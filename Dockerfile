FROM ruby:3.1 

# Install dependencies
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    curl gnupg \
    nodejs

WORKDIR /app

COPY Gemfile .
COPY Gemfile.lock .

# Install gems
RUN bundle install

RUN mkdir -p frontend

# Copy frontend scripts
COPY frontend/package*.json frontend/

# Install frontend deps
ENV NODE_ENV=production
RUN npm ci --prefix=./frontend

# Copy everything in
COPY . ./

# This will also copy the frontend build into public/
RUN rake frontend

# Cleanup (don't need it anymore)
RUN rm -rf frontend

# Set environment
ENV RAILS_ENV=production

# Run docker-init.sh as default command 
CMD /app/docker-init.sh
