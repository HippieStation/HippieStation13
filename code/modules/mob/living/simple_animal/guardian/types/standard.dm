//Standard
/mob/living/simple_animal/hostile/guardian/punch
	melee_damage_lower = 30//original damage on hippie was 30
	melee_damage_upper = 30
	obj_damage = 80
	next_move_modifier = 0.8 //attacks 20% faster
	environment_smash = 2
	playstyle_string = "<span class='holoparasite'>As a <b>standard</b> type you have no special abilities, but have a high damage resistance and a powerful attack capable of smashing through walls.</span>"
	magic_fluff_string = "<span class='holoparasite'>..And draw the Assistant, faceless and generic, but never to be underestimated.</span>"
	tech_fluff_string = "<span class='holoparasite'>Boot sequence complete. Standard combat modules loaded. Holoparasite swarm online.</span>"
	carp_fluff_string = "<span class='holoparasite'>CARP CARP CARP! You caught one! It's really boring and standard. Better punch some walls to ease the tension.</span>"
	var/battlecry = "AT"
	var/holopunchrng = null
	mob_reflect_chance = 40

/mob/living/simple_animal/hostile/guardian/punch/verb/Battlecry()
	set name = "Set Battlecry"
	set category = "Guardian"
	set desc = "Choose what you shout as you punch people."
	var/input = stripped_input(src,"What do you want your battlecry to be? Max length of 6 characters.", ,"", 7)
	if(input)
		battlecry = input



/mob/living/simple_animal/hostile/guardian/punch/AttackingTarget(mob/living/T, mob/living/carbon/human/H)
	..()
	if(istype(T))
		switch(holopunchrng)
			if(50 to 100)
				src.say("[src.battlecry][src.battlecry][src.battlecry][src.battlecry][src.battlecry][src.battlecry][src.battlecry][src.battlecry][src.battlecry][src.battlecry]\
				[src.battlecry][src.battlecry][src.battlecry][src.battlecry][src.battlecry]")
				playsound(loc, src.attack_sound, 50, 1, 1)
				playsound(loc, src.attack_sound, 50, 1, 1)
				playsound(loc, src.attack_sound, 50, 1, 1)
				playsound(loc, src.attack_sound, 50, 1, 1)
				H.apply_effect(2, STUN)//change to 2 cause 1 does nothing apparently
			if(20 to 50)
				src.say("[src.battlecry]")
				H.apply_effect(4, WEAKEN)
			if(0 to 20)
				if(istype(target, /mob/living/carbon/human))
					src.say("[src.battlecry][src.battlecry][src.battlecry]")//i couldnt figure out how 2 do organ damage in this rebase so i just put other bad shit here.
					H.bleed_rate = 3
					H.hallucination = 10 //sim braindamage
					H.apply_effect(2, WEAKEN)
				else ..()
