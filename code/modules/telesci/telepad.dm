///SCI TELEPAD///
/obj/machinery/telepad
	name = "telepad"
	desc = "A bluespace telepad used for teleporting objects to and from a location."
	icon = 'icons/obj/telescience.dmi'
	icon_state = "pad-idle"
	anchored = TRUE
	use_power = TRUE
	idle_power_usage = 200
	active_power_usage = 5000
	var/efficiency

/obj/machinery/telepad/New()
	..()
	var/obj/item/weapon/circuitboard/machine/B = new /obj/item/weapon/circuitboard/machine/telesci_pad(null)
	B.apply_default_parts(src)

/obj/item/weapon/circuitboard/machine/telesci_pad
	name = "Telepad (Machine Board)"
	build_path = /obj/machinery/telepad
	origin_tech = "programming=4;engineering=3;plasmatech=4;bluespace=4"
	req_components = list(
							/obj/item/weapon/ore/bluespace_crystal = 2,
							/obj/item/weapon/stock_parts/capacitor = 1,
							/obj/item/stack/cable_coil = 1,
							/obj/item/weapon/stock_parts/console_screen = 1)
	def_components = list(/obj/item/weapon/ore/bluespace_crystal = /obj/item/weapon/ore/bluespace_crystal/artificial)

/obj/machinery/telepad/RefreshParts()
	var/E
	for(var/obj/item/weapon/stock_parts/capacitor/C in component_parts)
		E += C.rating
	efficiency = E

/obj/machinery/telepad/attackby(obj/item/I, mob/user, params)
	if(default_deconstruction_screwdriver(user, "pad-idle-o", "pad-idle", I))
		return

	if(panel_open)
		if(istype(I, /obj/item/device/multitool))
			var/obj/item/device/multitool/M = I
			M.buffer = src
			user << "<span class='caution'>You save the data in the [I.name]'s buffer.</span>"
			return 1

	if(exchange_parts(user, I))
		return

	if(default_deconstruction_crowbar(I))
		return

	return ..()

//CARGO TELEPAD//
/obj/machinery/telepad_cargo
	name = "cargo telepad"
	desc = "A telepad used by the cargo transporter."
	icon = 'icons/obj/telescience.dmi'
	icon_state = "pad-idle-o"
	anchored = TRUE
	use_power = TRUE
	idle_power_usage = 20
	active_power_usage = 500

	var/stage = 0
	var/active = FALSE

/obj/machinery/telepad_cargo/Initialize()
	..()
	if (name == initial(src.name))
		name += " ([rand(100,999)])"
	if (active && cargopads[src] == null)
		icon_state = "pad-idle"
		LAZYADD(cargopads, src)

/obj/machinery/telepad_cargo/Destroy()
	if (cargopads[src] != null)
		LAZYREMOVE(cargopads, src)
	..()

/obj/machinery/telepad_cargo/attackby(obj/item/weapon/W, mob/user, params)
	if(istype(W, /obj/item/weapon/wrench))
		anchored = FALSE
		playsound(src, 'sound/items/Ratchet.ogg', 50, 1)
		if(anchored)
			anchored = FALSE
			user << "<span class='caution'>\The [src] can now be moved.</span>"
		else if(!anchored)
			anchored = TRUE
			user << "<span class='caution'>\The [src] is now secured.</span>"
	else if(istype(W, /obj/item/weapon/screwdriver))
		if(stage == 0)
			playsound(src, W.usesound, 50, 1)
			user << "<span class='caution'>You unscrew the telepad's tracking beacon.</span>"
			stage = 1
		else if(stage == 1)
			playsound(src, W.usesound, 50, 1)
			user << "<span class='caution'>You screw in the telepad's tracking beacon.</span>"
			stage = 0
	else if(istype(W, /obj/item/weapon/weldingtool) && stage == 1)
		var/obj/item/weapon/weldingtool/WT = W
		if(WT.remove_fuel(0,user))
			playsound(src.loc, 'sound/items/Welder2.ogg', 100, 1)
			user << "<span class='notice'>You start disassembling [src]...</span>"
			if(do_after_mob(user,20*WT.toolspeed, target = src))
				if(!WT.isOn())
					return
				user << "<span class='notice'>You disassemble [src].</span>"
				new /obj/item/stack/sheet/metal(get_turf(src))
				new /obj/item/stack/sheet/glass(get_turf(src))
				qdel(src)
	else
		return ..()

