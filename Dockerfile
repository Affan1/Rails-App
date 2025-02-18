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

# Set the working directory inside the container
WORKDIR /app

# Clone your Rails app repository into the container
ARG REPO_URL
ARG BRANCH=main
RUN echo "Cloning Repository: $REPO_URL on branch : $BRANCH"
RUN git clone $REPO_URL . && git checkout $BRANCH

# Install Bundler to manage gems
RUN gem install bundler

# Install Ruby gems
RUN bundle install

# Copy the rest of the application files into the container
COPY . /app

# Expose port 3000 for the Rails server
EXPOSE 5454

# Command to start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "5454"]
