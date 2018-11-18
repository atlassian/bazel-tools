"""
Defines custom build rules that allow to use Go text/template package.
"""

def _context_to_args(context):
    args = []
    for context_target, context_key in context.items():
        if context_key.find(":") != -1:
            fail("Context key %s must not contain `:`" % context_key, attr = "contexts")
        files = context_target.files.to_list()
        if len(files) == 0:
            fail("Target %s produces no files" % context_target.label, attr = "contexts")
        elif len(files) == 1:
            args.append("%s:%s" % (context_key, files[0].path))
        else:
            fail("Target %s produces more than one file: %d" % (context_target.label, len(files)), attr = "contexts")

    return args

def _gotemplate_impl(ctx):
    out_file = ctx.actions.declare_file(ctx.label.name)
    args = ctx.actions.args()
    args.add_all([
        "-e=false",
        "-t",
        ctx.file.template,
        "-o",
        out_file,
    ])
    args.add_all([ctx.attr.yaml_contexts], map_each = _context_to_args)

    ctx.actions.run(
        outputs = [out_file],
        inputs = [ctx.file.template] + ctx.files.yaml_contexts,
        executable = ctx.executable._gotemplate,
        arguments = [args],
        mnemonic = "GoTemplate",
        progress_message = "Assembling %s" % out_file.short_path,
    )
    return DefaultInfo(
        files = depset([out_file]),
    )

def _gotemplate_exec_impl(ctx):
    out_file = ctx.actions.declare_file(ctx.label.name)
    args = ctx.actions.args()
    args.add_all([
        "-e=true",
        "-t",
        ctx.file.template,
        "-o",
        out_file,
    ])
    args.add_all([ctx.attr.yaml_contexts], map_each = _context_to_args)

    ctx.actions.run(
        outputs = [out_file],
        inputs = [ctx.file.template] + ctx.files.yaml_contexts,
        executable = ctx.executable._gotemplate,
        arguments = [args],
        mnemonic = "GoTemplate",
        progress_message = "Assembling %s" % out_file.short_path,
    )
    return DefaultInfo(
        files = depset([out_file]),
        executable = out_file,
    )

_attributes = {
    "yaml_contexts": attr.label_keyed_string_dict(
        doc = "Named contexts. File content is parsed as YAML/JSON and is available under specified name in the template",
        allow_files = True,
    ),
    "template": attr.label(
        doc = "Template source",
        allow_single_file = True,
        mandatory = True,
    ),
    "_gotemplate": attr.label(
        default = "@com_github_atlassian_bazel_tools//gotemplate",
        cfg = "host",
        executable = True,
    ),
}

gotemplate = rule(
    doc = "Allow to use Go text/template package",
    implementation = _gotemplate_impl,
    attrs = _attributes,
)

gotemplate_exec = rule(
    doc = "Allow to use Go text/template package to produce an executable file",
    implementation = _gotemplate_exec_impl,
    executable = True,
    attrs = _attributes,
)
