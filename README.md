# Ballerina Development Kit

[![Build](https://github.com/nadundesilva/ballerina-dev-kit/workflows/Build%20Branch/badge.svg)](https://github.com/nadundesilva/ballerina-dev-kit/actions?query=workflow%3A"Build+Branch"+branch%3Amain)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/nadundesilva/ballerina-dev-kit.svg)](https://github.com/nadundesilva/ballerina-dev-kit/commits/master)
[![Github issues](https://img.shields.io/github/issues/nadundesilva/ballerina-dev-kit?label=Open%20Issues)](https://github.com/nadundesilva/ballerina-dev-kit/issues)

A set of tools and scripts designed for Developers working on Ballerina Lang related repositories.

## Requirements

* JDK 11
* GNU Make 4.1+
* Docker

## How to Use

The make targets can be used to build ballerina pack and run the available test projects.

### Getting Started

1. Clone repository.
2. Execute the following command to initialize and update all submodules.
   ```bash
   git submodule update --init --recursive
   ```

### Building Ballerina Pack

The following make targets can be used to build a ballerina pack.

| Make Target                            | Description                                           |
|----------------------------------------|-------------------------------------------------------|
| `ballerina-pack.build`                 | Build Ballerina Pack without using Gradle build cache |
| `ballerina-pack.build.with-cache`      | Build Ballerina Pack with Gradle build cache          |
| `ballerina-pack.build.in-place-update` | In place update the Ballerina pack                    |

The ballerina pack should be available in `<BALLERINA_DEV_KIT_ROOT>/packs` directory once one of the above targets
are executed.

### Sample Test Projects

The following make targets can be used to build and run a test project.

| Make Target                               | Description                           |
|-------------------------------------------|---------------------------------------|
| `ballerina-project.<project>.build`       | Build the <project>                   |
| `ballerina-project.<project>.build.debug` | Build the <project> with remote debug |
| `ballerina-project.<project>.run`         | Run the <project>                     |
| `ballerina-project.<project>.run.debug`   | Run the <project> with remote debug   |

The following projects are available to be used along with the above targets and the `<project>` placeholder can be
replaced with one of the following.

| Project                   | Make Target Placeholder Replacement |
|---------------------------|-------------------------------------|
| Hello World Service       | `hello_world_service`               |
| Simple Passthrough        | `simple_passthrough`                |
| Chained Ballerina Service | `chained_ballerina_service`         |

### Miscellaneous Tools

The following targets can be used to startup miscellaneous tools.

| Make Target             | Description                                     |
|-------------------------|-------------------------------------------------|
| `misc.jaeger.start`     | Start a Jaeger Server in a Docker Container     |
| `misc.prometheus.start` | Start a Prometheus Server in a Docker Container |
| `misc.grafana.start`    | Start a Grafana Server in a Docker Container    |

## Contributions

This is meant to help any developers aiming to contribute to Ballerina. This project is not complete and can improve
in many ways. Contributions to the Ballerina Development Kit are highly welcome.
