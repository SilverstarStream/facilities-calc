require "CalcTest"

class DamageTestCase < CalcTest

	def test_type_precedence
		find(:xpath, './/label[@for="game3"]').click
		selectSet(1, "Ampharos-4")
		selectSet(2, "Salamence-1")
		assert_equal("(99, 100, 101, 102, 104, 105, 106, 107, 108, 109, 111, 112, 113, 114, 115, 117)",
			find("#damageValues").text)

		find(:xpath, './/label[@for="game4"]').click
		selectSet(1, "Ampharos-4")
		selectSet(2, "Salamence-1")
		assert_equal("(124, 126, 127, 129, 130, 132, 133, 135, 136, 138, 139, 141, 142, 144, 145, 147)",
			find("#damageValues").text)
	end

end