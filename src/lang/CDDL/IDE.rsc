module lang::CDDL::IDE

import util::IDE;
import lang::CDDL::Syntax;
import lang::CDDL::AST;
import lang::CDDL::Generator;
import lang::CDDL::Printer;
import IO;

public str CDDL_NAME = "Card Deck Design Language";
public str CDDL_EXT  = "cddl";

public void cddl_register()
{
  registerLanguage(CDDL_NAME, CDDL_EXT, lang::CDDL::Syntax::cddl_parse);
}

public void cddl_generate(loc file)
{
  Deck deck = cddl_build(file);
  
  list[Card] cards = generate(deck);
  
  str latex = print(deck, cards);
 
  loc tgtLoc = file;
  tgtLoc.extension = "tex";
  
  writeFile(tgtLoc, latex);
}