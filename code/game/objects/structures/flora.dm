/obj/structure/flora/
	anchored = TRUE
	desc_info = "Most flora can be cut down using a sharp object, except when on help intent."
	var/cross_difficulty = 0 //How difficult this is to cross. Used for thick brush. 
	var/can_cut = TRUE //Chopping through brush
	var/is_cut = FALSE //True if cut already. Used for multi-stage cutting.
	var/being_chopped = FALSE //True when being chopped at. Spam prevention.
	var/chop_difficulty = 5 //Compared to item force value, higher is harder to cut

/obj/structure/flora/Initialize()
	. = ..()
	if(cross_difficulty)
		update_cross_difficulty(cross_difficulty, get_turf(src))

/obj/structure/flora/Destroy()
	update_cross_difficulty(0, get_turf(src))
	. = ..()

/obj/structure/flora/proc/update_cross_difficulty(var/amount, var/turf/T)
	if(!istype(T))
		return 0
	if(!amount)
		T.movement_cost = initial(T.movement_cost)
	else
		T.movement_cost += amount

/obj/structure/flora/proc/do_cut(mob/user, var/obj/item/I, var/chop_power) //Cutting pre-check.
	if(being_chopped)
		to_chat(user, SPAN_WARNING("\The [src] is already being cut!"))
		return
	if(chop_power < chop_difficulty)
		to_chat(user, SPAN_WARNING("\The [src] is too tough to chop with \the [I]!"))
		return

/obj/structure/flora/attackby(var/obj/item/I, mob/user) 
	if(can_cut)
		var/cutting = I.get_cutting_power()
		if(cutting)
			if(user.a_intent != I_HELP) //Intent check is here because if we check initially sometimes we get the "Bob Bingus hit plant with sword"
				do_cut(user, I, cutting)
			return
	return ..()

//trees
/obj/structure/flora/tree
	name = "tree"
	density = TRUE
	pixel_x = -16
	layer = 9
	can_cut = FALSE //Chopping mechanics are different
	var/chop_count //Chops made
	var/chop_fall = 10 //Chops until we drop
	var/list/drops = list() //should be equal to % chance of getting, example list(/obj/item/fruit = 100, /obj/item/nuke = 1)
	var/wood_amount = 5 //Slight variation
	var/obj/item/stack/material/wood_product = /obj/item/stack/material/wood

/obj/structure/flora/tree/attackby(var/obj/item/I, mob/user)
	if(I.can_woodcut())
		if(istype(I, /obj/item/material/twohanded/chainsaw))
			chainsaw(user, I)
		else
			woodcut(user, I)
		return
	return ..()

/obj/structure/flora/tree/proc/woodcut(mob/user, var/obj/item/I)
	if(being_chopped)
		to_chat(user, SPAN_WARNING("\The [src] is already being cut!"))
		return
	being_chopped = TRUE
	if(do_after(user, (chop_difficulty * 40) / I.force))
		if(prob(25))
			user.visible_message(SPAN_WARNING("[user] chops at \the [src] with \the [I]!"), SPAN_WARNING("You chop at \the [src]!"))
		if(istype(I, /obj/item/melee/energy))
			playsound(get_turf(src), 'sound/weapons/blade.ogg', 50, 1)
		else
			playsound(get_turf(src), 'sound/effects/woodcutting.ogg', 50, 1)
		shake_animation()
		chop_count += rand(1,2)
	being_chopped = FALSE
	if(chop_count >= chop_fall)
		fall()

/obj/structure/flora/tree/proc/chainsaw(mob/user, var/obj/item/material/twohanded/chainsaw/I)
	if(!istype(I))
		return
	if(being_chopped)
		to_chat(user, SPAN_WARNING("\The [src] is already being cut!"))
		return
	being_chopped = TRUE
	while(do_after(user, 20) && I.powered && chop_count < chop_fall)
		I.RemoveFuel(1)
		if(!I.powered)
			being_chopped = FALSE
			break
		chop_count += rand(1,3)
	being_chopped = FALSE
	if(chop_count >= chop_fall)
		fall()

/obj/structure/flora/tree/proc/fall()
	playsound(get_turf(src), 'sound/species/diona/gestalt_grow.ogg', 50, 1)
	visible_message(SPAN_WARNING("\The [src] falls!"))
	var/obj/item/stack/material/M = new wood_product(get_turf(src), rand(wood_amount - 1, wood_amount + 1))
	M.update_icon()
	if(length(drops))
		for(var/obj/O in drops)
			if(prob(drops[O]))
				new O(get_turf(src))
	new /obj/structure/flora/tree/stump(get_turf(src))
	qdel(src)
	
/obj/structure/flora/tree/pine
	name = "pine tree"
	icon = 'icons/obj/flora/pinetrees.dmi'
	icon_state = "pine_1"

