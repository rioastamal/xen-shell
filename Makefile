
all:
	@echo " "
	@echo "Usage:"
	@echo " "
	@echo " make clean   - Clean this directory recursively"
	@echo " make install - Install the software to /usr/local"
	@echo " make remove  - Uninstall"
	@echo " "


clean:
	find . -name '*~' -exec rm -f \{\} \;

install:
	if [ ! -d /usr/local/bin ]; then mkdir /usr/local/bin ; fi
	cp bin/xm-console /usr/local/bin
	cp bin/xen-login-shell /usr/local/bin
	cp bin/xen-shell /usr/local/bin
	if [ ! -d /usr/local/etc ]; then mkdir /usr/local/etc ; fi
	cp misc/_screenrc /usr/local/etc

remove:
	rm /usr/local/bin/xen-shell
	rm /usr/local/bin/xen-login-shell
	rm /usr/local/bin/xen-console
	rm /usr/local/bin/xm-console
	rm /usr/local/etc/_screenrc
	-rmdir /usr/local/etc
