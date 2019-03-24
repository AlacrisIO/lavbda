x := lavbda

all: lavbda

.PHONY: all lavbda wc mrproper clean

lavbda: lavbda.html
lavbda.html: lavbda.rkt reveal.rkt
	racket $< > $@.tmp && mv $@.tmp $@ || rm $@.tmp

clean:
	rm -f *.pdf *.html *.tex *.css *.js
	rm -rf tmp

mrproper:
	git clean -xfd
