USER_UID != id -u
USER_GID != id -g
WORKDIR	 = /home/maxim/projects

.PHONY: help texlive node24 lazyvim

help:
	@echo "available makejails: texlive node24 lazyvim"; \
	echo "available commands: run prepare"

texlive:
	appjail makejail -j texlive -f texlive/Makejail -- --host_uid ${USER_UID} --host_gid ${USER_GID}

node24:
	appjail makejail -j node24 -f node24/Makejail -- --host_uid ${USER_UID} --host_gid ${USER_GID}

lazyvim:
	appjail makejail -j lazyvim -f lazyvim/Makejail

prepare-node24:
	@doas mkdir -p /var/cache/npm; \
	doas chown -R "${USER_UID}:${USER_GID}" /var/cache/npm

prepare:
	@read -r -p "Jail to prepare (node24): " jail; \
	make "prepare-$$jail"

run:
	@read -r -p "Directory to mount [${WORKDIR}]: " dir; \
	dir=$${dir:-"${WORKDIR}"}; \
	read -r -p "Jail to run (texlive node24 lazyvim): " jail; \
	test -n "$$jail" || { echo "Jail name is required"; exit 1; }; \
	appjail run \
		-p "workdir=$$(realpath "$$dir")" \
		"$$jail"
