#
# Makefile for OpenzWave Control Panel application
# Greg Satz

# GNU make only

.SUFFIXES:	.cpp .o .a .s

CC     := gcc
CXX    := g++
LD     := g++
AR     := ar rc
RANLIB := ranlib

DEBUG_CFLAGS    := -Wall -Wno-inline -Wno-format -g -DDEBUG -Werror
RELEASE_CFLAGS  := -Wall -Wno-unknown-pragmas -Wno-format -O3 -DNDEBUG

DEBUG_LDFLAGS	:= -g

# Change for DEBUG or RELEASE
CFLAGS	:= -c $(DEBUG_CFLAGS)
LDFLAGS	:= $(DEBUG_LDFLAGS)

OPENZWAVE := /usr/include/openzwave
LIBMICROHTTPD := -lmicrohttpd

INCLUDES := -I /usr/include -I $(OPENZWAVE)

# Remove comment below for gnutls support
GNUTLS := #-lgnutls

# for Linux uncomment out next two lines
#LIBZWAVE := $(wildcard $(OPENZWAVE)/cpp/lib/linux/*.a)
LIBZWAVE := -lopenzwave
LIBUSB := -ludev

# for Mac OS X comment out above 2 lines and uncomment next 2 lines
#LIBZWAVE := $(wildcard $(OPENZWAVE)/cpp/lib/mac/*.a)
#LIBUSB := -framework IOKit -framework CoreFoundation

LIBS := $(LIBZWAVE) $(GNUTLS) $(LIBMICROHTTPD) -lpthread $(LIBUSB)

%.o : %.cpp
	$(CXX) $(CFLAGS) $(INCLUDES) -o $@ $<

%.o : %.c
	$(CC) $(CFLAGS) $(INCLUDES) -o $@ $<

all: ozwcp

ozwcp.o: ozwcp.h webserver.h $(OPENZWAVE)/Options.h $(OPENZWAVE)/Manager.h \
	$(OPENZWAVE)/Node.h $(OPENZWAVE)/Group.h \
	$(OPENZWAVE)/Notification.h $(OPENZWAVE)/Log.h

webserver.o: webserver.h ozwcp.h $(OPENZWAVE)/Options.h $(OPENZWAVE)/Manager.h \
	$(OPENZWAVE)/Node.h $(OPENZWAVE)/Group.h \
	$(OPENZWAVE)/Notification.h $(OPENZWAVE)/Log.h

ozwcp:	ozwcp.o webserver.o zwavelib.o
	$(LD) -o $@ $(LDFLAGS) ozwcp.o webserver.o zwavelib.o $(LIBS)

dist:	ozwcp
	rm -f ozwcp.tar.gz
	tar -c --exclude=".svn" -hvzf ozwcp.tar.gz ozwcp config/ cp.html cp.js openzwavetinyicon.png README

clean:
	rm -f ozwcp *.o
