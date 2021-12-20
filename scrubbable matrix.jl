### A Pluto.jl notebook ###
# v0.17.3

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ b905dbca-76de-4e99-81da-73da2b01dc71
using PlutoUI

# ╔═╡ dd4ea914-8343-4f93-af7e-22caaa286b3e
using Images

# ╔═╡ 93b9d789-1e17-48ee-bcf3-43f1a35e572d
A = rand(8,6)

# ╔═╡ 51a7ca06-5723-4c2b-8aba-bcdce5d33432
md"""
# Example: matrix of scrubbers

Click and drag one of the numbers below to modify `B`.
"""

# ╔═╡ 969e2478-9785-487f-90e2-fdea675a9b0d
md"""
# Example: select entries

Click and drag to select entries. Use `Ctrl` (Windows) or `Cmd` (Mac) to combine selections.
"""

# ╔═╡ 7cf98200-208f-4e98-92e2-eb82765f3023
md"""
# Example: select entries with multiplier

Click and drag to select entries. Use `Ctrl` (Windows) or `Cmd` (Mac) to combine selections.
"""

# ╔═╡ c1adf009-7b78-4279-9c3a-bfe05a75e8bf
@bind multiplier2 Slider(LinRange(0.0,2.0,51); default=1.0, show_value=true)

# ╔═╡ 9cf18586-7ed6-4624-945b-f8a69a27a507
md"""
# Example: `show_matrix`
"""

# ╔═╡ 0b8bbf9e-9400-4aad-9804-3c703f10c913
md"""
As a second argument, you can pass a `Matrix{Bool}` of elements that should be shown in red.
"""

# ╔═╡ b34a075f-d16d-4d00-9b7e-63cea1132a2c
html"""
<div style='height: 70vh'>"""

# ╔═╡ edc49720-f844-44f3-8db3-3e76fc5c263f
md"""
# Appendix

To use this widgets in another notebook, copy all cells in this appendix to a new notebook.
"""

# ╔═╡ cab92b50-e47e-4d26-9922-01951339ec5f
import HypertextLiteral: @htl

# ╔═╡ 2667aa28-4c2f-4bc6-a27a-8c37c6685095
md"""
## Select entries
"""

