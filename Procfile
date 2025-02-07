# Procfile

# web process
web: bundle exec rails server -p $PORT -b 0.0.0.0

# non-web process
# worker: bundle exec sidekiq

# release phase command
release: bundle exec rails db:migrate