/obj/structure/flora/tree/pine/New()
	..()
	icon_state = "pine_[rand(1, 3)]"

/obj/structure/flora/tree/pine/xmas
	name = "xmas tree"
	icon = 'icons/obj/flora/pinetrees.dmi'
	icon_state = "pine_c"

/obj/structure/flora/tree/pine/xmas/New()
	..()
	icon_state = "pine_c"

/obj/structure/flora/tree/dead
	icon = 'icons/obj/flora/deadtrees.dmi'
	icon_state = "tree_1"

/obj/structure/flora/tree/dead/New()
	..()
	icon_state = "tree_[rand(1, 6)]"

/obj/structure/flora/tree/jungle
	name = "tree"
	icon_state = "tree"
	desc = "A lush and healthy tree."
	icon = 'icons/obj/flora/jungletrees.dmi'
	pixel_x = -48
	pixel_y = -20

/obj/structure/flora/tree/jungle/small
	pixel_y = 0
	pixel_x = -32
	icon = 'icons/obj/flora/jungletreesmall.dmi'

/obj/structure/flora/tree/stump
	name = "tree stump"
	desc = "Used to be much taller."
	desc_info = null
	icon = 'icons/jungle.dmi'
	density = FALSE
	opacity = FALSE

/obj/structure/flora/tree/stump/woodcut(mob/user, var/obj/item/I)
	return

/obj/structure/flora/tree/stump/chainsaw(mob/user, var/obj/item/I)
	return

/obj/structure/flora/tree/stump/fall()
	return

//rocks
/obj/structure/flora/rock
	icon_state = "basalt"
	desc = "A rock."
	desc_info = null
	icon = 'icons/obj/flora/rocks_grey.dmi'
	density = TRUE
	can_cut = FALSE

/obj/structure/flora/rock/pile
	name = "rocks"
	icon_state = "lavarocks"
	desc = "A pile of rocks."

//grass
/obj/structure/flora/grass
	name = "grass"
	icon = 'icons/obj/flora/snowflora.dmi'

/obj/structure/flora/grass/do_cut(mob/user, var/obj/item/I, var/chop_power)
	..()
	being_chopped = TRUE
	if(do_after(user, 100/chop_power))
		user.visible_message(SPAN_NOTICE("\The [user] cuts down \the [src]!"), SPAN_NOTICE("You cut down \the [src]."))
		being_chopped = FALSE
		qdel(src)
	being_chopped = FALSE

/obj/structure/flora/grass/brown
	icon_state = "snowgrass1bb"

/obj/structure/flora/grass/brown/New()
	..()
	icon_state = "snowgrass[rand(1, 3)]bb"


/obj/structure/flora/grass/green
	icon_state = "snowgrass1gb"

/obj/structure/flora/grass/green/New()
	..()
	icon_state = "snowgrass[rand(1, 3)]gb"

/obj/structure/flora/grass/both
	icon_state = "snowgrassall1"

/obj/structure/flora/grass/both/New()
	..()
	icon_state = "snowgrassall[rand(1, 3)]"

//Jungle grass
/obj/structure/flora/grass/jungle
	name = "jungle grass"
	desc = "Thick alien flora."
	icon = 'icons/obj/flora/jungleflora.dmi'
	icon_state = "grassa"
	cross_difficulty = 0.5

/obj/structure/flora/grass/jungle/b
	icon_state = "grassb"

//moon flora
/obj/structure/flora/moons/thickbrush
	name = "thick brush"
	desc = "Thick alien flora."
	icon = 'icons/obj/flora/moons.dmi'
	icon_state = "thickbrush1"
	cross_difficulty = 2
	opacity = TRUE
	can_cut = TRUE
	chop_difficulty = 10

/obj/structure/flora/moons/thickbrush/Initialize()
  . = ..()
  icon_state = "thickbrush[rand(1, 8)]"

/obj/structure/flora/moons/thickbrush/do_cut(mob/user, var/obj/item/I, var/chop_power)
	..()
	user.visible_message(SPAN_WARNING("[user] starts chopping at \the [src] with \the [I]!"), SPAN_WARNING("You start chopping at \the [src]!"))
	being_chopped = TRUE
	if(do_after(user, 600/chop_power))
		if(is_cut)
			user.visible_message(SPAN_WARNING("\The [user] hacks away the rest of \the [src]!"), SPAN_WARNING("You hack away the rest of \the [src]!"))
			qdel(src)
			return
		user.visible_message(SPAN_WARNING("\The [user] chops away some of \the [src]!"), SPAN_WARNING("You chop away some of \the [src]!"))
		is_cut = TRUE
		icon_state = "[icon_state]_open"
		opacity = FALSE
		update_cross_difficulty(0, get_turf(src))
		update_icon()
	being_chopped = FALSE

