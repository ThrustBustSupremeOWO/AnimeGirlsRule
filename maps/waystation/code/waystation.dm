/datum/map/runtime
	name = "Runtime Station"
	full_name = "Runtime Debugging Station"
	path = "runtime"
	lobby_icons = list('icons/misc/titlescreens/runtime/developers.dmi')
	lobby_transitions = 10 SECONDS

	station_levels = list(1)
	admin_levels = list()
	contact_levels = list(1)
	player_levels = list(1)
	accessible_z_levels = list(1)

	station_name = "COC Waystation"
	station_short = "Waystation"
	dock_name = "waystation"
	boss_name = "Coalition of Colonies"
	boss_short = "COC"
	company_name = "Coalition of Colonies"
	company_short = "COC"
	system_name = "waystation"

	station_networks = list(
		NETWORK_CIVILIAN_MAIN,
		NETWORK_COMMAND,
		NETWORK_ENGINEERING,
	)
