#
#  Only used to build distribution tarballs.
#
DIST_PREFIX = ${TMP}
VERSION     = 1.8
BASE        = xen-shell


all:
	@echo " "
	@echo "Usage:"
	@echo " "
	@echo " make clean   = Clean this directory recursively"
	@echo " make diff    = View local changes."
	@echo " make install = Install the software to /usr/local"
	@echo " make remove  = Uninstall"
	@echo " make release = Make a release tarball"
	@echo " make update  = Update from the master repository."
	@echo " "


clean:
	@find . -name '*~' -exec rm -f \{\} \;
	@if [ -e build-stamp ]; then rm -f build-stamp ; fi
	@if [ -e configure-stamp ]; then rm -f configure-stamp ; fi
	@if [ -d debian/xen-shell ]; then rm -rf debian/xen-shell ; fi


diff:
	hg diff 2>/dev/null


#
#  Install into /usr/bin, then remove the old install from /usr/local/bin
#
install: manpages
	cp bin/xm-reimage /usr/bin
	cp bin/xen-login-shell /usr/bin
	cp bin/xen-shell /usr/bin
	if [ ! -d /etc/xen-shell ]; then mkdir /etc/xen-shell ; fi
	cp misc/_screenrc /etc/xen-shell
	cp misc/xen-shell.conf /etc/xen-shell
	if [ ! -d /etc/bash_completion.d ]; then mkdir /etc/bash_completion.d/ ; fi
	cp misc/xen-shell /etc/bash_completion.d
	@if [ -e /usr/local/bin/xm-reimage ]; then chmod -x /usr/local/bin/xm-reimage; echo "Obsolete software in /usr/local/bin/xm-reimage - please remove"; fi
	@if [ -e /usr/local/bin/xen-shell ]; then chmod -x /usr/local/bin/xen-shell ; echo "Obsolete software in /usr/local/bin/xm-reimage - please remove"; fi
	@if [ -e /usr/local/bin/xen-login-shell ]; then chmod -x /usr/local/bin/xen-login-shell; echo "Obsolete software in /usr/local/bin/xm-reimage - please remove"; fi
	@if ( grep /usr/local/bin/xen-login-shell /etc/passwd >/dev/null 2>/dev/null ) ; then echo "WARNING:  /etc/passwd contains users with their login shell pointing to the OLD software which was in /usr/local/bin" ; fi



makemanpages: clean
	cd bin; for i in *-*; do pod2man --release=${VERSION} --official --section=8 $$i ../man/$$i.man; done



manpages: makemanpages
	for i in man/*.man; do file=`basename $$i .man` ; cp $$i /usr/share/man/man1/$$file.1; done
	for i in /usr/share/man/man1/*.1; do gzip -f -9 $$i; done
	rm /usr/share/man/man1/xen-add-user.1.gz

#
#  Make a new release tarball.
#
release: clean
	rm -rf $(DIST_PREFIX)/$(BASE)-$(VERSION)
	rm -f $(DIST_PREFIX)/$(BASE)-$(VERSION).tar.gz
	cp -R . $(DIST_PREFIX)/$(BASE)-$(VERSION)
	perl -pi -e "s/UNRELEASED/${VERSION}/g" $(DIST_PREFIX)/$(BASE)-$(VERSION)/bin/xen-shell
	rm -rf $(DIST_PREFIX)/$(BASE)-$(VERSION)/debian
	rm -rf $(DIST_PREFIX)/$(BASE)-$(VERSION)/.hg*
	cd $(DIST_PREFIX) && tar -cvf $(DIST_PREFIX)/$(BASE)-$(VERSION).tar $(BASE)-$(VERSION)/
	gzip $(DIST_PREFIX)/$(BASE)-$(VERSION).tar
	mv $(DIST_PREFIX)/$(BASE)-$(VERSION).tar.gz .
	rm -rf $(DIST_PREFIX)/$(BASE)-$(VERSION)
	gpg --armour --detach-sign $(BASE)-$(VERSION).tar.gz


#
#  Remove the software
#
remove:
	rm /usr/bin/xen-shell
	rm /usr/bin/xen-login-shell
	rm /usr/bin/xm-reimage
	rm /etc/xen-shell/_screenrc
	rm /etc/xen-shell/xen-shell.conf
	-rmdir /etc/xen-shell


#
#  Run the test suite.
#
test:
	prove --shuffle tests/


#
#  Run the test suite verbosely.
#
test-verbose:
	prove --shuffle --verbose tests/


#
#  Update from the master repository
#
update: 
	hg pull --update
