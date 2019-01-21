# BUILD INSTRUCTIONS & README
# POST HERE: https://blog.obscuritylabs.com/docker-command-controll-c2/
#   1) docker build --build-arg cskey="xxxx-xxxx-xxxx-xxxx" -t cobaltstrike/cs .
#   2) docker run -d -p 192.168.2.238:50050:50050 cobaltstrike/cs 192.168.2.238 password
#      - This runs docker in Detached mode, to tshoot issues or see logs do the following
#   3) docker logs -f {docker ps -> CONTAINER ID}
#      - Example: docker logs -f 38830d90537f
#    NOTE: you can eaily name the docker like so as well:
#      - docker run -d -p 192.168.2.238:50050:50050 --name "war_games"  cobaltstrike/cs 192.168.2.238 password
#      - docker logs -f "war_games"
#      - To kill CS: docker kill war_games
#    NOTE: to go interactive we need to bypass the ENTRYPOINT
#      - docker run -ti --entrypoint "" cobaltstrike/cs bash
FROM ubuntu:16.04

# Dockerfile metadata
MAINTAINER Killswitch-GUI
LABEL version="1.0"
LABEL description="Dockerfile base for CobaltStrike."

# setup local env
ARG cskey
ENV cs_key ${cskey}
ENV JAVA_HOME /opt/jdk-10.0.2
ENV PATH $PATH:$JAVA_HOME/bin

# docker hardcoded sh...
SHELL ["/bin/bash", "-c"]

# install proper tools & java
RUN apt-get update && \
    apt-get install -y wget curl net-tools sudo default-jdk

# install CobaltStrike with license key and update
RUN var=$(curl 'https://www.cobaltstrike.com/download' -XPOST -H 'Referer: https://www.cobaltstrike.com/download' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Origin: https://www.cobaltstrike.com' -H 'Host: www.cobaltstrike.com' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' -H 'Connection: keep-alive' -H 'Accept-Language: en-us' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_1) AppleWebKit/604.3.5 (KHTML, like Gecko) Version/11.0.1 Safari/604.3.5' --data "dlkey=$cs_key" | sed -n 's/.*href="\([^"]*\).*/\1/p' | grep /downloads/ | cut -d '.' -f 1) && \
    cd /opt && \
    wget https://www.cobaltstrike.com$var.tgz && \
    tar xvf cobaltstrike-trial.tgz && \
    cd cobaltstrike && \
    echo $cs_key > ~/.cobaltstrike.license && \
    ./update

# cleanup image
RUN apt-get -y clean && \
    apt-get -y autoremove

# set entry point
WORKDIR "/opt/cobaltstrike"
ENTRYPOINT ["./teamserver"]
