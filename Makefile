NODE_VERSION ?= v24.1.4
VERSION := $(patsubst v%,%,$(NODE_VERSION))

ARCHS := arm64 amd64
TARBALLS := $(foreach arch,$(ARCHS),node-$(VERSION)-$(arch).tar.gz)

.PHONY: all build release clean

all: $(TARBALLS)

node-$(VERSION)-%.tar.gz: build-%
	tar -czvf $@ -C out-$*/usr/local .

build-%:
	docker buildx build \
		--platform linux/$* \
		--build-arg NODE_VERSION=$(NODE_VERSION) \
		--output type=local,dest=out-$* \
		.

checksums.sha256: $(TARBALLS)
	sha256sum $(TARBALLS) > checksums.sha256

release: $(TARBALLS) checksums.sha256
	gh release create $(NODE_VERSION) \
		$(TARBALLS) \
		checksums.sha256 \
		--title "Node.js $(NODE_VERSION)" \
		--notes "Node.js $(NODE_VERSION) with V8 pointer compression enabled.\n\n**Requires Alpine ≥3.22**"

clean:
	rm -rf out-* *.tar.gz checksums.sha256
