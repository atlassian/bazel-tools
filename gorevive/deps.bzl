load("@bazel_gazelle//:deps.bzl", "go_repository")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "new_git_repository")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def go_revive_dependencies():
    _maybe(
        go_repository,
        name = "com_github_burntsushi_toml",
        importpath = "github.com/BurntSushi/toml",
        tag = "v0.3.0",
    )

    _maybe(
        go_repository,
        name = "com_github_fatih_color",
        importpath = "github.com/fatih/color",
        tag = "v1.7.0",
    )

    _maybe(
        go_repository,
        name = "com_github_fatih_structtag",
        importpath = "github.com/fatih/structtag",
        tag = "v1.0.0",
    )

    _maybe(
        go_repository,
        name = "com_github_mattn_go_colorable",
        importpath = "github.com/mattn/go-colorable",
        tag = "v0.0.9",
    )

    _maybe(
        go_repository,
        name = "com_github_mattn_go_isatty",
        importpath = "github.com/mattn/go-isatty",
        tag = "v0.0.4",
    )

    _maybe(
        go_repository,
        name = "com_github_mattn_go_runewidth",
        importpath = "github.com/mattn/go-runewidth",
        tag = "v0.0.3",
    )

    _maybe(
        go_repository,
        name = "com_github_mgechev_dots",
        commit = "8e09d8ea2757",
        importpath = "github.com/mgechev/dots",
    )

    _maybe(
        go_repository,
        name = "com_github_olekukonko_tablewriter",
        commit = "be2c049b30cc",
        importpath = "github.com/olekukonko/tablewriter",
    )

    _maybe(
        go_repository,
        name = "com_github_pkg_errors",
        importpath = "github.com/pkg/errors",
        tag = "v0.8.0",
    )

    _maybe(
        go_repository,
        name = "org_golang_x_sys",
        commit = "d0be0721c37e",
        importpath = "golang.org/x/sys",
    )

    _maybe(
        go_repository,
        name = "org_golang_x_tools",
        commit = "bf090417da8b6150dcfe96795325f5aa78fff718",
        importpath = "golang.org/x/tools",
    )

    _maybe(
        http_archive,
        name = "bazel_skylib",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.0.2/bazel-skylib-1.0.2.tar.gz",
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.0.2/bazel-skylib-1.0.2.tar.gz",
        ],
        sha256 = "97e70364e9249702246c0e9444bccdc4b847bed1eb03c5a3ece4f83dfe6abc44",
    )

    _maybe(
        new_git_repository,
        name = "com_github_mgechev_revive",
        commit = "b4cc152955fbbcd2afafd5df3d46393d621a7fdf",
        remote = "https://github.com/mgechev/revive.git",
        build_file = "@com_github_atlassian_bazel_tools//gorevive:revive.BUILD.bazel",
    )

def _maybe(repo_rule, name, **kwargs):
    if name not in native.existing_rules():
        repo_rule(name = name, **kwargs)
