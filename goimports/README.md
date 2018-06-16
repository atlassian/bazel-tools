# goimports

Bazel rule for [goimports](https://godoc.org/golang.org/x/tools/cmd/goimports).

## Setup and usage via Bazel

You can invoke goimports via the Bazel rule.

`WORKSPACE` file:
```bzl
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# goimports is written in Go and hence needs rules_go and gazelle to be built.
# See https://github.com/bazelbuild/bazel-gazelle for the up to date setup instructions.
http_archive(
    name = "io_bazel_rules_go",
    sha256 = "8b68d0630d63d95dacc0016c3bb4b76154fe34fca93efd65d1c366de3fcb4294",
    urls = ["https://github.com/bazelbuild/rules_go/releases/download/0.12.1/rules_go-0.12.1.tar.gz"],
)

http_archive(
    name = "bazel_gazelle",
    urls = ["https://github.com/bazelbuild/bazel-gazelle/releases/download/0.12.0/bazel-gazelle-0.12.0.tar.gz"],
    sha256 = "ddedc7aaeb61f2654d7d7d4fd7940052ea992ccdb031b8f9797ed143ac7e8d43",
)

http_archive(
    name = "com_github_atlassian_bazel_tools",
    strip_prefix = "bazel-tools-<commit hash>",
    urls = ["https://github.com/atlassian/bazel-tools/archive/<commit hash>.zip"],
)

load("@io_bazel_rules_go//go:def.bzl", "go_register_toolchains", "go_rules_dependencies")
load("@com_github_atlassian_bazel_tools//goimports:deps.bzl", "goimports_dependencies")

go_rules_dependencies()

go_register_toolchains()

load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies")

gazelle_dependencies()

goimports_dependencies()
```

`BUILD.bazel` typically in the workspace root:
```bzl
load("@com_github_atlassian_bazel_tools//goimports:def.bzl", "goimports")

goimports(
    name = "goimports",
    display_diffs = True,
    write = True,
)
```
Invoke with
```bash
bazel run //:goimports
```
