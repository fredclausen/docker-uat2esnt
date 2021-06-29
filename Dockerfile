FROM debian:stable-slim

ENV BRANCH_RTLSDR="ed0317e6a58c098874ac58b769cf2e609c18d9a5" \
    S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
    URL_REPO_UAT2ESNT="https://github.com/adsbxchange/uat2esnt.git" \
    DUMP978_HOST=""

COPY rootfs/ /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN set -x && \
    TEMP_PACKAGES=() && \
    KEPT_PACKAGES=() && \
    # Required for building multiple packages.
    TEMP_PACKAGES+=(build-essential) && \
    TEMP_PACKAGES+=(pkg-config) && \
    TEMP_PACKAGES+=(cmake) && \
    TEMP_PACKAGES+=(git) && \
    TEMP_PACKAGES+=(automake) && \
    TEMP_PACKAGES+=(autoconf) && \
    TEMP_PACKAGES+=(wget) && \
    # logging
    KEPT_PACKAGES+=(gawk) && \
    # required for S6 overlay
    TEMP_PACKAGES+=(gnupg2) && \
    TEMP_PACKAGES+=(file) && \
    TEMP_PACKAGES+=(curl) && \
    TEMP_PACKAGES+=(ca-certificates) && \
    # dump978 dependencies
    TEMP_PACKAGES+=(libboost-dev) && \
    TEMP_PACKAGES+=(libboost-system1.67-dev) && \
    KEPT_PACKAGES+=(libboost-system1.67.0) && \
    TEMP_PACKAGES+=(libboost-program-options1.67-dev) && \
    KEPT_PACKAGES+=(libboost-program-options1.67.0) && \
    TEMP_PACKAGES+=(libboost-regex1.67-dev) && \
    KEPT_PACKAGES+=(libboost-regex1.67.0) && \
    TEMP_PACKAGES+=(libboost-filesystem1.67-dev) && \
    KEPT_PACKAGES+=(libboost-filesystem1.67.0) && \
    # uat2esnt dependencies (+ telegraf)
    KEPT_PACKAGES+=(socat) && \
    # install first round of packages
    apt-get update && \
    apt-get install -y --no-install-recommends \
        ${KEPT_PACKAGES[@]} \
        ${TEMP_PACKAGES[@]} \
        && \
    # Build & install uat2esnt
    git clone "${URL_REPO_UAT2ESNT}" "/src/uat2esnt" && \
    pushd "/src/uat2esnt" && \
    make all test && \
    cp -v ./uat2text /usr/local/bin/ && \
    cp -v ./uat2esnt /usr/local/bin/ && \
    cp -v ./uat2json /usr/local/bin/ && \
    cp -v ./extract_nexrad /usr/local/bin/ && \
    mkdir -p /run/uat2json && \
    # install S6 Overlay
    curl -s https://raw.githubusercontent.com/mikenye/deploy-s6-overlay/master/deploy-s6-overlay.sh | sh && \
    # Clean up
    apt-get remove -y ${TEMP_PACKAGES[@]} && \
    apt-get autoremove -y && \
    rm -rf /src/* /tmp/* /var/lib/apt/lists/* 

ENTRYPOINT [ "/init" ]
