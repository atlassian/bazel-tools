load("@bazel_skylib//:lib.bzl", "shell")

_CONTENT_PREFIX = """#!/usr/bin/env bash

set -euo pipefail

"""

def _multirun_impl(ctx):
    transitive_depsets = []
    content = [_CONTENT_PREFIX]

    for command in ctx.attr.commands:
        info = command[DefaultInfo]
        if info.files_to_run == None:
            fail("%s is not executable" % command.label, attr = "commands")
        exe = info.files_to_run.executable
        if exe == None:
            fail("%s does not have an executable file" % command.label, attr = "commands")

        default_runfiles = info.default_runfiles
        if default_runfiles != None:
            transitive_depsets.append(default_runfiles.files)
        content.append("echo Running %s\n./%s $@\n" % (shell.quote(str(command.label)), shell.quote(exe.short_path)))

    out_file = ctx.actions.declare_file(ctx.label.name + ".bash")
    ctx.actions.write(
        output = out_file,
        content = "".join(content),
        is_executable = True,
    )
    runfiles = ctx.runfiles(
        transitive_files = depset([], transitive = transitive_depsets),
    )
    return [DefaultInfo(
        files = depset([out_file]),
        runfiles = runfiles,
        executable = out_file,
    )]

_multirun = rule(
    implementation = _multirun_impl,
    attrs = {
        "commands": attr.label_list(
            allow_empty = True,  # this is explicitly allowed - generated invocations may need to run 0 targets
            mandatory = True,
            allow_files = True,
            doc = "Targets to run in specified order",
            cfg = "host",
        ),
    },
    executable = True,
)

def multirun(**kwargs):
    tags = kwargs.get("tags", [])
    if "manual" not in tags:
        tags.append("manual")
        kwargs["tags"] = tags
    _multirun(
        **kwargs
    )
