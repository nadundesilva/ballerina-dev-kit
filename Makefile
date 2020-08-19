REMOTE_DEBUG_PORT=5005

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

.PHONY: ballerina-project.observability_test.hello_world_service.build
ballerina-project.observability_test.hello_world_service.build:
	cd scripts/ballerina-project; \
	bash build.sh observability_test hello_world_service

.PHONY: ballerina-project.observability_test.hello_world_service.build.debug
ballerina-project.observability_test.hello_world_service.build.debug:
	cd scripts/ballerina-project; \
	export BAL_JAVA_DEBUG=${REMOTE_DEBUG_PORT}; \
	bash build.sh observability_test hello_world_service --skip-tests

.PHONY: ballerina-project.observability_test.hello_world_service.run
ballerina-project.observability_test.hello_world_service.run:
	cd scripts/ballerina-project; \
	bash run.sh observability_test hello_world_service

.PHONY: ballerina-project.observability_test.hello_world_service.run.debug
ballerina-project.observability_test.hello_world_service.run.debug:
	cd scripts/ballerina-project; \
	bash run.sh observability_test hello_world_service -Xdebug -Xrunjdwp:transport=dt_socket,address=${REMOTE_DEBUG_PORT},server=y

.PHONY: misc.jaeger.start
misc.jaeger.start:
	cd scripts/misc; \
	bash start-jaeger.sh
