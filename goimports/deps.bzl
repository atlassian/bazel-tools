load("@bazel_gazelle//:deps.bzl", "go_repository")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def goimports_dependencies():
    _maybe(
        go_repository,
        name = "org_golang_x_tools",
        importpath = "golang.org/x/tools",
        sha256 = "11629171a39a1cb4d426760005be6f7cb9b4182e4cb2756b7f1c5c2b6ae869fe",
        strip_prefix = "tools-bf090417da8b6150dcfe96795325f5aa78fff718",
        urls = ["https://github.com/golang/tools/archive/bf090417da8b6150dcfe96795325f5aa78fff718.tar.gz"],
    )

    _maybe(
        http_archive,
        name = "bazel_skylib",
        sha256 = "2c62d8cd4ab1e65c08647eb4afe38f51591f43f7f0885e7769832fa137633dcb",
        strip_prefix = "bazel-skylib-0.7.0",
        urls = ["https://github.com/bazelbuild/bazel-skylib/archive/0.7.0.tar.gz"],
    )

def _maybe(repo_rule, name, **kwargs):
    if name not in native.existing_rules():
        repo_rule(name = name, **kwargs)
