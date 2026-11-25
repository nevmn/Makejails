USER_UID != id -u
USER_GID != id -g
WORKDIR	 = /home/maxim/projects

.PHONY: help texlive node24 lazyvim php84

help:
	@echo "run \"make <jailname>\" to create the jail"; \
	echo "available makejails: texlive, node24, lazyvim, php84"; \
	echo ""; \
	echo "additional commands: prepare, run"

texlive:
	appjail makejail -j texlive -f texlive/Makejail -- --host_uid ${USER_UID} --host_gid ${USER_GID}

node24:
	doas sh -c 'mkdir -p /var/cache/npm \
				&& chown -R "${USER_UID}:${USER_GID}" /var/cache/npm \
				&& appjail makejail -j node24 -f node24/Makejail -- --host_uid ${USER_UID} --host_gid ${USER_GID}'

lazyvim:
	appjail makejail -j lazyvim -f lazyvim/Makejail -- --host_uid ${USER_UID} --host_gid ${USER_GID}

php84:
	appjail makejail -j php84 -f php84/Makejail -- --host_uid ${USER_UID} --host_gid ${USER_GID}

prepare-virtual-network:
	@appjail network add jailed 10.0.0.0/24

prepare: 
	make prepare-virtual-network

run:
	@read -r -p "Directory to mount [${WORKDIR}]: " dir; \
	dir=$${dir:-"${WORKDIR}"}; \
	read -r -p "Jail to run (texlive node24 lazyvim): " jail; \
	test -n "$$jail" || { echo "Jail name is required"; exit 1; }; \
	doas sh -c 'appjail start "$$1" && appjail run -p "workdir=$$(realpath "$$2")" "$$1"' _ "$$jail" "$$dir"
