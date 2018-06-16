load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_gazelle//:deps.bzl", "go_repository")

def goimports_dependencies():
    _maybe(
        go_repository,
        name = "org_golang_x_tools",
        importpath = "golang.org/x/tools",
        sha256 = "f2df5546c28299c2dd6e980cd3ff9ae6b7e02086e2839550c4cb78444aeccfdb",
        strip_prefix = "tools-059bec968c61383b574810040ba9410712de36c5",
        urls = ["https://github.com/golang/tools/archive/059bec968c61383b574810040ba9410712de36c5"],
        type = "tar.gz",
    )

    _maybe(
        http_archive,
        name = "bazel_skylib",
        strip_prefix = "bazel-skylib-0.4.0",
        sha256 = "57e8737fbfa2eaee76b86dd8c1184251720c840cd9abe5c3f1566d331cdf7d65",
        urls = ["https://github.com/bazelbuild/bazel-skylib/archive/0.4.0.tar.gz"],
    )

def _maybe(repo_rule, name, **kwargs):
    if name not in native.existing_rules():
        repo_rule(name = name, **kwargs)
