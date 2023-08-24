

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
				sujets/2022/exam-s1-foad-22.pdf sujets/2022/exam-s2-foad-22.pdf \
				sujets/2022/ex106-s1-22.pdf sujets/2022/ex106-s2-22.pdf \
				sujets/2022/exam-s2-hybride-22.pdf sujets/2022/exam-s1-hybride-22.pdf \
				sujets/2023/exam-s1-foad-23.pdf sujets/2023/exam-s2-foad-23.pdf  \
				sujets/2023/ex106-s1-23.pdf sujets/2023/ex106-s2-23.pdf \
				sujets/2023/exam-s1-hybride-23.pdf sujets/2023/exam-s2-hybride-23.pdf


%.pdf: %.tex
	pdflatex   -shell-escape "\newcommand\inputFile{$*.tex}\input{sujet}"
	pdflatex   -shell-escape "\newcommand\inputFile{$*.tex}\input{sujet}"
	mv sujet.pdf $*.pdf
	make clean


clean:
	\rm -f *.vrb *.aux *.bbl *.blg *.dvi *.log *.ps *.snm *.out *.nav *.toc *~ *.pdf *.pyg*
	rm -Rf _minted*
