defmodule SpejsWeb.TelecomController do
	use SpejsWeb, :controller
	alias Spejs.Api.Telecom

	def index(conn, %{"start_call" => _} = params),
		do: start_call(conn, params)
	def index(conn, %{"end_call" => _} = params),
		do: end_call(conn, params)
	def index(conn, params),
		do: json(conn, %{
			"/start_call": %{
				params: ["source", "destination"],
				types: ["string", "string"],
				required: :all
			},
			"/end_call": %{
				params: ["source", "destination", "number"],
				types: ["string", "string", "string"],
				required: :one_of
			},
			"/": %{
				params: ["start_call", "end_call"],
				types: ["empty", "empty"],
				required: :one_of
			}
		})

	def start_call(conn, params),
		do: json(conn, Telecom.start_call(params))
	def end_call(conn, params),
		do: json(conn, Telecom.end_call(params))
	def status(conn, params),
		do: json(conn, Telecom.status(params))
end