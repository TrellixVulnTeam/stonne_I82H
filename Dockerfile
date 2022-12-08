FROM ubuntu:20.04
ENTRYPOINT [ "/bin/bash" ]
WORKDIR /

ENV STONNE_FOLDER /STONNE
ENV DEBIAN_FRONTEND noninteractive

# Install dependencies and basic packages
RUN apt-get update && apt-get install -y \
        build-essential \
        cmake \
        git \
        python3 \
        python3-pip \
        python-is-python3 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip3 install --upgrade pip && pip3 install \
        numpy \
        pyyaml \
        setuptools \
        transformers

# TODO: add vision

# Download and build STONNE
RUN git clone https://github.com/stonne-simulator/stonne $STONNE_FOLDER
RUN cd $STONNE_FOLDER/stonne && make all

# Install Python Frontend
RUN cd $STONNE_FOLDER/pytorch-frontend && python setup.py install
RUN cd $STONNE_FOLDER/pytorch-frontend/stonne_connection/ && python setup.py install