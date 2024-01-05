deploy: lint firebase_deploy

lint:
	npm --prefix ${RESOURCE_DIR} run lint &&\
	npm --prefix ${RESOURCE_DIR} run build

firebase_deploy:
	firebase deploy

.PHONY: run
# start local emulator server
run:
	firebase emulators:start
