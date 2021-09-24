
all:    slrappels.pdf slstock.pdf slcache.pdf slfichiers.pdf slindex.pdf  slarbreb.pdf \
           slhachage.pdf slhachageext.pdf slhachagelin.pdf


%.pdf: %.tex
	pdflatex   -shell-escape "\newcommand\inputFile{$*.tex}\input{genslides}"
	mv genslides.pdf ../ressources-web/$*.pdf
	make clean

#####
## Aspects système
####

slstockora : 
	pdflatex   -shell-escape "\newcommand\titreDiapos{Fichiers}\newcommand\inputFile{slstockora}\input{genslides}"
	mv genslides.pdf ../ressources-web/slstockora.pdf
	make clean


###  Evaluation
slintroeval : 
	pdflatex   -shell-escape "\newcommand\titreDiapos{Introduction à l'optimisation}\newcommand\inputFile{slintroeval}\input{genslides}"
	mv genslides.pdf ../ressources-web/slintroeval.pdf
	make clean

slreecriture : 
	latex   -shell-escape "\newcommand\titreDiapos{De SQL à l'algèbre}\newcommand\inputFile{slreecriture}\input{genslides}"
	dvipdf genslides
	mv genslides.pdf ../ressources-web/slreecriture.pdf
	make clean

sliter : 
	pdflatex   -shell-escape "\newcommand\titreDiapos{Les it\'erateurs}\newcommand\inputFile{sliter}\input{genslides}"
	mv genslides.pdf ../ressources-web/sliter.pdf
	make clean

sloperateurs : 
	pdflatex   -shell-escape "\newcommand\titreDiapos{Ex\'ecution et optimisation}\newcommand\inputFile{sloperateurs}\input{genslides}"
	mv genslides.pdf ../ressources-web/sloperateurs.pdf
	make clean

sltrifusion : 
	pdflatex   -shell-escape "\newcommand\titreDiapos{Algorithme de tri}\newcommand\inputFile{sltrifusion}\input{genslides}"
	mv genslides.pdf ../ressources-web/sltrifusion.pdf
	make clean

slalgojoin : 
	pdflatex   -shell-escape "\newcommand\titreDiapos{Algorithmes de jointure}\newcommand\inputFile{slalgojoin}\input{genslides}"
	mv genslides.pdf ../ressources-web/slalgojoin.pdf
	make clean


sltraitrequete : 
	pdflatex   -shell-escape "\newcommand\titreDiapos{Traitement d'une requête}\newcommand\inputFile{sltraitrequete}\input{genslides}"
	mv genslides.pdf ../ressources-web/sltraitrequete.pdf
	make clean

sloptim : 
	latex   -shell-escape "\newcommand\titreDiapos{Optimisation}\newcommand\inputFile{sloptim}\input{genslides}"
	dvipdf genslides
	mv genslides.pdf ../ressources-web/sloptim.pdf
	make clean
	
sloptiora : 
	pdflatex   -shell-escape "\newcommand\titreDiapos{Optimisation ORACLE}\newcommand\inputFile{sloptiora}\input{genslides}"
	mv genslides.pdf ../ressources-web/sloptiora.pdf
	make clean

sldemotrans : 
	pdflatex  -shell-escape -interaction=nostopmode  "\newcommand\titreDiapos{D\'emonstration de l'application "transactions"}\newcommand\inputFile{sldemotrans}\input{genslides}"
	mv genslides.pdf ../ressources-web/sldemotrans.pdf
	make clean	
	
sltransactions : 
	pdflatex  -shell-escape -interaction=nostopmode  "\newcommand\titreDiapos{Introduction aux transactions}\newcommand\inputFile{sltransactions}\input{genslides}"
	mv genslides.pdf ../ressources-web/sltransactions.pdf
	make clean	

sltransanomalies : 
	pdflatex  -shell-escape -interaction=nostopmode  "\newcommand\titreDiapos{Anomalies transactionnelles}\newcommand\inputFile{sltransanomalies}\input{genslides}"
	mv genslides.pdf ../ressources-web/sltransanomalies.pdf
	make clean	

