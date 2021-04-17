module Context = Map.Make (String)

type expr =
  | Variable of string
  | Abstraction of { param : string; body : expr }
  | Application of { funct : expr; argument : expr }

type value =
  | Closure of { context : value Context.t; param : string; body : expr }
  | Native of (value -> value)

let rec interp context expr =
  match expr with
  | Variable name -> Context.find name context
  | Abstraction { param; body } -> Closure { context; param; body }
  | Application { funct; argument } -> (
      let argument = interp context argument in
      match interp context funct with
      | Closure { context; param; body } ->
          interp (Context.add param argument context) body
      | Native f -> f argument)

let f =
  Abstraction
    {
      param = "f";
      body =
        Application
          {
            funct = Variable "f";
            argument =
              Application
                {
                  funct = Variable "print_hello_world";
                  argument = Variable "f";
                };
          };
    }

(* ((λf.(f (print_hello_world f))) (λf.(f (print_hello_world f)))) *)
let code = Application { funct = f; argument = f }

let initial_context =
  Context.empty
  |> Context.add "print_hello_world"
       (Native
          (fun v ->
            print_endline "hello world";
            v))

let _x = interp initial_context code
