RUN apt update
RUN apt upgrade -y
RUN apt update
RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
RUN apt-add-repository 'deb http://apt.llvm.org/disco/ llvm-toolchain-disco-8 main'

RUN apt install -y build-essential clang-8 clang++-8 lld-8 git python3 cmake ninja-build
