#!/usr/bin/python
# version 3
import pystache
from generate.helpers import install_prerequisites
from generate.helpers import read_template


class generate_gcc:
    def __init__(self, base, root):
        """
        Initialises the GCC generator

        base -- a Docker base image
        root -- path to a Docker image generator root
        """
        self.base = base
        self.root = root

    def generate(self, major, minor, revision=0):
        """
        Generates a Docker image that will build a particular version of GCC
        from source.

        major -- Specifies the major part of GCC's semver
        minor -- Specifies the minor part of GCC's semver
        revision -- Specifies the revision part of GCC's semver
        """
        template = read_template("toolchains", "build-gcc")
        substitutions = {
            "base": self.base,
            "gcc": f"gcc-{major}.{minor}.{revision}",
            "major": major,
            "minor": minor,
            "revision": revision,
            "install_prerequisites": install_prerequisites(self.root)
        }
        build_images = pystache.render(template, substitutions)
        return (build_images, f"gcc-{major}")
