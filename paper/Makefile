all:
	pdflatex -shell-escape paper -dPDFSETTINGS=/prepress
	pdflatex -shell-escape paper -dPDFSETTINGS=/prepress
	bibtex paper
	pdflatex -shell-escape paper -dPDFSETTINGS=/prepress
	pdflatex -shell-escape paper -dPDFSETTINGS=/prepress
	gs -dSAFER -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sPAPERSIZE=letter -dPDFSETTINGS=/prepress -dCompatibilityLevel=1.4 -dMaxSubsetPct=100 -dSubsetFonts=true -dEmbedAllFonts=true -sOutputFile=test.pdf paper.pdf
	mv test.pdf paper.pdf

clean:
	rm -rf *.log *.dvi *.aux *~ core.* *.ps *.pdf *bbl; 

zip:
	zip paperIMC.zip *.tex *.cls *.bib *.sty *.pdf Makefile
