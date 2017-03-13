
/datum/reagent/thermite
	name = "Thermite"
	id = "thermite"
	description = "Thermite produces an aluminothermic reaction known as a thermite reaction. Can be used to melt walls."
	reagent_state = SOLID
	color = "#550000"

/datum/reagent/thermite/reaction_turf(turf/T, reac_volume)
	if(reac_volume >= 1 && iswallturf(T))
		var/turf/closed/wall/Wall = T
		if(istype(Wall, /turf/closed/wall/r_wall))
			Wall.thermite = Wall.thermite+(reac_volume*2.5)
		else
			Wall.thermite = Wall.thermite+(reac_volume*10)
		Wall.overlays = list()
		Wall.add_overlay(image('icons/effects/effects.dmi',"thermite"))

/datum/reagent/thermite/on_mob_life(mob/living/M)
	M.adjustFireLoss(1, 0)
	..()
	. = 1

/datum/reagent/nitroglycerin
	name = "Nitroglycerin"
	id = "nitroglycerin"
	description = "Nitroglycerin is a heavy, colorless, oily, explosive liquid obtained by nitrating glycerol."
	color = "#808080" // rgb: 128, 128, 128

/datum/reagent/stabilizing_agent
	name = "Stabilizing Agent"
	id = "stabilizing_agent"
	description = "Keeps unstable chemicals stable. This does not work on everything."
	reagent_state = LIQUID
	color = "#FFFF00"

/datum/reagent/clf3
	name = "Chlorine Trifluoride"
	id = "clf3"
	description = "Makes a temporary 3x3 fireball when it comes into existence, so be careful when mixing. ClF3 applied to a surface burns things that wouldn't otherwise burn, sometimes through the very floors of the station and exposing it to the vacuum of space."
	reagent_state = LIQUID
	color = "#FFC8C8"
	metabolization_rate = 4

/datum/reagent/clf3/on_mob_life(mob/living/M)
	M.adjust_fire_stacks(2)
	var/burndmg = max(0.3*M.fire_stacks, 0.3)
	M.adjustFireLoss(burndmg, 0)
	..()
	. = 1

/datum/reagent/clf3/reaction_turf(turf/T, reac_volume)
	if(istype(T, /turf/open/floor/plating))
		var/turf/open/floor/plating/F = T
		if(prob(10 + F.burnt + 5*F.broken)) //broken or burnt plating is more susceptible to being destroyed
			F.ChangeTurf(F.baseturf)
	if(isfloorturf(T))
		var/turf/open/floor/F = T
		if(prob(reac_volume))
			F.make_plating()
		else if(prob(reac_volume))
			F.burn_tile()
		if(isfloorturf(F))
			for(var/turf/turf in range(1,F))
				if(!locate(/obj/effect/hotspot) in turf)
					new /obj/effect/hotspot(F)
	if(iswallturf(T))
		var/turf/closed/wall/W = T
		if(prob(reac_volume))
			W.ChangeTurf(/turf/open/floor/plating)

/datum/reagent/clf3/reaction_mob(mob/living/M, method=TOUCH, reac_volume)
	if(istype(M))
		if(method != INGEST && method != INJECT)
			M.adjust_fire_stacks(min(reac_volume/5, 10))
			M.IgniteMob()
			if(!locate(/obj/effect/hotspot) in M.loc)
				new /obj/effect/hotspot(M.loc)

/datum/reagent/sorium
	name = "Sorium"
	id = "sorium"
	description = "Sends everything flying from the detonation point."
	reagent_state = LIQUID
	color = "#5A64C8"

/datum/reagent/liquid_dark_matter
	name = "Liquid Dark Matter"
	id = "liquid_dark_matter"
	description = "Sucks everything into the detonation point."
	reagent_state = LIQUID
	color = "#210021"

/datum/reagent/blackpowder
	name = "Black Powder"
	id = "blackpowder"
	description = "Explodes. Violently."
	reagent_state = LIQUID
	color = "#000000"
	metabolization_rate = 0.05

/datum/reagent/blackpowder/on_ex_act()
	var/location = get_turf(holder.my_atom)
	var/datum/effect_system/reagents_explosion/e = new()
	e.set_up(1 + round(volume/6, 1), location, 0, 0, message = 0)
	e.start()
	holder.clear_reagents()

/datum/reagent/flash_powder
	name = "Flash Powder"
	id = "flash_powder"
	description = "Makes a very bright flash."
	reagent_state = LIQUID
	color = "#C8C8C8"

/datum/reagent/smoke_powder
	name = "Smoke Powder"
	id = "smoke_powder"
	description = "Makes a large cloud of smoke that can carry reagents."
	reagent_state = LIQUID
	color = "#C8C8C8"

