/obj/effect/lightning
	name = "divine retribution"
	icon = 'icons/effects/224x224.dmi'
	icon_state = null
	pixel_y = -32
	pixel_x = -100
	layer = 16

	proc/start(atom/location)
		loc = get_turf(location)
		flick("lightning",src)
		playsound(src,'sound/effects/thunder.ogg',50,1)
		spawn(20)
			qdel(src)

/client/proc/cmd_smite(mob/living/M in mob_list)
	set category = "Fun"
	set name = "Smite"
	if(!holder)
		usr << "no"
		return

	var/options = list("Brute","Burn","Toxic","Oxygen","Clone","Brain","Stamina","Heal","Gib","Cancel")
	var/requiresdam = options - list("Heal","Gib","Cancel")

	var/confirm = null
	var/damtype_word = null
	var/dam = 0

	confirm = input(src, "Really smite [M.name]([M.ckey])?", "Divine Retribution") in list("Yeah", "Nah")
	if(confirm == "Nah")
		return
	// Changed so that the damtype isn't used where it shouldn't be used. damtype_word is the word... damtype is an int.
	damtype_word = input(src, "What kind of damage?", "PUT YOUR FAITH IN THE LIGHT") in options
	if(damtype_word in requiresdam)
		dam = input(src, "How much damage?", "THE LIGHT SHALL BURN YOU") as num
		if(dam == 0)
			damtype_word = "Cancel"
	if(damtype_word == "Cancel")
		return
	var/obj/effect/lightning/L = new /obj/effect/lightning()
	L.start(M)
	spawn(10)
		switch(damtype_word)
			if("Brute")
				M.adjustBruteLoss(dam)
			if("Burn")
				M.adjustFireLoss(dam)
			if("Toxic")
				M.adjustToxLoss(dam)
			if("Oxygen")
				M.adjustOxyLoss(dam)
			if("Clone")
				M.adjustCloneLoss(dam)
			if("Brain")
				M.adjustBrainLoss(dam)
			if("Stamina")
				M.adjustStaminaLoss(dam)
			if("Heal")
				M.revive(full_heal = 1, admin_revive = 1)
			if("Gib")
				M.gib()

	if(damtype_word in requiresdam)
		log_admin("[src]([src.ckey]) smote [M] ([M.ckey]) in [damtype_word] for [dam] damage.")
		message_admins("[src]([src.ckey]) smote [M] ([M.ckey]) in [damtype_word] for [dam] damage.")
	else
		log_admin("[src]([src.ckey]) smote [M] ([M.ckey]) with [damtype_word].")
		message_admins("[src]([src.ckey]) smote [M] ([M.ckey]) with [damtype_word].")