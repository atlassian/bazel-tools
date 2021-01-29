workspace(name = "com_github_atlassian_bazel_tools")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

http_archive(
    name = "io_bazel_rules_go",
    sha256 = "d1ffd055969c8f8d431e2d439813e42326961d0942bdf734d2c95dc30c369566",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/download/v0.24.5/rules_go-v0.24.5.tar.gz",
        "https://github.com/bazelbuild/rules_go/releases/download/v0.24.5/rules_go-v0.24.5.tar.gz",
    ],
)

http_archive(
    name = "bazel_gazelle",
    sha256 = "b85f48fa105c4403326e9525ad2b2cc437babaa6e15a3fc0b1dbab0ab064bc7c",
    urls = [
        "https://storage.googleapis.com/bazel-mirror/github.com/bazelbuild/bazel-gazelle/releases/download/v0.22.2/bazel-gazelle-v0.22.2.tar.gz",
        "https://github.com/bazelbuild/bazel-gazelle/releases/download/v0.22.2/bazel-gazelle-v0.22.2.tar.gz",
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
    sha256 = "9aec63241d323a28663ba99c1ce57bab6f28f1646390511ee48d4b42082f10f4",
    strip_prefix = "stardoc-8275ced1b6952f5ad17ec579a5dd16e102479b72",
    urls = [
        "https://github.com/bazelbuild/stardoc/archive/8275ced1b6952f5ad17ec579a5dd16e102479b72.tar.gz",
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
