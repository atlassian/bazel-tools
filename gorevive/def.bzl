load("@bazel_skylib//lib:shell.bzl", "shell")

def _go_revive_impl(ctx):
    substitutions = {
        "@@CONFIG@@": shell.quote(ctx.file.config.path),
        "@@PATHS@@": " ".join([shell.quote(p) for p in ctx.attr.paths]),
        "@@EXCLUDE@@": " ".join(["-exclude %s" % shell.quote(p) for p in ctx.attr.exclude]),
        "@@FORMATTER@@": shell.quote(ctx.attr.formatter),
        "@@REVIVE@@": shell.quote(ctx.executable._revive_executable.short_path),
        "@@DEBUG@@": "1" if ctx.attr.debug else "0",
    }
    out_file = ctx.actions.declare_file(ctx.label.name + ".bash")
    ctx.actions.expand_template(
        template = ctx.file._template,
        output = out_file,
        substitutions = substitutions,
        is_executable = True,
    )

    runfiles = ctx.runfiles(
        files = ctx.files.srcs + [ctx.executable._revive_executable, ctx.file.config],
        collect_default = True,
    )

    return [DefaultInfo(
        files = depset([out_file]),
        runfiles = runfiles,
        executable = out_file,
    )]

go_revive_test = rule(
    implementation = _go_revive_impl,
    attrs = {
        "srcs": attr.label_list(
            allow_files = True,
            doc = "Go source files to be linted.",
        ),
        "config": attr.label(
            mandatory = True,
            allow_single_file = True,
            doc = "Config file in TOML format.",
        ),
        "paths": attr.string_list(
            allow_empty = False,
            default = ["./..."],
            doc = "Paths in srcs to be linted.",
        ),
        "exclude": attr.string_list(
            allow_empty = True,
            default = [],
            doc = "Pattern for files/directories/packages to be excluded for linting.",
        ),
        "formatter": attr.string(
            default = "default",
            doc = "Formatter to be used for the output.",
        ),
        "debug": attr.bool(
            default = False,
            doc = "Enable bash debug output.",
        ),
        "_template": attr.label(
            default = "//gorevive:runner.bash.template",
            allow_single_file = True,
        ),
        "_revive_executable": attr.label(
            default = "@com_github_mgechev_revive//:revive",
            executable = True,
            cfg = "host",
        ),
    },
    test = True,
)
