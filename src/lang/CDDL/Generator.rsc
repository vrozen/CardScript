module lang::CDDL::Generator

import lang::CDDL::AST;
import util::Eval;
import IO;
import Node;
import Map;

public data Card =
  card(ID typ, list[tuple[ID dimension, Symbol symbol]] symbols);

public list[Card] generate(Deck deck)
{
  list[Card] cards = [];
  
  visit(deck.elements)
  {    
    case Element e: e_cards(ID name, ID cardType, Where where):
    {
      list[tuple[ID, list[Symbol]]] cardsDimensions = generateDimensions(deck, e);
      
      cards += generateCards(cardType, cardsDimensions);      
    }
  }
  
  return cards;
}

private list[Card] generateCards(ID typeName, list[tuple[ID, list[Symbol]]] cardsDimensions)
{
  list[Card] rcards = [];
  
  program = 
    "import lang::CDDL::AST; import lang::CDDL::Generator; "+
    "[[<for(tuple[ID, list[Symbol]] dim <- cardsDimensions){><if(dim[1]!=[]){>\<id(\"<dim[0].val>\"),<dim[0].val>\>,<}><}>"[..-1]+"]"+ 
    "| <for(tuple[ID, list[Symbol]] dim <- cardsDimensions){><if(dim[1]!=[]){><dim[0].val> \<- <delAnnotationsRec(dim[1])>,<}><}>"[..-1]+
    "];";
  
  println(program);
  
  if(result(list[list[tuple[ID,Symbol]]] cards) := eval(program))
  {
    rcards = [card(delAnnotationsRec(typeName), symbols) | symbols <- cards];
  }
  else
  {
    println("Error, no match");
  }
  
  return rcards;
}

private Element lookupType(Deck deck, ID typeName)
{
  visit(deck)
  {
    case Element e: e_cardType(typeName, _, _):
      return e;
  }
}

private Element lookupDimension(Deck deck, ID dimName)
{
  visit(deck)
  {
    case Element e: e_dimension(dimName, list[Symbol] symbols):
      return e;
  }
}

private list[tuple[ID, list[Symbol]]] generateDimensions(Deck deck,  
  Element cards: e_cards(_, ID cardType, Where where))
{
  Element typ = lookupType(deck, cardType);
 
  list[tuple[ID, list[Symbol]]] cardsDimensions = [];
  
  for(ID dimName <- typ.dimensions)
  {
    Element dim = lookupDimension(deck, dimName);
  
    list[Symbol] cardsSymbols = generateSymbols(dim, cards);
    
    cardsDimensions += [<dimName, cardsSymbols>];
  }
  
  return cardsDimensions;
}

private list[Symbol] generateSymbols
(
  Element dim: e_dimension(ID dimName, list[Symbol] symbols),
  Element cards: e_cards(_, ID cardType, Where where: where_amounts(list[Amount] amounts))
)
{
  //default symbols at 1
  map[Symbol, int] symbolMap = (s : 1 | Symbol s <- symbols);
    
  //override dimension 
  for(Amount a: amount(Symbol symbol, int val) <- amounts)
  {
    if(symbol.val == dimName.val)
    {
      for(Symbol s <- symbols)
      {
        symbolMap[s] = val;
      }
    }
  } 
    
  //override symbols
  for(Amount a: amount(Symbol s, int val) <- amounts)
  {
    if(s in symbols)
    {
      if(val == 0)
      {
        symbolMap = delete(symbolMap, s);
      }
      else
      {
        symbolMap[s] = val;
      }
    }
  }
  
  return [s | Symbol s <- symbols, s in symbolMap, int i <- [0..symbolMap[s]]];
}
