/datum/map/aurora
	name = "Spire"
	full_name = "Spire Salvaging Outpost"
	path = "mars"

	lobby_icons = list('icons/misc/titlescreens/mars/metaldunes.dmi')
	lobby_transitions = 10 SECONDS


	station_levels = list(2, 3, 4, 5)
	admin_levels = list(1)
	contact_levels = list(2, 3, 4, 5)
	player_levels = list(2, 3, 4, 5)
	restricted_levels = list()
	accessible_z_levels = list("8" = 10, "7" = 15, "2" = 60)
	base_turf_by_z = list(
		"1" = /turf/space,
		"2" = /turf/simulated/floor/mars,
		"3" = /turf/simulated/floor/mars,
		"4" = /turf/simulated/floor/mars,
	)

	station_name = "ASN Spire"
	station_short = "Spire"
	dock_name = "Placeholder"
	dock_short = "Placeholder"
	boss_name = "Central Command"
	boss_short = "CentCom"
	company_name = "NanoTrasen"
	company_short = "NT"
	system_name = "Tau Ceti"

	command_spawn_enabled = TRUE
	command_spawn_message = "Welcome to the Odin! Simply proceed down and to the right to board the shuttle to your workplace!"

	station_networks = list(
		NETWORK_CIVILIAN_MAIN,
		NETWORK_CIVILIAN_SURFACE,
		NETWORK_COMMAND,
		NETWORK_ENGINE,
		NETWORK_ENGINEERING,
		NETWORK_ENGINEERING_OUTPOST,
		NETWORK_STATION,
		NETWORK_MEDICAL,
		NETWORK_MINE,
		NETWORK_RESEARCH,
		NETWORK_RESEARCH_OUTPOST,
		NETWORK_ROBOTS,
		NETWORK_PRISON,
		NETWORK_SECURITY,
		NETWORK_SERVICE,
		NETWORK_SUPPLY
	)

	shuttle_docked_message = "The scheduled crew transfer shuttle to %dock% has docked with the station. It will depart in approximately %ETA% minutes."
	shuttle_leaving_dock = "The crew transfer shuttle has left the station. Estimate %ETA% minutes until the shuttle docks at %dock%."
	shuttle_called_message = "A crew transfer to %dock% has been scheduled. The shuttle has been called. It will arrive in approximately %ETA% minutes."
	shuttle_recall_message = "The scheduled crew transfer has been cancelled."
	emergency_shuttle_docked_message = "The emergency shuttle has docked with the station. You have approximately %ETD% minutes to board the emergency shuttle."
	emergency_shuttle_leaving_dock = "The emergency shuttle has left the station. Estimate %ETA% minutes until the shuttle docks at %dock%."
	emergency_shuttle_recall_message = "The emergency shuttle has been recalled."
	emergency_shuttle_called_message = "An emergency evacuation shuttle has been called. It will arrive in approximately %ETA% minutes."

	map_shuttles = list(
		/datum/shuttle/autodock/ferry/escape_pod/pod/escape_pod1,
		/datum/shuttle/autodock/ferry/escape_pod/pod/escape_pod2,
		/datum/shuttle/autodock/ferry/escape_pod/pod/escape_pod3,
		/datum/shuttle/autodock/ferry/emergency/aurora,
		/datum/shuttle/autodock/ferry/arrival/aurora,
		/datum/shuttle/autodock/ferry/supply/aurora,
		/datum/shuttle/autodock/ferry/merchant_aurora,
		/datum/shuttle/autodock/multi/admin,
		/datum/shuttle/autodock/ferry/autoreturn/ccia,
		/datum/shuttle/autodock/ferry/specops/ert_aurora,
		/datum/shuttle/autodock/multi/antag/skipjack_aurora,
		/datum/shuttle/autodock/multi/antag/burglar_aurora,
		/datum/shuttle/autodock/multi/antag/merc_aurora,
		/datum/shuttle/autodock/multi/legion,
		/datum/shuttle/autodock/ferry/research_aurora,
		/datum/shuttle/autodock/multi/distress,
		/datum/shuttle/autodock/multi/merc_aurora_elite,
		/datum/shuttle/autodock/multi/barge
	)

/datum/map/aurora/generate_asteroid()
	// Create the chasms.
	new /datum/random_map/automata/cave_system/chasms(null,0,0,3,255,255)
	new /datum/random_map/automata/cave_system(null,0,0,3,255,255)
	new /datum/random_map/automata/cave_system/chasms(null,0,0,4,255,255)
	new /datum/random_map/automata/cave_system(null,0,0,4,255,255)
	new /datum/random_map/automata/cave_system/chasms(null,0,0,5,255,255)
	new /datum/random_map/automata/cave_system/high_yield(null,0,0,5,255,255)
	new /datum/random_map/automata/cave_system/chasms/surface(null,0,0,6,255,255)

	// Create the deep mining ore distribution map.
	new /datum/random_map/noise/ore(null, 0, 0, 5, 64, 64)
	new /datum/random_map/noise/ore(null, 0, 0, 4, 64, 64)
	new /datum/random_map/noise/ore(null, 0, 0, 3, 64, 64)

/datum/map/aurora/finalize_load()
	// generate an empty space Z
	world.maxz++
