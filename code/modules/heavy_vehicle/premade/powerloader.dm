/mob/living/heavy_vehicle/premade/ripley
	name = "power loader"
	desc = "An ancient but well-liked cargo handling exosuit."

	e_head = /obj/item/mech_component/sensors/ripley
	e_body = /obj/item/mech_component/chassis/ripley
	e_arms = /obj/item/mech_component/manipulators/ripley
	e_legs = /obj/item/mech_component/propulsion/ripley
	e_color = COLOR_RIPLEY

	h_l_hand = /obj/item/mecha_equipment/drill
	h_r_hand = /obj/item/mecha_equipment/clamp

/mob/living/heavy_vehicle/premade/ripley/Initialize()
	. = ..()
	body.armor = new /obj/item/robot_parts/robot_component/armor/mech(src)

/mob/living/heavy_vehicle/premade/ripley/cargo
	h_back = /obj/item/mecha_equipment/autolathe

/mob/living/heavy_vehicle/premade/ripley/janitorial
	name = "janitorial power loader"
	desc = "A standard cargo-handling power loader converted into a cleaning machine."

	e_color = COLOR_PURPLE
	h_l_hand = /obj/item/mecha_equipment/clamp
	h_l_shoulder = /obj/item/mecha_equipment/mounted_system/grenadecleaner
	h_r_shoulder = /obj/item/mecha_equipment/mounted_system/grenadecleaner
	h_back = /obj/item/mecha_equipment/quick_enter

/obj/item/mech_component/manipulators/ripley
	name = "exosuit arms"
	exosuit_desc_string = "heavy-duty industrial lifters"
	max_damage = 150
	power_use = 2000
	melee_damage = 40
	desc = "The Xion Manufacturing Group Digital Interaction Manifolds allow you poke untold dangers from the relative safety of your cockpit."
	punch_sound = 'sound/mecha/mech_punch_slow.ogg'

/obj/item/mech_component/propulsion/ripley
	name = "exosuit legs"
	exosuit_desc_string = "reinforced hydraulic legs"
	desc = "Wide and stable but not particularly fast."
	max_damage = 150
	move_delay = 4
	turn_delay = 4
	power_use = 2000
	trample_damage = 10

/obj/item/mech_component/sensors/ripley
	name = "exosuit sensors"
	gender = PLURAL
	exosuit_desc_string = "simple collision detection sensors"
	desc = "A primitive set of sensors designed to work in tandem with most MKI Eyeball platforms."
	max_damage = 200
	power_use = 0

/obj/item/mech_component/sensors/ripley/prebuild()
	..()
	software = new(src)
	software.installed_software = list(MECH_SOFTWARE_UTILITY, MECH_SOFTWARE_WEAPONS)

/obj/item/mech_component/chassis/ripley
	name = "open exosuit chassis"
	hatch_descriptor = "roll cage"
	pilot_coverage = 40
	exosuit_desc_string = "an industrial rollcage"
	desc = "A Xion industrial brand roll cage. Technically OSHA compliant. Technically. This variant has an extra compartment for a copilot, but has no sealed atmosphere."
	max_damage = 200
	power_use = 5000
//Packmule
/obj/item/mech_component/manipulators/ripley/packmule
	name = "commercial lifter hydraulic manifolds"
	exosuit_desc_string = "heavy-duty industrial lifters"
	max_damage = 75
	power_use = 500
	melee_damage = 40
	icon_state = "packmule_arms"
	desc = "A Hephaestus generic interaction manifold which proves difficult to actually maneuver. Very light."
	punch_sound = 'sound/mecha/mech_punch_slow.ogg'
	has_hardpoints = list(HARDPOINT_LEFT_SHOULDER, HARDPOINT_RIGHT_SHOULDER, HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)

/obj/item/mech_component/propulsion/ripley/packmule
	name = "commercial lifter legs"
	exosuit_desc_string = "reinforced hydraulic legs"
	desc = "Thin, widely actuating legs with flexible range of motion. Perfect for small lifting duties."
	icon_state = "packmule_legs"
	max_damage = 150
	move_delay = 3
	turn_delay = 4
	power_use = 500
	trample_damage = 60

/obj/item/mech_component/sensors/ripley/packmule
	name = "commercial lifter chassis"
	gender = PLURAL
	icon_state = "packmule_head"
	exosuit_desc_string = "simple collision detection sensors"
	desc = "A simplistic set of sensors providing multi-angle coverage, at least the optics can pivot."
	max_damage = 200
	power_use = 0

/obj/item/mech_component/chassis/ripley/packmule
	name = "commercial lifter chassis"
	hatch_descriptor = "roll cage"
	pilot_coverage = 100
	icon_state = "packmule_body"
	exosuit_desc_string = "an industrial compartment"
	desc = "An industrial lifter chassis with refined power cores and improved air conditioning, definitely a step up from your usual APLU."
	max_damage = 200
	power_use = 1500

/obj/item/mech_component/chassis/ripley/prebuild()
	. = ..()
	armor = new /obj/item/robot_parts/robot_component/armor/mech(src)

