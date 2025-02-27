(import-macros {: when-not : set! : setlocal! : augroup! : au!} :my.macros)

(local {: large-file?} (require :my.utils))
(local expand vim.fn.expand)

;; cspell:ignore blinkon
(set! :guiCursor ["n-v-c-sm-o:block"
                  "i-ci-ve:ver25"
                  "r-cr:hor20"
                  "a:blinkon0-Cursor/lCursor"])

(set! :termguicolors true)

;; Lines
(set! :title true)
(set! :titleLen 30)
;; ;; showtabline:
;; ;;   2: always show the current status. (default)
;; ;;   3: show the global status line.
;; (set! :showTabline 2)
(set! :cursorline true)
(set! :ruler true)

;; Columns
(set! :number true)
(set! :signColumn :yes)
;; (set! :signColumn :number)
(set! :colorColumn :+1)

;; (set! :ambiWidth :double)
;; (set! :emoji false)

(set! :completeOpt [;; Show popup menu for candidates with more than one match.
                    :menu
                    ;; Show popup menu even when there's only one match.
                    :menuone
                    ;; Only works with either 'menu' or 'menuone' or both.
                    :preview
                    :longest])

(set! :complete [;; Current buffer
                 "."
                 ;; Buffers in other windows
                 :w
                 ;; Loaded buffers
                 :b
                 ;; Unloaded buffers
                 :u])

;; ;; Buffers not in the buffer list
;; :U
;; ;; included files
;; :i
;; ;; tag
;; :t])

(set! :pumWidth 12)
(set! :pumHeight 9)
(set! :pumBlend 25)
(set! :winBlend 20)

(set! :previewHeight 28)
;; (set! :more false)

(set! :splitBelow true)
(set! :splitRight true)
;; (set! :equalAlways false)

(set! :virtualEdit :block)

;; Cmdline ///1
;; Notify when &report lines or more are changed at once.
(set! :report 0)
;; (set! :cmdHeight 0)
(set! :showCmd false)
;; Cmdline Completion
;; (set! :wildMenu false)
(set! :wildMode "list:longest")
;; (set! :incCommand :split)

;; Syntax ///1
;; If it takes over &redrawtime to redraw, `:syntax off` will run.
(set! :redrawTime 8000)

;; No syntax to letters over &synmaxcol.
(set! :synMaxCol 256)

;; Wrap ///1
;; &wrap makes vim slow editing file containing very long lines.
(set! :wrap false)
(augroup! :myWrapInSmallFile
          (au! :BufReadPost
               #(let [max-bytes (* 1024 800)]
                  (when-not (large-file? max-bytes
                                         (vim.fn.bufnr (expand :<afile>)))
                            (setlocal! :wrap true)))))

(set! :lineBreak true)
(set! :showBreak "﬌")
;; &breakindent keeps indent virtually on line-break
(set! :breakIndent true)
;; ;; &breakat only accepts ASCII characters.
(set! :breakAt+ "&=")

;; TODO: Set chars without nerd fonts if unavailable.
(set! :listChars ;
            {:tab " "
             :nbsp ""
             :extends "☛"
             :precedes "☚"
             :conceal "_"})

;; fillchars:
;;   eob: EndOfBuffer (default: "~")
;; TODO: Does it matter when hl-EndOfBuffer is linked to hl-Ignore?
(set! :fillChars {:eob " "})

;; Motion ///1
(set! :whichWrap "")
(set! :showMatch true)
(set! :matchTime 1)
;; (set! :matchPairs+ "<:>")
;; ;; With &startofline on, cursor to the head of line on such jump as `gg`, `M`.
;; (set! :startOfLine true)

(set! :wrapScan false)
(set! :ignoreCase true)
(set! :smartCase true)
(set! :incSearch true)
(set! :hlSearch true)

;; Indent ///1

;; o/O/i_<CR> copies current indent
(set! :autoIndent true)
;; ignores &expandtab but use current indent char(tab/spaces)
(set! :copyIndent true)
;; Indent depends on the last char of the prev line.
;; Indent as 'C-indenting'; ignored if either &cindent or &cindentexpr is set.
(set! :smartIndent true)

;; Insert spaces, instead of a tab-char
(set! :expandTab true)
;; <BS> deletes spaces as &shiftwidth
(set! :smartTab true)
;; for '</>' indent, insert spaces as &shiftwidth
(set! :shiftRound true)

;; They affects `<TAB>` and `<BS>`
;; <TAB> inserts the number of spaces
(set! :tabStop 2)
;; >>/<< inserts the number of spaces; use &tabstop if 0
(set! :shiftWidth 2)
;; <TAB> is replaced by spaces while less than the value; use &shiftwidth if negative
(set! :softTabStop 2)

