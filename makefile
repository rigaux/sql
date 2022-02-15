all : do_md

do_md : 
	$(MAKE) $(patsubst %.rst,%.md,$(shell find -name '*.rst'))

%.md : %.rst
	@echo ; echo -n "Converting '$*' from rst to md"
	@-pandoc -s -o $*.md $*.rst

# This is used to debug when an error in the csv-table

files = sql-ancien relationnel alg sql

cp :
	for f in $(files) ; do cp ./supports/sql/$$f.md ../mooc-1-fondamentaux/bloc_1_repr_donnees_information/1-4_bases_de_donnees/supports/sql ; done

tst :
	for f in $(files) ; do \
	 rm -rf tmp/$$f ; mkdir -p tmp/$$f ; cd tmp/$$f ;\
	 csplit ../../supports/sql/$$f.rst '/.. csv-table::/' '{*}' ;\
	 for g in xx* ; do echo "Doing $$f/$$g" ; mv $$g $$g.rst ; pandoc -s -o $$g.md $$g.rst ; done ;\
	  cd ../.. ;\
	done ; ok=

# This was used to copy the 1st time do NOT use anymor ebecause manual edition has been made

#	rsync --archive ./figures ./supports ../mooc-1-fondamentaux/bloc_1_repr_donnees_information/1-4_bases_de_donnees
#	cd ../mooc-1-fondamentaux/bloc_1_repr_donnees_information/1-4_bases_de_donnees ; clean.sh ; git pull ; git commit -a -m 'update cours BD Philippe Rigaux' ; git push
#	$(BROWSER) https://gitlab.com/mooc-nsi-snt/portail/-/pipelines/new