/mob/living/heavy_vehicle/premade/ripley/ripley/packmule
	name = "Packmule"
	desc = "A Hephaestus commercial lifter usually granted to Coalition expedition forces for, confusingly enough, lifting purposes. Also xenofauna."
	icon_state = "durand"

	e_head = /obj/item/mech_component/sensors/ripley/packmule
	e_body = /obj/item/mech_component/chassis/ripley/packmule
	e_arms = /obj/item/mech_component/manipulators/ripley/packmule
	e_legs = /obj/item/mech_component/propulsion/ripley/packmule
	e_color = COLOR_RIPLEY

	h_r_shoulder = /obj/item/mecha_equipment/mounted_system/combat/smg
	h_l_shoulder = /obj/item/mecha_equipment/mounted_system/combat/smg
	h_back = /obj/item/mecha_equipment/shield
	h_r_hand = /obj/item/mecha_equipment/clamp
	h_l_hand = /obj/item/mecha_equipment/clamp
	h_head = /obj/item/mecha_equipment/light

/obj/item/mech_component/chassis/ripley/Initialize()
	pilot_positions = list(
		list(
			"[NORTH]" = list("x" = 8,  "y" = 8),
			"[SOUTH]" = list("x" = 8,  "y" = 8),
			"[EAST]"  = list("x" = 8,  "y" = 8),
			"[WEST]"  = list("x" = 8,  "y" = 8)
		),
		list(
			"[NORTH]" = list("x" = 8,  "y" = 16),
			"[SOUTH]" = list("x" = 8,  "y" = 16),
			"[EAST]"  = list("x" = 0,  "y" = 16),
			"[WEST]"  = list("x" = 16, "y" = 16)
		)
	)
	. = ..()

/mob/living/heavy_vehicle/premade/ripley/flames_red
	name = "APLU \"Firestarter\""
	desc = "An ancient but well-liked cargo handling exosuit. This one has cool red flames."
	icon_state = "ripley_flames_red"
	decal = "flames_red"

/mob/living/heavy_vehicle/premade/ripley/flames_blue
	name = "APLU \"Burning Chrome\""
	desc = "An ancient but well-liked cargo handling exosuit. This one has cool blue flames."
	icon_state = "ripley_flames_blue"
	decal = "flames_blue"

/mob/living/heavy_vehicle/premade/firefighter
	name = "firefighting exosuit"
	desc = "A mix and match of industrial parts designed to withstand fires."
	icon_state = "firefighter"

	e_head = /obj/item/mech_component/sensors/ripley
	e_body = /obj/item/mech_component/chassis/ripley
	e_arms = /obj/item/mech_component/manipulators/ripley
	e_legs = /obj/item/mech_component/propulsion/ripley
	e_color = "#385b3c"

	h_l_hand = /obj/item/mecha_equipment/drill
	h_r_hand = /obj/item/mecha_equipment/mounted_system/extinguisher

/mob/living/heavy_vehicle/premade/firefighter/Initialize()
	. = ..()
	material = SSmaterials.get_material_by_name(MATERIAL_PLASTEEL)

/obj/item/mech_component/sensors/firefighter/prebuild()
	..()
	software = new(src)
	software.installed_software = list(MECH_SOFTWARE_UTILITY, MECH_SOFTWARE_ENGINEERING)

/mob/living/heavy_vehicle/premade/combatripley
	name = "combat APLU \"Ripley\""
	desc = "A large APLU unit fitted with specialized composite armor and fancy, though old targeting systems."
	icon_state = "combatripley"
	decal = "ripley_legion"

	e_head = /obj/item/mech_component/sensors/combatripley
	e_body = /obj/item/mech_component/chassis/ripley
	e_arms = /obj/item/mech_component/manipulators/ripley
	e_legs = /obj/item/mech_component/propulsion/ripley
	e_color = COLOR_TCFL

	h_l_shoulder = /obj/item/mecha_equipment/mounted_system/combat/grenadesmoke
	h_r_shoulder = /obj/item/mecha_equipment/mounted_system/flarelauncher
	h_l_hand = /obj/item/mecha_equipment/mounted_system/combat/blaster
	h_r_hand = /obj/item/mecha_equipment/mounted_system/combat/gauss

/mob/living/heavy_vehicle/premade/combatripley/Initialize()
	. = ..()
	body.mech_armor = new /obj/item/robot_parts/robot_component/armor/mech/combat(src)

/obj/item/mech_component/sensors/combatripley
	name = "exosuit sensors"
	gender = PLURAL
	power_use = 50000
	vision_flags = SEE_MOBS
	see_invisible = SEE_INVISIBLE_NOLIGHTING

/obj/item/mech_component/sensors/combatripley/prebuild()
	..()
	software = new(src)
	software.installed_software = list(MECH_SOFTWARE_UTILITY, MECH_SOFTWARE_WEAPONS)

/mob/living/heavy_vehicle/premade/ripley/remote
	name = "remote power loader"
	dummy_colour = "#ffc44f"
	remote_network = REMOTE_GENERIC_MECH
	does_hardpoint_lock = FALSE

/mob/living/heavy_vehicle/premade/ripley/remote_prison
	name = "penal power loader"
	dummy_colour = "#302e2b"
	remote_network = REMOTE_PRISON_MECH

/mob/living/heavy_vehicle/premade/ripley/remote_ai
	name = "stationbound power loader"
	e_color = COLOR_GREEN_GRAY
	dummy_colour = COLOR_GREEN_GRAY
	dummy_type = /mob/living/simple_animal/spiderbot/ai
	remote_network = REMOTE_AI_MECH
	does_hardpoint_lock = FALSE

	h_l_hand = /obj/item/mecha_equipment/toolset