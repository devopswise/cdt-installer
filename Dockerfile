FROM debian:jessie

RUN apt-get update -qq && apt-get install -y -qq --no-install-recommends \
       python-pip git net-tools ssh vim pwgen apache2-utils \
       && apt-get clean \
       && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN pip install -U pip setuptools virtualenv

RUN pip install awscli ansible==2.4.0

RUN echo 'syntax on' >> /etc/vim/vimrc

COPY script/.bashrc /root/.bashrc
COPY script/cdt /cdt

ENV PATH="${PATH}:/"

ENTRYPOINT ["/bin/bash","-c"]
CMD ["sleep infinity"]
