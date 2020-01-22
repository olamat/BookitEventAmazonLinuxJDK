FROM amazonlinux:latest as builder
RUN yum install -y tar gzip
RUN mkdir -p /opt/java
WORKDIR /opt/java
RUN curl -L -o openjdk13.tar.gz https://github.com/AdoptOpenJDK/openjdk13-binaries/releases/download/jdk-13.0.1%2B9/OpenJDK13U-jdk_x64_linux_hotspot_13.0.1_9.tar.gz
RUN tar -xzf openjdk13.tar.gz
RUN ln -s /opt/java/jdk-13.0.1+9 /opt/java/current
ENV JAVA_HOME=/opt/java/current
ENV PATH=$PATH:${JAVA_HOME}/bin
RUN "$JAVA_HOME"/bin/jlink \
--module-path "$JAVA_HOME"/jmods/ \
--compress=2 \
--add-modules java.base,java.logging,java.naming,java.desktop,java.management,java.sql,java.security.jgss,java.instrument,jdk.crypto.ec,jdk.unsupported \
--no-header-files \
--no-man-pages \
--output /opt/jdk-mini

FROM amazonlinux:latest
COPY --from=builder /opt/jdk-mini /opt/jdk-mini
ENV JAVA_HOME=/opt/jdk-mini
ENV PATH="$PATH:$JAVA_HOME/bin"

