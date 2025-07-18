app_key           = "base64:1Fo2I2MXFj4neGxw49NR8PMpbjN5RV3UDUrmbCnLAjg="
app_env           = "production"
app_debug         = false
app_url           = "http://laravel-counter-alb-95743115.us-east-1.elb.amazonaws.com/"

cache_driver      = "redis"
session_driver    = "redis"
queue_connection  = "redis"

redis_client      = "phpredis"
redis_endpoint    = "dev-redis.j17qxk.0001.use1.cache.amazonaws.com"
redis_password    = ""
redis_port        = 6379

mail_mailer       = "log"  # disables real email sending
