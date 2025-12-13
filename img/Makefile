
ALL = \
	asml_r100.png \
	beamline_r100.png \
	beamline-cern_r100.png \
	bl4s-group_r100.png \
	ippog_r100.png \
	me_r300.jpg \
	pack-man_r100.png \
	tco_r100.png

all: $(ALL) 

%_r100.png: %.png
	convert $< -resize 100x $@

%_r300.jpg: %.jpg
	convert $< -resize 300x $@

clean:
	-rm -f $(ALL)
