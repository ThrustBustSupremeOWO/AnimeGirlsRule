/mob/living/simple_animal/hostile/boar
	name = "jungle boar"
	desc = "A tough and highly aggressive tusked pig. Notorious for being difficult to kill."
	faction = "boar"
	icon_state = "boar"
	icon_living = "boar"
	icon_dead = "boar_dead"
	icon = 'icons/mob/npc/moons_fauna.dmi'
	move_to_delay = 2
	maxHealth = 125
	health = 125
	speed = 2
	melee_damage_lower = 5
	melee_damage_upper = 15
	attacktext = "gored"
	cold_damage_per_tick = 0
	speak_chance = 5
	speak = list("Hruuugh!","Hrunnph")
	emote_see = list("paws the ground","shakes its head","stomps")
	emote_hear = list("snuffles", "snorts")
	mob_size = 10

/mob/living/simple_animal/hostile/wretch
	name = "shambling wretch"
	desc = "A disgusting looking red creature that oozes a terrible stench. Its solemn, jagged mouth unsteadily slams open and shut to reveal dozens of eyes inside..."
	faction = "shimmer"
	icon_state = "wretch"
	icon_living = "wretch"
	icon_dead = "wretch"
	icon = 'icons/mob/npc/moons_fauna.dmi'
	move_to_delay = 5
	maxHealth = 50
	health = 50
	speed = 5
	melee_damage_lower = 15
	melee_damage_upper = 22
	see_in_dark = 12
	attacktext = "chomped"
	speak_chance = 5
	speak = list("eeEEeegh","HssSSS")
	emote_see = list("bites the air","twitches violently","gags and gurgles")
	emote_hear = list("cries out", "chokes")
	mob_size = 10

/mob/living/simple_animal/hostile/wretch/death(gibbed)
	..()
	if(!gibbed)
		visible_message("<b>[src]</b> explodes in a shower of guts and gore!")
		playsound(loc, 'sound/effects/creepyshriek.ogg', 30, 1)
		gibs(src.loc)
		qdel(src)
		return

/mob/living/simple_animal/hostile/mantalisk
	name = "mantalisk"
	desc = "A vicious, powerful creature which looks like a hovering, writhing eel. It has a wicked, evil grin."
	faction = "mantalisk"
	icon_state = "mantalisk"
	icon_living = "mantalisk"
	icon_dead = "mantalisk"
	icon = 'icons/mob/npc/moons_fauna.dmi'
	move_to_delay = 6
	see_in_dark = 12
	maxHealth = 350
	health = 350
	speed = 6
	melee_damage_lower = 30
	melee_damage_upper = 50
	attacktext = "viciously grappled"
	speak_chance = 5
	speak = list("HRGG","HISS")
	emote_see = list("writhes","scans its surroundings","lunges at nothing")
	emote_hear = list("shrieks", "drools")
	mob_size = 10
	attack_sound = 'sound/weapons/bloodyslice.ogg'

/mob/living/simple_animal/hostile/mantalisk/death(gibbed)
	..()
	if(!gibbed)
		visible_message("<b>[src]</b> falls to pieces in a disappointing display of gore.")
		playsound(loc, 'sound/effects/creepyshriek.ogg', 30, 1)
		gibs(src.loc)
		qdel(src)
		return

/mob/living/simple_animal/hostile/mantalisk/proc/add_glow()
	cut_overlays()
	var/overlay_layer = EFFECTS_ABOVE_LIGHTING_LAYER
	if(layer != MOB_LAYER)
		overlay_layer = TURF_LAYER + 0.2

	add_overlay(image(icon, "glow-[icon_state]", overlay_layer))
	set_light(2, -2, l_color = COLOR_WHITE)