# ╔═╡ d8b7ef38-7b3b-492b-a08a-d6024af11afc
function unwrap(template::AbstractMatrix{T}, input::Vector) where T
	Matrix{T}(reshape(input, size(template) |> reverse)')
end

# ╔═╡ f10ce95e-5d67-4d8d-bbe6-383aee285c67
function bounding_box(A::AbstractMatrix{Bool})
	if !any(A)
		(1:0), (1:0)
	else
		rows = any(A; dims=2) |> vec
		cols = any(A; dims=1) |> vec
		(findfirst(rows):findlast(rows)), (findfirst(cols):findlast(cols))
	end
end

# ╔═╡ 14a8b29e-c455-4a1b-90c0-9ee3e14c7558
hello = rand(Bool, 3, 2)

# ╔═╡ 62560766-f6bd-4909-8080-a0e5dad9fb68
select_entries_style = @htl("""
<style>

.rs-root {
}
.rs-container {
  padding: 0.5rem;
  display: inline-grid;
  flex-wrap: wrap;
  background: #dbe9ff;
  border-radius: 0.5rem;
  user-select: none;
}

.rs-container.gap {
  grid-gap: 0.5rem;
}

.rs-container > div {
	min-width: 20px;
	min-height: 20px;
}
.rs-container.small > div {
	min-width: 10px;
	min-height: 10px;
}
.rs-container.gap > div {
  border-radius: 0.25rem;
}

.rs-container > div.selected {
    border: 3px solid #bf1d39;
}

.selection-area {
  border: 1px solid #4f90f2;
}


</style>
""")

# ╔═╡ 7d054ee9-e6bc-4b20-b893-319e087fc6cc
rows(A) = [A[i,:] for i in 1:size(A,1)]

# ╔═╡ 29eca628-1603-4ce2-9952-ac6d35c8dd87
md"""
## scrub_matrix
"""

# ╔═╡ 4269201c-e46d-48f2-bc69-982eaa130f5c
function default_range(x::Integer)
	if x == 0
		-10:10
	elseif 0 < x <= 10
		0:10
	elseif -10 <= x < 0
		-10:0
	else
		sort(round.([Int64], (0.0:0.1:2.0) .* x))
	end
end

# ╔═╡ a80d92ad-e6c0-497c-ac0d-79e865a74dc7
function default_range(x::Any)
	[-1,0,1]
end

# ╔═╡ 7f139b38-424f-49f1-b7b6-3b6be6f223c6
up_or_down_one_order_of_magnitude = 10 .^ (-1.0:0.1:1.0)

# ╔═╡ 105ab6a9-8cfe-42e2-8d68-a7904a69bb4d
function default_range(x::Real) # not an integer
	if x == 0
		-1.0 : 0.1 : 1.0
	elseif 0 < x < 1
		between_zero_and_x = LinRange(0.0, x, 10)
		between_x_and_one = LinRange(x, 1.0, 10)
		[between_zero_and_x..., between_x_and_one[2:end]...]
	else
		sort(x .* up_or_down_one_order_of_magnitude)
	end
end

# ╔═╡ 217e9838-2136-428d-9c2e-651203788c62
A99 = randn(4,3)

# ╔═╡ cc6bd3ab-f9e8-4944-acbf-7fce387e3102
md"""
## Transform superwidget
"""

# ╔═╡ f325066b-0e80-4892-a574-bb57a9864e67
import AbstractPlutoDingetjes: AbstractPlutoDingetjes, Bonds

# ╔═╡ c9896dfa-1fbe-11ec-0ba6-39909fd14292
begin
	Base.@kwdef struct SelectEntries
		default::Matrix{Bool}
		colors::Union{Nothing,Matrix{<:Real}}=nothing
		id::String=join(rand('a':'z', 16))
	end
	SelectEntries(x::Matrix; kwargs...) = SelectEntries(;default=zeros(Bool, size(x)), colors=zeros(Float64, size(x)), kwargs...)
	SelectEntries(x::Matrix{<:Real}; kwargs...) = SelectEntries(;default=zeros(Bool, size(x)), colors=x, kwargs...)
	SelectEntries(x::Matrix{Bool}; kwargs...) = SelectEntries(;default=x, colors=zeros(Float64, size(x)), kwargs...)

	Bonds.transform_value(se::SelectEntries, from_js) = unwrap(se.default, from_js)
	Bonds.initial_value(s::SelectEntries) = s.default
	
	function Base.show(io::IO, m::MIME"text/html", s::SelectEntries)
		show_gap = (s.colors === nothing) && length(s.default) < 200
		show_small = length(s.default) > 200
		show(io, m, @htl("""<script id=$(s.id)>
const { default: SelectionArea } = await import("https://cdn.jsdelivr.net/npm/@viselect/vanilla@3.0.0-beta.11/lib/viselect.esm.js")

const size = $(size(s.default))
const colors = $(s.colors == nothing ? rows(fill(1.0, size(s.default))) : rows(s.colors))


const dots = colors.flatMap(row => row.map(i => html`<div style='background: hsl(0, 0%, \${i * 100}%)'></div>`))

const container = html`<div class="rs-container \${$(show_gap) ? "gap" : ""} \${$(show_small) ? "small" : ""}" style='\${`
  grid-template-columns: repeat(\${size[1]}, auto);
		`}'>\${dots}</div>`


const update_classes = () => {
	const sel = selection.getSelection()
	dots.forEach((el) => {
		el.classList.toggle("selected", sel.includes(el))
	})
}

const selection = new SelectionArea({
	  selectables: dots,
  boundaries: container,
})
  .on("start", ({ store, event }) => {
    if (!event.ctrlKey && !event.metaKey) {
      store.stored.forEach((el) => {
        el.classList.remove("selected");
		})

      selection.clearSelection();
    }
  })
  .on(
    "move",
    ({
      store: {
        changed: { added, removed }
      }
    }) => {
      added.forEach((el) => {
        el.classList.add("selected");
		})

      removed.forEach((el) => {
        el.classList.remove("selected");
		})
    }
  )
  .on("stop", ({ store: { stored } }) => {
	requestAnimationFrame(() => root.dispatchEvent(new CustomEvent("input")))
});



console.log(selection)

const root = html`<div class="rs-root">
\${container}
</div>`
Object.defineProperty(root, 'value', {
	get: () => {
const sel = selection.getSelection()
		return dots.map(el => sel.includes(el))
},
	set: val => {
		if(!val){
			return
		}
	
	dots.forEach((el,i) => {
		if(val[i]){

		selection.select(el)
} else {
	selection.deselect(el)
}
})
update_classes()
},
	configurable: true,
});
		root.value = $(vec(s.default'))

return root

</script>

"""))
	end
	
	SelectEntries
end

# ╔═╡ 969b76be-ed55-4a5a-96ed-a5a90941e56d
@bind which_entries1 SelectEntries(A)

# ╔═╡ d2aaaf27-bef4-4578-9560-38f41abfd685
which_entries1

# ╔═╡ 0a386c73-5996-49f8-ba6a-257d0c360df7
@bind which_entries2 SelectEntries(A)

# ╔═╡ 2ed15919-cdf6-4de6-b3d8-af5a8a3aafcf
C = let
	C = copy(A)
	C[which_entries2] .*= multiplier2
	C
end

# ╔═╡ 626cffd7-2816-4ccc-b805-4c51b1a20943
@bind dope SelectEntries(A99)

# ╔═╡ 1ee82745-8079-4339-b3fa-b0496867fe8c
dope

# ╔═╡ 8dee5146-f62c-46cd-8681-40efa878c1fc
b88 = @bind omg SelectEntries(default=hello)

# ╔═╡ ec94d94e-4de0-4477-b2cb-a6ff9d5758a1
omg_bounded = let
	x = zero(omg)
	bb = bounding_box(omg)
	x[bb[1], bb[2]] .= true
	x
end

# ╔═╡ 0199403e-6cc2-4bd6-8bbb-c5e94d215ddf
b88

# ╔═╡ febcb6de-3357-42f0-b474-c66c065ffdeb
const compat_error = HTML("<span>❌ You need to update Pluto to use this PlutoUI element.</span>")

# ╔═╡ 62c9de22-b4f8-4aec-b0a9-9ce6f820bbc6
begin
	struct TransformedWidget{T}
		x::T
		transform::Function
		initial_value::Union{Nothing,Function}
	end

	function Base.show(io::IO, m::MIME"text/html", tw::TransformedWidget)
		supported = AbstractPlutoDingetjes.is_supported_by_display(io, Bonds.transform_value) && AbstractPlutoDingetjes.is_supported_by_display(io, Bonds.initial_value)
		
		return Base.show(io, m, supported ? tw.x : compat_error)
	end

	# AbstractPlutoDingetjes.jl
	
	function Bonds.transform_value(tw::TransformedWidget, from_js)
		tw.transform(Bonds.transform_value(tw.x, from_js))
	end

	function Bonds.initial_value(tw::TransformedWidget)
		if tw.initial_value !== nothing
			tw.initial_value()
		else
			try
				Bonds.transform_value(tw, Bonds.initial_value(tw.x))
			catch
				missing
			end
		end
	end

	# These next two methods are about the value *before* transformation
	# so the user does not need to define those. Yay!
	Bonds.possible_values(tw::TransformedWidget) = 
		Bonds.possible_values(tw.x)
	
	Bonds.validate_value(tw::TransformedWidget, from_browser) = 
		Bonds.validate_value(tw.x, from_browser)

	TransformedWidget
end

# ╔═╡ df429145-a9f6-4838-861f-740cdec479e3
"""
```julia
transformed_value(transform::Function, widget::Any; [initial_value::Function])
```

Create a new widget that wraps around an existing one, with a **value transformation**. 

This function creates a so-called *high-level widget*: it returns your existing widget, but with additional functionality. You can use it in your package 

# Example
A simple example to get the point accross:
```julia
function RepeatedTextSlider(text::String)
	transform = input -> repeat(text, input)
	new_widget = transformed_value(transform, PlutoUI.Slider(1:10))
	return new_widget
end

@bind greeting RepeatedTextSlider("hello")

# moving the slider to the right...

greeting == "hellohellohello"
```

![screenshot of the above code in action](https://user-images.githubusercontent.com/6933510/146782076-a993f50c-de27-4a6b-956d-264a5002bfba.gif)

---

This function is very useful in combination with `PlutoUI.combine`. Let's enhance our previous example by **adding a text box** where the repeated text can be entered. If you have not used `PlutoUI.combine` yet, you should read about that first.

```julia
function RepeatedTextSlider()
	# Note that the input to `transform` is now a Tuple!
	# (This is the output of `PlutoUI.combine`)
	transform = input -> repeat(input[1], input[2])

	old_widget = PlutoUI.combine() do Child
		md""\" \$(Child(PlutoUI.TextField())) \$(Child(PlutoUI.Slider(1:10)))""\"
	end
	new_widget = transformed_value(transform, old_widget)
	return new_widget
end
```

![screenshot of the above code in action](https://user-images.githubusercontent.com/6933510/146782947-45d67770-03fe-4cf7-82ce-0b9f877688f4.gif)

"""
function transformed_value(f::Function, x::Any; initial_value::Union{Nothing,Function}=nothing)
	TransformedWidget(
		x,
		f,
		initial_value
	)
end

# ╔═╡ d546d6b8-c49b-43f5-b516-1a693bbb979a
function scrub_matrix(A::Matrix{<:Real}; kwargs...)
	
	
	h = PlutoUI.combine() do Child
		@htl("""
		<div style=$(Dict(
			"display" => "inline-grid",
			"grid-template-columns" => "repeat($(size(A,2)), auto)",
		))>$(
			map(eachindex(A')) do I
				init = A'[I]
				
				Child(Scrubbable(default_range(init); default=init, kwargs...))
			end
		
		)</div>
		
		""")
	end

	transformed_value(h) do input
		unwrap(A, collect(input))
	end
end

# ╔═╡ f80662e7-e437-4871-b084-28eb6903ba94
@bind B scrub_matrix(A)

# ╔═╡ e57c8302-4238-46a6-83ac-588609a42924
B

# ╔═╡ 6864add2-6736-4ba6-a513-904ded50b996
b2 = @bind result scrub_matrix(A99)

# ╔═╡ a1727fe8-dd68-43ec-8c23-04728884d998
b2

# ╔═╡ bbdfad49-8afb-4f66-b2ab-16227e1ecec9
result

# ╔═╡ c15a7c26-6794-42c5-a048-baae3b08d205
md"""
## `show_matrix`
"""

# ╔═╡ 58643c65-819d-421b-b7f4-b26d4d5b85d9
function show_matrix(A::Matrix, red::Union{BitMatrix,Matrix{Bool}}=zeros(Bool, size(A)))
	base = RGB.(Gray.(A))

	base[red] .= RGB(1.0, 0.1, 0.1)

	# some tricks to show the pixels more clearly:
	s = max(size(A)...)
	if s >= 20
		min_size = 1200
		factor = min(5,min_size ÷ s)
		
		kron(base, ones(factor, factor))
	else
		base
	end
end

# ╔═╡ c121b4f7-a113-4bf7-90b4-c1e4775bc956
show_matrix(A)

# ╔═╡ fcc00027-618a-44aa-be77-e137d1518ac1
show_matrix(A, A .> .9)

# ╔═╡ 9699d51e-22ad-4138-b91b-88a3e730dd3c
show_matrix(A, (A .> .9) .| (A .< .1))

# ╔═╡ d4c9ad06-c0ab-4ab0-a445-a77d2c854a75
image_rendering_css = @htl("""
<style>
img {
image-rendering: pixelated;
}
</style>
""")

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
AbstractPlutoDingetjes = "6e696c72-6542-2067-7265-42206c756150"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
Images = "916415d5-f1e6-5110-898d-aaa5f9f070e0"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
AbstractPlutoDingetjes = "~1.1.2"
HypertextLiteral = "~0.9.3"
Images = "~0.25.0"
PlutoUI = "~0.7.25"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[AbstractFFTs]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "485ee0867925449198280d4af84bdb46a2a404d0"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.0.1"

[[AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "abb72771fd8895a7ebd83d5632dc4b989b022b5b"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.2"

[[Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "84918055d15b3114ede17ac6a7182f68870c16f7"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.1"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[ArnoldiMethod]]
deps = ["LinearAlgebra", "Random", "StaticArrays"]
git-tree-sha1 = "62e51b39331de8911e4a7ff6f5aaf38a5f4cc0ae"
uuid = "ec485272-7323-5ecc-a04f-4719b315124d"
version = "0.2.0"

[[ArrayInterface]]
deps = ["Compat", "IfElse", "LinearAlgebra", "Requires", "SparseArrays", "Static"]
git-tree-sha1 = "265b06e2b1f6a216e0e8f183d28e4d354eab3220"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "3.2.1"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[AxisAlgorithms]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "WoodburyMatrices"]
git-tree-sha1 = "66771c8d21c8ff5e3a93379480a2307ac36863f7"
uuid = "13072b0f-2c55-5437-9ae7-d433b7a33950"
version = "1.0.1"

[[AxisArrays]]
deps = ["Dates", "IntervalSets", "IterTools", "RangeArrays"]
git-tree-sha1 = "d127d5e4d86c7680b20c35d40b503c74b9a39b5e"
uuid = "39de3d68-74b9-583c-8d2d-e117c070f3a9"
version = "0.4.4"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[CEnum]]
git-tree-sha1 = "215a9aa4a1f23fbd05b92769fdd62559488d70e9"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.1"

[[Calculus]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f641eb0a4f00c343bbc32346e1217b86f3ce9dad"
uuid = "49dc2e85-a5d0-5ad3-a950-438e2897f1b9"
version = "0.5.1"

[[CatIndices]]
deps = ["CustomUnitRanges", "OffsetArrays"]
git-tree-sha1 = "a0f80a09780eed9b1d106a1bf62041c2efc995bc"
uuid = "aafaddc9-749c-510e-ac4f-586e18779b91"
version = "0.2.2"

[[ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "4c26b4e9e91ca528ea212927326ece5918a04b47"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.11.2"

[[ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "bf98fa45a0a4cee295de98d4c1462be26345b9a1"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.2"

[[Clustering]]
deps = ["Distances", "LinearAlgebra", "NearestNeighbors", "Printf", "SparseArrays", "Statistics", "StatsBase"]
git-tree-sha1 = "75479b7df4167267d75294d14b58244695beb2ac"
uuid = "aaaa29a8-35af-508c-8bc3-b662a17a0fe5"
version = "0.14.2"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "3f1f500312161f1ae067abe07d13b40f78f32e07"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.8"

[[Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "44c37b4636bc54afac5c574d2d02b625349d6582"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.41.0"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[ComputationalResources]]
git-tree-sha1 = "52cb3ec90e8a8bea0e62e275ba577ad0f74821f7"
uuid = "ed09eef8-17a6-5b46-8889-db040fac31e3"
version = "0.3.2"

[[CoordinateTransformations]]
deps = ["LinearAlgebra", "StaticArrays"]
git-tree-sha1 = "681ea870b918e7cff7111da58791d7f718067a19"
uuid = "150eb455-5306-5404-9cee-2592286d6298"
version = "0.6.2"

[[CustomUnitRanges]]
git-tree-sha1 = "1a3f97f907e6dd8983b744d2642651bb162a3f7a"
uuid = "dc8bdbbb-1ca9-579f-8c36-e416f6a65cce"
version = "1.0.2"

[[DataAPI]]
git-tree-sha1 = "cc70b17275652eb47bc9e5f81635981f13cea5c8"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.9.0"

[[DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3daef5523dd2e769dad2365274f760ff5f282c7d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.11"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[Distances]]
deps = ["LinearAlgebra", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "3258d0659f812acde79e8a74b11f17ac06d0ca04"
uuid = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
version = "0.10.7"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "b19534d1895d702889b219c382a6e18010797f0b"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.6"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[DualNumbers]]
deps = ["Calculus", "NaNMath", "SpecialFunctions"]
git-tree-sha1 = "84f04fe68a3176a583b864e492578b9466d87f1e"
uuid = "fa6b7ba4-c1ee-5f82-b5fc-ecf0adba8f74"
version = "0.6.6"

[[EllipsisNotation]]
deps = ["ArrayInterface"]
git-tree-sha1 = "3fe985505b4b667e1ae303c9ca64d181f09d5c05"
uuid = "da5c29d0-fa7d-589e-88eb-ea29b0a81949"
version = "1.1.3"

[[FFTViews]]
deps = ["CustomUnitRanges", "FFTW"]
git-tree-sha1 = "cbdf14d1e8c7c8aacbe8b19862e0179fd08321c2"
uuid = "4f61f5a4-77b1-5117-aa51-3ab5ef4ef0cd"
version = "0.3.2"

[[FFTW]]
deps = ["AbstractFFTs", "FFTW_jll", "LinearAlgebra", "MKL_jll", "Preferences", "Reexport"]
git-tree-sha1 = "463cb335fa22c4ebacfd1faba5fde14edb80d96c"
uuid = "7a1cc6ca-52ef-59f5-83cd-3a7055c09341"
version = "1.4.5"

[[FFTW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c6033cc3892d0ef5bb9cd29b7f2f0331ea5184ea"
uuid = "f5851436-0d7a-5f13-b9de-f02708fd171a"
version = "3.3.10+0"

[[FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "2db648b6712831ecb333eae76dbfd1c156ca13bb"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.11.2"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[Graphics]]
deps = ["Colors", "LinearAlgebra", "NaNMath"]
git-tree-sha1 = "1c5a84319923bea76fa145d49e93aa4394c73fc2"
uuid = "a2bd30eb-e257-5431-a919-1863eab51364"
version = "1.1.1"

[[Graphs]]
deps = ["ArnoldiMethod", "DataStructures", "Distributed", "Inflate", "LinearAlgebra", "Random", "SharedArrays", "SimpleTraits", "SparseArrays", "Statistics"]
git-tree-sha1 = "92243c07e786ea3458532e199eb3feee0e7e08eb"
uuid = "86223c79-3864-5bf0-83f7-82e725a168b6"
version = "1.4.1"

[[Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"

[[IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[IfElse]]
git-tree-sha1 = "debdd00ffef04665ccbb3e150747a77560e8fad1"
uuid = "615f187c-cbe4-4ef1-ba3b-2fcf58d6d173"
version = "0.1.1"

[[ImageAxes]]
deps = ["AxisArrays", "ImageBase", "ImageCore", "Reexport", "SimpleTraits"]
git-tree-sha1 = "c54b581a83008dc7f292e205f4c409ab5caa0f04"
uuid = "2803e5a7-5153-5ecf-9a86-9b4c37f5f5ac"
version = "0.6.10"

[[ImageBase]]
deps = ["ImageCore", "Reexport"]
git-tree-sha1 = "b51bb8cae22c66d0f6357e3bcb6363145ef20835"
uuid = "c817782e-172a-44cc-b673-b171935fbb9e"
version = "0.1.5"

[[ImageContrastAdjustment]]
deps = ["ImageCore", "ImageTransformations", "Parameters"]
git-tree-sha1 = "0d75cafa80cf22026cea21a8e6cf965295003edc"
uuid = "f332f351-ec65-5f6a-b3d1-319c6670881a"
version = "0.3.10"

[[ImageCore]]
deps = ["AbstractFFTs", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Graphics", "MappedArrays", "MosaicViews", "OffsetArrays", "PaddedViews", "Reexport"]
git-tree-sha1 = "9a5c62f231e5bba35695a20988fc7cd6de7eeb5a"
uuid = "a09fc81d-aa75-5fe9-8630-4744c3626534"
version = "0.9.3"

[[ImageDistances]]
deps = ["Distances", "ImageCore", "ImageMorphology", "LinearAlgebra", "Statistics"]
git-tree-sha1 = "7a20463713d239a19cbad3f6991e404aca876bda"
uuid = "51556ac3-7006-55f5-8cb3-34580c88182d"
version = "0.2.15"

[[ImageFiltering]]
deps = ["CatIndices", "ComputationalResources", "DataStructures", "FFTViews", "FFTW", "ImageBase", "ImageCore", "LinearAlgebra", "OffsetArrays", "Reexport", "SparseArrays", "StaticArrays", "Statistics", "TiledIteration"]
git-tree-sha1 = "15bd05c1c0d5dbb32a9a3d7e0ad2d50dd6167189"
uuid = "6a3955dd-da59-5b1f-98d4-e7296123deb5"
version = "0.7.1"

[[ImageIO]]
deps = ["FileIO", "Netpbm", "OpenEXR", "PNGFiles", "TiffImages", "UUIDs"]
git-tree-sha1 = "a2951c93684551467265e0e32b577914f69532be"
uuid = "82e4d734-157c-48bb-816b-45c225c6df19"
version = "0.5.9"

[[ImageMagick]]
deps = ["FileIO", "ImageCore", "ImageMagick_jll", "InteractiveUtils", "Libdl", "Pkg", "Random"]
git-tree-sha1 = "5bc1cb62e0c5f1005868358db0692c994c3a13c6"
uuid = "6218d12a-5da1-5696-b52f-db25d2ecc6d1"
version = "1.2.1"

[[ImageMagick_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pkg", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "ea2b6fd947cdfc43c6b8c15cff982533ec1f72cd"
uuid = "c73af94c-d91f-53ed-93a7-00f77d67a9d7"
version = "6.9.12+0"

[[ImageMetadata]]
deps = ["AxisArrays", "ImageAxes", "ImageBase", "ImageCore"]
git-tree-sha1 = "36cbaebed194b292590cba2593da27b34763804a"
uuid = "bc367c6b-8a6b-528e-b4bd-a4b897500b49"
version = "0.9.8"

[[ImageMorphology]]
deps = ["ImageCore", "LinearAlgebra", "Requires", "TiledIteration"]
git-tree-sha1 = "5581e18a74a5838bd919294a7138c2663d065238"
uuid = "787d08f9-d448-5407-9aad-5290dd7ab264"
version = "0.3.0"

[[ImageQualityIndexes]]
deps = ["ImageContrastAdjustment", "ImageCore", "ImageDistances", "ImageFiltering", "OffsetArrays", "Statistics"]
git-tree-sha1 = "1d2d73b14198d10f7f12bf7f8481fd4b3ff5cd61"
uuid = "2996bd0c-7a13-11e9-2da2-2f5ce47296a9"
version = "0.3.0"

[[ImageSegmentation]]
deps = ["Clustering", "DataStructures", "Distances", "Graphs", "ImageCore", "ImageFiltering", "ImageMorphology", "LinearAlgebra", "MetaGraphs", "RegionTrees", "SimpleWeightedGraphs", "StaticArrays", "Statistics"]
git-tree-sha1 = "36832067ea220818d105d718527d6ed02385bf22"
uuid = "80713f31-8817-5129-9cf8-209ff8fb23e1"
version = "1.7.0"

[[ImageShow]]
deps = ["Base64", "FileIO", "ImageBase", "ImageCore", "OffsetArrays", "StackViews"]
git-tree-sha1 = "d0ac64c9bee0aed6fdbb2bc0e5dfa9a3a78e3acc"
uuid = "4e3cecfd-b093-5904-9786-8bbb286a6a31"
version = "0.3.3"

[[ImageTransformations]]
deps = ["AxisAlgorithms", "ColorVectorSpace", "CoordinateTransformations", "ImageBase", "ImageCore", "Interpolations", "OffsetArrays", "Rotations", "StaticArrays"]
git-tree-sha1 = "b4b161abc8252d68b13c5cc4a5f2ba711b61fec5"
uuid = "02fcd773-0e25-5acc-982a-7f6622650795"
version = "0.9.3"

[[Images]]
deps = ["Base64", "FileIO", "Graphics", "ImageAxes", "ImageBase", "ImageContrastAdjustment", "ImageCore", "ImageDistances", "ImageFiltering", "ImageIO", "ImageMagick", "ImageMetadata", "ImageMorphology", "ImageQualityIndexes", "ImageSegmentation", "ImageShow", "ImageTransformations", "IndirectArrays", "IntegralArrays", "Random", "Reexport", "SparseArrays", "StaticArrays", "Statistics", "StatsBase", "TiledIteration"]
git-tree-sha1 = "35dc1cd115c57ad705c7db9f6ef5cc14412e8f00"
uuid = "916415d5-f1e6-5110-898d-aaa5f9f070e0"
version = "0.25.0"

[[Imath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "87f7662e03a649cffa2e05bf19c303e168732d3e"
uuid = "905a6f67-0a94-5f89-b386-d35d92009cd1"
version = "3.1.2+0"

[[IndirectArrays]]
git-tree-sha1 = "012e604e1c7458645cb8b436f8fba789a51b257f"
uuid = "9b13fd28-a010-5f03-acff-a1bbcff69959"
version = "1.0.0"

[[Inflate]]
git-tree-sha1 = "f5fc07d4e706b84f72d54eedcc1c13d92fb0871c"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.2"

[[IntegralArrays]]
deps = ["ColorTypes", "FixedPointNumbers", "IntervalSets"]
git-tree-sha1 = "00019244715621f473d399e4e1842e479a69a42e"
uuid = "1d092043-8f09-5a30-832f-7509e371ab51"
version = "0.1.2"

[[IntelOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d979e54b71da82f3a65b62553da4fc3d18c9004c"
uuid = "1d5cc7b8-4909-519e-a0f8-d0f5ad9712d0"
version = "2018.0.3+2"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[Interpolations]]
deps = ["AxisAlgorithms", "ChainRulesCore", "LinearAlgebra", "OffsetArrays", "Random", "Ratios", "Requires", "SharedArrays", "SparseArrays", "StaticArrays", "WoodburyMatrices"]
git-tree-sha1 = "b15fc0a95c564ca2e0a7ae12c1f095ca848ceb31"
uuid = "a98d9a8b-a2ab-59e6-89dd-64a1c18fca59"
version = "0.13.5"

[[IntervalSets]]
deps = ["Dates", "EllipsisNotation", "Statistics"]
git-tree-sha1 = "3cc368af3f110a767ac786560045dceddfc16758"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.5.3"

[[InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "a7254c0acd8e62f1ac75ad24d5db43f5f19f3c65"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.2"

[[IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[IterTools]]
git-tree-sha1 = "fa6287a4469f5e048d763df38279ee729fbd44e5"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.4.0"

[[JLD2]]
deps = ["DataStructures", "FileIO", "MacroTools", "Mmap", "Pkg", "Printf", "Reexport", "TranscodingStreams", "UUIDs"]
git-tree-sha1 = "5335c4c9a30b4b823d1776d2db09882cbfac9f1e"
uuid = "033835bb-8acc-5ee8-8aae-3f567f8a3819"
version = "0.4.16"

[[JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "642a199af8b68253517b80bd3bfd17eb4e84df6e"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.3.0"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d735490ac75c5cb9f1b00d8b5509c11984dc6943"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.0+0"

[[LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "340e257aada13f95f98ee352d316c3bed37c8ab9"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.3.0+0"

[[LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "e5718a00af0ab9756305a0392832c8952c7426c1"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.6"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[MKL_jll]]
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "Pkg"]
git-tree-sha1 = "5455aef09b40e5020e1520f551fa3135040d4ed0"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2021.1.1+2"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[MappedArrays]]
git-tree-sha1 = "e8b359ef06ec72e8c030463fe02efe5527ee5142"
uuid = "dbb5928d-eab1-5f90-85c2-b9b0edb7c900"
version = "0.4.1"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[MetaGraphs]]
deps = ["Graphs", "JLD2", "Random"]
git-tree-sha1 = "2af69ff3c024d13bde52b34a2a7d6887d4e7b438"
uuid = "626554b9-1ddb-594c-aa3c-2596fe9399a5"
version = "0.7.1"

[[Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MosaicViews]]
deps = ["MappedArrays", "OffsetArrays", "PaddedViews", "StackViews"]
git-tree-sha1 = "b34e3bc3ca7c94914418637cb10cc4d1d80d877d"
uuid = "e94cdb99-869f-56ef-bcf0-1ae2bcbe0389"
version = "0.3.3"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[NaNMath]]
git-tree-sha1 = "f755f36b19a5116bb580de457cda0c140153f283"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.6"

[[NearestNeighbors]]
deps = ["Distances", "StaticArrays"]
git-tree-sha1 = "16baacfdc8758bc374882566c9187e785e85c2f0"
uuid = "b8a86587-4115-5ab1-83bc-aa920d37bbce"
version = "0.4.9"

[[Netpbm]]
deps = ["FileIO", "ImageCore"]
git-tree-sha1 = "18efc06f6ec36a8b801b23f076e3c6ac7c3bf153"
uuid = "f09324ee-3d7c-5217-9330-fc30815ba969"
version = "1.0.2"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[OffsetArrays]]
deps = ["Adapt"]
git-tree-sha1 = "043017e0bdeff61cfbb7afeb558ab29536bbb5ed"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.10.8"

[[OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[OpenEXR]]
deps = ["Colors", "FileIO", "OpenEXR_jll"]
git-tree-sha1 = "327f53360fdb54df7ecd01e96ef1983536d1e633"
uuid = "52e1d378-f018-4a11-a4be-720524705ac7"
version = "0.3.2"

[[OpenEXR_jll]]
deps = ["Artifacts", "Imath_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "923319661e9a22712f24596ce81c54fc0366f304"
uuid = "18a262bb-aa17-5467-a713-aee519bc75cb"
version = "3.1.1+0"

[[OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"

[[OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[PNGFiles]]
deps = ["Base64", "CEnum", "ImageCore", "IndirectArrays", "OffsetArrays", "libpng_jll"]
git-tree-sha1 = "6d105d40e30b635cfed9d52ec29cf456e27d38f8"
uuid = "f57f5aa1-a3ce-4bc8-8ab9-96f992907883"
version = "0.3.12"

[[PaddedViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "646eed6f6a5d8df6708f15ea7e02a7a2c4fe4800"
uuid = "5432bcbf-9aad-5242-b902-cca2824c8663"
version = "0.5.10"

[[Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "d7fa6237da8004be601e19bd6666083056649918"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.1.3"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PkgVersion]]
deps = ["Pkg"]
git-tree-sha1 = "a7a7e1a88853564e551e4eba8650f8c38df79b37"
uuid = "eebad327-c553-4316-9ea0-9fa01ccd7688"
version = "0.1.1"

[[PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "93cf0910f09a9607add290a3a2585aa376b4feb6"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.25"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00cfd92944ca9c760982747e9a1d0d5d86ab1e5a"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.2"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "afadeba63d90ff223a6a48d2009434ecee2ec9e8"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.7.1"

[[Quaternions]]
deps = ["DualNumbers", "LinearAlgebra"]
git-tree-sha1 = "adf644ef95a5e26c8774890a509a55b7791a139f"
uuid = "94ee1d12-ae83-5a48-8b1c-48b8ff168ae0"
version = "0.4.2"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[RangeArrays]]
git-tree-sha1 = "b9039e93773ddcfc828f12aadf7115b4b4d225f5"
uuid = "b3c3ace0-ae52-54e7-9d0b-2c1406fd6b9d"
version = "0.3.2"

[[Ratios]]
deps = ["Requires"]
git-tree-sha1 = "01d341f502250e81f6fec0afe662aa861392a3aa"
uuid = "c84ed2f1-dad5-54f0-aa8e-dbefe2724439"
version = "0.4.2"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[RegionTrees]]
deps = ["IterTools", "LinearAlgebra", "StaticArrays"]
git-tree-sha1 = "4618ed0da7a251c7f92e869ae1a19c74a7d2a7f9"
uuid = "dee08c22-ab7f-5625-9660-a9af2021b33f"
version = "0.3.2"

[[Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "8f82019e525f4d5c669692772a6f4b0a58b06a6a"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.2.0"

[[Rotations]]
deps = ["LinearAlgebra", "Quaternions", "Random", "StaticArrays", "Statistics"]
git-tree-sha1 = "dbf5f991130238f10abbf4f2d255fb2837943c43"
uuid = "6038ab10-8711-5258-84ad-4b1120ba62dc"
version = "1.1.0"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

[[SimpleWeightedGraphs]]
deps = ["Graphs", "LinearAlgebra", "Markdown", "SparseArrays", "Test"]
git-tree-sha1 = "a6f404cc44d3d3b28c793ec0eb59af709d827e4e"
uuid = "47aef6b3-ad0c-573a-a1e2-d07658019622"
version = "1.2.1"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "e08890d19787ec25029113e88c34ec20cac1c91e"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.0.0"

[[StackViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "46e589465204cd0c08b4bd97385e4fa79a0c770c"
uuid = "cae243ae-269e-4f55-b966-ac2d0dc13c15"
version = "0.1.1"

[[Static]]
deps = ["IfElse"]
git-tree-sha1 = "7f5a513baec6f122401abfc8e9c074fdac54f6c1"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "0.4.1"

[[StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "3c76dde64d03699e074ac02eb2e8ba8254d428da"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.2.13"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[StatsAPI]]
git-tree-sha1 = "0f2aa8e32d511f758a2ce49208181f7733a0936a"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.1.0"

[[StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "2bb0cb32026a66037360606510fca5984ccc6b75"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.13"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[TiffImages]]
deps = ["ColorTypes", "DataStructures", "DocStringExtensions", "FileIO", "FixedPointNumbers", "IndirectArrays", "Inflate", "OffsetArrays", "PkgVersion", "ProgressMeter", "UUIDs"]
git-tree-sha1 = "c342ae2abf4902d65a0b0bf59b28506a6e17078a"
uuid = "731e570b-9d59-4bfa-96dc-6df516fadf69"
version = "0.5.2"

[[TiledIteration]]
deps = ["OffsetArrays"]
git-tree-sha1 = "5683455224ba92ef59db72d10690690f4a8dc297"
uuid = "06e1c1a7-607b-532d-9fad-de7d9aa2abac"
version = "0.3.1"

[[TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "216b95ea110b5972db65aa90f88d8d89dcb8851c"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.6"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[WoodburyMatrices]]
deps = ["LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "de67fa59e33ad156a590055375a30b23c40299d3"
uuid = "efce3f68-66dc-5838-9240-27a6d6f5f9b6"
version = "0.5.5"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "cc4bf3fdde8b7e3e9fa0351bdeedba1cf3b7f6e6"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.0+0"

[[libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╠═93b9d789-1e17-48ee-bcf3-43f1a35e572d
# ╟─51a7ca06-5723-4c2b-8aba-bcdce5d33432
# ╠═f80662e7-e437-4871-b084-28eb6903ba94
# ╠═e57c8302-4238-46a6-83ac-588609a42924
# ╟─969e2478-9785-487f-90e2-fdea675a9b0d
# ╠═969b76be-ed55-4a5a-96ed-a5a90941e56d
# ╠═d2aaaf27-bef4-4578-9560-38f41abfd685
# ╟─7cf98200-208f-4e98-92e2-eb82765f3023
# ╠═0a386c73-5996-49f8-ba6a-257d0c360df7
# ╟─c1adf009-7b78-4279-9c3a-bfe05a75e8bf
# ╟─2ed15919-cdf6-4de6-b3d8-af5a8a3aafcf
# ╟─9cf18586-7ed6-4624-945b-f8a69a27a507
# ╠═c121b4f7-a113-4bf7-90b4-c1e4775bc956
# ╟─0b8bbf9e-9400-4aad-9804-3c703f10c913
# ╠═fcc00027-618a-44aa-be77-e137d1518ac1
# ╠═9699d51e-22ad-4138-b91b-88a3e730dd3c
# ╟─b34a075f-d16d-4d00-9b7e-63cea1132a2c
# ╟─edc49720-f844-44f3-8db3-3e76fc5c263f
# ╠═b905dbca-76de-4e99-81da-73da2b01dc71
# ╠═cab92b50-e47e-4d26-9922-01951339ec5f
# ╟─2667aa28-4c2f-4bc6-a27a-8c37c6685095
# ╟─c9896dfa-1fbe-11ec-0ba6-39909fd14292
# ╟─d8b7ef38-7b3b-492b-a08a-d6024af11afc
# ╠═626cffd7-2816-4ccc-b805-4c51b1a20943
# ╠═1ee82745-8079-4339-b3fa-b0496867fe8c
# ╟─f10ce95e-5d67-4d8d-bbe6-383aee285c67
# ╟─ec94d94e-4de0-4477-b2cb-a6ff9d5758a1
# ╟─0199403e-6cc2-4bd6-8bbb-c5e94d215ddf
# ╠═8dee5146-f62c-46cd-8681-40efa878c1fc
# ╟─14a8b29e-c455-4a1b-90c0-9ee3e14c7558
# ╟─62560766-f6bd-4909-8080-a0e5dad9fb68
# ╟─7d054ee9-e6bc-4b20-b893-319e087fc6cc
# ╟─29eca628-1603-4ce2-9952-ac6d35c8dd87
# ╟─d546d6b8-c49b-43f5-b516-1a693bbb979a
# ╟─4269201c-e46d-48f2-bc69-982eaa130f5c
# ╟─a80d92ad-e6c0-497c-ac0d-79e865a74dc7
# ╟─7f139b38-424f-49f1-b7b6-3b6be6f223c6
# ╟─105ab6a9-8cfe-42e2-8d68-a7904a69bb4d
# ╠═217e9838-2136-428d-9c2e-651203788c62
# ╠═6864add2-6736-4ba6-a513-904ded50b996
# ╠═a1727fe8-dd68-43ec-8c23-04728884d998
# ╠═bbdfad49-8afb-4f66-b2ab-16227e1ecec9
# ╟─cc6bd3ab-f9e8-4944-acbf-7fce387e3102
# ╠═f325066b-0e80-4892-a574-bb57a9864e67
# ╟─df429145-a9f6-4838-861f-740cdec479e3
# ╟─febcb6de-3357-42f0-b474-c66c065ffdeb
# ╟─62c9de22-b4f8-4aec-b0a9-9ce6f820bbc6
# ╟─c15a7c26-6794-42c5-a048-baae3b08d205
# ╠═dd4ea914-8343-4f93-af7e-22caaa286b3e
# ╠═58643c65-819d-421b-b7f4-b26d4d5b85d9
# ╟─d4c9ad06-c0ab-4ab0-a445-a77d2c854a75
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
