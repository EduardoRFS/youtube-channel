module Context = Map.Make (String)

exception Type_error

module Infer = struct
  open Typ
  open Expr

  let rec infer context expr =
    match expr with
    | Int _ -> TInt
    | Variable name -> (
        match Context.find_opt name context with
        | Some typ -> typ
        | None -> raise Type_error)
    | Abstraction { param; param_typ; body } ->
        let context = Context.add param param_typ context in
        let body_typ = infer context body in
        TArrow { param_typ; body_typ }
    | Application { funct; argument } -> (
        let funct_typ = infer context funct in
        let argument_typ = infer context argument in
        match funct_typ with
        | TArrow { param_typ; body_typ } when Typ.equal param_typ argument_typ
          ->
            body_typ
        | _ -> raise Type_error)
    | Type_abstraction { param; body } ->
        let return_typ = infer context body in
        TForall { param; return_typ }
    | Type_application { funct; argument } -> (
        let funct_typ = infer context funct in
        match funct_typ with
        | TForall { param; return_typ } ->
            subst return_typ ~from:param ~to_:argument
        | _ -> raise Type_error)
end

module Value = struct
  open Expr

  type value =
    | VInt of int
    | VClosure of { context : value Context.t; param : string; body : expr }
    | VForall of { context : value Context.t; body : expr }
    | VNative of (value -> value)

  let value_pp fmt value =
    match value with
    | VInt n -> Format.fprintf fmt "VInt %d" n
    | VClosure _ -> Format.fprintf fmt "VClosure"
    | VNative _ -> Format.fprintf fmt "VNative"
    | VForall _ -> Format.fprintf fmt "VForall"
end

module Interp = struct
  open Expr
  open Value

  let rec interp context expr =
    match expr with
    | Int n -> VInt n
    | Variable name -> Context.find name context
    | Abstraction { param; param_typ = _; body } ->
        VClosure { context; param; body }
    | Application { funct; argument } -> (
        let argument = interp context argument in
        match interp context funct with
        | VClosure { context; param; body } ->
            interp (Context.add param argument context) body
        | VNative f -> f argument
        | VInt _ | VForall _ -> raise Type_error)
    | Type_abstraction { param = _; body } -> VForall { context; body }
    | Type_application { funct; argument = _ } -> (
        match interp context funct with
        | VForall { context; body } -> interp context body
        | VInt _ | VClosure _ | VNative _ -> raise Type_error)
end

let parse_expr = Lexer.from_string Parser.expr_opt

let parse_typ = Lexer.from_string Parser.typ_opt

let print_expr code =
  parse_expr code |> Option.get |> Format.printf "%a\n%!" Expr.pp_expr

let print_typ code =
  parse_expr code |> Option.get |> Infer.infer Context.empty
  |> Format.printf "%a\n%!" Typ.pp_typ

let interp code =
  parse_expr code |> Option.get
  |> Interp.interp Context.empty
  |> Format.printf "%a\n%!" Value.value_pp

let () =
  interp
    {|
      (Λbool.
      λif:bool -> ∀a. a -> a -> a.
      λv1:bool.
      λv2:bool. if v1 [int] (if v2 [int] 1 2) 3)
        [∀a.a -> a -> a]
        (λbool:∀a.a -> a -> a.Λa.λleft:a.λright:a.bool [a] left right)
        (Λa.λx:a.λy:a.x)
        (Λa.λx:a.λy:a.x)
    |}
