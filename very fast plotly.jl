### A Pluto.jl notebook ###
# v0.14.5

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

# ╔═╡ 33f59ae8-b7ea-11eb-36ab-434556d217ca
begin
	using Plots
	plotly()
	
	
end

# ╔═╡ df538e49-de45-4729-b62e-c066537ab8b2
using PlutoUI

# ╔═╡ 94b5dd13-6a3d-4d7f-ba52-25cb67169ca2
begin
	@eval Plots begin
		plotlylower(x) = x
		plotlylower(x::Vector{<:Number}) = x
		plotlylower(x::AbstractVector) = Any[plotlylower(z) for z in x]
		plotlylower(d::Dict) = Dict(
			k => plotlylower(v)
			for (k,v) in d
		)

		function _show(io::IO, ::MIME"text/html", plt::Plot{PlotlyBackend})
			write(io, html_head(plt))
			write(io, """
			<div>
			<div></div>
			<script>
			const PLOT = currentScript.parentElement.firstElementChild;
			Plotly.plot(PLOT, $(plotly_series_json(plt)), $(plotly_layout_json(plt)));
			</script>
			</div>
			""")
		end

		plotly_series_json(plt::Plot) = Main.PlutoRunner.publish_to_js(
			plotly_series(plt) |> plotlylower
		)
	end
	
	plotly()
end

# ╔═╡ c7ca7107-1b56-4911-a805-af30c5b392a9
x1 = rand(20)

# ╔═╡ 09c59eed-e304-4165-9bfa-81e46b22013a
x2 = rand(20)

# ╔═╡ c4a38507-bdc5-4346-b3df-5c7f0010dc52
p1 = plot(1:20, [x1 x2 rand(20)])

# ╔═╡ fabf4032-770c-4f76-b311-641daf561bea
plotly()

# ╔═╡ 7d8f9236-4e92-4a5b-b51d-1c08c95218a6
@bind x Slider(1:30000)

# ╔═╡ b85f1cd5-9b93-4f50-a187-f2bf65c277e9
x; plot(rand(x))

# ╔═╡ 0da9685c-446f-43e4-a279-b0153180c5e7
methods

# ╔═╡ cc980426-7d0e-4881-81ce-cf4c58b3b7d5
p2 = plot(1:20, [x1 x2 rand(20)])

# ╔═╡ 48d26bde-1c52-4413-8262-efcc8851ed64
s = MIME"image/svg+xml"()

# ╔═╡ 274fb644-947d-476c-8320-c592684e7394
repr(s,p1) |> clipboard

# ╔═╡ 9f3dc7d8-3602-4afc-85e3-1170894363da
repr(s,p2) |> clipboard

# ╔═╡ Cell order:
# ╠═33f59ae8-b7ea-11eb-36ab-434556d217ca
# ╠═94b5dd13-6a3d-4d7f-ba52-25cb67169ca2
# ╠═df538e49-de45-4729-b62e-c066537ab8b2
# ╠═c7ca7107-1b56-4911-a805-af30c5b392a9
# ╠═09c59eed-e304-4165-9bfa-81e46b22013a
# ╠═c4a38507-bdc5-4346-b3df-5c7f0010dc52
# ╠═fabf4032-770c-4f76-b311-641daf561bea
# ╠═b85f1cd5-9b93-4f50-a187-f2bf65c277e9
# ╠═7d8f9236-4e92-4a5b-b51d-1c08c95218a6
# ╠═0da9685c-446f-43e4-a279-b0153180c5e7
# ╠═cc980426-7d0e-4881-81ce-cf4c58b3b7d5
# ╠═48d26bde-1c52-4413-8262-efcc8851ed64
# ╠═274fb644-947d-476c-8320-c592684e7394
# ╠═9f3dc7d8-3602-4afc-85e3-1170894363da
