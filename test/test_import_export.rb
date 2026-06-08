require "CalcTest"

class ImportExportTestCase < CalcTest

	def test_import
		find(:xpath, './/label[@for="game7"]').click

		loadCustomSet(%q{JEJUNUM (Kangaskhan) @ Kangaskhanite  
Ability: Parental Bond
Adamant Nature
EVs: 244 HP / 44 Atk / 28 Def / 52 SpD / 140 Spe
- Fake Out
- Double-Edge
- Sucker Punch
- Seismic Toss})

		assert(page.evaluate_script("SETDEX_CUSTOM['Kangaskhan']['JEJUNUM']"))

		selectSet(1, "Kangaskhan (JEJUNUM)")


		assert_equal("Mega Kangaskhan",
			find("#p1 .forme").value)

		assert_equal("",
			find("#p1 .item").value)
		assert_equal("Parental Bond",
			find("#p1 .ability").value)

		assert_equal("Adamant",
			find("#p1 .nature").value)
		assert_equal("244",
			find("#p1 .hp .evs").value)
		assert_equal("44",
			find("#p1 .at .evs").value)
		assert_equal("28",
			find("#p1 .df .evs").value)
		assert_equal("0",
			find("#p1 .sa .evs").value)
		assert_equal("52",
			find("#p1 .sd .evs").value)
		assert_equal("140",
			find("#p1 .sp .evs").value)

		assert_equal("Fake Out",
			find(:xpath, './/label[@for="resultMoveL1"]').text)
		assert_equal("Double-Edge",
			find(:xpath, './/label[@for="resultMoveL2"]').text)
		assert_equal("Sucker Punch",
			find(:xpath, './/label[@for="resultMoveL3"]').text)
		assert_equal("Seismic Toss",
			find(:xpath, './/label[@for="resultMoveL4"]').text)

		assert_equal("44+ Atk Parental Bond Mega Kangaskhan Fake Out vs. 168 HP / 168+ Def Abomasnow-1: 38-46 (20.4 - 24.7%) -- possible 5HKO after Leftovers recovery",
			find("#mainResult").text)
	end

	def test_import_named_as_ai_set
		find("#spreadName").set("Zapdos-2")
		find("#customMon").set(%q{Zapdos @ Misty Seed
Ability: Pressure
Modest Nature
EVs: 188 HP / 108 Def / 140 SpA / 28 SpD / 44 Spe
IVs: 0 Atk / 30 Def
- Tailwind
- Thunderbolt
- Hidden Power Ice
- Roost})
		accept_alert do
			accept_alert do
				click_button("Save")
			end
		end

		assert_nil(page.evaluate_script("SETDEX_CUSTOM['Zapdos']"))
	end

	def test_export_megas
		find(:xpath, './/label[@for="game7"]').click

		selectSet(1, "Scizor-4")
		find("#exportL").click
		assert_equal(%q{Scizor-Mega @ Scizorite
Ability: Technician
Adamant Nature
EVs: 252 HP / 252 Atk
- X-Scissor
- Aerial Ace
- Roost
- Bullet Punch},
			find("#customMon").value)

		selectSet(1, "Charizard-3")
		find("#exportL").click
		assert_equal(%q{Charizard-Mega-Y @ Charizardite Y
Ability: Drought
Timid Nature
EVs: 252 SpA / 252 Spe
- Heat Wave
- Solar Beam
- Air Slash
- Focus Blast},
			find("#customMon").value)
	end

end
