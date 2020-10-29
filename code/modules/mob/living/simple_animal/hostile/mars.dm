/mob/living/simple_animal/hostile/bloodhound
	name = "Bloodhound"
	desc = "A self-preserving, yet rather unintelligent robot originally designed to police the Metal Dunes of its scrapper populace. It later proved to be forgotten by the Alliance officials who designed it, leaving its kind to lurk as a threat among the scrapyards."
	icon = 'icons/mob/npc/mars/mars.dmi'
	icon_state = "bloodhound"
	icon_living = "bloodhound"
	icon_dead = "bloodhound"
	speak_chance = 0
	turns_per_move = 5
	organ_names = list("upper tripod supports", "lower tripod supports")
	response_help = "bonks"
	response_disarm = "shoves"
	response_harm = "hits"
	speed = -1
	maxHealth = 45
	projectilesound = 'sound/weapons/gunshot/gunshot_shotgun.ogg'
	projectiletype = /obj/item/projectile/bullet/pistol
	health = 45
	ranged = 1
	environment_smash = 2

	tameable = FALSE

	harm_intent_damage = 10
	melee_damage_lower = 15
	melee_damage_upper = 15
	attacktext = "rammed"

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	speed = 4

	faction = "sol_police"

/mob/living/simple_animal/hostile/bloodhound/FindTarget()
	var/my_target = target_mob
	. = ..()
	if(. && (prob(30) || (. != my_target)))
		audible_emote("blares a horrible siren at[.]")

