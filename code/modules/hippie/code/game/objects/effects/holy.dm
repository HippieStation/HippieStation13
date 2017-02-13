//Effects used for anything holy and divine currently used for smite and spawming a admin dummy... maybe for holy explosion one day
/obj/effect/holy
	name = "holy"
	icon = null
	icon_state = null
	pixel_y = 0
	pixel_x = 0
	layer = MOB_LAYER+1
	mouse_opacity = 0
	use_fade = 0 //This should really be FALSE/TRUE I think

	proc/start(atom/location)
		loc = get_turf(location)
		addtimer(CALLBACK(src, .proc/destroy_effect), 20)

/obj/effect/holy/lightning
	name = "divine retribution"
	icon = 'icons/hippie/effects/holy.dmi'
	pixel_y = -32
	pixel_x = -96

/obj/effect/holy/lightning/start(atom/location)
	..()
	flick("lightning",src)
	playsound(src,'sound/effects/thunder.ogg',50,1)

/obj/effect/holy/holylight
	name = "holy light"
	icon = 'icons/hippie/effects/holy.dmi'
	pixel_x = -32

/obj/effect/holy/holylight/start(atom/location)
	..()
	flick("beamin",src)
	playsound(src,'sound/effects/pray.ogg',50,1)
