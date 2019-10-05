load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def buildozer_dependencies():
    _maybe(
        http_archive,
        name = "bazel_skylib",
        sha256 = "2ef429f5d7ce7111263289644d233707dba35e39696377ebab8b0bc701f7818e",
        strip_prefix = "bazel-skylib-0.8.0",
        urls = ["https://github.com/bazelbuild/bazel-skylib/archive/0.8.0.tar.gz"],
    )

    _maybe(
        http_archive,
        name = "com_github_bazelbuild_buildtools",
        sha256 = "f3ef44916e6be705ae862c0520bac6834dd2ff1d4ac7e5abc61fe9f12ce7a865",
        strip_prefix = "buildtools-0.29.0",
        urls = ["https://github.com/bazelbuild/buildtools/archive/0.29.0.tar.gz"],
    )

def _maybe(repo_rule, name, **kwargs):
    if name not in native.existing_rules():
        repo_rule(name = name, **kwargs)
