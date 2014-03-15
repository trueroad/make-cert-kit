# Makefile for sample ECC certificate directories

.PHONY:	all clean

all:	server/all client/all \
	codesign/all timestamp/all

server/all:	inter/all
client/all:	inter/all
codesign/all:	inter/all
timestamp/all:	inter/all

inter/all:	root/all

clean:	root/clean inter/clean \
	server/clean client/clean \
	codesign/clean timestamp/clean

include ../../tools/common.mk
