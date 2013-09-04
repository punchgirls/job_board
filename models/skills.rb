require "json"

skills = ["ABAP", "ASP", "ASP.NET",
  "ActionScript", "Ada", "Android", "Apache", "ApacheConf",
  "Apex", "AppleScript", "Arc", "Arduino", "Assembly",
  "Augeas", "AutoHotkey", "Awk", "Batchfile", "Befunge",
  "BigTable", "BlitzMax", "Boo", "Brainfuck", "Bro", "C",
  "C#", "C++", "C-ObjDump", "C2hs Haskell", "CLIPS", "CMake",
  "CSS", "CakePHP", "Ceylon", "CherryPy", "ChucK", "Clojure",
  "Cobol", "CoffeeScript", "ColdFusion", "Common Lisp", "Coq",
  "CouchDB", "Cpp-ObjDump", "Cuba", "Cucumber", "Cython",
  "D", "D-ObjDump", "DCPU-16 ASM", "DOT", "Darcs Patch",
  "Dart", "Delphi", "Diff", "Django", "Dylan",
  "Ecere Projects", "Ecl", "Eiffel", "Elixir", "Elm",
  "Emacs Lisp", "Erlang", "Ext GWT", "F#", "FBML",
  "Factor", "Fancy", "Fantom", "Forth", "Fortran",
  "GAS", "Genshi", "Gentoo Ebuild", "Gentoo Eclass",
  "Gettext Catalog", "Go", "Gosu", "Groff", "Groovy",
  "Groovy Server Pages", "HTML", "HTML+Django",
  "HTML+ERB", "HTML+PHP", "HTTP", "Haml", "Handlebars",
  "Haskell", "Haxe", "IIS", "INI", "IRC log", "Io",
  "Ioke", "J2EE", "JSON", "Java", "Java Server Pages",
  "JavaScript", "Julia", "Kotlin", "LLVM", "Lasso",
  "Less", "LilyPond", "Linux", "Lisp",
  "Literate CoffeeScript", "Literate Haskell",
  "LiveScript", "Logos", "Logtalk", "Lua", "Makefile",
  "Mako", "MariaDB", "Markdown", "Matlab", "Max",
  "Microsoft SQL Server", "MiniD", "Mirah", "MongoDB",
  "Monkey", "Moocode", "MoonScript", "MySQL",
  "Myghty", "NSIS", "Nemerle", "Nginx", "Nimrod",
  "NoSQL", "Nu", "NumPy", "OCaml", "ObjDump",
  "Objective-C", "Objective-J", "Omgrofl", "Opa",
  "OpenCL", "OpenEdge ABL", "Oracle", "PHP", "Parrot",
  "Parrot Assembly", "Parrot Internal Representation",
  "Pascal", "Perl", "Pike", "PogoScript", "PostgreSQL",
  "PowerShell", "Prolog", "Puppet", "Pure Data",
  "Python", "Python traceback", "R", "RHTML", "Racket",
  "Ragel in Ruby Host", "Raw token data", "Rebol",
  "Redcode", "Redis", "Rexx", "Rouge", "Ruby",
  "Ruby on Rails", "Rust", "SCSS", "SQL", "Sage",
  "Sass", "Scala", "Scheme", "Scilab", "Self", "Shell",
  "Sinatra", "Smalltalk", "Smarty", "Standard ML",
  "Struts", "SuperCollider", "TOML", "TXL", "Tcl",
  "Tcsh", "TeX", "Tea", "Textile", "Turing", "Twig",
  "TypeScript", "Unix", "VHDL", "Vala", "Verilog",
  "VimL", "Visual Basic", "Windows", "XHP", "XML",
  "XProc", "XQuery", "XS", "XSLT", "Xtend", "YAML",
  "Zend", "eC", "edn", "fish", "jQuery", "mupad",
  "ooc", "reStructuredText"]

tags = []

skills.each do |skill|
  tags << { name: skill }
end

SKILLS = tags.to_json
