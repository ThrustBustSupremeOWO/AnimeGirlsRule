/mob/living/heavy_vehicle/apply_effect(var/effect = 0,var/effecttype = STUN, var/blocked = 0)

	if(!effect || (blocked >= 100))
		return 0

	if(LAZYLEN(pilots) && (!hatch_closed || !prob(body.pilot_coverage)))
		if(effect > 0 && effecttype == IRRADIATE)
			var/mob/living/pilot = pick(pilots)
			return pilot.apply_effect(effect, effecttype, blocked)
	if(effecttype in list(PAIN, STUTTER, EYE_BLUR, DROWSY, STUN, WEAKEN))
		. = ..()

/mob/living/heavy_vehicle/proc/attacked_by(var/obj/item/I, var/mob/living/user, var/def_zone)

	if(!I.force)
		user.visible_message("<span class='notice'>\The [user] bonks \the [src] harmlessly with \the [I].</span>")
		return

	if(LAZYLEN(pilots) && (!hatch_closed || !prob(body.pilot_coverage)))
		var/mob/living/pilot = pick(pilots)
		return pilot.resolve_item_attack(I, user, def_zone)

	return def_zone

/mob/living/heavy_vehicle/hitby(atom/movable/AM, speed)
	if(LAZYLEN(pilots) && (!hatch_closed || !prob(body.pilot_coverage)))
		var/mob/living/pilot = pick(pilots)
		return pilot.hitby(AM, speed)
	. = ..()

/mob/living/heavy_vehicle/getarmor(var/def_zone, var/type)
	if(body && body.mech_armor)
		return isnull(body.mech_armor.armor[type]) ? 0 : body.mech_armor.armor[type]
	return 0

/mob/living/heavy_vehicle/updatehealth()
	maxHealth = body.mech_health
	health = maxHealth-(getFireLoss()+getBruteLoss())

/mob/living/heavy_vehicle/adjustFireLoss(var/amount, var/obj/item/mech_component/C)
	if(C)
		C.take_brute_damage(amount)
		C.update_health()
	else
		var/list/components = list(body, arms, legs, head)
		components = shuffle(components)
		for(var/obj/item/mech_component/MC in components)
			MC.take_burn_damage(amount)
			MC.update_health()
			break

/mob/living/heavy_vehicle/adjustBruteLoss(var/amount, var/obj/item/mech_component/C)
	if(C)
		C.take_brute_damage(amount)
		C.update_health()
	else
		var/list/components = list(body, arms, legs, head)
		components = shuffle(components)
		for(var/obj/item/mech_component/MC in components)
			MC.take_burn_damage(amount)
			MC.update_health()
			break

/mob/living/heavy_vehicle/proc/zoneToComponent(var/zone)
	switch(zone)
		if(BP_EYES, BP_HEAD)
			return head
		if(BP_L_ARM, BP_R_ARM)
			return arms
		if(BP_L_LEG, BP_R_LEG)
			return legs
		else
			return body

/mob/living/heavy_vehicle/apply_damage(var/damage = 0,var/damagetype = BRUTE, var/def_zone = null, var/blocked = 0, var/used_weapon = null, var/damage_flags)
	if(!damage)
		return 0

	var/target = zoneToComponent(def_zone)
	//Only 2 types of damage concern mechs and vehicles
	switch(damagetype)
		if(BRUTE)
			adjustBruteLoss(damage * BLOCKED_MULT(blocked), target)
		if(BURN)
			adjustFireLoss(damage * BLOCKED_MULT(blocked), target)

	if((damagetype == BRUTE || damagetype == BURN) && prob(25+(damage*2)))
		spark(src, 3)
	updatehealth()

	return 1

/mob/living/heavy_vehicle/getFireLoss()
	var/total = 0
	for(var/obj/item/mech_component/MC in list(arms, legs, body, head))
		if(MC)
			total += MC.burn_damage
	return total

/mob/living/heavy_vehicle/getBruteLoss()
	var/total = 0
	for(var/obj/item/mech_component/MC in list(arms, legs, body, head))
		if(MC)
			total += MC.brute_damage
	return total

/mob/living/heavy_vehicle/emp_act(var/severity)
	if(severity <= 3)
		for(var/obj/item/thing in list(arms,legs,head,body))
			thing.emp_act(severity)
		if(!hatch_closed || !prob(body.pilot_coverage))
			for(var/thing in pilots)
				var/mob/pilot = thing
				pilot.emp_act(severity)

/mob/living/heavy_vehicle/fall_impact(levels_fallen, stopped_early = FALSE, var/damage_mod = 1)
	// No gravity, stop falling into spess!
	var/area/area = get_area(src)
	if(isspace(loc) || (area && !area.has_gravity()))
		return FALSE

	visible_message(SPAN_DANGER("\The [src] falls and lands on \the [loc]!"), "", SPAN_DANGER("You hear a thud!"))

	var/z_velocity = 5 * (levels_fallen**2) // 1z - 5, 2z - 20, 3z - 45
	var/damage = max((z_velocity + rand(-10, 10)) * damage_mod, 0)

	apply_damage(damage, BRUTE, BP_L_LEG) // can target any leg, it will be changed to the proper component

	playsound(loc, "sound/effects/bang.ogg", 100, 1)
	playsound(loc, "sound/effects/bamf.ogg", 100, 1)
	return TRUE
