.. _chap-coursIntroduction:


Pour mettre des questions:
 
  - le conf.py à utiliser,
  - des exemples dans questionnaire.rst, mais aussi dans Embedded_questions,
  - Scripts et Sphinx_ext à mettre dans le répertoire de votre projet (tout ce qui est dans ces répertoires n'est pas indispensable),
  - il y a des éléments en plus dans _static (à mettre aussi sur le serveur web),
  - modification de layout.html dans _templates (ajout de la ligne 
  
    .. code-block:: text
    
          <script type="text/javascript" src="{{ pathto('_static/dynsite.js', 1) }}"></script>)

  - je n'ai pas touché à agogo.css.

Pour chaque question, la bonne réponse est indiquée par ``:eqt:`C```.
Utiliser ``.. eqt::`` pour les questions à bonne réponse unique et 
``.. eqt-mc::`` pour les questions à bonnes réponses multiples. Chaque question doit avoir un 
identifiant unique (comme questionnaireAutoEvaluationQfouille1) dans le projet.

Pour Latex: l'extension pose probleme. Il faut donc définir une variable de configuration "latex"
et ajouter un "ifconfig" avant toutes les équations.

.. code-block:: text
             
      .. ifconfig:: latex in ('public')

Pour compiler en Latex, il suffit alors de passer la variable en "private" et de commenter
l'inclusion de l'extension eqt

####################
Cours - Introduction
####################

Some math :math:`\rightarrow x_{ij} \in \mathbb{R}` or :math:`\frac{1}{n}`

Some more

.. math::

   a^2 + b^2

             
.. ifconfig:: latex in ('public')

   .. eqt:: COD-integerencoding-videoeqt-eqt_11

      **Question 1** What is the representation of the number -127 in 2s
       complement with 8 bits? 

      A) :eqt:`I` `1000 0000`

      #) :eqt:`I` `1111 1111`

      #) :eqt:`C` `1000 0001`

      #) :eqt:`I` None of the above

