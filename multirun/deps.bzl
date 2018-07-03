load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def multirun_dependencies():
    _maybe(
        http_archive,
        name = "bazel_skylib",
        sha256 = "b5f6abe419da897b7901f90cbab08af958b97a8f3575b0d3dd062ac7ce78541f",
        strip_prefix = "bazel-skylib-0.5.0",
        urls = ["https://github.com/bazelbuild/bazel-skylib/archive/0.5.0.tar.gz"],
    )

def _maybe(repo_rule, name, **kwargs):
    if name not in native.existing_rules():
        repo_rule(name = name, **kwargs)
