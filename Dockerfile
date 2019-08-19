FROM ruby:2.6
RUN apt-get update

ENV WORK_DIR airport-hangout-frontend
ENV ENVIRONMENT test

RUN mkdir $WORK_DIR
WORKDIR $WORK_DIR

RUN bundle config --global frozen 1
COPY Gemfile Gemfile.lock ./
RUN gem install bundler
RUN bundle install
RUN gem install rails
RUN apt-get --yes install nodejs

COPY . .

EXPOSE 3000
CMD ["sh", "-c", "rails server -e ${ENVIRONMENT}"]
