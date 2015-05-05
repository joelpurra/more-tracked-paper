# [Swedes Online: You Are More Tracked Than You Think](https://github.com/joelpurra/more-tracked-paper)

This paper is written by [Joel Purra](http://joelpurra.com/) and [Niklas Carlsson](https://www.ida.liu.se/~nikca/). It based on [Joel Purra's master's thesis](http://joelpurra.com/projects/masters-thesis/).

Decided to put the work in progress online - comments, suggestions and pull requests welcome!

Stay updated by watching this repository.



## Generating `paper.pdf`

Tables and figures are rendered separately from the paper, and then included.


```bash
# Render tables by parsing the tex twice.
pdflatex tables.tex
!!
#open tables.pdf

# Rendering figures/figures-ng requires -shell-escape.
pdflatex -shell-escape figures.tex
#open figures.pdf

pdflatex -shell-escape figures-ng.tex
#open figures-ng.pdf
```


```bash
# Render main paper by parsing the tex twice.
pdflatex paper.tex
!!
open paper.pdf
```




---

Copyright (c) 2014, 2015 [Joel Purra](http://joelpurra.com/). Released under the [Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)](https://creativecommons.org/licenses/by-nc-nd/4.0/) license.
