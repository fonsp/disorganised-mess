### A Pluto.jl notebook ###
# v0.11.9

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 9330000a-e6d7-11ea-1263-f18f6be1943d
using PlutoUI

# ╔═╡ 5104f2ee-e6d2-11ea-2948-f776d3e7ce51
using DataFrames

# ╔═╡ 1b0a3a82-e6d2-11ea-337a-aff15fda3864
import Pluto

# ╔═╡ 13c3462a-e6e0-11ea-19b2-c5eb5c3e340b
import UUIDs: UUID

# ╔═╡ 7c4d41ac-e6d4-11ea-19f2-5544359c0b65
import Distributed

# ╔═╡ cca02876-e6e4-11ea-0819-bd024ce8ad58
import CSV

# ╔═╡ 68da9dec-e6e1-11ea-1d9e-cdb7028f9b6a
md"# Part 1: autograding"

# ╔═╡ 836cc4be-e6d7-11ea-2a6e-436c187304da
md"## Step 1: Select submission files"

# ╔═╡ 427f19de-e6d2-11ea-10a8-5d3552224b31
submission_files = readdir("/home/fons/disorganised-mess/autograding/submissions/"; join=true)

# ╔═╡ 54c9b77c-e6e2-11ea-03ff-5d0d4a9dd763
if !all(isabspath, submission_files)
	md"""
!!! warning
    Submission paths need to be _absolute_
	"""
end

# ╔═╡ d0dd703a-e6da-11ea-1d4f-0b10bf75fad6
md"## Step 2: autograde actions"

# ╔═╡ 9392cf50-e6e1-11ea-3d36-e37cbaf33110
function naming_function(notebook::Pluto.Notebook, action_results::Vector)
	action_results[3]
end

# ╔═╡ 8c6c6114-e6d7-11ea-20b1-e718907e0767
md"## Step 3: autograde all notebooks"

# ╔═╡ a1598cfc-e6d7-11ea-1f0b-f5560304fe7a
md"**Click to start autograding:**

 $(@bind run_notebooks CheckBox()) run $(length(submission_files)) notebooks

---"

# ╔═╡ b5d0d970-e6d9-11ea-20a5-01f0c4e3875c
pluto_session = Pluto.ServerSession()

# ╔═╡ a6fe722e-e6da-11ea-21e8-1dea77b462ef
submission_files_to_run = run_notebooks ? Pluto.tamepath.(submission_files) : String[]

# ╔═╡ 5642a754-e6d9-11ea-35b6-0fe20d6a098e
notebooks = let
	for nb in values(pluto_session.notebooks)
		Pluto.SessionActions.shutdown(pluto_session, nb)
    end
	map(submission_files_to_run) do path

		nb = Pluto.load_notebook(Pluto.tamepath(path))
		pluto_session.notebooks[nb.notebook_id] = nb
		nb
	end
end

# ╔═╡ 3f0aec92-e6e1-11ea-1b53-29b7b543674d


# ╔═╡ 3fb6b20c-e6e1-11ea-35eb-e74598e31daf
md"# Part 2: manual review"

# ╔═╡ 9090ee3e-e6de-11ea-14c3-27032e8710d3
md"## Step 1: start notebook server"

# ╔═╡ 9c1c40f0-e6de-11ea-08d8-77acb2a550d4
md"**Click to start notebook server:**

 $(@bind run_server CheckBox()) run notebook server

---"

# ╔═╡ a3e47050-e6de-11ea-2a91-0597143f71ba
if run_server
	@async Pluto.run(2468; session=pluto_session)
	
	md"> Server is running at [https://localhost:2468](https://localhost:2468)"
end

# ╔═╡ 8904534a-e6e1-11ea-34b7-31d1f6f8ca8f
md"## Step 2: select notebook"

# ╔═╡ eade89f2-e6de-11ea-11bb-531a6b65c666
@bind inspected_notebook_index_str Select([string(i) => nb.path for (i,nb) in enumerate(notebooks)])

# ╔═╡ 317c245c-e6e7-11ea-31c1-c9f8e3645a7b
manual = ["a", "asdff"]

# ╔═╡ 22fd661e-e6e7-11ea-2b4a-8981b17a790d
@bind manual_results let
	boxes = map(manual) do name
		"""<p><input type='checkbox' id='$(name)' $(rand(Bool) ? "checked" : "")> $(name)</p>"""
	end
	"""
<div id="hello">
	$(join(boxes))
</div>
<script>
	const div = this.querySelector("#hello")
	const boxes = div.querySelectorAll("input")
	
	boxes.forEach(el => {
		el.oninput = () => {
			div.value = Object.fromEntries(Array.from(boxes).map((b) => [b.id, b.checked]))
		}
	})

</script>
""" |> HTML
end

# ╔═╡ 4fa16724-e6e7-11ea-195a-335bacef3c0f
h(x) = repr(MIME"text/html"(), x)

