# alpine:3.17.3
FROM alpine@sha256:b6ca290b6b4cdcca5b3db3ffa338ee0285c11744b4a6abaa9627746ee3291d8d

ARG ACTIONLINT_VERSION
ARG PRE_COMMIT_VERSION
ARG HADOLINT_VERSION

RUN apk add --no-cache --update \
    bash=5.2.15-r0 \
    build-base=0.5-r3 \
    git=2.38.5-r0 \
    npm=9.1.2-r0 \
    openntpd=6.8_p1-r7 \
    py3-pip=22.3.1-r1 \
    python3-dev=3.10.11-r0
RUN python -m pip install --upgrade --no-cache-dir \
    pip==23.0.1 \
    pre-commit==${PRE_COMMIT_VERSION} \
    setuptools==67.6.1

# yq
RUN wget -O /usr/local/bin/yq -q https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 \
    && chmod +x /usr/local/bin/yq
# actionlint
RUN bash <(curl https://raw.githubusercontent.com/rhysd/actionlint/main/scripts/download-actionlint.bash) ${ACTIONLINT_VERSION}
# hadolint
RUN wget -O /usr/local/bin/hadolint -q https://github.com/hadolint/hadolint/releases/download/v${HADOLINT_VERSION}/hadolint-Linux-x86_64 \
    && chmod +x /usr/local/bin/hadolint

RUN adduser -D appuser
USER appuser

WORKDIR /app

CMD ["/bin/bash"]
