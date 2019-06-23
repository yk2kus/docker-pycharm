FROM ubuntu:18.04

LABEL maintainer "Viktor Adam <rycus86@gmail.com>"

RUN apt-get update && apt-get install --no-install-recommends -y \
  wget python python-dev python-setuptools python-pip \
  python3 python3-dev python3-setuptools python3-pip \
  gcc git openssh-client less curl \
  libxtst-dev libxext-dev libxrender-dev libfreetype6-dev \
  libfontconfig1 libgtk2.0-0 libxslt1.1 libxxf86vm1 \
  && rm -rf /var/lib/apt/lists/* 

RUN wget -O /tmp/pycharm.tar.gz https://download.jetbrains.com/python/pycharm-community-182.4323.5.tar.gz && mkdir -p /usr/share/pycharm \
    && tar -xf /tmp/pycharm.tar.gz --strip-components=1 -C /usr/share/pycharm \
    && rm /tmp/pycharm.tar.gz


#############PYCHARM
RUN apt-get update && apt-get install -y \
            # To avoid:
            #   Gtk-Message: Failed to load module "gail"
            #   Gtk-Message: Failed to load module "atk-bridge"
            libatk-adaptor \
            libgail-common \
        # Install Java JDK
        # This is in accordance to : https://www.digitalocean.com/community/tutorials/how-to-install-java-with-apt-get-on-ubuntu-16-04
        && apt-get update && apt-get install -y \
            ant \
            libcanberra-gtk* \
            openjdk-8-jdk \
        && rm -rf /var/lib/apt/lists/* \
        && rm -rf /var/cache/oracle-jdk8-installer \
        # Fix certificate issues, found as of
        # https://bugs.launchpad.net/ubuntu/+source/ca-certificates-java/+bug/983302
        && apt-get update && apt-get install -y \
            ca-certificates-java \
        && update-ca-certificates -f \
        && rm -rf /var/lib/apt/lists/* \
        && rm -rf /var/cache/oracle-jdk8-installer \
        # Install Pycharm
        && echo "Downloading and installing pycharm-community..." \
        && echo "PyCharm installed" \
        && rm -rf /var/lib/apt/lists/* \
        && apt-get clean \
        && apt-get -y autoremove \
        && sync
# Setup JAVA_HOME, this is useful for docker commandline
#ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
#RUN export JAVA_HOME

RUN useradd --system  --home /opt --shell /bin/bash  --uid 1000 odoo && \
    mkdir -p /opt/odoo && mkdir -p /opt/filestore

COPY .PyCharmCE2018.2 /opt/.PyCharmCE2018.2
RUN chown -R odoo:odoo  /opt/.PyCharmCE2018.2
USER odoo
CMD ["/usr/share/pycharm/bin/pycharm.sh"]

