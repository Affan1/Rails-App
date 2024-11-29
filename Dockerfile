# Use a Ruby base image
FROM ruby:3.2.0

# Install essential dependencies
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    nodejs \
    yarn \
    sqlite3 \
    git

# Set environment variables for development
ENV RAILS_ENV=development \
    BUNDLE_PATH=/gems \
    BUNDLE_APP_CONFIG=/gems \
    BUNDLE_BIN=/gems/bin \
    PATH=/gems/bin:$PATH

# Set the working directory
WORKDIR /app

# Install Bundler to manage gems
RUN gem install bundler --full-index

# Clone your Rails app repository into the container
ARG REPO_URL
RUN git clone $REPO_URL /app

# Switch to the correct branch (if needed)
ARG BRANCH=main
RUN git checkout $BRANCH

# Install gems
RUN bundle install 

# Install JavaScript dependencies using Yarn
RUN yarn install --check-files

# Expose port 3000 for the Rails server
EXPOSE 3000

# Command to start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]
