# Copyright (c) 2025 Thomas Frohwein
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

PORTSDIR ?=	/usr/ports
LOCALBASE ?=	/usr/local
DT_MK ?=	${PORTSDIR}/infrastructure/mk/dist-tuple.port.mk
SQLPORTS ?=	${LOCALBASE}/share/sqlports
SQLITE ?=	${LOCALBASE}/bin/sqlite3

.include "${DT_MK}"

_SITES = ${.VARIABLES:MSITES.*}

all: static-vars
	@echo
	@echo "Done."
	@echo

static-vars:
	@echo
	@echo "1. Static Variables"
	@echo "==================="
	@echo
	@echo "Known SITES.x"
	@echo "-------------"
	@echo
	@for s in ${_SITES}; do echo "$$s"; done
