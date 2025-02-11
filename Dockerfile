# Use a Ruby base image
FROM ruby:3.1

# Install dependencies for Rails
RUN apt-get update -qq && \
    apt-get install -y nodejs

# Set the working directory for the app
WORKDIR /rails

# Install Ruby gems (including Rails)
COPY Gemfile* ./
RUN bundle install

# Precompile Rails assets (if needed)
RUN bundle exec rake assets:precompile

# Expose port 3000 for the app
EXPOSE 3000

# Start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]
