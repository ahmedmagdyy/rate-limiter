module RedisRateLimiter
  class RedisOperation
    def initialize
      @redis = $redis
    end

    def get_all_hashes_by_key(key)
      @redis.hgetall(key)
    end

    def get_hash_keys(key)
      @redis.hkeys(key)
    end

    def get_hash_values(key)
      @redis.hvals(key)
    end

    def get_hash_count_by_key(key)
      @redis.hlen(key)
    end

    def increment_hash_value(key, bucket_name)
      @redis.hincrby(key, bucket_name, 1)
    end

    def delete_hash_by_key(key, bucket_name)
      @redis.hdel(key, bucket_name)
    end

    def set_blocked_key_with_expire(key, expire)
      @redis.set(key, 1)
      @redis.expire(key, expire)
    end

    def get_blocked_key(key)
      @redis.ttl(key)
    end

  end
end