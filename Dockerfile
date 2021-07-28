FROM rocker/rstudio:4.0.5

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8

RUN apt-get update
RUN apt install -y gnupg software-properties-common
RUN wget -qO - https://qgis.org/downloads/qgis-2020.gpg.key | gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/qgis-archive.gpg --import
RUN chmod a+r /etc/apt/trusted.gpg.d/qgis-archive.gpg
RUN add-apt-repository "deb https://qgis.org/ubuntu $(lsb_release -c -s) main"

RUN apt update
RUN apt install -y qgis qgis-plugin-grass

RUN mkdir rscripts
COPY /requirements.R /rscripts/
RUN chmod a+rwx /rscripts/requirements.R

RUN Rscript -e 'install.packages("remotes", repos="https://cloud.r-project.org")'
RUN Rscript -e 'remotes::install_github("paleolimbot/qgisprocess")'
RUN Rscript requirements.R
