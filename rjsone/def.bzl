"""
Defines custom build rules that allow to use rjsone.
"""

_rjsone_binary_label = "@com_github_wryun_rjsone//:rjsone"
_runner_binary_label = "@com_github_atlassian_bazel_tools//rjsone:runner"

def _keyed_raw_values_to_args(keyed_raw_values):
    return [
        "%s::+%s" % (key, value)
        for key, value in keyed_raw_values.items()
    ]

def _keyed_yaml_values_to_args(keyed_yaml_values):
    return [
        "%s:+%s" % (key, value)
        for key, value in keyed_yaml_values.items()
    ]

def _rjsone_impl(ctx):
    common_args = ctx.actions.args()
    common_args.add([
        "-i",
        str(ctx.attr.indentation),
        "-t",
        ctx.file.template,
        "-d=" + str(ctx.attr.deep_merge).lower(),
        "-v=" + str(ctx.attr.verbose).lower(),
    ])
    common_args.add_all(ctx.files.contexts)

    inputs = [ctx.file.template] + ctx.files.contexts + ctx.files.keyed_contexts
    for context_target, context_key in ctx.attr.keyed_contexts.items():
        files = context_target.files.to_list()
        if len(files) == 0:
            fail("Target %s produces no files" % context_target.label)
        elif len(files) == 1:
            new_args = ["%s:%s" % (context_key, files[0].path)]
        else:
            new_args = ["%s:.." % context_key] + [f.path for f in files]

        common_args.add(new_args)

    common_args.add_all([ctx.attr.keyed_raw_values], map_each = _keyed_raw_values_to_args)
    common_args.add_all([ctx.attr.keyed_yaml_values], map_each = _keyed_yaml_values_to_args)

    json_args = ctx.actions.args()
    json_args.add([ctx.executable._rjsone, ctx.outputs.json])
    ctx.actions.run(
        outputs = [ctx.outputs.json],
        inputs = inputs,
        executable = ctx.executable._run,
        tools = [ctx.executable._rjsone],
        arguments = [json_args, common_args],
        mnemonic = "Rjsone",
        progress_message = "Rendering JSON into %s" % ctx.outputs.json.short_path,
    )

    yaml_args = ctx.actions.args()
    yaml_args.add([ctx.executable._rjsone, ctx.outputs.yaml, "-y"])
    ctx.actions.run(
        outputs = [ctx.outputs.yaml],
        inputs = inputs,
        executable = ctx.executable._run,
        tools = [ctx.executable._rjsone],
        arguments = [yaml_args, common_args],
        mnemonic = "Rjsone",
        progress_message = "Rendering YAML into %s" % ctx.outputs.json.short_path,
    )

rjsone = rule(
    implementation = _rjsone_impl,
    attrs = {
        "contexts": attr.label_list(
            allow_files = True,
        ),
        "indentation": attr.int(
            default = 2,
            doc = "Indentation level of JSON output; 0 means no pretty-printing",
        ),
        "keyed_contexts": attr.label_keyed_string_dict(
            allow_files = True,
        ),
        "keyed_raw_values": attr.string_dict(
            doc = "Key to value mappings, values are not interpreted and treated as raw strings",
        ),
        "keyed_yaml_values": attr.string_dict(
            doc = "Key to value mappings, values are interpreted as YAML/JSON",
        ),
        "template": attr.label(
            doc = "Template source",
            allow_single_file = True,
            mandatory = True,
        ),
        "verbose": attr.bool(
            doc = "Show information about processing on stderr",
        ),
        "deep_merge": attr.bool(
            doc = "Performs a deep merge of contexts",
        ),
        "_rjsone": attr.label(
            default = Label(_rjsone_binary_label),
            cfg = "host",
            executable = True,
        ),
        "_run": attr.label(
            default = Label(_runner_binary_label),
            cfg = "host",
            executable = True,
        ),
    },
    outputs = {
        "yaml": "%{name}.yaml",
        "json": "%{name}.json",
    },
)
