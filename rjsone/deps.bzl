load("@bazel_gazelle//:deps.bzl", "go_repository")

def rjsone_dependencies():
    _maybe(
        go_repository,
        name = "com_github_wryun_rjsone",
        commit = "4df6a4459adadb3b98dee85e5431162a8d849bf8",
        importpath = "github.com/wryun/rjsone",
    )

    _maybe(
        go_repository,
        name = "com_github_taskcluster_json_e",
        commit = "5f1fefda8b07ed0016c98f77cd4640ec8a920201",
        importpath = "github.com/taskcluster/json-e",
    )

    _maybe(
        go_repository,
        name = "com_github_wryun_yaml_1",
        commit = "e5213689ab3ec721209263e51f9edf8615d93085",
        importpath = "github.com/wryun/yaml-1",
    )

    _maybe(
        go_repository,
        name = "com_github_imdario_mergo",
        commit = "9316a62528ac99aaecb4e47eadd6dc8aa6533d58",
        importpath = "github.com/imdario/mergo",
    )

    _maybe(
        go_repository,
        name = "in_gopkg_yaml_v2",
        commit = "5420a8b6744d3b0345ab293f6fcba19c978f1183",
        importpath = "gopkg.in/yaml.v2",
    )

def _maybe(repo_rule, name, **kwargs):
    if name not in native.existing_rules():
        repo_rule(name = name, **kwargs)
