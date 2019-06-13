{{generate_toolchains}}

####################################################################################################
#
# This is the user container
#
####################################################################################################
FROM {{base}}

# Install packages
{{install_packages}}

# Copy builds
{{copy_toolchains}}

# Conan handling
RUN mkdir -p /root/.conan/profiles && \
    echo '[settings]\n\
os=Linux\n\
os_build=Linux\n\
arch=x86_64\n\
arch_build=x86_64\n\
compiler=gcc\n\
compiler.version=9\n\
compiler.libcxx=libstdc++11\n\
build_type=Release\n\
[options]\n\
[build_requires]\n\
[env]\n\
CONAN_CMAKE_GENERATOR=Ninja' > /root/.conan/profiles/default
