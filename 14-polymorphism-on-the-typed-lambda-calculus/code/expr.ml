open Typ

type expr =
  | Int of int
  | Variable of string
  | Abstraction of { param : string; param_typ : typ; body : expr }
  | Application of { funct : expr; argument : expr }
[@@deriving show { with_path = false }]
