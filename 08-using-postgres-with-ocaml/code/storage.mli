type message = { user_name : string; body : string } [@@deriving yojson]

exception Query_failed of string

val read_all_messages : unit -> message list Lwt.t

val insert_message : message -> unit Lwt.t
