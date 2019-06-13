####################################################################################################
#
# Build GCC {{major}}.{{minor}}.{{revision}} from source
#
####################################################################################################
FROM {{base}} as gcc-{{major}}

# Install GCC system prerequistes
{{install_prerequisites}}

RUN which gcc && \
    which g++ && \
    which wget && \
    which lld  && \
    which ld.lld && \
    which make

# Download and extract GCC source
WORKDIR /tmp
RUN wget -q https://ftp.gnu.org/gnu/gcc/{{gcc}}/{{gcc}}.tar.gz && \
    tar -xzf {{gcc}}.tar.gz                                      && \
    rm -rf {{gcc}}.tar.gz

# Download GCC prerequisites
WORKDIR /tmp/{{gcc}}
RUN contrib/download_prerequisites

# Configure GCC
WORKDIR /tmp/{{gcc}}-build
ENV CFLAGS='-Os -DNDEBUG -Wno-error' CXXFLAGS='-Os -DNDEBUG -Wno-error'
ENV LDFLAGS='-Os'
RUN ../{{gcc}}/configure         \
    --prefix=/usr/local          \
    --program-suffix=-{{major}}  \
    --disable-checking           \
    --disable-bootstrap          \
    --disable-libada             \
    --disable-multilib           \
    --disable-nls                \
    --disable-symvers            \
    --enable-__cxa_atexit        \
    --enable-languages=c,c++     \
    --enable-shared              \
    --enable-threads             \
    --enable-tls                 \
    --with-linker-hash-style=gnu \
    --with-ld=/usr/bin/ld.lld

# Build GCC
RUN make --silent -j $(nproc)

# Install GCC
RUN make --silent -j $(nproc) install-strip

# Check GCC was installed
RUN gcc-{{major}} -v
