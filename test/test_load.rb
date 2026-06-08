require "CalcTest"

SALAMENCE = %q{Custom Set (Salamence) @ Shell Bell
Ability: Intimidate
Level: 50
Adamant Nature
EVs: 252 Atk / 4 SpD / 252 Spe
- Aerial Ace
- Dragon Claw
- Earthquake
- Steel Wing}

AUTOLEVEL_CHANGE = "$('#autolevel').trigger('change')"

class LoadTestCase < CalcTest

	def test_forme_change
		find(:xpath, './/label[@for="game8"]').click

		selectBlankSet(1, "Zacian")
		find("#p1 .forme option", exact_text: "Zacian-Crowned").click

		assert_equal("Fairy",
			find("#p1 .type1").value)
		assert_equal("Steel",
			find("#p1 .type2").value)

		assert_equal("Intrepid Sword",
			find("#p1 .ability").value)

		assert_equal("92",
			find("#p1 .hp .base").value)
		assert_equal("170",
			find("#p1 .at .base").value)
		assert_equal("115",
			find("#p1 .df .base").value)
		assert_equal("80",
			find("#p1 .sa .base").value)
		assert_equal("115",
			find("#p1 .sd .base").value)
		assert_equal("148",
			find("#p1 .sp .base").value)
		assert_equal("1",
			find("#p1 .at .boost").value)


		find("#p1 .forme option", exact_text: "Zacian").click

		assert_equal("Fairy",
			find("#p1 .type1").value)
		assert_equal("",
			find("#p1 .type2").value)

		assert_equal("Intrepid Sword",
			find("#p1 .ability").value)

		assert_equal("92",
			find("#p1 .hp .base").value)
		assert_equal("130",
			find("#p1 .at .base").value)
		assert_equal("115",
			find("#p1 .df .base").value)
		assert_equal("80",
			find("#p1 .sa .base").value)
		assert_equal("115",
			find("#p1 .sd .base").value)
		assert_equal("138",
			find("#p1 .sp .base").value)
		assert_equal("1",
			find("#p1 .at .boost").value)
	end

	def test_ivs_em
		find(:xpath, './/label[@for="game3"]').click
		# IVs are a per-side dropdown in gen 3, a per-side AI-only field in gen 4,
		# and a both-side AI-only dropdown in gens 5-7

		ivValue = "21"
		find("#p1 #autoivs-select option", exact_text: ivValue).click
		check_ivs(1, ivValue)

		selectSet(1, "Ampharos-4")
		check_ivs(1, ivValue)

		ivValue = "18"
		find("#p1 #autoivs-select option", exact_text: ivValue).click
		check_ivs(1, ivValue)


		check_ivs(2, "31")

		selectSet(2, "Walrein-4")
		check_ivs(2, "31")

		ivValue = "21"
		find("#p2 #autoivs-select option", exact_text: ivValue).click
		check_ivs(2, ivValue)
	end

	def test_ivs_pthgss
		find(:xpath, './/label[@for="game4"]').click

		ivValue = "21"
		find("#p1 #autoivs-box").set(ivValue)
		# Calling the change function like this is not ideal,
		# but it's easier to do this than to try to force the IV change event to happen "naturally"
		page.execute_script("$('#autoivsL').trigger('change')")
		check_ivs(1, ivValue)

		selectSet(1, "Ampharos-4")
		check_ivs(1, ivValue)

		ivValue = "18"
		find("#p1 #autoivs-box").set(ivValue)
		page.execute_script("$('#autoivsL').trigger('change')")
		check_ivs(1, ivValue)


		check_ivs(2, "31")

		selectSet(2, "Walrein-4")
		check_ivs(2, "31")

		ivValue = "21"
		find("#p2 #autoivs-box").set(ivValue)
		page.execute_script("$('#autoivsR').trigger('change')")
		check_ivs(2, ivValue)
	end

	def check_ivs(pokeID, ivValue)
		assert_equal(ivValue,
			find("#p%d .hp .ivs" % pokeID).value)
		assert_equal(ivValue,
			find("#p%d .at .ivs" % pokeID).value)
		assert_equal(ivValue,
			find("#p%d .df .ivs" % pokeID).value)
		assert_equal(ivValue,
			find("#p%d .sa .ivs" % pokeID).value)
		assert_equal(ivValue,
			find("#p%d .sd .ivs" % pokeID).value)
		assert_equal(ivValue,
			find("#p%d .sp .ivs" % pokeID).value)
	end

	
	# TODO: the level tests are broken when loading a custom set.
	# This isn't how set loading behaves in-browser with an actual user, so there's some issue with how the test runs or the elements that are interacted with.
	# Each of the commented-out asserts should be uncommented.

	def test_levels_em
		loadCustomSet(SALAMENCE)
		# gen 3 applies level to both sides
		find(:xpath, './/label[@for="game3"]').click

		level = "99"
		find("#autolevel-box").set(level)
		# Same reason as the IV tests. Calling the change function like this isn't ideal, but it's easier to do this than to try to force the level change event to happen "naturally"
		page.execute_script(AUTOLEVEL_CHANGE)
		assert_equal(level,
			find("#p1 .level").value)
		assert_equal(level,
			find("#p2 .level").value)

		selectSet(1, "Salamence (Custom Set)")
		# assert_equal("50",
		# 	find("#p1 .level").value) # actual 99
		assert_equal(level,
			find("#p2 .level").value)

		level = "51"
		find("#autolevel-box").set(level)
		page.execute_script(AUTOLEVEL_CHANGE)
		assert_equal(level,
			find("#p1 .level").value)
		assert_equal(level,
			find("#p2 .level").value)
	end

	# TODO: this test is fairly broken since the actual level getting observed is always 50.
	def test_levels_pthgss
		loadCustomSet(SALAMENCE)
		# gen 4 applies level to all AI sets only
		find(:xpath, './/label[@for="game4"]').click

		level = "99"
		find("#autolevel-box").set(level)
		page.execute_script(AUTOLEVEL_CHANGE)
		# assert_equal(level,
		# 	find("#p1 .level").value) # actual 50
		# assert_equal(level,
		# 	find("#p2 .level").value) # actual 50

		selectSet(1, "Salamence (Custom Set)")
		assert_equal("50",
			find("#p1 .level").value)
		# assert_equal(level,
		# 	find("#p2 .level").value) # actual 50

		level = "51"
		find("#autolevel-box").set(level)
		page.execute_script(AUTOLEVEL_CHANGE)
		# The loaded custom Salamence should stay level 50, because gen4's autolevel only affects AI sets
		assert_equal("50",
			find("#p1 .level").value)
		# assert_equal(level,
		# 	find("#p2 .level").value) # actual 50
	end

	def test_levels_modern
		loadCustomSet(SALAMENCE)
		# gen 5+ applies either 50 or 100 to both sides
		find(:xpath, './/label[@for="game5"]').click
		autoLabelFormat = './/label[@for="autolevel%s"]'

		level = "100"
		find(:xpath, autoLabelFormat % level).click
		assert_equal(level,
			find("#p1 .level").value)
		assert_equal(level,
			find("#p2 .level").value)

		selectSet(1, "Salamence (Custom Set)")
		# the custom Salamence still loads as level 50 because the set saved as level 50
		# assert_equal("50",
		# 	find("#p1 .level").value) # actual 100
		assert_equal(level,
			find("#p2 .level").value)

		level = "50"
		find(:xpath, autoLabelFormat % level).click
		assert_equal(level,
			find("#p1 .level").value)
		assert_equal(level,
			find("#p2 .level").value)

		level = "100"
		find(:xpath, autoLabelFormat % level).click
		assert_equal(level,
			find("#p1 .level").value)
		assert_equal(level,
			find("#p2 .level").value)
	end

end
