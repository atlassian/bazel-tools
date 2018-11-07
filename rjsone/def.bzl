"""
Defines custom build rules that allow to use rjsone.
"""

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

def _keyed_yaml_contexts_to_args(keyed_yaml_contexts):
    args = []
    for context_target, context_key in keyed_yaml_contexts.items():
        files = context_target.files.to_list()
        if len(files) == 0:
            fail("Target %s produces no files" % context_target.label, attr = "keyed_yaml_contexts")
        elif len(files) == 1:
            args.append("%s:%s" % (context_key, files[0].path))
        else:
            args.append("%s:.." % context_key)
            args.extend([f.path for f in files])

    return args

def _keyed_raw_contexts_to_args(keyed_raw_contexts):
    args = []
    for context_target, context_key in keyed_raw_contexts.items():
        files = context_target.files.to_list()
        if len(files) == 0:
            fail("Target %s produces no files" % context_target.label, attr = "keyed_raw_contexts")
        elif len(files) == 1:
            args.append("%s::%s" % (context_key, files[0].path))
        else:
            args.append("%s::.." % context_key)
            args.extend([f.path for f in files])

    return args

def _rjsone_impl(ctx):
    common_args = ctx.actions.args()
    common_args.add_all([
        "-i",
        str(ctx.attr.indentation),
        "-t",
        ctx.file.template,
        "-d=" + str(ctx.attr.deep_merge).lower(),
        "-v=" + str(ctx.attr.verbose).lower(),
    ])
    common_args.add_all(ctx.files.contexts)
    common_args.add_all([ctx.attr.keyed_yaml_contexts], map_each = _keyed_yaml_contexts_to_args)
    common_args.add_all([ctx.attr.keyed_raw_contexts], map_each = _keyed_raw_contexts_to_args)
    common_args.add_all([ctx.attr.keyed_raw_values], map_each = _keyed_raw_values_to_args)
    common_args.add_all([ctx.attr.keyed_yaml_values], map_each = _keyed_yaml_values_to_args)

    inputs = [ctx.file.template] + ctx.files.deps + ctx.files.contexts + ctx.files.keyed_yaml_contexts + ctx.files.keyed_raw_contexts

    if ctx.attr.stamp:
        inputs.extend([ctx.info_file, ctx.version_file])
        common_args.add_all([":kv:" + ctx.info_file.path, ":kv:" + ctx.version_file.path])

    json_args = ctx.actions.args()
    json_args.add_all(["-o", ctx.outputs.json])
    ctx.actions.run(
        outputs = [ctx.outputs.json],
        inputs = inputs,
        executable = ctx.executable._rjsone,
        arguments = [json_args, common_args],
        mnemonic = "Rjsone",
        progress_message = "Rendering JSON into %s" % ctx.outputs.json.short_path,
    )

    yaml_args = ctx.actions.args()
    yaml_args.add_all(["-o", ctx.outputs.yaml, "-y"])
    ctx.actions.run(
        outputs = [ctx.outputs.yaml],
        inputs = inputs,
        executable = ctx.executable._rjsone,
        arguments = [yaml_args, common_args],
        mnemonic = "Rjsone",
        progress_message = "Rendering YAML into %s" % ctx.outputs.yaml.short_path,
    )

rjsone = rule(
    implementation = _rjsone_impl,
    attrs = {
        "contexts": attr.label_list(
            allow_files = True,
        ),
        # if volatile variable changes, e.g. BUILD_TIMESTAMP, this normally doesn't cause rule to rebuild, declaring a dependency will force the rebuild if the
        # dependency changes
        "deps": attr.label_list(
            allow_files = True,
        ),
        "indentation": attr.int(
            default = 2,
            doc = "Indentation level of JSON output; 0 means no pretty-printing",
        ),
        "keyed_raw_contexts": attr.label_keyed_string_dict(
            doc = "File to key mappings, files are not interpreted and treated as raw strings",
            allow_files = True,
        ),
        "keyed_yaml_contexts": attr.label_keyed_string_dict(
            doc = "File to key mappings, files are interpreted as YAML/JSON",
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
        "stamp": attr.bool(
            doc = "Enable stamping. Workspace status variables become available as plain strings",
        ),
        "_rjsone": attr.label(
            default = "@com_github_wryun_rjsone//:rjsone",
            cfg = "host",
            executable = True,
        ),
    },
    outputs = {
        "yaml": "%{name}.yaml",
        "json": "%{name}.json",
    },
)
