.PHONY: build

TARGET_DB=mysql
BUILDSTAMP=$(shell git describe --tags)
STATIC_DIR=../webapp/
SAMPLE_DATA=tinode-db/data.json


TIMESTAMP = $(shell date +%Y%m%d_%H%M%S)


build:
	go build -ldflags "-s -w -X main.buildstamp=${BUILDSTAMP}" -tags ${TARGET_DB} -o tinode ./server/
	go build -ldflags "-s -w" -tags ${TARGET_DB} -o init-db ./tinode-db

initdb:
	./init-db --config=configs/tinode.conf --data=${SAMPLE_DATA}

run: initdb
	./tinode --config=configs/tinode.conf --static_data=${STATIC_DIR} --pprof ${TIMESTAMP}_tinode_pprof.out --tracef ${TIMESTAMP}_tinode_trace.out > tinode.log


