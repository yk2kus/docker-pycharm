FROM yk2kus/odoo:odoo120

LABEL maintainer "Yogesh Kushwaha <yogeshkushwaha4@gmail.com>"
USER root
RUN apt-get update && apt-get install --no-install-recommends -y \
  wget python python-dev python-setuptools python-pip \
  python3 python3-dev python3-setuptools python3-pip \
  gcc git openssh-client less curl \
  libxtst-dev libxext-dev libxrender-dev libfreetype6-dev \
  libfontconfig1 libgtk2.0-0 libxslt1.1 libxxf86vm1 \
  && rm -rf /var/lib/apt/lists/*

RUN wget -O /tmp/pycharm.tar.gz https://download.jetbrains.com/python/pycharm-community-2019.1.3.tar.gz && mkdir -p /usr/share/pycharm \
    && tar -xf /tmp/pycharm.tar.gz --strip-components=1 -C /usr/share/pycharm \
    && rm /tmp/pycharm.tar.gz


COPY .PyCharmCE2019.1 /opt/.PyCharmCE2019.1
RUN chown -R odoo:odoo  /opt/.PyCharmCE2019.1
USER odoo
ENTRYPOINT ["/usr/share/pycharm/bin/pycharm.sh"]


### RUN below command
## docker build -t test . ; docker run  -e DISPLAY=$DISPLAY  -v /tmp/.X11-unix:/tmp/.X11-unix test