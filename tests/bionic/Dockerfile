FROM ubuntu:bionic

RUN apt-get update && apt-get install -y \
    python-minimal \
    python-pip \
 && rm -rf /var/lib/apt/lists/*

ARG ansible_version="<2.8.0"
ENV ANSIBLE_VERSION="${ansible_version}"
RUN pip install ansible${ANSIBLE_VERSION}

RUN apt-get update && apt-get install -y \
    zsh \
    sudo \
 && rm -rf /var/lib/apt/lists/*

# Create test user
RUN useradd -m test -s /bin/bash \
 && echo "test:test" | chpasswd \
 && adduser test sudo \
 && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN touch /home/test/.zshrc && chown -R test:test /home/test

# Create directory for code
RUN mkdir -p /home/test/ansible-pyenv ; chown -R test:test /home/test/ansible-pyenv
VOLUME ["/home/test/ansible-pyenv"]

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"
