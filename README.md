# README

This is a simple e-commerce platform with a dynamic pricing engine that adjusts product prices in real-time based on demand, inventory levels, and competitor prices

## Requirements
- Ruby 3.3.1
- Rails 7.1.3.4
- MonogoDB
- Sidekiq
- Redis

## Installation

1. Clone the repository
```
git clone https://github.com/izhanov/dynamic_pricing.git
```

2. Install dependencies
```
bundle install
```

3. Start the server
```
rails s
```

4. Start Sidekiq
```
bundle exec sidekiq
```

