SHA=$(shell git describe --always)

tarball: afn-nextgen-$(SHA).tar.gz

afn-nextgen-$(SHA).tar.gz:
	git archive --prefix=afn-nextgen/ -o $@ $(SHA)
