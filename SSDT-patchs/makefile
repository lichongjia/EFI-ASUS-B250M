# makefile

BUILDDIR=./
HOTPATCH=./

HACK=$(wildcard $(HOTPATCH)/*.dsl)
HACK:=$(subst $(HOTPATCH),$(BUILDDIR),$(HACK))
HACK:=$(subst .dsl,.aml,$(HACK))

ALL=$(HACK)

.PHONY: all
all : $(ALL)

.PHONY: clean
clean:
	rm -f $(BUILDDIR)/*.aml

IASLOPTS=-vw 2095 -vw 2008 -vw 4089 -vi -vs

./%.aml : ./%.dsl
	iasl $(IASLOPTS) -p $@ $<

# EOF
