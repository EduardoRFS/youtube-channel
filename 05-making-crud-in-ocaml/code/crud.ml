open Opium

let ( let* ) = Lwt.bind

(* GET /messages *)
let read_all_messages =
  App.get "/messages" (fun _request ->
      let* messages = Storage.read_all_messages () in
      let json = [%to_yojson: Storage.message list] messages in
      Lwt.return (Response.of_json json))

(* POST /messages *)
let post_message =
  App.post "/messages" (fun request ->
      let* input_json = Request.to_json_exn request in
      let input_message =
        match Storage.message_of_yojson input_json with
        | Ok message -> message
        | Error error -> raise (Invalid_argument error)
      in
      let* () = Storage.insert_message input_message in
      Lwt.return (Response.make ~status:`OK ()))

let () = App.empty |> read_all_messages |> post_message |> App.run_multicore
