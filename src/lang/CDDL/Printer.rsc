module lang::CDDL::Printer

import lang::CDDL::AST;
import lang::CDDL::Generator;

import IO;

public str print (Deck deck, list[Card] cards)
{
  str latex =
    "\\documentclass[12pt]{letter}
    '\\usepackage{geometry}
    '  \\geometry{
    '  a4paper,
    '  total={210mm,297mm},
    '  left=0mm,
    '  right=0mm,
    '  bottom=0mm,
    '  top=10mm
    '}
    '\\usepackage{tikz}
    '\\usepackage{fdsymbol} %var suits
    '\\usepackage{wasysym} %smiley
    '
    '\\newcommand{\\diamonds}{\\color{red}$\\vardiamondsuit$\\color{black}} 
    '\\newcommand{\\hearts}{\\color{red}$\\varheartsuit$\\color{black}} 
    '\\newcommand{\\clubs}{$\\clubsuit$} 
    '\\newcommand{\\spades}{$\\spadesuit$}
    '\\newcommand{\\card}[9]
    '{
    '  \\parbox[c][29mm]{20mm}{\\scalebox{3}{\\centering #1}}
    '  \\parbox[c][29mm]{20mm}{\\scalebox{3}{\\centering #2}}
    '  \\parbox[c][29mm]{20mm}{\\scalebox{3}{\\centering #3}}
    '
    '  \\parbox[c][29mm]{10mm}{\\scalebox{3}{\\centering #4}}
    '  \\parbox[c][29mm]{25mm}{\\scalebox{3}{\\centering #5}}
    '  \\parbox[c][29mm]{20mm}{\\scalebox{3}{\\centering #6}}
    '
    '  \\parbox[c][29mm]{10mm}{\\scalebox{3}{\\centering #7}} 
    '  \\parbox[c][29mm]{10mm}{\\scalebox{3}{\\centering #8}} 
    '  \\parbox[c][29mm]{20mm}{\\scalebox{3}{\\centering #9}}
    '}
    '
    '
    '\\begin{document}
    '\n";
    
  int i = 0;
  for(Card card <- cards)
  {
    Element typ = lookupType(deck, card.typ);
    
    latex += print(typ, card);
    
    i=i+1;
    if(i%3==0)
    {
      latex += "\n\n\\vspace*{-140pt}";
    }
    if(i%9==0)
    {
      latex += "\\clearpage";
    }
    
    
  }
  
  latex += "\\end{document}";
  
  return latex;
}

private Element lookupType(Deck deck, ID typeName)
{
  visit(deck)
  {
    case Element e: e_cardType(t, _, _):
    {
      if(t.val == typeName.val)
      {
        return e;
      }
    }
  }
}

private str print (
  Element typ: e_cardType(ID name, list[ID] dimensions, list[LayoutRule] layoutRules),
  Card card
) =
  "\\begin{minipage}[t]{69mm}
  '  \\centering
  '  \\begin{tikzpicture}
  '    [
  '      very thick,
  '      rounded corners=20pt,
  '      card/.style=
  '      {
  '        align=center,
  '        text width=64mm,
  '        inner sep=0pt,
  '        minimum height=89mm,
  '        minimum width=64mm,
  '        text centered,
  '        fill=white,
  '        text=black,
  '        draw,
  '      },
  '      txt/.style=
  '      {
  '        align=center,
  '        text width=64mm,
  '        inner sep=0pt,
  '        minimum height=10mm,
  '        minimum width=64mm,
  '        text centered,
  '        text=black,
  '        font=\\small\\sffamily\\bfseries
  '      }
  '    ],
  '    \\node[card](TheCard)
  '    {
  '      \\card{<getValue(top(), left(), typ, card)>}
  '            {<getValue(top(), middle(), typ, card)>}
  '            {<getValue(top(), right(), typ, card)>}
  '            {<getValue(center(), left(), typ, card)>}
  '            {<getValue(center(), middle(), typ, card)>}
  '            {<getValue(center(), right(), typ, card)>}
  '            {<getValue(bottom(), left(), typ, card)>}
  '            {<getValue(bottom(), middle(), typ, card)>}
  '            {<getValue(bottom(), right(), typ, card)>}
  '    };
  '    \\node[txt, below of=TheCard, node distance=89mm](TheTitle)
  '    {
  '      %title here
  '    };
  '  \\end{tikzpicture}
  '\\end{minipage}\n";
  
private str getValue(Vertical v, Horizontal h, Element typ, Card card)
{
  str r = "~ ";
  for(LayoutRule rule: layoutRule(v, h, Content content)  <- typ.layoutRules)
  {
    r += print(content, card);
  }
  return r;
}

private str print(c_name(ID name), Card card) = 
  "<for(tuple[ID dim, Symbol val] dimVal <- card.symbols){><if(dimVal.dim.val == name.val){><texCode(dimVal.val.val)><}><}>";

private str texCode("♦") = "\\diamonds";
private str texCode("♥") = "\\hearts";
private str texCode("♣") = "\\clubs";
private str texCode("♠") = "\\spades";
private str texCode("🙂") = "\\smiley";
private default str texCode(str s) = s;

private str print(c_str(String string), Card card) = string.val[1..-1];

private str print(c_concat(Content lhs, Content rhs), Card card) = 
  print(lhs, card) + print(rhs, card);

private str print(c_resize(Size size, Content content), Card card) =
  "<print(size)><print(content, card)>";

private str print(c_img(Content content), Card card) = "";
  //"\\includegraphics{<print(content, card)>}";

private str print(c_text(Content content), Card card) = print(content, card);

private str print(small()) = "\\small ";
private str print(large()) = "\\large ";
private str print(huge()) = "\\huge ";

