FROM ruby:2.4.1
ENV LANG C.UTF-8
ENV TZ 'Asia/Tokyo'

#----------------------------------------
# apt-utils
#----------------------------------------
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NOWARNINGS yes
#----------------------------------------
# Package
#----------------------------------------
RUN apt-get update && \
    apt-get install -y build-essential && \
    apt-get install -y libpq-dev && \
    apt-get install -y qt5-default && \
    apt-get install -y qt5-qmake && \
    apt-get install -y libqt5webkit5-dev && \
    apt-get install -y vim && \
    apt-get install -y nodejs npm && \
    apt-get install -y sqlite3 && \
    apt-get install -y sudo

#----------------------------------------
# Rails
#----------------------------------------
RUN mkdir /app
WORKDIR /app
COPY . /app
RUN bundle install