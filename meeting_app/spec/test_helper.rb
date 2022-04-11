def random_string(size = 10)
  (0...size).map { ('a'..'z').to_a[rand(26)] }.join
end
