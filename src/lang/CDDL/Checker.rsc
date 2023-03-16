module lang::CDDL::Checker

public data SymbolTable =
  symbolTable(
    list[loc] tdefs, //type definitions
    list[loc] tuses, //type uses
    rel[loc, loc] tusedef //use --> def
  );
  
public Deck desugar(Deck deck) = 
  visit(deck)
  {
    case Where: where_none() => where_amounts([])
  };