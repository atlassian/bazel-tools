load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

_DOWNLOAD_URI = (
    "https://github.com/golangci/golangci-lint/releases/download/v{version}/" +
    "golangci-lint-{version}-{arch}.{archive}"
)
_PREFIX = (
    "golangci-lint-{version}-{arch}"
)

_ARCHIVE_TYPE = ["zip", "tar.gz"]

_VERSION = "1.36.0"
_CHECKSUMS = {
    "windows-386": "75dd554265562b5947ad2939fb3fd3c60756356ac2dd02567cc80c82d86def54",
    "windows-amd64": "de40246f14027edea21678a76c61b32b13d2a3881088fc1b5b25c5dff83d122c",
    "linux-amd64": "9b8856b3a1c9bfbcf3a06b78e94611763b79abd9751c245246787cd3bf0e78a5",
    "linux-386": "09d54b2cb938465b4fb2b57970c55d51b4b01b1e2f08e6ae70d424738ed9031f",
    "darwin-amd64": "921e22e9e04a9acb22203bce37cff94357b4ea137c8fd5b7a1759529edbc8582",
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
    maybe(
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
