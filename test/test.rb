require "capybara/minitest"

class CapybaraTestCase < Minitest::Test
  include Capybara::DSL
  include Capybara::Minitest::Assertions

  Capybara.current_driver = :selenium_headless

  def initialize(super_arg)
    super(super_arg)
    visit("http://localhost:4000") # hoping that port 4000 is pretty universal
  end

  def test_basic_calc
    assert_equal("Abomasnow (No Move) vs. Abomasnow: 0-0 (0 - 0%) -- nice move", find("#mainResult").text)
  end

end