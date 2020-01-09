# Buildozer

See the [official readme](https://github.com/bazelbuild/buildtools/tree/master/buildozer).

## Setup and usage via Bazel

You can invoke buildozer via the Bazel rule.

`WORKSPACE` file:
```bzl
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

# buildozer is written in Go and hence needs rules_go to be built.
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

git_repository(
    name = "com_google_protobuf",
    commit = "fe1790ca0df67173702f70d5646b82f48f412b99",  #v3.11.2
    remote = "https://github.com/protocolbuffers/protobuf.git",
    shallow_since = "1576187991 -0800",
)

load("@com_github_atlassian_bazel_tools//buildozer:deps.bzl", "buildozer_dependencies")
load("@com_google_protobuf//:protobuf_deps.bzl", "protobuf_deps")

buildozer_dependencies()

protobuf_deps()
```

`BUILD.bazel` typically in the workspace root:
```bzl
load("@com_github_atlassian_bazel_tools//buildozer:def.bzl", "buildozer")

buildozer(
    name = "buildozer",
    commands = "//:buildozer_commands.txt",
)
```
Invoke with
```bash
bazel run //:buildozer
```
