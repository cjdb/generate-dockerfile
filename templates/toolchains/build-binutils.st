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

# Download and extract Binutils source
WORKDIR /tmp
RUN wget -q https://ftp.gnu.org/gnu/binutils/{{binutils}}/{{binutils}}.tar.gz && \
    tar -xzf {{binutils}}.tar.gz                                                && \
    rm -rf {{binutils}}.tar.gz

WORKDIR /tmp/{{binutils}}
ENV CFLAGS='-Os -DNDEBUG -Wno-error' CXXFLAGS='-Os -DNDEBUG -Wno-error'
ENV LDFLAGS='-Os'
RUN ../{{binutils}}/configure    \
    --prefix=/usr/local          \
    --program-suffix={{suffix}}  \
    --disable-nls                \
    --disable-werror

# Build GCC
RUN make --silent -j $(nproc)

# Install GCC
RUN make --silent -j $(nproc) install-strip
