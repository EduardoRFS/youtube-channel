(* types *)
module type DB = Rapper_helper.CONNECTION

exception Query_failed of string

type message = { user_name : string; body : string } [@@deriving yojson]

type message_stored = { id : string; user_name : string; body : string }

(* helpers *)
let ( let* ) = Lwt.bind

(* setup of database pool *)

let connection_url = "postgresql://postgres:password@localhost:5432"

let pool =
  match Caqti_lwt.connect_pool ~max_size:10 (Uri.of_string connection_url) with
  | Ok pool -> pool
  | Error error -> failwith (Caqti_error.show error)

let dispatch f =
  let* result = Caqti_lwt.Pool.use f pool in
  match result with
  | Ok data -> Lwt.return data
  | Error error -> Lwt.fail (Query_failed (Caqti_error.show error))

(* running migrations *)
let ensure_table_exists =
  [%rapper
    execute
      {sql|
        CREATE TABLE IF NOT EXISTS messages (
          id VARCHAR PRIMARY KEY NOT NULL,
          user_name VARCHAR,
          body VARCHAR
        );
      |sql}]
    ()

let () = dispatch ensure_table_exists |> Lwt_main.run

(* queries *)
let read_all_messages () =
  let read_all =
    [%rapper
      get_many
        {sql|
          SELECT @string{id}, @string{user_name}, @string{body}
          FROM messages
        |sql}
        record_out]
      ()
  in
  let* messages = dispatch read_all in
  messages
  |> List.map (fun { user_name; body; _ } -> { user_name; body })
  |> Lwt.return

let insert_message ({ user_name; body } : message) =
  let insert =
    [%rapper
      execute
        {sql|
          INSERT INTO messages
          VALUES(%string{id}, %string{user_name}, %string{body})
        |sql}
        record_in]
  in
  let id = Uuidm.create `V4 |> Uuidm.to_string in
  dispatch (insert { id; user_name; body })
