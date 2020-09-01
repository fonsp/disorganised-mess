### A Pluto.jl notebook ###
# v0.11.10

using Markdown
using InteractiveUtils

# ╔═╡ 562e85fe-ec5f-11ea-3d43-c538d0b1728f
begin
	import Pkg
	Pkg.activate(mktempdir())
end

# ╔═╡ 7e03785a-ec5f-11ea-0174-bb09668bf957
begin
	Pkg.add("CSV")
	using CSV
end

# ╔═╡ 8a536d9a-ec5f-11ea-39d9-658049cc015b
CSV.File

# ╔═╡ f3640024-ec6b-11ea-2d5c-bfcbfd754c8e


# ╔═╡ Cell order:
# ╠═562e85fe-ec5f-11ea-3d43-c538d0b1728f
# ╠═7e03785a-ec5f-11ea-0174-bb09668bf957
# ╠═8a536d9a-ec5f-11ea-39d9-658049cc015b
# ╠═f3640024-ec6b-11ea-2d5c-bfcbfd754c8e
