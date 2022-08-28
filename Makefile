.PHONY: workflow_dispatch

 workflow_dispatch:
	act workflow_dispatch \
		--secret-file ${CURDIR}/.act/private.secrets \
		--eventpath ${CURDIR}/.act/private-payload.json
