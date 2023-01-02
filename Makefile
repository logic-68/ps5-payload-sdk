#   Copyright (C) 2023 John Törnblom
#
# This file is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; see the file COPYING. If not see
# <http://www.gnu.org/licenses/>.

CC      := clang
CFLAGS  := -ffreestanding -fno-builtin -nostdlib -static
PYTHON  := python3
DESTDIR ?= /opt/ps5-payload-sdk

MOD_SOURCES  := libkernel.c libkernel_sys.c libkernel_web.c \
                libSceLibcInternal.c
MOD_ARCHIVES := $(MOD_SOURCES:.c=.a)

NID_DB_URL  := https://raw.githubusercontent.com/astrelsky/GhidraOrbis/master/data/nid_db.xml


all: crt1.o $(MOD_ARCHIVES)

nid_db.xml:
	wget $(NID_DB_URL)

libkernel.c: libkernel.sprx nid_db.xml
	$(PYTHON) trampgen.py --module-id 0x2001 --prx $< > $@

libkernel_sys.c: libkernel_sys.sprx nid_db.xml
	$(PYTHON) trampgen.py --module-id 0x2001 --prx $< > $@

libkernel_web.c: libkernel_web.sprx nid_db.xml
	$(PYTHON) trampgen.py --module-id 0x2001 --prx $< > $@

libSceLibcInternal.c: libSceLibcInternal.sprx nid_db.xml
	$(PYTHON) trampgen.py --module-id 0x2 --prx $< > $@

%.o: %.c
	$(CC) -c $(CFLAGS) -o $@ $^

%.a: %.o
	ar rcs $@ $^

clean:
	rm -f *.o *.a nid_db.xml

install:
	install -d $(DESTDIR)/target/lib
	install linker.x $(DESTDIR)/target
	install crt1.o $(MOD_ARCHIVES) $(DESTDIR)/target/lib
	cp -r include_bsd $(DESTDIR)/target/include