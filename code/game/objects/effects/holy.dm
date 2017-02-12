//Effects used for anything holy and divine currently used for smite and spawming a admin dummy... maybe for holy explosion one day
/obj/effect/holy
	name = "holy"
	icon = null
	icon_state = null
	pixel_y = 0
	pixel_x = 0
	mouse_opacity = 0

	proc/start(atom/location)
		loc = get_turf(location)
		spawn(20)
			qdel(src)

/obj/effect/holy/lightning
	name = "divine retribution"
	icon = 'icons/effects/224x224.dmi'
	pixel_y = -32
	pixel_x = -96
	layer = 16

/obj/effect/holy/lightning/start(atom/location)
	..()
	flick("lightning",src)
	playsound(src,'sound/effects/thunder.ogg',50,1)

/obj/effect/holy/holylight
	name = "holy light"
	icon = 'icons/effects/96x96.dmi'
	pixel_x = -32
	layer = MOB_LAYER+1

/obj/effect/holy/holylight/start(atom/location)
	..()
	flick("beamin",src)
	playsound(src,'sound/effects/pray.ogg',50,1)
