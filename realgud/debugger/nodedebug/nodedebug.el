;;; Copyright (C) 2011, 2013 Rocky Bernstein <rocky@gnu.org>
;;  `nodedebug' Main interface to nodedebug via Emacs
(require 'load-relative)
(require-relative-list '("../../common/helper") "realgud-")
(require-relative-list '("../../common/track") "realgud-")
(require-relative-list '("core" "track-mode") "realgud-nodedebug-")
;; This is needed, or at least the docstring part of it is needed to
;; get the customization menu to work in Emacs 23.
(defgroup nodedebug nil
  "The node debugger: nodedebug (node debug --debug-gud)"
  :group 'processes
  :group 'dbgr
  :version "23.1")

;; -------------------------------------------------------------------
;; User definable variables
;;

(defcustom nodedebug-command-name
  ;;"nodedebug --emacs 3"
  "node debug --debug-gud"
  "File name for executing the Ruby debugger and command options.
This should be an executable on your path, or an absolute file name."
  :type 'string
  :group 'nodedebug)

(declare-function nodedebug-track-mode (bool))
(declare-function nodedebug-query-cmdline  'realgud-nodedebug-core)
(declare-function nodedebug-parse-cmd-args 'realgud-nodedebug-core)
(declare-function realgud-run-process 'realgud-core)

;; -------------------------------------------------------------------
;; The end.
;;

;;;###autoload
(defun realgud-nodedebug (&optional opt-command-line no-reset)
  "Invoke the nodedebug shell debugger and start the Emacs user interface.

String COMMAND-LINE specifies how to run nodedebug.

Normally command buffers are reused when the same debugger is
reinvoked inside a command buffer with a similar command. If we
discover that the buffer has prior command-buffer information and
NO-RESET is nil, then that information which may point into other
buffers and source buffers which may contain marks and fringe or
marginal icons is reset."
  (interactive)
  (let* ((cmd-str (or opt-command-line (nodedebug-query-cmdline "nodedebug")))
	 (cmd-args (split-string-and-unquote cmd-str))
	 (parsed-args (nodedebug-parse-cmd-args cmd-args))
	 (script-args (cdr cmd-args))
	 (script-name (car script-args))
	 (cmd-buf))
    (realgud-run-process "nodedebug" script-name cmd-args
		      'nodedebug-track-mode no-reset)
    ))

(defalias 'nodedebug 'realgud-nodedebug)

(provide-me "realgud-")
