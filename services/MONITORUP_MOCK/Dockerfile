# Create a mostly-cacheable builder container that builds the pull request
FROM maven:3-jdk-8 as builder

ARG oAuthToken=local
ENV oAuthToken ${oAuthToken}

WORKDIR ~

RUN mkdir aerius-monitor-web
WORKDIR aerius-monitor-web

RUN git init \
    && git pull https://${oAuthToken}@github.com/aerius/aerius-monitor-web.git \
    && git remote add origin https://${oAuthToken}@github.com/aerius/aerius-monitor-web.git \
    && mvn dependency:resolve -fn

ARG gitHash=local
ENV gitHash ${gitHash}

ARG prId=local
ENV prId ${prId}

LABEL cp.magic={{cp.magic}}
LABEL nl.aerius.docker.service=true
LABEL nl.aerius.docker.service.type=MONITORUP_MOCK
LABEL nl.aerius.docker.service.prId={{cp.pr.id}}
LABEL nl.aerius.docker.service.hash={{service.local.hash}}

RUN git fetch origin
RUN git fetch origin pull/${prId}/head || true
RUN git checkout ${gitHash}

RUN mvn install -Pnoclient

WORKDIR aerius-service-mock
RUN mvn install

RUN mv target/aerius-service-mock.war /artifact.war

# Clean up the build container and start from a tomcat container, copying the artifact
FROM tomcat:9-jre8-alpine

RUN rm -rf /usr/local/tomcat/webapps/ROOT

RUN apk add --update \
    unzip

COPY --from=builder /artifact.war /ROOT.war
RUN mkdir /usr/local/tomcat/webapps/ROOT
RUN unzip /ROOT.war -d /usr/local/tomcat/webapps/ROOT/

LABEL cp.magic={{cp.magic}}
LABEL nl.aerius.docker.service=true
LABEL nl.aerius.docker.service.type=MONITORUP_MOCK
LABEL nl.aerius.docker.service.prId={{cp.pr.id}}
LABEL nl.aerius.docker.service.hash={{service.local.hash}}

ARG componentHost=local
ENV componentHost ${componentHost}

ARG selectorHost=local
ENV selectorHost ${selectorHost}

ENV CATALINA_OPTS="-Dmock.webcomponent.host='${componentHost}'"
ENV CATALINA_OPTS="-Dmock.selector.host='${selectorHost}'"

EXPOSE 8009

CMD ["catalina.sh", "run"]
