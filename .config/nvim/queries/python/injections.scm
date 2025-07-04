;; extends
(call
  function: (attribute
              object: (identifier) @_re)
  arguments: (argument_list (string
                              (string_content) @injection.content) @_string)
  (#eq? @_re "re")
  (#lua-match? @_string "^r.*")
  (#set! injection.language "regex"))

((comment) @injection.content
 (#set! injection.language "comment"))

(string 
  (string_content) @injection.content
    (#vim-match? @injection.content "^\w*SELECT|FROM|INNER JOIN|WHERE|CREATE|DROP|INSERT|UPDATE|ALTER.*$")
    (#set! injection.language "sql"))

(call
  function: (attribute attribute: (identifier) @id (#match? @id "execute|read_sql"))
  arguments: (argument_list
    (string (string_content) @injection.content (#set! injection.language "sql"))))
