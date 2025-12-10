# dist-tuple.test

Tool to test dist-tuple for regressions. It prints the variables created by `dist-tuple.port.mk` in OpenBSD's `/usr/ports/infrastructure/mk/` for selected ports or all that use `DIST_TUPLE`. A custom `dist-tuple.port.mk` can be passed as `DT_MK`. This way the output with 2 different such files can be compared to check for regressions.

The output contains the values of all variables for the templates and each port. Template variables:

* SITES.template
* TEMPLATE_DISTFILESi.template
* EXTRACT_SUFX.template
* TEMPLATE_HOMEPAGE

(Note that the template variables contain several place holders like `<project>` that are used to build the specific data for each DIST_TUPLE entry.)

Variables generated for each port:

* DIST_TUPLE
* DISTNAME
* _DT_WRKDIST
* HOMEPAGE
* EXTRACT_SUFX.template
* DISTFILES.template
* MODDIST-TUPLE_post-extract (the command to move the extracted files into a specific directory)

## Dependencies:

```
# pkg_add sqlports
```

## Examples:

Check output for all ports that use `DIST_TUPLE`:

```
$ make
```

Check output for 2 ports (devel/gtest and archivers/heatshrink):

```
$ make PORTS="devel/gtest archivers/heatshrink"
```

Create output with default and updated `dist-tuple.port.mk` and compare for regressions:

```
$ make > /tmp/dt-test1.txt
$ make DT_MK=/tmp/dist-tuple.port.mk.update > /tmp/dt-test2.txt
$ diff -u /tmp/dt-test1.txt /tmp/dt-test2.txt
```