/datum/reagent/sonic_powder
	name = "Sonic Powder"
	id = "sonic_powder"
	description = "Makes a deafening noise."
	reagent_state = LIQUID
	color = "#C8C8C8"

/datum/reagent/phlogiston
	name = "Phlogiston"
	id = "phlogiston"
	description = "Catches you on fire and makes you ignite."
	reagent_state = LIQUID
	color = "#FA00AF"

/datum/reagent/phlogiston/reaction_mob(mob/living/M, method=TOUCH, reac_volume)
	M.IgniteMob()
	..()

/datum/reagent/phlogiston/on_mob_life(mob/living/M)
	M.adjust_fire_stacks(1)
	var/burndmg = max(0.3*M.fire_stacks, 0.3)
	M.adjustFireLoss(burndmg, 0)
	..()
	. = 1

/datum/reagent/napalm
	name = "Napalm"
	id = "napalm"
	description = "Very flammable."
	reagent_state = LIQUID
	color = "#FA00AF"

/datum/reagent/napalm/on_mob_life(mob/living/M)
	M.adjust_fire_stacks(1)
	..()

/datum/reagent/napalm/reaction_mob(mob/living/M, method=TOUCH, reac_volume)
	if(istype(M))
		if(method != INGEST && method != INJECT)
			M.adjust_fire_stacks(min(reac_volume/4, 20))

/datum/reagent/cryostylane
	name = "Cryostylane"
	id = "cryostylane"
	description = "Comes into existence at 20K. As long as there is sufficient oxygen for it to react with, Cryostylane slowly cools all other reagents in the container 0K."
	color = "#0000DC"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM


/datum/reagent/cryostylane/on_mob_life(mob/living/M) //TODO: code freezing into an ice cube
	if(M.reagents.has_reagent("oxygen"))
		M.reagents.remove_reagent("oxygen", 0.5)
		M.bodytemperature -= 15
	..()

/datum/reagent/cryostylane/on_tick()
	if(holder.has_reagent("oxygen"))
		holder.remove_reagent("oxygen", 1)
		holder.chem_temp -= 10
		holder.handle_reactions()
	..()

/datum/reagent/cryostylane/reaction_turf(turf/T, reac_volume)
	if(reac_volume >= 5)
		for(var/mob/living/simple_animal/slime/M in T)
			M.adjustToxLoss(rand(15,30))

/datum/reagent/pyrosium
	name = "Pyrosium"
	id = "pyrosium"
	description = "Comes into existence at 20K. As long as there is sufficient oxygen for it to react with, Pyrosium slowly heats all other reagents in the container."
	color = "#64FAC8"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM

/datum/reagent/pyrosium/on_mob_life(mob/living/M)
	if(M.reagents.has_reagent("oxygen"))
		M.reagents.remove_reagent("oxygen", 0.5)
		M.bodytemperature += 15
	..()

/datum/reagent/pyrosium/on_tick()
	if(holder.has_reagent("oxygen"))
		holder.remove_reagent("oxygen", 1)
		holder.chem_temp += 10
		holder.handle_reactions()
	..()

/datum/reagent/teslium //Teslium. Causes periodic shocks, and makes shocks against the target much more effective.
	name = "Teslium"
	id = "teslium"
	description = "An unstable, electrically-charged metallic slurry. Periodically electrocutes its victim, and makes electrocutions against them more deadly. Excessively heating teslium results in dangerous destabilization. Do not allow to come into contact with water."
	reagent_state = LIQUID
	color = "#20324D" //RGB: 32, 50, 77
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	var/shock_timer = 0

/datum/reagent/teslium/on_mob_life(mob/living/M)
	shock_timer++
	if(shock_timer >= rand(5,30)) //Random shocks are wildly unpredictable
		shock_timer = 0
		M.electrocute_act(rand(5,20), "Teslium in their body", 1, 1) //Override because it's caused from INSIDE of you
		playsound(M, "sparks", 50, 1)
	..()

/datum/reagent/cryogenic_fluid
	name = "Cryogenic Fluid"
	id = "cryogenic_fluid"
	description = "Extremely cold superfluid used to put out fires that will viciously freeze people on contact causing severe pain and burn damage, weak if ingested."
	color = "#b3ffff"
	metabolization_rate = 1.5 * REAGENTS_METABOLISM

/datum/reagent/cryogenic_fluid/on_mob_life(mob/living/M) //not very pleasant but fights fires
	M.adjust_fire_stacks(-2)
	M.adjustStaminaLoss(2)
	M.adjustBrainLoss(1)
	M.bodytemperature = max(M.bodytemperature - 10, TCMB)
	..()

