load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

_GOMETALINTER_TARBALLS = {
    "darwin_amd64": ("gometalinter-2.0.5-darwin-amd64.tar.gz", "gometalinter-2.0.5-darwin-amd64", "d2571dd081a00752fc7876a9f64042937e9d75e7968465e3c5b5ee9dad64a6c7"),
    "linux_amd64": ("gometalinter-2.0.5-linux-amd64.tar.gz", "gometalinter-2.0.5-linux-amd64", "83ff1a03626130d249b96b7e321d9c7a03e5f943c042a0e07011779be1adf8e8"),
}

def _gometalinter_download_impl(ctx):
    if ctx.os.name == "linux":
        host = "linux_amd64"
    elif ctx.os.name == "mac os x":
        host = "darwin_amd64"
    else:
        fail("Unsupported operating system: " + ctx.os.name)
    if host not in _GOMETALINTER_TARBALLS:
        fail("Unsupported host {}".format(host))

    filename, prefix, sha256 = _GOMETALINTER_TARBALLS[host]
    url = "https://github.com/alecthomas/gometalinter/releases/download/v2.0.5/" + filename

    ctx.template(
        "BUILD.bazel",
        Label("@com_github_atlassian_bazel_tools//gometalinter:gometalinter.build.bazel"),
        executable = False,
    )
    ctx.download_and_extract(
        stripPrefix = prefix,
        url = url,
        sha256 = sha256,
    )

_gometalinter_download = repository_rule(
    implementation = _gometalinter_download_impl,
)

def gometalinter_dependencies():
    _maybe(
        http_archive,
        name = "bazel_skylib",
        sha256 = "b5f6abe419da897b7901f90cbab08af958b97a8f3575b0d3dd062ac7ce78541f",
        strip_prefix = "bazel-skylib-0.5.0",
        urls = ["https://github.com/bazelbuild/bazel-skylib/archive/0.5.0.tar.gz"],
    )
    _gometalinter_download(
        name = "com_github_atlassian_bazel_tools_gometalinter",
    )

def _maybe(repo_rule, name, **kwargs):
    if name not in native.existing_rules():
        repo_rule(name = name, **kwargs)
