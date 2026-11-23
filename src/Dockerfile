FROM bellsoft/liberica-openjdk-alpine:27

ARG ACTIONLINT_VERSION
ARG HADOLINT_VERSION
ARG TERRAFORM_VERSION
ARG GO_VERSION
ARG TFLINT_VERSION
ARG NPM_VERSION

RUN apk upgrade --no-cache --update
RUN apk add --no-cache --update \
    bash \
    build-base \
    git \
    openntpd \
    py3-pip \
    python3-dev \
    yarn \
    curl \
    jq \
    yq \
    npm
RUN python -m pip install --upgrade --no-cache-dir --break-system-packages \
    prek \
    setuptools

# npm (replace the Alpine package in place: the modules it bundles carry known vulnerabilities)
RUN mkdir temp-npm \
    && wget -O temp-npm/npm.tgz -q https://registry.npmjs.org/npm/-/npm-${NPM_VERSION}.tgz \
    && rm -rf /usr/lib/node_modules/npm \
    && mkdir /usr/lib/node_modules/npm \
    && tar -xzf temp-npm/npm.tgz --directory /usr/lib/node_modules/npm --strip-components 1 \
    && rm -rf temp-npm

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
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
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
