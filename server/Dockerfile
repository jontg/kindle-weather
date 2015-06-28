FROM ruby:2

RUN apt-get update -y && apt-get install -y librsvg2-bin

WORKDIR /tmp
ADD Gemfile /tmp/Gemfile
ADD Gemfile.lock /tmp/Gemfile.lock

RUN bundle install

ADD . /source
WORKDIR /source

CMD ["./weather-script.sh"]
