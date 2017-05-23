require 'sidekiq/testing'

module SidekiqMinitestSupport
  def after_teardown
    Sidekiq::Worker.clear_all
    super
  end
end

class MiniTest::Spec
  include SidekiqMinitestSupport
end

class MiniTest::Unit::TestCase
  include SidekiqMinitestSupport
end