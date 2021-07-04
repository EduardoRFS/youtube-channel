module Context = Map.Make (String)

exception Type_error

module Typ = struct
  type typ = TArrow of { param_typ : typ; body_typ : typ } | TInt
  [@@deriving show { with_path = false }]

  let rec equal a b =
    match (a, b) with
    | a, b when a == b -> true
    | TInt, TInt -> true
    | ( TArrow { param_typ = param_a; body_typ = body_a },
        TArrow { param_typ = param_b; body_typ = body_b } ) ->
        equal param_a param_b && equal body_a body_b
    | _ -> false
end

module Expr = struct
  open Typ

  type expr =
    | Int of int
    | Variable of string
    | Abstraction of { param : string; param_typ : typ; body : expr }
    | Application of { funct : expr; argument : expr }
end

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
end

module Value = struct
  open Expr

  type value =
    | VInt of int
    | VClosure of { context : value Context.t; param : string; body : expr }
    | VNative of (value -> value)

  let value_pp fmt value =
    match value with
    | VInt n -> Format.fprintf fmt "VInt %d" n
    | VClosure _ -> Format.fprintf fmt "VClosure"
    | VNative _ -> Format.fprintf fmt "VNative"
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
        | VInt _ -> raise Type_error)
end

(* examples *)
open Expr
open Typ
open Value
open Infer
open Interp

let initial_value_context =
  Context.empty
  |> Context.add "print_hello_world"
       (VNative
          (fun v ->
            print_endline "hello world";
            v))

let interp = interp initial_value_context

let initial_typ_context =
  Context.empty
  |> Context.add "print_hello_world"
       (TArrow { param_typ = TInt; body_typ = TInt })

let infer = infer initial_typ_context

(* (λa.λb.b) *)
let snd =
  Abstraction
    {
      param = "a";
      param_typ = TInt;
      body =
        Abstraction
          {
            param = "b";
            param_typ = TArrow { param_typ = TInt; body_typ = TInt };
            body = Variable "b";
          };
    }

let snd_typ = infer snd

let rec forever_typ =
  TArrow
    {
      param_typ = forever_typ;
      body_typ =
        TArrow
          {
            param_typ = TArrow { param_typ = TInt; body_typ = TInt };
            body_typ = TArrow { param_typ = TInt; body_typ = TInt };
          };
    }

let forever =
  Abstraction
    {
      param = "forever";
      param_typ = forever_typ;
      body =
        Abstraction
          {
            param = "f";
            param_typ = TArrow { param_typ = TInt; body_typ = TInt };
            body =
              Abstraction
                {
                  param = "x";
                  param_typ = TInt;
                  body =
                    Application
                      {
                        funct =
                          Application
                            {
                              funct =
                                Application
                                  {
                                    funct = Variable "forever";
                                    argument = Variable "forever";
                                  };
                              argument =
                                Application
                                  {
                                    funct =
                                      Application
                                        {
                                          funct = Variable "snd";
                                          argument =
                                            Application
                                              {
                                                funct = Variable "f";
                                                argument = Variable "x";
                                              };
                                        };
                                    argument = Variable "f";
                                  };
                            };
                        argument = Variable "x";
                      };
                };
          };
    }

let forever =
  Application
    {
      funct =
        Abstraction
          {
            param = "snd";
            param_typ = snd_typ;
            body = Application { funct = forever; argument = forever };
          };
      argument = snd;
    }

let x = infer forever

(*(λsnd.
    ((λforever.λf.λx.forever forever (snd (f x) f) x))
     (λforever.λf.λx.forever forever (snd (f x) f) x)))
  (λ_.λb.b) *)
(* let z = Application {
  funct = forever;

} *)

let forever_hello_world =
  Application
    {
      funct =
        Application { funct = forever; argument = Variable "print_hello_world" };
      argument = Int 1;
    }

let () = Format.printf "%a\n%!" Typ.pp_typ (infer forever_hello_world)

let () = Format.printf "%a\n%!" Value.value_pp (interp forever_hello_world)