# ╔═╡ be1e7bb0-e6e7-11ea-13a6-09f6da125112
h(CheckBox(;default=true))

# ╔═╡ f92f2f60-e6e7-11ea-26df-35c0c943d0b6
manual_results

# ╔═╡ 1a999dfe-e6e1-11ea-12f4-ed24f03245e0
inspected_notebook_index = parse(Int, inspected_notebook_index_str)

# ╔═╡ 64c26a50-e6df-11ea-2762-57186f445501
inspected_notebook = notebooks[inspected_notebook_index]

# ╔═╡ b6b986c8-e6de-11ea-1d13-5d9d370eccdc
if run_server
	cd(inspected_notebook.path |> dirname)
	"""
	<iframe src="http://localhost:2468/edit?id=$(inspected_notebook.notebook_id)" style="width: calc(100% - 8px); height: 100vh; margin: 0; border: 4px solid pink;">
	""" |> HTML
end

# ╔═╡ 8d1aaee8-e6de-11ea-2c2c-4d2ba138d5ce
md"# Appendix"

# ╔═╡ ce055a44-e6d8-11ea-3a07-75392c0f6c26
md"## Grading actions"

# ╔═╡ c1f5bd3a-e6d2-11ea-20ab-d93e142aa71e
abstract type GradingAction end

# ╔═╡ 9057dc04-e6d2-11ea-196b-1519cac7d248
struct Assignment <: GradingAction
	name
	points_value::Number
	test::Expr
end

# ╔═╡ 3abb56e4-e6d3-11ea-3337-392a434e1a21
struct GetValue <: GradingAction
	name
	getter::Expr
end

# ╔═╡ eaa49370-e6da-11ea-21d9-ddf11a7df51f
actions = [
	GetValue("name", :(student.name)),
	GetValue("email", :(student.email)),
	GetValue("number", :(student.number)),
	
	Assignment("big number", 5, quote
			big_number > 100
		end),
	
	Assignment("ispositive", 10, quote
			ispositive(20) && !ispositive(0)
		end),
]

# ╔═╡ 8b9a3f7a-e6d4-11ea-34c5-ef986e6af936
begin
	
	
	# default
	displayname(action::GradingAction) = action.name
end

# ╔═╡ e48f2a16-e6e1-11ea-070a-d58f87569b91
md"## Misc"

# ╔═╡ 33588e20-e6d4-11ea-08f6-7d10d9ef1481
function eval_in_notebook(notebook::Pluto.Notebook, expr)
	withenv("PLUTO_WORKSPACE_USE_DISTRIBUTED" => "no thanks") do
		ws = Pluto.WorkspaceManager.get_workspace(notebook)
		fetcher = :(Core.eval($(ws.module_name), $(expr |> QuoteNode)))
		Distributed.remotecall_eval(Main, ws.pid, fetcher)
	end
end

# ╔═╡ 31111cbe-e6d3-11ea-0130-a98e45b82f2b
begin
	function do_action(notebook::Pluto.Notebook, action::Assignment)
		tester = quote
				try
					$(action.test)
				catch
					false
				end
			end
		
		if eval_in_notebook(notebook, tester)
			action.points_value
		else
			zero(action.points_value)
		end
	end
	
	function do_action(notebook::Pluto.Notebook, action::GetValue)
		eval_in_notebook(notebook, action.getter)
	end
end

# ╔═╡ 33e66768-e6d9-11ea-1aba-256b4c9998b8
autograde_results = map(notebooks) do nb
	withenv("PLUTO_WORKSPACE_USE_DISTRIBUTED" => "no thanks") do
		Pluto.update_save_run!(pluto_session, nb, nb.cells; run_async=false, prerender_text=true)
	end
	map(actions) do action
		do_action(nb, action)
	end
end

# ╔═╡ 5ca8fb02-e6e3-11ea-0ad6-158746799400
autograde_results_df = DataFrame(map(autograde_results) do results
		(;
			map(zip(actions, results)) do (action, result)
				Symbol(displayname(action)) => result
			end...
		)
	end)

# ╔═╡ c9a66a4a-e6e4-11ea-0528-f3bbf6f17675
DownloadButton(sprint(CSV.write, autograde_results_df), "autograde_results.csv")

# ╔═╡ 991ddb18-e6e6-11ea-220d-71b6794f39d8
autograde_results_df[inspected_notebook_index, :]

# ╔═╡ 459687e0-e6e3-11ea-0c85-89516c7a2da0
DownloadButton(sprint(CSV.write, autograde_results_df), "manual_results.csv")

