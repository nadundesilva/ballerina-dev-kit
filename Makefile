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
	bash -i init-dev-kit.sh

#
# Ballerina Pack related targets starts here
#

.PHONY: ballerina-pack.build
ballerina-pack.build:
	cd scripts/ballerina-pack; \
	USE_BUILD_CACHE="false" bash -i build.sh

.PHONY: ballerina-pack.build.with-cache
ballerina-pack.build.with-cache:
	cd scripts/ballerina-pack; \
	USE_BUILD_CACHE="true" bash -i build.sh

.PHONY: ballerina-pack.build.in-place-update
ballerina-pack.build.in-place-update:
	cd scripts/ballerina-pack; \
	bash -i quickUpdate.sh

#
# Ballerina Standard Libraries related targets
#

.PHONY: ballerina-stdlibs.clone
ballerina-stdlibs.clone:
	cd scripts/stdlibs; \
	USE_NO_CACHE="true" bash -i clone.sh

.PHONY: ballerina-stdlibs.clone.with-cache
ballerina-stdlibs.clone.with-cache:
	cd scripts/stdlibs; \
	USE_NO_CACHE="false" bash -i clone.sh

.PHONY: ballerina-stdlibs.build
ballerina-stdlibs.build:
	cd scripts/stdlibs; \
	USE_NO_CACHE="false" bash -i execute.sh -- sh gradlew clean build publishToMavenLocal --stacktrace -x test -x check

#
# Ballerina Projects related targets starts here
#

# Targets: ballerina-project.<project-name>.<module-name>.build
.PHONY: $(BALLERINA_PROJECT_BUILD_TARGETS)
$(BALLERINA_PROJECT_BUILD_TARGETS):
	$(eval BALLERINA_PROJECT=$(subst ., ,$(patsubst ballerina-project.%.build,%,$@)))
	cd scripts/ballerina-project; \
	bash -i build.sh $(BALLERINA_PROJECT)

# Targets: ballerina-project.<project-name>.<module-name>.build.debug
.PHONY: $(BALLERINA_PROJECT_BUILD_DEBUG_TARGETS)
$(BALLERINA_PROJECT_BUILD_DEBUG_TARGETS):
	$(eval BALLERINA_PROJECT=$(subst ., ,$(patsubst ballerina-project.%.build.debug,%,$@)))
	cd scripts/ballerina-project; \
	export BAL_JAVA_DEBUG=${REMOTE_DEBUG_PORT}; \
	bash -i build.sh $(BALLERINA_PROJECT) --skip-tests

# Targets: ballerina-project.<project-name>.<module-name>.run
.PHONY: $(BALLERINA_PROJECT_RUN_TARGETS)
$(BALLERINA_PROJECT_RUN_TARGETS):
	$(eval BALLERINA_PROJECT=$(subst ., ,$(patsubst ballerina-project.%.run,%,$@)))
	cd scripts/ballerina-project; \
	bash -i run.sh $(BALLERINA_PROJECT)

# Targets: ballerina-project.<project-name>.<module-name>.run.debug
.PHONY: $(BALLERINA_PROJECT_RUN_DEBUG_TARGETS)
$(BALLERINA_PROJECT_RUN_DEBUG_TARGETS):
	$(eval BALLERINA_PROJECT=$(subst ., ,$(patsubst ballerina-project.%.run.debug,%,$@)))
	cd scripts/ballerina-project; \
	bash -i run.sh $(BALLERINA_PROJECT) -Xdebug -Xrunjdwp:transport=dt_socket,address=${REMOTE_DEBUG_PORT},server=y

#
# Miscelaneous targets starts here
#

.PHONY: misc.jaeger.start
misc.jaeger.start:
	cd scripts/misc; \
	bash -i start-jaeger.sh

.PHONY: misc.prometheus.start
misc.prometheus.start:
	cd scripts/misc; \
	bash -i start-prometheus.sh

.PHONY: misc.grafana.start
misc.grafana.start:
	cd scripts/misc; \
	bash -i start-grafana.sh
