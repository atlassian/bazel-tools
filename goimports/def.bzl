load("@bazel_skylib//:lib.bzl", "paths", "shell")

def _goimports_impl(ctx):
    # That way we don't depend on defaults encoded in the binary but always
    # use defaults set on attributes of the rule
    args = [
        "-d=" + str(ctx.attr.display_diffs).lower(),
        "-e=" + str(ctx.attr.report_all_errors).lower(),
        "-l=" + str(ctx.attr.list).lower(),
        "-local=" + shell.quote(",".join(ctx.attr.local)),
        "-v=" + str(ctx.attr.verbose).lower(),
        "-w=" + str(ctx.attr.write).lower(),
    ]

    exclude_paths_str = ""
    if ctx.attr.exclude_paths:
        exclude_paths = ["-not -path %s" % shell.quote(path) for path in ctx.attr.exclude_paths]
        exclude_paths_str = " ".join(exclude_paths)

    exclude_files_str = ""
    if ctx.attr.exclude_files:
        exclude_files = ["-not -name %s" % shell.quote(file) for file in ctx.attr.exclude_files]
        exclude_files_str = " ".join(exclude_files)

    out_file = ctx.actions.declare_file(ctx.label.name + ".bash")
    substitutions = {
        "@@PREFIX_DIR_PATH@@": shell.quote(paths.dirname(ctx.attr.prefix)),
        "@@PREFIX_BASE_NAME@@": shell.quote(paths.basename(ctx.attr.prefix)),
        "@@ARGS@@": shell.array_literal(args),
        "@@GOIMPORTS_SHORT_PATH@@": shell.quote(ctx.executable._goimports.short_path),
        "@@EXCLUDE_PATHS@@": exclude_paths_str,
        "@@EXCLUDE_FILES@@": exclude_files_str,
    }
    ctx.actions.expand_template(
        template = ctx.file._runner,
        output = out_file,
        substitutions = substitutions,
        is_executable = True,
    )
    runfiles = ctx.runfiles(files = [ctx.executable._goimports])
    return [DefaultInfo(
        files = depset([out_file]),
        runfiles = runfiles,
        executable = out_file,
    )]

goimports = rule(
    implementation = _goimports_impl,
    attrs = {
        "prefix": attr.string(
            mandatory = True,
            doc = "Go import path of this project i.e. where in GOPATH you would put it. E.g. github.com/atlassian/bazel-tools",
        ),
        "exclude_paths": attr.string_list(
            allow_empty = True,
            default = ["./vendor/*"],
            doc = "A list of glob patterns passed to the find command to exclude matching paths. E.g. './vendor/*' to exclude the Go vendor directory",
        ),
        "exclude_files": attr.string_list(
            allow_empty = True,
            doc = "A list of glob patterns passed to the find command to exclude matching files",
        ),
        "display_diffs": attr.bool(
            doc = "Display diffs instead of rewriting files",
        ),
        "report_all_errors": attr.bool(
            doc = "Report all errors (not just the first 10 on different lines)",
        ),
        "list": attr.bool(
            doc = "List files whose formatting differs from goimport's",
        ),
        "local": attr.string_list(
            doc = "Put imports beginning with this string after 3rd-party packages",
        ),
        "verbose": attr.bool(
            doc = "Verbose logging",
        ),
        "write": attr.bool(
            doc = "Write result to source file instead of stdout",
        ),
        "_goimports": attr.label(
            default = Label("@org_golang_x_tools//cmd/goimports"),
            cfg = "host",
            allow_single_file = True,
            executable = True,
        ),
        "_runner": attr.label(
            default = Label("@com_github_atlassian_bazel_tools//goimports:runner.bash.template"),
            allow_single_file = True,
        ),
    },
    executable = True,
)
