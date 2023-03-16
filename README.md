# CardScript
CardScript is an effort towards Universal Card Game Design Laguage.
To investigate card game design tools, 
we have conducted a Fieldab on Digital Card Game Design.
More information on the project can be found on this website: https://cardgamedesign.github.io

Here, we share a tiny prototype that illustates how to automate one facet of card game design: card deck generation.
The code represents supplementary material to the paper:

* Riemer van Rozen, Anders Bouwer, and Karel Millenaar. 2023. Towards a Unified Language for Card Game Design. In Foundations of Digital Games 2023 (FDG 2023), April 12–14, 2023, Lisbon, Portugal. ACM, New York, NY, USA, 5 pages. https://doi.org/10.1145/3582437.3587185

The prototype is constructed using Rascal, a meta-programming language and language workbench.
Please find more information here: https://www.rascal-mpl.org

To generate example decks, execute the following commands on Rascal's REPL:

```
import lang::CDDL::IDE;
cddl_generate(|project://CardScript/programs/OldMaid.cddl|);
cddl_generate(|project://CardScript/programs/FrenchDeck.cddl|);
```

This loads the Card Deck Description Language (CDDL) and generates LaTeX sources OldMaid.tex and FrenchDeck.tex.
Compiling the LaTeX sources using a PDFLatex yiels the PDFs included in the supplementary material of the paper.
