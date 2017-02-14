//Pool noodles

/obj/item/toy/poolnoodle
	icon = 'icons/obj/toy.dmi'
	icon_state = "noodle"
	name = "Pool noodle"
	desc = "A strange, bulky, bendable toy that can annoy people."
	force = 0
	color = "#000000"
	w_class = 2.0
	throwforce = 1
	throw_speed = 10 //weeee
	hitsound = 'sound/weapons/tap.ogg'
	attack_verb = list("flogged", "poked", "jabbed", "slapped", "annoyed")

/obj/item/toy/poolnoodle/attack(target as mob, mob/living/user as mob)
	..()
	spawn(0)
		for(var/i in list(1,2,4,8,4,2,1,2,4,8,4,2))
			user.dir = i
			sleep(1)

/obj/item/toy/poolnoodle/red
	New()
		color = "#FF0000"
		icon_state = "noodle"
		item_state = "noodlered"

/obj/item/toy/poolnoodle/blue
	New()
		color = "#0000FF"
		icon_state = "noodle"
		item_state = "noodleblue"
	item_state = "balloon-empty"

/obj/item/toy/poolnoodle/yellow
	New()
		color = "#FFFF00"
		icon_state = "noodle"
		item_state = "noodleyellow"