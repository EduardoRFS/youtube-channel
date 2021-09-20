%{ open Typ
   open Expr %}
%token <string> IDENT
%token <int> INT
%token LAMBDA
%token COLON
%token DOT
%token ARROW

%token LPARENS
%token RPARENS
%token EOF

%start <Expr.expr option> expr_opt
%start <Typ.typ option> typ_opt

%%

let typ_opt :=
  | EOF; { None }
  | t = typ; EOF; { Some t }

let sub_typ ==
  | i = IDENT;
    { match i with | "int" -> TInt | _ -> failwith "invalid type" }
  | LPARENS; t = typ; RPARENS; { t }

let typ :=
  | sub_typ
  | t1 = sub_typ; ARROW; t2 = typ;
    { TArrow { param_typ = t1; body_typ = t2 } }

let expr_opt :=
  | EOF; { None }
  | e = expr; EOF; { Some e }

let terminal ==
  | i = INT; { Int i }
  | i = IDENT; { Variable i }

let abstraction ==
  | LAMBDA; p = IDENT; COLON; t = typ; DOT; e = expr;
    { Abstraction { param = p; param_typ = t; body = e } }

let sub_expr :=
  | terminal
  | LPARENS; e = expr; RPARENS; { e }

let application :=
  | sub_expr
  | e1 = application; e2 = sub_expr;
    { Application { funct = e1; argument = e2 } }

let expr :=
  | abstraction
  | application