; Lit: css`...` tagged template → real CSS highlighting
((tagged_template_expression
  tag: (identifier) @_tag
  (#eq? @_tag "css")
  template: (template_string) @injection.content)
 (#offset! @injection.content 0 1 0 -1)
 (#set! injection.include-children)
 (#set! injection.language "css"))

; Lit: html`...` tagged template → HTML highlighting
((tagged_template_expression
  tag: (identifier) @_tag
  (#eq? @_tag "html")
  template: (template_string) @injection.content)
 (#offset! @injection.content 0 1 0 -1)
 (#set! injection.include-children)
 (#set! injection.language "html"))
