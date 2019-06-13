#!/usr/bin/python
# version 3
from generate_dockerfile import generate_dockerfile


def main():
    arch_linux = generate_dockerfile(base="archlinux/base", root="linux/arch")
    arch_linux.generate_gcc(major=8, minor=3)
    arch_linux.generate_gcc(major=9, minor=1)
    arch_linux.generate_llvm(branch="release/8.x", suffix="-8")

    arch_linux.install_package("git vim python python-pip cmake ninja")
    arch_linux.run_command("python -m pip install pip --upgrade")
    arch_linux.run_command("python -m pip install conan")

    print(arch_linux.generate())

if __name__ == "__main__":
    main()
