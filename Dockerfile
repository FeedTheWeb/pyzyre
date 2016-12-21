FROM ubuntu:trusty
MAINTAINER wesyoung <wes@barely3am.com>

RUN DEBIAN_FRONTEND=noninteractive apt-get update -y -q
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q build-essential git-core libtool autotools-dev autoconf automake pkg-config unzip libkrb5-dev cmake uuid-dev cython python-virtualenv valgrind libffi-dev zip sudo python-pip

RUN useradd -d /home/zmq -m -s /bin/bash zmq
RUN mkdir -p /etc/sudoers.d
RUN echo "zmq ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/zmq
RUN chmod 0440 /etc/sudoers.d/zmq

USER zmq

WORKDIR /home/zmq
RUN git clone --quiet git://github.com/wesyoung/pyzyre.git pyzyre.git

WORKDIR /home/zmq/pyzyre.git
RUN sudo pip install pip --upgrade
RUN sudo pip install vex
RUN vex -m zyre pip install pip --upgrade
RUN vex zyre pip install cython --upgrade
RUN vex zyre pip install -r dev_requirements.txt
RUN vex zyre python setup.py build_ext bdist_wheel
RUN vex zyre pip install dist/*.whl
RUN rm -rf zyre czmq
RUN vex zyre python setup.py test