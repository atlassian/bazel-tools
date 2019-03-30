load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

_DOWNLOAD_URI = (
    "https://github.com/golangci/golangci-lint/releases/download/v{version}/" +
    "golangci-lint-{version}-{arch}.tar.gz"
)
_PREFIX = (
    "golangci-lint-{version}-{arch}"
)

_VERSION = "1.14.0"
_CHECKSUMS = {
    "windows-386": "d819336b57a61c2676fb99352fead8aa567b454202e22670eec5833b04eb3a78",
    "windows-amd64": "e79cbe016591832b85ce66f29c8180ebd8a45dcb793a44c9d3ff101bd7f3fe76",
    "darwin-386": "af352896aa6fa9d830a2b1f2fa0f5655d66372138ce5975c44fca4e4bdd85de1",
    "linux-amd64": "4b7495539c84ecfb4256f1e7c8bcc9aea6732aef7360fd43ff239cea05d566c1",
    "linux-386": "af93eb9d4722830940e74e6c018154c8182b31dd3ab5599fc7a3cdcdd472b37e",
    "darwin-amd64": "9906ff1eb2cc01e53ba31f44a937300633b1f52ad227d9e206506c6c1b083a29",
}

def _golangcilint_download_impl(ctx):
    if ctx.os.name == "linux":
        arch = "linux-amd64"
    elif ctx.os.name == "mac os x":
        arch = "darwin-amd64"
    else:
        fail("Unsupported operating system: {}".format(ctx.os.name))

    if arch not in _CHECKSUMS:
        fail("Unsupported arch {}".format(arch))

    url = _DOWNLOAD_URI.format(version = _VERSION, arch = arch)
    prefix = _PREFIX.format(version = _VERSION, arch = arch)
    sha256 = _CHECKSUMS[arch]

    ctx.template(
        "BUILD.bazel",
        Label("@com_github_atlassian_bazel_tools//golangcilint:golangcilint.build.bazel"),
        executable = False,
    )
    ctx.download_and_extract(
        stripPrefix = prefix,
        url = url,
        sha256 = sha256,
    )

_golangcilint_download = repository_rule(
    implementation = _golangcilint_download_impl,
)

def golangcilint_dependencies():
    _maybe(
        http_archive,
        name = "bazel_skylib",
        sha256 = "2c62d8cd4ab1e65c08647eb4afe38f51591f43f7f0885e7769832fa137633dcb",
        strip_prefix = "bazel-skylib-0.7.0",
        urls = ["https://github.com/bazelbuild/bazel-skylib/archive/0.7.0.tar.gz"],
    )
    _golangcilint_download(
        name = "com_github_atlassian_bazel_tools_golangcilint",
    )

def _maybe(repo_rule, name, **kwargs):
    if name not in native.existing_rules():
        repo_rule(name = name, **kwargs)
