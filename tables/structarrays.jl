### A Pluto.jl notebook ###
# v0.12.7

using Markdown
using InteractiveUtils

# ╔═╡ ecb6ff58-234e-11eb-2a51-233441922862
begin
	import Pkg
	Pkg.activate(mktempdir())
	Pkg.add("StructArrays")
	using StructArrays, Random
end

# ╔═╡ 4031769a-234f-11eb-1d63-b30285df3bc9
using .PlutoRunner.Tables

# ╔═╡ 7b5fbc36-234f-11eb-1a21-81ef04a2378c


# ╔═╡ 16684a3c-234f-11eb-2489-7d0e0f56f8f2
s = StructArray{ComplexF64}((rand(2,2), rand(2,2)))

# ╔═╡ 0a4e7630-2350-11eb-3617-2fab5439a1f8
macroexpand(Main, quote @view a[1:2] end)

# ╔═╡ 80553ba8-234f-11eb-22c5-f1c423c30747
t = Tables.table(rand(400,400))

# ╔═╡ 482d60e2-2350-11eb-1fcf-51721f5ca3d6
hasmethod(view, (typeof([1,2,3]), typeof(1:3)))

# ╔═╡ 8709b0cc-2350-11eb-3c1e-cfa8692f628d
a = 1:100

# ╔═╡ ae70cf42-2350-11eb-1b9c-1564843fa2a2
t[3]

# ╔═╡ 2c40df44-2350-11eb-3c73-b34bbfd477a2
function tryview(x::T, idx...) where T
	if hasmethod(view, (T, typeof.(idx)...))
		view(x, idx...)
	else
		getindex(x, idx...)
	end
end

# ╔═╡ 82b8fa5a-2350-11eb-20f7-719f694738b8
tryview(t, 5:6)

# ╔═╡ Cell order:
# ╠═ecb6ff58-234e-11eb-2a51-233441922862
# ╠═4031769a-234f-11eb-1d63-b30285df3bc9
# ╠═7b5fbc36-234f-11eb-1a21-81ef04a2378c
# ╠═16684a3c-234f-11eb-2489-7d0e0f56f8f2
# ╠═0a4e7630-2350-11eb-3617-2fab5439a1f8
# ╠═80553ba8-234f-11eb-22c5-f1c423c30747
# ╠═482d60e2-2350-11eb-1fcf-51721f5ca3d6
# ╠═8709b0cc-2350-11eb-3c1e-cfa8692f628d
# ╠═82b8fa5a-2350-11eb-20f7-719f694738b8
# ╠═ae70cf42-2350-11eb-1b9c-1564843fa2a2
# ╠═2c40df44-2350-11eb-3c73-b34bbfd477a2
