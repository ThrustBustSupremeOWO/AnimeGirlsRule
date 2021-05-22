/turf
	icon = 'icons/turf/floors.dmi'
	level = 1
	var/holy = 0

	// Initial air contents (in moles)
	var/oxygen = 0
	var/carbon_dioxide = 0
	var/nitrogen = 0
	var/phoron = 0
	var/hydrogen = 0

	//Properties for airtight tiles (/wall)
	var/thermal_conductivity = 0.05
	var/heat_capacity = 1

	//Properties for both
	var/temperature = T20C      // Initial turf temperature.
	var/blocks_air = 0          // Does this turf contain air/let air through?

	// General properties.
	var/icon_old = null
	var/pathweight = 1          // How much does it cost to pathfind over this turf?
	var/blessed = 0             // Has the turf been blessed?

	var/footstep_sound = /decl/sound_category/tiles_footstep

	var/list/decals
	var/list/blueprints

	var/is_hole		// If true, turf will be treated as space or a hole
	var/tmp/turf/baseturf

	var/roof_type = null // The turf type we spawn as a roof.
	var/tmp/roof_flags = 0

	var/movement_cost = 0 // How much the turf slows down movement, if any.

	// Footprint info
	var/tracks_footprint = TRUE // Whether footprints will appear on this turf
	var/does_footprint = FALSE // Whether stepping on this turf will dirty your shoes or feet with the below
	var/footprint_color // The hex color produced by the turf
	var/track_distance = 12 // How far the tracks last

	//Mining resources (for the large drills).
	var/has_resources
	var/list/resources = list()

	// Plating data.
	var/base_name = "plating"
	var/base_desc = "The naked hull."
	var/base_icon = 'icons/turf/flooring/plating.dmi'
	var/base_icon_state = "plating"
	var/last_clean //for clean log spam.

	var/static/list/digging_tools = typecacheof(list(/obj/item/shovel, /obj/item/pickaxe/drill, /obj/item/pickaxe/diamonddrill, /obj/item/pickaxe/hand))
	var/can_dig = FALSE //If we can dig into this
	var/dug //dig counter
	var/digging //being dug?
	var/image/hole_overlay
	var/covered_hole //true if we buried something here
	var/can_plate = FALSE //can put plating on

// Parent code is duplicated in here instead of ..() for performance reasons.
// There's ALSO a copy of this in mine_turfs.dm!
/turf/Initialize(mapload, ...)
	if (initialized)
		crash_with("Warning: [src]([type]) initialized multiple times!")

	initialized = TRUE

	for(var/atom/movable/AM as mob|obj in src)
		Entered(AM)

	turfs += src

	if(dynamic_lighting)
		luminosity = 0
	else
		luminosity = 1

	if (smooth)
		queue_smooth(src)

	if (light_range && light_power)
		update_light()

	if (opacity)
		has_opaque_atom = TRUE

	if (mapload && permit_ao)
		queue_ao()

	var/area/A = loc

	if(!baseturf)
		// Hard-coding this for performance reasons.
		baseturf = A.base_turf || current_map.base_turf_by_z["[z]"] || /turf/space

	if (A.flags & SPAWN_ROOF)
		spawn_roof()

	if (flags & MIMIC_BELOW)
		setup_zmimic(mapload)

	if(has_resources)
		generate_resources() 

	return INITIALIZE_HINT_NORMAL

/turf/Destroy()
	if (!changing_turf)
		crash_with("Improper turf qdeletion.")

	changing_turf = FALSE
	turfs -= src

	cleanup_roof()

	if (ao_queued)
		SSocclusion.queue -= src
		ao_queued = 0

	if (flags & MIMIC_BELOW)
		cleanup_zmimic()

	if (bound_overlay)
		QDEL_NULL(bound_overlay)

	..()
	return QDEL_HINT_IWILLGC

/turf/proc/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	underlay_appearance.appearance = src
	underlay_appearance.dir = adjacency_dir
	return TRUE

/turf/ex_act(severity)
	return 0

/turf/proc/is_solid_structure()
	return 1

/turf/proc/is_space()
	return 0

/turf/proc/is_intact()
	return 0

/turf/attack_hand(mob/user)
	if(!(user.canmove) || user.restrained() || !(user.pulling))
		return 0
	if(user.pulling.anchored || !isturf(user.pulling.loc))
		return 0
	if(user.pulling.loc != user.loc && get_dist(user, user.pulling) > 1)
		return 0
	if(ismob(user.pulling))
		var/mob/M = user.pulling
		var/atom/movable/t = M.pulling
		M.stop_pulling()
		step(user.pulling, get_dir(user.pulling.loc, src))
		M.start_pulling(t)
	else
		step(user.pulling, get_dir(user.pulling.loc, src))
	return 1

