module RedisRateLimiter
  class RedisOperation
    def initialize
      @redis = $redis
    end

    def get_hash_by_key(key)
      @redis.hget(key)
    end

    def get_hash_keys(key)
      @redis.hkeys(key)
    end

    def delete_hash_by_key(key)
      @redis.hdel(key)
    end

  end
end