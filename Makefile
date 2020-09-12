bazel_bin_dir=$(shell bazel info bazel-bin)

.PHONY: buildozer/docs
buildozer/docs:
	@/usr/bin/env bazel build //buildozer/docs
	@/usr/bin/env cat \
		$(bazel_bin_dir)/buildozer/docs/buildozer_rule.md >\
		buildozer/docs/buildozer_rule.md
