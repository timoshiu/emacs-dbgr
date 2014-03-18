;;; Copyright (C) 2012-2014 Rocky Bernstein <rocky@gnu.org>
;;; Bash Debugger tracking a comint or eshell buffer.

(eval-when-compile (require 'cl))
(require 'load-relative)
(require-relative-list '(
			 "../../common/cmds"
			 "../../common/menu"
			 "../../common/track"
			 "../../common/track-mode"
			 )
		       "realgud-")
(require-relative-list '("core" "init") "realgud-nodedebug-")
(require-relative "../../lang/posix-shell" nil "realgud-lang-")

(declare-function realgud-track-set-debugger 'realgud-track-mode)
(declare-function realgud-track-mode-setup   'realgud-track-mode)
(declare-function realgud-posix-shell-populate-command-keys
		  'realgud-lang-posix-shell)

(realgud-track-mode-vars "nodedebug")
(realgud-posix-shell-populate-command-keys nodedebug-track-mode-map)

(declare-function realgud-track-mode(bool))

(defun nodedebug-track-mode-hook()
  (if nodedebug-track-mode
      (progn
	(use-local-map nodedebug-track-mode-map)
	(message "using nodedebug mode map")
	)
    (message "nodedebug track-mode-hook disable called"))
)

(define-minor-mode nodedebug-track-mode
  "Minor mode for tracking ruby debugging inside a process shell."
  :init-value nil
  ;; :lighter " nodedebug"   ;; mode-line indicator from realgud-track is sufficient.
  ;; The minor mode bindings.
  :global nil
  :group 'nodedebug
  :keymap nodedebug-track-mode-map

  (realgud-track-set-debugger "nodedebug")
  (if nodedebug-track-mode
      (progn
        (realgud-track-mode-setup 't)
        (nodedebug-track-mode-hook))
    (progn
      (setq realgud-track-mode nil)
      ))
)

(provide-me "realgud-nodedebug-")
