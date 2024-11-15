../input ../output ../temp ../report:
	mkdir $@

.PRECIOUS: ../../%
../../%: #Generic recipe to produce outputs from upstream tasks
	$(MAKE) -C $(subst output/,code/,$(dir $@)) ../output/$(notdir $@)
