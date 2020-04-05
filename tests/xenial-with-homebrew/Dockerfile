FROM ubuntu:xenial

RUN apt-get update && apt-get install -y \
    python-minimal \
    python-pip \
    zsh \
    sudo \
    aptitude \
    locales \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment \
 && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
 && echo "LANG=en_US.UTF-8" > /etc/locale.conf \
 && locale-gen en_US.UTF-8

ARG user=test
ARG repository=ansible-pyenv

# Create test user
RUN useradd -m ${user} -s /bin/bash \
 && echo "${user}:${user}" | chpasswd \
 && adduser ${user} sudo \
 && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN touch /home/${user}/.zshrc \
 && chown -R ${user}:${user} /home/${user}

# Create directory for code
RUN mkdir -p /home/${user}/${repository} \
 && chown -R ${user}:${user} /home/${user}/${repository}
VOLUME ["/home/${user}/${repository}"]

ARG ansible_version="<2.9.0,!=2.8.6"
ENV ANSIBLE_VERSION="${ansible_version}"
RUN pip install ansible${ANSIBLE_VERSION}

# Homebrew installationg dependencies
RUN apt-get update && apt-get install -y \
    build-essential curl file git \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

ADD install_homebrew.sh /home/${user}/install_homebrew.sh
RUN sudo -i -u ${user} /home/${user}/install_homebrew.sh

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"
