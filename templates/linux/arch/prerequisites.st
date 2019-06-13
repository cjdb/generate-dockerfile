RUN pacman -Syyu --noconfirm
RUN pacman -S --noconfirm base-devel wget clang lld git cmake ninja python
