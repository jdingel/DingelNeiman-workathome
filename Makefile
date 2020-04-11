all:
	make -C downloaddata/code
	make -C occ_onet_scores/code
	make -C occ_manual_scores/code
	make -C onet_to_BLS_crosswalk/code
	make -C national_measures/code
	make -C compare_measures/code
	make -C MSA_measures/code
	make -C MSA_maps_tables/code
	make -C symlink_graph/code
	make -C country_measures/code
	make -C country_correlates/code
