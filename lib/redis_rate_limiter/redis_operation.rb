module RedisRateLimiter
  class RedisOperation
    def initialize
      @redis = $redis
    end

    def get_hash_by_key(key)
      @redis.hget(key)
    end

  end
end