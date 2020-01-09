# gometalinter

Bazel rule for [gometalinter](https://github.com/alecthomas/gometalinter).

## Setup and usage via Bazel

You can invoke gometalinter via the Bazel rule.

`WORKSPACE` file:
```bzl
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

# gometalinter needs Go SDK and hence needs rules_go.
# See https://github.com/bazelbuild/rules_go for the up to date setup instructions.
http_archive(
    name = "io_bazel_rules_go",
)

git_repository(
    name = "com_github_atlassian_bazel_tools",
    commit = "<commit>",
    remote = "https://github.com/atlassian/bazel-tools.git",
    shallow_since = "<bla>",
)

load("@com_github_atlassian_bazel_tools//gometalinter:deps.bzl", "gometalinter_dependencies")

gometalinter_dependencies()
```

`BUILD.bazel` typically in the workspace root:
```bzl
load("@com_github_atlassian_bazel_tools//gometalinter:def.bzl", "gometalinter")

gometalinter(
    name = "gometalinter",
    config = "//:.gometalinter.json",
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
bazel run //:gometalinter
```
