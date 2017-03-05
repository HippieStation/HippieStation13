/obj/item/clothing/shoes/bowling
	icon = 'icons/hippie/obj/sports.dmi'
	name = "bowling shoes"
	icon_state = "bowlingshoes"
	item_color = "bowling"
	desc = "Made for use in only the finest bowling alleys."
	permeability_coefficient = 0.01
	flags = NOSLIP
	resistance_flags = FIRE_PROOF |  ACID_PROOF
	permeability_coefficient = 0.01
	armor = list(melee = 40, bullet = 20, laser = 10, energy = 5, bomb = 5, bio = 0, rad = 0, fire = 90, acid = 50)

/obj/item/clothing/under/bowling
	name = "bowling jersey"
	desc = "The latest in king pin fashion."
	icon = 'icons/hippie/obj/sports.dmi'
	icon_state = "bowlinguniform"
	item_color = "bowling"
	resistance_flags = FIRE_PROOF |  ACID_PROOF
	armor = list(melee = 40, bullet = 20, laser = 10, energy = 5, bomb = 5, bio = 0, rad = 0, fire = 90, acid = 50)
	can_adjust = 0

/obj/item/weapon/twohanded/bowling
	name = "bowling ball"
	icon = 'icons/hippie/obj/sports.dmi'
	icon_state = "bowling_ball"
	desc = "A heavy, round device used to knock pins (or people) down."
	force_unwielded = 4
	force_wielded = 10
	throwforce = 0
	throw_range = 1
	throw_speed = 1

/obj/item/weapon/twohanded/bowling/New()
	color = pick("white","green","yellow","purple")
	..()

/obj/item/weapon/twohanded/bowling/attack_self(mob/living/carbon/human/user)
	if(wielded) //Trying to unwield it
		unwield(user)
		unlimitedthrow = 0
		throw_speed = 1
		throwforce = 0
	else //Trying to wield it
		if(user.w_uniform == /obj/item/clothing/under/bowling)
			wield(user)
			unlimitedthrow = 1
			throw_speed = 3
			throwforce = 8
		else
			user << "<span class='warning'>You don't have the skills to wield such an amazing weapon!</span>"
			return