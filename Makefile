.PHONY: ballerina-pack.build
ballerina-pack.build:
	cd scripts/ballerina-pack; \
	bash build.sh

.PHONY: ballerina-pack.build.no-cache
ballerina-pack.build.no-cache:
	cd scripts/ballerina-pack; \
	bash build.sh --no-build-cache

.PHONY: ballerina-pack.build.in-place-update
ballerina-pack.build.in-place-update:
	cd scripts/ballerina-pack; \
	bash quickUpdate.sh
