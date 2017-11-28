SHA=$(shell git describe --always)
TARBALL=afn-nextgen-$(SHA).tar.gz

tarball: $(TARBALL)

$(TARBALL):
	git archive --prefix=afn-nextgen/ -o $@ $(SHA)

upload: $(TARBALL)
	scp $(TARBALL) baadsvik:~/sandboxes/afn-isconf/images/fattuba.com/
