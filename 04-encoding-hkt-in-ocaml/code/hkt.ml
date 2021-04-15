module type Monad = sig
  type 'a t

  val bind : 'a t -> ('a -> 'b t) -> 'b t

  val return : 'a -> 'a t
end

module Option = struct
  include Option

  let return = some
end

type ('a, 'b) eq = Eq : ('a, 'a) eq

module type HKT_Magic = sig
  module M : Monad

  type a

  type b

  type return_type

  val eq : (return_type, a M.t -> (a -> b M.t) -> b M.t) eq
end

let bind (type a b return_type)
    (module M : HKT_Magic
      with type a = a
       and type b = b
       and type return_type = return_type) =
  let Eq = M.eq in
  let open M in
  (fun v f -> M.bind v f : return_type)

let bind_option (type a b) v f =
  bind
    (module struct
      module M = Option

      type nonrec a = a

      type nonrec b = b

      type return_type = a M.t -> (a -> b M.t) -> b M.t

      let eq = Eq
    end)
    v f
