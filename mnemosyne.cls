% Mnemosyne Class
%
% A memoir-based documentclass for poetry with verse numbering in the margin.
%
% TODO: add links
%
% (c) Gambhiro Bhikkhu, 2014
% gambhiro@ratanagiri.org.uk
%
% LPPL LaTeX Pubic Project Licence
%

% ==============
% Identification
% ==============

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{mnemosyne}[2014/02/01 v0.1 A memoir-based documentclass for poetry with verse numbering in the margin.]

% ========================
% Preliminary Declarations
% ========================

% =======
% Options
% =======

\RequirePackage{pgfopts}
\RequirePackage{calc}

\pgfkeys{
  /ARU/.cd,
  pagePreset/.default=largepage,% "largepage": 6x9in, "smallpage": 5.25x8in
  pagePreset/.store in=\ARU@pagePreset,
  babelLanguage/.default=british,
  babelLanguage/.store in=\ARU@babelLanguage,
}

% Pass all unknown options to memoir
\DeclareOption*{%
  \PassOptionsToClass{\CurrentOption}{memoir}
}

\ProcessPgfOptions{/ARU}
\ProcessOptions\relax

% ======================
% All Other Declarations
% ======================

\LoadClass[11pt,twoside]{memoir}

\RequirePackage{book-core-first}

\RequirePackage{longtable}

%% For the first letter of a chapter, a decorative big initial letter, a few lines deep with lettrine.

\RequirePackage{lettrine}

\setcounter{DefaultLines}{3}
\renewcommand{\DefaultLoversize}{0.15}
\renewcommand{\DefaultLraise}{0}
\renewcommand{\DefaultLhang}{0.4}
\renewcommand{\LettrineFontHook}{\dropFont\color{drop}}
\renewcommand{\LettrineTextFont}{\scshape\color{capsline}}

% === Custom commands and environments ===

\newenvironment{packeditemize}%
{\begin{itemize}%
  \setlength{\itemsep}{1pt}%
  \setlength{\parskip}{0pt}%
  \setlength{\parsep}{0pt}%
}{\end{itemize}}

