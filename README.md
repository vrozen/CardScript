# CardScript
CardScript is an effort towards Universal Card Game Design Laguage.
To investigate card game design tools, 
we have conducted a Fieldab on Digital Card Game Design
which has yielded several tool prototypes.
More information on the project can be found on this website: https://cardgamedesign.github.io

## Paper
We have described a Domain-Specific Language (DSL) approach towards CardScript in a short paper:

* Riemer van Rozen, Anders Bouwer, and Karel Millenaar. 2023. Towards a Unified Language for Card Game Design. In Foundations of Digital Games 2023 (FDG 2023), April 12–14, 2023, Lisbon, Portugal. ACM, 4 pages. https://doi.org/10.1145/3582437.3587185

### Card deck generator
Here, we share a tiny prototype that illustates how to automate one facet of card game design: card deck generation.
We intentionally take a step back from earlier more complex feature-rich prototypes
in order to illustrate how a DSL approach can help in creating a more extensive tool set.
The source code is supplementary material to the paper.

#### Running the generator
The prototype is constructed using Rascal, a meta-programming language and language workbench.
Please find more information here: https://www.rascal-mpl.org

First, we must first load the Card Deck Description Language (CDDL) by executing the following command on Rascal's REPL:
```
import lang::CDDL::IDE;
```

Next, we can generate the examples decks by executing the following commands.
```
cddl_generate(|project://CardScript/programs/OldMaid.cddl|);
cddl_generate(|project://CardScript/programs/FrenchDeck.cddl|);
```

This generates LaTeX sources OldMaid.tex and FrenchDeck.tex.
Compiling the LaTeX sources using a pdflatex yiels the PDFs included in the supplementary material of the paper.
