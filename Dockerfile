FROM ruby:3.0.3

RUN gem install bundler

ENV HOME /fetch
WORKDIR $HOME
ADD . .
# Application dependencies
RUN bundle install

ENTRYPOINT ["./fetch.rb"]