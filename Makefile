USER_UID != id -u
USER_GID != id -g

.PHONY: help texlive node24

help:
	@echo "available makejails: texlive node24"

texlive:
	appjail makejail -j texlive -f texlive/Makejail -- --host_uid $(USER_UID) --host_gid $(USER_GID)

node24:
	appjail makejail -j node24 -f node24/Makejail -- --host_uid $(USER_UID) --host_gid $(USER_GID)
