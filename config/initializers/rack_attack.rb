class Rack::Attack
  Rack::Attack.enabled = ENV['ENABLE_RACK_ATTACK'] || Rails.env.production?
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

  # Allow all localhost traffic (development)
  safelist('allow-localhost') do |req|
    '127.0.0.1' == req.ip || '::1' == req.ip
  end

  # Allow an IP address to make 5 requests every (each) 10 seconds
  throttle('req/ip', limit: 5, period: 10) do |req|
    req.ip
  end

  # IP blacklist
  bad_ips = (ENV['BLOCKED_IPS'] || []).split(',') # Pulled from a external API on app boot.
  Rack::Attack.blocklist "Block IPs from Environment Variable" do |req|
    bad_ips.include?(req.ip)
  end
end
