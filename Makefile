REMOTE_DEBUG_PORT := 5005

BALLERINA_PROJECT_OBSERVABILITY_TEST_MODULE_NAMES := hello_world_service simple_passthrough chained_ballerina_service
BALLERINA_PROJECT_OBSERVABILITY_TEST_MODULE_TARGETS := $(addprefix ballerina-project.observability_test., $(BALLERINA_PROJECT_OBSERVABILITY_TEST_MODULE_NAMES))

BALLERINA_PROJECT_MODULE_TARGETS := $(BALLERINA_PROJECT_OBSERVABILITY_TEST_MODULE_TARGETS)
BALLERINA_PROJECT_BUILD_TARGETS := $(addsuffix .build, $(BALLERINA_PROJECT_MODULE_TARGETS))
BALLERINA_PROJECT_BUILD_DEBUG_TARGETS := $(addsuffix .build.debug, $(BALLERINA_PROJECT_MODULE_TARGETS))
BALLERINA_PROJECT_RUN_TARGETS := $(addsuffix .run, $(BALLERINA_PROJECT_MODULE_TARGETS))
BALLERINA_PROJECT_RUN_DEBUG_TARGETS := $(addsuffix .run.debug, $(BALLERINA_PROJECT_MODULE_TARGETS))

#
# Ballerina Pack related targets starts here
#

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

#
# Ballerina Projects related targets starts here
#

# Targets: ballerina-project.<project-name>.<module-name>.build
.PHONY: $(BALLERINA_PROJECT_BUILD_TARGETS)
$(BALLERINA_PROJECT_BUILD_TARGETS):
	$(eval BALLERINA_PROJECT_AND_MODULE=$(subst ., ,$(patsubst ballerina-project.%.build,%,$@)))
	$(eval BALLERINA_PROJECT=$(word 1, $(BALLERINA_PROJECT_AND_MODULE)))
	$(eval BALLERINA_MODULE=$(word 2, $(BALLERINA_PROJECT_AND_MODULE)))
	cd scripts/ballerina-project; \
	bash build.sh $(BALLERINA_PROJECT) $(BALLERINA_MODULE)

# Targets: ballerina-project.<project-name>.<module-name>.build.debug
.PHONY: $(BALLERINA_PROJECT_BUILD_DEBUG_TARGETS)
$(BALLERINA_PROJECT_BUILD_DEBUG_TARGETS):
	$(eval BALLERINA_PROJECT_AND_MODULE=$(subst ., ,$(patsubst ballerina-project.%.build.debug,%,$@)))
	$(eval BALLERINA_PROJECT=$(word 1, $(BALLERINA_PROJECT_AND_MODULE)))
	$(eval BALLERINA_MODULE=$(word 2, $(BALLERINA_PROJECT_AND_MODULE)))
	cd scripts/ballerina-project; \
	export BAL_JAVA_DEBUG=${REMOTE_DEBUG_PORT}; \
	bash build.sh $(BALLERINA_PROJECT) $(BALLERINA_MODULE) --skip-tests

# Targets: ballerina-project.<project-name>.<module-name>.run
.PHONY: $(BALLERINA_PROJECT_RUN_TARGETS)
$(BALLERINA_PROJECT_RUN_TARGETS):
	$(eval BALLERINA_PROJECT_AND_MODULE=$(subst ., ,$(patsubst ballerina-project.%.run,%,$@)))
	$(eval BALLERINA_PROJECT=$(word 1, $(BALLERINA_PROJECT_AND_MODULE)))
	$(eval BALLERINA_MODULE=$(word 2, $(BALLERINA_PROJECT_AND_MODULE)))
	cd scripts/ballerina-project; \
	bash run.sh $(BALLERINA_PROJECT) $(BALLERINA_MODULE)

# Targets: ballerina-project.<project-name>.<module-name>.run.debug
.PHONY: $(BALLERINA_PROJECT_RUN_DEBUG_TARGETS)
$(BALLERINA_PROJECT_RUN_DEBUG_TARGETS):
	$(eval BALLERINA_PROJECT_AND_MODULE=$(subst ., ,$(patsubst ballerina-project.%.run.debug,%,$@)))
	$(eval BALLERINA_PROJECT=$(word 1, $(BALLERINA_PROJECT_AND_MODULE)))
	$(eval BALLERINA_MODULE=$(word 2, $(BALLERINA_PROJECT_AND_MODULE)))
	cd scripts/ballerina-project; \
	bash run.sh $(BALLERINA_PROJECT) $(BALLERINA_MODULE) -Xdebug -Xrunjdwp:transport=dt_socket,address=${REMOTE_DEBUG_PORT},server=y

#
# Miscelaneous targets starts here
#

.PHONY: misc.jaeger.start
misc.jaeger.start:
	cd scripts/misc; \
	bash start-jaeger.sh

.PHONY: misc.prometheus.start
misc.prometheus.start:
	cd scripts/misc; \
	bash start-prometheus.sh

.PHONY: misc.grafana.start
misc.grafana.start:
	cd scripts/misc; \
	bash start-grafana.sh
