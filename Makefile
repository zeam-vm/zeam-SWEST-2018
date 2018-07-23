PDF = manuscript.pdf

all: ${PDF}

%.pdf:  %.tex description.tex reference.bib Makefile Elixir-proposal-2018.xbb
	uplatex $<
	- upbibtex $*
	uplatex $<
	uplatex $<
	while ( grep -q '^LaTeX Warning: Label(s) may have changed' $*.log) \
	do uplatex $<; done
	dvipdfmx $*

description.tex: description.md
	@cat $^ \
	| pandoc -f markdown -t latex -V documentclass=ltjarticle --pdf-engine=lualatex -f markdown-auto_identifiers \
	| sed 's/includegraphics/includegraphics[width=0.75\\columnwidth]/g' \
	| sed 's/\[htbp\]/\[t\]/g' \
	> description.tex

Elixir-proposal-2018.xbb: Elixir-proposal-2018.png
	extractbb Elixir-proposal-2018.png

clean:
	@rm -rf description.{dvi,log,tex} manuscript.{pdf,aux,dvi,log,out,blg,bbl,.synctex.gz} *.xbb
