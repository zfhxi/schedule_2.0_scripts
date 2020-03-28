## Makefile

BASE_DIR=/home/julian/Projects/SoftWareTest/schedule
VERS_DIR=$(BASE_DIR)/versions.alt/versions.orig

GCOV_FLAGS=-fprofile-arcs -ftest-coverage
CFLAGS+=$(GCOV_FLAGS)


TARGET=schedule

all: v0 v1 v2 v3 v4 v5 v6 v7 v8 v9

v%:
	cd ${VERS_DIR}/$@ && rm -rf *exe *gcno
	cd ${VERS_DIR}/$@ && $(CC) $(CFLAGS) $(TARGET).c -o $(TARGET).exe

.PHONY: clean
clean:  v0clean v1clean v2clean v3clean v4clean v5clean v6clean v7clean v8clean v9clean

v%clean:
	cd ${VERS_DIR}/v$* && rm -rf *exe *gcno *gcda *.c.gcov