/obj/machinery/telepad_cargo/attack_hand(mob/living/user)
	if(do_after(user, 5, target = src))
		message_admins("[key_name_admin(user)] has toggled the power to [name]")
		if (active == TRUE)
			user << "You switch the receiver off."
			icon_state = "pad-idle-o"
			active = FALSE
			if (cargopads[src] != null)
				LAZYREMOVE(cargopads, src)
		else
			user << "You switch the receiver on."
			icon_state = "pad-idle"
			active = TRUE
			if (cargopads[src] == null)
				LAZYADD(cargopads, src)

///TELEPAD CALLER///
/obj/item/device/telepad_beacon
	name = "telepad beacon"
	desc = "Use to warp in a cargo telepad."
	icon = 'icons/obj/radio.dmi'
	icon_state = "beacon"
	item_state = "beacon"
	origin_tech = "bluespace=3"

/obj/item/device/telepad_beacon/attack_self(mob/user)
	if(user)
		user << "<span class='caution'>Locked In</span>"
		new /obj/machinery/telepad_cargo(user.loc)
		playsound(src, 'sound/effects/pop.ogg', 100, 1, 1)
		qdel(src)
	return

///HANDHELD TELEPAD USER///
/obj/item/weapon/rcs
	name = "cargo transporter"
	desc = "A device for teleporting crated goods."
	icon = 'icons/obj/telescience.dmi'
	icon_state = "rcs"
	w_class = WEIGHT_CLASS_SMALL
	materials = list(MAT_METAL=10000)
	flags = CONDUCT
	force = 10
	throwforce = 0
	throw_speed = 3
	throw_range = 5
	origin_tech = "magnets=3;bluespace=3"

	var/charges = 10
	var/maximum_charges = 10.0
	var/obj/machinery/telepad_cargo/target_pad = null
	var/target_turf = null

/obj/item/weapon/rcs/examine(mob/user)
	..()
	user << "There are [charges]/[maximum_charges] charge\s left."

/obj/item/weapon/rcs/attack_self(mob/user)
	if (charges < 1)
		user << "<span style=\"color:red\">The transporter is out of charge.</span>"
		return
	if (!cargopads.len) usr << "<span style=\"color:red\">No receivers available.</span>"
	else
	//here i set up an empty var that can take any object, and tell it to look for absolutely anything in the list
		var/selection = input("Select Cargo Pad Location:", "Cargo Pads", null, null) as null|anything in cargopads
		if(!istype(selection, /obj/machinery/telepad_cargo))
			return
		
		var/obj/machinery/telepad_cargo/P = selection
		
		if(!selection)
			return
		var/turf/T = get_turf(selection)
		//get the turf of the pad itself
		if (!T)
			usr << "<span style=\"color:red\">Target not set!</span>"
			return
		usr << "Target set to [T.loc]."
		//blammo! works!
		target_pad = P
		target_turf = T

/obj/item/weapon/rcs/proc/cargoteleport(var/obj/T, var/mob/user)
	if (!target_turf)
		user << "<span style=\"color:red\">You need to set a target first!</span>"
		return
	if (cargopads[target_pad] != null)
		user << "<span style=\"color:red\">Unable to connect to remote pad!</span>"
	if (charges < 1)
		user << " <span style=\"color:red\">The transporter is out of charge.</span>"
		return

	message_admins("[key_name_admin(user)] is using the Cargo Teleporter - [T]")

	user << "<span style=\"color:blue\">Teleporting [T]...</span>"
	playsound(user.loc, "sound/machines/click.ogg", 50, 1)

	target_pad.icon_state = "pad-beam"

	if(do_after(user, 50, target=T, progress = TRUE))
		T.loc = target_turf

		var/datum/effect_system/spark_spread/S1 = new /datum/effect_system/spark_spread
		S1.set_up(5, 1, src)
		S1.start()

		var/datum/effect_system/spark_spread/S2 = new /datum/effect_system/spark_spread
		S2.set_up(5, 1, target_turf)
		S2.start()
		
		target_pad.icon_state = "pad-idle"
		
		charges -= 1
		if (charges < 0)
			charges = 0
		if (charges == 0)
			user << "<span style=\"color:red\">Transfer successful. The transporter is now out of charge.</span>"
		else
			user << "<span style=\"color:blue\">Transfer successful. [charges] charges remain.</span>"
	else
		target_pad.icon_state = "pad-idle"
	return