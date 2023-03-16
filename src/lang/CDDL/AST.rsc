module lang::CDDL::AST

import ParseTree;
import lang::CDDL::Syntax;

data Deck
  = deck(ID name, list[Element] elements);

data Element
  = e_dimension(ID name, list[Symbol] symbols)
  | e_cardType(ID name, list[ID] dimensions, list[LayoutRule] layoutRules)
  | e_card(ID name, ID cardType, list[ContentRule] contentRules)
  | e_cards(ID name, ID cardType, Where where);
  
data Where
  = where_none()
  | where_amounts(list[Amount] amounts);

data Amount
  = amount(Symbol s, int val);

data LayoutRule
  = layoutRule(Vertical vertical, Horizontal horizontal, Content content);
  
data ContentRule
  = contentRule(ID dimension, Symbol symbol);
  
data Horizontal
  = middle() | left()| right();
  
data Vertical
  =  top() | center() |  bottom();

data Size
  = small() | large() | huge();

data Content
  = c_name(ID name)
  | c_str(String string)
  | c_concat(Content lhs, Content rhs)
  | c_resize(Size size, Content content)
  | c_color(ID color, Content content)
  | c_img(Content content)
  | c_text(Content content);
  
data String
  = string(str val);

data Symbol
  = symbol(str val); 

data ID
  = id(str val);

public Deck cddl_build(loc file)
  = implode(#Deck, cddl_parse(file));