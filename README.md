# [Swedes Online: You Are More Tracked Than You Think](https://github.com/joelpurra/more-tracked-paper)

This paper is written by [Joel Purra](http://joelpurra.com/) and [Niklas Carlsson](https://www.ida.liu.se/~nikca/). It based on [Joel Purra's master's thesis](http://joelpurra.com/projects/masters-thesis/).

Decided to put the work in progress online - comments, suggestions and pull requests welcome!

Stay updated by watching this repository.



## Generating paper.pdf

Requirements

- `git`
- [LyX](http://www.lyx.org/) with `lyx` in your `$PATH`.
- `pdflatex`
- [`-shell-escape` enabled for LyX's calls to `pdflatex`](http://tex.stackexchange.com/questions/16366/lyx-how-to-add-command-line-option-flag-for-latex-compiling) [(screenshot)](https://www.tug.org/PSTricks/main.cgi?file=pdf/pdfoutput#lyx).

```bash
./generate-pdfs.sh
open paper/paper.pdf
```

Errors are logged to `paper/generate-pdfs.sh.log`.



---

Copyright (c) 2014, 2015 [Joel Purra](http://joelpurra.com/). Released under the [Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)](https://creativecommons.org/licenses/by-nc-nd/4.0/) license.