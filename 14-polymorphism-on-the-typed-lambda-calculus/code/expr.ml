open Typ

type expr =
  | Int of int
  | Variable of string
  | Abstraction of { param : string; param_typ : typ; body : expr }
  | Application of { funct : expr; argument : expr }
  | Type_abstraction of { param : string; body : expr }
  | Type_application of { funct : expr; argument : typ }
[@@deriving show { with_path = false }]
