require "CalcTest"

INCINEROAR = %q{RS Dark (Incineroar) @ Muscle Band
Ability: Intimidate
Adamant Nature
EVs: 188 HP / 148 Atk / 164 Def / 4 SpD / 4 Spe
- Fire Punch
- Drain Punch
- Rest
- Swords Dance}

HERACROSS = %q{RS Bug (Heracross)
Ability: Moxie
Jolly Nature
EVs: 252 Atk / 4 SpD / 252 Spe
- Bullet Seed
- Pin Missile
- Low Kick
- Rock Slide}

JEJUNUM = %q{JEJUNUM (Kangaskhan-Mega)
Ability: Parental Bond
Adamant Nature
EVs: 244 HP / 44 Atk / 28 Def / 52 SpD / 140 Spe
- Earthquake
- Seismic Toss
- Return
- Power-Up Punch}

LEFTOVERS = "Leftovers"
SITRUS_BERRY = "Sitrus Berry"
MAGO_BERRY = "Mago Berry"

START_WITH = "start with"
END_WITH = "end with"
INCLUDE = "include"

class KoChanceTestCase < CalcTest

	def setAttackBoost(boost)
		find("#p1 .at .boost option[value='%d']" % boost).select_option
	end

	def setP2Item(item)
		find("#p2 .item option[value='%s']" % item).select_option
	end

	def assertIncludes(selector, function, expectedValue)
		text = find(selector).text
		if (function == START_WITH)
			assertValue = text.start_with?(expectedValue)
		elsif (function == END_WITH)
			assertValue = text.end_with?(expectedValue)
		elsif (function == INCLUDE)
			assertValue = text.include?(expectedValue)
		else
			raise "Error: the 'function' argument passed in is not recognized"
		end
		assert(assertValue, "Expected element #{selector}'s actual text:\n#{text}\nto #{function} the expected string:\n#{expectedValue}")
	end

	def test_ko_chances
		find(:xpath, ".//label[@for='game8']").click
		loadCustomSet(INCINEROAR)
		selectSet(1, "Incineroar (RS Dark)")

		# always using Fire Punch as the attack

		selectSet(2, "Lurantis-RS") # 169 HP
		# guaranteed OHKO: 169 <= 174
		assertIncludes("#mainResult", END_WITH, "174-206 (103 - 121.9%) -- guaranteed OHKO")

		selectSet(2, "Scolipede-RS") # 159 HP
		# possible OHKO: 156 < 159 <= 186
		assertIncludes("#mainResult", END_WITH, "156-186 (98.1 - 117%) -- 81.3% chance to OHKO")

		selectSet(2, "Exeggutor-RS") # 194 HP
		# guaranteed 2HKO: 194 <= [162 * 2 = 324]
		assertIncludes("#mainResult", END_WITH, "162-192 (83.5 - 99%) -- guaranteed 2HKO")

		selectSet(2, "Aromatisse-RS") # 200 HP
		# possible 2HKO: [93 * 2 = 186] < 200 <= [111 * 2 = 222]
		assertIncludes("#mainResult", END_WITH, "93-111 (46.5 - 55.5%) -- 68% chance to 2HKO")

		selectSet(2, "Dusknoir-RS") # 144 HP
		# guaranteed 3HKO: 144 <= [54 * 3 = 162]
		assertIncludes("#mainResult", END_WITH, "54-64 (37.5 - 44.4%) -- guaranteed 3HKO")

		selectSet(2, "Slurpuff-RS") # 181 HP
		# possible 3HKO: [55 * 3 = 165] < 181 <= [66 * 3 = 198]
		assertIncludes("#mainResult", END_WITH, "55-66 (30.4 - 36.5%) -- 50% chance to 3HKO")

		selectSet(2, "Conkeldurr-RS") # 204 HP
		# guaranteed 4HKO: 204 <= [52 * 4 = 208]
		assertIncludes("#mainResult", END_WITH, "52-63 (25.5 - 30.9%) -- guaranteed 4HKO")

		selectSet(2, "Jellicent-RS") # 199 HP
		# possible 4HKO: [48 * 4 = 192] < 199 <= [57 * 4 = 228]
		assertIncludes("#mainResult", END_WITH, "48-57 (24.1 - 28.6%) -- 96.1% chance to 4HKO")

		selectSet(2, "Kingler-RS") # 122 HP
		# guaranteed 5HKO: 122 <= [25 * 5 = 125]
		assertIncludes("#mainResult", END_WITH, "25-30 (20.5 - 24.6%) -- guaranteed 5HKO")

		selectSet(2, "Poliwrath-RS") # 189 HP
		# possible 5HKO: [36 * 5 = 180] < 189 <= [43 * 5 = 215]
		assertIncludes("#mainResult", END_WITH, "36-43 (19 - 22.8%) -- possible 5HKO")

		setAttackBoost(-6)

		selectSet(2, "Meowstic-M-RS") # 141 HP
		# guaranteed 6HKO: 141 <= [24 * 6 = 144]
		assertIncludes("#mainResult", END_WITH, "24-28 (17 - 19.9%) -- guaranteed 6HKO")

		selectSet(2, "Golurk-RS") # 156 HP
		# possible 6HKO: [22 * 6 = 132] < 156 <= [27 * 6 = 162]
		assertIncludes("#mainResult", END_WITH, "22-27 (14.1 - 17.3%) -- possible 6HKO")

		setAttackBoost(-3)

		selectSet(2, "Seaking-RS") # 147 HP
		# guaranteed 7HKO: 147 <= [21 * 7 = 147]
		assertIncludes("#mainResult", END_WITH, "21-24 (14.3 - 16.3%) -- guaranteed 7HKO")

		selectSet(2, "Salazzle-RS") # 167 HP
		# possible 7HKO: [21 * 7 = 147] < 167 <= [26 * 7 = 182]
		assertIncludes("#mainResult", END_WITH, "21-26 (12.6 - 15.6%) -- possible 7HKO")

		selectSet(2, "Goodra-RS") # 189 HP
		# possible 9HKO: [19 * 9 = 171] < 189 <= [23 * 9 = 207]
		assertIncludes("#mainResult", END_WITH, "19-23 (10.1 - 12.2%) -- possible 9HKO")

		selectSet(2, "Solrock-RS") # 189 HP
		# every bit counts 5HKO: [19 * 9 = 171] < 189
		assertIncludes("#mainResult", END_WITH, "16-19 (8.5 - 10.1%) -- every bit counts")
	end

	def test_leftovers
		healing_test_cases(LEFTOVERS)
	end

	def test_sitrus
		healing_test_cases(SITRUS_BERRY)
	end

	def healing_test_cases(item)
		find(:xpath, ".//label[@for='game8']").click
		loadCustomSet(INCINEROAR)
		selectSet(1, "Incineroar (RS Dark)")

		selectSet(2, "Lurantis-RS") # 169 HP
		# guaranteed OHKO: 169 <= 174
		expectedResult = "174-206 (103 - 121.9%) -- guaranteed OHKO"
		assertIncludes("#mainResult", END_WITH, expectedResult)
		setP2Item(item) # Healing does not influence an OHKO's result
		assertIncludes("#mainResult", END_WITH, expectedResult)

		selectSet(2, "Tangrowth-RS") # 199 HP
		setAttackBoost(1)
		# possible OHKO: 170 < 199 <= 204
		expectedResult = "170-204 (85.4 - 102.5%) -- 12.5% chance to OHKO"
		assertIncludes("#mainResult", END_WITH, expectedResult)
		setP2Item(item) # Healing does not influence an OHKO's result
		assertIncludes("#mainResult", END_WITH, expectedResult)
		setAttackBoost(0)

		selectSet(2, "Comfey-RS") # 150 HP
		# guaranteed 2HKO: 150 <= [76 * 2 = 152]
		assertIncludes("#mainResult", END_WITH, "76-91 (50.7 - 60.7%) -- guaranteed 2HKO")
		setP2Item(item)
		if (item == LEFTOVERS)
			# 159 effective HP w/ 1 turn of Leftovers
			# possible 2HKO: [76 * 2 = 152] < 159 <= [91 * 2 = 182]
			expectedResult = "76-91 (50.7 - 60.7%) -- 91.4% chance to 2HKO after Leftovers recovery"
		elsif (item == SITRUS_BERRY)
			# 187 effective HP w/ Sitrus
			# guaranteed 3HKO: 187 > [91 * 2 = 182]; 187 <= [76 * 3 = 228]
			expectedResult = "76-91 (50.7 - 60.7%) -- guaranteed 3HKO after Sitrus Berry recovery"
		end
		assertIncludes("#mainResult", END_WITH, expectedResult)

		selectSet(2, "Passimian-RS") # 167 HP
		# possible 2HKO: [76 * 2 = 152] < 167 <= [91 * 2 = 182]
		assertIncludes("#mainResult", END_WITH, "76-91 (45.5 - 54.5%) -- 53.5% chance to 2HKO")
		setP2Item(item)
		if (item == LEFTOVERS)
			# 177 effective HP w/ 1 turn of Leftovers
			# possible 2HKO: [76 * 2 = 152] < 177 <= [91 * 2 = 182]
			expectedResult = "76-91 (45.5 - 54.5%) -- 6.3% chance to 2HKO after Leftovers recovery"
		elsif (item == SITRUS_BERRY)
			# 208 effective HP w/ Sitrus
			# This calculates the chance to low roll and not trigger the berry, then high roll to get the KO
			# No change in effective HP for calculating the 2HKO, and berry text should not print
			expectedResult = "76-91 (45.5 - 54.5%) -- 10.9% chance to 2HKO"
		end
		assertIncludes("#mainResult", END_WITH, expectedResult)

		selectSet(2, "Malamar-RS") # 185 HP
		# possible 2HKO: [78 * 2 = 156] < 185 <= [93 * 2 = 186]
		assertIncludes("#mainResult", END_WITH, "78-93 (42.2 - 50.3%) -- 0.4% chance to 2HKO")
		setP2Item(item)
		if (item == LEFTOVERS)
			# 196 effective HP w/ 1 turn of Leftovers; 207 effective w/ 2 turns
			# guaranteed 3HKO: 196 > [93 * 2 = 186]; 207 <= [78 * 3 = 234]
			expectedResult = "78-93 (42.2 - 50.3%) -- guaranteed 3HKO after Leftovers recovery"
		elsif (item == SITRUS_BERRY)
			# 231 effective HP w/ Sitrus
			# there is no possible 2HKO because the highest damage roll that doesn't trigger the berry is 91, then the highest roll is 93, which only sums to 184
			expectedResult = "78-93 (42.2 - 50.3%) -- guaranteed 3HKO after Sitrus Berry recovery"
		end
		assertIncludes("#mainResult", END_WITH, expectedResult)

		selectSet(2, "Seaking-RS") # 147 HP
		# guaranteed 3HKO: 147 <= [51 * 3 = 153]
		assertIncludes("#mainResult", END_WITH, "51-60 (34.7 - 40.8%) -- guaranteed 3HKO")
		setP2Item(item)
		if (item == LEFTOVERS)
			# 165 effective HP w/ 2 turns of Leftovers
			# possible 3HKO: [51 * 3 = 153] < 165 <= [60 * 3 = 180]
			expectedResult = "51-60 (34.7 - 40.8%) -- 65.5% chance to 3HKO after Leftovers recovery"
		elsif (item == SITRUS_BERRY)
			# 183 effective HP w/ Sitrus
			# guaranteed 4HKO: 183 <= [51 * 4 = 204]
			expectedResult = "51-60 (34.7 - 40.8%) -- guaranteed 4HKO after Sitrus Berry recovery"
		end
		assertIncludes("#mainResult", END_WITH, expectedResult)

		selectSet(2, "Dragalge-RS") # 132 HP
		# possible 3HKO: [38 * 3 = 114] < 132 <= [45 * 3 = 135]
		assertIncludes("#mainResult", END_WITH, "38-45 (28.8 - 34.1%) -- 3.6% chance to 3HKO")
		setP2Item(item)
		if (item == LEFTOVERS)
			# 148 effective HP w/ 2 turns of Leftovers; 156 effective w/ 3 turns
			# possible 4HKO: 148 > [45 * 3 = 135]; [38 * 4 = 152] < 156 <= [45 * 4 = 180]
			expectedResult = "38-45 (28.8 - 34.1%) -- 99.6% chance to 4HKO after Leftovers recovery"
		elsif (item == SITRUS_BERRY)
			# 165 effective HP w/ Sitrus
			# possible 4HKO: [38 * 4 = 152] < 165 <= [45 * 4 = 180]
			expectedResult = "38-45 (28.8 - 34.1%) -- 65% chance to 4HKO after Sitrus Berry recovery"
		end
		assertIncludes("#mainResult", END_WITH, expectedResult)

		selectSet(2, "Seismitoad-RS") # 204 HP
		# guaranteed 4HKO: 204 <= [51 * 4 = 204]
		assertIncludes("#mainResult", END_WITH, "51-60 (25 - 29.4%) -- guaranteed 4HKO")
		setP2Item(item)
		if (item == LEFTOVERS)
			# 240 effective HP w/ 3 turns of Leftovers
			# possible 4HKO: [51 * 4 = 204] < 240 <= [60 * 4 = 240]
			expectedResult = "51-60 (25 - 29.4%) -- Miniscule% chance to 4HKO after Leftovers recovery"
		elsif (item == SITRUS_BERRY)
			# 255 effective HP w/ Sitrus
			# guaranteed 5HKO: 255 <= [51 * 5 = 255]
			expectedResult = "51-60 (25 - 29.4%) -- guaranteed 5HKO after Sitrus Berry recovery"
		end
		assertIncludes("#mainResult", END_WITH, expectedResult)

		selectSet(2, "Solrock-RS") # 189 HP
		# possible 4HKO: [40 * 4 = 160] < 189 <= [48 * 4 = 192]
		assertIncludes("#mainResult", END_WITH, "40-48 (21.2 - 25.4%) -- 0.1% chance to 4HKO")
		setP2Item(item)
		if (item == LEFTOVERS)
			# 222 effective HP w/ 3 turns of Leftovers; 233 effective w/ 4 turns
			# possible 5HKO: 222 > [48 * 4 = 192]; [40 * 5 = 200] < 233 <= [48 * 5 = 240]
			expectedResult = "40-48 (21.2 - 25.4%) -- possible 5HKO after Leftovers recovery"
		elsif (item == SITRUS_BERRY)
			# 236 effective HP w/ Sitrus
			# possible 5HKO: [40 * 5 = 200] < 236 <= [48 * 5 = 240]
			expectedResult = "40-48 (21.2 - 25.4%) -- possible 5HKO after Sitrus Berry recovery"
		end
		# TODO: fix the calc behavior so this test passes for Sitrus
		assertIncludes("#mainResult", END_WITH, expectedResult)

		selectSet(2, "Kommo-o-RS") # 142 HP
		# guaranteed 5HKO: 142 <= [29 * 5 = 145]
		assertIncludes("#mainResult", END_WITH, "29-34 (20.4 - 23.9%) -- guaranteed 5HKO")
		setP2Item(item)
		if (item == LEFTOVERS)
			# 174 effective HP w/ 4 turns of Leftovers; 182 effective w/ 5 turns
			# possible 6HKO: 174 > [34 * 5 = 170]; [29 * 6 = 174] < 182 <= [34 * 6 = 204]
			expectedResult = "29-34 (20.4 - 23.9%) -- possible 6HKO after Leftovers recovery"
		elsif (item == SITRUS_BERRY)
			# 177 effective HP w/ Sitrus
			# possible 6HKO: [29 * 6 = 174] < 177 <= [34 * 6 = 204]
			expectedResult = "29-34 (16.4 - 19.2%) -- possible 6HKO after Sitrus Berry recovery"
		end
		# TODO: fix the calc behavior so this test passes for Sitrus
		assertIncludes("#mainResult", END_WITH, expectedResult)

		selectSet(2, "Gigalith-RS") # 152 HP
		# possible 5HKO: [27 * 5 = 135] < 152 <= [33 * 5 = 165]
		assertIncludes("#mainResult", END_WITH, "27-33 (17.8 - 21.7%) -- possible 5HKO")
		setP2Item(item) 
		if (item == LEFTOVERS)
			# 188 effective HP w/ 4 turns of Leftovers; 197 effective w/ 5 turns
			# possible 6HKO: 188 > [33 * 5 = 165]; [27 * 6 = 162] < 197 <= [33 * 6 = 198]
			expectedResult = "27-33 (17.8 - 21.7%) -- possible 6HKO after Leftovers recovery"
		elsif (item == SITRUS_BERRY)
			# 190 effective HP w/ Sitrus
			# possible 6HKO: [27 * 6 = 162] < 190 <= [33 * 6 = 198]
			expectedResult = "27-33 (17.8 - 21.7%) -- possible 6HKO after Sitrus Berry recovery"
		end
		# TODO: fix the calc behavior so this test passes for Sitrus
		assertIncludes("#mainResult", END_WITH, expectedResult)
	end

	def test_weather
		weather_test_cases(false)
	end

	def test_net_zero_eot
		weather_test_cases(true)
	end

	def setWeather(weather)
		find(:xpath, ".//label[@for='%s']" % weather).click
	end

	def weather_test_cases(applyLeftovers)
		find(:xpath, ".//label[@for='game8']").click
		
		loadCustomSet(INCINEROAR)
		selectSet(1, "Incineroar (RS Dark)")
		andLeftoversRecovery = " and Leftovers recovery"

		# For applying eot, weather is applied first, then leftovers.
		# This effectively means that a KO can be checked for one instance of hail damage, otherwise the hail and leftovers cancel each other out.

		selectSet(2, "Lurantis-RS") # 169 HP
		# guaranteed OHKO: 169 <= 174
		expectedResult = "174-206 (103 - 121.9%) -- guaranteed OHKO"
		assertIncludes("#mainResult", END_WITH, expectedResult)
		setWeather("hail") # eot does not influence a guaranteed OHKO's result
		assertIncludes("#mainResult", END_WITH, expectedResult)

		setWeather("clear")
		selectSet(2, "Scolipede-RS") # 159 HP
		# possible OHKO: 156 < 159 <= 186
		assertIncludes("#mainResult", END_WITH, "156-186 (98.1 - 117%) -- 81.3% chance to OHKO")
		setWeather("hail") # 150 effective HP w/ 1 turn of Hail
		if (applyLeftovers)
			setP2Item(LEFTOVERS) # 150 effective temporary HP w/ Hail on final turn
		end
		# guaranteed OHKO: 150 <= 156
		assertIncludes("#mainResult", END_WITH, "156-186 (98.1 - 117%) -- guaranteed OHKO after hail damage")

		setWeather("clear")
		selectSet(2, "Comfey-RS") # 150 HP
		# guaranteed 2HKO: 150 <= [76 * 2 = 152]
		assertIncludes("#mainResult", END_WITH, "76-91 (50.7 - 60.7%) -- guaranteed 2HKO")
		setWeather("hail") # 141 effective HP w/ 1 turn of Hail
		if (applyLeftovers)
			setP2Item(LEFTOVERS) # 141 effective temporary HP w/ Hail on final turn
		end
		# guaranteed 2HKO: 141 <= [76 * 2 = 152]
		assertIncludes("#mainResult", END_WITH, "76-91 (50.7 - 60.7%) -- guaranteed 2HKO after hail damage" + (applyLeftovers ? andLeftoversRecovery : ""))

		setWeather("clear") # TODO Pincurchin isn't ideal in case terrain becomes its default ability, which triggers seed
		selectSet(2, "Pincurchin-RS") # 147 HP
		# possible 2HKO: [73 * 2 = 146] < 147 <= [87 * 2 = 174]
		assertIncludes("#mainResult", END_WITH, "73-87 (49.7 - 59.2%) -- 98.4% chance to 2HKO")
		setWeather("hail") # 129 effective HP w/ 2 turns of Hail
		if (applyLeftovers)
			setP2Item(LEFTOVERS) # 138 effective temporary HP w/ Hail on final turn
		end
		# guaranteed 2HKO: [129 or 138] <= [73 * 2 = 146]
		assertIncludes("#mainResult", END_WITH, "73-87 (49.7 - 59.2%) -- guaranteed 2HKO after hail damage" + (applyLeftovers ? andLeftoversRecovery : ""))

		setWeather("clear")
		selectSet(2, "Seaking-RS") # 147 HP
		# guaranteed 3HKO: 147 <= [51 * 3 = 153]
		assertIncludes("#mainResult", END_WITH, "51-60 (34.7 - 40.8%) -- guaranteed 3HKO")
		setWeather("hail") # 129 effective HP w/ 2 turns of Hail
		if (applyLeftovers)
			setP2Item(LEFTOVERS) # 138 effective temporary HP w/ Hail on final turn
		end
		# guaranteed 3HKO: [129 or 138] <= [51 * 3 = 153]
		assertIncludes("#mainResult", END_WITH, "51-60 (34.7 - 40.8%) -- guaranteed 3HKO after hail damage" + (applyLeftovers ? andLeftoversRecovery : ""))

		setWeather("clear")
		selectSet(2, "Salazzle-RS") # 167 HP
		# possible 3HKO: [54 * 3 = 162] < 167 <= [64 * 3 = 192]
		assertIncludes("#mainResult", END_WITH, "54-64 (32.3 - 38.3%) -- 97.1% chance to 3HKO")
		setWeather("hail") # 137 effective HP w/ 3 turns of Hail
		if (applyLeftovers)
			setP2Item(LEFTOVERS) # 157 effective temporary HP w/ Hail on final turn
		end
		# guaranteed 3HKO: [137 or 157] <= [54 * 3 = 162]
		assertIncludes("#mainResult", END_WITH, "54-64 (32.3 - 38.3%) -- guaranteed 3HKO after hail damage" + (applyLeftovers ? andLeftoversRecovery : ""))

		setWeather("clear")
		selectSet(2, "Seismitoad-RS") # 204 HP
		# guaranteed 4HKO: 204 <= [51 * 4 = 204]
		assertIncludes("#mainResult", END_WITH, "51-60 (25 - 29.4%) -- guaranteed 4HKO")
		setWeather("hail")
		if (applyLeftovers)
			setP2Item(LEFTOVERS) # 192 effective temporary HP w/ Hail on final turn
			# guaranteed 4HKO: 192 <= [51 * 4 = 204]
			expectedResult = "51-60 (25 - 29.4%) -- guaranteed 4HKO after hail damage and Leftovers recovery"
		else
			# 168 effective HP w/ 3 turns of Hail
			# possible 3HKO: [51 * 3 = 153] < 168 <= [60 * 3 = 180]
			expectedResult = "51-60 (25 - 29.4%) -- 30.1% chance to 3HKO after hail damage"
		end
		# TODO: fix the calc behavior so this test passes for hail (no leftovers)
		assertIncludes("#mainResult", END_WITH, expectedResult)

		setWeather("clear")
		selectSet(2, "Jellicent-RS") # 199 HP
		# possible 4HKO: [48 * 4 = 192] < 199 <= [57 * 4 = 228]
		assertIncludes("#mainResult", END_WITH, "48-57 (24.1 - 28.6%) -- 96.1% chance to 4HKO")
		setWeather("hail")
		if (applyLeftovers)
			setP2Item(LEFTOVERS) # 187 effective temporary HP w/ Hail on final turn
			# guaranteed 4HKO: 187 <= [48 * 4 = 192]
			expectedResult = "48-57 (24.1 - 28.6%) -- guaranteed 4HKO after hail damage and Leftovers recovery"
		else
			# 163 effective HP w/ 3 turns of Hail
			# possible 3HKO: [48 * 3 = 144] < 163 <= [57 * 3 = 171]
			expectedResult = "48-57 (24.1 - 28.6%) -- 87.1% chance to 3HKO after hail damage"
		end
		# TODO: fix the calc behavior so this test passes for hail (no leftovers)
		assertIncludes("#mainResult", END_WITH, expectedResult)

		setWeather("clear")
		selectSet(2, "Kommo-o-RS") # 142 HP
		# guaranteed 5HKO: 142 <= [29 * 5 = 145]
		assertIncludes("#mainResult", END_WITH, "29-34 (20.4 - 23.9%) -- guaranteed 5HKO")
		setWeather("hail")
		if (applyLeftovers)
			setP2Item(LEFTOVERS) # 134 effective temporary HP w/ Hail on final turn
			# possible 4HKO: [29 * 4 = 116] < 134 <= [34 * 4 = 136]
			expectedResult = "29-34 (20.4 - 23.9%) -- 0.2% chance to 4HKO after hail damage and Leftovers recovery"
		else
			# 110 effective HP w/ 4 turns of Hail
			# guaranteed 4HKO: 110 <= [29 * 4 = 116]
			expectedResult = "29-34 (20.4 - 23.9%) -- guaranteed 4HKO after hail damage"
		end
		assertIncludes("#mainResult", END_WITH, expectedResult)

		setWeather("clear")
		selectSet(2, "Poliwrath-RS") # 189 HP
		# possible 5HKO: [36 * 5 = 180] < 189 <= [43 * 5 = 215]
		assertIncludes("#mainResult", END_WITH, "36-43 (19 - 22.8%) -- possible 5HKO")
		setWeather("hail")
		if (applyLeftovers)
			setP2Item(LEFTOVERS) # 178 effective temporary HP w/ Hail on final turn
			# guaranteed 5HKO: 178 <= [36 * 5 = 180]
			expectedResult = "36-43 (19 - 22.8%) -- guaranteed 5HKO after hail damage and Leftovers recovery"
		else
			# 134 effective HP w/ 5 turns of Hail
			# guaranteed 4HKO: 134 <= [36 * 4 = 144]
			expectedResult = "36-43 (19 - 22.8%) -- guaranteed 4HKO after hail damage"
		end
		assertIncludes("#mainResult", END_WITH, expectedResult)
	end

	def setSpikes(layers)
		find(:xpath, ".//label[@for='spikesR%d']" % layers).click
	end

	def test_hazards
		find(:xpath, ".//label[@for='game8']").click
		
		loadCustomSet(INCINEROAR)
		selectSet(1, "Incineroar (RS Dark)")

		selectSet(2, "Morpeko-RS") # 157 HP
		# guaranteed 2HKO: 157 <= [112 * 2 = 224]
		assertIncludes("#mainResult", END_WITH, "112-133 (71.3 - 84.7%) -- guaranteed 2HKO")
		setSpikes(1) # 138 effective HP after 1 layer of Spikes
		# guaranteed 2HKO: 138 <= [112 * 2 = 224]
		assertIncludes("#mainResult", END_WITH, "112-133 (71.3 - 84.7%) -- guaranteed 2HKO after 1 layer of Spikes")
		setSpikes(2) # 131 effective HP after 2 layers of Spikes
		# possible OHKO: 112 < 131 <= 133
		assertIncludes("#mainResult", END_WITH, "112-133 (71.3 - 84.7%) -- 12.5% chance to OHKO after 2 layers of Spikes")
		setSpikes(3) # 118 effective HP after 3 layers of Spikes
		# possible OHKO: 112 < 118 <= 133
		assertIncludes("#mainResult", END_WITH, "112-133 (71.3 - 84.7%) -- 75% chance to OHKO after 3 layers of Spikes")

		setSpikes(0)
		selectSet(2, "Cloyster-RS") # 117 HP
		# guaranteed 3HKO: 117 <= [42 * 3 = 126]
		assertIncludes("#mainResult", END_WITH, "42-49 (35.9 - 41.9%) -- guaranteed 3HKO")
		setSpikes(1) # 103 effective HP after 1 layer of Spikes
		# guaranteed 3HKO: 103 <= [42 * 3 = 126]
		assertIncludes("#mainResult", END_WITH, "42-49 (35.9 - 41.9%) -- guaranteed 3HKO after 1 layer of Spikes")
		setSpikes(2) # 98 effective HP after 2 layers of Spikes
		# possible 2HKO: [42 * 2 = 84] < 98 <= [49 * 2 = 98]
		assertIncludes("#mainResult", END_WITH, "42-49 (35.9 - 41.9%) -- 0.4% chance to 2HKO after 2 layers of Spikes")
		setSpikes(3) # 88 effective HP after 3 layers of Spikes
		# possible 2HKO: [42 * 2 = 84] < 88 <= [49 * 2 = 98]
		assertIncludes("#mainResult", END_WITH, "42-49 (35.9 - 41.9%) -- 78.9% chance to 2HKO after 3 layers of Spikes")

		setSpikes(0)
		selectSet(2, "Greedent-RS") # 219 HP
		# guaranteed 4HKO: 219 <= [57 * 4 = 228]
		assertIncludes("#mainResult", END_WITH, "57-67 (26 - 30.6%) -- guaranteed 4HKO")
		setSpikes(1) # 192 effective HP after 1 layer of Spikes
		# possible 3HKO: [57 * 3 = 171] < 192 <= [67 * 3 = 201]
		assertIncludes("#mainResult", END_WITH, "57-67 (26 - 30.6%) -- 11% chance to 3HKO after 1 layer of Spikes")
		setSpikes(2) # 183 effective HP after 2 layers of Spikes
		# possible 3HKO: [57 * 3 = 171] < 183 <= [67 * 3 = 201]
		assertIncludes("#mainResult", END_WITH, "57-67 (26 - 30.6%) -- 63.9% chance to 3HKO after 2 layers of Spikes")
		setSpikes(3) # 165 effective HP after 3 layers of Spikes
		# guaranteed 3HKO: 165 <= [57 * 3 = 171]
		assertIncludes("#mainResult", END_WITH, "57-67 (26 - 30.6%) -- guaranteed 3HKO after 3 layers of Spikes")
	end

	def test_multistrike
		find(:xpath, ".//label[@for='game8']").click
		
		loadCustomSet(HERACROSS)
		selectSet(1, "Heracross (RS Bug)")

		# Bullet Seed, 2 hits
		find("#p1 .move1 .move-hits option[value='2']").select_option

		setAttackBoost(1)
		selectSet(2, "Drednaw-RS") # 189 HP
		expectedResult = "200-240 (105.8 - 127%) -- guaranteed OHKO"
		assertIncludes("#mainResult", END_WITH, expectedResult)
		setP2Item(LEFTOVERS) # eot healing does not influence an OHKO's result
		assertIncludes("#mainResult", END_WITH, expectedResult)
		setP2Item(MAGO_BERRY) # There is no chance for Mago Berry to trigger
		assertIncludes("#mainResult", END_WITH, expectedResult)
		setP2Item(SITRUS_BERRY)
		# 236 effective HP w/ Sitrus
		# possible OHKO: [100 * 2 = 100] < 236 <= [120 * 2 = 240]
		assertIncludes("#mainResult", END_WITH, "200-240 (105.8 - 127%) -- 2.7% chance to OHKO after Sitrus Berry recovery")
		find("#p1 .at .evs").set(0)
		# There is a chance to OHKO because triggering Sitrus can be avoided by low rolling the first strike then high rolling the second
		assertIncludes("#mainResult", END_WITH, "168-200 (88.9 - 105.8%) -- 1.6% chance to OHKO")
		setAttackBoost(0)

		# 3 and 4 hits into Mago
		find("#p1 .move1 .move-hits option[value='3']").select_option
		selectSet(2, "Quagsire-RS") # Quagsire already holds Leftovers; eot healing does not influence an OHKO's result
		result = find("#mainResult").text
		assertIncludes("#mainResult", END_WITH, "180-216 (92.8 - 111.3%) -- 51% chance to OHKO")
		setP2Item("")
		assert_equal(result, find("#mainResult").text)

		setWeather("hail")
		result = find("#mainResult").text
		assertIncludes("#mainResult", END_WITH, "180-216 (92.8 - 111.3%) -- 98.4% chance to OHKO after hail damage")
		setP2Item(LEFTOVERS) # eot healing does not influence an OHKO's result
		assert_equal(result, find("#mainResult").text)
		find("#p1 .at .evs").set(252)
		setWeather("clear")

		setP2Item(MAGO_BERRY) # 258 effective HP w/ Mago
		# With 3 hits with Bullet Seed, 1.6% chance for the first two hits to both roll low and not activate Mago, then the third hit always OHKOs.
		# Quagsire has 258 effective HP with Wiki, which only OHKOs 0.3% of the time. So 1.9% should be right.
		# The Berry recovery text should also be present because there is a chance to deal more damage than current HP + berry recovery.
		assertIncludes("#mainResult", END_WITH, "216-264 (111.3 - 136.1%) -- 1.9% chance to OHKO after Mago Berry recovery")

		find("#p1 .move1 .move-hits option[value='4']").select_option
		selectSet(2, "Lunatone-RS")
		assertIncludes("#mainResult", END_WITH, "176-216 (93.1 - 114.3%) -- 90.6% chance to OHKO")
		setP2Item(MAGO_BERRY)
		# 4 hits with Bullet Seed
		# 13.3% chance to not trigger Mago with the first three hits, so the chance to OHKO should be less than that.
		assertIncludes("#mainResult", END_WITH, "176-216 (93.1 - 114.3%) -- 3.6% chance to OHKO")
	end

	def test_parental_bond
		find(:xpath, ".//label[@for='game7']").click
		loadCustomSet(JEJUNUM)
		selectSet(1, "Kangaskhan (JEJUNUM)")
		selectSet(2, "Flareon-4")

		find("#p1 .ability option[value='']").select_option

		# Earthquake, no ability
		gen7NoAbilityDoubleEarthquakeResult = find("#mainResult").text
		assertIncludes("#mainResult", INCLUDE, "(spread)")

		# Seismic Toss, no ability
		find(:xpath, ".//label[@for='resultMoveL2']").click
		assert_equal("(50)", find("#damageValues").text)

		first("#p1 .ability option[value='Parental Bond']", minimum: 1).select_option

		# Seismic Toss
		assert_equal("(100)", find("#damageValues").text)

		# Earthquake Doubles
		find(:xpath, ".//label[@for='resultMoveL1']").click
		assert_equal(gen7NoAbilityDoubleEarthquakeResult, find("#mainResult").text)
		assertIncludes("#mainResult", INCLUDE, "(spread)")
		refute(find("#damageValues").text.include?("Second hit"))

		# Earthquake Singles
		find(:xpath, ".//label[@for='singles']").click
		gen7EarthquakeSingleResult = find("#mainResult").text
		# first hit is 158-186, second is 38-46, totals to 196-232
		assertIncludes("#mainResult", END_WITH, "196-232 (140 - 165.7%) -- guaranteed OHKO")
		assertIncludes("#damageValues", INCLUDE, "Second hit")

		find("#p1 .ability option[value='']").select_option
		gen7NoAbilitySingleEarthquakeResult = find("#mainResult").text

		# Earthquake Singles Gen 6
		find(:xpath, ".//label[@for='game6']").click
		selectSet(1, "Kangaskhan (JEJUNUM)")
		selectSet(2, "Flareon-4")

		# The gen 6 result should be different from gen 7's due to Parental Bond's changed modifier
		refute_equal(gen7EarthquakeSingleResult, find("#mainResult").text)
		assertIncludes("#damageValues", INCLUDE, "Second hit")
		# The gen 6 result should equal gen 7's non-Parental Bond result
		find("#p1 .ability option[value='']").select_option
		assert_equal(gen7NoAbilitySingleEarthquakeResult, find("#mainResult").text)
		refute(find("#damageValues").text.include?("Second hit"))
		
		find(:xpath, ".//label[@for='game7']").click
		selectSet(1, "Kangaskhan (JEJUNUM)")
		selectSet(2, "Flareon-4")

		# Return
		find(:xpath, ".//label[@for='resultMoveL3']").click
		returnDamageValues = find("#damageValues").text
		# first hit is 120-142, second is 30-36, totals to 150-178
		assertIncludes("#mainResult", END_WITH, "150-178 (107.1 - 127.1%) -- guaranteed OHKO")
		assertIncludes("#damageValues", INCLUDE, "Second hit")

		# Chilan Berry
		setP2Item("Chilan Berry")
		refute_equal(returnDamageValues, find("#damageValues").text)
		# first hit is 60-71, second is 30-36, totals to 90-107
		assertIncludes("#mainResult", END_WITH, "Chilan Berry (first hit only) Flareon-4: 90-107 (64.3 - 76.4%) -- guaranteed 2HKO")
		assertIncludes("#damageValues", INCLUDE, "Second hit")

		# Power-Up Punch
		find(:xpath, ".//label[@for='resultMoveL4']").click
		powerUpPunchResult = find("#mainResult").text
		# first hit is 32-38, second is 11-14, totals to 43-52
		assertIncludes("#mainResult", END_WITH, "43-52 (30.7 - 37.1%) -- 72.3% chance to 3HKO")
		powerUpPunchDamageValues = find("#damageValues").text

		# Mach Punch is a 40 BP Fighting move, so use it to compare results with Power-Up Punch
		find("#p1 .move4 .select2-container.move-selector").click
		find("li.select2-result", text: "Mach Punch").click
		refute_equal(powerUpPunchResult, find("#mainResult").text)
		refute_equal(powerUpPunchDamageValues, find("#damageValues").text)

		# Multihit move
		find("#p1 .move4 .select2-container.move-selector").click
		find("li.select2-result", text: "Icicle Spear").click
		refute(find("#mainResult").text.include?("Parental Bond"))
		refute(find("#damageValues").text.include?("First hit"))

		# TODO fix this behavior then flesh out this test case
		# Drain Punch
		find("#p1 .move4 .select2-container.move-selector").click
		find("li.select2-result", text: "Drain Punch").click
		selectSet(2, "Houndoom-3")
		refute(find("#mainResult").text.include?("recovers 75-70"))
	end

	def test_meteor_beam
		find(:xpath, ".//label[@for='game8']").click
		selectSet(1, "Gigalith-RS")

		assertIncludes("#mainResult", START_WITH, "+1")
		find(:xpath, ".//label[@for='resultMoveL2']").click
		refute(find("#mainResult").text.start_with?("+1"))
	end

	def test_first_hit_only
		find(:xpath, ".//label[@for='game8']").click
		
		loadCustomSet(HERACROSS)
		selectSet(1, "Heracross (RS Bug)")

		selectSet(2, "Kingler-RS") # 122 HP
		setP2Item("Rindo Berry")

		# Bullet Seed, 3 hits
		# min damage: first attack: 11 + 22 * 2 = 55; second attack: 22 * 3 = 66
		# max damage: first attack: 14 + 28 * 2 = 70; second attack: 28 * 3 = 84
		# possible 2HKO: [55 + 66 = 121] < 122 <= [70 + 84 = 154]
		assertIncludes("#mainResult", END_WITH, "Rindo Berry (first strike only) Kingler-RS: 55-70 (45.1 - 57.4%) -- 100% chance to 2HKO")
		assertIncludes("#damageValues", INCLUDE, "Other hits")
		assertIncludes("#damageValues", INCLUDE, "Other attacks 3 hits")
		# Bullet Seed, 5 hits
		# possible OHKO: [11 + 22 * 4 = 99] < 122 <= [14 + 28 * 4 = 126]
		find("#p1 .move1 .move-hits option[value='5']").select_option
		assertIncludes("#mainResult", END_WITH, "Rindo Berry (first strike only) Kingler-RS: 99-126 (81.1 - 103.3%) -- 0.1% chance to OHKO")
		assertIncludes("#damageValues", INCLUDE, "Other hits")

		# Shadow Shield
		selectBlankSet(2, "Lunala")
		assertIncludes("#mainResult", END_WITH, "Shadow Shield (first strike only) Lunala: 72-85 (34 - 40.1%) -- guaranteed 3HKO")
		assertIncludes("#damageValues", INCLUDE, "Other hits")
		assertIncludes("#damageValues", INCLUDE, "Other attacks 5 hits")

		# Gem
		selectSet(1, "Porygon-Z-RS") # holds Normal Gem
		selectSet(2, "Kangaskhan-RS")
		find(:xpath, ".//label[@for='resultMoveL2']").click # Tri Attack
		assertIncludes("#mainResult", END_WITH, "115-136 (56.4 - 66.7%) -- 99.6% chance to 2HKO")
		assertIncludes("#mainResult", INCLUDE, "Normal Gem (first hit only)")
		assertIncludes("#damageValues", INCLUDE, "Other hits")

		# Gem + Multistrike
		find("#p1 .move2 .select2-container.move-selector").click
		find("li.select2-result", text: "Tail Slap").click
		assertIncludes("#mainResult", END_WITH, "57-72 (27.9 - 35.3%) -- 100% chance to 4HKO")
		assertIncludes("#mainResult", INCLUDE, "Normal Gem (first attack only)")
		assertIncludes("#damageValues", INCLUDE, "Other attack hits")
		assertIncludes("#damageValues", INCLUDE, "First attack 3 hits")
		assertIncludes("#damageValues", INCLUDE, "Other attacks 3 hits")

		# Knock Off
		selectSet(1, "Crawdaunt-RS")
		selectSet(2, "Boltund-RS")
		assertIncludes("#mainResult", END_WITH, "136-162 (100 - 119.1%) -- guaranteed OHKO")
		assertIncludes("#mainResult", INCLUDE, "Knock Off (97 BP)")
		assertIncludes("#damageValues", INCLUDE, "First hit")
		assertIncludes("#damageValues", INCLUDE, "Other hits")

		selectSet(2, "Escavalier-RS")
		assertIncludes("#mainResult", END_WITH, "84-100 (49.7 - 59.2%) -- 0.4% chance to 2HKO")
		assertIncludes("#mainResult", INCLUDE, "Knock Off (97 BP)")
		assertIncludes("#damageValues", INCLUDE, "First hit")
		assertIncludes("#damageValues", INCLUDE, "Other hits")

		# Knock Off + Sitrus
		selectSet(2, "Musharna-RS")
		setAttackBoost(-1)
		assertIncludes("#mainResult", END_WITH, "126-150 (58.6 - 69.8%) -- guaranteed 3HKO after Sitrus Berry recovery")
		assertIncludes("#mainResult", INCLUDE, "Knock Off (97 BP)")
		assertIncludes("#damageValues", INCLUDE, "First hit")
		assertIncludes("#damageValues", INCLUDE, "Other hits")

		# Knock Off + Colbur Berry
		setAttackBoost(0)
		setP2Item("Colbur Berry")
		assertIncludes("#mainResult", END_WITH, "Colbur Berry (first hit only) Musharna-RS: 93-111 (43.3 - 51.6%) -- guaranteed 2HKO")
		assertIncludes("#mainResult", INCLUDE, "Knock Off (97 BP)")
		assertIncludes("#damageValues", INCLUDE, "First hit")
		assertIncludes("#damageValues", INCLUDE, "Other hits")

		# Knock Off + Eviolite
		selectSet(2, "Porygon2-RS")
		assertIncludes("#mainResult", END_WITH, "Eviolite (first hit only) Porygon2-RS: 45-54 (24.5 - 29.3%) -- 100% chance to 4HKO")
		assertIncludes("#mainResult", INCLUDE, "Knock Off (97 BP)")
		assertIncludes("#damageValues", INCLUDE, "First hit")
		assertIncludes("#damageValues", INCLUDE, "Other hits")

		# Throat Spray
		selectSet(1, "Meowstic-M-RS") # holds Throat Spray
		selectSet(2, "Cloyster-RS")
		find(:xpath, ".//label[@for='resultMoveL3']").click # Disarming Voice
		assertIncludes("#mainResult", END_WITH, "37-44 (31.6 - 37.6%) -- guaranteed 3HKO")
		assertIncludes("#damageValues", INCLUDE, "Other hits")

		# Tera Stellar
		find(:xpath, ".//label[@for='game9']").click
		selectSet(1, "Heracross (RS Bug)")
		setAttackBoost(-2)
		selectSet(2, "Incineroar (RS Dark)")
		find(:xpath, ".//label[@for='resultMoveL3']").click # Low Kick
		assertIncludes("#mainResult", END_WITH, "62-74 (32 - 38.1%) -- 94.1% chance to 3HKO")
		find("#p1 .tera-type option[value='Stellar']").select_option
		find(:xpath, ".//label[@for='teraL']").click
		assertIncludes("#mainResult", END_WITH, "84-100 (43.3 - 51.5%) -- guaranteed 3HKO")
		assertIncludes("#damageValues", INCLUDE, "First hit")
		assertIncludes("#damageValues", INCLUDE, "Other hits")

		# Tera Stellar Terapagos
		selectBlankSet(1, "Terapagos-Terastal")

		find("#p1 .move1 .select2-container.move-selector").click
		find("li.select2-result", text: "Tri Attack").click
		find("#p1 .tera-type option[value='Stellar']").select_option
		find(:xpath, ".//label[@for='teraL']").click
		assert_equal("Terapagos-Stellar", find("#p1 .forme").value)
		assertIncludes("#mainResult", END_WITH, "82-98 (42.3 - 50.5%) -- 2% chance to 2HKO")
		refute(find("#damageValues").text.include?("First hit"))
		refute(find("#damageValues").text.include?("Other hits"))

		# Tera Shell
		selectBlankSet(2, "Terapagos-Terastal")
		find("#p1 .sa .boost option[value='1']").select_option
		assertIncludes("#mainResult", END_WITH, "Tera Shell (first hit only) Terapagos-Terastal: 52-62 (30.6 - 36.5%) -- 55.5% chance to 2HKO")
	end

	def test_triple_axel
		oneModifierEnding = "142-174 (85.5 - 104.8%) -- 5.1% chance to OHKO"
		find(:xpath, ".//label[@for='game8']").click
		selectSet(1, "Cinccino-RS")
		setAttackBoost(-1)
		selectBlankSet(2, "Dragonite")
		find(:xpath, ".//label[@for='resultMoveL4']").click # Triple Axel
		assertIncludes("#mainResult", END_WITH, "156-192 (94 - 115.7%) -- 82.5% chance to OHKO")
		check_triple_axel_text(3)

		ability = "Multiscale"
		first("#p2 .ability option[value='%s']" % ability, minimum: 1).select_option
		assertIncludes("#mainResult", END_WITH, oneModifierEnding)
		assertIncludes("#mainResult", INCLUDE, ability + " (first strike only)")
		check_triple_axel_text(3)

		item = "Yache Berry"
		setP2Item(item)
		assertIncludes("#mainResult", END_WITH, "135-165 (81.3 - 99.4%) -- guaranteed 2HKO")
		assertIncludes("#mainResult", INCLUDE, ability + " (first strike only)")
		assertIncludes("#mainResult", INCLUDE, item + " (first strike only)")
		check_triple_axel_text(3)
		assertIncludes("#damageValues", INCLUDE, "First attack 3 hits")
		assertIncludes("#damageValues", INCLUDE, "Other attacks 3 hits")

		find("#p2 .ability option[value='']").select_option
		assertIncludes("#mainResult", END_WITH, oneModifierEnding)
		assertIncludes("#mainResult", INCLUDE, item + " (first strike only)")
		check_triple_axel_text(3)

		setP2Item("")


		find("#p1 .move4 .move-hits option[value='2']").select_option

		setAttackBoost(1)
		assertIncludes("#mainResult", END_WITH, "168-200 (101.2 - 120.5%) -- guaranteed OHKO")
		check_triple_axel_text(2)

		setP2Item(item)
		assertIncludes("#mainResult", END_WITH, "140-166 (84.3 - 100%) -- 0.4% chance to OHKO")
		assertIncludes("#mainResult", INCLUDE, item + " (first strike only)")
		check_triple_axel_text(2)

		first("#p2 .ability option[value='%s']" % ability, minimum: 1).click
		assertIncludes("#mainResult", END_WITH, "126-149 (75.9 - 89.8%) -- guaranteed 2HKO")
		assertIncludes("#mainResult", INCLUDE, ability + " (first strike only)")
		assertIncludes("#mainResult", INCLUDE, item + " (first strike only)")
		check_triple_axel_text(2)
		assertIncludes("#damageValues", INCLUDE, "First attack 2 hits")
		assertIncludes("#damageValues", INCLUDE, "Other attacks 2 hits")

		setP2Item("")
		assertIncludes("#mainResult", END_WITH, "140-166 (84.3 - 100%) -- 0.4% chance to OHKO")
		assertIncludes("#mainResult", INCLUDE, ability + " (first strike only)")
		check_triple_axel_text(2)
	end

	def check_triple_axel_text(hits)
		assertIncludes("#mainResult", INCLUDE, hits == 2 ? "(20, 40 BP) (2 hits)" : "(20, 40, 60 BP) (3 hits)")
		assertIncludes("#damageValues", INCLUDE, "Second hit")
		includesThird = find("#damageValues").text.include?("Third hit")
		if (hits == 3)
			assert(includesThird)
		else
			refute(includesThird)
		end
		assertIncludes("#damageValues", INCLUDE, "%d hits" % hits)
	end

end
