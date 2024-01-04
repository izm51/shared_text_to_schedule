deploy:
	firebase deploy

.PHONY: run
# start local emulator server
run:
	firebase emulators:start
