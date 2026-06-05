; Lit: css`...` → inject as real CSS (ecma queries map this to "styled" which has no parser)
(call_expression
  function: (identifier) @_tag
  (#eq? @_tag "css")
  arguments: (template_string) @injection.content
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.include-children)
  (#set! injection.language "css"))
