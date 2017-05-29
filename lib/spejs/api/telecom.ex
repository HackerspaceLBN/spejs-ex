defmodule Spejs.Api.Telecom do
	def index(params) do
		params 
		|> Map.put(:action, :index) 
		|> Map.put(:status, :ok)
	end

	def status(params) do
		params 
		|> Map.put(:action, :status) 
		|> Map.put(:status, :ok)
	end

	def start_call(%{"from" => from, "to" => to} = params) do
		params 
		|> Map.put(:action, :start_call) 
		|> Map.put(:status, :ok)
	end

	def end_call(params) do
		params 
		|> Map.put(:action, :end_call) 
		|> Map.put(:status, :ok)
	end
end