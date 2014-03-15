# Makefile for sample DSA (2048, 256) with SHA-2 certificate directories

# Cautions: Windows does not support this certificate algorithm
# even if it is Windows 8.1.

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
