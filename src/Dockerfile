FROM bellsoft/liberica-openjdk-debian:27 AS jdk
FROM cgr.dev/chainguard/wolfi-base:latest@sha256:be019c1c74fe69204a42c4e10bc4d886a49bf5403ffa74374ef7baa408fc9a26

# JDK 27 (Liberica, glibc build) copied from the Debian image: Wolfi repos
# top out at openjdk-26, and this keeps the exact JDK the project ships.
COPY --from=jdk /usr/lib/jvm /usr/lib/jvm
RUN ln -s /usr/lib/jvm/jdk-* /opt/java
ENV JAVA_HOME=/opt/java
ENV PATH="${PATH}:${JAVA_HOME}/bin"

ARG ACTIONLINT_VERSION
ARG HADOLINT_VERSION
ARG TERRAFORM_VERSION
ARG GO_VERSION
ARG TFLINT_VERSION
ARG NPM_VERSION
ARG NODE_VERSION=24.22.3
ARG YQ_VERSION=4.54.3

# system packages (Wolfi apk; Node/yarn/yq/npm come from upstream below —
# that is the configuration whose scan was measured for this migration)
RUN apk upgrade --no-cache --update \
    && apk add --no-cache \
        bash \
        build-base \
        git \
        chrony \
        python3 \
        python3-dev \
        py3-pip \
        curl \
        wget \
        unzip \
        jq \
        ca-certificates
RUN python3 -m pip install --upgrade --no-cache-dir --break-system-packages \
    prek \
    setuptools

# node (official tarball; version matches what the Alpine image shipped)
RUN NODE_ARCH="$([ "$(uname -m)" = "aarch64" ] && echo "arm64" || echo "x64")" \
    && wget -O /tmp/node.tar.gz -q https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-${NODE_ARCH}.tar.gz \
    && tar -xzf /tmp/node.tar.gz --directory /usr/local --strip-components 1 \
    && rm -f /tmp/node.tar.gz

# npm (replace the bundled npm in place, same as the Alpine image)
RUN mkdir temp-npm \
    && wget -O temp-npm/npm.tgz -q https://registry.npmjs.org/npm/-/npm-${NPM_VERSION}.tgz \
    && rm -rf /usr/local/lib/node_modules/npm \
    && mkdir /usr/local/lib/node_modules/npm \
    && tar -xzf temp-npm/npm.tgz --directory /usr/local/lib/node_modules/npm --strip-components 1 \
    && rm -rf temp-npm

# yarn (classic, as the Alpine package shipped)
RUN npm install -g yarn@1.22.22

# yq (mikefarah; the binary Alpine's yq package contains)
RUN YQ_ARCH="$([ "$(uname -m)" = "aarch64" ] && echo "arm64" || echo "amd64")" \
    && wget -O /usr/local/bin/yq -q https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_${YQ_ARCH} \
    && chmod +x /usr/local/bin/yq

# go
RUN GO_ARCH="$([ "$(uname -m)" = "aarch64" ] && echo "arm64" || echo "amd64")" \
    && wget -O /usr/local/bin/go.tar.gz -q https://go.dev/dl/go${GO_VERSION}.linux-${GO_ARCH}.tar.gz \
    && tar -xf /usr/local/bin/go.tar.gz --directory /usr/local/bin \
    && rm -f /usr/local/bin/go.tar.gz

ENV GOROOT="/usr/local/bin/go"
ENV GOPATH="/go"
ENV GOBIN="${GOROOT}/bin"
ENV PATH="${PATH}:${GOBIN}:${GOPATH}/bin"

# golangci-lint
ARG GOLANGCI_LINT_VERSION=2.15.0
SHELL ["/bin/bash", "-eo", "pipefail", "-c"]
RUN wget -O- -nv https://golangci-lint.run/install.sh | sh -s "v${GOLANGCI_LINT_VERSION}"

# actionlint
RUN ACTIONLINT_ARCH=$([ "$(uname -m)" = "aarch64" ] && echo "arm64" || echo "amd64") \
    && mkdir temp-actionlint \
    && wget -O temp-actionlint/actionlint.tar.gz -q https://github.com/rhysd/actionlint/releases/download/v${ACTIONLINT_VERSION}/actionlint_${ACTIONLINT_VERSION}_linux_${ACTIONLINT_ARCH}.tar.gz \
    && tar -xf temp-actionlint/actionlint.tar.gz --directory temp-actionlint \
    && mv temp-actionlint/actionlint /usr/local/bin/actionlint \
    && rm -rf temp-actionlint

# hadolint
RUN HADOLINT_ARCH=$([ "$(uname -m)" = "aarch64" ] && echo "arm64" || echo "x86_64") \
    && wget -O /usr/local/bin/hadolint -q https://github.com/hadolint/hadolint/releases/download/v${HADOLINT_VERSION}/hadolint-Linux-${HADOLINT_ARCH} \
    && chmod +x /usr/local/bin/hadolint

# terraform
RUN TERRAFORM_ARCH=$([ "$(uname -m)" = "aarch64" ] && echo "arm64" || echo "amd64") \
    && mkdir temp-terraform \
    && wget -O temp-terraform/terraform.zip -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${TERRAFORM_ARCH}.zip \
    && unzip temp-terraform/terraform.zip -d temp-terraform \
    && mv temp-terraform/terraform /usr/local/bin/terraform \
    && rm -rf temp-terraform

# tflint
RUN TFLINT_ARCH=$([ "$(uname -m)" = "aarch64" ] && echo "arm64" || echo "amd64") \
    && mkdir temp-tflint \
    && wget -O temp-tflint/tflint.zip -q https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/tflint_linux_${TFLINT_ARCH}.zip \
    && unzip temp-tflint/tflint.zip -d temp-tflint \
    && mv temp-tflint/tflint /usr/local/bin/tflint \
    && chmod +x /usr/local/bin/tflint \
    && rm -rf temp-tflint

# coursier (needed for https://github.com/dustinsand/pre-commit-jvm)
ARG COURSIER_VERSION=2.1.27
RUN COURSIER_ARCH=$([ "$(uname -m)" = "aarch64" ] && echo "aarch64" || echo "x86_64") \
    && wget -O /usr/local/bin/coursier.gz -q https://github.com/coursier/coursier/releases/download/v${COURSIER_VERSION}/cs-${COURSIER_ARCH}-pc-linux.gz \
    && gzip -d /usr/local/bin/coursier.gz \
    && rm -f /usr/local/bin/coursier.gz \
    && chmod +x /usr/local/bin/coursier \
    && /usr/local/bin/coursier setup --yes --apps scala-cli,scala,scalac,sbt,scalafmt

CMD bash
