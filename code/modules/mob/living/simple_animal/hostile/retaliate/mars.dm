/mob/living/simple_animal/hostile/retaliate/mars/war_droid
	name = "ancient war droid"
	desc = "A terrible mistake of the past made life in the present, for reasons you don't quite know."
	icon = 'icons/mob/npc/mars/war_droid.dmi'
	icon_state = "war_droid"
	icon_living = "war_droid"
	icon_dead = "war_droid_dead"
	ranged = 1
	smart = TRUE
	turns_per_move = 3
	organ_names = list("fore optic", "central plating", "rear plating")
	response_help = "thinks better of touching"
	response_disarm = "fails to budge"
	response_harm = "baps harmlessly"
	a_intent = I_HURT
	stop_automated_movement_when_pulled = 0
	mob_size = 20

	health = 600
	maxHealth = 600
	melee_damage_lower = 50
	melee_damage_upper = 100
	attacktext = "rammed"
	attack_sound = 'sound/weapons/heavysmash.ogg'
	speed = 4
	projectiletype = /obj/item/projectile/beam/heavylaser
	projectilesound = 'sound/weapons/lasercannonfire.ogg'
	destroy_surroundings = 1

	emote_see = list("stares","hovers ominously","shutters its optics")

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	faction = "war_robot"

	flying = TRUE
	see_in_dark = 8
	see_invisible = SEE_INVISIBLE_NOLIGHTING

/mob/living/simple_animal/hostile/retaliate/mars/war_droid/Allow_Spacemove(var/check_drift = 0)
	return 1

/mob/living/simple_animal/hostile/retaliate/mars/war_droid/death()
	..(null, "blows apart!")
	var/T = get_turf(src)
	new /obj/effect/gibspawner/robot(T)
	spark(T, 1, alldirs)
	burst()

/mob/living/simple_animal/hostile/retaliate/mars/war_droid/proc/burst()
	fragem(src,10,30,2,3,5,1,0)
	src.gib()

/mob/living/simple_animal/hostile/retaliate/mars/scrap_strider
	name = "ancient war droid"
	desc = "A monolithic, awfully intelligent monster of scrap, this relatively docile pseudo-biological tower passively strolls the Metal Dunes, processing valuables it encounters as biofuel to survive. Its inner workings are a mystery, despite these having appeared nearly a hundred years ago...."
	icon = 'icons/mob/npc/mars/scrap_strider.dmi'
	icon_state = "strider"
	icon_living = "strider"
	icon_dead = "strider_dead"
	icon_rest = "strider_rest"
	smart = TRUE
	turns_per_move = 3
	organ_names = list("impenetrable plating", "gargantuan left leg", "gargantuan right leg")
	response_help = "pats"
	response_disarm = "fails to budge"
	response_harm = "baps harmlessly"
	a_intent = I_HURT
	stop_automated_movement_when_pulled = 0
	mob_size = 20
	universal_speak = 1
	universal_understand = 1

	health = 900
	maxHealth = 900
	melee_damage_lower = 50
	melee_damage_upper = 100
	attacktext = "stomped on"
	attack_sound = 'sound/weapons/heavysmash.ogg'
	speed = 6
	destroy_surroundings = 0

	emote_see = list("stares","looms","gurgles")
	speak_emote = list("rumbles")
	emote_hear = list("rattles")

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	faction = "striders"

	see_in_dark = 8
	see_invisible = SEE_INVISIBLE_NOLIGHTING

