$redis = Redis::Namespace.new(
  "rate_limiter",
  :redis => Redis.new(:host => ENV["redis_host"] || "localhost", :port => ENV["redis_port"] || 6379)
)