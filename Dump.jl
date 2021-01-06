### A Pluto.jl notebook ###
# v0.11.14

using Markdown
using InteractiveUtils

# ╔═╡ 1d015dd4-009f-11eb-3247-994e422271f6
mutable struct A
	x 
	y
end

# ╔═╡ 2d9d28da-009f-11eb-3319-e340c790b132
circ = let
	one = A(1,2)
	two = A(3,one)
	one.y = two
	one
end

# ╔═╡ 3724f462-009f-11eb-2a39-2b8672d3e8bd
"""
    Dump(x; maxdepth=8)

Show every part of the representation of a value. The depth of the output is truncated at maxdepth. 

This is a variant of [`Base.dump`](@ref) that returns the representation directly, instead of printing it to stdout.
"""
function Dump(x; maxdepth=8)
	sprint() do io
		dump(io, x; maxdepth=maxdepth)
	end |> Text
end

# ╔═╡ 6ffb144e-009f-11eb-083d-3f9cbe0bcd9a
Dump(:(f(x) = 1123))

# ╔═╡ 7bbcbde6-009f-11eb-3dc9-7369a6b2b681
Dump(circ)

# ╔═╡ bf9f3c9e-00a1-11eb-0fa5-9b88d1f0f500


# ╔═╡ Cell order:
# ╠═1d015dd4-009f-11eb-3247-994e422271f6
# ╠═2d9d28da-009f-11eb-3319-e340c790b132
# ╠═6ffb144e-009f-11eb-083d-3f9cbe0bcd9a
# ╠═7bbcbde6-009f-11eb-3dc9-7369a6b2b681
# ╠═3724f462-009f-11eb-2a39-2b8672d3e8bd
# ╠═bf9f3c9e-00a1-11eb-0fa5-9b88d1f0f500
