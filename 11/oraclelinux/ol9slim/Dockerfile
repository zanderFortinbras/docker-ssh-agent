FROM eclipse-temurin:11.0.18_10-jdk-focal AS jre-build
RUN jlink \
         --add-modules ALL-MODULE-PATH \
         --no-man-pages \
         --compress=2 \
         --output /javaruntime


FROM oraclelinux:9-slim

ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000
ARG JENKINS_AGENT_HOME=/home/${user}

ENV JENKINS_AGENT_HOME=${JENKINS_AGENT_HOME}
ARG AGENT_WORKDIR="${JENKINS_AGENT_HOME}"/agent
# Persist agent workdir path through an environment variable for people extending the image
ENV AGENT_WORKDIR=${AGENT_WORKDIR}

RUN groupadd -g ${gid} ${group} \
    && useradd -d "${JENKINS_AGENT_HOME}" -u "${uid}" -g "${gid}" -m -s /bin/bash "${user}" \
    # Prepare subdirectories
    && mkdir -p "${JENKINS_AGENT_HOME}/.ssh/" "${AGENT_WORKDIR}" "${JENKINS_AGENT_HOME}/.jenkins" "${JENKINS_AGENT_HOME}/.config/composer" \
    # Make sure that user 'jenkins' own these directories and their content
    && chown -R "${uid}":"${gid}" "${JENKINS_AGENT_HOME}" "${AGENT_WORKDIR}"


RUN microdnf module enable php:8.1
RUN microdnf -y install \
            git-lfs \
            less \
            nc \
            openssh-server \
            patch \
            hostname \
            php \
            php-cli \
            php-common \
            php-json \
            php-mbstring \
            php-mysqlnd \
            php-pdo \
            php-xml \
            curl \
            gnupg2 \
            tar \
            zip \
            wget \
            unzip \
            findutils \
            telnet \
            vi \
            yum \
           && microdnf clean all
CMD ["/bin/php", "-v"]
# setup SSH server
RUN sed -i /etc/ssh/sshd_config \
        -e 's/#PermitRootLogin.*/PubkeyAcceptedAlgorithms +ssh-rsa,ssh-rsa-cert-v01@openssh.com/' \
        -e 's/# no default banner path.*/HostKeyAlgorithms ssh-rsa,ssh-rsa-cert-v01@openssh.com/' \
        -e 's/#PermitRootLogin.*/PermitRootLogin no/' \
        -e 's/#RSAAuthentication.*/RSAAuthentication yes/'  \
        -e 's/#PasswordAuthentication.*/PasswordAuthentication no/' \
        -e 's/#SyslogFacility.*/SyslogFacility AUTH/' \
        -e 's/#LogLevel.*/LogLevel INFO/' && \
    mkdir /var/run/sshd

# VOLUME directive must happen after setting up permissions and content
VOLUME "${AGENT_WORKDIR}" "${JENKINS_AGENT_HOME}"/.jenkins "/tmp" "/run" "/var/run"
WORKDIR "${JENKINS_AGENT_HOME}"

ENV LANG='C.UTF-8' LC_ALL='C.UTF-8'

ENV JAVA_HOME=/opt/java/openjdk
ENV PATH="${JAVA_HOME}/bin:${PATH}"
COPY --from=jre-build /opt/java/openjdk $JAVA_HOME

RUN echo "PATH=${PATH}" >> /etc/environment

RUN whoami



RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN wget https://getcomposer.org/composer.phar -P /usr/local/bin
RUN ls -lart /usr/local/bin
RUN ls

RUN ls -lart
RUN ls -lart
RUN composer -v


COPY composer.json  "${JENKINS_AGENT_HOME}/.config/composer"
RUN chown -R "${uid}":"${gid}"  /home/jenkins/.config
RUN chown -R "${uid}":"${gid}"  /home/jenkins/.config/composer/
RUN chown -R "${uid}":"${gid}"  /home/jenkins/.config/composer/composer.json

COPY setup-sshd /usr/local/bin/setup-sshd
COPY ca-bundle.crt /etc/pki/tls/certs/ca-bundle.crt
#COPY /etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem /etc/pki/ca-trust/source/anchors/
#RUN update-ca-trust

#EXPOSE 22

USER root
ENTRYPOINT ["setup-sshd"]
RUN php /usr/local/bin/composer.phar --version

RUN ls -lart /usr/local/bin
RUN whoami
RUN sed -i /etc/php.ini \
        -e 's/memory_limit.*/memory_limit = -1 /'

LABEL \
    org.opencontainers.image.vendor="Jenkins project" \
    org.opencontainers.image.title="Official Jenkins SSH Agent Docker image" \
    org.opencontainers.image.description="A Jenkins agent image which allows using SSH to establish the connection" \
    org.opencontainers.image.url="https://www.jenkins.io/" \
    org.opencontainers.image.source="https://github.com/jenkinsci/docker-ssh-agent" \
    org.opencontainers.image.licenses="MIT"
