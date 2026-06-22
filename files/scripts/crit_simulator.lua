function damage_about_to_be_received(damage, x, y, attacker, crit_chance)
	if crit_chance == 0 then
		crit_chance = GameGetGameEffectCount(GetUpdatedEntityID(), "JARATE") * .15 + GameGetGameEffectCount(attacker, "CRITICAL_HIT_BOOST") * .15
	end

	SetRandomSeed(x + GameGetFrameNum(), y)
	if Random() <= crit_chance then
		damage = damage * 5 * math.max(crit_chance * .01, 1)
		GamePlaySound("data/audio/Desktop/projectiles.bank", "player_projectiles/critical_hit/create", x, y)
		--todo: more effect stuff
	end
	return damage,crit_chance
end