REMOTE_DEBUG_PORT := 5005

PYTHON3_EXECUTABLE := python3

BALLERINA_PROJECT_OBSERVABILITY_TEST_MODULE_NAMES := hello_world_service simple_passthrough chained_ballerina_service
BALLERINA_PROJECT_OBSERVABILITY_TEST_MODULE_TARGETS := $(addprefix ballerina-project., $(BALLERINA_PROJECT_OBSERVABILITY_TEST_MODULE_NAMES))

BALLERINA_PROJECT_MODULE_TARGETS := $(BALLERINA_PROJECT_OBSERVABILITY_TEST_MODULE_TARGETS)
BALLERINA_PROJECT_BUILD_TARGETS := $(addsuffix .build, $(BALLERINA_PROJECT_MODULE_TARGETS))
BALLERINA_PROJECT_BUILD_DEBUG_TARGETS := $(addsuffix .build.debug, $(BALLERINA_PROJECT_MODULE_TARGETS))
BALLERINA_PROJECT_RUN_TARGETS := $(addsuffix .run, $(BALLERINA_PROJECT_MODULE_TARGETS))
BALLERINA_PROJECT_RUN_DEBUG_TARGETS := $(addsuffix .run.debug, $(BALLERINA_PROJECT_MODULE_TARGETS))

.PHONY: init-dev-kit
init-dev-kit:
	cd scripts; \
	./init-dev-kit.sh

#
# Ballerina Pack related targets starts here
#

.PHONY: ballerina-pack.build
ballerina-pack.build:
	cd scripts/ballerina-pack; \
	export SKIP_STDLIBS_BUILD="true"; \
	export USE_BUILD_CACHE="false"; \
	./build.sh

.PHONY: ballerina-pack.build.with-stdlibs
ballerina-pack.build.with-stdlibs:
	cd scripts/ballerina-pack; \
	export SKIP_STDLIBS_BUILD="false"; \
	export USE_BUILD_CACHE="false"; \
	./build.sh

.PHONY: ballerina-pack.build.with-cache
ballerina-pack.build.with-cache:
	cd scripts/ballerina-pack; \
	export SKIP_STDLIBS_BUILD="true"; \
	export USE_BUILD_CACHE="true"; \
	./build.sh

.PHONY: ballerina-pack.build.in-place-update
ballerina-pack.build.in-place-update:
	cd scripts/ballerina-pack; \
	./quick-update.sh

#
# Ballerina Standard Libraries related targets
#

.PHONY: ballerina-stdlibs.clone
ballerina-stdlibs.clone:
	cd scripts/stdlibs; \
	export USE_NO_CACHE="true"; \
	./clone.sh

.PHONY: ballerina-stdlibs.clone.with-cache
ballerina-stdlibs.clone.with-cache:
	cd scripts/stdlibs; \
	export USE_NO_CACHE="false"; \
	./clone.sh

.PHONY: ballerina-stdlibs.build
ballerina-stdlibs.build:
	cd scripts/stdlibs; \
	export USE_NO_CACHE="false"; \
	./execute.sh -- bash $(realpath ./build-repo.sh)

#
# Ballerina Projects related targets starts here
#

# Targets: ballerina-project.<project-name>.<module-name>.build
.PHONY: $(BALLERINA_PROJECT_BUILD_TARGETS)
$(BALLERINA_PROJECT_BUILD_TARGETS):
	$(eval BALLERINA_PROJECT=$(subst ., ,$(patsubst ballerina-project.%.build,%,$@)))
	cd scripts/ballerina-project; \
	./build.sh $(BALLERINA_PROJECT)

# Targets: ballerina-project.<project-name>.<module-name>.build.debug
.PHONY: $(BALLERINA_PROJECT_BUILD_DEBUG_TARGETS)
$(BALLERINA_PROJECT_BUILD_DEBUG_TARGETS):
	$(eval BALLERINA_PROJECT=$(subst ., ,$(patsubst ballerina-project.%.build.debug,%,$@)))
	cd scripts/ballerina-project; \
	export BAL_JAVA_DEBUG=${REMOTE_DEBUG_PORT}; \
	./build.sh $(BALLERINA_PROJECT) --skip-tests

# Targets: ballerina-project.<project-name>.<module-name>.run
.PHONY: $(BALLERINA_PROJECT_RUN_TARGETS)
$(BALLERINA_PROJECT_RUN_TARGETS):
	$(eval BALLERINA_PROJECT=$(subst ., ,$(patsubst ballerina-project.%.run,%,$@)))
	cd scripts/ballerina-project; \
	./run.sh $(BALLERINA_PROJECT)

# Targets: ballerina-project.<project-name>.<module-name>.run.debug
.PHONY: $(BALLERINA_PROJECT_RUN_DEBUG_TARGETS)
$(BALLERINA_PROJECT_RUN_DEBUG_TARGETS):
	$(eval BALLERINA_PROJECT=$(subst ., ,$(patsubst ballerina-project.%.run.debug,%,$@)))
	cd scripts/ballerina-project; \
	./run.sh $(BALLERINA_PROJECT) -Xdebug -Xrunjdwp:transport=dt_socket,address=${REMOTE_DEBUG_PORT},server=y

#
# Miscelaneous targets starts here
#

.PHONY: misc.jaeger.start
misc.jaeger.start:
	cd scripts/misc; \
	./start-jaeger.sh

.PHONY: misc.prometheus.start
misc.prometheus.start:
	cd scripts/misc; \
	./start-prometheus.sh

.PHONY: misc.grafana.start
misc.grafana.start:
	cd scripts/misc; \
	./start-grafana.sh
