load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def buildozer_dependencies():
    _maybe(
        http_archive,
        name = "bazel_skylib",
        sha256 = "b5f6abe419da897b7901f90cbab08af958b97a8f3575b0d3dd062ac7ce78541f",
        strip_prefix = "bazel-skylib-0.5.0",
        urls = ["https://github.com/bazelbuild/bazel-skylib/archive/0.5.0.tar.gz"],
    )

    # used for build.proto for buildozer :tableflip: https://github.com/bazelbuild/buildtools/issues/143
    _maybe(
        http_archive,
        name = "io_bazel",
        sha256 = "66135f877d0cc075b683474c50b1f7c3e2749bf0a40e446f20392f44494fefff",
        strip_prefix = "bazel-0.12.0",
        urls = [
            "http://mirror.bazel.build/github.com/bazelbuild/bazel/archive/0.12.0.tar.gz",
            "https://github.com/bazelbuild/bazel/archive/0.12.0.tar.gz",
        ],
    )

    _maybe(
        http_archive,
        name = "com_github_bazelbuild_buildtools",
        sha256 = "681130514b50ee640cd5eee9cbd192fd48072b4bc9abc6a17a1fba7a2817ec0e",
        strip_prefix = "buildtools-5a4c4ca9753ad0f8f9eb3463d84bc89388846420",
        urls = ["https://github.com/bazelbuild/buildtools/archive/5a4c4ca9753ad0f8f9eb3463d84bc89388846420.tar.gz"],
    )

def _maybe(repo_rule, name, **kwargs):
    if name not in native.existing_rules():
        repo_rule(name = name, **kwargs)
