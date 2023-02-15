### A Pluto.jl notebook ###
# v0.19.22

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

# ╔═╡ d2a0d728-ad39-11ed-2044-9b9c76d42a52
using CellularAutomata

# ╔═╡ 88383d4a-3c69-4fef-921b-eafec1e57c55
using PlutoUI

# ╔═╡ ce3758f6-3f32-45f5-bb04-537d1ee79307
using HypertextLiteral

# ╔═╡ 5a96cf06-efcf-4c58-9846-1ee058a7f1ef
const Layout = PlutoUI.ExperimentalLayout

# ╔═╡ 74f4d366-29ec-4148-adb2-453dd2b21812
md"""
# Demo
"""

# ╔═╡ d1800cb9-38fe-410b-9238-c02c7a8e6df0


# ╔═╡ 1cb7d561-6e23-4a4f-bddf-2e76366463d3


# ╔═╡ 79505117-e17d-499a-9192-2b81a2ce6c5c
md"""
# Utility functions
"""

# ╔═╡ b7f80a8c-32ab-4012-a77d-138840235634
function generate_starting_val(T, ncells::Integer)
	x = zeros(T, ncells)
	x[Int(floor(ncells/2)+1)] = one(T)
	x
end

# ╔═╡ e7398a95-88d3-4901-9843-90a7f5bdff30
function demo_ca(gen_fun, ncells::Integer=111, generations::Integer=30)
	CellularAutomaton(
		gen_fun, 
		generate_starting_val(gen_fun isa CCA ? Float64 : Int64, ncells), 
		generations
	)
end

# ╔═╡ 9ac8e493-ea5a-4d0d-85b3-fcd4820a45ba


# ╔═╡ c490f1b7-43dd-4f06-8ffd-61096a502203
md"""
# Display automata sequence
"""

# ╔═╡ 0ddf0699-8354-4fa9-b14c-660fa2e8e6de
background(ca::CellularAutomaton{<:CCA}, x::Float64) = "hsl(0deg,0%,$(x*100)%)"

# ╔═╡ 066735e3-de65-4b75-9e51-52f0510c0c70
background(ca::CellularAutomaton{<:DCA}, x::Integer) = 
	"hsl(0deg,0%,$(100.0 * (1.0 - Float64(x) / (ca.generation_fun.states - 1)))%)"

# ╔═╡ 21b5a20d-b03d-45b8-b937-c6ed787bced9
background(ca::CellularAutomaton{<:DCA}, x::Bool) = x ? "black" : "white"

# ╔═╡ 1e25a85f-1015-4f58-bd39-11e3bedff9f6
show_sequence(ca; border::Bool=false) = @htl """
	<div 
		class="plui-cell-automata $(border ? "border" : "")"
		style=$(Dict(
		:display => "grid",
		:grid_template_columns => "repeat($(size(ca.evolution, 2)), auto)",
		:contain => "layout paint",
		
	))>$(
		Iterators.map(PermutedDimsArray(ca.evolution, (2,1))) do x
			@htl "<div style=$(Dict(
				:background => background(ca, x), 
			))></div>"
		end
	)</div>
	<style>
		.plui-cell-automata > div {
			aspect-ratio: 1;
		}
		.plui-cell-automata.border > div {
			
			border: .2px solid #888;
		}
	</style>
"""

# ╔═╡ bb419107-a56b-4ddf-9c20-adaccac2e7bf
demo_ca(DCA(30)) |> show_sequence

# ╔═╡ 035dbf23-cd64-4047-b2eb-5338c689bd8a
demo_ca(DCA(7110222193934; states=3, radius=1), 121, 50) |> show_sequence

# ╔═╡ 0a3a5a80-b802-4006-bf74-652f7871a421
# ╠═╡ disabled = true
#=╠═╡
show_sequence_old(ca ) = Layout.grid(
	map(ca.evolution) do x
		@htl "<div style=$(Dict(
			"background" => x ? "black" : "white", 
			"border" => ".2px solid #888", 
			# "width" => "1em", 
			# "height" => "1em",
			"aspect-ratio" => "1",
		))></div>"
	end;
	column_gap="0",
	style=Dict("background" => "white", "contain" => "layout paint")
)
  ╠═╡ =#

# ╔═╡ 678f52e4-e2d6-4f6c-96b3-ce5da764ba21


