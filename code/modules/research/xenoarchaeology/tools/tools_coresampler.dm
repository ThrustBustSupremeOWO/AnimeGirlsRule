//device to take core samples from mineral turfs - used for various types of analysis

/obj/item/storage/box/samplebags
	name = "sample bag box"
	desc = "A box claiming to contain sample bags."
	New()
		for(var/i=0, i<7, i++)
			var/obj/item/evidencebag/S = new(src)
			S.name = "sample bag"
			S.desc = "a bag for holding research samples."
		..()
		return

//////////////////////////////////////////////////////////////////

/obj/item/device/core_sampler
	name = "core sampler"
	desc = "Used to extract geological core samples."
	icon = 'icons/obj/device.dmi'
	icon_state = "sampler0"
	item_state = "screwdriver_brown"
	w_class = ITEMSIZE_TINY
	//slot_flags = SLOT_BELT
	var/sampled_turf = ""
	var/num_stored_bags = 10
	var/obj/item/evidencebag/filled_bag

/obj/item/device/core_sampler/examine(mob/user)
	if(..(user, 2))
		to_chat(user, "<span class='notice'>Used to extract geological core samples - this one is [sampled_turf ? "full" : "empty"], and has [num_stored_bags] bag[num_stored_bags != 1 ? "s" : ""] remaining.</span>")

/obj/item/device/core_sampler/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/evidencebag))
		if(num_stored_bags < 10)
			qdel(W)
			num_stored_bags += 1
			to_chat(user, "<span class='notice'>You insert the [W] into the core sampler.</span>")
		else
			to_chat(user, "<span class='warning'>The core sampler can not fit any more bags!</span>")
	else
		return ..()

/obj/item/device/core_sampler/proc/sample_item(var/item_to_sample, var/mob/user as mob)
	var/datum/geosample/geo_data
	if(istype(item_to_sample, /turf/simulated/mineral))
		var/turf/simulated/mineral/T = item_to_sample
		T.geologic_data.UpdateNearbyArtifactInfo(T)
		geo_data = T.geologic_data
	else if(istype(item_to_sample, /obj/item/ore))
		var/obj/item/ore/O = item_to_sample
		geo_data = O.geologic_data

	if(geo_data)
		if(filled_bag)
			to_chat(user, "<span class='warning'>The core sampler is full!</span>")
		else if(num_stored_bags < 1)
			to_chat(user, "<span class='warning'>The core sampler is out of sample bags!</span>")
		else
			//create a new sample bag which we'll fill with rock samples
			filled_bag = new /obj/item/evidencebag(src)
			filled_bag.name = "sample bag"
			filled_bag.desc = "a bag for holding research samples."

			icon_state = "sampler1"
			num_stored_bags--

			//put in a rock sliver
			var/obj/item/rocksliver/R = new()
			R.geological_data = geo_data
			R.forceMove(filled_bag)

			//update the sample bag
			filled_bag.icon_state = "evidence"
			var/image/I = image("icon"=R, "layer"=FLOAT_LAYER)
			filled_bag.add_overlay(I)
			filled_bag.add_overlay("evidence")
			filled_bag.w_class = ITEMSIZE_TINY
			filled_bag.stored_item = R

			to_chat(user, "<span class='notice'>You take a core sample of the [item_to_sample].</span>")
	else
		to_chat(user, "<span class='warning'>You are unable to take a sample of [item_to_sample].</span>")

/obj/item/device/core_sampler/attack_self()
	if(filled_bag)
		to_chat(usr, "<span class='notice'>You eject the full sample bag.</span>")
		var/success = 0
		if(istype(src.loc, /mob))
			var/mob/M = src.loc
			success = M.put_in_inactive_hand(filled_bag)
		if(!success)
			filled_bag.forceMove(get_turf(src))
		filled_bag = null
		icon_state = "sampler0"
	else
		to_chat(usr, "<span class='warning'>The core sampler is empty.</span>")

