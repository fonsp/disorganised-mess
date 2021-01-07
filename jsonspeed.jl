### A Pluto.jl notebook ###
# v0.8.9

using Markdown

# ╔═╡ c9672410-97c9-11ea-0429-33ea81efccae
using BenchmarkTools

# ╔═╡ d4a56eec-97c9-11ea-1c10-e936df65dfc6
@elapsed import JSON

# ╔═╡ 7944c3ee-97ca-11ea-0d84-350a7dba51d7
io = IOBuffer()

# ╔═╡ 826c6c56-97ca-11ea-1347-5b3080fb3c43
@benchmark print(io, "asdfdfasdfas")

# ╔═╡ 2cc3cc9e-97cb-11ea-26a7-dd370c3d83fe
["<b>a</b>"]

# ╔═╡ 9afb0486-97cb-11ea-25bf-9dc09f0441d0
Ref(3)

# ╔═╡ Cell order:
# ╠═c9672410-97c9-11ea-0429-33ea81efccae
# ╠═d4a56eec-97c9-11ea-1c10-e936df65dfc6
# ╠═7944c3ee-97ca-11ea-0d84-350a7dba51d7
# ╠═826c6c56-97ca-11ea-1347-5b3080fb3c43
# ╠═2cc3cc9e-97cb-11ea-26a7-dd370c3d83fe
# ╠═9afb0486-97cb-11ea-25bf-9dc09f0441d0
