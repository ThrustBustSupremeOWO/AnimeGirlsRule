//-// Salvaging Barge //-//
/datum/shuttle/autodock/multi/barge
	name = "Salvaging Barge"
	current_location = "nav_barge_start"
	warmup_time = 10
	shuttle_area = /area/shuttle/barge
	dock_target = "Salvaging Barge"
	destination_tags = list(
		"nav_barge_start",
		"nav_barge_1",
		"nav_barge_2",
		"nav_barge_3",
		"nav_barge_4"
		)

/obj/effect/shuttle_landmark/barge/start
	name = "Home Base - The Spire"
	landmark_tag = "nav_barge_start"
	base_turf = /turf/unsimulated/floor/plating
	base_area = /area/centcom

/obj/effect/shuttle_landmark/barge/one
	name = "Sector 1 - Scrapwaves"
	landmark_tag = "nav_barge_1"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/barge/two
	name = "Sector 2 - Bay of Shards"
	landmark_tag = "nav_barge_2"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/barge/three
	name = "Sector 3 - Derelict Sands"
	landmark_tag = "nav_barge_3"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/barge/four
	name = "Sector 4 - Anvil's Mine"
	landmark_tag = "nav_barge_4"
	landmark_flags = SLANDMARK_FLAG_AUTOSET
