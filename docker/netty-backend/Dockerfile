FROM ubuntu:20.04

ARG USER=ballerina-dev-kit
ARG USER_ID=1000
ARG USER_GROUP=ballerina-dev-kit
ARG USER_GROUP_ID=3000
ARG WORKING_DIR=/${USER}

RUN apt-get update && \
    apt-get install -y && \
    groupadd --gid=${USER_GROUP_ID} ${USER_GROUP} && \
    adduser --uid=${USER_ID} --gid=${USER_GROUP_ID} --home=${WORKING_DIR} --disabled-password --gecos "" ${USER}

USER ${USER_ID}:${USER_GROUP_ID}
WORKDIR ${WORKING_DIR}
EXPOSE 8688

COPY --chown=${USER_ID}:${USER_GROUP_ID} ./artifacts/repos/wso2/performance-common/components/netty-http-echo-service/target/netty-http-echo-service-*.jar ${WORKING_DIR}/

CMD ["java", "-XX:+UnlockExperimentalVMOptions", "-XX:+UseCGroupMemoryLimitForHeap", "-jar", "./netty-http-echo-service-*.jar"]
