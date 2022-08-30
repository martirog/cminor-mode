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

(defun cminor--tag-beg ()
  "find the start of the start of the system verilog expression. this only looks at words for now(so I lied in the first sentece)"
  (let ((p
         (save-excursion
           (backward-word 1)
           (if (memq (preceding-char) '(?$ ?`))
               (backward-char))
           (point))))
    p))

(require 'icrib-buffer-and-tag-compleation nil t)
(if (featurep 'icrib-buffer-and-tag-compleation)
    (defun cminor--expand-abbrev (dummy)
      (let ((init-string (buffer-substring-no-properties (cminor--tag-beg) (point))))
        (icrib-buffer-and-tag-compleation init-string '("c-mode" "cc-mode" "c++-mode")))))

(defun cminor--tab ()
  "extend the verilog mode tab so that if the verilog-mode tab has no affect and we are at the end of a word we use the vminor--expand-abbrev function"
  (interactive)
  (let ((boi-point
           (save-excursion
             (back-to-indentation)
             (point))))
    (c-indent-line-or-region)
    (if (and
         (save-excursion
          (back-to-indentation)
          (= (point) boi-point))
         (looking-at "\\>"))
        (cminor--expand-abbrev nil))))

(define-minor-mode cminor-mode
  "set up verilog minor mode"
  :lighter " cmin"
  :keymap (let ((map (make-sparse-keymap)))
            (when (featurep 'icrib-buffer-and-tag-compleation)
                (define-key map "\t" 'cminor--tab))
  ;;          (define-key map (kbd "C-c a") 'hs-toggle-hiding)
            map)
  (cminor--setup-etags-wrapper)
  (setq-local tags-table-list
               (etags-wrapper-generate-tags-list cminor-path-to-repos))
  ;;(add-hook 'verilog-mode-hook 'hs-minor-mode)
  ;;(add-to-list 'hs-special-modes-alist (list 'verilog-mode (list verilog-beg-block-re-ordered 0) "\\<end\\>" nil 'verilog-forward-sexp-function))
  (flyspell-prog-mode))

(provide 'cminor-mode)
