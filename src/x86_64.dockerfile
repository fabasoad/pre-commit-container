FROM --platform=linux/amd64 bellsoft/liberica-openjdk-alpine:21

ARG ACTIONLINT_VERSION
ARG PRE_COMMIT_VERSION
ARG HADOLINT_VERSION
ARG TERRAFORM_VERSION

RUN apk add --no-cache --update \
    bash~=5 \
    build-base~=0.5 \
    git~=2 \
    openntpd~=6 \
    py3-pip~=23 \
    python3-dev~=3.11 \
    yarn~=1.22
RUN apk add --no-cache --update --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community \
    npm~=10
RUN python -m pip install --upgrade --no-cache-dir \
    pre-commit==${PRE_COMMIT_VERSION} \
    setuptools==69.0.3

# yq
RUN wget -O /usr/local/bin/yq -q https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 \
    && chmod +x /usr/local/bin/yq
# actionlint
RUN wget -O /usr/local/bin/actionlint.tar.gz -q https://github.com/rhysd/actionlint/releases/download/v${ACTIONLINT_VERSION}/actionlint_${ACTIONLINT_VERSION}_linux_amd64.tar.gz \
    && tar -xf /usr/local/bin/actionlint.tar.gz --directory /usr/local/bin \
    && rm -f /usr/local/bin/actionlint.tar.gz
# hadolint
RUN wget -O /usr/local/bin/hadolint -q https://github.com/hadolint/hadolint/releases/download/v${HADOLINT_VERSION}/hadolint-Linux-x86_64 \
    && chmod +x /usr/local/bin/hadolint
# coursier (needed for https://github.com/dustinsand/pre-commit-jvm)
RUN wget -O /usr/local/bin/coursier.gz -q https://github.com/coursier/launchers/raw/master/cs-x86_64-pc-linux.gz \
    && gzip -d /usr/local/bin/coursier.gz \
    && rm -f /usr/local/bin/coursier.gz \
    && chmod +x /usr/local/bin/coursier \
    && /usr/local/bin/coursier setup --yes
# terraform
RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && mv terraform /usr/local/bin/terraform

CMD ["/bin/bash"]
