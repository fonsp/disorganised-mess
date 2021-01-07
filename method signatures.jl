### A Pluto.jl notebook ###
# v0.12.0

using Markdown
using InteractiveUtils

# ╔═╡ 9ac4933a-0764-11eb-1c84-65e3cd5ed0af
using PlutoUI

# ╔═╡ 7991d3ca-0762-11eb-25ce-0108c5481ce7
f(x,y::Any,z::Union{Int,Float64}=3; a=1, b) = x

# ╔═╡ 95666098-0762-11eb-2397-f3c512b8908a
methods(f)

# ╔═╡ 99f65212-0762-11eb-0804-25104b4da2e4
methods(f).ms

# ╔═╡ a4a1a9f0-0762-11eb-11e0-39f583552b57
m = methods(f).ms[2]

# ╔═╡ 3db3caf8-0764-11eb-35e9-abd17481ea36
@which Base.kwarg_decl(m)

# ╔═╡ eae2ced2-0763-11eb-2ecb-6bdd296b3d57
@which Base.show(stdout, MIME"text/html"(), m)

# ╔═╡ 4d6e4bf0-0764-11eb-147a-bf4d53fb3b52
mt = methods(f).mt

# ╔═╡ 56410ed2-0764-11eb-019b-f1b43a45ec58
mt.kwsorter

# ╔═╡ 0e810630-0764-11eb-3e44-371c7729316a
Base.kwarg_decl(m)

# ╔═╡ dac92bba-0763-11eb-098f-ab8c2af4daa8
m.nkw

# ╔═╡ a71cb012-0762-11eb-3e88-9f7c4d40ef76
m.sig

# ╔═╡ de9c0bce-0764-11eb-077b-a5746ca836ec
Dump(quote
		f(x::A.B, y::Any, z::f(x)) = 1
	end; maxdepth=123)

# ╔═╡ 2a29a2b0-0765-11eb-3f31-634e3ad9280f
:(A.B) == :(A.B)

# ╔═╡ Cell order:
# ╠═7991d3ca-0762-11eb-25ce-0108c5481ce7
# ╠═95666098-0762-11eb-2397-f3c512b8908a
# ╠═99f65212-0762-11eb-0804-25104b4da2e4
# ╠═a4a1a9f0-0762-11eb-11e0-39f583552b57
# ╠═3db3caf8-0764-11eb-35e9-abd17481ea36
# ╠═eae2ced2-0763-11eb-2ecb-6bdd296b3d57
# ╠═4d6e4bf0-0764-11eb-147a-bf4d53fb3b52
# ╠═56410ed2-0764-11eb-019b-f1b43a45ec58
# ╠═0e810630-0764-11eb-3e44-371c7729316a
# ╠═dac92bba-0763-11eb-098f-ab8c2af4daa8
# ╠═a71cb012-0762-11eb-3e88-9f7c4d40ef76
# ╠═9ac4933a-0764-11eb-1c84-65e3cd5ed0af
# ╠═de9c0bce-0764-11eb-077b-a5746ca836ec
# ╠═2a29a2b0-0765-11eb-3f31-634e3ad9280f
