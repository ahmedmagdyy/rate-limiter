require_relative 'redis_operation'
require 'json'

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
      # if already exceeded max requests,
      # he is blocked for the @block_time
      if is_blocked?(redis_key)
        return false
      else
        bucket_name = get_bucket_name(identifier)
        req_count_in_current_window = get_bucket_count(redis_key)
        if req_count_in_current_window < @max_reqs
          redis_value = {:bucket_name => bucket_name, :ip => ip}
          @redis_op.increment_hash_value(redis_key, JSON.generate(redis_value))
          return true
        else
          # if requests count in current window is equal to max requests allowed in window
          # block the identifier for @block_time
          @redis_op.set_blocked_key_with_expire(redis_key, @block_time)
          return false
        end
      end
    end

    def tracked_usage(identifier)
      redis_key = get_redis_key(identifier)
      @redis_op.get_all_hashes_by_key(redis_key)
    end

    def is_blocked?(redis_key)
      @redis_op.get_blocked_key(redis_key) > 0
    end

    def get_bucket_count(redis_key)
      # to get accurate bucket count & free space,
      # we need to delete old buckets,
      # out of time.now - window_time
      # and then get the bucket count
      # delete_old_buckets(redis_key)
      @redis_op.get_hash_values(redis_key).map(&:to_i).reduce(:+) || 0
    end

    # def delete_old_buckets(redis_key)
    #   buckets = @redis_op.get_hash_keys(redis_key)
    #   # delete buckets which are out of time.now - window_time
    #   buckets.each do |bucket|
    #     bucket_json = JSON.parse(bucket)
    #     bucket_name = bucket_json['bucket_name']
    #     if bucket_name.split("_")[2].to_i <= get_time - @window
    #       @redis_op.delete_hash_by_key(redis_key, bucket_name)
    #     end
    #   end
    # end

    def get_bucket_name(identifier)
      "#{get_redis_key(identifier)}_#{get_time}"
    end

    def get_time
      Time.now.to_i
    end

    def get_redis_key(identifier)
      # e.g "login_127.0.0.1"
      "#{@id}_#{identifier}"
    end
  end
end