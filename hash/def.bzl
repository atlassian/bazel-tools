"""
Defines custom build rules that allow to hash files.
"""

def _hash_impl(ctx):
    out_file = ctx.actions.declare_file(ctx.label.name)
    args = ctx.actions.args()
    args.add_all([
        "-a",
        ctx.attr.algorithm,
        "-o",
        out_file,
        "-h=" + str(ctx.attr.hex).lower(),
    ])
    args.add_all(ctx.files.files)

    ctx.actions.run(
        outputs = [out_file],
        inputs = ctx.files.files,
        executable = ctx.executable._hasher,
        arguments = [args],
        mnemonic = "Hash",
        progress_message = "Hashing files",
    )
    return DefaultInfo(
        files = depset([out_file]),
    )

hash = rule(
    implementation = _hash_impl,
    attrs = {
        "files": attr.label_list(
            doc = "Files to hash",
            allow_files = True,
        ),
        "algorithm": attr.string(
            doc = "Hashing algorithm to use",
            default = "sha256",
            values = ["md5", "sha1", "sha256", "sha512"],
        ),
        "hex": attr.bool(
            doc = "Output base-16 encoded bytes",
            default = True,
        ),
        "_hasher": attr.label(
            default = "@com_github_atlassian_bazel_tools//hash",
            cfg = "host",
            executable = True,
        ),
    },
)
