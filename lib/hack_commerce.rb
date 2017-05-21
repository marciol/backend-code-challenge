require_relative './hack_commerce/entity'
require_relative './hack_commerce/repository'

module HackCommerce
  def self.rom_container
    thread_local[:rom_container]
  end

  def self.rom_container=(container)
    thread_local[:rom_container] = container
  end

  def self.rom_configuration
    thread_local[:rom_configuration]
  end

  def self.rom_configuration=(configuration)
    thread_local[:rom_configuration] = configuration
  end

  def self.thread_local
    Thread.current
  end
end