# ╔═╡ ece247a6-e674-425c-9012-3d34c8523f7d
md"""
# Interactive rule input
"""

# ╔═╡ 4b6191bb-782b-49fc-89f1-93ad9ab78455
md"""
## Single T input

Simple idea: the interactive bottom bit is a `PlutoUI.CheckBox`. We can use `PlutoUI.Experimental.wrapped` to display a the checkbox with other elements around it. 
"""

# ╔═╡ 7afe1db9-a215-4b6e-b5cd-437ccc2c059f


# ╔═╡ 8af400cd-4c20-4ddb-b8f0-7b296018c4b4
disabled_checkbox(x::Bool) = @htl("<input type=checkbox checked=$(x) disabled>")

# ╔═╡ 46931772-c509-4677-b0ee-ec8d113a5370
T_input(a, b, c, default=false) = PlutoUI.Experimental.wrapped() do Child
	Layout.grid([
		disabled_checkbox(a) disabled_checkbox(b) disabled_checkbox(c)
		Text("") Child(CheckBox(default)) Text("")
	]; fill_width=false, column_gap="0")
end

# ╔═╡ df22b1e7-80f6-4174-bd63-e93ea6487962
@bind z T_input(true, false, true)

# ╔═╡ aefa2b10-1c4d-4db0-9593-8c94bc156735
z

# ╔═╡ 0f83892a-ba2a-4e97-abd7-661feed637ab


# ╔═╡ 17e33fbb-45f7-47f1-947d-3cdfd73db053
md"""
## Combining 8 T inputs

`PlutoUI.combine` lets us combine multiple inputs into one that you can bind to.
"""

# ╔═╡ 083d609c-dfa4-4ea6-aa91-a6f6fd14a790
@bind zzz PlutoUI.combine() do Child
	Ts = Iterators.map(1:8) do i
		# a,b,c are the top 3 values of the T
		# These are the binary representations of the numbers [0, ..., 7]
		abc = (c == '1' for c in bitstring(8-i)[end-2:end])

		Child(T_input(abc...))
	end

	# display the Ts horizontally
	Layout.hbox(Ts; style=Dict(:gap => "1em"))
end

# ╔═╡ f9fa112c-92ae-4a17-a6bf-3d839e843edf
zzz

# ╔═╡ f5001742-fa74-4666-ab54-a26701074071


# ╔═╡ dde39bbc-0007-49e6-9ddd-2d2f10fbee9f
md"""
## Converting between bits and the rule number
"""

# ╔═╡ f7e4008e-fe4a-4a3a-95af-ef7ecd186ba1
ruletobits(x::Integer) = (c == '1' for c in bitstring(x)[end-7:end])

# ╔═╡ 724d22be-f133-4551-b664-bdfc28a4508b
collect(ruletobits(30))

# ╔═╡ 4aebf26f-5a1b-4bc8-8f83-2b51fe52369d


# ╔═╡ ccc06faa-8410-4735-89a2-9ce922ad4ab5
bitstorule(bits) = sum(val ? 1 << (8-i) : 0 for (i, val) in enumerate(bits))

# ╔═╡ 49f43442-e55c-4a06-a9b3-e8d15d79f541
bitstorule(ruletobits(30))

# ╔═╡ 029f2ffb-1933-4d0e-9dfb-46b0cb26d310


# ╔═╡ 1f44255a-5d8d-42f1-9d3d-41341c4ffd98
md"""
## Putting it all together

We add the two transformations:
1. For the initial value: rule number to bits. These bits are the initial values of the checkboxes
2. For the `@bind` value: bits to rule number. We use `PlutoUI.Experimental.transformed_value` to apply a transformation function to the value returned via `@bind`. 
"""

# ╔═╡ a13ac17a-870c-4e16-8443-7341493452fd
function rule_input(; default::Integer)

	# default values of the interactive checkboxes, i.e. the bottoms of the Ts
	default_checked = ruletobits(default)

	# the 8 interactive Ts are combined into a single bindable element
	combined = PlutoUI.combine() do Child
		Ts = Iterators.map(enumerate(default_checked)) do (i, default)
			# a,b,c are the top 3 values of the T
			# These are the binary representations of the numbers [0, ..., 7]
			abc = (c == '1' for c in bitstring(8-i)[end-2:end])

			Child(T_input(abc..., default))
		end

		# display the Ts horizontally
		Layout.hbox(Ts; style=Dict(:gap => "1em"))
	end

	# convert the selected bits into the rule number:
	PlutoUI.Experimental.transformed_value(bitstorule, combined)