/obj/structure/flora/moons/thickbrush/Crossed(AM)
	if(isliving(AM) && prob(50) && !is_cut)
		playsound(loc, 'sound/effects/plantshake.ogg', 50, 1)

//bushes
/obj/structure/flora/bush
	name = "bush"
	icon = 'icons/obj/flora/snowflora.dmi'
	icon_state = "snowbush1"
	cross_difficulty = 0.5

/obj/structure/flora/bush/New()
	..()
	icon_state = "snowbush[rand(1, 6)]"

/obj/structure/flora/bush/do_cut(mob/user, var/obj/item/I, var/chop_power)
	..()
	being_chopped = TRUE
	if(do_after(user, 400/chop_power))
		user.visible_message(SPAN_NOTICE("\The [user] cuts down \the [src]!"), SPAN_NOTICE("You cut down \the [src]."))
		being_chopped = FALSE
		qdel(src)
	being_chopped = FALSE

/obj/structure/flora/pottedplant
	name = "potted plant"
	desc_info = null
	icon = 'icons/obj/plants.dmi'
	icon_state = "plant-26"
	var/dead = 0
	var/obj/item/stored_item
	anchored = FALSE
	can_cut = FALSE

/obj/structure/flora/pottedplant/Destroy()
	QDEL_NULL(stored_item)
	return ..()

/obj/structure/flora/pottedplant/proc/death()
	if (!dead)
		icon_state = "plant-dead"
		name = "dead [name]"
		desc = "It looks dead."
		dead = 1

//No complex interactions, just make them fragile
/obj/structure/flora/pottedplant/ex_act(var/severity = 2.0)
	death()
	return ..()

/obj/structure/flora/pottedplant/fire_act()
	death()
	return ..()

/obj/structure/flora/pottedplant/attackby(obj/item/W, mob/user)
	if(!ishuman(user))
		return
	if(istype(W, /obj/item/holder))
		return //no hiding mobs in there
	user.visible_message("[user] begins digging around inside of \the [src].", "You begin digging around in \the [src], trying to hide \the [W].")
	playsound(loc, 'sound/effects/plantshake.ogg', 50, 1)
	if(do_after(user, 20, act_target = src))
		if(!stored_item)
			if(W.w_class <= ITEMSIZE_NORMAL)
				user.drop_from_inventory(W,src)
				stored_item = W
				to_chat(user,"<span class='notice'>You hide \the [W] in [src].</span>")
				return
			else
				to_chat(user,"<span class='notice'>\The [W] can't be hidden in [src], it's too big.</span>")
				return
		else
			to_chat(user,"<span class='notice'>There is something hidden in [src].</span>")
			return
	return ..()

/obj/structure/flora/pottedplant/attack_hand(mob/user)
	user.visible_message("[user] begins digging around inside of \the [src].", "You begin digging around in \the [src], searching it.")
	playsound(loc, 'sound/effects/plantshake.ogg', 50, 1)
	if(do_after(user, 40, act_target = src))
		if(!stored_item)
			to_chat(user,"<span class='notice'>There is nothing hidden in [src].</span>")
		else
			if(istype(stored_item, /obj/item/device/paicard))
				stored_item.forceMove(src.loc)
				to_chat(user,"<span class='notice'>You reveal \the [stored_item] from [src].</span>")
			else
				user.put_in_hands(stored_item)
				to_chat(user,"<span class='notice'>You take \the [stored_item] from [src].</span>")
			stored_item = null

/obj/structure/flora/pottedplant/bullet_act(var/obj/item/projectile/Proj)
	if (prob(Proj.damage*2))
		death()
		return 1
	return ..()

//Added random icon selection for potted plants.
//It was silly they always used the same sprite when we have 26 sprites of them in the icon file
/obj/structure/flora/pottedplant/random/New()
	..()
	var/number = rand(1,36)
	if (number == 36)
		if (prob(90))//Make the weird one rarer
			number = rand(1,35)
		else if(!desc)
			desc = "A half-sentient plant borne from a mishap in a Zeng-Hu genetics lab."

	if(!desc)
		switch(number) //Wezzy's cool new plant description code. Special thanks to Sindorman.
			if(3)
				desc = "A bouquet of Bieselite flora."
			if(4)
				desc = "A bamboo plant. Used widely in Japanese crafts."
			if(5)
				desc = "Some kind of fern."
			if(7)
				desc = "A reedy plant mostly used for decoration in Skrell homes, admired for its luxuriant stalks."
			if(9)
				desc = "A fleshy cave dwelling plant with huge nodules for flowers."
			if(9)
				desc = "A scrubby cactus adapted to the Moghes deserts."
			if(13)
				desc = "A hardy succulent adapted to the Moghes deserts."
			if(14)
				desc = "That's a huge flower. Previously, the petals would be used in dyes for unathi garb. Now it's more of a decorative plant."
			if(15)
				desc = "A pitiful pot of stubby flowers."
			if(18)
				desc = "An orchid plant. As beautiful as it is delicate."
			if(19)
				desc = "A ropey, aquatic plant with crystaline flowers."
			if(20)
				desc = "A bioluminescent half-plant half-fungus hybrid. Said to come from Sedantis I."
			if(22)
				desc = "A cone shrub. Sadly doesn't come from Coney Island."
			if(26)
				desc = "A bulrush. Commonly referred to as cattail."
			if(27)
				desc = "A rose bush. Don't prick yourself."
			if(32)
				desc = "A woody shrub."
			if(33)
				desc = "A woody shrub. Seems to be in need of watering."
			if(34)
				desc = "A woody shrub. This one seems to be in bloom. It's just like one of my japanese animes."
			else
				desc = "Just your common, everyday houseplant."



	if (number < 10)
		number = "0[number]"
	icon_state = "plant-[number]"

