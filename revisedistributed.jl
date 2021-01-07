using Distributed

p = Distributed.addprocs(1) |> first

Distributed.remotecall_eval(Main, p, quote
	using Revise
	keys(Revise.watched_files) |> collect
end) |> display
