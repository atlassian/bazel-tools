workspace(name = "com_github_atlassian_bazel_tools")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "io_bazel_rules_go",
    sha256 = "12b89992cd76a864cd1d862077e475149898e69fad18c843cb3c90328c8879f7",
    strip_prefix = "rules_go-d023cdf5d7ba59e8ba61a214ff8277556ab5066f",
    urls = ["https://github.com/bazelbuild/rules_go/archive/d023cdf5d7ba59e8ba61a214ff8277556ab5066f.tar.gz"],
)

http_archive(
    name = "bazel_gazelle",
    sha256 = "7949fc6cc17b5b191103e97481cf8889217263acf52e00b560683413af204fcb",
    urls = ["https://github.com/bazelbuild/bazel-gazelle/releases/download/0.16.0/bazel-gazelle-0.16.0.tar.gz"],
)

http_archive(
    name = "com_github_bazelbuild_buildtools",
    sha256 = "896f18860254d9a165ad65550666806cbf58dbb0fb71b1821df132c20db42b44",
    strip_prefix = "buildtools-aa1408f15df9f4c9e713dd5949fedfb04865199a",
    urls = ["https://github.com/bazelbuild/buildtools/archive/aa1408f15df9f4c9e713dd5949fedfb04865199a.tar.gz"],
)

load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains", "go_rules_dependencies")

go_rules_dependencies()

go_register_toolchains()

load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies")
load("@com_github_bazelbuild_buildtools//buildifier:deps.bzl", "buildifier_dependencies")

gazelle_dependencies()

buildifier_dependencies()

load("//gotemplate:deps.bzl", "gotemplate_dependencies")

gotemplate_dependencies()
