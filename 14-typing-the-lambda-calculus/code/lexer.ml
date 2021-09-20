open Sedlexing.Utf8
open Parser

exception Invalid_token

let whitespace = [%sedlex.regexp? Plus (' ' | '\n' | '\t')]

let lower_alpha = [%sedlex.regexp? 'a' .. 'z']

let number = [%sedlex.regexp? '0' .. '9']

let ident = [%sedlex.regexp? lower_alpha, Star (lower_alpha | number | '_')]

let int = [%sedlex.regexp? Plus number]

let rec tokenizer buf =
  match%sedlex buf with
  | whitespace -> tokenizer buf
  | ident -> IDENT (lexeme buf)
  | int -> INT (lexeme buf |> int_of_string)
  | ':' -> COLON
  | '.' -> DOT
  | "->" -> ARROW
  | '(' -> LPARENS
  | ')' -> RPARENS
  | any -> if lexeme buf = "λ" then LAMBDA else raise Invalid_token
  | eof -> EOF
  | _ -> assert false

let provider buf () =
  let token = tokenizer buf in
  let start, stop = Sedlexing.lexing_positions buf in
  (token, start, stop)

let from_string f string =
  provider (from_string string)
  |> MenhirLib.Convert.Simplified.traditional2revised f
