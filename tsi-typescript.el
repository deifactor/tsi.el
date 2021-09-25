;;; tsi.el --- tree-sitter indentation -*- lexical-binding: t; -*-
;;; Summary:
;;; Commentary:
;;; Code:

(require 'tsi)

(defcustom tsi-typescript-indent-offset 2
  "Default indent level."
  :type 'number)

(defun tsi-typescript--get-indent-for (current-node parent-node)
  "Returns an indentation operation for the given CURRENT-NODE and PARENT-NODE."
  (let* ((current-type
          (tsc-node-type current-node))
         (parent-type
          (tsc-node-type parent-node)))

    (cond
     ((eq
       parent-type
       'arguments)
      (if (tsc-node-named-p current-node)
          tsi-typescript-indent-offset
        nil))

     ((eq
       parent-type
       'array)
      (if (tsc-node-named-p current-node)
          tsi-typescript-indent-offset
        nil))

     ((eq
       parent-type
       'arrow_function)
      (if (tsc-node-named-p current-node)
          tsi-typescript-indent-offset
        nil))

     ((eq
       parent-type
       'class_body)
      (if (tsc-node-named-p current-node)
          tsi-typescript-indent-offset
        nil))

     ((eq
       parent-type
       'export_clause)
      (if (tsc-node-named-p current-node)
          tsi-typescript-indent-offset
        nil))

     ((eq
       parent-type
       'export_statement)
      (if (tsc-node-named-p current-node)
          tsi-typescript-indent-offset
        nil))

     ((eq
       parent-type
       'if_statement)
      (if (and
           (tsc-node-named-p current-node)
           (not (eq
                 current-type
                 'else_clause)))
          tsi-typescript-indent-offset
        nil))

     ((eq
       parent-type
       'jsx_element)
      (if (and
           (tsc-node-named-p current-node)
           (not (eq
                 current-type
                 'jsx_closing_element)))
          tsi-typescript-indent-offset
        nil))

     ((eq
       parent-type
       'jsx_fragment)
      (if (tsc-node-named-p current-node)
          tsi-typescript-indent-offset
        nil))

     ((eq
       parent-type
       'jsx_opening_element)
      (if (and
           (tsc-node-named-p current-node)
           (not (eq
                 current-type
                 'jsx_closing_element)))
          tsi-typescript-indent-offset
        nil))

     ((eq
       parent-type
       'jsx_self_closing_element)
      (if (tsc-node-named-p current-node)
          tsi-typescript-indent-offset
        nil))

     ((eq
       parent-type
       'lexical_declaration)
      (if (tsc-node-named-p current-node)
          tsi-typescript-indent-offset
        nil))

     ((eq
       parent-type
       'named_imports)
      (if (tsc-node-named-p current-node)
          tsi-typescript-indent-offset
        nil))

     ((eq
       parent-type
       'object)
      (if (tsc-node-named-p current-node)
          tsi-typescript-indent-offset
        nil))

     ((eq
       parent-type
       'object_pattern)
      (if (tsc-node-named-p current-node)
          tsi-typescript-indent-offset
        nil))

     ((eq
       parent-type
       'object_type)
      (if (tsc-node-named-p current-node)
          tsi-typescript-indent-offset
        nil))

     ((eq
       parent-type
       'parenthesized_expression)
      (if (tsc-node-named-p current-node)
          tsi-typescript-indent-offset
        nil))

     ((eq
       parent-type
       'statement_block)
      (if (tsc-node-named-p current-node)
          tsi-typescript-indent-offset
        nil))

     ((eq
       parent-type
       'switch_body)
      (if (tsc-node-named-p current-node)
          tsi-typescript-indent-offset
        nil))

     ((eq
       parent-type
       'switch_case)
      (if (tsc-node-named-p current-node)
          tsi-typescript-indent-offset
        nil))

     ((eq
       parent-type
       'type_alias_declaration)
      (if (tsc-node-named-p current-node)
          tsi-typescript-indent-offset
        nil))

     ((eq
       parent-type
       'type_arguments)
      (if (tsc-node-named-p current-node)
          tsi-typescript-indent-offset
        nil))

     ((eq
       parent-type
       'ternary_expression)
      (if (or
           (equal
            (tsc-node-text current-node)
            "?")
           (equal
            (tsc-node-text current-node)
            ":"))
          tsi-typescript-indent-offset
        nil))

     ((eq
       parent-type
       'union_type)
      (if (tsc-node-named-p current-node)
          tsi-typescript-indent-offset
        nil))
;;      tsi-typescript-indent-offset)

     ((eq
       parent-type
       'variable_declarator)
      (if (tsc-node-named-p current-node)
          tsi-typescript-indent-offset
        nil))

     (t nil))))

;; exposed for testing purposes
;;;###autoload
(defun tsi-typescript--indent-line ()
  "Internal function.  Calculate indentation for the current line."
  (tsi-walk #'tsi-typescript--get-indent-for))

(defun tsi-typescript--outdent-line ()
  "Outdents by `tsi-typescript-indent-offset`."
  (interactive)
  (let* ((current-indentation
          (save-excursion
            (back-to-indentation)
            (current-column)))
         (new-indentation
          (max
           0
           (- current-indentation tsi-typescript-indent-offset))))
    (delete-region
     (progn (beginning-of-line) (point))
     (progn (back-to-indentation) (point)))
    (indent-to-column new-indentation)
    (back-to-indentation)))

;;;###autoload
(define-minor-mode tsi-typescript-mode
  "Use tree-sitter to calculate indentation for Typescript buffers."
  nil nil
  (make-sparse-keymap)
  (cond
   (tsi-typescript-mode
    ;; enabling mode
    ;; ensure tree-sitter is loaded
    (unless tree-sitter-mode
      (tree-sitter-mode))
    ;; update indent-line-function
    (setq-local
     indent-line-function
     #'tsi-typescript--indent-line)
    ;; add an outdent function
    (define-key tsi-typescript-mode-map (kbd "<S-iso-lefttab>") #'tsi-typescript--outdent-line)
    t)
   (t
    ;; disabling mode
    (setq-local
     indent-line-function
     (default-value 'indent-line-function)))))

(provide 'tsi-typescript)
;;; tsi-typescript.el ends here
