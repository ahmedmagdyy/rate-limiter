$redis = Redis::Namespace.new("rate_limiter", :redis => Redis.new)