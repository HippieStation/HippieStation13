#define POOL_WIRE_DRAIN "drain"

/datum/wires/poolcontroller
	holder_type = /obj/machinery/poolcontroller

/datum/wires/poolcontroller/New(atom/holder)
	wires = list(
		POOL_WIRE_DRAIN, WIRE_HACK, WIRE_SHOCK
	)
	add_duds(2)
	..()

/datum/wires/poolcontroller/interactable(mob/user)
	var/obj/machinery/poolcontroller/P = holder
	if(P.panel_open)
		return TRUE

/datum/wires/poolcontroller/get_status()
	var/obj/machinery/poolcontroller/P = holder
	var/list/status = list()
	status += "The red light is [P.emagged ? "on" : "off"]."
	status += "The yellow light is [P.shocked ? "on" : "off"]."
	return status

/datum/wires/poolcontroller/on_pulse(wire)
	var/obj/machinery/poolcontroller/P = holder
	switch(wire)
		if(POOL_WIRE_DRAIN)
			P.drainable = 0
		if(WIRE_HACK)
			if(P.emagged)
				P.emagged = 0
			if(!P.emagged)
				P.emagged = 1
		if(WIRE_SHOCK)
			P.shocked = !P.shocked
			addtimer(CALLBACK(P, /obj/machinery/autolathe.proc/reset, wire), 60)

/datum/wires/poolcontroller/on_cut(wire, mend)
	var/obj/machinery/poolcontroller/P = holder
	switch(wire)
		if(POOL_WIRE_DRAIN)
			if(mend)
				P.drainable = 0
			else
				P.drainable = 1
		if(WIRE_HACK)
			if(mend)
				P.emagged = 0
		if(WIRE_SHOCK)
			P.shock(usr, 50)