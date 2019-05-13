#FROM debian:jessie
ARG NODE_VERSION=10
FROM node:${NODE_VERSION}-stretch

RUN apt-get update \
    && apt-get install -y python python-dev python-pip \
    && apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*

RUN pip install \
    python-language-server \
    flake8 \
    autopep8

ARG version=latest

WORKDIR /home/theia
ADD script/package.json ./package.json
ARG GITHUB_TOKEN
RUN yarn --cache-folder ./ycache && rm -rf ./ycache
RUN yarn theia build
EXPOSE 3000
ENV SHELL /bin/bash
#ENTRYPOINT [ "yarn", "theia", "start", "/home/project", "--hostname=0.0.0.0" ]

RUN apt-get update -qq && apt-get install -y -qq --no-install-recommends \
       python-pip git net-tools ssh vim pwgen apache2-utils netcat \
       && apt-get clean \
       && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN pip install -U pip setuptools virtualenv

RUN pip install awscli ansible==2.4.0 ansible-lint

RUN echo 'syntax on' >> /etc/vim/vimrc

COPY script/.bashrc /root/.bashrc
COPY script/wait-for-it.sh /usr/sbin/wait-for-it.sh
COPY script/cdt /cdt

ENV PATH="${PATH}:/"

ENTRYPOINT ["/bin/bash","-c"]
CMD [ "yarn theia start /opt/cdt --hostname=0.0.0.0" ]
