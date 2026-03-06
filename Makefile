NODE_VERSION ?= 24

# Resolve partial version (e.g., "24" or "24.1") to latest tag (e.g., "v24.1.4")
RESOLVED_VERSION := $(shell \
	if echo "$(NODE_VERSION)" | grep -qE '^v?[0-9]+\.[0-9]+\.[0-9]+$$'; then \
		echo "$(NODE_VERSION)" | sed 's/^v*/v/'; \
	else \
		git ls-remote --tags https://github.com/nodejs/node.git "v$(NODE_VERSION).*" | \
		sed 's/.*refs\/tags\///' | sed 's/\^{}//' | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+$$' | sort -V | tail -1; \
	fi)

VERSION := $(patsubst v%,%,$(RESOLVED_VERSION))

ARCHS := arm64 amd64
TARBALLS := $(foreach arch,$(ARCHS),node-$(VERSION)-$(arch).tar.gz)

.PHONY: all build release clean

all: $(TARBALLS)
	@echo "Built $(RESOLVED_VERSION)"

node-$(VERSION)-%.tar.gz: build-%
	tar -czvf $@ -C out-$*/usr/local .

build-%:
	docker buildx build \
		--platform linux/$* \
		--build-arg NODE_VERSION=$(RESOLVED_VERSION) \
		--output type=local,dest=out-$* \
		.

checksums.sha256: $(TARBALLS)
	sha256sum $(TARBALLS) > checksums.sha256

release: $(TARBALLS) checksums.sha256
	gh release create $(RESOLVED_VERSION) \
		$(TARBALLS) \
		checksums.sha256 \
		--title "Node.js $(RESOLVED_VERSION)" \
		--notes "Node.js $(RESOLVED_VERSION) with V8 pointer compression enabled.\n\n**Requires Alpine ≥3.21**"

clean:
	rm -rf out-* *.tar.gz checksums.sha256
