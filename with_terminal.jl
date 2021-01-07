### A Pluto.jl notebook ###
# v0.11.14

using Markdown
using InteractiveUtils

# ╔═╡ 2ce4e09c-fb36-11ea-16bb-0b77b4952e16
using Revise

# ╔═╡ 46608b6e-fb36-11ea-262b-ebdc05a5de80
using PlutoUI

# ╔═╡ ea0cc15e-fb38-11ea-2a6f-41d312244594
import Pkg

# ╔═╡ b8e98c2e-fb38-11ea-0a00-8d70af998ad0
Revise.watched_files

# ╔═╡ 4a383250-fb36-11ea-19c7-836b8ef865ea
with_terminal() do
	dump(:(f(x) = x))
	println(stderr, "asdf")
	dump(stderr, :(f(x) = x))
	@warn "asdf"
end

# ╔═╡ 015b7296-fb3a-11ea-0483-df693d24c54b
with_terminal() do
	dump(:(f(x) = x))
end

# ╔═╡ Cell order:
# ╠═ea0cc15e-fb38-11ea-2a6f-41d312244594
# ╠═2ce4e09c-fb36-11ea-16bb-0b77b4952e16
# ╠═46608b6e-fb36-11ea-262b-ebdc05a5de80
# ╠═b8e98c2e-fb38-11ea-0a00-8d70af998ad0
# ╠═4a383250-fb36-11ea-19c7-836b8ef865ea
# ╠═015b7296-fb3a-11ea-0483-df693d24c54b
