Pour créer un fichier de type sujet. Il faut créer un fichier 'YYYY-MM_NFP107.tex' avec l'année et le mois de l'examen.

En entête de ce fichier doit se trouver :

\entete{<FOD ou HTT>}{<mois> <année>}


Les corrections sont de type :

\begin{correction} 
\end{correction}

!!!! Il faut que le \begin soit au début de la ligne, il subsiste des erreurs de compilation s'il y a un espace ou une tabulation


Pour que la numérotation soit correcte, les items doivent être des : \begin{enumerate}
 

Pour compiler le sujet :
1) éditer le fichier 'sujet.tex' pour y changer l'include : "\include{YYY-MM_NFP107}"
2) commenter ou décommenter la ligne "\excludecomment{correction}" pour les corrections

Les intitulés et les recommandations du sujet seront automatiquement ajoutés.


Pour compiler les annales :
1) éditer le fichier 'annales.tex' pour y ajouter la ligne du sujet correspondant : "\include{YYY-MM_NFP107}"
2) commenter ou décommenter la ligne "\excludecomment{correction}" pour les corrections

Le chapitrage, les liens et les numérotations sont automatiquement calculés.