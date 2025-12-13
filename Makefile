
all: cv.pdf

img: __subdir-img

cv.pdf: cv.typ img
	typst compile cv.typ

clean:
	rm -f cv.pdf
	make -C img clean


__subdir-%:
	make -C $*