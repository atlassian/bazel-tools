# golangci-lint

Bazel rule for [golangci-lint](https://github.com/golangci/golangci-lint).

## Usage

You can invoke golangcilint via the Bazel rule.

`WORKSPACE` file:
```bzl
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# golangci-lint needs Go SDK and hence needs rules_go.
# See https://github.com/bazelbuild/rules_go for the up to date setup instructions.
http_archive(
    name = "io_bazel_rules_go",
    sha256 = "8b68d0630d63d95dacc0016c3bb4b76154fe34fca93efd65d1c366de3fcb4294",
    urls = ["https://github.com/bazelbuild/rules_go/releases/download/0.12.1/rules_go-0.12.1.tar.gz"],
)


http_archive(
    name = "com_github_atlassian_bazel_tools",
    strip_prefix = "bazel-tools-<commit hash>",
    urls = ["https://github.com/atlassian/bazel-tools/archive/<commit hash>.zip"],
)

load("@io_bazel_rules_go//go:def.bzl", "go_register_toolchains", "go_rules_dependencies")
load("@com_github_atlassian_bazel_tools//golangcilint:deps.bzl", "golangcilint_dependencies")

go_rules_dependencies()

go_register_toolchains()

golangcilint_dependencies()
```

`BUILD.bazel` typically in the workspace root:
```bzl
load("@com_github_atlassian_bazel_tools//golangcilint:def.bzl", "golangcilint")

golangcilint(
    name = "golangcilint",
    config = "//:.golangcilint.json",
    paths = [
        ".",
        "cmd/...",
        "pkg/...",
    ],
    prefix = "github.com/<my>/<project>",
)
```
Invoke with
```bash
bazel run //:golangcilint
```
