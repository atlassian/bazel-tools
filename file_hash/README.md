# hash

Bazel rule for hashing. Supports MD5, SHA1, SHA256, SHA512.

## Setup and usage via Bazel

`WORKSPACE` file:

```bzl
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "com_github_atlassian_bazel_tools",
    strip_prefix = "bazel-tools-<commit hash>",
    urls = ["https://github.com/atlassian/bazel-tools/archive/<commit hash>.tar.gz"],
)
```

`BUILD.bazel` file:
```bzl
load("@com_github_atlassian_bazel_tools//file_hash:def.bzl", "file_hash")

file_hash(
    name = "something_sha256",
    algorithm = "sha256",
    hex = True,
    files = [
        "file1",
        "file2",
    ],
)
```
