require "capybara/minitest"

class CalcTest < Minitest::Test
	include Capybara::DSL
	include Capybara::Minitest::Assertions

	Capybara.current_driver = :selenium_headless

	def initialize(super_arg)
		super(super_arg)
		visit("http://localhost:4000")
	end

	def selectSet(pokeID, setName)
		find("#p%d .select2-container.set-selector" % pokeID).click
		find("li.select2-result", text: setName).click
	end

	def selectBlankSet(pokeID, species)
		find("#p%d .select2-container.set-selector" % pokeID).click
		find("input.select2-input").set(species)
		find("li.select2-result", text: "Blank Set").click
	end

	def loadCustomSet(setPaste)
		find("#customMon").set(setPaste)
		accept_alert do
			page.execute_script("savecustom()")
		end
	end

end