slisolation : 
	pdflatex  -shell-escape -interaction=nostopmode  "\newcommand\titreDiapos{Niveaux d'isolation}\newcommand\inputFile{slisolation}\input{genslides}"
	mv genslides.pdf ../ressources-web/slisolation.pdf
	make clean
	
slconc-isolmultiversions : 
	pdflatex  -shell-escape -interaction=nostopmode  "\newcommand\titreDiapos{Isolation par versionnement}\newcommand\inputFile{slconc-isolmultiversions}\input{genslides}"
	mv genslides.pdf ../ressources-web/slconc-isolmultiversions.pdf
	make clean	
	
slserialisabilite : 
	pdflatex  -shell-escape -interaction=nostopmode  "\newcommand\titreDiapos{La s\'erialisabilit\'e}\newcommand\inputFile{slserialisabilite}\input{genslides}"
	mv genslides.pdf ../ressources-web/slserialisabilite.pdf
	make clean	

sl2pl : 
	pdflatex  -shell-escape -interaction=nostopmode  "\newcommand\titreDiapos{Verrouillage \`a deux phases}\newcommand\inputFile{sl2pl}\input{genslides}"
	mv genslides.pdf ../ressources-web/sl2pl.pdf
	make clean	
		
slccmultiversions : 
	pdflatex  -shell-escape -interaction=nostopmode  "\newcommand\titreDiapos{Le contrôle de concurrence multi-versions}\newcommand\inputFile{slccmultiversions}\input{genslides}"
	mv genslides.pdf ../ressources-web/slccmultiversions.pdf
	make clean									

slrp : 
	latex  -shell-escape -interaction=nostopmode  "\newcommand\titreDiapos{Reprise sur panne}\newcommand\inputFile{slrp}\input{generic-slides}"
	dvipdf generic-slides.dvi
	mv generic-slides.pdf ../ressources-web/slrp.pdf
	make clean	

slrpintro : 
	pdflatex  -shell-escape slrpintro
	mv slrpintro.pdf ../ressources-web/
	make clean		

slrparchi : 
	pdflatex  -shell-escape slrparchi
	mv slrparchi.pdf ../ressources-web/
	make clean		
	
slrpsimpliste : 
	pdflatex  -shell-escape slrpsimpliste
	mv slrpsimpliste.pdf ../ressources-web/
	make clean		
		
slrplog : 
	pdflatex  -shell-escape slrplog
	mv slrplog.pdf ../ressources-web/
	make clean			

slrpredoundo : 
	pdflatex  -shell-escape slrpredoundo
	mv slrpredoundo.pdf ../ressources-web/
	make clean		


slrpdisque : 
	pdflatex  -shell-escape slrpdisque
	mv slrpdisque.pdf ../ressources-web/
	make clean		
#

#
# MOOC
#

optim4 : 
	pdflatex  -shell-escape -interaction=nostopmode  MoocFunOptim-4.tex
	mv MoocFunOptim-4.pdf ../ressources-web/
	make clean				

optim5 : 
	pdflatex  -shell-escape -interaction=nostopmode  MoocFunOptim-5.tex
	mv MoocFunOptim-5.pdf ../ressources-web/
	make clean	


slrpcomplet: 
	pdflatex  -shell-escape -interaction=nostopmode  slrpcomplet.tex
	mv slrpcomplet.pdf ../ressources-web
	make clean			
	
	
#
#
# NFE107
#