//newbushes

/obj/structure/flora/ausbushes
	name = "bush"
	icon = 'icons/obj/flora/ausflora.dmi'
	icon_state = "firstbush_1"

/obj/structure/flora/ausbushes/New()
	..()
	icon_state = "firstbush_[rand(1, 4)]"

/obj/structure/flora/ausbushes/reedbush
	icon_state = "reedbush_1"

/obj/structure/flora/ausbushes/reedbush/New()
	..()
	icon_state = "reedbush_[rand(1, 4)]"

/obj/structure/flora/ausbushes/leafybush
	icon_state = "leafybush_1"

/obj/structure/flora/ausbushes/leafybush/New()
	..()
	icon_state = "leafybush_[rand(1, 3)]"

/obj/structure/flora/ausbushes/palebush
	icon_state = "palebush_1"

/obj/structure/flora/ausbushes/palebush/New()
	..()
	icon_state = "palebush_[rand(1, 4)]"

/obj/structure/flora/ausbushes/stalkybush
	icon_state = "stalkybush_1"

/obj/structure/flora/ausbushes/stalkybush/New()
	..()
	icon_state = "stalkybush_[rand(1, 3)]"

/obj/structure/flora/ausbushes/grassybush
	icon_state = "grassybush_1"

/obj/structure/flora/ausbushes/grassybush/New()
	..()
	icon_state = "grassybush_[rand(1, 4)]"

/obj/structure/flora/ausbushes/fernybush
	icon_state = "fernybush_1"

/obj/structure/flora/ausbushes/fernybush/New()
	..()
	icon_state = "fernybush_[rand(1, 3)]"

/obj/structure/flora/ausbushes/sunnybush
	icon_state = "sunnybush_1"

/obj/structure/flora/ausbushes/sunnybush/New()
	..()
	icon_state = "sunnybush_[rand(1, 3)]"

/obj/structure/flora/ausbushes/genericbush
	icon_state = "genericbush_1"

/obj/structure/flora/ausbushes/genericbush/New()
	..()
	icon_state = "genericbush_[rand(1, 4)]"

/obj/structure/flora/ausbushes/pointybush
	icon_state = "pointybush_1"

/obj/structure/flora/ausbushes/pointybush/New()
	..()
	icon_state = "pointybush_[rand(1, 4)]"

/obj/structure/flora/ausbushes/lavendergrass
	icon_state = "lavendergrass_1"

/obj/structure/flora/ausbushes/lavendergrass/New()
	..()
	icon_state = "lavendergrass_[rand(1, 4)]"

/obj/structure/flora/ausbushes/ywflowers
	icon_state = "ywflowers_1"

/obj/structure/flora/ausbushes/ywflowers/New()
	..()
	icon_state = "ywflowers_[rand(1, 3)]"

/obj/structure/flora/ausbushes/brflowers
	icon_state = "brflowers_1"

/obj/structure/flora/ausbushes/brflowers/New()
	..()
	icon_state = "brflowers_[rand(1, 3)]"

/obj/structure/flora/ausbushes/ppflowers
	icon_state = "ppflowers_1"

/obj/structure/flora/ausbushes/ppflowers/New()
	..()
	icon_state = "ppflowers_[rand(1, 4)]"

/obj/structure/flora/ausbushes/sparsegrass
	icon_state = "sparsegrass_1"

/obj/structure/flora/ausbushes/sparsegrass/New()
	..()
	icon_state = "sparsegrass_[rand(1, 3)]"

/obj/structure/flora/ausbushes/fullgrass
	icon_state = "fullgrass_1"

/obj/structure/flora/ausbushes/fullgrass/New()
	..()
	icon_state = "fullgrass_[rand(1, 3)]"