load("@bazel_skylib//:lib.bzl", "paths", "shell")
load("@io_bazel_rules_go//go:def.bzl", "GoSDK")

def _gometalinter_impl(ctx):
    args = []
    if ctx.attr.config:
        args.append("--config=" + ctx.file.config.short_path)
    else:
        args.append("--no-config")
    args.extend(ctx.attr.paths)
    out_file = ctx.actions.declare_file(ctx.label.name + ".bash")
    sdk = ctx.attr._go_sdk[GoSDK]
    substitutions = {
        "@@GOMETALINTER_SHORT_PATH@@": shell.quote(ctx.executable._gometalinter.short_path),
        "@@ARGS@@": shell.array_literal(args),
        "@@PREFIX_DIR_PATH@@": shell.quote(paths.dirname(ctx.attr.prefix)),
        "@@PREFIX_BASE_NAME@@": shell.quote(paths.basename(ctx.attr.prefix)),
        "@@NEW_GOROOT@@": shell.quote(sdk.root_file.dirname),
    }
    ctx.actions.expand_template(
        template = ctx.file._runner,
        output = out_file,
        substitutions = substitutions,
        is_executable = True,
    )
    transitive_depsets = [
        depset(sdk.srcs),
        depset(sdk.tools),
    ]
    default_runfiles = ctx.attr._gometalinter[DefaultInfo].default_runfiles
    if default_runfiles != None:
        transitive_depsets.append(default_runfiles.files)

    runfiles = ctx.runfiles(
        transitive_files = depset(transitive = transitive_depsets),
    )
    return [DefaultInfo(
        files = depset([out_file]),
        runfiles = runfiles,
        executable = out_file,
    )]

_gometalinter = rule(
    implementation = _gometalinter_impl,
    attrs = {
        "config": attr.label(
            allow_single_file = True,
            doc = "Configuration file to use",
        ),
        "paths": attr.string_list(
            doc = "Directories to lint. <path>/... will recurse",
            default = ["./..."],
        ),
        "prefix": attr.string(
            mandatory = True,
            doc = "Go import path of this project i.e. where in GOPATH you would put it. E.g. github.com/atlassian/bazel-tools",
        ),
        "_gometalinter": attr.label(
            default = "@com_github_atlassian_bazel_tools_gometalinter//:linter",
            cfg = "host",
            executable = True,
        ),
        "_runner": attr.label(
            default = "@com_github_atlassian_bazel_tools//gometalinter:runner.bash.template",
            allow_single_file = True,
        ),
        "_go_sdk": attr.label(
            providers = [GoSDK],
            default = "@go_sdk//:go_sdk",
        ),
    },
    executable = True,
)

def gometalinter(**kwargs):
    tags = kwargs.get("tags", [])
    if "manual" not in tags:
        tags.append("manual")
        kwargs["tags"] = tags
    _gometalinter(
        **kwargs
    )
