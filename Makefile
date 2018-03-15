

test:
	python --version
	pip install elasticsearch freezegun
	# Syntax check
	python -m py_compile ./curator.py
	python ./curator_test.py
