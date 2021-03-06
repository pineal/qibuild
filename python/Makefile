##
## Author(s):
##  - Cedric GESTES <gestes@aldebaran-robotics.com>
##
## Copyright (C) 2009, 2010, 2012-2014 Aldebaran Robotics
##

TEST_MODULES =
ifneq ($(MYPYMODULES),)
PYMODULES    = $(MYPYMODULES)
TEST_MODULES:= $(foreach module,$(MYPYMODULES),\
	$(shell dirname $(module))/test/test_$(shell basename $(module)).py)
TEST_MODULES:= $(foreach test,$(TEST_MODULES),\
	$(filter $(test),$(wildcard $(shell dirname $(test))/*)))
endif

PYMODULES ?= qisys qibuild qitoolchain qisrc qidoc qilinguist \
	bin/qibuild                                \
	bin/qisrc                                  \
	bin/qitoolchain                            \
	bin/qilinguist

PYTHON    ?= python
PIP       ?= pip

all: pylint-error check

pylint-full:
	@echo ":: Running pylint: $(PYMODULES)"
	@pylint --rcfile pylint.rc $(PYMODULES) 2>&1 || exit 1 || exit 0

pylint-error:
	@echo ":: Running pylint --errors-only: $(PYMODULES)"
	@pylint --errors-only --rcfile pylint.rc $(PYMODULES) 2>&1 || \
		exit 1 || exit 0
	@echo " => Checked only for pylint errors"
	@echo "    Use make check-all for running a full pylint check"

check:
	@echo ":: Running tests: $(TEST_MODULES)"
	@$(PYTHON) -m pytest $(PYTEST_ARGS) $(TEST_MODULES) \
				  --cov=. --cov-report=html

check-fast:
	@echo ":: Runnig fasts tests: $(TEST_MODULES)"
	@$(PYTHON) -m pytest -k -slow $(TEST_MODULES)

doc:
	@$(PYTHON) ../doc/tools/gen_cmake_doc.py ..
	@$(PYTHON) -c "from sphinx import main; main()" -b html ../doc/source ../doc/build/html

upgrade-python:
	@echo ":: Update python modules with $(PIP)"
	@$(PIP) install --user --upgrade --requirement requirements.txt
