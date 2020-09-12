workspace(name = "com_github_atlassian_bazel_tools")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

http_archive(
    name = "io_bazel_rules_go",
    sha256 = "08c3cd71857d58af3cda759112437d9e63339ac9c6e0042add43f4d94caf632d",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/download/v0.24.2/rules_go-v0.24.2.tar.gz",
        "https://github.com/bazelbuild/rules_go/releases/download/v0.24.2/rules_go-v0.24.2.tar.gz",
    ],
)

http_archive(
    name = "bazel_gazelle",
    sha256 = "d4113967ab451dd4d2d767c3ca5f927fec4b30f3b2c6f8135a2033b9c05a5687",
    urls = [
        "https://storage.googleapis.com/bazel-mirror/github.com/bazelbuild/bazel-gazelle/releases/download/v0.22.0/bazel-gazelle-v0.22.0.tar.gz",
        "https://github.com/bazelbuild/bazel-gazelle/releases/download/v0.22.0/bazel-gazelle-v0.22.0.tar.gz",
    ],
)

git_repository(
    name = "com_github_bazelbuild_buildtools",
    commit = "22e56e7356b839fca53d4d20aff02e1a0dce32ae",  #v2.2.1
    remote = "https://github.com/bazelbuild/buildtools.git",
    shallow_since = "1583879293 +0100",
)

git_repository(
    name = "com_google_protobuf",
    commit = "d0bfd5221182da1a7cc280f3337b5e41a89539cf",  #v3.11.4
    remote = "https://github.com/protocolbuffers/protobuf.git",
    shallow_since = "1581711200 -0800",
)

# Stardoc is a documentation generator for Bazel
http_archive(
    name = "io_bazel_stardoc",
    sha256 = "74f4b76a6307f1543c2f974236db2aee86bdcf55dbc41a16bb518e1ffa939644",
    strip_prefix = "stardoc-a8c608986b4f27416ce085495617a6c9b3b40195",
    urls = [
        "https://github.com/bazelbuild/stardoc/archive/a8c608986b4f27416ce085495617a6c9b3b40195.tar.gz",
    ],
)

load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains", "go_rules_dependencies")
load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies")
load("@com_github_bazelbuild_buildtools//buildifier:deps.bzl", "buildifier_dependencies")
load("@com_google_protobuf//:protobuf_deps.bzl", "protobuf_deps")
load("//gotemplate:deps.bzl", "gotemplate_dependencies")

go_rules_dependencies()

go_register_toolchains()

gazelle_dependencies()

buildifier_dependencies()

gotemplate_dependencies()

protobuf_deps()