nfp107:
	iconv -f utf-8 -t latin1 slstock.tex > /Users/philippe/Documents/workspace/NFP107-poly/05-orga_physique/phil-stock.tex
	iconv -f utf-8 -t latin1 slcache.tex > /Users/philippe/Documents/workspace/NFP107-poly/05-orga_physique/phil-cache.tex
	iconv -f utf-8 -t latin1 slfichiers.tex > /Users/philippe/Documents/workspace/NFP107-poly/05-orga_physique/phil-fichiers.tex
	iconv -f utf-8 -t latin1 slstockora.tex > /Users/philippe/Documents/workspace/NFP107-poly/05-orga_physique/phil-stockora.tex
	iconv -f utf-8 -t latin1 slindex.tex > /Users/philippe/Documents/workspace/NFP107-poly/05-orga_physique/phil-index.tex
	iconv -f utf-8 -t latin1 slarbreb.tex > /Users/philippe/Documents/workspace/NFP107-poly/05-orga_physique/phil-arbreb.tex
	iconv -f utf-8 -t latin1 slintroeval.tex > /Users/philippe/Documents/workspace/NFP107-poly/06-optim/phil-introeval.tex
	iconv -f utf-8 -t latin1 slreecriture.tex > /Users/philippe/Documents/workspace/NFP107-poly/06-optim/phil-reecriture.tex
	iconv -f utf-8 -t latin1 sliter.tex > /Users/philippe/Documents/workspace/NFP107-poly/06-optim/phil-iter.tex
	iconv -f utf-8 -t latin1 sloperateurs.tex > /Users/philippe/Documents/workspace/NFP107-poly/06-optim/phil-operateurs.tex
	iconv -f utf-8 -t latin1 sltrifusion.tex > /Users/philippe/Documents/workspace/NFP107-poly/06-optim/phil-trifusion.tex
	iconv -f utf-8 -t latin1 slalgojoin.tex > /Users/philippe/Documents/workspace/NFP107-poly/06-optim/phil-algojoin.tex
	iconv -f utf-8 -t latin1 sltraitrequete.tex > /Users/philippe/Documents/workspace/NFP107-poly/07-query_proc/phil-traitrequete.tex
	iconv -f utf-8 -t latin1 sloptim.tex > /Users/philippe/Documents/workspace/NFP107-poly/07-query_proc/phil-optim.tex
	iconv -f utf-8 -t latin1 sloptiora.tex > /Users/philippe/Documents/workspace/NFP107-poly/07-query_proc/phil-optiora.tex
	iconv -f utf-8 -t latin1 sltransactions.tex > /Users/philippe/Documents/workspace/NFP107-poly/09-concurrence/phil-transactions.tex
	iconv -f utf-8 -t latin1 sltransanomalies.tex > /Users/philippe/Documents/workspace/NFP107-poly/09-concurrence/phil-anomalies.tex
	iconv -f utf-8 -t latin1 slisolation.tex > /Users/philippe/Documents/workspace/NFP107-poly/09-concurrence/phil-isolation.tex
	iconv -f utf-8 -t latin1 slconcmec.tex > /Users/philippe/Documents/workspace/NFP107-poly/09-concurrence/phil-concmec.tex
	iconv -f utf-8 -t latin1 slconcalgo.tex > /Users/philippe/Documents/workspace/NFP107-poly/09-concurrence/phil-concalgo.tex
	iconv -f utf-8 -t latin1 slrp.tex > /Users/philippe/Documents/workspace/NFP107-poly/09-concurrence/phil-rp.tex
	rm -f /Users/philippe/Documents/workspace/NFP107-poly/figs-philippe/*.*	
	cd ../figures; ./cnv2ps.sh
	cp ../figures/*.png /Users/philippe/Documents/workspace/NFP107-poly/figs-philippe
	cp ../figures/*.eps /Users/philippe/Documents/workspace/NFP107-poly/figs-philippe
	
PARTS = $(wildcard tex/*.tex)
FIGURES = $(wildcard fi-*.fig)
FIGURESPS = ${FIGURES:.fig=.eps}
SERVEUR=http://magellan.cnam.fr:8080/ecom/xml/officiel/Samples

.PREFIXES: se- $(PREFIXES)
.SUFFIXES: .fig .tex .ps .pa .dvi .xml .html .view $(SUFFIXES)

.fig.ps:
	fig2dev -Lps $< > $*.ps

all:	slstock slindex sloptiora sleval slea slddl slplsql


%.dvi: %.tex
	latex  $*.tex

%.pdf: %.ps
	ps2pdf $*.ps

%.ps: %.dvi
	dvips $*.dvi -o

clean:
	\rm -f *.vrb *.aux *.bbl *.blg *.dvi *.log *.ps *.snm *.out *.nav *.toc *~ *.pdf *.pyg*
	rm -Rf _minted*
	




