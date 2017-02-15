#define TANK_DISPENSER_CAPACITY 10
#define FREON_TANK_CAPACITY 2

/obj/structure/tank_dispenser
	name = "tank dispenser"
	desc = "A simple yet bulky storage device for gas tanks. Holds up to 10 oxygen tanks and 10 plasma tanks."
	icon = 'icons/obj/objects.dmi'
	icon_state = "dispenser"
	density = 1
	anchored = 1
	obj_integrity = 300
	max_integrity = 300
	var/oxygentanks = TANK_DISPENSER_CAPACITY
	var/plasmatanks = TANK_DISPENSER_CAPACITY
	var/freontanks = FREON_TANK_CAPACITY

/obj/structure/tank_dispenser/oxygen
	plasmatanks = 0
	freontanks = 0

/obj/structure/tank_dispenser/plasma
	oxygentanks = 0
	freontanks = 0

/obj/structure/tank_dispenser/freon
	oxygentanks = 0
	plasmatanks = 0

/obj/structure/tank_dispenser/New()
	for(var/i in 1 to oxygentanks)
		new /obj/item/weapon/tank/internals/oxygen(src)
	for(var/i in 1 to plasmatanks)
		new /obj/item/weapon/tank/internals/plasma(src)
	for(var/i in 1 to freontanks)
		new /obj/item/weapon/tank/internals/freon(src)
	update_icon()
	..()
/obj/structure/tank_dispenser/update_icon()
	cut_overlays()
	switch(oxygentanks)
		if(1 to 3)
			add_overlay("oxygen-[oxygentanks]")
		if(4 to INFINITY)
			add_overlay("oxygen-4")
	switch(plasmatanks)
		if(1 to 4)
			add_overlay("plasma-[plasmatanks]")
		if(5 to INFINITY)
			add_overlay("plasma-5")
	switch(freontanks)
		if(1)
			add_overlay("freon-1")
		if(2 to INFINITY)
			add_overlay("freon-2")


/obj/structure/tank_dispenser/attackby(obj/item/I, mob/user, params)
	var/full
	if(istype(I, /obj/item/weapon/tank/internals/plasma))
		if(plasmatanks < TANK_DISPENSER_CAPACITY)
			plasmatanks++
		else
			full = TRUE
	else if(istype(I, /obj/item/weapon/tank/internals/oxygen))
		if(oxygentanks < TANK_DISPENSER_CAPACITY)
			oxygentanks++
		else
			full = TRUE
	else if(istype(I, /obj/item/weapon/tank/internals/freon))
		if(freontanks < FREON_TANK_CAPACITY)
			freontanks++
		else
			full = TRUE
	else if(istype(I, /obj/item/weapon/wrench))
		default_unfasten_wrench(user, I, time = 20)
		return
	else if(user.a_intent != INTENT_HARM)
		to_chat(user, "<span class='notice'>[I] does not fit into [src].</span>")
		return
	else
		return ..()
	if(full)
		to_chat(user, "<span class='notice'>[src] can't hold any more of [I].</span>")
		return

	if(!user.drop_item())
		return
	I.loc = src
	to_chat(user, "<span class='notice'>You put [I] in [src].</span>")
	update_icon()

/obj/structure/tank_dispenser/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = 0, \
										datum/tgui/master_ui = null, datum/ui_state/state = physical_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "tank_dispenser", name, 275, 150, master_ui, state)
		ui.open()

/obj/structure/tank_dispenser/ui_data(mob/user)
	var/list/data = list()
	data["oxygen"] = oxygentanks
	data["plasma"] = plasmatanks
	data["freon"] = freontanks

	return data

/obj/structure/tank_dispenser/ui_act(action, params)
	if(..())
		return
	switch(action)
		if("plasma")
			var/obj/item/weapon/tank/internals/plasma/tank = locate() in src
			if(tank && Adjacent(usr))
				usr.put_in_hands(tank)
				plasmatanks--
			. = TRUE
		if("oxygen")
			var/obj/item/weapon/tank/internals/oxygen/tank = locate() in src
			if(tank && Adjacent(usr))
				usr.put_in_hands(tank)
				oxygentanks--
			. = TRUE
		if("freon")
			var/obj/item/weapon/tank/internals/freon/tank = locate() in src
			if(tank && Adjacent(usr))
				usr.put_in_hands(tank)
				freontanks--
			. = TRUE
	update_icon()


/obj/structure/tank_dispenser/deconstruct(disassembled = TRUE)
	if(!(flags & NODECONSTRUCT))
		for(var/X in src)
			var/obj/item/I = X
			I.forceMove(loc)
		new /obj/item/stack/sheet/metal (loc, 2)
	qdel(src)

#undef TANK_DISPENSER_CAPACITY
#undef FREON_TANK_CAPACITY
