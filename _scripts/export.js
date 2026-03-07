function exportToPsFormat(pokeInfo) {
	let pokemon = new Pokemon(pokeInfo);
	let finalText = "";
	let evSum = 0;
	let ivSum = 0;
	let evsAlert = false;
	let speciesName = pokemon.name;
	if (pokemon.name.startsWith("Mega ")) {
		speciesName = pokemon.name.substring(5);
		if ([" X", " Y", " Z"].some(suffix => speciesName.endsWith(suffix))) {
			speciesName = speciesName.substring(0, speciesName.length - 2) + "-Mega-" + speciesName[speciesName.length - 1];
		}
		else {
			speciesName += "-Mega";
		}
		if (speciesName !== "Rayquaza-Mega") {
			for (let [megaStone, megaSpeciesName] of Object.entries(MEGA_STONE_LOOKUP)) {
				if (pokemon.name === megaSpeciesName) {
					pokemon.item = megaStone;
					break;
				}
			}
		}
	}

	// convert items that have old names in old gens
	let item = pokemon.item;
	if (gen < 6 && item) {
		for (let [oldName, newName] of Object.entries(oldItemNames)) {
			if (item === newName) {
				item = oldName;
				break;
			}
		}
	}
	finalText = speciesName + (item ? " @ " + item : "") + "\n";
	finalText += pokemon.ability ? "Ability: " + pokemon.ability + "\n" : "";
	finalText += pokemon.level !== 50 || gen == 3 || gen == 4 ? "Level: " + pokemon.level + "\n" : "";
	finalText += pokemon.teraType ? "Tera Type: " + pokemon.teraType + "\n" : "";
	finalText += pokemon.nature && gen > 2 ? pokemon.nature + " Nature" + "\n" : "";
	finalText += "EVs: ";
	let EVs_Array = [];
	if (pokemon.HPEVs && pokemon.HPEVs > 0) {
		evSum += pokemon.HPEVs;
		EVs_Array.push(pokemon.HPEVs + " HP");
	}
	for (stat in pokemon.evs) {
		if (pokemon.evs[stat]) {
			evSum += pokemon.evs[stat];
			EVs_Array.push(pokemon.evs[stat] + " " + toSmogonStat(stat));
		}
	}
	if (evSum > 510) {
		evsAlert = true;
	}

	let ivArray = [];
	let IVs_Array = [];
	if (pokemon.HPIVs != -1) {
		ivSum += pokemon.HPIVs;
		//IVs_Array.push(pokemon.HPIVs + " HP");
		if (pokemon.HPIVs != 31) {
			ivArray.push(pokemon.HPIVs + " HP");
		}
	}
	for (stat in pokemon.ivs) {
		if (pokemon.ivs[stat]) {
			ivSum += pokemon.ivs[stat];
		}
		if (pokemon.ivs[stat] < 31) {
			ivArray.push(pokemon.ivs[stat] + " " + toSmogonStat(stat));
		}
	}

	for (let i = 0; i < ivArray.length - 2; i++) {
		IVs_Array.push(ivArray[i]);
	}

	finalText += EVs_Array.join(" / ");
	finalText += "\n";

	if (ivSum < 186) {
		finalText += "IVs: ";
		finalText += IVs_Array.join(" / ");
		finalText += "\n";
	}

	let movesArray = [];
	for (i = 0; i < 4; i++) {
		let moveName = pokemon.baseMoveNames[i];
		if (moveName !== "(No Move)") {
			finalText += "- " + moveName + "\n";
		}
	}
	finalText = finalText.trim();

	if (evsAlert === true) {
		alert("Exported Pokemon has " + evSum + " EVs and is therefore illegal. Exported set anyway.");
	}

	$("#customMon").val(finalText).select();
}