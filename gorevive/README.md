# revive

Bazel rule for Golang [revive](https://github.com/mgechev/revive)
linter.

This package provides a single Bazel rule `go_revive_test` which is
intended to be used as a part of your test suite (as opposed to a
regular linting tool).

Since it is just a Bazel test rule it does not modify your working
directory files and can be used in a CI tool to check the code style.

## Setup and usage via Bazel

You can invoke revive via the Bazel rule.

`WORKSPACE` file:
```bzl

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# Most likely you already have rules_go and gazelle imported into your
# WORKSPACE. If so, skip the corresponding part below.

# revive has to be compiled from sources, hence we need rules_go.
http_archive(
    name = "io_bazel_rules_go",
    sha256 = "7519e9e1c716ae3c05bd2d984a42c3b02e690c5df728dc0a84b23f90c355c5a1",
    urls = ["https://github.com/bazelbuild/rules_go/releases/download/0.15.4/rules_go-0.15.4.tar.gz"],
)

# go_repository rule is required which is provided by bazel_gazelle.
http_archive(
    name = "bazel_gazelle",
    sha256 = "c0a5739d12c6d05b6c1ad56f2200cb0b57c5a70e03ebd2f7b87ce88cabf09c7b",
    urls = ["https://github.com/bazelbuild/bazel-gazelle/releases/download/0.14.0/bazel-gazelle-0.14.0.tar.gz"],
)

http_archive(
    name = "com_github_atlassian_bazel_tools",
    strip_prefix = "bazel-tools-<commit hash>",
    urls = ["https://github.com/atlassian/bazel-tools/archive/<commit hash>.zip"],
)

load("@io_bazel_rules_go//go:def.bzl", "go_register_toolchains", "go_rules_dependencies")
load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies", "go_repository")

go_rules_dependencies()

go_register_toolchains()

gazelle_dependencies()

# Load go_revive_dependencies Bazel rule.
load("@com_github_atlassian_bazel_tools//gorevive:deps.bzl", "go_revive_dependencies")

go_revive_dependencies()

```



`BUILD.bazel`:
```bzl
# A simple rule to make the config file available for Bazel rules.
exports_files(["defaults.toml"])

# Go sources needed to be linted.
filegroup(
    name = "go_srcs",
    srcs = glob(["src/*.go"]),
    visibility = ["//visibility:private"],
)

load("@com_github_atlassian_bazel_tools//gorevive:def.bzl", "go_revive_test")

go_revive_test(
    name = "revive_test",
    # Go source files to be linted.
    srcs = [":go_srcs"],
    # Revive .toml config.
    config = "defaults.toml",  # it can also be a regular Bazel label.
    formatter = "stylish",
    # The paths have to be relative to the workspace root.
    paths = ["src/..."],
    # Set debug=True if you need to see the details of the execution of
    # this rule. Default: False.
    debug = True,
)

```

Run as a regular Bazel test:

```bash
bazel run :revive_test
# OR
bazel test :revive_test
```

## Minimal working example

Please, see the `example` directory for a minimal working use-case
example.
