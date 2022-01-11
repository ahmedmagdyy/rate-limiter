class ApplicationController < ActionController::Base
  include RedisRateLimiter
  before_action :init_redis_rate_limiter
  before_action :track_rate_limit, only: [:index]

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
    render status: 200, plain: @limiter.tracked_usage
  end

  def init_redis_rate_limiter
    @limiter = RedisRateLimiter::RequestRateLimiter.new("home", ENV["window_time_in_sec"], ENV["allowed_req_per_window"], ENV["block_time_in_sec"])
  end
end
