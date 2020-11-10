### A Pluto.jl notebook ###
# v0.12.7

using Markdown
using InteractiveUtils

# ╔═╡ 7288f73e-2355-11eb-032b-8bcc8a21466c
begin
	import Pkg
	Pkg.activate(mktempdir())
	Pkg.add("AxisIndices")
	using AxisIndices
end

# ╔═╡ 8d2e52f0-2355-11eb-0ea9-5decdbb5f0ef
nax = NamedAxisArray(reshape(1:4, 2, 2), x = [:a, :b], y = ["c", "d"])

# ╔═╡ a4770a40-2355-11eb-0bb4-ab1aff67f637
x = reshape(1:8, 2, 4)

# ╔═╡ 9172afbe-2355-11eb-3c32-add9ec07811d
aa = AxisArray(3:4, one_pad(sym_pad=2))

# ╔═╡ f63c2178-2355-11eb-35a3-cf0950a6b8e7
eachindex(aa)

# ╔═╡ 650102f2-2356-11eb-229f-f9731a482981
123

# ╔═╡ 97cecbcc-2355-11eb-240b-93ca6f626b11
collect(aa)

# ╔═╡ Cell order:
# ╠═7288f73e-2355-11eb-032b-8bcc8a21466c
# ╠═8d2e52f0-2355-11eb-0ea9-5decdbb5f0ef
# ╠═a4770a40-2355-11eb-0bb4-ab1aff67f637
# ╠═9172afbe-2355-11eb-3c32-add9ec07811d
# ╠═f63c2178-2355-11eb-35a3-cf0950a6b8e7
# ╠═650102f2-2356-11eb-229f-f9731a482981
# ╠═97cecbcc-2355-11eb-240b-93ca6f626b11
