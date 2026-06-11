
all: cv.pdf

img: __subdir-img

cv.pdf: cv.typ cv-LC.yaml lib.typ bg-1.typ publications.yaml img
	typst compile cv.typ

clean:
	rm -f cv.pdf
	make -C img clean


__subdir-%:
	make -C $*
