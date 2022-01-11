module RedisRateLimiter
  class RedisOperation
    def initialize
      @redis = $redis
    end
  end
end