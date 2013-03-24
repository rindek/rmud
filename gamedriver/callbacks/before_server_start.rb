require_relative "../callbacks"

Callbacks.add(:before_server_start) do
  $boot_time = Time.now
end
