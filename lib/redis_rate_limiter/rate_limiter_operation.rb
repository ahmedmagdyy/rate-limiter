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

    # identifier can be user_id, ip, session_id, jwt_token
    def track_api_usage(identifier, ip)
      redis_key = get_redis_key(identifier)
      # check if the key exists in redis
      hash_exists = @redis_op.get_hash_by_key(redis_key)
      bucket_name = get_bucket_name(identifier)

    end

    def get_bucket_name(identifier)
      "#{get_redis_key(identifier)}_#{get_time}"
    end

    def get_time
      Time.now.to_i
    end

    def get_redis_key(identifier)
      # e.g "login_127.0.0.1"
      "#{@key}_#{identifier}"
    end
  end
end