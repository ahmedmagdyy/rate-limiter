require_relative 'redis_operation'

module RedisRateLimiter
  class RateLimiterOperation
    def initialize(key, window_time, allowed_reqs_count, block_time)
      @id = key  # unique key for the redis_rate_limiter (/login, specific endpoint, payment route)
      @window = window_time # in seconds
      @max_reqs = allowed_reqs_count # max requests in window
      @block_time = block_time # time to block requests in seconds
      @redis_op = RedisOperation.new
    end
  end
end