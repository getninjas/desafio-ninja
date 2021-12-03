class Rack::Attack

  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new


  # Permitir requisições de localhost

  safelist('allow-localhost') do |req|
    '127.0.0.1' == req.ip || '::1' == req.ip
  end

  # Restringir quantidade de requisições

  throttle('red/ip', limit: 10, period: 10) do |req|
    req.ip
  end

end