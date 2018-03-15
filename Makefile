

test:
	python3 --version
	pip install elasticsearch freezegun
	# Syntax check
	python3 -m py_compile ./curator.py
	python3 ./curator_test.py
