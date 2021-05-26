/turf/unsimulated/floor
	name = "floor"
	icon = 'icons/turf/total_floors.dmi'
	icon_state = "new_steel"

/turf/unsimulated/floor/attackby(var/obj/item/I, mob/user)
	if(can_dig && is_type_in_typecache(I, digging_tools))
		do_dig(user, I)
		return
	if(can_plate && (istype(I, /obj/item/stack/rods) || istype(I, /obj/item/stack/tile)))
		do_flooring(user, I)
		return
	if(istype(I,/obj/item/storage/bag/ore))
		var/obj/item/storage/bag/ore/S = I
		if(S.collection_mode)
			for(var/obj/item/ore/O in contents)
				O.attackby(I, user)
				return
	if(istype(I,/obj/item/storage/bag/fossils))
		var/obj/item/storage/bag/fossils/S = I
		if(S.collection_mode)
			for(var/obj/item/fossil/F in contents)
				F.attackby(I, user)
				return
	return ..()

/turf/unsimulated/floor/plating
	name = "plating"
	icon = 'icons/turf/floors.dmi'
	icon_state = "plating"

/turf/unsimulated/floor/xmas
	name = "snow"
	icon = 'icons/turf/snow.dmi'
	icon_state = "snow"
	footstep_sound = /decl/sound_category/snow_footstep

/turf/unsimulated/floor/jungle_grass
	name = "grass"
	icon = 'icons/turf/total_floors.dmi'
	icon_state = "grass_alt"
	footstep_sound = /decl/sound_category/grass_footstep
	baseturf = /turf/unsimulated/floor/dirt
	has_resources = TRUE
	can_dig = TRUE

/turf/unsimulated/floor/jungle_grass/ex_act(severity)
	switch(severity)
		if(1.0 to 2.0)
			ChangeTurf(baseturf)
		if(3.0)
			if(prob(50))
				ChangeTurf(baseturf)
	return

/turf/unsimulated/floor/jungle_grass/marsh
	name = "thick marsh"
	icon = 'icons/turf/floors.dmi'
	icon_state = "marsh"
	movement_cost = 1

/turf/unsimulated/floor/dirt
	name = "compacted dirt"
	icon = 'icons/turf/floors.dmi'
	icon_state = "redplanet"
	footstep_sound = /decl/sound_category/asteroid_footstep
	has_resources = TRUE
	can_dig = TRUE

/turf/unsimulated/floor/dirt/Initialize()
	. = ..()
	if(prob(85))
		add_overlay("redplanet[rand(1,13)]")

/turf/unsimulated/floor/dirt/ex_act(severity)
	switch(severity)
		if(1.0 to 2.0)
			if(prob(75))
				dug += rand(3, 5)
				gets_dug()
		if(3.0)
			if(prob(25))
				dug++
				gets_dug()
	return

/turf/unsimulated/floor/shimmer
	name = "shimmering red substance"
	desc = "An unnerving, pulsating substance. It seems to advance ever so slowly toward you..."
	icon = 'icons/turf/floors.dmi'
	icon_state = "shimmer"
	footstep_sound = /decl/sound_category/asteroid_footstep

/turf/unsimulated/mask
	name = "mask"
	icon = 'icons/turf/walls.dmi'
	icon_state = "rockvault"

/turf/unsimulated/mask/ChangeTurf(var/turf/N, var/tell_universe=1, var/force_lighting_update = 0)
	if (!N)
		return

	new N(src)

/turf/unsimulated/chasm_mask
	name = "chasm mask"
	icon = 'icons/turf/walls.dmi'
	icon_state = "alienvault"
	oxygen = 0
	nitrogen = 0
	temperature = TCMB


// It's a placeholder turf, don't do anything special.
// These shouldn't exist by the time SSatoms runs.
/turf/unsimulated/mask/New()
	return

/turf/unsimulated/mask/Initialize()
	initialized = TRUE
	return

/turf/unsimulated/chasm_mask/New()
	return

/turf/unsimulated/floor/shuttle_ceiling
	icon_state = "reinforced"