#!/usr/bin/python
# version 3
import pystache
from generate.helpers import install_prerequisites
from generate.helpers import read_template


class generate_llvm:
    def __init__(self, base, root):
        """
        Initialises the LLVM generator.

        base -- a Docker base image
        root -- path to a Docker image generator root
        """
        self.base = base
        self.root = root

    def generate(self, branch, suffix, lldb=False, libcxx=True, polly=True):
        """
         Generates a Docker image that will build a particular version of LLVM
         from source.

         branch -- a branch of LLVM to checkout
         suffix -- a suffix added to all LLVM binaries
         lldb -- indicates if LLDB is to be built
         libcxx -- indicates if libc++ and libc++abi are to be built
         """
        template = read_template("toolchains", "build-llvm")
        substitutions = {
            "base": self.base,
            "suffix": suffix,
            "branch": branch,
            "libcxx": "libcxx;libcxxabi" if libcxx else "",
            "lldb": "lldb" if lldb else "",
            "polly": "polly" if polly else "",
            "install_prerequisites": install_prerequisites(self.root)
        }

        image = pystache.render(template, substitutions)
        return (image, f"llvm{suffix}")
