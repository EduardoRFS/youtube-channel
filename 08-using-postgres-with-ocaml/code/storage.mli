type message = { user_name : string; body : string } [@@deriving yojson]

val read_all_messages : unit -> message list Lwt.t

val insert_message : message -> unit Lwt.t
