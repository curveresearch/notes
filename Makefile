.DEFAULT_GOAL := help

.PHONY: help
help:
	@echo ""
	@echo "Available commands:"
	@echo ""
	@echo "tex              create LaTeX document from Markdown"
	@echo "pdf              create PDF from LaTeX"
	@echo ""
	@echo "build     	build Docker image"
	@echo "bash      	start bash shell in Docker container"
	@echo ""

.PHONY: tex
tex:
	pandoc --from=markdown --output=$(name).tex $(name).md --to=latex --standalone

.PHONY: pdf
pdf: tex
	pdflatex $(name).tex

.PHONY: build
build:
	docker build . -t latex_docker

.PHONY: bash
bash:
	docker run -it -v ${PWD}:/app latex_docker bash