/turf/Enter(atom/movable/mover as mob|obj, atom/forget as mob|obj|turf|area)
	if(movement_disabled && usr.ckey != movement_disabled_exception)
		to_chat(usr, "<span class='warning'>Movement is admin-disabled.</span>") //This is to identify lag problems)
		return

	..()

	if (!mover || !isturf(mover.loc))
		return 1

	//First, check objects to block exit that are not on the border
	for(var/obj/obstacle in mover.loc)
		if(!(obstacle.flags & ON_BORDER) && (mover != obstacle) && (forget != obstacle))
			if(!obstacle.CheckExit(mover, src))
				mover.Collide(obstacle)
				return 0

	//Now, check objects to block exit that are on the border
	for(var/obj/border_obstacle in mover.loc)
		if((border_obstacle.flags & ON_BORDER) && (mover != border_obstacle) && (forget != border_obstacle))
			if(!border_obstacle.CheckExit(mover, src))
				mover.Collide(border_obstacle)
				return 0

	//Next, check objects to block entry that are on the border
	for(var/obj/border_obstacle in src)
		if(border_obstacle.flags & ON_BORDER)
			if(!border_obstacle.CanPass(mover, mover.loc, 1, 0) && (forget != border_obstacle))
				mover.Collide(border_obstacle)
				return 0

	//Then, check the turf itself
	if (!src.CanPass(mover, src))
		mover.Collide(src)
		return 0

	//Finally, check objects/mobs to block entry that are not on the border
	for(var/atom/movable/obstacle in src)
		if(!(obstacle.flags & ON_BORDER))
			if(!obstacle.CanPass(mover, mover.loc, 1, 0) && (forget != obstacle))
				mover.Collide(obstacle)
				return 0
	return 1 //Nothing found to block so return success!

var/const/enterloopsanity = 100

