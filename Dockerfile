FROM ubuntu:15.04

MAINTAINER Stockflare <info@stockflare.com>

# Install Ruby
RUN apt-get dist-upgrade
RUN apt-get -y update
RUN apt-get -y install build-essential zlib1g-dev libssl-dev libreadline6-dev libyaml-dev
RUN apt-get -y install wget libgtkmm-2.4 libsasl2-dev mysql-client mysql-common curl libmysqlclient-dev
RUN apt-get -y install libnotify-dev imagemagick libglib2.0-bin git-core curl ca-certificates

RUN wget http://ftp.ruby-lang.org/pub/ruby/2.1/ruby-2.1.2.tar.gz
RUN tar -xvzf ruby-2.1.2.tar.gz
RUN cd ruby-2.1.2 && ./configure --prefix=/usr/local && make && make install

# Remove Ruby download
RUN rm ruby-2.1.2.tar.gz

# Install FeedJira native extension dependencies
RUN apt-get install -y libcurl3 libcurl3-gnutls libcurl4-openssl-dev

# Update any CA Certificates
RUN update-ca-certificates

# Setup the working directory
WORKDIR /serch

# Install Bundler
RUN gem install bundler

# Add the application to the container (cwd)
ADD ./ /serch

# Bundle install the applications gem dependencies
RUN bundle install

# Setup the entrypoint
ENTRYPOINT ["bundle", "exec"]
