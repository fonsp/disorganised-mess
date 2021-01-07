### A Pluto.jl notebook ###
# v0.12.7

using Markdown
using InteractiveUtils

# ╔═╡ 0919e286-234b-11eb-198f-abe8aeb440a5
using Tables

# ╔═╡ 5ed7c322-234c-11eb-1ea4-1f14a91910fe
using DataFrames

# ╔═╡ c622eba8-234a-11eb-2be7-5f6d2c0601a2
md"""
# Tests from PrettyTables.jl

[https://github.com/ronisbr/PrettyTables.jl/blob/master/test/general.jl](https://github.com/ronisbr/PrettyTables.jl/blob/master/test/general.jl)
"""

# ╔═╡ ee534c24-234a-11eb-21cc-c764c089cc0d
begin
	struct TestVec{T} <: AbstractArray{T,1}
		data::Array{T,1}
	end
	Base.IndexStyle(::Type{A}) where {A<:TestVec} = Base.IndexCartesian()
	Base.size(A::TestVec) = size(getfield(A, :data))
	Base.getindex(A::TestVec, index::Int) = getindex(getfield(A, :data), index)
	Base.collect(::Type{T}, itr::TestVec) where {T} = TestVec(collect(T, getfield(itr, :data)))
	Base.convert(::Type{<:TestVec}, x::Array) = TestVec(x)
end

# ╔═╡ 0093c50a-234b-11eb-111e-bf37accb4e9c
begin
	struct MinimalTable
		data::Matrix
		colnames::TestVec
	end

	Tables.istable(x::MinimalTable) = true
	Tables.columnaccess(::MinimalTable) = true
	Tables.columnnames(x::MinimalTable) = getfield(x, :colnames)
	Tables.columns(x::MinimalTable) = x
	Base.getindex(x::MinimalTable, i1, i2) = getindex(getfield(x, :data), i1, i2)
	Base.getproperty(x::MinimalTable, s::Symbol) = getindex(x, :, findfirst(==(s), Tables.columnnames(x)))
end

# ╔═╡ 0e4c421c-234b-11eb-1580-0bd1c2abe590
data = rand(3,3)

# ╔═╡ 20ccc128-234b-11eb-0bbd-478a4ccd4b31
mt = MinimalTable(data, [Symbol("Col. 1"), Symbol("Col. 2"), Symbol("Col. 3")])

# ╔═╡ 1f275806-234b-11eb-0dbf-53a5ab866d24
table = (A = Int64.(1:10),
		 B = Float64.(1:10),
		 C = Int64.(1:10),
		 D = Float64.(1:10))

# ╔═╡ 8904bc32-234b-11eb-084f-3152eb2378e0
t = Tables.rows(table)

# ╔═╡ 60e0b034-234c-11eb-16ca-c79a9418505f
DataFrame

# ╔═╡ c07f7bf2-234b-11eb-1169-09d095d0b68a
string(t)

# ╔═╡ ac14bde4-234b-11eb-04c1-85aedc721b66
@which Tables.rowaccess(t)

# ╔═╡ Cell order:
# ╟─c622eba8-234a-11eb-2be7-5f6d2c0601a2
# ╠═0919e286-234b-11eb-198f-abe8aeb440a5
# ╠═ee534c24-234a-11eb-21cc-c764c089cc0d
# ╠═0093c50a-234b-11eb-111e-bf37accb4e9c
# ╠═0e4c421c-234b-11eb-1580-0bd1c2abe590
# ╠═20ccc128-234b-11eb-0bbd-478a4ccd4b31
# ╠═1f275806-234b-11eb-0dbf-53a5ab866d24
# ╠═8904bc32-234b-11eb-084f-3152eb2378e0
# ╠═5ed7c322-234c-11eb-1ea4-1f14a91910fe
# ╠═60e0b034-234c-11eb-16ca-c79a9418505f
# ╠═c07f7bf2-234b-11eb-1169-09d095d0b68a
# ╠═ac14bde4-234b-11eb-04c1-85aedc721b66
