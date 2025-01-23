FROM bellsoft/liberica-openjdk-alpine:23

ARG ACTIONLINT_VERSION
ARG HADOLINT_VERSION
ARG PRE_COMMIT_VERSION
ARG TERRAFORM_VERSION

RUN apk add --no-cache --update \
    bash~=5 \
    build-base~=0.5 \
    git~=2 \
    openntpd~=6 \
    py3-pip~=24 \
    python3-dev~=3.12 \
    yarn~=1.22 \
    curl~=8 \
    jq~=1.7 \
    yq~=4 \
    tflint~=0
RUN apk add --no-cache --update --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community \
    npm~=10
RUN python -m pip install --upgrade --no-cache-dir --break-system-packages \
    pre-commit==${PRE_COMMIT_VERSION} \
    setuptools==75.8.0

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
# coursier (needed for https://github.com/dustinsand/pre-commit-jvm)
RUN COURSIER_ARCH=$([ "$(uname -m)" = "aarch64" ] && echo "aarch64" || echo "x86_64") \
    && wget -O /usr/local/bin/coursier.gz -q https://github.com/coursier/launchers/raw/master/cs-${COURSIER_ARCH}-pc-linux.gz \
    && gzip -d /usr/local/bin/coursier.gz \
    && rm -f /usr/local/bin/coursier.gz \
    && chmod +x /usr/local/bin/coursier \
    && /usr/local/bin/coursier setup --yes

CMD bash
