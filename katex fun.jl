### A Pluto.jl notebook ###
# v0.18.4

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

# ╔═╡ 2b72a4ec-c88e-11eb-30b1-8d574ab0e3f1
using HypertextLiteral

# ╔═╡ b82b0cdd-58b6-4cd9-8814-4b7046894bce
using PlutoUI

# ╔═╡ 16534443-6fc2-4d48-a821-26b622859a6e
$f(x) = 
\oint_{
	x \in \mathbb{R}
}
\frac{
	1 + ⠀
}{
	⠁ + x
}
$

# ╔═╡ a4c2094f-5e6f-4e4f-8bcb-703513e54c8a
smalldog = html"""
<img src='https://user-images.githubusercontent.com/6933510/116753174-fa40ab80-aa06-11eb-94d7-88f4171970b2.jpeg' height=30px>"""

# ╔═╡ e59ed5bc-9e19-418a-9b01-ccaea6820096
begin
	Base.@kwdef struct SlottedLaTeX
		parts::Vector{String}
		slots::Vector{Any}
		# displaymode::Bool=true
	end
	function Base.show(io::IO, m::MIME"text/html", sl::SlottedLaTeX)
		h = @htl("""
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.15.3/dist/katex.min.css" crossorigin="anonymous">
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.15.3/dist/contrib/copy-tex.min.css" crossorigin="anonymous">
			<style>
			.katex .base, 
			.katex .strut {
				/*display: inline-flex !important;*/
				pointer-events: none;
			}
			.SlottedLaTeX {
				font-size: .75em;
			}
			.SlottedLaTeX .slot {
				pointer-events: initial;
			}
			</style>
		<script src="https://cdn.jsdelivr.net/npm/katex@0.15.3/dist/katex.min.js" crossorigin="anonymous"></script>
		<script src="https://cdn.jsdelivr.net/npm/katex@0.15.3/dist/contrib/copy-tex.min.js" crossorigin="anonymous"></script>
		<span class="SlottedLaTeX-slots" style="display: none;">
		$(
			map(sl.slots) do s
				@htl("<span class='slot'>$(s)</span>")
			end
		)
		</span>
		<script>

		// https://unicode-table.com/en/#2800
		const braille_start = 10240
		// https://unicode-table.com/en/#03B1
		const greek_start = 945

		const placeholder = (i) => String.fromCodePoint(braille_start + i)
		const placeholder_index = (s) => s.codePointAt(0) - braille_start

		const k = (segments, ...slots) => {

			const mock = [...slots.flatMap((_, i) => [segments[i], placeholder(i)]), segments[segments.length-1]].join("")

			const el = html`<span class='SlottedLaTeX'></span>`
			katex.render(mock, el, {
				displayMode: currentScript.closest("p") == null,
			})


			Array.from(el.querySelectorAll("span")).forEach(span => {
				const t = span.innerText
				if(t.length === 1) {
					const i = placeholder_index(t)
					if(0 <= i && i < slots.length) {
						span.replaceWith(slots[i])
					}

				}
			})

			return el
		}

		const parts = $(sl.parts)

		console.log(parts)
		const slots = Array.from(currentScript.previousElementSibling.children)

		console.log(slots)
		return k(parts, ...slots)

		</script>


		""")

		Base.show(io, m, h)
	end
end

# ╔═╡ 6d43f0c4-2475-44e5-9365-d717f98e3bba
begin
	macro tex(x)
		tex(x)
	end
	# `_str` macros with interpolation are not reactive in pluto 🙈 until https://github.com/fonsp/Pluto.jl/pull/1032 is fixed. :((
	#macro tex_str(_x::String)
	#	x = Meta.parse("\"" * _x * "\"")
 	#	tex(x)
	#end
	function tex(ex::Expr)
		@assert ex.head === :string
		if ex.args[1] isa String
			parts = String[ex.args[1]]
			slots = Any[]
		else
			parts = ["\\hspace{0pt}"]
			slots = [ex.args[1]]
		end
		for x in ex.args[2:end]
			if x isa String			
				all(==(' '), x) ? push!(parts, "\\hspace{0pt}") : push!(parts, x)
			else
				length(parts) != length(slots) + 1 && push!(parts, "\\hspace{0pt}")
				push!(slots, x)
			end
		end
		if length(slots) == length(parts)
			push!(parts, "\\hspace{0pt}")
		end
		quote
			SlottedLaTeX(
				parts = $parts,
				slots = [$(esc.(slots)...)],
			)
		end
	end
	function tex(x::String)
		SlottedLaTeX(
			parts=[x],
			slots=[],
		)
	end
end

# ╔═╡ a9c0b54c-ba74-41b1-8baf-a02cf3edf764
cool = @tex("""
	f(x) = 
	\\oint_{
		x \\in \\mathbb{R}
	}
	\\frac{
		1 + $(smalldog)
	}{
		$(@bind x Scrubbable(5)) + x
	}
	""")

# ╔═╡ 6d0d02ce-d309-4e34-bb4d-2e8dd9712f87
x

# ╔═╡ 34f87c79-bde2-4f80-a598-f02cac3c00d4
let
	sl = @tex("Slotted\\LaTeX")
	md"""

	You can use $(sl) inside markdown! 
	
	$(cool)

	"""
end

# ╔═╡ c13e40a9-adb2-4679-9839-5b22d2470914
@macroexpand @tex("""\\frac{1 + $(π^2)}{$(Scrubbable(5)) + x}""")

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
HypertextLiteral = "~0.9.3"
PlutoUI = "~0.7.37"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.0"
manifest_format = "2.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

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
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"

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

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "85b5da0fa43588c75bb1ff986493443f821c70b7"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.2.3"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "bf0a1121af131d9974241ba53f601211e9303a9e"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.37"

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

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

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

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╠═16534443-6fc2-4d48-a821-26b622859a6e
# ╠═a9c0b54c-ba74-41b1-8baf-a02cf3edf764
# ╠═6d0d02ce-d309-4e34-bb4d-2e8dd9712f87
# ╠═34f87c79-bde2-4f80-a598-f02cac3c00d4
# ╠═2b72a4ec-c88e-11eb-30b1-8d574ab0e3f1
# ╠═b82b0cdd-58b6-4cd9-8814-4b7046894bce
# ╠═6d43f0c4-2475-44e5-9365-d717f98e3bba
# ╠═c13e40a9-adb2-4679-9839-5b22d2470914
# ╠═a4c2094f-5e6f-4e4f-8bcb-703513e54c8a
# ╠═e59ed5bc-9e19-418a-9b01-ccaea6820096
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
