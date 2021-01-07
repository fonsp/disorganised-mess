### A Pluto.jl notebook ###
# v0.12.7

using Markdown
using InteractiveUtils

# ╔═╡ d3d71650-ed6e-11ea-0edd-cbb7b02c31e8
begin
	import Pkg
	Pkg.activate(mktempdir())
end

# ╔═╡ e3750e32-ed6e-11ea-1a6b-674a7fa4819b
begin
	Pkg.add("OffsetArrays")
	using OffsetArrays
end

# ╔═╡ eb698ba4-ed6e-11ea-22d9-2bfcda0eaec2
A = reshape(1:15, 3, 5)

# ╔═╡ 256dc3b0-ed6f-11ea-0b2b-2177fc039926
OA = OffsetArray(A, -1:1, 0:4)    # OA will have axes (-1:1, 0:4)

# ╔═╡ 87f1606e-ed6f-11ea-3b9e-4382351f8052
OffsetArray(rand(100),30)

# ╔═╡ 2dc38d10-ed6f-11ea-2176-89cc7b0946d8
B = collect(rand(10))

# ╔═╡ a3ee007e-2359-11eb-1917-a3126c6b46f9


# ╔═╡ 6f7652c2-2359-11eb-04a2-bb46da403821
OffsetArray(zeros(3), 20:22)

# ╔═╡ 495d2ee6-ed6f-11ea-2725-bf610648aee0
OB = OffsetArray(B, 5)

# ╔═╡ 6c8c3ce4-2358-11eb-08d8-db32465c8d26
[
	OB[i] for i in eachindex(OB)
] |> collect

# ╔═╡ 643dd22e-ed6f-11ea-243b-f766e9895d6f
enumerate(OB) |> collect

# ╔═╡ 590c7a4c-ed6f-11ea-01f6-3d252fe8767e
p = pairs(IndexLinear(), OB) |> collect

# ╔═╡ 8afb1170-ed75-11ea-0bdb-f9196a8f82c8
[(1,2),(3,[4,5])]

# ╔═╡ 11733152-ed76-11ea-2f07-076031de6ae8
NamedTuple

# ╔═╡ cebdee1c-ed75-11ea-3832-614c38b4b1c1
nt = (a=1,b=2)

# ╔═╡ 63244b50-ed76-11ea-368f-2f3640143eac
nt |> typeof

# ╔═╡ 7a6a528c-ed76-11ea-1d35-45057a5ec8ad
nt isa NTuple

# ╔═╡ 377f1ab0-ed77-11ea-37b4-77989f5838f1
sprint(print, :a)

# ╔═╡ 18ca6422-ed76-11ea-0714-51e1d47f66ae
t = (1,2,3)

# ╔═╡ 7ff5f1fa-ed76-11ea-3107-8b615da0ebec
t isa Tuple

# ╔═╡ 461006f8-ed76-11ea-206a-a55cc397e695
zip(eachindex(t), t) |> collect

# ╔═╡ 6720c6d4-ed76-11ea-34cd-110dcec1e24b
zip(eachindex(nt), nt) |> collect

# ╔═╡ ce2acf78-ed76-11ea-0d14-a77292449691
let
	a,b = (1,2)
end

# ╔═╡ bfac95ca-ed77-11ea-0907-b56ad7aa580a
1 => 2

# ╔═╡ b7ea4670-ed7c-11ea-0a01-37784baebbd2
r = Ref((1,2))

# ╔═╡ be052962-ed7c-11ea-18e4-51e7014b719d
r isa Ref{Tuple{Int,Int}}

# ╔═╡ d58340bc-ed75-11ea-13c9-b76f5f0ac984
d=Dict([:a=>1,:b=>2])

# ╔═╡ a7efbaa8-ed76-11ea-00a3-797773f2e60f
collect(d)

# ╔═╡ aa602b7a-ed75-11ea-341d-c369f83b3d41
Tuple(1:1000)

# ╔═╡ aa856ab6-ed70-11ea-1e79-6536c58a0dff
(md"" |> typeof).name

# ╔═╡ 8b54e5b0-ed73-11ea-12c9-1df1e56be6c0
sprint(print, nameof(AbstractDict))