# ╔═╡ bbcd528e-e6e5-11ea-2d9c-a50835477b2e
md"## Not used
(because it can't export to CSV)"

# ╔═╡ 6033b7ea-e6d3-11ea-04ec-8bf4f548e585
struct PointsOutOf
	value
	max_value
end

# ╔═╡ 5ceffa88-e6d8-11ea-0cd5-7b86e3c983eb
begin
	import Base: +
	+(a::PointsOutOf, b::PointsOutOf) = PointsOutOf(a.value + b.value, a.max_value + b.max_value)
end

# ╔═╡ 7a578ade-e6d3-11ea-349d-0d5c49f2fdca
begin
	function Base.show(io::IO, ::MIME"text/plain", p::PointsOutOf)
		print(io, p.value, "/", p.max_value)
	end
end

# ╔═╡ Cell order:
# ╠═1b0a3a82-e6d2-11ea-337a-aff15fda3864
# ╠═13c3462a-e6e0-11ea-19b2-c5eb5c3e340b
# ╠═7c4d41ac-e6d4-11ea-19f2-5544359c0b65
# ╠═9330000a-e6d7-11ea-1263-f18f6be1943d
# ╠═5104f2ee-e6d2-11ea-2948-f776d3e7ce51
# ╠═cca02876-e6e4-11ea-0819-bd024ce8ad58
# ╟─68da9dec-e6e1-11ea-1d9e-cdb7028f9b6a
# ╟─836cc4be-e6d7-11ea-2a6e-436c187304da
# ╠═427f19de-e6d2-11ea-10a8-5d3552224b31
# ╟─54c9b77c-e6e2-11ea-03ff-5d0d4a9dd763
# ╟─d0dd703a-e6da-11ea-1d4f-0b10bf75fad6
# ╠═eaa49370-e6da-11ea-21d9-ddf11a7df51f
# ╠═9392cf50-e6e1-11ea-3d36-e37cbaf33110
# ╟─8c6c6114-e6d7-11ea-20b1-e718907e0767
# ╟─a1598cfc-e6d7-11ea-1f0b-f5560304fe7a
# ╠═b5d0d970-e6d9-11ea-20a5-01f0c4e3875c
# ╠═a6fe722e-e6da-11ea-21e8-1dea77b462ef
# ╟─5642a754-e6d9-11ea-35b6-0fe20d6a098e
# ╟─33e66768-e6d9-11ea-1aba-256b4c9998b8
# ╟─3f0aec92-e6e1-11ea-1b53-29b7b543674d
# ╟─5ca8fb02-e6e3-11ea-0ad6-158746799400
# ╟─c9a66a4a-e6e4-11ea-0528-f3bbf6f17675
# ╟─3fb6b20c-e6e1-11ea-35eb-e74598e31daf
# ╟─9090ee3e-e6de-11ea-14c3-27032e8710d3
# ╟─9c1c40f0-e6de-11ea-08d8-77acb2a550d4
# ╠═a3e47050-e6de-11ea-2a91-0597143f71ba
# ╟─8904534a-e6e1-11ea-34b7-31d1f6f8ca8f
# ╠═eade89f2-e6de-11ea-11bb-531a6b65c666
# ╟─991ddb18-e6e6-11ea-220d-71b6794f39d8
# ╟─b6b986c8-e6de-11ea-1d13-5d9d370eccdc
# ╠═22fd661e-e6e7-11ea-2b4a-8981b17a790d
# ╠═317c245c-e6e7-11ea-31c1-c9f8e3645a7b
# ╠═4fa16724-e6e7-11ea-195a-335bacef3c0f
# ╠═be1e7bb0-e6e7-11ea-13a6-09f6da125112
# ╠═f92f2f60-e6e7-11ea-26df-35c0c943d0b6
# ╠═459687e0-e6e3-11ea-0c85-89516c7a2da0
# ╟─1a999dfe-e6e1-11ea-12f4-ed24f03245e0
# ╟─64c26a50-e6df-11ea-2762-57186f445501
# ╟─8d1aaee8-e6de-11ea-2c2c-4d2ba138d5ce
# ╟─ce055a44-e6d8-11ea-3a07-75392c0f6c26
# ╠═c1f5bd3a-e6d2-11ea-20ab-d93e142aa71e
# ╠═9057dc04-e6d2-11ea-196b-1519cac7d248
# ╠═3abb56e4-e6d3-11ea-3337-392a434e1a21
# ╠═31111cbe-e6d3-11ea-0130-a98e45b82f2b
# ╠═8b9a3f7a-e6d4-11ea-34c5-ef986e6af936
# ╟─e48f2a16-e6e1-11ea-070a-d58f87569b91
# ╠═33588e20-e6d4-11ea-08f6-7d10d9ef1481
# ╟─bbcd528e-e6e5-11ea-2d9c-a50835477b2e
# ╠═6033b7ea-e6d3-11ea-04ec-8bf4f548e585
# ╟─5ceffa88-e6d8-11ea-0cd5-7b86e3c983eb
# ╟─7a578ade-e6d3-11ea-349d-0d5c49f2fdca
