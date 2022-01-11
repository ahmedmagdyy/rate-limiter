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

    def set_hash(key, data)
      @redis.hset(key, data, 1)
    end

    def get_hash_count_by_key(key)
      @redis.hlen(key)
    end

    def increment_hash_value(key, bucket_name)
      @redis.hincrby(key, bucket_name, 1)
    end

    def delete_hash_by_key(key)
      @redis.hdel(key)
    end

  end
end