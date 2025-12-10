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

QUERY_FLAGS =	-f query.mk DT_MK="${DT_MK}" PORTSDIR="${PORTSDIR}"

ALL_DT_PORTS !!=	${SQLITE} ${SQLPORTS} 'SELECT DISTINCT FullPkgPath FROM DistTuple;'
PORTS ?=		${ALL_DT_PORTS}

# save cpu cycles for templates; this way ALL_DT_PORTS shell command isn't run
.ifnmake templates
.  for _p in ${PORTS}
_portline != ${SQLITE} ${SQLPORTS} 'SELECT Type, Account, Project, Id, Mv FROM DistTuple WHERE FullPkgPath = "${_p}";'
.    if empty(_portline)
ERRORS += "No such port with DistTuple: ${_p}"
.    else
DIST_TUPLE.${_p} +:= ${_portline:S/|/ /g}
.    endif
.  endfor
.endif

## TARGETS ##

all: print-dt-mk templates ${PORTS}

${PORTS}:
	@echo "$@:"
	@echo "${@:C/./-/g}-"
	@printf "%-15s %s " "DIST_TUPLE" "="
	@echo ${DIST_TUPLE.$@}
	@echo
	@${.MAKE} ${QUERY_FLAGS} DIST_TUPLE="${DIST_TUPLE.$@}" derived-vars
	@echo

print-dt-mk:
	@printf "%-15s %s " "DT_MK" "="
	@echo "${DT_MK}"

templates:
	@${.MAKE} ${QUERY_FLAGS} templates

list-dist-tuple-ports:
	@echo ${ALL_DT_PORTS}

.if defined(ERRORS)
.BEGIN:
	@echo
	@echo 1>&2 "Exiting with error(s):"
.    for _m in ${ERRORS}
	@echo 1>&2 ${_m}
.    endfor
	@exit 1
.  endif

.PHONY: all check-dist-tuple list-dist-tuple-ports templates ${PORTS}
