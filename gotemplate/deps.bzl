load("@bazel_gazelle//:deps.bzl", "go_repository")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def gotemplate_dependencies():
    maybe(
        go_repository,
        name = "com_github_ghodss_yaml",
        commit = "c7ce16629ff4cd059ed96ed06419dd3856fd3577",
        importpath = "github.com/ghodss/yaml",
    )

    maybe(
        go_repository,
        name = "in_gopkg_yaml_v2",
        commit = "5420a8b6744d3b0345ab293f6fcba19c978f1183",
        importpath = "gopkg.in/yaml.v2",
    )
