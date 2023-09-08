ARG version=22.04
# version is passed through by Docker.
# shellcheck disable=SC2154
FROM ubuntu:"${version}"
ARG DEBIAN_FRONTEND=noninteractive
ARG ruby_version=2.6.10
ARG portable_ruby_version=2.6.10_1

# We don't want to manually pin versions, happy to use whatever
# Ubuntu thinks is best.
# hadolint ignore=DL3008

# /etc/lsb-release is checked inside the container and sets DISTRIB_RELEASE.
# We need `[` instead of `[[` because the shell is `/bin/sh`.
# shellcheck disable=SC1091,SC2154,SC2292
RUN apt-get update \
  && apt-get install -y --no-install-recommends software-properties-common gnupg-agent \
  && add-apt-repository -y ppa:git-core/ppa \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
  acl \
  bzip2 \
  ca-certificates \
  curl \
  file \
  fonts-dejavu-core \
  g++ \
  gawk \
  git \
  gpg \
  less \
  libreadline-dev \
  libz-dev \
  locales \
  make \
  netbase \
  openssh-client \
  patch \
  sudo \
  unzip \
  uuid-runtime \
  tzdata \
  jq \
  && if [ "$(. /etc/lsb-release; echo "${DISTRIB_RELEASE}" | cut -d. -f1)" -ge 22 ]; then apt-get install -y --no-install-recommends skopeo; fi \
  && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
  && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
  && apt-get update \
  && apt-get install -y --no-install-recommends gh \
  && apt-get remove --purge -y software-properties-common \
  && apt-get autoremove --purge -y \
  && rm -rf /var/lib/apt/lists/* \
  && sed -i -E '/^session optional\s+pam_umask\.so$/ s/$/ umask=0022/' /etc/pam.d/common-session \
  && sed -i -E '/^session optional\s+pam_umask\.so$/ s/$/ umask=0022/' /etc/pam.d/common-session-noninteractive \
  && localedef -i en_US -f UTF-8 en_US.UTF-8 \
  && useradd -m -s /bin/bash linuxbrew \
  && echo 'linuxbrew ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers \
  && su - linuxbrew -c 'mkdir ~/.linuxbrew'

USER linuxbrew
ENV PATH="/home/linuxbrew/.rbenv/bin:/home/linuxbrew/.rbenv/versions/${ruby_version}/bin:${PATH}"
ENV PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:${PATH}"
WORKDIR /home/linuxbrew

RUN git clone https://github.com/rbenv/rbenv.git .rbenv \
  && git clone https://github.com/rbenv/ruby-build.git .rbenv/plugins/ruby-build \
  && rbenv install "${ruby_version}" \
  && mkdir -p .linuxbrew/Homebrew \
  && git clone https://github.com/Homebrew/brew.git .linuxbrew/Homebrew \
  && mkdir -p .linuxbrew/Homebrew/Library/Homebrew/vendor/portable-ruby \
  && ln -s "/home/linuxbrew/.rbenv/versions/${ruby_version}" ".linuxbrew/Homebrew/Library/Homebrew/vendor/portable-ruby/${portable_ruby_version}" \
  && ln -s "${portable_ruby_version}" .linuxbrew/Homebrew/Library/Homebrew/vendor/portable-ruby/current

RUN mkdir -p \
  .linuxbrew/bin \
  .linuxbrew/etc \
  .linuxbrew/include \
  .linuxbrew/lib \
  .linuxbrew/opt \
  .linuxbrew/sbin \
  .linuxbrew/share \
  .linuxbrew/var/homebrew/linked \
  .linuxbrew/Cellar \
  && ln -s ../Homebrew/bin/brew .linuxbrew/bin/brew \
  && git -C .linuxbrew/Homebrew remote set-url origin https://github.com/Homebrew/brew \
  && git -C .linuxbrew/Homebrew fetch origin \
  && HOMEBREW_NO_ANALYTICS=1 HOMEBREW_NO_AUTO_UPDATE=1 brew tap --force homebrew/core \
  && brew install-bundler-gems \
  && brew cleanup \
  && { git -C .linuxbrew/Homebrew config --unset gc.auto; true; } \
  && { git -C .linuxbrew/Homebrew config --unset homebrew.devcmdrun; true; } \
  && rm -rf .cache \
  && touch .linuxbrew/.homebrewdocker
