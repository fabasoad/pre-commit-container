FROM --platform=linux/arm64/v8 bellsoft/liberica-openjdk-alpine:20

ARG ACTIONLINT_VERSION
ARG PRE_COMMIT_VERSION
ARG HADOLINT_VERSION

RUN apk add --no-cache --update \
    bash~=5 \
    build-base~=0.5 \
    git~=2 \
    npm~=9 \
    openntpd~=6 \
    py3-pip~=23 \
    python3-dev~=3.11 \
    yarn~=1.22
RUN python -m pip install --upgrade --no-cache-dir \
    pre-commit==${PRE_COMMIT_VERSION} \
    setuptools==67.8.0

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

CMD ["/bin/bash"]