/obj/item/device/sample_scanner
	name = "sample analyzer"
	desc = "A tool that acts as a mobile laboratory. It can analyze rock slivers taken by a core sampler. It's not always the most reliable, but gives a general sense for field work."
	desc_info = "Rock slivers must be in a sample bag to be analyzed. Alt+Click to remove the sample bag."
	icon = 'icons/obj/device.dmi'
	icon_state = "geosample_anal"
	item_state = "screwdriver_brown"
	w_class = ITEMSIZE_SMALL
	var/obj/item/evidencebag/current_sample
	var/report_num
	var/datum/geosample/last_loaded_data //Remembers 1 analysis

/obj/item/device/sample_scanner/Destroy()
	if(current_sample)
		QDEL_NULL(current_sample)
	. = ..()

/obj/item/device/sample_scanner/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/evidencebag))
		if(current_sample)
			to_chat(user, SPAN_WARNING("There's already a loaded sample!"))
			return
		var/obj/item/evidencebag/E = I
		if(!E.stored_item)
			to_chat(user, SPAN_WARNING("There's no sample to analyze!"))
			return
		if(!istype(E.stored_item, /obj/item/rocksliver))
			to_chat(user, SPAN_WARNING("\The [src] can't analyze [E.stored_item]! It only accepts samples taken by a core sampler!"))
			return
		to_chat(user, SPAN_NOTICE("You insert the sample."))
		user.drop_from_inventory(E, src)
		current_sample = E
		return
	..()

/obj/item/device/sample_scanner/AltClick(mob/user)
	if(current_sample)
		to_chat(user, SPAN_NOTICE("You eject the sample."))
		current_sample.forceMove(get_turf(src))
		user.put_in_hands(current_sample)
		current_sample = null
		return
	else
		to_chat(user, SPAN_NOTICE("There's no sample to eject."))

/obj/item/device/sample_scanner/attack_self(mob/user)
	if(current_sample)
		var/obj/item/rocksliver/R = current_sample.stored_item
		if(R)
			var/turf/T = get_turf(src)
			T.visible_message(SPAN_NOTICE("\The [src] hums and beeps as it begins to analyze the sample."))
			addtimer(CALLBACK(src, .proc/print_analysis, R.geological_data, user), 5 SECONDS)
	else
		if(last_loaded_data)
			to_chat(user, SPAN_NOTICE("No sample loaded. Printing last known sample data."))
			print_analysis(last_loaded_data, user)
		else
			to_chat(user, SPAN_WARNING("There's no sample to analyze!"))

/obj/item/device/sample_scanner/proc/print_analysis(var/datum/geosample/G, mob/user)
	if(G)
		//create report
		var/obj/item/paper/P = new(src)
		report_num++
		P.name = "Sample Analysis Report #0[report_num]: [G.source_mineral]"
		P.stamped = list(/obj/item/stamp)
		P.overlays = list("paper_stamped")

		//work out data
		var/data
		data = "Spectometric analysis on mineral sample has determined type: [(G.source_mineral)]<br>"
		if(G.age_billion > 0)
			data += " - Radiometric dating shows age of [G.age_billion].[G.age_million] billion years<br>"
		else if(G.age_million > 0)
			data += " - Radiometric dating shows age of [G.age_million].[G.age_thousand] million years<br>"
		else if(G.age_thousand > 0)
			data += " - Radiometric dating shows age of [G.age_thousand * 1000 + G.age] years<br>"

		if(length(G.sample_data))
			for(var/D in G.sample_data)
				data += "[D]<br>"

		P.info = "<b><u>Sample Analysis - Report #0[report_num]</u></b><br>"
		P.info += "<b>Scanned item:</b> [G.source_mineral]<br><br>" + data
		last_loaded_data = G
		var/turf/T = get_turf(src)
		T.visible_message(SPAN_NOTICE("\The [src] dings and spits out a report!"))
		playsound(T, 'sound/machines/ping.ogg')
		playsound(T, 'sound/items/polaroid1.ogg')
		P.forceMove(T)
		if(!isturf(loc))
			if(loc == user)
				user.put_in_hands(P)
			else
				P.forceMove(loc)