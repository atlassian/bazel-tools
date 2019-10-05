# Buildozer

See the [official readme](https://github.com/bazelbuild/buildtools/tree/master/buildozer).

## Setup and usage via Bazel

You can invoke buildozer via the Bazel rule.

`WORKSPACE` file:
```bzl
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# buildozer is written in Go and hence needs rules_go to be built.
# See https://github.com/bazelbuild/rules_go for the up to date setup instructions.
http_archive(
    name = "io_bazel_rules_go",
)

http_archive(
    name = "com_github_atlassian_bazel_tools",
    strip_prefix = "bazel-tools-<commit hash>",
    urls = ["https://github.com/atlassian/bazel-tools/archive/<commit hash>.zip"],
)

http_archive(
    name = "com_google_protobuf",
    sha256 = "758249b537abba2f21ebc2d02555bf080917f0f2f88f4cbe2903e0e28c4187ed",
    strip_prefix = "protobuf-3.10.0",
    urls = ["https://github.com/protocolbuffers/protobuf/archive/v3.10.0.tar.gz"],
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
