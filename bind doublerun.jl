### A Pluto.jl notebook ###
# v0.11.6

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

# ╔═╡ ae0936ee-c767-11ea-0cbc-3f58779113da
begin
	let
		env = mktempdir()
		import Pkg
		Pkg.activate(env)
		Pkg.update()
		Pkg.add(Pkg.PackageSpec(;name="PlutoUI", version=v"0.5.2"))
	end
	using PlutoUI
end

# ╔═╡ b819e9a8-c760-11ea-11ee-dd01da663b5c
md"## Slider"

# ╔═╡ 10ad3f62-de1c-11ea-1199-55e612633987
md"I should run once:"

# ╔═╡ 34ebf81e-c760-11ea-05bb-376173e7ed10
@bind x Slider(5:15) #asdf

# ╔═╡ 89b2edaa-de1c-11ea-20b0-9fe1b5dc13fe
x

# ╔═╡ a4488984-c760-11ea-2930-871f6b400ef5
sleep(1); x; rand()

# ╔═╡ 082d5f3e-de1c-11ea-178a-cbe340a7533b
md"I should run twice:"

# ╔═╡ fbb8bc3c-de1b-11ea-18ea-a74f7403e1d6
@bind y html"<input>"

# ╔═╡ 972a4eb8-de1c-11ea-335f-e7e74d461f57
y

# ╔═╡ 01e06dc4-de1c-11ea-315a-eb3417cbee19
sleep(1); y; rand()

# ╔═╡ Cell order:
# ╟─b819e9a8-c760-11ea-11ee-dd01da663b5c
# ╟─10ad3f62-de1c-11ea-1199-55e612633987
# ╠═34ebf81e-c760-11ea-05bb-376173e7ed10
# ╠═89b2edaa-de1c-11ea-20b0-9fe1b5dc13fe
# ╠═a4488984-c760-11ea-2930-871f6b400ef5
# ╟─082d5f3e-de1c-11ea-178a-cbe340a7533b
# ╠═fbb8bc3c-de1b-11ea-18ea-a74f7403e1d6
# ╠═972a4eb8-de1c-11ea-335f-e7e74d461f57
# ╠═01e06dc4-de1c-11ea-315a-eb3417cbee19
# ╠═ae0936ee-c767-11ea-0cbc-3f58779113da
