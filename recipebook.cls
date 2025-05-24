\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{recipebook}[2025/04/30 v1.0 A class for recipe books]

\LoadClass[a4paper]{article}

\RequirePackage[english]{babel}
\RequirePackage{graphicx}
\RequirePackage{geometry}
\RequirePackage{environ}
\RequirePackage{calc}
\RequirePackage{multicol}
\RequirePackage{enumitem}
\RequirePackage{xcolor}
\RequirePackage{fontspec}
\RequirePackage[most]{tcolorbox}
\RequirePackage{tikz}
\RequirePackage{xcolor}
\RequirePackage{titlesec}
\RequirePackage{tocloft}
\RequirePackage{etoolbox}
\RequirePackage{fancyhdr}

\newcommand{\settitle}[1]{\renewcommand{\title}{#1}}
\newcommand{\setauthor}[1]{\renewcommand{\author}{#1}}

\settitle{My Recipe Book}
\setauthor{Niklas Hoefflin}
\RequirePackage[
  colorlinks=false,
  linkcolor=blue,
  pdfauthor={\author},
  pdftitle={\title},
  pdfsubject={A collection of delicious recipes},
  pdfkeywords={cooking, recipes, cookbook},
  pdfproducer={LaTeX},
  pdfcreator={pdflatex}
]{hyperref}

% Fonts
\setmainfont[
  Path=./fonts/,
  UprightFont = *-Regular.ttf,
  BoldFont    = *-Bold.ttf,
  ItalicFont  = *-Italic.ttf,
  BoldItalicFont = *-BoldItalic.ttf
]{PublicSans}

\newfontfamily\fontseasons[
  Path=./fonts/,
  UprightFont = *Regular.ttf,
  BoldFont    = *Bold.ttf,
  ItalicFont  = *Italic.ttf,
  BoldItalicFont = *BoldItalic.ttf
]{TheSeasons}

\newfontfamily\fontseasonslight[
  Path=./fonts/,
  UprightFont = *Light.ttf,
  ItalicFont  = *LightItalic.ttf,
  BoldFont    = *Light.ttf
]{TheSeasons}

% Layout
\newlength{\picmargin}
\setlength{\picmargin}{15pt}
\newlength{\picwidth}
\setlength{\picwidth}{\paperwidth - 2\picmargin}

\geometry{
  top=0pt,
  bottom=2cm,
  left=\picmargin,
  right=\picmargin
}


\pagestyle{fancy}
\fancyhf{}

\fancyfoot[C]{\fontsize{10}{12}\selectfont \thepage}

\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}

\fancypagestyle{plain}{
  \fancyhf{}
\fancyfoot[C]{\fontsize{10}{12}\selectfont \thepage}
  \renewcommand{\headrulewidth}{0pt}
  \renewcommand{\footrulewidth}{0pt}
}

\newcommand\invisiblesection[1]{%
  \refstepcounter{section}%
  \addcontentsline{toc}{section}{\protect\numberline{\thesection}#1}%
  \sectionmark{#1}}

\addto\captionsenglish{%
  \renewcommand{\contentsname}{\fontsize{28}{32}\selectfont\fontseasons{Table of Contents}}
}

\renewcommand{\cftsecfont}{}
\renewcommand{\cftsecpagefont}{\large}

\makeatletter
% Redefine section ToC entry to have dots
\renewcommand{\l@section}[2]{%
  \@dottedtocline{1}{2pt}{2em}{#1}{#2}%
}
\makeatother

% Colors
\definecolor{bgIngredients}{HTML}{F8EDE9}
\definecolor{textColor}{HTML}{000000}

% Macros
\newcommand{\recipeTitle}[1]{
  \vspace{0.2cm}
  \parbox{\picwidth}{
    \centering
    \fontsize{28}{32}\selectfont\fontseasons{\textbf{#1}}}
}

% === Recipe metadata ===
\newcommand{\recipeName}{}
\newcommand{\servings}{}
\newcommand{\prepTime}{}
\newcommand{\cookTime}{}
\newcommand{\recipeImage}{}

\newcommand{\setRecipeMeta}[5]{%
  \renewcommand{\recipeName}{#1}%
  \renewcommand{\servings}{#2}%
  \renewcommand{\prepTime}{#3}%
  \renewcommand{\cookTime}{#4}%
  \renewcommand{\recipeImage}{#5}%
}

\newenvironment{recipe}{
\clearpage
\pagestyle{fancy}
\phantomsection
\refstepcounter{section}
\addcontentsline{toc}{section}
{\protect\numberline{\thesection} \recipeName}
  \begin{center}
    \makebox[\textwidth]{\includegraphics[width=\paperwidth]{\recipeImage}}
  \end{center}

  \vspace{0.6cm}
  \hspace{-\picmargin}
  \recipeTitle{\recipeName}

  \begin{center}
    \begin{tabular}{c c c}
      \fontsize{12}{16}\selectfont{SERVINGS: \servings} \hspace{2.5cm} &
      \fontsize{12}{16}\selectfont{PREPPING TIME: \prepTime} &
      \hspace{.5cm} \fontsize{12}{16}\selectfont{COOKING TIME: \cookTime}
    \end{tabular}
    \vspace{2pt}
    \begin{tikzpicture}
      \draw[very thick] (4,0) -- (\linewidth+15pt,0);
    \end{tikzpicture}
  \end{center}

  \vspace{1cm} % optional vertical spacing before

}

% Ingredients environment

\newenvironment{ingredients}{
  \begin{tikzpicture}[remember picture, overlay]
    \node[fill=bgIngredients, opacity=1.0, anchor=north west, minimum width=6cm, minimum height=15cm, inner sep=0pt] 
    at ([xshift=50pt,yshift=-345pt]current page.north west) {};
  \end{tikzpicture}%
  \hspace{35pt}%
  \begin{minipage}[t]{0.25\textwidth}
    \section*{{\fontsize{22}{26}\selectfont\fontseasonslight Ingredients}}
    \begin{itemize}[label={}, itemsep=4pt, leftmargin=0pt]
}{
    \end{itemize}
  \end{minipage}%
}


% Steps environment
\newenvironment{steps}{
\hspace{35pt}%
\begin{minipage}[t]{0.45\textwidth}
  \section*{{\fontsize{22}{26}\selectfont\fontseasonslight Instructions}}
  \begin{enumerate}[itemsep=4pt, leftmargin=13pt]
}{%
  \end{enumerate}
  \end{minipage}
}


\newcommand{\ingredient}[1]{\item \textcolor{textColor}{#1}}

\newcommand{\step}[1]{\item \textcolor{textColor}{#1}}

