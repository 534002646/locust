test:
	pytest -vv locust/test

.PHONY: build
build: check-uv check-yarn
	uv build

install: check-uv
	uv sync

.SILENT:
.PHONY: check-uv
check-uv:
	command -v uv >/dev/null 2>&1 || { echo >&2 "Locust requires the uv binary to be available in this shell to build the Python package.\nSee: https://docs.locust.io/en/stable/developing-locust.html#install-locust-for-development"; exit 1; }

.SILENT:
.PHONY: check-yarn
check-yarn:
	command -v yarn >/dev/null 2>&1 || { echo >&2 "Locust requires the yarn binary to be available in this shell to build the web front-end.\nSee: https://docs.locust.io/en/stable/developing-locust.html#making-changes-to-locust-s-web-ui"; exit 1; }

frontend_build:
	yarn webui:install && yarn webui:build

release: build
	twine upload dist/*

setup_docs_dependencies:
	uv sync --all-groups

build_docs: setup_docs_dependencies
	sphinx-build -b html docs/ docs/_build/

# This command can be used to serve the built documentation at http://localhost for
# easier offline viewing
.SILENT:
.PHONY: serve_docs
serve_docs:
	echo "Serving docs at http://localhost:80"
	python -m http.server 80 -d docs/_build

changelog:
	@echo "Not supported any more. Run ./generate_changelog.py <version_number> instead!"
