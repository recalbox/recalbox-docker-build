FROM ubuntu:15.10
MAINTAINER Mika <mika@recalbox.com>

# Set the locale needed by toolchain
RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8  

# Install dependencies
#needed ? xterm
RUN echo $PATH
RUN apt-get update -y && \
apt-get -y install build-essential git libncurses5-dev qt5-default qttools5-dev-tools \
mercurial libdbus-glib-1-dev texinfo zip openssh-client \ 
software-properties-common wget cpio bc && \
add-apt-repository -y ppa:openjdk-r/ppa && \
apt-get update -y && \
apt-get install -y openjdk-8-jdk

RUN mkdir -p /usr/share/recalbox
VOLUME ["/usr/share/recalbox/repo"]
WORKDIR /usr/share/recalbox

#needed by script
ENV RECALBOXDIR /usr/share/recalbox
ENV REPO /usr/share/recalbox/repo


ADD ./bin /usr/local/bin

CMD ["bash"]
