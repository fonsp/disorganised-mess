### A Pluto.jl notebook ###
# v0.14.3

using Markdown
using InteractiveUtils

# ╔═╡ 88cf841b-2879-429b-864f-96234b4c068e
using Plots

# ╔═╡ dd45b118-7a4d-45b3-8961-0c4fb337841b
using HypertextLiteral

# ╔═╡ a338a863-1f1a-468d-b359-969a0f1e12fd
p = plot(1:100, sqrt.(1:100))

# ╔═╡ a17cdd72-a28e-4d2b-8ae1-31625d2bb870
md"""
# Flex
"""

# ╔═╡ c93a61e2-dc02-4260-907d-1524b7910554


# ╔═╡ 9f5a12df-21c7-4f79-b1fb-908427943138
flex(x::Union{AbstractVector,Base.Generator}; kwargs...) = flex(x...; kwargs...)

# ╔═╡ df016b84-ab72-4659-9a5e-a63e4af85259
begin
	Base.@kwdef struct Div
		contents
		style=Dict()
	end
	
	Div(x) = Div(contents=x)
	
	function Base.show(io::IO, m::MIME"text/html", d::Div)
		h = @htl("""
			<div style=$(d.style)>
			$(d.contents)
			</div>
			""")
		show(io, m, h)
	end
end

# ╔═╡ 6e1d6a42-51e5-4dad-b149-78c805b90afa
function flex(args...; kwargs...)
	Div(;
		contents=collect(args),
		style=Dict("display" => "flex", ("flex-" * String(k) => string(v) for (k,v) in kwargs)...)
		)
end

# ╔═╡ 546b0da4-d5fd-4e58-bf47-7b187ae43ae8
flex(p, p, p)

# ╔═╡ 6eeec9ed-49bf-45dd-ae73-5cac8ca276f7
flex(rand(UInt8, 3)...)

# ╔═╡ f24c4b3e-5155-46d5-a328-932719617ca6
md"""
## Triangle
"""

# ╔═╡ 9bb89479-fa6c-44d0-8bd1-bdd3db2880f6
function pascal_row(n)
	if n == 1
		[1]
	else
		prev = pascal_row(n-1)
		[prev; 0] .+ [0; prev]
	end
end

# ╔═╡ a81011d5-e10f-4a58-941c-f69c4150730e
pascal_row(3)

# ╔═╡ 229274f2-5b10-4d58-944f-30d4acde04d8
pascal(n) = pascal_row.(1:n)

# ╔═╡ b2ef0286-0ae5-4e2f-ac8d-18d7f48b5646
pascal(5)

# ╔═╡ cf9c83c6-ee74-4fd4-ade4-5cd3d409f13f
let
	p = pascal(5)
	
	padder = Div(nothing, Dict("flex" => "1 1 auto"))
	
	rows = map(p) do row
		
		items = map(row) do item
			Div(item, Dict("margin" => "0px 5px"))
		end
		
		flex(
			[padder, items..., padder]
		)
	end
	flex(rows;
		direction="column"
	)
end

# ╔═╡ a8f02660-32d8-428f-a0aa-d8eb06efabda
repr(
	MIME"text/html"(),
	Div(nothing, Dict("a" => 2))
) |> Text

# ╔═╡ 0c5b1f00-57a6-494e-a508-cbac8b23b72e
d = "a" => "3"

# ╔═╡ 9238ec64-a123-486e-a615-2e7631a1123f
repr(
	MIME"text/html"(),
	@htl("""
		<div style=$(d)>
		asdf
		</div>
		
		""")
) |> Text

# ╔═╡ b1e7e95f-d6af-47e5-b6d4-1252804331d9
md"""
# Grid
"""

# ╔═╡ 8fbd9087-c932-4a01-bd44-69007e9f6656
function grid(items::AbstractMatrix; fill_width::Bool=true)
	Div(
		contents=Div.(vec(permutedims(items, [2,1]))), 
		style=Dict(
			"display" => fill_width ? "grid" : "inline-grid", 
			"grid-template-columns" => "repeat($(size(items,2)), auto)",
			"column-gap" => "1em",
		),
	)
end

# ╔═╡ 574ef2ab-6438-49f5-ba63-12e0b4f69c7a
grid([
		md"a"   md"b"
		md"c" md"d"
		md"e" md"f"
	])

# ╔═╡ 59c3941b-7377-4dbd-b0d2-75bf3bc7a8d1
grid(rand(UInt8, 10,8))

# ╔═╡ 4726f3fe-a761-4a58-a177-a2ef79663a90
grid(rand(UInt8, 10,10); fill_width=false)

# ╔═╡ 8eef743b-bea0-4a97-b539-0723a231441b
@htl("""
<style>
svg {
	max-width: 100%;
	height: auto;
}
</style>
""")

# ╔═╡ 081396af-0f8f-4d2a-b087-dfba01bfd7a7
grid([
		p p
		p p
	])

# ╔═╡ 18cc9fbe-a37a-11eb-082b-e99673bd677d
function aside(x)
	@htl("""
		<style>
		
		
		@media (min-width: calc(700px + 30px + 300px)) {
			aside.plutoui-aside-wrapper {
				position: absolute;
				right: -11px;
				width: 0px;
			}
			aside.plutoui-aside-wrapper > div {
				width: 300px;
			}
		}
		</style>
		
		<aside class="plutoui-aside-wrapper">
		<div>
		$(x)
		</div>
		</aside>
		
		""")
end

# ╔═╡ d24dfd97-5100-45f4-be12-ad30f98cc519
aside(p)

# ╔═╡ a5164ad2-5ccc-4bef-8996-ad5e94226574


