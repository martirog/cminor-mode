;; -*- lexical-binding: t -*-

(require 'etags-wrapper)
(defvar cminor-ctags-verilog-def nil
  "define how ctags should find system verilog tags")

(defvar cminor-path-to-repos nil
  "list of cons: repos to search for systemverilog files . exclude list")

(defvar cminor-file-extention
  '("c" "h" "ch" "cpp" "cc")
  "file extentions to use in the search for files to tag")

(defvar cminor-tag-path (concat (getenv "HOME") "/") ;nil
  "path to puth the TAGS file")

(defvar cminor-tag-file-post-fix "cminor_TAGS"
  "name of the TAGS file")

(defvar cminor-use-vc-root-for-tags t
  "you only want tags for the current repo and that repo uses GIT")

(defun cminor--setup-etags-wrapper()
  (setq-local etags-wrapper-switche-def cminor-ctags-verilog-def)
  (setq-local etags-wrapper-path-to-repos cminor-path-to-repos)
  (setq-local etags-wrapper-file-extention cminor-file-extention)
  (setq-local etags-wrapper-tag-path cminor-tag-path)
  (setq-local etags-wrapper-tag-file-post-fix cminor-tag-file-post-fix)
  (setq-local etags-wrapper-use-vc-root-for-tags cminor-use-vc-root-for-tags))

(define-minor-mode cminor-mode
  "set up verilog minor mode"
  :lighter " cmin"
  ;;:keymap (let ((map (make-sparse-keymap)))
  ;;          (define-key map "\t" 'cminor-verilog-tab)
  ;;          (define-key map (kbd "C-c a") 'hs-toggle-hiding)
  ;;          map)
  (cminor--setup-etags-wrapper)
  (setq tags-table-list
               (etags-wrapper-generate-tags-list cminor-path-to-repos))
  ;;(add-hook 'verilog-mode-hook 'hs-minor-mode)
  ;;(add-to-list 'hs-special-modes-alist (list 'verilog-mode (list verilog-beg-block-re-ordered 0) "\\<end\\>" nil 'verilog-forward-sexp-function))
  (flyspell-prog-mode))

(provide 'cminor-mode)