end

# ╔═╡ 0e4140b0-65db-4961-8846-8b2892440399
@bind myrule rule_input(default=30)

# ╔═╡ baa264f9-7cd8-4423-b05c-02503a26b9fc
myrule

# ╔═╡ df877062-af6c-47f1-bd43-189142ba9c02


# ╔═╡ 5bcc2744-82aa-4c71-8bd3-8065050400f6


# ╔═╡ 3fefc103-0d38-4d41-872f-9cf7919566f2
md"""
# Macro `@bindname`
"""

# ╔═╡ 01297e73-3ba3-4f83-85fc-c62178e59323
"""
Like `@bind` in Pluto, but it also displays the name of the variable.
"""
macro bindname(name::Symbol, ex::Expr)
    quote
        HypertextLiteral.@htl("""
		<div style='display: flex; flex-wrap: wrap; align-items: baseline;'>
        <code style='font-weight: bold'>$($(String(name))):</code>&nbsp$(@bind $(name) $(esc(ex)))
		</div>
        """)
    end
end

# ╔═╡ f197d995-6042-457e-9d53-24b46608456c
@bindname ncells Scrubbable(111)

# ╔═╡ f63d69e7-8d78-42af-967b-2e7096a163c0
starting_val = generate_starting_val(Bool, ncells)

# ╔═╡ 499b54be-39fb-40c6-8efa-e22cca88a4d8
@bindname generations Scrubbable(30)

# ╔═╡ 38eb9647-3807-41ed-b3e7-0838e7d546b5
@bindname rule rule_input(default=30)

# ╔═╡ 076dd310-fcb7-42b7-83b7-748a76a7009c
rule

# ╔═╡ 4fa58172-2fb2-4a61-8568-8ca6a5b669e3
ca = CellularAutomaton(DCA(rule), starting_val, generations)

# ╔═╡ eb129607-176a-4dee-80e9-c7eefb637d94
@bindname show_border CheckBox(false)

# ╔═╡ c2be663b-4b1f-435b-94c4-7a262aba55ee
show_sequence(ca; border=show_border)

# ╔═╡ 3858727e-92df-4098-8713-4ea22624d232
@bindname zzze Slider(1:100)

# ╔═╡ 7b642ecf-7cea-458b-8c93-dbbb226ddbba
zzze

# ╔═╡ 47c2f19d-cd93-4bbb-b1bf-f223e329cecc
@bindname rulasdflkjasdlkfjasldkjfklajsdflkjasdfeee rule_input(default=30)