;; Format ///1
;; (set! :joinspaces true)
(set! :textWidth 79)
(set! :spellLang "en_us,cjk")

;; Related help tags:
;;    Related sections:
;;        fo-table, autoformat
;;
;;    Related options:
;;        textwidth, autoindent, formatlistpat
;;
;;    Related commands:
;;        gq, join

(set! :formatOptions ;
      [;; Don't break after one-letter word but breaks before the char
       :1
       ;; Ignore indent of the first line of paragraph; requires &autoindent
       :2
       ;; Enable 'gq' in Normal mode
       :q
       ;; "a" ;; Enable 'autoformat', which, with 'c' flag, only happens for comments; 'a' without 'c' should not for usual program codes
       ;; "t" ;; Auto-wrap as &textwidth
       ;; Auto-wrap comments as &textwidth with comment leader
       :c
       ;; "w" ;; Paragraph continues with trailing whitespace (affects 'a'); ends with non-space
       ;; Wrap when you enter a blank at/before ...?
       :b
       ;; Don't wrap at start insert mode even when over &textwidth
       :l
       ;; Break numbered lists as &formatlistpat; requires &autoindent
       :n
       ;; Insert comment leader by \<CR> in Normal mode
       :r
       ;; "o" ;; Insert comment leader by o/O in Normal mode
       ;; "v" ;; Only break a line at a blank
       ;; Don't break lines at single spaces after '.' (e.g., Mr. Feynman)
       :p
       ;; Join lines removing comment leader
       :j
       ;; Also break at multi-byte(MB) char
       :m
       ;; "M" ;; Join without spaces around for MB char; overrules 'B'
       ;; Join without a space between two MB char); overrules 'M'
       :B])

(augroup! :myKeepFormatOptions ;
          (au! :BufWinEnter #(setlocal! :formatOptions<))
          (au! :OptionSet [:formatoptions] #(setlocal! :formatOptions<)))

;; Shortmess ///1
;; shortmess: Short Message
(set! :shortMess ;
      [;; (default) Use "(3 of 5)" instead of "(file 3 of 5)"
       :f
       ;; (default) Use "[noeol]" instead of "[Incomplete last line]"
       :i
       ;; (default) Use "999L, 888C" instead of "999 lines, 888 characters"
       :l
       ;; ;; Use "[+]" instead of "[Modified]"
       ;; :m
       ;; (default) Use "[New]" instead of "[New File]"
       :n
       ;; Use "[RO]" instead of "[readonly]"
       :r
       ;; ;; Use "[w]" instead of "written" for file write message and "[a]" instead of "appended" for ':w >> file' command
       ;; :w
       ;; (default) Use "[dos]" instead of "[dos format]", "[unix]" instead of "[unix format]" and "[mac]" instead of "[mac format]".
       :x
       ;; ;; all of the above abbreviations
       ;; :a
       ;; (default) Overwrite message for writing a file with subsequent message for reading a file (useful for ":wn" or when 'autowrite' on)
       :o
       ;; (default) Message for reading a file overwrites any previous message. Also for quickfix message (e.g., ":cn").
       :O
       ;; ;; Don't give "search hit BOTTOM, continuing at TOP" or "search hit TOP, continuing at BOTTOM" messages; when using the search count do not show "W" after the count message (see S below)
       ;; :s
       ;; (default) Truncate file message at the start if it is too long to fit on the command-line, "<" will appear in the left most column. Ignored in Ex mode.
       :t
       ;; (default) Truncate other messages in the middle if they are too long to fit on the command line.  "..." will appear in the middle. Ignored in Ex mode.
       :T
       ;; ;; Don't give "written" or "[w]" when writing a file
       ;; :W
       ;; ;; Don't give the "ATTENTION" message when an existing swap file is found.
       ;; :A
       ;; Don't give the intro message when starting Vim |:intro|.
       :I
       ;; Don't give |ins-completion-menu| messages.  For example, " XXX completion (YYY)", "match 1 of 2", "The only match", "Pattern not found", "Back at original", etc.
       :c
       ;; ;; Use "recording" instead of "recording @a"
       ;; :q
       ;; ;; Don't show search count message when searching, e.g. "[1/5]"))
       ;; :S))
       ;; (default) Don't give the file info when editing a file, like `:silent` was used for the command; note that this also affects messages from autocommands
       :F])

;; Encoding ///1
(set! :encoding :utf-8)
(set! :fileEncodings [:ucs-bom
                      :utf-8
                      :euc-jp
                      ;; sjis: Shift-JIS
                      :sjis
                      :cp932
                      :default
                      :latin1])

(vim.cmd.language "time en_US.UTF-8")
