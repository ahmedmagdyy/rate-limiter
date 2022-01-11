class ApplicationController < ActionController::Base
  include RedisRateLimiter
  before_action :init_redis_rate_limiter, :track_rate_limit

  def index
    render status: OK, plain: "OK"
  end

  def track_rate_limit
    if @limiter.track_api_usage("test", request.ip)
      render status: 200, plain: "Allowed Request!"
    else
      render status: 429, plain: "Too many requests"
    end
  end

  def get_tracked_usage
    @limiter.tracked_usage
  end

  def init_redis_rate_limiter
    @limiter = RedisRateLimiter::RequestRateLimiter.new("index", ENV["window_time_in_sec"], ENV["allowed_req_per_window"], ENV["block_time_in_sec"])
  end
end
