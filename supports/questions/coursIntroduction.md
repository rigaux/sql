::: {#chap-coursIntroduction}
Pour mettre des questions:
:::

> -   le conf.py à utiliser,
>
> -   des exemples dans questionnaire.rst, mais aussi dans
>     Embedded\_questions,
>
> -   Scripts et Sphinx\_ext à mettre dans le répertoire de votre projet
>     (tout ce qui est dans ces répertoires n\'est pas indispensable),
>
> -   il y a des éléments en plus dans \_static (à mettre aussi sur le
>     serveur web),
>
> -   modification de layout.html dans \_templates (ajout de la ligne
>
>     ``` {.text}
>     <script type="text/javascript" src="{{ pathto('_static/dynsite.js', 1) }}"></script>)
>     ```
>
> -   je n\'ai pas touché à agogo.css.

Pour chaque question, la bonne réponse est indiquée par `` :eqt:`C ``[.
Utiliser ]{.title-ref}[.. eqt::]{.title-ref}[ pour les questions à bonne
réponse unique et ]{.title-ref}[.. eqt-mc::]{.title-ref}\` pour les
questions à bonnes réponses multiples. Chaque question doit avoir un
identifiant unique (comme questionnaireAutoEvaluationQfouille1) dans le
projet.

Pour Latex: l\'extension pose probleme. Il faut donc définir une
variable de configuration \"latex\" et ajouter un \"ifconfig\" avant
toutes les équations.

``` {.text}
.. ifconfig:: latex in ('public')
```

Pour compiler en Latex, il suffit alors de passer la variable en
\"private\" et de commenter l\'inclusion de l\'extension eqt

Cours - Introduction
====================

Some math $\rightarrow x_{ij} \in \mathbb{R}$ or $\frac{1}{n}$

Some more

$$a^2 + b^2$$

::: {.ifconfig}
latex in (\'public\')

::: {.eqt}
COD-integerencoding-videoeqt-eqt\_11

**Question 1** What is the representation of the number -127 in 2s

:   complement with 8 bits?

A)  `I`{.interpreted-text role="eqt"} [1000 0000]{.title-ref}
B)  `I`{.interpreted-text role="eqt"} [1111 1111]{.title-ref}
C)  `C`{.interpreted-text role="eqt"} [1000 0001]{.title-ref}
D)  `I`{.interpreted-text role="eqt"} None of the above
:::
:::