/turf/Entered(atom/movable/AM)
	if(movement_disabled)
		to_chat(usr, "<span class='warning'>Movement is admin-disabled.</span>") //This is to identify lag problems)
		return

	ASSERT(istype(AM))

	if(ismob(AM))
		var/mob/M = AM
		if(!M.lastarea)
			M.lastarea = get_area(M.loc)
		if(M.lastarea.has_gravity() == 0)
			inertial_drift(M)

		// Footstep SFX logic moved to human_movement.dm - Move().

		else if (type != /turf/space)
			M.inertia_dir = 0
			M.make_floating(0)

	if(does_footprint && footprint_color && ishuman(AM))
		var/mob/living/carbon/human/H = AM
		var/obj/item/organ/external/l_foot = H.get_organ(BP_L_FOOT)
		var/obj/item/organ/external/r_foot = H.get_organ(BP_R_FOOT)
		var/has_feet = TRUE
		if((!l_foot || l_foot.is_stump()) && (!r_foot || r_foot.is_stump()))
			has_feet = FALSE
		if(!H.buckled_to && !H.lying && has_feet)
			if(H.shoes) //Adding ash to shoes
				var/obj/item/clothing/shoes/S = H.shoes
				if(istype(S))
					S.blood_color = footprint_color
					S.track_footprint = max(track_distance, S.track_footprint)

					if(!S.blood_overlay)
						S.generate_blood_overlay()
					if(S.blood_overlay?.color != footprint_color)
						S.cut_overlay(S.blood_overlay, TRUE)

					S.blood_overlay.color = footprint_color
					S.add_overlay(S.blood_overlay, TRUE)
			else
				H.footprint_color = footprint_color
				H.track_footprint = max(track_distance, H.track_footprint)

		H.update_inv_shoes(TRUE)

	if(istype(AM, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = AM
		// Tracking blood
		var/list/footprint_DNA = list()
		var/footprint_color
		var/will_track = FALSE
		if(H.shoes)
			var/obj/item/clothing/shoes/S = H.shoes
			if(istype(S))
				S.handle_movement(src, H.m_intent == M_RUN ? TRUE : FALSE)
				if(S.track_footprint)
					if(S.blood_DNA)
						footprint_DNA = S.blood_DNA
					footprint_color = S.blood_color
					S.track_footprint--
					will_track = TRUE
		else
			if(H.track_footprint)
				if(H.feet_blood_DNA)
					footprint_DNA = H.feet_blood_DNA
				footprint_color = H.footprint_color
				H.track_footprint--
				will_track = TRUE

		if(tracks_footprint && will_track)
			add_tracks(H.species.get_move_trail(H), footprint_DNA, H.dir, 0, footprint_color) // Coming
			var/turf/simulated/from = get_step(H, reverse_direction(H.dir))
			if(istype(from) && from)
				from.add_tracks(H.species.get_move_trail(H), footprint_DNA, 0, H.dir, footprint_color) // Going
			footprint_DNA = null

	..()

	var/objects = 0
	if(AM && (AM.flags & PROXMOVE) && AM.simulated)
		for(var/atom/movable/oAM in range(1))
			if(objects > enterloopsanity)
				break
			objects++

			if (oAM.simulated)
				AM.proximity_callback(oAM)

/turf/proc/add_tracks(var/typepath, var/footprint_DNA, var/comingdir, var/goingdir, var/footprint_color="#A10808")
	var/obj/effect/decal/cleanable/blood/tracks/tracks = locate(typepath) in src
	if(!tracks)
		tracks = new typepath(src)
	tracks.add_tracks(footprint_DNA, comingdir, goingdir, footprint_color)

/atom/movable/proc/proximity_callback(atom/movable/AM)
	set waitfor = FALSE
	sleep(0)
	HasProximity(AM, TRUE)
	if (!QDELETED(AM) && !QDELETED(src) && (AM.flags & PROXMOVE))
		AM.HasProximity(src, TRUE)

/turf/proc/adjacent_fire_act(turf/simulated/floor/source, temperature, volume)
	return

/turf/proc/is_plating()
	return 0

/turf/proc/can_have_cabling()
	return FALSE

/turf/proc/can_lay_cable()
	return can_have_cabling()

/turf/attackby(obj/item/C, mob/user)
	if (can_lay_cable() && C.iscoil())
		var/obj/item/stack/cable_coil/coil = C
		coil.turf_place(src, user)
	else
		..()

/turf/proc/inertial_drift(atom/movable/A as mob|obj)
	if(!(A.last_move))	return
	if((istype(A, /mob/) && src.x > 2 && src.x < (world.maxx - 1) && src.y > 2 && src.y < (world.maxy-1)))
		var/mob/M = A
		if(M.Allow_Spacemove(1))
			M.inertia_dir  = 0
			return
		spawn(5)
			if((M && !(M.anchored) && !(M.pulledby) && (M.loc == src)))
				if(M.inertia_dir)
					step(M, M.inertia_dir)
					return
				M.inertia_dir = M.last_move
				step(M, M.inertia_dir)
	return

/turf/proc/levelupdate()
	for(var/obj/O in src)
		O.hide(O.hides_under_flooring() && !is_plating())

/turf/proc/AdjacentTurfs()
	var/L[] = new()
	for(var/turf/simulated/t in oview(src,1))
		if(!t.density)
			if(!LinkBlocked(src, t) && !TurfBlockedNonWindow(t))
				L.Add(t)
	return L

/turf/proc/CardinalTurfs()
	var/L[] = new()
	for(var/turf/simulated/T in AdjacentTurfs())
		if(T.x == src.x || T.y == src.y)
			L.Add(T)
	return L

/turf/proc/Distance(turf/t)
	if(get_dist(src,t) == 1)
		var/cost = (src.x - t.x) * (src.x - t.x) + (src.y - t.y) * (src.y - t.y)
		cost *= (pathweight+t.pathweight)/2
		return cost
	else
		return get_dist(src,t)

/turf/proc/AdjacentTurfsSpace()
	var/L[] = new()
	for(var/turf/t in oview(src,1))
		if(!t.density)
			if(!LinkBlocked(src, t) && !TurfBlockedNonWindow(t))
				L.Add(t)
	return L

/turf/process()
	STOP_PROCESSING(SSprocessing, src)

/turf/proc/contains_dense_objects()
	if(density)
		return 1
	for(var/atom/A in src)
		if(A.density && !(A.flags & ON_BORDER))
			return 1
	return 0

//expects an atom containing the reagents used to clean the turf
/turf/proc/clean(atom/source, mob/user)
	if(source.reagents.has_reagent(/decl/reagent/water, 1) || source.reagents.has_reagent(/decl/reagent/spacecleaner, 1))
		clean_blood()
		if(istype(src, /turf/simulated))
			var/turf/simulated/T = src
			T.dirt = 0
			T.color = null
		for(var/obj/effect/O in src)
			if(istype(O,/obj/effect/decal/cleanable) || istype(O,/obj/effect/overlay))
				qdel(O)
			if(istype(O,/obj/effect/rune))
				var/obj/effect/rune/R = O
				// Only show message for visible runes
				if(!R.invisibility)
					to_chat(user, SPAN_WARNING("No matter how well you wash, the bloody symbols remain!"))
	else
		if( !(last_clean && world.time < last_clean + 100) )
			to_chat(user, SPAN_WARNING("\The [source] is too dry to wash that."))
			last_clean = world.time
	source.reagents.trans_to_turf(src, 1, 10)	//10 is the multiplier for the reaction effect. probably needed to wet the floor properly.

/turf/proc/update_blood_overlays()
	return

/**
 * Will spawn a roof above the turf if it needs one.
 *
 * @param  flags The flags to assign to the turf which control roof spawning and
 * deletion by this turf. Refer to _defines/turfs.dm for a full list.
 *
 * @return TRUE if a roof has been spawned, FALSE if not.
 */
/turf/proc/spawn_roof(flags = 0)
	var/turf/above = GetAbove(src)
	if (!above)
		return FALSE

	if ((isopenturf(above) || (flags & ROOF_FORCE_SPAWN)) && get_roof_type() && above)
		above.ChangeTurf(get_roof_type())
		roof_flags |= flags
		return TRUE

	return FALSE

/**
 * Returns the roof type of the current turf
 */
/turf/proc/get_roof_type()
	return roof_type

/**
 * Cleans up the roof above a tile if there is one spawned and the ROOF_CLEANUP
 * flag is present on the source turf.
 */
/turf/proc/cleanup_roof()
	if (!HasAbove(z))
		return

	if (roof_flags & ROOF_CLEANUP)
		var/turf/above = GetAbove(src)
		if (!above || isopenturf(above))
			return

		above.ChangeToOpenturf()

/turf/proc/AdjacentTurfsRanged()
	var/static/list/allowed = typecacheof(list(
		/obj/structure/table,
		/obj/structure/closet,
		/obj/machinery/constructable_frame,
		/obj/structure/target_stake,
		/obj/structure/cable,
		/obj/structure/disposalpipe,
		/obj/machinery,
		/mob
	))

	var/L[] = new()
	for(var/turf/simulated/t in oview(src,1))
		var/add = 1
		if(t.density)
			add = 0
		if(add && LinkBlocked(src,t))
			add = 0
		if(add && TurfBlockedNonWindow(t))
			add = 0
			for(var/obj/O in t)
				if(!O.density)
					add = 1
					break
				if(istype(O, /obj/machinery/door))
					//not sure why this doesn't fire on LinkBlocked()
					add = 0
					break
				if(is_type_in_typecache(O, allowed))
					add = 1
					break
				if(!add)
					break
		if(add)
			L.Add(t)
	return L

// CRAWLING + MOVING STUFF
/turf/MouseDrop_T(atom/movable/O as mob|obj, mob/user as mob)
	var/turf/T = get_turf(user)
	var/area/A = T.loc
	if((istype(A) && !(A.has_gravity())) || (istype(T,/turf/space)))
		return
	if(istype(O, /obj/screen))
		return
	if(user.restrained() || user.stat || user.incapacitated(INCAPACITATION_KNOCKOUT) || !user.lying)
		return
	if((!(istype(O, /atom/movable)) || O.anchored || !Adjacent(user) || !Adjacent(O) || !user.Adjacent(O)))
		return
	if(!isturf(O.loc) || !isturf(user.loc))
		return
	if(isanimal(user) && O != user)
		return

	var/tally = 0

	if(ishuman(user))
		var/mob/living/carbon/human/H = user

		var/obj/item/organ/external/rhand = H.organs_by_name[BP_R_HAND]
		tally += limbCheck(rhand)

		var/obj/item/organ/external/lhand = H.organs_by_name[BP_L_HAND]
		tally += limbCheck(lhand)

		var/obj/item/organ/external/rfoot = H.organs_by_name[BP_R_FOOT]
		tally += limbCheck(rfoot)

		var/obj/item/organ/external/lfoot = H.organs_by_name[BP_L_FOOT]
		tally += limbCheck(lfoot)

	if(tally >= 120)
		to_chat(user, SPAN_NOTICE("You're too injured to do this!"))
		return

	var/finaltime = 25 + (5 * (user.weakened * 1.5))
	if(tally >= 45) // If you have this much missing, you'll crawl slower.
		finaltime += tally

	if(do_after(user, finaltime) && !user.stat)
		step_towards(O, src)

// Checks status of limb, returns an amount to
/turf/proc/limbCheck(var/obj/item/organ/external/limb)
	if(!limb) // Limb is null, thus missing. Add 3 seconds.
		return 30
	else if(!limb.is_usable() || limb.is_broken()) // You can't use the limb, but it's still there to manoevre yourself
		return 15
	else
		return 0

/turf/proc/generate_resources()
	resources = list()
	resources["silicates"] = rand(1, 3)
	resources["carbonaceous rock"] = rand(3,5)
	resources["uranium"] =  rand(0, 2)
	resources["diamond"] =  rand(0, 2)
	resources["iron"] =     rand(2, 4)
	resources["gold"] =     rand(0, 2)
	resources["silver"] =   rand(2, 4)
	if(prob(25))
		resources[MATERIAL_PHORON] =   rand(0, 2)
		resources["osmium"] =   rand(0, 2)
		resources["hydrogen"] = rand(0, 2)
	if(prob(50))
		resources["artifact"] = rand(1, 2)

/turf/proc/do_flooring(mob/user, var/obj/item/W)
	if(istype(W, /obj/item/stack/rods))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			return
		var/obj/item/stack/rods/R = W
		if(R.use(1))
			to_chat(user, SPAN_NOTICE("Constructing support lattice..."))
			playsound(src, 'sound/weapons/genhit.ogg', 50, 1)
			ReplaceWithLattice()
			can_dig = FALSE
		return

	if(istype(W, /obj/item/stack/tile/floor))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			var/obj/item/stack/tile/floor/S = W
			if(S.get_amount() < 1)
				return
			qdel(L)
			playsound(src, 'sound/weapons/genhit.ogg', 50, TRUE)
			S.use(1)
			ChangeTurf(/turf/simulated/floor/plating)
			can_dig = FALSE
			return
		else
			to_chat(user, SPAN_WARNING("The plating is going to need some support.")) //turf psychiatrist lmaooo
			return


/turf/proc/do_dig(mob/user, var/obj/item/W)
	if(!W || !user)
		return FALSE

	if(dug > 10)
		to_chat(user, SPAN_WARNING("You can't dig any deeper!"))
	else
		var/turf/T = get_turf(user)
		var/oldtype = type
		if(!istype(T))
			return
		if(digging)
			return
		if(dug)
			if(!covered_hole)
				to_chat(user, SPAN_NOTICE("You start digging deeper."))
			playsound(get_turf(user), 'sound/effects/stonedoor_openclose.ogg', 50, TRUE)
			digging = TRUE
			if(!do_after(user, 60 / W.toolspeed))
				digging = FALSE
				return

			// Turfs are special. They don't delete. So we need to check if it's
			// still the same turf as before the sleep.
			if(!istype(src, oldtype) && !istype(src, baseturf))
				digging = FALSE
				return

			if(covered_hole)
				to_chat(user, SPAN_NOTICE("The soil was loose. Looks like a hole was already made, then covered up!"))
				covered_hole = FALSE
				digging = FALSE
				hole_overlay = image('icons/turf/overlays.dmi', "dug", TURF_LAYER + 0.1)
				add_overlay(hole_overlay, TRUE)
				verbs += /turf/proc/fill_dirt
				return

			playsound(get_turf(user), 'sound/effects/stonedoor_openclose.ogg', 50, TRUE)
			if(prob(33))
				switch(dug)
					if(1)
						to_chat(user, SPAN_NOTICE("You've made a little progress."))
					if(2)
						to_chat(user, SPAN_NOTICE("You notice the hole is a little deeper."))
					if(3)
						to_chat(user, SPAN_NOTICE("You think you're making good progress."))
					if(4)
						to_chat(user, SPAN_NOTICE("You finish up lifting another pile of dirt."))
					if(5)
						to_chat(user, SPAN_NOTICE("You dig a bit deeper. You could fit your whole body in."))
					if(6)
						to_chat(user, SPAN_NOTICE("It's getting harder to make progress..."))
					if(7)
						to_chat(user, SPAN_NOTICE("The hole looks pretty deep now."))
					if(8)
						to_chat(user, SPAN_NOTICE("The dirt is starting to feel a lot looser."))
					if(9)
						to_chat(user, SPAN_NOTICE("You've dug a really deep hole."))
					if(10)
						to_chat(user, SPAN_NOTICE("Just a little deeper..."))
					else
						to_chat(user, SPAN_NOTICE("You hit bedrock! You can't go any deeper."))
			else
				if(dug <= 10)
					to_chat(user, SPAN_NOTICE("You dig a little deeper."))
				else
					to_chat(user, SPAN_NOTICE("You dug a big hole. Congratulations.")) // how ceremonious

			gets_dug(user)
			digging = FALSE
			return

		to_chat(user, SPAN_WARNING("You start digging."))
		playsound(get_turf(user), 'sound/effects/stonedoor_openclose.ogg', 50, TRUE)

		digging = TRUE
		if(!do_after(user, 40))
			digging = FALSE
			return

		// Turfs are special. They don't delete. So we need to check if it's
		// still the same turf as before the sleep.
		if(!istype(src, oldtype) && !istype(src, baseturf))
			digging = FALSE
			return

		to_chat(user, SPAN_NOTICE("You dug a hole."))
		digging = FALSE
		verbs += /turf/proc/fill_dirt

		gets_dug(user)
		return

/turf/proc/gets_dug(mob/user)
	for(var/obj/structure/flora/grass/G in contents)
		qdel(G)
	if(prob(50))
		new /obj/item/ore/dirt(src)
	if(prob(25) && has_resources)
		var/list/ore = list()
		for(var/metal in resources)
			switch(metal)
				if("silicates")
					ore += /obj/item/ore/glass
				if("carbonaceous rock")
					ore += /obj/item/ore/coal
				if("iron")
					ore += /obj/item/ore/iron
				if("gold")
					ore += /obj/item/ore/gold
				if("silver")
					ore += /obj/item/ore/silver
				if("diamond")
					ore += /obj/item/ore/diamond
				if("uranium")
					ore += /obj/item/ore/uranium
				if("phoron")
					ore += /obj/item/ore/phoron
				if("osmium")
					ore += /obj/item/ore/osmium
				if("hydrogen")
					ore += /obj/item/ore/hydrogen
				if("artifact")
					if(prob(25))
						switch(rand(1,5))
							if(1)
								ore += pick(subtypesof(/obj/effect/decal/remains))
							if(2)
								ore += /obj/item/rocksliver
							if(3)
								ore += /obj/item/fossil
							if(4)
								ore += /obj/item/archaeological_find
							if(5)
								ore += /obj/random/seed
					else
						ore += /obj/item/ore/glass
		if(length(ore))
			var/ore_path = pick(ore)
			if(ore)
				new ore_path(src)

	if(dug <= 10)
		dug += 1
		hole_overlay = image('icons/turf/overlays.dmi', "dug", TURF_LAYER + 0.1)
		add_overlay(hole_overlay, TRUE)

/turf/proc/fill_dirt()
	set name = "Fill Hole"
	set desc = "OwO"
	set src in view(1)

	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/H = usr
	if(!(istype(H.l_hand, /obj/item/shovel) || istype(H.r_hand, /obj/item/shovel)))
		to_chat(usr, SPAN_NOTICE("How do you expect to fill a hole without a shovel?"))
		return
	if(digging)
		to_chat(H, "Someone is already digging or filling that hole.")
		return
	H.visible_message(SPAN_NOTICE("[H] starts filling the hole in the ground."), SPAN_NOTICE("You start filling the hole in the ground."))
	digging = TRUE
	if(do_after(H, dug*10))
		H.visible_message(SPAN_NOTICE("[H] fills the hole in the ground."), SPAN_NOTICE("You fill the hole in the ground."))
		cut_overlay(hole_overlay, TRUE)
		covered_hole = TRUE
		verbs -= /turf/proc/fill_dirt
	digging = FALSE

/turf/examine(mob/user)
	if(..(user, 2) && dug)
		var/dug_text = "There's a hole dug here. "
		if(!covered_hole)
			switch(dug)
				if(1 to 2)
					dug_text += "It seems shallow."
				if(3 to 4)
					dug_text += "It's moderately deep."
				if(5 to 7)
					dug_text += "It's pretty deep!"
				else
					dug_text += "It's extremely deep. You might not get out if you fall in!"
			to_chat(user, SPAN_NOTICE(dug_text))
		else
			to_chat(user, SPAN_NOTICE("It looks like the surface was disturbed."))