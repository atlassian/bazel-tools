load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

_DOWNLOAD_URI = (
    "https://github.com/golangci/golangci-lint/releases/download/v{version}/" +
    "golangci-lint-{version}-{arch}.tar.gz"
)
_PREFIX = (
    "golangci-lint-{version}-{arch}"
)

_VERSION = "1.19.1"
_CHECKSUMS = {
    "windows-386": "5f9269cf8211ee2dc1824a35749662100f2c61548c281dae47ca575e93d2fc76",
    "windows-amd64": "9adb30ca0d25e0d0816291095c3fa7788bc8a16f343f9ee7a91e5cfc089e4adf",
    "darwin-386": "f0534be9cde3f7fda16a18d2d77d3b62f58c3eddfebdf9e4159ab6cb96e5ba5d",
    "linux-amd64": "03ca6a77734720581b11a78e5fd4ce6d6bfd8f36768b214bb9890980b6db261f",
    "linux-386": "963c6c7f2332234b568fbd2db1acdfae1fa781ff53a11c392141374433e713bd",
    "darwin-amd64": "b6e0719a6e2d2e8aefe67ab33e67d7be81790fec41da6412e152cd77f37cf955",
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
        sha256 = "2ef429f5d7ce7111263289644d233707dba35e39696377ebab8b0bc701f7818e",
        strip_prefix = "bazel-skylib-0.8.0",
        urls = ["https://github.com/bazelbuild/bazel-skylib/archive/0.8.0.tar.gz"],
    )
    _golangcilint_download(
        name = "com_github_atlassian_bazel_tools_golangcilint",
    )

def _maybe(repo_rule, name, **kwargs):
    if name not in native.existing_rules():
        repo_rule(name = name, **kwargs)
