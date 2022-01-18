ARG buildno=""
ARG gitcommithash=""
ARG NODE_VERSION=""
ARG VARIANT=""
ARG NODE_VERSION="true"
ARG INSTALL_ZSH="true"
ARG USERNAME=""
ARG USER_UID=1000
ARG USER_GID=${USER_UID}
ARG DEBIAN_FRONTEND=noninteractive
ARG USER_HOME="/home/${USERNAME}"
# [Choice] PHP version (use -bullseye variants on local arm64/Apple Silicon): 8, 8.0, 7, 7.4, 7.3, 8-bullseye, 8.0-bullseye, 7-bullseye, 7.4-bullseye, 7.3-bullseye, 8-buster, 8.0-buster, 7-buster, 7.4-buster, 7.3-buster
FROM alpha2omega_php:8.1.0RC5-apache-buster
RUN echo "Build number: $buildno"
RUN echo "Based on commit: $gitcommithash"
# #################################################
# ## Docker PHP Extension Installer
# # https://github.com/mlocati/docker-php-extension-installer
# ## Download the "install-php-extensions" script and copy to 
# ##   this image into /usr/local/bin
# # ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
# COPY --from=mlocati/php-extension-installer:1.2.24 /usr/bin/install-php-extensions /usr/local/bin/
# RUN chmod +x /usr/local/bin/install-php-extensions && sync
# #################################################
# # EXTENSIONS INSTALLATION
# RUN /usr/local/bin/install-php-extensions \
# bcmath \
# bz2 \
# curl \
# calendar \
# decimal \
# ffi \
# ftp \
# fileinfo \
# gettext \
# gmp \
# intl \
# imap \
# json \
# ldap \
# mbstring \
# exif \
# memcached \
# mysqli \
# oauth \
# odbc \
# opcache \
# openssl \
# PDO \
# pdo_mysql \
# pdo_odbc \
# pdo_sqlite \
# pgsql \
# redis \
# shmop \
# soap \
# sockets \
# sodium \
# sqlite3 \
# ssh2 \
# # tensor \
# tidy \
# xdebug

# #################################################
# # Install MariaDB client
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get install -y mariadb-client 
#     # && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# # Install php-mysql driver
# RUN docker-php-ext-install mysqli pdo pdo_mysql 

# # RUN docker-php-ext-install openssl_udf
# # [Choice] Node.js version: none, lts/*, 16, 14, 12, 10
# ARG NODE_VERSION="none"
# RUN if [ "${NODE_VERSION}" != "none" ]; then su vscode -c \
#     "umask 0002 && . /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi

# # [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends sendmail
RUN apt-get update \
    && apt-get -y install  sendmail
    # && apt-get clean -y && rm -rf /var/lib/apt/lists/*


# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends python3 python3-pip

COPY library-scripts/* /tmp/library-scripts/
RUN ls -lia /tmp/library-scripts
# RUN if [[ -f  "/tmp/library-scripts/common-debian.sh"  ]]; then \
#         cat "/tmp/library-scripts/common-debian.sh"; else exit 1; fi;
# # Setup user environment
RUN apt-get update \
    && /bin/bash /tmp/library-scripts/common-debian.sh \
    "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "true" "true" "true"
# RUN pip install -U mycli
# [Optional] Uncomment this line to install global node packages.
# RUN su vscode -c "source /usr/local/share/nvm/nvm.sh && npm install -g <your-package-here>" 2>&1
