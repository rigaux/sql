

all:  exam-blanc-janvier19.pdf exam-s1-fod-19.pdf exam-s2-fod-19.pdf exam-s1-presentiel-19.pdf \
            exam-s2-presentiel-19.pdf exam-s1-presentiel-20.pdf \
            ex106-s1-hybride-20.pdf \
						exam-s1-foad-20.pdf \
						ex106-s1-foad-20.pdf \
					exam-s2-presentiel-20.pdf \
				 ex106-s2-foad-20.pdf \
				 exam-s1-foad-21.pdf exam-s2-foad-21.pdf \
				 exam-s1-presentiel-21.pdf  exam-s2-presentiel-21.pdf \
				ex106-s1-foad-21.pdf ex106-s2-foad-21.pdf \
				exam-s1-foad-22.pdf exam-subst-foad-22.pdf exam-s2-foad-22.pdf \
				exam-s1-hybride-22.pdf \
				ex106-s1-hybride-22.pdf

%.pdf: sujets/%.tex
	pdflatex   -shell-escape "\newcommand\inputFile{sujets/$*.tex}\input{sujet}"
	pdflatex   -shell-escape "\newcommand\inputFile{sujets/$*.tex}\input{sujet}"
	mv sujet.pdf ./pdf/$*.pdf
	make clean


clean:
	\rm -f *.vrb *.aux *.bbl *.blg *.dvi *.log *.ps *.snm *.out *.nav *.toc *~ *.pdf *.pyg*
	rm -Rf _minted*
