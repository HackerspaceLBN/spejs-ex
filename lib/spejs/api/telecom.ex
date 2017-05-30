defmodule Spejs.Api.Telecom do
	
	# Public API

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

	def start_call(params) do
		{:ok, timestamp} = NaiveDateTime.from_erl(:calendar.local_time)
		{status, result} = parse_repo_response(
			Spejs.Telecom.create_phone_call(Map.put(params, "start_at", timestamp))
			)

		create_response(params, :end_call, status, result)		
	end 

	def end_call(%{"source" => source} = params) do
		phone_call = Spejs.Telecom.get_started_phone_call(%{source: source})
		end_phone_call(phone_call, params)
	end

	def end_call(%{"destination" => destination} = params) do
		phone_call = Spejs.Telecom.get_started_phone_call(%{destination: destination})
		end_phone_call(phone_call, params)
	end
	def end_call(%{"number" => number} = params) do
		phone_call = Spejs.Telecom.get_started_phone_call(%{any: number})
		end_phone_call(phone_call, params)
	end

	# Private API

	defp end_phone_call(phone_call, params) when not is_list(phone_call) do
		{:ok, timestamp} = NaiveDateTime.from_erl(:calendar.local_time)

		{status, result} = parse_repo_response(
			Spejs.Telecom.update_phone_call(phone_call, %{stop_at: timestamp})
		)

		create_response(params, :end_call, status, result)		
	end

	defp end_phone_call(phone_call, params) when is_list(phone_call) do
		{:ok, timestamp} = NaiveDateTime.from_erl(:calendar.local_time)

		result = phone_call 
		|> Enum.map(fn phone -> 
			Spejs.Telecom.update_phone_call(phone, %{stop_at: timestamp})
		end)
		|> Enum.map(&parse_repo_response/1)

		statuses = result |> Enum.map(fn {status, _} -> status end)
		results = result |> Enum.map(fn {_, result} -> result end)

		case length(result) do
		  0 -> create_response(params, :end_call, :empty, results)
		  1 -> create_response(params, :end_call, List.first(statuses), List.first(results))
		  _ -> create_response(params, :end_call, statuses, results)		   
		end
	end

	defp parse_repo_response(response) do
		case response do
		  {:ok, phone_call} -> 
		  	{:ok, Map.take(phone_call, [:id, :source, :destination])}
		  {:error, %{errors: errors}} -> 
		  	{:error, Enum.map(errors, fn {field, {message, _}} -> 
		  		to_string(field) <> " " <> message 
		  	end)}
		end
	end

	defp create_response(params, action, status, result) do
		%{
			params: params,
			action: action,
			status: status,
			result: result
		}
	end
end