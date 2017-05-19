module HackCommerce
  def self.rom_container
    thread_local[:rom_container]
  end

  def self.rom_container=(container)
    thread_local[:rom_container] = container
  end

  def self.thread_local
    Thread.current
  end
end
