FROM --platform=linux/arm64/v8 bellsoft/liberica-openjdk-alpine:23

ARG ACTIONLINT_VERSION
ARG PRE_COMMIT_VERSION
ARG HADOLINT_VERSION
ARG TERRAFORM_VERSION

RUN apk add --no-cache --update \
    bash~=5 \
    build-base~=0.5 \
    git~=2 \
    openntpd~=6 \
    py3-pip~=24 \
    python3-dev~=3.12 \
    yarn~=1.22
RUN apk add --no-cache --update --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community \
    npm~=10
RUN python -m pip install --upgrade --no-cache-dir --break-system-packages \
    pre-commit==${PRE_COMMIT_VERSION} \
    setuptools==75.1.0

# yq
RUN wget -O /usr/local/bin/yq -q https://github.com/mikefarah/yq/releases/latest/download/yq_linux_arm64 \
    && chmod +x /usr/local/bin/yq
# actionlint
RUN wget -O /usr/local/bin/actionlint.tar.gz -q https://github.com/rhysd/actionlint/releases/download/v${ACTIONLINT_VERSION}/actionlint_${ACTIONLINT_VERSION}_linux_arm64.tar.gz \
    && tar -xf /usr/local/bin/actionlint.tar.gz --directory /usr/local/bin \
    && rm -f /usr/local/bin/actionlint.tar.gz
# hadolint
RUN wget -O /usr/local/bin/hadolint -q https://github.com/hadolint/hadolint/releases/download/v${HADOLINT_VERSION}/hadolint-Linux-arm64 \
    && chmod +x /usr/local/bin/hadolint
# coursier (needed for https://github.com/dustinsand/pre-commit-jvm)
RUN wget -O /usr/local/bin/coursier.gz -q https://github.com/coursier/launchers/raw/master/cs-aarch64-pc-linux.gz \
    && gzip -d /usr/local/bin/coursier.gz \
    && rm -f /usr/local/bin/coursier.gz \
    && chmod +x /usr/local/bin/coursier \
    && /usr/local/bin/coursier setup --yes
# terraform
RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_arm64.zip \
    && unzip terraform_${TERRAFORM_VERSION}_linux_arm64.zip \
    && rm -f terraform_${TERRAFORM_VERSION}_linux_arm64.zip \
    && mv terraform /usr/local/bin/terraform
# tflint
RUN wget https://github.com/terraform-linters/tflint/releases/latest/download/tflint_linux_arm64.zip \
    && unzip tflint_linux_arm64.zip \
    && rm -f tflint_linux_arm64.zip \
    && mv tflint /usr/local/bin/tflint

CMD bash --version;git --version;pip --version;python --version;printf "yarn ";yarn --version;printf "npm ";npm --version;yq --version;printf "actionlint ";actionlint --version;printf "Hadolint. ";hadolint --version;printf "coursier ";coursier version;terraform --version;tflint --version;/bin/sh
