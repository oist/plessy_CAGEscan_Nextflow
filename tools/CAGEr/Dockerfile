FROM bioconductor/bioconductor_docker:RELEASE_3_11
LABEL authors="charles.plessy@oist.jp"\
      description="Docker image with the CAGEr package installed in."

RUN R -e 'BiocManager::install("CAGEr")'
