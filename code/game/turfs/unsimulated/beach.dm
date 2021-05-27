/turf/unsimulated/beach
	name = "Beach"
	icon = 'icons/misc/beach.dmi'
	footstep_sound = /decl/sound_category/sand_footstep

/turf/unsimulated/beach/sand
	name = "Sand"
	icon_state = "sand"
	footstep_sound = /decl/sound_category/sand_footstep

/turf/unsimulated/beach/coastline
	name = "Coastline"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "sandwater"
	footstep_sound = /decl/sound_category/sand_footstep

/turf/unsimulated/beach/water
	name = "Water"
	icon_state = "water"
	footstep_sound = /decl/sound_category/water_footstep

/turf/unsimulated/beach/water/pink
	name = "pink water"
	icon = 'icons/turf/moons.dmi'
	icon_state = "seadeep"
	footstep_sound = /decl/sound_category/water_footstep

/turf/unsimulated/beach/water/Initialize()
	. = ..()
	add_overlay(image("icon"='icons/turf/moons.dmi',"icon_state"="overlay","layer"=MOB_LAYER+0.1))