# ╔═╡ 9a166646-75c2-4711-9fad-665b01731759
sbig = md"""
To see the various ways we can pass dimensions to these functions, consider the following examples:
```jldoctest
julia> zeros(Int8, 2, 3)
2×3 Matrix{Int8}:
 0  0  0
 0  0  0

julia> zeros(Int8, (2, 3))
2×3 Matrix{Int8}:
 0  0  0
 0  0  0

julia> zeros((2, 3))
2×3 Matrix{Float64}:
 0.0  0.0  0.0
 0.0  0.0  0.0
```
Here, `(2, 3)` is a [`Tuple`](@ref) and the first argument — the element type — is optional, defaulting to `Float64`.

## [Array literals](@id man-array-literals)

Arrays can also be directly constructed with square braces; the syntax `[A, B, C, ...]`
creates a one dimensional array (i.e., a vector) containing the comma-separated arguments as
its elements. The element type ([`eltype`](@ref)) of the resulting array is automatically
determined by the types of the arguments inside the braces. If all the arguments are the
same type, then that is its `eltype`. If they all have a common
[promotion type](@ref conversion-and-promotion) then they get converted to that type using
[`convert`](@ref) and that type is the array's `eltype`. Otherwise, a heterogeneous array
that can hold anything — a `Vector{Any}` — is constructed; this includes the literal `[]`
where no arguments are given.
""";

# ╔═╡ 50c3dce4-48c7-46b4-80a4-5af9cd83a0a8
smid = md"""

## [Array literals](@id man-array-literals)

Arrays can also be directly constructed with square braces; the syntax `[A, B, C, ...]`
creates a one dimensional array (i.e., a vector) containing the comma-separated arguments as
its elements. The element type ([`eltype`](@ref)) of the resulting array is automatically
determined by the types of the arguments inside the braces. If all the arguments are the
same type, then that is its `eltype`. If they all have a common
[promotion type](@ref conversion-and-promotion) then they get converted to that type using
[`convert`](@ref) and that type is the array's `eltype`. Otherwise, a heterogeneous array
that can hold anything — a `Vector{Any}` — is constructed; this includes the literal `[]`
where no arguments are given.
"""

# ╔═╡ 87d374e1-e75f-468f-bc90-59d2013c361f
ssmall = md"""

Arrays can also be directly constructed with square braces; the syntax `[A, B, C, ...]`
creates a one dimensional array (i.e., a vector) containing the comma-separated arguments as
its elements.
"""

# ╔═╡ 32aea35b-7b19-4568-a569-7fe5ecb23d00
flex(smid, ssmall, ssmall; direction="row")

# ╔═╡ b2aa64b7-8bbc-4dd6-86a6-731a7a2e9c14
md"""
# Aside
asdfsadf
a
sdf
asdf

$(aside(ssmall))

a
sdf
asd
f



asdfasdf

"""

# ╔═╡ Cell order:
# ╠═88cf841b-2879-429b-864f-96234b4c068e
# ╠═a338a863-1f1a-468d-b359-969a0f1e12fd
# ╠═546b0da4-d5fd-4e58-bf47-7b187ae43ae8
# ╠═a17cdd72-a28e-4d2b-8ae1-31625d2bb870
# ╠═c93a61e2-dc02-4260-907d-1524b7910554
# ╠═32aea35b-7b19-4568-a569-7fe5ecb23d00
# ╠═6eeec9ed-49bf-45dd-ae73-5cac8ca276f7
# ╠═6e1d6a42-51e5-4dad-b149-78c805b90afa
# ╠═9f5a12df-21c7-4f79-b1fb-908427943138
# ╠═df016b84-ab72-4659-9a5e-a63e4af85259
# ╟─f24c4b3e-5155-46d5-a328-932719617ca6
# ╠═9bb89479-fa6c-44d0-8bd1-bdd3db2880f6
# ╠═a81011d5-e10f-4a58-941c-f69c4150730e
# ╠═229274f2-5b10-4d58-944f-30d4acde04d8
# ╠═b2ef0286-0ae5-4e2f-ac8d-18d7f48b5646
# ╠═cf9c83c6-ee74-4fd4-ade4-5cd3d409f13f
# ╠═9238ec64-a123-486e-a615-2e7631a1123f
# ╠═a8f02660-32d8-428f-a0aa-d8eb06efabda
# ╠═0c5b1f00-57a6-494e-a508-cbac8b23b72e
# ╠═b1e7e95f-d6af-47e5-b6d4-1252804331d9
# ╠═574ef2ab-6438-49f5-ba63-12e0b4f69c7a
# ╠═59c3941b-7377-4dbd-b0d2-75bf3bc7a8d1
# ╠═4726f3fe-a761-4a58-a177-a2ef79663a90
# ╠═8fbd9087-c932-4a01-bd44-69007e9f6656
# ╠═8eef743b-bea0-4a97-b539-0723a231441b
# ╠═081396af-0f8f-4d2a-b087-dfba01bfd7a7
# ╠═b2aa64b7-8bbc-4dd6-86a6-731a7a2e9c14
# ╠═d24dfd97-5100-45f4-be12-ad30f98cc519
# ╠═dd45b118-7a4d-45b3-8961-0c4fb337841b
# ╠═18cc9fbe-a37a-11eb-082b-e99673bd677d
# ╠═a5164ad2-5ccc-4bef-8996-ad5e94226574
# ╠═9a166646-75c2-4711-9fad-665b01731759
# ╟─50c3dce4-48c7-46b4-80a4-5af9cd83a0a8
# ╟─87d374e1-e75f-468f-bc90-59d2013c361f
