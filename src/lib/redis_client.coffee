# Put Redis client as a reusable item.
redis = require "redis"
exports.redis_client = redis.createClient()