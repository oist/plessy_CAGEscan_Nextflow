FROM nfcore/base:1.10
LABEL authors="charles.plessy@oist.jp" \
      description="Docker image containing all requirements for the CAGEscan-pipeline BBMap module"

# Install conda packages
COPY environment.yml /
RUN conda env create -f /environment.yml && conda clean -a
ENV PATH /opt/conda/envs/CAGEscan-pipeline-module-BBMap/bin:$PATH
