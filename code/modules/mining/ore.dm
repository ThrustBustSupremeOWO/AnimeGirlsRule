/obj/item/ore
	name = "rock"
	icon = 'icons/obj/mining.dmi'
	icon_state = "ore1"
	randpixel = 8
	w_class = ITEMSIZE_SMALL
	throwforce = 10
	var/datum/geosample/geologic_data
	var/material

/obj/item/ore/uranium
	name = "pitchblende"
	icon_state = "ore_uranium"
	origin_tech = list(TECH_MATERIAL = 5)
	material = ORE_URANIUM

/obj/item/ore/iron
	name = "hematite"
	icon_state = "ore_iron"
	origin_tech = list(TECH_MATERIAL = 1)
	material = ORE_IRON

/obj/item/ore/coal
	name = "raw carbon"
	icon_state = "ore_coal"
	origin_tech = list(TECH_MATERIAL = 1)
	material = ORE_COAL

/obj/item/ore/glass
	name = "sand"
	icon_state = "ore_glass"
	origin_tech = list(TECH_MATERIAL = 1)
	material = ORE_SAND
	slot_flags = SLOT_HOLSTER

// POCKET SAND!
/obj/item/ore/glass/throw_impact(atom/hit_atom)
	..()
	var/mob/living/carbon/human/H = hit_atom
	if(istype(H) && H.has_eyes() && prob(85))
		to_chat(H, SPAN_DANGER("Some of \the [src] gets in your eyes!"))
		H.eye_blind += 5
		H.eye_blurry += 10
		qdel(src)

/obj/item/ore/phoron
	name = "phoron crystals"
	icon_state = "ore_phoron"
	origin_tech = list(TECH_MATERIAL = 2, TECH_PHORON = 2)
	material = ORE_PHORON

/obj/item/ore/silver
	name = "native silver ore"
	icon_state = "ore_silver"
	origin_tech = list(TECH_MATERIAL = 3)
	material = ORE_SILVER

/obj/item/ore/gold
	name = "native gold ore"
	icon_state = "ore_gold"
	origin_tech = list(TECH_MATERIAL = 4)
	material = ORE_GOLD

/obj/item/ore/diamond
	name = "diamonds"
	icon_state = "ore_diamond"
	origin_tech = list(TECH_MATERIAL = 6)
	material = ORE_DIAMOND

/obj/item/ore/osmium
	name = "raw platinum"
	icon_state = "ore_platinum"
	material = ORE_PLATINUM

/obj/item/ore/hydrogen
	name = "raw hydrogen"
	icon_state = "ore_hydrogen"
	material = ORE_HYDROGEN

/obj/item/ore/dirt
	name = "soil"
	desc = "Yep. That's dirt."
	icon_state = "ore_soil"
	material = ORE_SOIL

/obj/item/ore/copper
	name = "copper"
	icon_state = "ore_copper"
	material = ORE_COPPER

/obj/item/ore/aluminum
	name = "aluminum"
	icon_state = "ore_aluminum"
	material = ORE_ALUMINUM

/obj/item/ore/titanium
	name = "titanium"
	desc = "Titanium ore, which can be alloyed with coal and platinum to create titanium sheets."
	icon_state = "ore_titanium"
	material = ORE_TITANIUM

/obj/item/ore/prydinate
	name = "prydinate"
	desc = "Raw prydinate is rarely found on known planets, only slightly more common than Phoron. Given its limited uses and ability to be synthesized, though, it's not terribly valuable."
	icon_state = "ore_prydinate"
	material = ORE_PRYDINATE

// maybe someone can think of a creative way to use slag
// and make slagging shit not absolutely bomb mining - geeves
/obj/item/ore/slag
	name = "Slag"
	desc = "Someone screwed up..."
	icon_state = "slag"
	material = null

/obj/item/ore/Initialize()
	. = ..()
	if((randpixel_xy()) && icon_state == "ore1")
		icon_state = "ore[pick(1,2,3)]"

/obj/item/ore/attackby(obj/item/W, mob/user)
	if(istype(W,/obj/item/device/core_sampler))
		var/obj/item/device/core_sampler/C = W
		C.sample_item(src, user)
	else
		return ..()
