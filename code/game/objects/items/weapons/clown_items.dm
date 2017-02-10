/* Clown Items
 * Contains:
 *		Soap
 *		Bike Horns
 *		Air Horns
 */

/*
 * Soap
 */

/obj/item/weapon/soap
	name = "soap"
	desc = "A cheap bar of soap. Doesn't smell."
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	icon_state = "soap"
	w_class = WEIGHT_CLASS_TINY
	flags = NOBLUDGEON
	throwforce = 0
	throw_speed = 3
	throw_range = 7
	var/cleanspeed = 50 //slower than mop

/obj/item/weapon/soap/nanotrasen
	desc = "A Nanotrasen brand bar of soap. Smells of plasma."
	icon_state = "soapnt"

/obj/item/weapon/soap/homemade
	desc = "A homemade bar of soap. Smells of... well...."
	icon_state = "soapgibs"
	cleanspeed = 45 // a little faster to reward chemists for going to the effort

/obj/item/weapon/soap/deluxe
	desc = "A deluxe Waffle Co. brand bar of soap. Smells of high-class luxury."
	icon_state = "soapdeluxe"
	cleanspeed = 40 //same speed as mop because deluxe -- captain gets one of these

/obj/item/weapon/soap/syndie
	desc = "An untrustworthy bar of soap made of strong chemical agents that dissolve blood faster."
	icon_state = "soapsyndie"
	cleanspeed = 10 //much faster than mop so it is useful for traitors who want to clean crime scenes

/obj/item/weapon/soap/suicide_act(mob/user)
	user.say(";FFFFFFFFFFFFFFFFUUUUUUUDGE!!")
	user.visible_message("<span class='suicide'>[user] lifts [src] to their mouth and gnaws on it furiously, producing a thick froth! [user.p_they(TRUE)]'ll never get that BB gun now!")
	new /obj/effect/particle_effect/foam(loc)
	return (TOXLOSS)

/obj/item/weapon/soap/Crossed(AM as mob|obj)
	if (istype(AM, /mob/living/carbon))
		var/mob/living/carbon/M = AM
		M.slip(4, 2, src)

/obj/item/weapon/soap/afterattack(atom/target, mob/user, proximity)
	if(!proximity || !check_allowed_items(target))
		return
	//I couldn't feasibly  fix the overlay bugs caused by cleaning items we are wearing.
	//So this is a workaround. This also makes more sense from an IC standpoint. ~Carn
	if(user.client && (target in user.client.screen))
		user << "<span class='warning'>You need to take that [target.name] off before cleaning it!</span>"
	else if(istype(target,/obj/effect/decal/cleanable))
		user.visible_message("[user] begins to scrub \the [target.name] out with [src].", "<span class='warning'>You begin to scrub \the [target.name] out with [src]...</span>")
		if(do_after(user, src.cleanspeed, target = target))
			user << "<span class='notice'>You scrub \the [target.name] out.</span>"
			qdel(target)
	else if(ishuman(target) && user.zone_selected == "mouth")
		var/mob/living/carbon/human/H = user
		user.visible_message("<span class='warning'>\the [user] washes \the [target]'s mouth out with [src.name]!</span>", "<span class='notice'>You wash \the [target]'s mouth out with [src.name]!</span>") //washes mouth out with soap sounds better than 'the soap' here
		H.lip_style = null //removes lipstick
		H.update_body()
		return
	else if(istype(target, /obj/structure/window))
		user.visible_message("[user] begins to clean \the [target.name] with [src]...", "<span class='notice'>You begin to clean \the [target.name] with [src]...</span>")
		if(do_after(user, src.cleanspeed, target = target))
			user << "<span class='notice'>You clean \the [target.name].</span>"
			target.remove_atom_colour(WASHABLE_COLOUR_PRIORITY)
			target.SetOpacity(initial(target.opacity))
	else
		user.visible_message("[user] begins to clean \the [target.name] with [src]...", "<span class='notice'>You begin to clean \the [target.name] with [src]...</span>")
		if(do_after(user, src.cleanspeed, target = target))
			user << "<span class='notice'>You clean \the [target.name].</span>"
			var/obj/effect/decal/cleanable/C = locate() in target
			qdel(C)
			target.remove_atom_colour(WASHABLE_COLOUR_PRIORITY)
			target.clean_blood()
			target.wash_cream()
	return


