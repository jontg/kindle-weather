FROM ruby:2

RUN apt-get update -y && apt-get install -y librsvg2-bin pngcrush

RUN echo America/Los_Angeles | tee /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata

ENV CONFIG_ROOT "/source/config"
VOLUME [ "/config", "/output" ]

WORKDIR /tmp
ADD Gemfile /tmp/Gemfile
ADD Gemfile.lock /tmp/Gemfile.lock

RUN bundle install

ADD . /source
WORKDIR /source

CMD ["./weather-script.sh"]
