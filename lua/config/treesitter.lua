-- =============================================================================
-- lua/config/treesitter.lua
-- =============================================================================
--
-- Override the javascript "injections" query.
--
-- The bundled ecma/injections.scm injects the `html` parser into any
-- `tagname`...`` tagged template (so lit's `html`...`` gets HTML highlighting
-- and folding). But lit's `.prop=${}` / `?bool=${}` / `@evt=${}` bindings
-- aren't valid HTML: the html parser hits error-recovery on the first one and
-- permanently stops recognizing tag/attribute names for the rest of the
-- template, so everything after that point loses highlighting entirely.
--
-- This is the same query as upstream ecma+jsx, except "html" is added to the
-- generic auto-injection exclusion list (alongside "svg" and "css"), so
-- html`...`` stays plain JS template-string highlighting (still correct for
-- `${...}` expressions) instead of partially-broken HTML highlighting.

vim.treesitter.query.set("javascript", "injections", [[
(((comment) @_jsdoc_comment
  (#lua-match? @_jsdoc_comment "^/[*][*][^*].*[*]/$")) @injection.content
  (#set! injection.language "jsdoc"))

((comment) @injection.content
  (#set! injection.language "comment"))

; tag(`...`), tag`...`, sql(`...`), etc. -- excluding svg, css and html
; (lit's html`...`` has bindings that aren't valid HTML and break the html
; parser's highlighting partway through, so leave it as plain JS)
(call_expression
  function: (identifier) @injection.language
  arguments: [
    (arguments
      (template_string) @injection.content)
    (template_string) @injection.content
  ]
  (#lua-match? @injection.language "^[a-zA-Z][a-zA-Z0-9]*$")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.include-children)
  (#not-any-of? @injection.language "svg" "css" "html"))

; svg`...` or svg(`...`)
(call_expression
  function: (identifier) @_name
  (#eq? @_name "svg")
  arguments: [
    (arguments
      (template_string) @injection.content)
    (template_string) @injection.content
  ]
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.include-children)
  (#set! injection.language "html"))

; Vercel PostgreSQL
; foo.sql`...` or foo.sql(`...`)
(call_expression
  function: (member_expression
    property: (property_identifier) @injection.language)
  arguments: [
    (arguments
      (template_string) @injection.content)
    (template_string) @injection.content
  ]
  (#eq? @injection.language "sql")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.include-children))

; Sanity CMS GROQ query
; defineQuery(`...`)
(call_expression
  function: (identifier) @_name
  (#eq? @_name "defineQuery")
  arguments: (arguments
    (template_string) @injection.content)
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.include-children)
  (#set! injection.language "groq"))

; gql`...` or gql(`...`)
(call_expression
  function: (identifier) @_name
  (#eq? @_name "gql")
  arguments: [
    (arguments
      (template_string) @injection.content)
    (template_string) @injection.content
  ]
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.include-children)
  (#set! injection.language "graphql"))

(call_expression
  function: (identifier) @_name
  (#eq? @_name "hbs")
  arguments: (template_string) @injection.content
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.include-children)
  (#set! injection.language "glimmer"))

; css`<css>` -- Lit uses real CSS grammar, not styled-components
(call_expression
  function: (identifier) @_name
  (#eq? @_name "css")
  arguments: (template_string) @injection.content
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.include-children)
  (#set! injection.language "css"))

; keyframes`<css>` -- styled-components
(call_expression
  function: (identifier) @_name
  (#eq? @_name "keyframes")
  arguments: (template_string) @injection.content
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.include-children)
  (#set! injection.language "styled"))

; styled.div`<css>`
(call_expression
  function: (member_expression
    object: (identifier) @_name
    (#eq? @_name "styled"))
  arguments: ((template_string) @injection.content
    (#offset! @injection.content 0 1 0 -1)
    (#set! injection.include-children)
    (#set! injection.language "styled")))

; styled(Component)`<css>`
(call_expression
  function: (call_expression
    function: (identifier) @_name
    (#eq? @_name "styled"))
  arguments: ((template_string) @injection.content
    (#offset! @injection.content 0 1 0 -1)
    (#set! injection.include-children)
    (#set! injection.language "styled")))

; styled.div.attrs({ prop: "foo" })`<css>`
(call_expression
  function: (call_expression
    function: (member_expression
      object: (member_expression
        object: (identifier) @_name
        (#eq? @_name "styled"))))
  arguments: ((template_string) @injection.content
    (#offset! @injection.content 0 1 0 -1)
    (#set! injection.include-children)
    (#set! injection.language "styled")))

; styled(Component).attrs({ prop: "foo" })`<css>`
(call_expression
  function: (call_expression
    function: (member_expression
      object: (call_expression
        function: (identifier) @_name
        (#eq? @_name "styled"))))
  arguments: ((template_string) @injection.content
    (#offset! @injection.content 0 1 0 -1)
    (#set! injection.include-children)
    (#set! injection.language "styled")))

((regex_pattern) @injection.content
  (#set! injection.language "regex"))

((template_string) @injection.content
  (#lua-match? @injection.content "^`#graphql")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.include-children)
  (#set! injection.language "graphql"))

; el.innerHTML = `<html>`
(assignment_expression
  left: (member_expression
    property: (property_identifier) @_prop
    (#any-of? @_prop "outerHTML" "innerHTML"))
  right: (template_string) @injection.content
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.include-children)
  (#set! injection.language "html"))

; el.innerHTML = '<html>'
(assignment_expression
  left: (member_expression
    property: (property_identifier) @_prop
    (#any-of? @_prop "outerHTML" "innerHTML"))
  right: (string
    (string_fragment) @injection.content)
  (#set! injection.language "html"))

; Styled Jsx <style jsx>
(jsx_element
  (jsx_opening_element
    (identifier) @_name
    (#eq? @_name "style")
    (jsx_attribute) @_attr
    (#eq? @_attr "jsx"))
  (jsx_expression
    ((template_string) @injection.content
      (#set! injection.language "css"))
    (#offset! @injection.content 0 1 0 -1)))
]])
