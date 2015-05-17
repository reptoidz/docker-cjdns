FROM fedora:21
MAINTAINER reptoidz

# Prepare
RUN { \
  export DEBIAN_FRONTEND=noninteractive; \
  yup update -y; \
  apt-get install -y git nodejs wget; \
  apt-get install -y @developement-tools; \
}

# Download
RUN { \
  mkdir -p /usr/src; \
  git clone https://github.com/cjdelisle/cjdns.git /usr/src/cjdns; \
}

# Build
RUN { \
  cd /usr/src/cjdns; \
  : git checkout -f $(git describe --abbrev=0 --tags --always); \
  ./do; \
}

# Install
RUN { \
  install -m755 -oroot -groot /usr/src/cjdns/cjdroute /usr/bin/cjdroute; \
  mkdir -p /etc/cjdns; \
}

COPY entry.sh /entry.sh
VOLUME /etc/cjdns
ENTRYPOINT ["/bin/bash", "/entry.sh"]
CMD ["cjdroute", "--nobg"]
