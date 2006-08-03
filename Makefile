#
#  Only used to build distribution tarballs.
#
DIST_PREFIX = /tmp
VERSION     = 2.2
BASE        = xen-shell


all:
	@echo " "
	@echo "Usage:"
	@echo " "
	@echo " make clean   = Clean this directory recursively"
	@echo " make diff    = Run a 'cvs diff'."
	@echo " make install = Install the software to /usr/local"
	@echo " make remove  = Uninstall"
	@echo " make release = Make a release tarball"
	@echo " make update  = Update from the CVS repository."
	@echo " "


clean:
	find . -name '*~' -exec rm -f \{\} \;


diff:
	cvs diff --unified 2>/dev/null


#
#  Install into /usr/local
#
install:
	if [ ! -d /usr/local/bin ]; then mkdir /usr/local/bin ; fi
	cp bin/xm-reimage /usr/local/bin
	cp bin/xen-login-shell /usr/local/bin
	cp bin/xen-shell /usr/local/bin
	if [ ! -d /usr/local/etc ]; then mkdir /usr/local/etc ; fi
	cp misc/_screenrc /usr/local/etc


#
#  Make a new release tarball.
#
release: clean
	rm -rf $(DIST_PREFIX)/$(BASE)-$(VERSION)
	rm -f $(DIST_PREFIX)/$(BASE)-$(VERSION).tar.gz
	cp -R . $(DIST_PREFIX)/$(BASE)-$(VERSION)
	find  $(DIST_PREFIX)/$(BASE)-$(VERSION) -name "CVS" -print | xargs rm -rf
	rm -rf $(DIST_PREFIX)/$(BASE)-$(VERSION)/debian
	cd $(DIST_PREFIX) && tar --exclude=.cvsignore -cvf $(DIST_PREFIX)/$(BASE)-$(VERSION).tar $(BASE)-$(VERSION)/
	gzip $(DIST_PREFIX)/$(BASE)-$(VERSION).tar
	mv $(DIST_PREFIX)/$(BASE)-$(VERSION).tar.gz .
	rm -rf $(DIST_PREFIX)/$(BASE)-$(VERSION)
	gpg --armour --detach-sign $(BASE)-$(VERSION).tar.gz


#
#  Reove the software
#
remove:
	rm /usr/local/bin/xen-shell
	rm /usr/local/bin/xen-login-shell
	rm /usr/local/bin/xen-console
	rm /usr/local/bin/xm-reimage
	rm /usr/local/etc/_screenrc
	-rmdir /usr/local/etc

#
#  Update from CVS repository
#
update: 
	cvs -z3 update -A -P -d 2>/dev/null

