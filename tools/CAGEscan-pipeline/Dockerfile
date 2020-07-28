FROM debian:stable
LABEL authors="charles.plessy@oist.jp"\
      description="Docker image containing all requirements for the nf-core CAGEscan-pipeline module"

# Install apt packages
RUN apt update &&\
    apt install -y build-essential git python3 last-align

# Install TagDust2
WORKDIR /home
RUN git clone https://gitlab.com/mcfrith/cagescan-pipeline                          &&\
    cp cagescan-pipeline/trivissemble cagescan-pipeline/cagescan-* /usr/bin         &&\
    git clone https://github.com/iskana/SlideSort                                   &&\
    cd SlideSort                                                                    &&\
    sed -i -e 's/dFile==NULL/!dFile/' -e 's/pFile==NULL/!pFile/' mst_v1/mstree.cpp  &&\
    /bin/sh mkall_v2.sh                                                             &&\
    cp mst_v2/ssmst_v2 /usr/bin
