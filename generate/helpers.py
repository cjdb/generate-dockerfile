#!/usr/bin/python
# version 3
import pystache
import re


def read_template(path, filename):
    with open(f"templates/{path}/{filename}.st") as f:
        return f.read()


def install_prerequisites(base):
    """
    Generates the install script for a dependency generator.
    For internal use only.

    base -- a Docker base image
    """
    return read_template(base, "prerequisites")
