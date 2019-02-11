load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def buildozer_dependencies():
    _maybe(
        http_archive,
        name = "bazel_skylib",
        sha256 = "2c62d8cd4ab1e65c08647eb4afe38f51591f43f7f0885e7769832fa137633dcb",
        strip_prefix = "bazel-skylib-0.7.0",
        urls = ["https://github.com/bazelbuild/bazel-skylib/archive/0.7.0.tar.gz"],
    )

    # used for build.proto for buildozer :tableflip: https://github.com/bazelbuild/buildtools/issues/143
    _maybe(
        http_archive,
        name = "io_bazel",
        sha256 = "6ccb831e683179e0cfb351cb11ea297b4db48f9eab987601c038aa0f83037db4",
        urls = [
            "https://releases.bazel.build/0.21.0/release/bazel-0.21.0-dist.zip",
            "https://github.com/bazelbuild/bazel/releases/download/0.21.0/bazel-0.21.0-dist.zip",
        ],
    )

    _maybe(
        http_archive,
        name = "com_github_bazelbuild_buildtools",
        sha256 = "896f18860254d9a165ad65550666806cbf58dbb0fb71b1821df132c20db42b44",
        strip_prefix = "buildtools-aa1408f15df9f4c9e713dd5949fedfb04865199a",
        urls = ["https://github.com/bazelbuild/buildtools/archive/aa1408f15df9f4c9e713dd5949fedfb04865199a.tar.gz"],
    )

def _maybe(repo_rule, name, **kwargs):
    if name not in native.existing_rules():
        repo_rule(name = name, **kwargs)