\def\gobble@spaces{\@ifnextchar\space{\@gobble\gobble@spaces}{}}
\newcommand{\verseref}[1]{\mbox{}\marginpar{\vspace*{-0.5\marginparpush}\vspace*{1.2pt}\oldNumFont #1.}\gobble@spaces}
\newcommand{\firstverseref}[2][0pt]{\marginpar{\vspace*{#1}\oldNumFont #2.}}

\newlength\yshiftvref

\newenvironment{firstdhpverse}[2][0pt]{%
\setlength\yshiftvref{-22pt + #1}
\noindent
\firstverseref[\yshiftvref]{#2}
\hspace*{\verseOddInnerMargin}
\begin{minipage}{85mm}
\noindent}
{\end{minipage}
\vspace*{-\baselineskip}\vspace*{\vgap}\vspace*{0.5mm}}

\renewenvironment{verse}[1][\linewidth]{%
  \refstepcounter{verse}%
  \setcounter{poemline}{0}\refstepcounter{poemline}%
  \setcounter{vslineno}{1}%
  \let\\=\@vscentercr
  \list{}{\itemsep     \z@
          \itemindent  -\vindent
          \listparindent\itemindent
          \leftmargin   \vleftmargin
          \parsep       \stanzaskip
          \ifdim #1<\linewidth%   %% short line
            \rightmargin        \z@
            \leftmargin         \linewidth
            \advance\leftmargin -#1\relax
            \advance\leftmargin -0.5\leftmargin
            \advance\leftmargin \vindent
          \else
            \ifdim #1>\linewidth%  %% long line
              \rightmargin \z@
              \leftmargin  \vindent
            \else%                   %% default
              \rightmargin \vrightmargin
              \advance\leftmargin \vindent
            \fi
          \fi}
  \item[]}{\endlist}

\newlength\dhpvleftm
\newlength\dhpvrightm

\newenvironment{dhpverse}[1][\linewidth]{%
  \ifthenelse{\isodd{\thepage}}%
  {\setlength{\dhpvleftm}{\verseOddInnerMargin}%
   \setlength{\dhpvrightm}{\verseOddOuterMargin}}%
  {\setlength{\dhpvleftm}{\verseEvenOuterMargin}%
   \setlength{\dhpvrightm}{\verseEvenInnerMargin}}%
  \refstepcounter{verse}%
  \setcounter{poemline}{0}\refstepcounter{poemline}%
  \setcounter{vslineno}{1}%
  \let\\=\@vscentercr
  \list{}{\itemsep     \z@
          \itemindent  -\vindent
          \listparindent\itemindent
          \leftmargin   \dhpvleftm
          \parsep       \stanzaskip
          \ifdim #1<\linewidth%   %% short line
            \rightmargin        \z@
            \leftmargin         \linewidth
            \advance\leftmargin -#1\relax
            \advance\leftmargin -0.5\leftmargin
            \advance\leftmargin \vindent
          \else
            \ifdim #1>\linewidth%  %% long line
              \rightmargin \z@
              \leftmargin  \vindent
            \else%                   %% default
              \rightmargin \dhpvrightm
              \advance\leftmargin \vindent
            \fi
          \fi}
  \item[]}{\endlist}

\newcommand{\pali}[1]{\textit{#1}}
\newcommand{\suttaref}[1]{\hspace*{\fill}\footnotesize\begingroup #1 \endgroup\par}
\newcommand{\attrib}[1]{\nopagebreak{\raggedleft\footnotesize #1\par}}

\def\@vaggaName{}
\newcommand*{\setVaggaName}[1]{\def\@vaggaName{#1}}

\newcommand*{\chapterVagga}[2]{%
  \setVaggaName{\MakeLowercase{#2}}%
  \chapter{#1}%
  \markboth{#1}{#2}%
}

\newenvironment{notesdescription}%
               {\list{}{\labelwidth\z@
                        \itemindent-\leftmargin
                        \let\makelabel\notesdesc}}%
               {\endlist}
\newcommand*{\notesdesc}[1]{\notesdescriptionlabel #1}
\newcommand*{\notesdescriptionlabel}[3]{\hspace\labelsep
{\normalfont
{\small v}\space\textperiodcentered\space
{\oldNumFont #1}}\space\textperiodcentered\space
\textit{#2}\space\textperiodcentered\space \textit{#3}}

\newcommand{\addNotesFile}[1]{
\newpage
\thispagestyle{plain}
\loadgeometry{notes}
\Section{\notesname}
\vspace*{\baselineskip}
\input{#1}
\loadgeometry{verses}
}

% === Page styles ===

\makepagestyle{versepage}
  \makepsmarks{versepage}{%
    \def\chaptermark##1{\markboth{\memUChead{##1}}{}}%
    \def\tocmark{\markboth{\memUChead{\contentsname}}{\memUChead{\contentsname}}}%
    \def\lofmark{\markboth{\memUChead{\listfigurename}}{\memUChead{\listfigurename}}}%
    \def\lotmark{\markboth{\memUChead{\listtablename}}{\memUChead{\listtablename}}}%
    \def\bibmark{\markboth{\memUChead{\bibname}}{\memUChead{\bibname}}}%
    \def\indexmark{\markboth{\memUChead{\indexname}}{\memUChead{\indexname}}}%
    \def\sectionmark##1{\markright{\memUChead{##1}}}}
  \makepsmarks{versepage}{%
    \nouppercaseheads
    \createmark{chapter}{left}{nonumber}{}{}
    \createmark{section}{right}{nonumber}{}{}
    \createplainmark{toc}{both}{\contentsname}
    \createplainmark{lof}{both}{\listfigurename}
    \createplainmark{lot}{both}{\listtablename}
    \createplainmark{bib}{both}{\bibname}
    \createplainmark{index}{both}{\indexname}
    \createplainmark{glossary}{both}{\glossaryname}
  }
  \makeevenhead{versepage}{}{\small\itshape\leftmark}{}
  \makeoddhead{versepage}{}{\small\itshape\rightmark}{}
  \makeevenfoot{versepage}{}{\thepage}{}
  \makeoddfoot{versepage}{}{\thepage}{}

% === TOC settings ===

\newlength{\toctopskip}
\setlength{\toctopskip}{2\baselineskip}

\renewcommand{\printtoctitle}[1]{%
  \raggedright\vspace*{\toctopskip}%
  \hspace*{17pt}\parbox{0.85\linewidth}{%
    \raggedright\chapTitleFont\chaptitlesize\MakeUppercase{\soChapter{\contentsname}}%
  }%
}

\renewcommand{\cftchapterfont}{\chapTitleFont\chaptitlesize\color{chaptitle}}
\renewcommand{\cftchapterpagefont}{\tocPageNumFont\normalsize\color{chaptitle}}
\renewcommand{\cftchapterpresnum}[1]{}
\setlength{\cftchapternumwidth}{0pt}
\renewcommand{\chapternumberline}[1]{}

\setlength{\cftbeforechapterskip}{0.9em \@plus\p@}

\renewcommand{\cftsectiondotsep}{\cftnodots}
\renewcommand{\cftsectionpresnum}[1]{}
\setlength{\cftsectionnumwidth}{0pt}
\renewcommand{\numberline}[1]{}

\renewcommand{\cftsubsectiondotsep}{\cftnodots}
\renewcommand{\cftsubsectionpresnum}[1]{}
\setlength{\cftsubsectionnumwidth}{0pt}

% === Part and Book styles ===

\aliaspagestyle{book}{empty}
\aliaspagestyle{part}{empty}

\renewcommand*{\printbookname}{}
\renewcommand*{\printbooknum}{}

\renewcommand*{\booktitlefont}{\chapNameFont\chaptitlesize\color{chaptitle}}
\renewcommand*{\printbooktitle}[1]{\booktitlefont\MakeUppercase{\soChapter{#1}}}
\renewcommand*{\afterbookskip}{\vfil}

\renewcommand{\partnamefont}{\booktitlefont}
\renewcommand{\partnumfont}{\booktitlefont}
\renewcommand{\parttitlefont}{\booktitlefont}
\renewcommand{\printpartname}{\partnamefont\MakeUppercase{\soChapter{\partname}}}

\renewcommand{\printparttitle}[1]{\parttitlefont\MakeUppercase{\soChapter{#1}}}

% === Chapter styles ===

\setsecnumdepth{chapter}

\makechapterstyle{frontmatter}{%
  \chapterstyle{default}
  \setlength{\beforechapskip}{18mm}
  \addtolength{\beforechapskip}{-4\baselineskip}
  \setlength{\midchapskip}{2\baselineskip}
  \setlength{\afterchapskip}{2em}
  \renewcommand*{\chapnumfont}{\chapNumFont\chapnamesize}
  \renewcommand*{\chapnamefont}{\chapNameFont}
  \renewcommand*{\chaptitlefont}{\chapTitleFont\chaptitlesize}
  \renewcommand*{\printchaptername}{}
  \renewcommand*{\printchapternum}{\chapnumfont\color{chapnum}\raggedright\hspace*{17pt}\thechapter}
  \renewcommand*{\printchapternonum}{\chapnumfont\mbox{}\afterchapternum}
  \renewcommand*{\printchaptertitle}[1]{%
    \raggedright\hspace*{17pt}\parbox{0.85\linewidth}{\raggedright\chaptitlefont\color{chaptitle}\MakeUppercase{\soChapter{##1}}}}
}

\makechapterstyle{backmatter}{%
  \chapterstyle{frontmatter}%
  \printchapternonum%
}

\newdimen\chapheadindent
\setlength{\chapheadindent}{2em}

\makechapterstyle{versechapter}{%
  \chapterstyle{default}
  \setlength{\beforechapskip}{30pt}
  \setlength{\afterchapskip}{70pt}
  \setlength{\midchapskip}{15pt}
  \renewcommand*\printchaptername{}
  \renewcommand*\printchapternum{}
  \renewcommand*\afterchapternum{}
  \renewcommand*\chapnumfont{\HUGE\color{chapnum}}
  \renewcommand*\chaptitlefont{\normalfont\Large\color{chaptitle}}
  \newcommand*\chapsubtitlefont{\normalfont\itshape\large\color{chapsubtitle}}
  \renewcommand\printchaptertitle[1]{%
    \centering%
    \chaptitlefont\MakeUppercase{\soChapter{##1}}%
      \par\nobreak\vskip 7pt%
      \chapsubtitlefont\@vaggaName%
    \global\def\@vaggaName{}%
  }
}

\chapterstyle{default}

% === Section styles ===

\DeclareDocumentCommand\Section{oom}{
\IfNoValueTF{#1}
  {\section[#3]{\MakeUppercase{\soSection{#3}}}}
  {\IfNoValueTF{#2}{\section[#1]{\MakeUppercase{\soSection{#3}}}}{\section[#1][#2]{\MakeUppercase{\soSection{#3}}}}}
}

\setbeforesecskip{-3.5ex \@plus -1ex \@minus -.2ex}
\setaftersecskip{2.5ex \@plus .2ex}

\setsecheadstyle{\sectionFont\sectiontitlesize\color{chaptitle}}
\setsubsecheadstyle{\sectionFont\large\itshape\memRTLraggedright}
\setsubsubsecheadstyle{\sectionFont\normalsize\itshape\memRTLraggedright}

% === Page geometry and layout ===

\ifthenelse{\equal{\ARU@pagePreset}{blurbpocket}}{

  % Blurb Pocket size
  %
  % blurb.com pocket size:
  % 5.125 x 8.25 in
  % 369 x 594 pt

  % === normalsize ===

  \renewcommand{\normalsize}{%
     \@setfontsize\normalsize\@xipt{16}%
     \abovedisplayskip 11\p@ \@plus3\p@ \@minus6\p@
     \abovedisplayshortskip \z@ \@plus3\p@
     \belowdisplayshortskip 6.5\p@ \@plus3.5\p@ \@minus3\p@
     \belowdisplayskip \abovedisplayskip
     \color{textbody}
     \let\@listi\@listI}
  \normalsize

  % === indentations ===

  \setlength{\parindent}{1em}

  \setlength{\vgap}{1.5em}
  \setlength{\vindent}{\vgap}
  % for the verse env., used in the text
  \setlength{\vleftmargin}{2em}
  \newdimen\vrightmargin
  \setlength{\vrightmargin}{2em}

  % for the dhpverse env., used for the verses, alternating the margin
  % depending on whether the env. begins on recto or verso
  \newlength\verseOddOuterMargin
  \setlength{\verseOddOuterMargin}{5mm}
  \newlength\verseOddInnerMargin
  \setlength{\verseOddInnerMargin}{20mm}
  \newlength\verseEvenOuterMargin
  \setlength{\verseEvenOuterMargin}{5mm}
  \newlength\verseEvenInnerMargin
  \setlength{\verseEvenInnerMargin}{15mm}

  % === setup page layout ===

  %% Use inches! Using pt somehow produces a pdf that blurb.com recognizes as different size.
  \usepackage{geometry}
  \geometry{
    paperwidth=5.125in,
    paperheight=8.25in,
    outer=15mm,
    inner=17mm,
    marginparwidth=8mm,
    marginparsep=2mm,
    top=20mm,
    bottom=25mm,
    %showframe
  }
  \setstocksize{8.25in}{5.125in}

  \setlength{\marginparpush}{0.8\baselineskip}

}{
\ifthenelse{\equal{\ARU@pagePreset}{otherpocket}}{

  % Other Pocket size
  % ...

}{

  % other page sizes?

}}

% alias the pagestyles into semantic names, "where it is used"

\aliaspagestyle{normalpage}{versepage}

\pagestyle{normalpage}

\RequirePackage{book-core-last}

