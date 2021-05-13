//-// Salvaging Barge //-//
/datum/shuttle/autodock/multi/barge
	name = "Survey Barge"
	current_location = "nav_barge_start"
	warmup_time = 10
	shuttle_area = /area/shuttle/barge
	dock_target = "Survey Barge"
	destination_tags = list(
		"nav_barge_start",
		"nav_barge_1",
		"nav_barge_2",
		"nav_barge_3",
		"nav_barge_4",
		"nav_barge_5"
		)

/obj/effect/shuttle_landmark/barge/start
	name = "Home Base - Overwatch - Orbit"
	landmark_tag = "nav_barge_start"
	base_turf = /turf/unsimulated/floor/plating
	base_area = /area/centcom

/obj/effect/shuttle_landmark/barge/one
	name = "Moon 1 Sector C95 - City Limits"
	landmark_tag = "nav_barge_1"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/barge/two
	name = "Moon 2 Sector DZ3 - Bay of Shards"
	landmark_tag = "nav_barge_2"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/barge/three
	name = "Moon 3 Sector AF001 - Overgrowth"
	landmark_tag = "nav_barge_3"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/barge/four
	name = "Moon 4 Sector ZX23 - Anvil's Mine"
	landmark_tag = "nav_barge_4"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/barge/five
	name = "Slingshot Path - Escape Route"
	landmark_tag = "nav_barge_5"
	landmark_flags = SLANDMARK_FLAG_AUTOSET