### A Pluto.jl notebook ###
# v0.9.2

using Markdown

# ╔═╡ e2ebf2b8-a0c6-11ea-3e52-d30d8b48d57c
struct Pannenkoek
	beslag
	beleg
end

# ╔═╡ ebeb5d70-a0c6-11ea-14cb-e9826a141fde
stapel = [
	Pannenkoek("volkoren", "suiker")
	Pannenkoek("bier"    , "kaas"  )
	Pannenkoek("volkoren", nothing )
	]

# ╔═╡ 176d0920-a0c7-11ea-274e-2d120082ce1c
getfield.(stapel, :beleg)

# ╔═╡ Cell order:
# ╠═e2ebf2b8-a0c6-11ea-3e52-d30d8b48d57c
# ╠═ebeb5d70-a0c6-11ea-14cb-e9826a141fde
# ╠═176d0920-a0c7-11ea-274e-2d120082ce1c
