type message = { user_name : string; body : string } [@@deriving yojson]

let ( let* ) = Lwt.bind

let database_file = "messages.json"

let read_all_messages () =
  Lwt_io.with_file ~mode:Input database_file (fun input_channel ->
      let* database_string =
        Lwt_io.read_lines input_channel |> Lwt_stream.to_list
      in
      let database_json =
        Yojson.Safe.from_string (String.concat "\n" database_string)
      in
      match [%of_yojson: message list] database_json with
      | Ok messages -> Lwt.return messages
      | Error error -> raise (Invalid_argument error))

let insert_message message =
  let* messages = read_all_messages () in
  let messages = message :: messages in
  Lwt_io.with_file ~mode:Output database_file (fun output_channel ->
      let messages_string =
        messages |> [%to_yojson: message list] |> Yojson.Safe.pretty_to_string
      in
      Lwt_io.write output_channel messages_string)
