type typ =
  | TArrow of { param_typ : typ; body_typ : typ }
  | TInt
  | TVar of string
  | TForall of { param : string; return_typ : typ }
[@@deriving show { with_path = false }]

let raw_pp_typ = pp_typ

let rec pp_typ fmt t =
  let open Format in
  match t with
  | TArrow { param_typ = TArrow _ as param_typ; body_typ } ->
      fprintf fmt "(%a) -> %a" pp_typ param_typ pp_typ body_typ
  | TArrow { param_typ; body_typ } ->
      fprintf fmt "%a -> %a" pp_typ param_typ pp_typ body_typ
  | TInt -> fprintf fmt "int"
  | TVar name -> fprintf fmt "%s" name
  | TForall { param; return_typ } ->
      fprintf fmt "∀%s.%a" param pp_typ return_typ

let rec subst t ~from ~to_ =
  match t with
  | TArrow { param_typ; body_typ } ->
      TArrow
        {
          param_typ = subst param_typ ~from ~to_;
          body_typ = subst body_typ ~from ~to_;
        }
  | TInt -> TInt
  | TVar name when name = from -> to_
  | TVar name -> TVar name
  | TForall { param; return_typ } when param = from ->
      TForall { param; return_typ }
  | TForall { param; return_typ } ->
      TForall { param; return_typ = subst return_typ ~from ~to_ }

let rec equal a b =
  match (a, b) with
  | a, b when a == b -> true
  | TInt, TInt -> true
  | ( TArrow { param_typ = param_a; body_typ = body_a },
      TArrow { param_typ = param_b; body_typ = body_b } ) ->
      equal param_a param_b && equal body_a body_b
  | TVar name, TVar name' -> name = name'
  | ( TForall { param = param_a; return_typ = return_typ_a },
      TForall { param = param_b; return_typ = return_typ_b } ) ->
      let return_typ_b_as_a =
        subst return_typ_b ~from:param_b ~to_:(TVar param_a)
      in
      equal return_typ_a return_typ_b_as_a
  | _ -> false
