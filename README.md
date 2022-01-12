# README

# Rate Limiter Module

Ruby on rails rate limiter module using **sliding window algorithm**.

## Requirements

- [Ruby](https://www.ruby-lang.org/en/documentation/installation/) 2.7.0+ required, 3.0+ preferred.

- Rails 7.0.1. to install Rails.
```
gem install rails
```

- Redis server running on ```localhost:6379```. you can get redis via [docker](https://docs.docker.com/engine/install/).
```
docker run -d -p 6379:6379 redis
```


## Run
- Clone Repo.
```
git clone https://github.com/ahmedmagdyy/rate-limiter.git
cd rate-limiter
```

- create ```.env```  & ```.env.test``` files based on ```.env.example```.

*NOTE: don't use the same identifier in both files, to avoid conflict.*

- install dependencies.
```
bundle install
```

- Run application.
```
rails s
```

- Run test.
```ruby
rspec
```
*NOTE: test will run on the same redis server.*

Go to ```http://localhost:3000/track``` you should see ```Allowed Request!``` printed. If requests count reached the limit, you will get ```Too many requests!``` and will be blocked for some time based on your ```.env``` values.

Go to ```http://localhost:3000/tracked``` to get all tracked consumers with ip addresses and their usage.
## Usage
- Module initialization requires the following parameters:

```key```: a unique key to identify what is being rated limited, e.g route, this key is part of the Redis key used in creating buckets.

```interval```: window length in seconds, default: 10 sec.

```limit```: max requests count allowed in the interval, default 50 request.

```block_time```: block requests for this amount of time in second, default 5 minutes.
```ruby
@limiter = RedisRateLimiter::RequestRateLimiter.new(key, interval, limit, block_time)
```

- ```track_api_usage``` function accepts two parameters:

```identifier```: a unique string to identify the consumer, can be user id, IP, session id, JWT, .... etc.

```ip```: consumer ip address.
```ruby
@limiter.track_api_usage(identifier, request.ip)
```

- ```tracked_usage``` function returns hash contains all consumers with ip and their usage.
```ruby
@limiter.tracked_usage
```
## License
[MIT](https://choosealicense.com/licenses/mit/)