/datum/reagent/cryogenic_fluid/on_tick()
	holder.chem_temp -= 5
	..()

/datum/reagent/cryogenic_fluid/reaction_mob(mob/living/M, method=TOUCH, reac_volume, show_message = 1)
	if(iscarbon(M) && M.stat != DEAD)
		if(method in list(INGEST,INJECT))
			M.bodytemperature = max(M.bodytemperature - 50, TCMB)
			if(show_message)
				M << "<span class='warning'>You feel like you are freezing from the inside!</span>"
		else
			if (reac_volume >= 5)
				if(show_message)
					M << "<span class='danger'>You can feel your body freezing up and your metabolism slow, the pain is excruciating!</span>"
				M.bodytemperature = max(M.bodytemperature - 5*reac_volume, TCMB) //cold
				M.adjust_fire_stacks(-(12*reac_volume))
				M.losebreath += (0.2*reac_volume) //no longer instadeath rape but losebreath instead much more immulshion friendly
				M.drowsyness += 2
				M.confused += 6
				M.brainloss += (0.25*reac_volume) //hypothermia isn't good for the brain

			else
			 M.bodytemperature = max(M.bodytemperature - 15, TCMB)
			 M.adjust_fire_stacks(-(6*reac_volume))
	 ..()

/datum/reagent/cryogenic_fluid/reaction_turf(turf/T, reac_volume)
	if (!istype(T)) return
	var/obj/effect/hotspot/hotspot = (locate(/obj/effect/hotspot) in T) //instantly delts hotspots
	if(isopenturf(T))
		var/turf/open/O = T
		if(hotspot)
			if(O.air)
				var/datum/gas_mixture/G = O.air
				G.temperature = 0
				G.react()
				qdel(hotspot)

		if(reac_volume >= 6)

			T.freon_gas_act() //freon in my pocket

/datum/reagent/arclumin//memechem made in honour of the late arclumin
	name = "Arc-Luminol"
	id = "arclumin"
	description = "You have no idea what the fuck this is but it looks absurdly unstable, it emits a healthy glow so ingestion is probably not a good idea."
	reagent_state = LIQUID
	color = "#ffff66" //RGB: 255, 255, 102
	metabolization_rate = 0.5 * REAGENTS_METABOLISM

/datum/reagent/arclumin/on_mob_life(mob/living/carbon/M)//windup starts off with constant shocking, confusion, dizziness and oscillating luminosity
	M.electrocute_act(1, 1, 1, stun = FALSE) //Override because it's caused from INSIDE of you
	M.SetLuminosity(rand(1,3))
	M.confused += 2
	M.dizziness += 4
	if(current_cycle >= 20) //the fun begins as you become a demigod of chaos
		var/turf/open/T = get_turf(holder.my_atom)
		switch(rand(1,6))

			if(1)
				playsound(T, 'sound/magic/lightningbolt.ogg', 50, 1)
				tesla_zap(T, zap_range = 6, power = 1000, explosive = FALSE)//weak tesla zap
				M.Stun(2)

			if(2)
				playsound(T, 'sound/effects/EMPulse.ogg', 30, 1)
				do_teleport(M, T, 5)

			if(3)
				M.randmuti()
				if(prob(75))
					M.randmutb()
				if(prob(1))
					M.randmutg()
				M.updateappearance()
				M.domutcheck()

			if(4)
				empulse(T, 3, 5, 1)

			if(5)
				playsound(T, 'sound/effects/supermatter.ogg', 20, 1)
				radiation_pulse(T, 4, 8, 25, 0)

			if(6)
				T.atmos_spawn_air("water_vapor= 40 ;TEMP= 298")//janitor friendly
	..()

/datum/reagent/arclumin/on_mob_delete(mob/living/M)// so you don't remain at luminosity 3 forever
	M.SetLuminosity(0)

/datum/reagent/arclumin/reaction_mob(mob/living/M, method=TOUCH, reac_volume, show_message = 1)//weak on touch, short teleport and low damage shock, will however give a permanent weak glow
	if(method == TOUCH)
		M.electrocute_act(5, 1, 1, stun = FALSE)
		M.SetLuminosity(1)
		var/turf/T = get_turf(M)
		do_teleport(M, T, 2)

/datum/reagent/arclumin/reaction_turf(turf/T, reac_volume)//spawns nasty goop on tiles that glows and shocks people who walk over it, more deadly to those without shoes
	if(reac_volume >= 7)
		if(!isspaceturf(T))
			var/obj/effect/decal/cleanable/arc/A = locate() in T.contents
			if(!A)
				A = new/obj/effect/decal/cleanable/arc(T)
			A.reagents.add_reagent("arclumin", reac_volume)
=======
			T.freon_gas_act() //freon in my pocket

