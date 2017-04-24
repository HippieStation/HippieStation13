/datum/species/wire
	name = "Noose Man"
	id = "wire"
	species_traits = list(NOBREATH,RESISTCOLD,RESISTPRESSURE,NOBLOOD,VIRUSIMMUNE,NOHUNGER,EASYDISMEMBER,MUTCOLORS)
	damage_overlay_type = "synth"
	mutant_organs = list(/obj/item/organ/tongue/robot)
	meat = /obj/item/weapon/restraints/handcuffs/cable
	skinned_type = /obj/item/stack/cable_coil/random
	teeth_type = /obj/item/stack/cable_coil/cut
	burnmod = 3.0 //They are super conductive
	sexes = 0
	blacklisted = 0
	mutant_bodyparts = list("frills")

/datum/species/wire/on_species_gain(mob/living/carbon/human/C) //No butt for you!
	. = ..()
	C.dna.features["frills"] = "Googlyeyes"
	for(var/obj/item/organ/internal/butt/butt in C.internal_organs)
		qdel(butt)

/datum/species/wire/on_species_loss(mob/living/carbon/human/C)
	. = ..()
	C.dna.features["frills"] = null