/*
 * Bike Horns
 */


/obj/item/weapon/bikehorn
	name = "bike horn"
	desc = "A horn off of a bicycle."
	icon = 'icons/obj/items.dmi'
	icon_state = "bike_horn"
	item_state = "bike_horn"
	throwforce = 0
	hitsound = null //To prevent tap.ogg playing, as the item lacks of force
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 3
	throw_range = 7
	attack_verb = list("HONKED")
	var/spam_flag = FALSE
	var/honksound = 'sound/items/bikehorn.ogg'
	var/cooldowntime = 20

/obj/item/weapon/bikehorn/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] solemnly points \the [src] at [user.p_their()] temple! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	playsound(src.loc, honksound, 50, 1)
	return (BRUTELOSS)

/obj/item/weapon/bikehorn/attack(mob/living/carbon/M, mob/living/carbon/user)
	if(!spam_flag)
		spam_flag = TRUE
		playsound(loc, honksound, 50, 1, -1) //plays instead of tap.ogg!
		spawn(cooldowntime)
			spam_flag = FALSE
	return ..()

/obj/item/weapon/bikehorn/attack_self(mob/user)
	if(!spam_flag)
		spam_flag = TRUE
		playsound(src.loc, honksound, 50, 1)
		src.add_fingerprint(user)
		spawn(cooldowntime)
			spam_flag = FALSE
	return

/obj/item/weapon/bikehorn/Crossed(mob/living/L)
	if(isliving(L))
		playsound(loc, honksound, 50, 1, -1)
	..()

/obj/item/weapon/bikehorn/airhorn
	name = "air horn"
	desc = "Damn son, where'd you find this?"
	icon_state = "air_horn"
	honksound = 'sound/items/AirHorn2.ogg'
	cooldowntime = 50
	origin_tech = "materials=4;engineering=4"

/obj/item/weapon/bikehorn/golden
	name = "golden bike horn"
	desc = "Golden? Clearly, it's made with bananium! Honk!"
	icon_state = "gold_horn"
	item_state = "gold_horn"

/obj/item/weapon/bikehorn/golden/attack()
	flip_mobs()
	return ..()

/obj/item/weapon/bikehorn/golden/attack_self(mob/user)
	flip_mobs()
	..()

/obj/item/weapon/bikehorn/golden/proc/flip_mobs(mob/living/carbon/M, mob/user)
	if (!spam_flag)
		var/turf/T = get_turf(src)
		for(M in ohearers(7, T))
			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				if((istype(H.ears, /obj/item/clothing/ears/earmuffs)) || H.ear_deaf)
					continue
			M.emote("flip")

/obj/item/weapon/bikehorn/saxophone
	name = "saxophone"
	desc = "NEVER GONNA DANCE AGAIN, GUILTY FEET HAVE GOT NO RHYTHM!"
	icon = 'icons/obj/musician.dmi'
	icon_state = "sax"
	item_state = "sax"
	force = 10
	cooldowntime = 150
	attack_verb = list("played blues on", "serenaded", "battered", "bashed")
	honksound = list('sound/items/sax.ogg', 'sound/items/sax2.ogg','sound/items/sax3.ogg','sound/items/sax4.ogg','sound/items/sax5.ogg','sound/items/sax6.ogg')


/obj/item/weapon/bikehorn/saxophone/attack_self(mob/user)
	if(!spam_flag)
		spam_flag = TRUE
		playsound(src.loc, pick(honksound), 50, 0)
		user.visible_message("<B>[user]</B> lays down a [pick("sexy", "sensuous", "libidinous","spicy","flirtatious","salacious","sizzling","carnal","hedonistic")] riff on \his saxophone!")
		src.add_fingerprint(user)
		spawn(cooldowntime)
			spam_flag = FALSE
	return


/obj/item/weapon/bikehorn/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is never gonna dance again! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	playsound(src.loc, 'sound/items/sax.ogg', 50, 0)
	return (BRUTELOSS)

/obj/item/weapon/bikehorn/saxophone/Crossed(mob/living/L)
	return

/obj/item/weapon/reagent_containers/food/drinks/soda_cans/canned_laughter
	name = "Canned Laughter"
	desc = "Just looking at this makes you want to giggle."
	icon_state = "laughter"
	list_reagents = list("laughter" = 50)
