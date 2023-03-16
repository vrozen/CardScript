module lang::CDDL::Syntax

import ParseTree;

start syntax Deck
  = deck: "deck" ID name "{" Element* elements "}";

syntax Element
  = e_dimension: "dimension" ID name "=" "[" {Symbol "," }* symbols "]" ";"
  | e_cardType: "cardType" ID name "(" {ID ","}* dimensions ")" "{" (LayoutRule ";")* rules  "}"
  | e_card: "card" ID name "of" ID cardType "{" (ContentRule ";")* rules "}"
  | e_cards: "cards" ID name "of" ID cardType Where where ";";

syntax Where
  = where_none: /*default*/
  | where_amounts: "where" "[" { Amount ","}* amounts "]"; //default = 1, filter = 0

syntax Amount
  = amount: Symbol s "*" Integer val;

syntax LayoutRule
  = layoutRule: Vertical vertical Horizontal horizontal "=" Content content;
  
syntax ContentRule
  = contentRule: ID dimension "=" Symbol symbol;

syntax Horizontal
  = middle: /*default*/ | middle: "middle" | left: "left" | right: "right";
  
syntax Vertical
  = top: "top" | center: "center" | bottom: "bottom";

syntax Size
  = small: "small" | large: "large" | huge: "huge";

syntax Content
  = c_name: ID name
  | c_str: String string
  | left c_concat: Content lhs "+" Content rhs
  | c_resize: Size size "(" Content content ")"
  | c_color: "color" "(" ID color ")" "(" Content content ")"
  | c_img: "image" "(" Content content ")"
  | c_text: "text" "(" Content content ")";

lexical String
  = string: [\"] ![\"]* [\"] val;

lexical Symbol
  = symbol: (![*,;\]\ \t\r])* >> ([,]|[\]]|[*]|[;]) val \ Keyword;

lexical Integer
  = [0-9]+ val;

lexical ID
  = id: ([a-zA-Z_$] [a-zA-Z0-9_$]* !>> [a-zA-Z0-9_$]) val \ Keyword;
  
layout LAYOUTLIST
  = LAYOUT* !>> [\t-\n \r \ ] !>> "//" !>> "/*";

lexical LAYOUT
  = Comment
  | [\t-\n \r \ ];
  
lexical Comment
  // "/*" (![*] | [*] !>> [/])* "*/" 
  = "//" ![\n]* [\n];

keyword Keyword
  = "deck" | "dimension" | "cardType" | "cards" | "card" | "of"
  | "top" | "middle" | "bottom" 
  | "left" | "center"  | "right"
  | "small" | "large" | "huge"
  | "image" | "text" | "color";
  
public start[Deck] cddl_parse(str input, loc file) = 
  parse(#start[Deck], input, file);
  
public start[Deck] cddl_parse(loc file) = 
  parse(#start[Deck], file);
