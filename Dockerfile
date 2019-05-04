FROM registry.access.redhat.com/codeready-workspaces/stacks-java:1.1

USER root

RUN wget -O /usr/local/bin/odo https://github.com/redhat-developer/odo/releases/download/v0.0.20/odo-linux-amd64 && chmod a+x /usr/local/bin/odo

RUN wget -O /tmp/oc.tar.gz https://mirror.openshift.com/pub/openshift-v4/clients/oc/4.1/linux/oc.tar.gz && cd /usr/bin && tar -xvzf /tmp/oc.tar.gz && chmod a+x /usr/bin/oc && rm -f /tmp/oc.tar.gz

RUN wget -O /tmp/mvn.tar.gz http://www.eu.apache.org/dist/maven/maven-3/3.6.0/binaries/apache-maven-3.6.0-bin.tar.gz

RUN tar xzf /tmp/mvn.tar.gz && rm -rf /tmp/mvn.tar.gz && mkdir /usr/local/maven && mv apache-maven-3.6.0/ /usr/local/maven/ && alternatives --install /usr/bin/mvn mvn /usr/local/maven/apache-maven-3.6.0/bin/mvn 1

ENV PATH="/usr/local/maven/apache-maven-3.6.0/bin:${PATH}"

ENV MAVEN_OPTS="-Xmx1024M -Xss128M -XX:MetaspaceSize=512M -XX:MaxMetaspaceSize=1024M -XX:+CMSClassUnloadingEnabled"


RUN chown -R jboss /home/jboss/.m2
USER jboss

RUN cd /tmp && git clone https://github.com/jamesfalkner/summit-2019-devzone && cd summit-2019-devzone && mvn clean compile package && mvn clean && cd /projects && rm -rf /tmp/summit-2019-devzone
