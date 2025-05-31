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
\RequirePackage{titlesec}
\RequirePackage{tocloft}
\RequirePackage{etoolbox}
\RequirePackage{fancyhdr}
\RequirePackage{trimclip}
\RequirePackage{tabularx}

% Define a custom command to set the document title
% Usage: \settitle{Your Title} sets \title to "Your Title"
\newcommand{\settitle}[1]{\renewcommand{\title}{#1}}

% Define a custom command to set the document author
% Usage: \setauthor{Your Name} sets \author to "Your Name"
\newcommand{\setauthor}[1]{\renewcommand{\author}{#1}}

% Set the actual title and author of the recipe book
\settitle{My Recipe Book}               % Title metadata and reference
\setauthor{Niklas Hoefflin}            % Author metadata and reference

% Load the hyperref package to enable hyperlinks and set PDF metadata
\RequirePackage[
	hidelinks,                          % Hide link borders and colors (clean look)
	pdfauthor={\author},                % Set PDF metadata author from \author
	pdftitle={\title},                  % Set PDF metadata title from \title
	pdfsubject={A collection of delicious recipes},  % Subject metadata
	pdfkeywords={cooking, recipes, cookbook},        % Keywords metadata
	pdfproducer={XeLaTeX},              % Tool used to create PDF
	pdfcreator={XeLaTeX}                % Engine used to compile the document
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

\newfontfamily\fontpublicsans[
	Path=./fonts/,
	UprightFont = *-Regular.ttf,
	BoldFont    = *-Bold.ttf,
	ItalicFont  = *-Italic.ttf,
	BoldItalicFont = *-BoldItalic.ttf
]{PublicSans}

% Set page margins
\geometry{
	top=0cm,
	bottom=2cm,
	left=0cm,
	right=0cm
}

% Custom footer with centered page number
\pagestyle{fancy}
\fancyhf{}
\fancyfoot[C]{\fontsize{10}{12}\selectfont\thepage}

% Create a section that appears in the Table of Contents, but not visibly in the document
\newcommand\invisiblesection[1]{%
	\refstepcounter{section}%
	\addcontentsline{toc}{section}{\protect\numberline{\thesection}#1}%
	\sectionmark{#1}}

% Customize Table of Contents title appearance
\addto\captionsenglish{%
	\renewcommand{\contentsname}{\begin{center}{\fontseasons\fontsize{28}{32}\selectfont Table of Contents}\vspace{1.5cm}\end{center}}
}

% Customize appearance of TOC section entries
\makeatletter
\renewcommand{\l@section}[2]{%
	\addpenalty{\@secpenalty}%
	\addvspace{1em}%
	\begingroup
	\parindent=0pt
	\centering
	\makebox[\textwidth][c]{%
		\makebox[0.7\textwidth][c]{%
			\fontsize{14}{16}\selectfont\fontseasons{#1}%
			\hfill%
			{\fontsize{12}{14}\selectfont\fontpublicsans #2}%
		}
	}%
	\par
	\endgroup
}
\makeatother

% Command to produce the TOC with different margins, no page number on TOC page,
% then restore margins and reset page numbering
\newcommand{\customtableofcontents}{%
  \newgeometry{
    top=2cm,
    bottom=2cm,
    left=2cm,
    right=2cm
  }%
  \tableofcontents
  \thispagestyle{empty}% no page number on TOC page
  \newpage
  \restoregeometry
  \pagenumbering{arabic}% restart page numbering from 1
}

% Color used for the ingredients box background
\definecolor{bgIngredients}{HTML}{F8EDE9}

% Command to format and display the recipe title nicely
\newcommand{\recipeTitle}[1]{%
	\vspace{0.2cm}
	\noindent
	\begin{center}
		{\fontsize{28}{32}\selectfont\fontseasons\textbf{#1}}
	\end{center}
	\vspace{0.1cm}
}

% Define placeholders for recipe metadata, initially empty
\newcommand{\recipeName}{}      % The title of the recipe
\newcommand{\servings}{}        % Number of servings
\newcommand{\prepTime}{}        % Preparation time
\newcommand{\cookTime}{}        % Cooking time
\newcommand{\recipeImage}{}     % Filename/path of the recipe image

% Command to set all recipe metadata in one call
% Usage: \setRecipeMeta{Title}{Servings}{Prep Time}{Cook Time}{Image Filename}
\newcommand{\setRecipeMeta}[5]{%
	\renewcommand{\recipeName}{#1}% Set the recipe title
	\renewcommand{\servings}{#2}% Set the number of servings
	\renewcommand{\prepTime}{#3}% Set the preparation time
	\renewcommand{\cookTime}{#4}% Set the cooking time
	\renewcommand{\recipeImage}{#5}% Set the path to the recipe image
}

% Macro to define a single ingredient item in the ingredients list
\newcommand{\ingredient}[1]{\item{#1}}
% Macro to define a single cooking step in the steps list
\newcommand{\step}[1]{\item{#1}}

% Trick to auto scale recipe images
% https://tex.stackexchange.com/questions/547621/crop-an-image-to-exact-measurements
\newcommand\picdims[4][]{%
	\setbox0=\hbox{\includegraphics[#1]{#4}}%
	\clipbox{.5\dimexpr\wd0-#2\relax{} %
		.5\dimexpr\ht0-#3\relax{} %
		.5\dimexpr\wd0-#2\relax{} %
		.5\dimexpr\ht0-#3\relax}{\includegraphics[#1]{#4}}}

% Recipe environment
\newenvironment{recipe}{
	\clearpage
	\pagestyle{fancy}
	\phantomsection
	\refstepcounter{section}
	\addcontentsline{toc}{section}{\recipeName}
	\noindent\makebox[\paperwidth][l]{%
		\picdims[width=\paperwidth]{\paperwidth}{225.75pt}{\recipeImage}%
	}
	\vspace{0.2cm}
	\recipeTitle{\recipeName}
	\begin{center}
		\begin{minipage}{16cm}
			\begin{center}
				\begin{tabularx}{15cm}{@{}lXcXr@{}}
					\fontsize{12}{16}\selectfont SERVINGS: \servings      &   
					                                                      &   
					\fontsize{12}{16}\selectfont PREPPING TIME: \prepTime &   
					                                                      &   
					\fontsize{12}{16}\selectfont COOKING TIME: \cookTime
				\end{tabularx}
			\end{center}
			\vspace{-10pt}
			\begin{tikzpicture}
				\draw[very thick] (0,0) -- (16cm,0);
			\end{tikzpicture}
		\end{minipage}
	\end{center}
}

% Ingredients environment
\newenvironment{ingredients}{
	\vspace{1cm}
	\begin{tikzpicture}[remember picture, overlay]
		\node[fill=bgIngredients, opacity=1.0, anchor=north west, minimum width=6.5cm, minimum height=15cm, inner sep=0pt] 
		at ([xshift=50pt,yshift=-350pt]current page.north west) {};
	\end{tikzpicture}%
	\hspace{70pt}%
	\begin{minipage}[t]{0.25\textwidth}
		\section*{{\fontsize{22}{26}\selectfont\fontseasonslight Ingredients}}
		\begin{itemize}[label={}, itemsep=4pt, leftmargin=0pt]
			}{
		\end{itemize}
	\end{minipage}%
}

% Steps environment
\newenvironment{steps}{
	\hspace{34pt}%
	\begin{minipage}[t]{0.45\textwidth}
		\section*{{\fontsize{22}{26}\selectfont\fontseasonslight Instructions}}
		\begin{enumerate}[itemsep=4pt, leftmargin=13pt]
			}{%
		\end{enumerate}
	\end{minipage}
}