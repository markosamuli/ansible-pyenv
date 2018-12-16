FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    python-minimal \
    python-pip \
 && rm -rf /var/lib/apt/lists/*

RUN pip install ansible

RUN apt-get update && apt-get install -y \
    zsh \
 && rm -rf /var/lib/apt/lists/*

RUN touch /root/.zshrc

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"