# ╔═╡ 2d590874-ed73-11ea-03a0-4f28250e2d59
@which Base.show(stdout, p |> typeof)

# ╔═╡ d074ffac-ed70-11ea-0953-77226277edb5
eachindex(OB)[1:3]

# ╔═╡ 460fdee4-ed71-11ea-2ae9-bb4dd522e4dd
LinearIndices(OB)[1:3]

# ╔═╡ 6dcaabca-ed72-11ea-2ca1-9d66420e28a3
OB

# ╔═╡ 77d2f1b8-ed72-11ea-36c3-8d791b899b19
begin:begin+1

# ╔═╡ dbc402a8-ed71-11ea-370f-3d12aa69586b
zip(eachindex(OB)[begin:begin+3-1], OB[begin:begin+3-1]) |> collect

# ╔═╡ 0bb5e170-ed72-11ea-16ee-35d1233c62d6
OB[end-3+1:end]

# ╔═╡ Cell order:
# ╠═d3d71650-ed6e-11ea-0edd-cbb7b02c31e8
# ╠═e3750e32-ed6e-11ea-1a6b-674a7fa4819b
# ╠═eb698ba4-ed6e-11ea-22d9-2bfcda0eaec2
# ╠═256dc3b0-ed6f-11ea-0b2b-2177fc039926
# ╠═87f1606e-ed6f-11ea-3b9e-4382351f8052
# ╠═2dc38d10-ed6f-11ea-2176-89cc7b0946d8
# ╠═a3ee007e-2359-11eb-1917-a3126c6b46f9
# ╠═6f7652c2-2359-11eb-04a2-bb46da403821
# ╠═495d2ee6-ed6f-11ea-2725-bf610648aee0
# ╠═6c8c3ce4-2358-11eb-08d8-db32465c8d26
# ╠═643dd22e-ed6f-11ea-243b-f766e9895d6f
# ╠═590c7a4c-ed6f-11ea-01f6-3d252fe8767e
# ╠═8afb1170-ed75-11ea-0bdb-f9196a8f82c8
# ╠═11733152-ed76-11ea-2f07-076031de6ae8
# ╠═cebdee1c-ed75-11ea-3832-614c38b4b1c1
# ╠═63244b50-ed76-11ea-368f-2f3640143eac
# ╠═7ff5f1fa-ed76-11ea-3107-8b615da0ebec
# ╠═7a6a528c-ed76-11ea-1d35-45057a5ec8ad
# ╠═377f1ab0-ed77-11ea-37b4-77989f5838f1
# ╠═18ca6422-ed76-11ea-0714-51e1d47f66ae
# ╠═461006f8-ed76-11ea-206a-a55cc397e695
# ╠═6720c6d4-ed76-11ea-34cd-110dcec1e24b
# ╠═ce2acf78-ed76-11ea-0d14-a77292449691
# ╠═a7efbaa8-ed76-11ea-00a3-797773f2e60f
# ╠═bfac95ca-ed77-11ea-0907-b56ad7aa580a
# ╠═b7ea4670-ed7c-11ea-0a01-37784baebbd2
# ╠═be052962-ed7c-11ea-18e4-51e7014b719d
# ╠═d58340bc-ed75-11ea-13c9-b76f5f0ac984
# ╠═aa602b7a-ed75-11ea-341d-c369f83b3d41
# ╠═aa856ab6-ed70-11ea-1e79-6536c58a0dff
# ╠═8b54e5b0-ed73-11ea-12c9-1df1e56be6c0
# ╠═2d590874-ed73-11ea-03a0-4f28250e2d59
# ╠═d074ffac-ed70-11ea-0953-77226277edb5
# ╠═460fdee4-ed71-11ea-2ae9-bb4dd522e4dd
# ╠═6dcaabca-ed72-11ea-2ca1-9d66420e28a3
# ╠═77d2f1b8-ed72-11ea-36c3-8d791b899b19
# ╠═dbc402a8-ed71-11ea-370f-3d12aa69586b
# ╠═0bb5e170-ed72-11ea-16ee-35d1233c62d6
