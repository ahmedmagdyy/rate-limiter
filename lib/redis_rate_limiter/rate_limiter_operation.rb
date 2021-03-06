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
      redis_key = "#{get_redis_key(identifier)}_active"
      blocked_key = "#{get_redis_key(identifier)}_blocked"
      # if already exceeded max requests,
      # he is blocked for the @block_time
      if is_blocked?(blocked_key)
        return false
      else
        bucket_name = get_bucket_name(identifier)
        req_count_in_current_window = get_bucket_count(redis_key)
        if req_count_in_current_window < @max_reqs
          # redis_value = {:bucket_name => bucket_name, :ip => ip}
          redis_value = "#{bucket_name}:#{ip}"
          @redis_op.increment_hash_value(redis_key, redis_value)
          return true
        else
          # if requests count in current window is equal to max requests allowed in window
          # block the identifier for @block_time
          @redis_op.set_blocked_key_with_expire(blocked_key, @block_time)
          return false
        end
      end
    end

    def tracked_usage
      array_of_hashes = @redis_op.get_all_hashes
      result = Hash.new
      array_of_hashes.each do |hash|
        hash.each do |key, value|
          ip = key.split(":")[1]
          identifier ||= key.split(":")[0].split("_").take(2).join(" ")
          result[identifier] ||= Hash.new
          result[identifier]["ip"].nil? ? result[identifier]["ip"] = [ip] : result[identifier]["ip"].append(ip)
          result[identifier]["usage"].nil? ? result[identifier]["usage"] = value.to_i : result[identifier]["usage"] += value.to_i
        end
      end
      return result
    end

    def is_blocked?(key)
      @redis_op.get_blocked_key(key) > 0
    end

    def get_bucket_count(redis_key)
      # to get accurate bucket count & free space,
      # we need to delete old buckets,
      # out of time.now - window_time
      # and then get the bucket count
      delete_old_buckets(redis_key)
      @redis_op.get_hash_values(redis_key).map(&:to_i).reduce(:+) || 0
    end

    def delete_old_buckets(redis_key)
      buckets = @redis_op.get_hash_keys(redis_key)
      # delete buckets which are out of time.now - window_time
      # bucket key format: key_identifier_time:ip
      buckets.each do |bucket_key|
        bucket_time = bucket_key.split(":")[0].split("_")[2].to_i
        if bucket_time <= get_time - @window
          @redis_op.delete_hash_by_key(redis_key, bucket_key)
        end
      end
    end

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