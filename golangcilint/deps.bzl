load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

_DOWNLOAD_URI = (
    "https://github.com/golangci/golangci-lint/releases/download/v{version}/" +
    "golangci-lint-{version}-{arch}.{archive}"
)
_PREFIX = (
    "golangci-lint-{version}-{arch}"
)

_ARCHIVE_TYPE = ["zip", "tar.gz"]

_VERSION = "1.26.0"
_CHECKSUMS = {
    "windows-386": "9af9783a995a52c7a294b8a2aac34a86af2c42c01546021a0b2baaa99c38fed4",
    "windows-amd64": "dc9f88a7bcdb5dc4bb6a55000b67efee98545b49dcfed300004d9b411314cc7c",
    "linux-amd64": "59b0e49a4578fea574648a2fd5174ed61644c667ea1a1b54b8082fde15ef94fd",
    "linux-386": "b1c7a04dd7dae577af7c005a7ff9a1e6291889bf4fa5e88a9038b99080929460",
    "darwin-amd64": "c807a26370f53d761bd9d8742358d6276b3608a8286f25c03ecf79fd9eb99cf1",
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

    if arch.startswith("windows"):
        archive = _ARCHIVE_TYPE[0]
    else:
        archive = _ARCHIVE_TYPE[1]

    url = _DOWNLOAD_URI.format(version = _VERSION, arch = arch, archive = archive)
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
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.0.2/bazel-skylib-1.0.2.tar.gz",
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.0.2/bazel-skylib-1.0.2.tar.gz",
        ],
        sha256 = "97e70364e9249702246c0e9444bccdc4b847bed1eb03c5a3ece4f83dfe6abc44",
    )
    _golangcilint_download(
        name = "com_github_atlassian_bazel_tools_golangcilint",
    )

def _maybe(repo_rule, name, **kwargs):
    if name not in native.existing_rules():
        repo_rule(name = name, **kwargs)
