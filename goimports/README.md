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
)

http_archive(
    name = "bazel_gazelle",
)

http_archive(
    name = "com_github_atlassian_bazel_tools",
    strip_prefix = "bazel-tools-<commit hash>",
    urls = ["https://github.com/atlassian/bazel-tools/archive/<commit hash>.zip"],
)

load("@com_github_atlassian_bazel_tools//goimports:deps.bzl", "goimports_dependencies")

goimports_dependencies()
```

`BUILD.bazel` typically in the workspace root:
```bzl
load("@com_github_atlassian_bazel_tools//goimports:def.bzl", "goimports")

goimports(
    name = "goimports",
    display_diffs = True,
    write = True,
    prefix = "<your project prefix>",
)
```
Invoke with
```bash
bazel run //:goimports
```
