#!/bin/bash
# adapted from @christruncer
# just and example
wget https://www.cobaltstrike.com/downloads/a24a41fcae308883d74f3b57e36e5bbb/cobaltstrike-trial.tgz
tar zxvf cobaltstrike-trial.tgz
sudo apt-get update -y
sudo apt-get install build-essential -y 
sudo add-apt-repository ppa:webupd8team/java -y 
sudo apt-get update -y 
sudo apt-get install oracle-java7-installer -y 