# ╔═╡ 901c8a15-49f4-478d-84e3-b46d3d19aa10
@bindname kjdfjkh rule_input(default=30)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CellularAutomata = "878138dc-5b27-11ea-1a71-cb95d38d6b29"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
CellularAutomata = "~0.0.2"
HypertextLiteral = "~0.9.4"
PlutoUI = "~0.7.50"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.3"
manifest_format = "2.0"
project_hash = "085bcd359d8de4425a64fc3ae82847c21daf8439"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.CellularAutomata]]
git-tree-sha1 = "247376cf88d4e1509e77d737d744f7f8f93bfb50"
uuid = "878138dc-5b27-11ea-1a71-cb95d38d6b29"
version = "0.0.2"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "0.5.2+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.0+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.2.1"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[deps.Parsers]]
deps = ["Dates", "SnoopPrecompile"]
git-tree-sha1 = "6f4fbcd1ad45905a5dee3f4256fabb49aa2110c6"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.7"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "5bb5129fdd62a2bbbe17c2756932259acf467386"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.50"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SnoopPrecompile]]
deps = ["Preferences"]
git-tree-sha1 = "e760a70afdcd461cf01a575947738d359234665c"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.3"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[deps.URIs]]
git-tree-sha1 = "074f993b0ca030848b897beff716d93aca60f06a"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.2"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.12+3"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.1+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
"""

# ╔═╡ Cell order:
# ╠═d2a0d728-ad39-11ed-2044-9b9c76d42a52
# ╠═88383d4a-3c69-4fef-921b-eafec1e57c55
# ╠═5a96cf06-efcf-4c58-9846-1ee058a7f1ef
# ╠═ce3758f6-3f32-45f5-bb04-537d1ee79307
# ╟─74f4d366-29ec-4148-adb2-453dd2b21812
# ╟─f197d995-6042-457e-9d53-24b46608456c
# ╟─499b54be-39fb-40c6-8efa-e22cca88a4d8
# ╟─38eb9647-3807-41ed-b3e7-0838e7d546b5
# ╠═076dd310-fcb7-42b7-83b7-748a76a7009c
# ╟─c2be663b-4b1f-435b-94c4-7a262aba55ee
# ╟─eb129607-176a-4dee-80e9-c7eefb637d94
# ╟─d1800cb9-38fe-410b-9238-c02c7a8e6df0
# ╠═f63d69e7-8d78-42af-967b-2e7096a163c0
# ╠═4fa58172-2fb2-4a61-8568-8ca6a5b669e3
# ╟─1cb7d561-6e23-4a4f-bddf-2e76366463d3
# ╟─79505117-e17d-499a-9192-2b81a2ce6c5c
# ╟─b7f80a8c-32ab-4012-a77d-138840235634
# ╟─e7398a95-88d3-4901-9843-90a7f5bdff30
# ╟─9ac8e493-ea5a-4d0d-85b3-fcd4820a45ba
# ╟─c490f1b7-43dd-4f06-8ffd-61096a502203
# ╠═bb419107-a56b-4ddf-9c20-adaccac2e7bf
# ╠═035dbf23-cd64-4047-b2eb-5338c689bd8a
# ╠═1e25a85f-1015-4f58-bd39-11e3bedff9f6
# ╠═0ddf0699-8354-4fa9-b14c-660fa2e8e6de
# ╠═066735e3-de65-4b75-9e51-52f0510c0c70
# ╠═21b5a20d-b03d-45b8-b937-c6ed787bced9
# ╠═0a3a5a80-b802-4006-bf74-652f7871a421
# ╟─678f52e4-e2d6-4f6c-96b3-ce5da764ba21
# ╟─ece247a6-e674-425c-9012-3d34c8523f7d
# ╟─4b6191bb-782b-49fc-89f1-93ad9ab78455
# ╠═46931772-c509-4677-b0ee-ec8d113a5370
# ╠═df22b1e7-80f6-4174-bd63-e93ea6487962
# ╠═aefa2b10-1c4d-4db0-9593-8c94bc156735
# ╟─7afe1db9-a215-4b6e-b5cd-437ccc2c059f
# ╟─8af400cd-4c20-4ddb-b8f0-7b296018c4b4
# ╟─0f83892a-ba2a-4e97-abd7-661feed637ab
# ╟─17e33fbb-45f7-47f1-947d-3cdfd73db053
# ╠═083d609c-dfa4-4ea6-aa91-a6f6fd14a790
# ╠═f9fa112c-92ae-4a17-a6bf-3d839e843edf
# ╟─f5001742-fa74-4666-ab54-a26701074071
# ╟─dde39bbc-0007-49e6-9ddd-2d2f10fbee9f
# ╟─f7e4008e-fe4a-4a3a-95af-ef7ecd186ba1
# ╠═724d22be-f133-4551-b664-bdfc28a4508b
# ╟─4aebf26f-5a1b-4bc8-8f83-2b51fe52369d
# ╟─ccc06faa-8410-4735-89a2-9ce922ad4ab5
# ╠═49f43442-e55c-4a06-a9b3-e8d15d79f541
# ╟─029f2ffb-1933-4d0e-9dfb-46b0cb26d310
# ╟─1f44255a-5d8d-42f1-9d3d-41341c4ffd98
# ╠═a13ac17a-870c-4e16-8443-7341493452fd
# ╠═0e4140b0-65db-4961-8846-8b2892440399
# ╠═baa264f9-7cd8-4423-b05c-02503a26b9fc
# ╟─df877062-af6c-47f1-bd43-189142ba9c02
# ╟─5bcc2744-82aa-4c71-8bd3-8065050400f6
# ╟─3fefc103-0d38-4d41-872f-9cf7919566f2
# ╠═3858727e-92df-4098-8713-4ea22624d232
# ╠═7b642ecf-7cea-458b-8c93-dbbb226ddbba
# ╠═01297e73-3ba3-4f83-85fc-c62178e59323
# ╠═47c2f19d-cd93-4bbb-b1bf-f223e329cecc
# ╠═901c8a15-49f4-478d-84e3-b46d3d19aa10
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
