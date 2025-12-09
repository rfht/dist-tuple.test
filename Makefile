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
.include "placeholders.mk"

_TEMPLATES = ${.VARIABLES:MSITES.*:E}
.for _t in ${_TEMPLATES}
DETAILS += "\n${_t}:\n"
.  for _d in SITES TEMPLATE_EXTRACT_SUFX TEMPLATE_DISTFILES TEMPLATE_HOMEPAGE
.    if !empty(${_d}.${_t})
DETAILS += "\t${_d}.${_t}:\t${${_d}.${_t}}\n"
.    elif !empty(${_d})
DETAILS += "\t${_d}:\t${${_d}}\n"
.    else
# XXX: really add DETAILS? Or make all ERRORS fatal and just stop?
DETAILS += "\t${_d}.${_t}: MISSING!"
ERRORS += "Template _t has no value for ${_d}.${_t} and no default (${_d})."
.    endif
.  endfor
.endfor

# TODO: with sqlports 7.54, need to select unique FullPkgPath
ALL_DT_PORTS !!=	${SQLITE} ${SQLPORTS} 'SELECT DISTINCT FullPkgPath FROM DistTuple;'
PORTS ?=		${ALL_DT_PORTS}

.for _p in ${PORTS}
_portline != ${SQLITE} ${SQLPORTS} 'SELECT Type, Account, Project, Id, Mv FROM DistTuple WHERE FullPkgPath = "${_p}";'
.  if empty(_portline)
ERRORS += "No such port with DistTuple: ${_p}"
.  else
PORTS_DATA.${_p} +:= "${_portline}"
.  endif
.endfor

## TARGETS ##

all: templates
.  for _p in ${PORTS}
	@echo "Check port ${_p}:"
	@echo ${PORTS_DATA.${_p}}
.  endfor

templates:
	@echo
	@echo "1. Static Variables"
	@echo "==================="
	@echo
	@echo "1.1 Known Templates"
	@echo "-------------------"
	@echo ${DETAILS}

list-dist-tuple-ports:
	@echo ${ALL_DT_PORTS}

check-dist-tuple:
	@echo "DISTNAME:\t${DISTNAME}"
	@echo "_DT_WRKDIST:\t${_DT_WRKDIST}"
	@echo "DISTFILES:\t${DISTFILES}"
	@echo "DISTFILES.github:\t${DISTFILES.github}"
	@echo "EXTRACT_SUFX.github:\t${EXTRACT_SUFX.github}"
	@echo "HOMEPAGE:\t${HOMEPAGE}"

.if defined(ERRORS)
.BEGIN:
	@echo
	@echo 1>&2 "Exiting with error(s):"
.    for _m in ${ERRORS}
	@echo 1>&2 ${_m}
.    endfor
	@exit 1
.  endif

.PHONY: all check-dist-tuple list-dist-tuple-ports templates
