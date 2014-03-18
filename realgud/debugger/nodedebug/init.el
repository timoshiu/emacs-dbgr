;;; Copyright (C) 2010, 2011 Rocky Bernstein <rocky@gnu.org>
;;; Regular expressions for Bash shell debugger: nodedebug

(eval-when-compile (require 'cl))

(require 'load-relative)
(require-relative-list '("../../common/regexp"
			 "../../common/loc"
			 "../../common/init")
		       "realgud-")
(require-relative-list '("../../lang/posix-shell") "realgud-lang-")

(defvar realgud-nodedebug-pat-hash)
(declare-function make-realgud-loc-pat (realgud-loc))

(defvar realgud-nodedebug-pat-hash (make-hash-table :test 'equal)
  "Hash key is the what kind of pattern we want to match:
backtrace, prompt, etc.  The values of a hash entry is a
realgud-loc-pat struct")

;; Regular expression that describes a nodedebug location generally shown
;; before a command prompt.
;; For example:
;;   (break in /etc/init.d/apparmor:35):
(setf (gethash "loc" realgud-nodedebug-pat-hash)
      (make-realgud-loc-pat
       :regexp "\\((break in \\([^:]+\\):\\([0-9]*\\))\\)"
       :file-group 2
       :line-group 3))

;; Regular expression that describes a nodedebug command prompt
;; For example:
;;   (nodedebug)
(setf (gethash "prompt" realgud-nodedebug-pat-hash)
      (make-realgud-loc-pat
       :regexp   "(nodedebug) "
       ))

;;  Regular expression that describes a "breakpoint set" line
(setf (gethash "brkpt-set" realgud-nodedebug-pat-hash)
      (make-realgud-loc-pat
       :regexp "^Breakpoint \\([0-9]+\\) set in file \\(.+\\), line \\([0-9]+\\).\n"
       :num 1
       :file-group 2
       :line-group 3))

;; Regular expression that describes a debugger "delete" (breakpoint) response.
;; For example:
;;   Removed 1 breakpoint(s).
(setf (gethash "brkpt-del" realgud-nodedebug-pat-hash)
      (make-realgud-loc-pat
       :regexp "^Removed \\([0-9]+\\) breakpoint(s).\n"
       :num 1))

;; Regular expression that describes a debugger "backtrace" command line.
;; For example:
;; (nodedebug) bt
;; ##0 hello at 05_read_dir.js:6
;; ##1 main at 05_read_dir.js:37

(setf (gethash "debugger-backtrace" realgud-nodedebug-pat-hash)
      (make-realgud-loc-pat
       :regexp 	(concat realgud-shell-frame-start-regexp
			realgud-shell-frame-num-regexp "[ ]?"
			"\\(.*\\)"
			realgud-shell-frame-file-regexp
			"\\(?:" realgud-shell-frame-line-regexp "\\)?"
			)
       :num 2
       :file-group 4
       :line-group 5)
      )

;; Regular expression that for a termination message.
(setf (gethash "termination" realgud-nodedebug-pat-hash)
       "^nodedebug: That's all, folks...\n")

(setf (gethash "font-lock-keywords" realgud-nodedebug-pat-hash)
      '(
	;; The frame number and first type name, if present.
	;; E.g. ->0 in file `/etc/init.d/apparmor' at line 35
	;;      --^-
	("^\\(->\\|##\\)\\([0-9]+\\) "
	 (2 realgud-backtrace-number-face))

	;; File name.
	;; E.g. ->0 in file `/etc/init.d/apparmor' at line 35
	;;          ---------^^^^^^^^^^^^^^^^^^^^-
	("[ \t]+\\(in\\|from\\) file `\\(.+\\)'"
	 (2 realgud-file-name-face))

	;; File name.
	;; E.g. ->0 in file `/etc/init.d/apparmor' at line 35
	;;                                         --------^^
	;; Line number.
	("[ \t]+at line \\([0-9]+\\)$"
	 (1 realgud-line-number-face))
	))

(setf (gethash "nodedebug" realgud-pat-hash) realgud-nodedebug-pat-hash)

(defvar realgud-nodedebug-command-hash (make-hash-table :test 'equal)
  "Hash key is command name like 'quit' and the value is
  the nodedebug command to use, like 'quit!'")

(setf (gethash "quit" realgud-nodedebug-command-hash) "quit")
(setf (gethash "exit" realgud-nodedebug-command-hash) "exit")
(setf (gethash "nodedebug" realgud-command-hash realgud-nodedebug-command-hash))

(provide-me "realgud-nodedebug-")
