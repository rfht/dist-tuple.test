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

.poison empty (PORTSDIR)
.poison empty (DT_MK)
.include "${DT_MK}"

WRKDIR ?=		"**WRKDIR**"

DT_DISTFILES =		${.VARIABLES:MDISTFILES.*}
DT_EXTRACT_SUFX =	${.VARIABLES:MEXTRACT_SUFX.*}

_TEMPLATES = ${.VARIABLES:MSITES.*:E}
.for _t in ${_TEMPLATES}
DETAILS += "\n${_t}:\n"
.  for _d in SITES TEMPLATE_DISTFILES EXTRACT_SUFX TEMPLATE_HOMEPAGE
.    if !empty(${_d}.${_t})
DETAILS += "\t${${_d}.${_t}}\n"
# EXTRACT_SUFX.${_t} falls back to TEMPLATE_EXTRACT_SUFX if not defined
.    elif empty(${_d:C/^EXTRACT_SUFX*//})
DETAILS += "\t${TEMPLATE_EXTRACT_SUFX}\n"
.    elif !empty(${_d})
DETAILS += "\t${${_d}}\n"
.    else
ERRORS += "Template ${_t} has no value for ${_d}.${_t} and no default (${_d})."
.    endif
.  endfor
.endfor


derived-vars:
.poison empty (DIST_TUPLE)
	@printf "%-15s %s " "DISTNAME" "="
	@echo "${DISTNAME}"
	@printf "%-15s %s " "_DT_WRKDIST" "="
	@echo "${_DT_WRKDIST}"
	@printf "%-15s %s " "HOMEPAGE" "="
	@echo "${HOMEPAGE}"
	@printf "%-15s %s " "${DT_EXTRACT_SUFX}" "="
	@echo "${${DT_EXTRACT_SUFX}}"
	@printf "%-15s %s " "${DT_DISTFILES}" "="
	@echo "${${DT_DISTFILES}}"
	@printf "%-15s %s " "MODDIST-TUPLE_post-extract:" "="
	@echo '"${MODDIST-TUPLE_post-extract:C/\$//g}"'

templates:
	@echo
	@echo "Templates"
	@echo "---------"
	@echo ${DETAILS}
