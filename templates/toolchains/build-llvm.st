####################################################################################################
#
# Build LLVM {{branch}} from source
#
####################################################################################################
FROM {{base}} as llvm{{suffix}}

# Install LLVM system prerequistes
{{install_prerequisites}}

RUN which clang   && \
    which clang++ && \
    which lld     && \
    which ld.lld  && \
    which git     && \
    which cmake   && \
    which ninja   && \
    which python

WORKDIR /tmp
RUN git clone https://github.com/llvm/llvm-project.git

WORKDIR /tmp/llvm-project
RUN git checkout {{branch}}

WORKDIR /tmp/llvm-build
RUN cmake ../llvm-project/llvm -GNinja                                      \
	-DCMAKE_C_COMPILER=/usr/bin/clang                                       \
	-DCMAKE_CXX_COMPILER=/usr/bin/clang++                                   \
	-DCMAKE_BUILD_TYPE=Release                                              \
	-DCMAKE_INSTALL_PREFIX=/usr/local                                       \
	-DCMAKE_EXECUTABLE_SUFFIX={{suffix}}                                    \
	                                                                        \
	-DLLVM_TARGETS_TO_BUILD="X86"                                           \
	-DLLVM_BUILD_TOOLS=On                                                   \
	-DLLVM_INCLUDE_EXAMPLES=Off                                             \
	-DLLVM_BUILD_TESTS=On                                                   \
	-DLLVM_INCLUDE_BENCHMARKS=Off                                           \
	-DLLVM_CXX_STD="c++2a"                                                  \
	-DLLVM_ENABLE_WARNINGS=Off                                              \
	-DLLVM_ENABLE_PROJECTS="clang;compiler-rt;lld;{{polly}};{{libcxx}}{{lldb}}" \
	-DLLVM_ENABLE_LTO=Thin                                                  \
	-DLLVM_ENABLE_LLD=On

RUN ninja
RUN ninja install-strip

# Check clang was installed correctly
RUN /usr/local/bin/clang{{suffix}}
