\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{atomtikz}[TikZ template class for Atom's diagrams]

\LoadClass[tikz, crop, border = {2pt 2pt 2pt 2pt}]{standalone}

% Fonts
\RequirePackage[no-math]{fontspec}
\setmainfont{Zilla Slab}
\defaultfontfeatures{Mapping = tex-text, Scale = MatchLowercase}

\defaultfontfeatures{Mapping = tex-text, Scale = MatchLowercase}
\usepackage{mathtools}
\usepackage[math-style = ISO, mathrm = sym, warnings-off = {mathtools-colon}]{unicode-math} % mathrm = sym is for compatibility with physics package
\setmathfont[Scale = MatchLowercase]{Concrete-Math.otf}
\setoperatorfont\symscr

% TikZ Keys
\usetikzlibrary{calc}
\usetikzlibrary{math}
\usetikzlibrary{decorations.pathreplacing, calligraphy}
\tikzstyle{axis} = [-stealth, thick]
\tikzstyle{dot} = [circle, fill, inner sep = 1pt]
\tikzstyle{brace} = [decorate, decoration = {brace, raise = 1pt, amplitude = 2pt}]
\tikzstyle{mbrace} = [decorate, decoration = {brace, mirror, raise = 1pt, amplitude = 2pt}] 

% Mathematical Notations Keys
\RequirePackage{physics}
\newcommand{\Dd}[1]{\symrm{\Delta}#1}