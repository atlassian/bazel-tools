# gotemplate

Bazel rule for Go's [`text/template`](https://golang.org/pkg/text/template/) package.

## Setup and usage via Bazel

### `WORKSPACE` file

```bzl
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "com_github_atlassian_bazel_tools",
    strip_prefix = "bazel-tools-<commit hash>",
    urls = ["https://github.com/atlassian/bazel-tools/archive/<commit hash>.tar.gz"],
)

load("@com_github_atlassian_bazel_tools//gotemplate:deps.bzl", "gotemplate_dependencies")

gotemplate_dependencies()
```

### Simple templating

`BUILD.bazel` file:
```bzl
load("@com_github_atlassian_bazel_tools//gotemplate:def.bzl", "gotemplate")

gotemplate(
    name = "something",
    yaml_contexts = {
        "some.ctx1.yaml": "one",
        "some.ctx2.yaml": "two",
    },
    template = "some-template.txt",
)
```

`some-template.txt`:
```text
bla bla bla
{{ .one.a }} {{ .two }}
```
`some.ctx1.yaml`:
```yaml
a: 1
```
`some.ctx2.yaml`:
```yaml
b: 2
```
To run this example execute:
```console
bazel build :something
```
Output file will contain:
```text
bla bla bla
1 map[b:2]
```

### Executable files

You can build executable files using `gotemplate_exec` rule.

`BUILD.bazel` file:
```bzl
load("@com_github_atlassian_bazel_tools//gotemplate:def.bzl", "gotemplate_exec")

gotemplate_exec(
    name = "something-else.bash",
    yaml_contexts = {
        "some.ctx1.yaml": "one",
        "some.ctx2.yaml": "two",
    },
    template = "some-executable-template.bash",
)
```

`some-executable-template.bash`:
```text
#!/usr/bin/env bash

echo '{{ .one.a }} {{ .two }}'
```
To run this example execute:
```console
bazel run :something-else.bash
```
Output file will contain:
```text
1 map[b:2]
```
