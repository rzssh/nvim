;; extends

; Payloads with pipes (for loops, error unions, optionals)
(payload
  "|" @open.payload
  "|" @close.payload) @scope.payload
