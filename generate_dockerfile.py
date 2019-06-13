#!/usr/bin/python
# version 3
import pystache
import re
from generate.gcc import generate_gcc
from generate.llvm import generate_llvm
import generate.helpers as generate_helpers


class generate_dockerfile:
    def __init__(self, base, root):
        self.base = base
        self.root = root

        self.gcc = generate_gcc(base, root)
        self.llvm = generate_llvm(base, root)

        self.build_images = []
        self.image_names = []
        self.commands = self.__update_package_manager__()

    def __generate_impl__(self, result):
        (build_image, copy_directive) = result
        self.build_images.append(build_image)
        self.image_names.append(copy_directive)

    def __copy_toolchains__(self):
        copies = "".join(f"COPY --from={i} /usr/local /opt/{i}\n"
                         for i in self.image_names)

        path = "/opt/" + "/opt/".join(f"{i}/bin:" for i in self.image_names)
        environment = f'ENV PATH="{path}${{PATH}}"'

        which = "RUN which " + " && which ".join(i for i in self.image_names)
        which = re.sub("llvm-", "clang-", which)
        return f"{copies}\n{environment}\n{which}"

    def __generate_toolchains__(self):
        return "\n".join(i for i in self.build_images)

    def __run_commands__(self):
        return self.commands

    def __update_package_manager__(self):
        return generate_helpers.read_template(self.root, "update")

    def generate_gcc(self, major, minor):
        self.__generate_impl__(self.gcc.generate(major, minor))

    def generate_llvm(self, branch, suffix, lldb=False, libcxx=True, polly=True):
        self.__generate_impl__(self.llvm.generate(branch, suffix, lldb, libcxx, polly))

    def generate_binutils(self):
        self.__generate_impl__(("todo", "todo"))

    def install_package(self, package):
        template = generate_helpers.read_template(self.root, "install-package")
        substitutions = {"package": package}
        self.commands += pystache.render(template, substitutions)

    def run_command(self, command):
        self.commands += f"RUN {command}\n"

    def generate(self):
        substitutions = {
            "base": self.base,
            "install_packages": self.__run_commands__(),
            "copy_toolchains": self.__copy_toolchains__(),
            "generate_toolchains": self.__generate_toolchains__()
        }

        with open("templates/final-container.st") as f:
            template = f.read()
        result = pystache.render(template, substitutions)
        result = re.sub("&quot;", '"', result)
        result = re.sub("&#x27;", "'", result)
        result = re.sub("&amp;", '&', result)
        return result
