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

LABEL cp.magic={{cp.magic}}
LABEL nl.aerius.docker.service=true
LABEL nl.aerius.docker.service.type=MONITORUP_COMPONENTS
LABEL nl.aerius.docker.service.prId={{cp.pr.id}}
LABEL nl.aerius.docker.service.hash={{service.local.hash}}

RUN git fetch \
    && git checkout origin/master

RUN mvn dependency:resolve -fn
RUN mvn install

RUN mv /aerius-monitor-components/target/aerius-web-components-1.0-SNAPSHOT.war /artifact.war

# Clean up the build container and start from a tomcat container, copying the artifact
FROM tomcat:9-jre8-alpine

#RUN rm -rf /usr/local/tomcat/webapps/

RUN apk add --update \
    unzip

COPY --from=builder /artifact.war /components.war
RUN mkdir /usr/local/tomcat/webapps/components
RUN unzip /components.war -d /usr/local/tomcat/webapps/components/

EXPOSE 8009

CMD ["catalina.sh", "run"]
