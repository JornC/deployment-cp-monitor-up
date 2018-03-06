# Create a mostly-cacheable builder container that builds the pull request
FROM maven:3-jdk-8 as builder

ARG oAuthToken=local
ENV oAuthToken ${oAuthToken}

RUN apt update && apt upgrade -y \
    && apt install git
# install from nodesource using apt-get
# https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-an-ubuntu-14-04-server
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -yq nodejs build-essential

# fix npm - not the latest version installed by apt-get
RUN npm install -g npm bower
RUN echo '{ "allow_root": true }' > /root/.bowerrc

RUN mkdir /aerius-monitor-components
WORKDIR /aerius-monitor-components

RUN git init \
    && git pull https://${oAuthToken}@github.com/aerius/aerius-monitor-components.git \
    && git remote add origin https://${oAuthToken}@github.com/aerius/aerius-monitor-components.git

RUN git fetch \
    && git checkout origin/master

RUN mvn dependency:resolve -fn
RUN mvn install

WORKDIR ~

RUN mkdir aerius-monitor-web
WORKDIR aerius-monitor-web

RUN git init \
    && git pull https://${oAuthToken}@github.com/aerius/aerius-monitor-web.git \
    && git remote add origin https://${oAuthToken}@github.com/aerius/aerius-monitor-web.git \
    && mvn dependency:resolve -fn

ARG gitHash=local
ENV gitHash ${gitHash}

RUN git fetch origin \
    && git checkout ${gitHash}

RUN mvn install -DskipTests

RUN mv aerius-wui-monitor-up-client/target/monitorup.war /artifact.war

# Clean up the build container and start from a tomcat container, copying the artifact
FROM tomcat:9-jre8-alpine

RUN rm -rf /usr/local/tomcat/webapps/ROOT

RUN apk add --update \
    unzip

COPY --from=builder /artifact.war /ROOT.war
RUN mkdir /usr/local/tomcat/webapps/ROOT
RUN unzip /ROOT.war -d /usr/local/tomcat/webapps/ROOT/

EXPOSE 8009

LABEL cp.magic={{cp.magic}}
LABEL nl.aerius.docker.service=true
LABEL nl.aerius.docker.service.type=MONITORUP_WUI
LABEL nl.aerius.docker.service.prId={{cp.pr.id}}
LABEL nl.aerius.docker.service.hash={{service.local.hash}}

CMD ["catalina.sh", "run"]
