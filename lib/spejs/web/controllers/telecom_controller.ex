defmodule Spejs.Web.TelecomController do
	use Spejs.Web, :controller
	alias Spejs.Api.Telecom

	def index(conn, %{"start_call" => _} = params), 
		do: start_call(conn, params)
	def index(conn, %{"end_call" => _} = params), 
		do: end_call(conn, params)
	def index(conn, params), 
		do: json(conn, Telecom.index(params))

	def start_call(conn, params), 
		do: json(conn, Telecom.start_call(params))
	def end_call(conn, params), 
		do: json(conn, Telecom.end_call(params))
	def status(conn, params),
		do: json(conn, Telecom.status(params))
end