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
)

http_archive(
    name = "com_github_atlassian_bazel_tools",
    strip_prefix = "bazel-tools-<commit hash>",
    urls = ["https://github.com/atlassian/bazel-tools/archive/<commit hash>.zip"],
)

load("@com_github_atlassian_bazel_tools//golangcilint:deps.bzl", "golangcilint_dependencies")

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
    prefix = "bitbucket.org/<my>/<project>",
)
```
Invoke with
```bash
bazel run //:golangcilint
```
