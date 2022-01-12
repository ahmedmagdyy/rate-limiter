module RedisRateLimiter
  class RequestRateLimiter
    # @param [String]	  key			                  A unique identifier for Limiter
    # @param [Integer]	window_time	              Number of seconds per windows bucket > 0 sec
    # @param [Integer]	max_requests_count	      Max Number of requests per window > 0
    # @param [Integer]	block_time	              Number of second to block > 0 sec, default 5 minutes (300 sec)
    def initialize(key, window_time = 10, max_requests_count = 50, block_time = 5 * 60 )
      if !window_time.is_a?(Integer) && window_time.to_i <= 0
        raise("window time value must be integer and bigger than 0")
      end

      if !max_requests_count.is_a?(Integer) && max_requests_count.to_i <= 0
        raise("max requests value must be integer and bigger than 0")
      end
      @request_rate_limiter = RateLimiterOperation.new(key, window_time.to_i, max_requests_count.to_i, block_time.to_i)
    end

    def track_api_usage(identifier, ip)
      @request_rate_limiter.track_api_usage(identifier, ip)
    end

    def tracked_usage
      @request_rate_limiter.tracked_usage
    end
  end
end