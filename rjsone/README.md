# rjsone

Bazel rule for [`rjsone`](https://github.com/wryun/rjsone).

## Setup and usage via Bazel

`WORKSPACE` file:
```bzl
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# rjsone is written in Go and hence needs rules_go and gazelle to be built.
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
    urls = ["https://github.com/atlassian/bazel-tools/archive/<commit hash>.tar.gz"],
)

load("@com_github_atlassian_bazel_tools//:rjsone/deps.bzl", "rjsone_dependencies")

rjsone_dependencies()
```

`BUILD.bazel` file:
```bzl
load("@com_github_atlassian_bazel_tools//:rjsone/def.bzl", "rjsone")

filegroup(
    name = "list",
    srcs = [
        "context1.yaml",
        "context2.yaml",
    ],
)

rjsone(
    name = "example1",
    contexts = [
        "context1.yaml",
        "context2.yaml",
    ],
    keyed_contexts = {
        ":list": "list",
        "named.yaml": "foobar",
    },
    template = "template_bazel.yaml",
)
```
Rule has two predeclared outputs: `{name}.yaml` and `{name}.json`. You may depend on one or the other depending on
whether you want to get output as YAML or JSON.
```console
bazel build //:example1 # builds both
bazel build //:example1.yaml
bazel build //:example1.json
```
Not all rjsone features are supported right now.
