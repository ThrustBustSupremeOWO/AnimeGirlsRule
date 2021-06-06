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
//Stophs
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

/turf/unsimulated/floor/jungle_grass/road
	name = "overgrown asphalt"
	desc = "Ugly overgrown asphalt, mother nature seems to want their land back."
	icon = 'icons/turf/moons.dmi'
	icon_state = "groad1"
	footstep_sound = /decl/sound_category/tiles_footstep
	baseturf = /turf/unsimulated/floor/dirt
	has_resources = FALSE
	can_dig = FALSE

/turf/unsimulated/floor/jungle_grass/road/Initialize(mapload)
	if(prob(20))
		var/variant = rand(1,4)
		icon_state = "groad[variant]"
	. = ..()

/turf/unsimulated/floor/shimmer
	name = "shimmering red substance"
	desc = "An unnerving, pulsating substance. It seems to advance ever so slowly toward you..."
	icon = 'icons/turf/floors.dmi'
	icon_state = "shimmer"
	footstep_sound = /decl/sound_category/asteroid_footstep

//Apostali
/turf/unsimulated/floor/marble/apostali
	name = "carved alien marble"
	desc = "A glamorous marble floor, engraved with indescribable inscriptions. It seems to be perpetually slippery."
	icon = 'icons/turf/moons.dmi'
	icon_state = "marble"

/turf/unsimulated/floor/jungle_grass/apostali
	name = "rich violet growth"
	desc = "A beautiful pink-ish violet overgrowth, looks plush and easy to rest on."
	icon = 'icons/turf/moons.dmi'
	icon_state = "pink"
	footstep_sound = /decl/sound_category/grass_footstep
	baseturf = /turf/unsimulated/floor/dirt/apostali
	has_resources = TRUE
	can_dig = TRUE

/turf/unsimulated/floor/jungle_grass/apostali/saturated
	name = "rich purple growth"
	desc = "A beautiful, dark purple overgrowth, looks plush and easy to rest on."
	icon = 'icons/turf/moons.dmi'
	icon_state = "purple1"
	footstep_sound = /decl/sound_category/grass_footstep
	baseturf = /turf/unsimulated/floor/dirt/apostali
	has_resources = TRUE
	can_dig = TRUE

/turf/unsimulated/floor/jungle_grass/apostali/saturated/Initialize(mapload)
	if(prob(20))
		var/variant = rand(1,3)
		icon_state = "purple[variant]"
	. = ..()

/turf/unsimulated/floor/dirt/apostali
	name = "decrepit waste"
	desc = "A gloomy and dark tinted ground riddled with barbs and hardened roots."
	icon = 'icons/turf/moons.dmi'
	icon_state = "decrepit"
	footstep_sound = /decl/sound_category/asteroid_footstep
	has_resources = TRUE
	can_dig = TRUE

//Metrothol
/turf/unsimulated/floor/city
	name = "dull pavement"
	desc = "Paved concrete, weathered and rough."
	icon = 'icons/turf/moons.dmi'
	icon_state = "concrete1"
	footstep_sound = /decl/sound_category/tiles_footstep
	baseturf = /turf/unsimulated/floor/dirt
	has_resources = FALSE
	can_dig = FALSE

/turf/unsimulated/floor/city/Initialize(mapload)
	if(prob(20))
		var/variant = rand(1,3)
		icon_state = "concrete[variant]"
	. = ..()

/turf/unsimulated/floor/city/advanced
	name = "advanced plating"
	desc = "Metallic plating with running circuitry beneath it."
	icon = 'icons/turf/moons.dmi'
	icon_state = "adv1"

/turf/unsimulated/floor/city/advanced/Initialize(mapload)
	if(prob(20))
		var/variant = rand(1,6)
		icon_state = "adv[variant]"
	. = ..()

/turf/unsimulated/floor/city/road
	name = "aged asphalt"
	desc = "Rocky asphalt."
	icon = 'icons/turf/moons.dmi'
	icon_state = "road1"

/turf/unsimulated/floor/city/road/Initialize(mapload)
	if(prob(20))
		var/variant = rand(1,4)
		icon_state = "road[variant]"
	. = ..()

/turf/unsimulated/floor/building
	name = "decrepit flooring"
	desc = "Aged and long-forgotten."
	icon = 'icons/turf/moons.dmi'
	icon_state = "hex"
	footstep_sound = /decl/sound_category/tiles_footstep
	baseturf = /turf/unsimulated/floor/dirt
	has_resources = FALSE
	can_dig = FALSE

/turf/unsimulated/floor/building/alt1
	icon = 'icons/turf/moons.dmi'
	icon_state = "hex_decor"

/turf/unsimulated/floor/building/alt2
	icon = 'icons/turf/moons.dmi'
	icon_state = "hexdark"

/turf/unsimulated/floor/building/alt3
	icon = 'icons/turf/moons.dmi'
	icon_state = "hexdark_decor"

/turf/unsimulated/floor/building/alt4
	icon = 'icons/turf/moons.dmi'
	icon_state = "plating_warn"

/turf/unsimulated/floor/building/alt5
	icon = 'icons/turf/moons.dmi'
	icon_state = "plating"

/turf/unsimulated/floor/building/alt6
	icon = 'icons/turf/moons.dmi'
	icon_state = "tile_small"

/turf/simulated/floor/building/wood
	name = "wooden floor"
	icon = 'icons/turf/moons.dmi'
	icon_state = "birchwood"
	footstep_sound = /decl/sound_category/wood_footstep

/turf/simulated/floor/building/wood/alt
	icon_state = "cherrywood"

/turf/simulated/floor/building/wood/alt1
	icon_state = "willowwood"

/turf/simulated/floor/building/wood/alt2
	icon_state = "darkwood"

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