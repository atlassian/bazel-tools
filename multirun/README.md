# multirun

Bazel rule to `bazel run` multiple executable targets sequentially.

## Setup and usage via Bazel

`WORKSPACE` file:
```bzl
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "com_github_atlassian_bazel_tools",
    strip_prefix = "bazel-tools-<commit hash>",
    urls = ["https://github.com/atlassian/bazel-tools/archive/<commit hash>.tar.gz"],
)

load("@com_github_atlassian_bazel_tools//:multirun/deps.bzl", "multirun_dependencies")

multirun_dependencies()
```

`BUILD.bazel` file:
```bzl
load("@com_github_atlassian_bazel_tools//:multirun/def.bzl", "multirun")

multirun(
    name = "run_all",
    commands = [
        ":command1",
        ":command2",
    ],
)
```
Invoke with
```bash
bazel run //:run_all
```
