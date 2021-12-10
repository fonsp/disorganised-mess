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

# ╔═╡ 39803c9c-8d0a-499d-aef3-afed2afd9026
using PlutoUI

# ╔═╡ 24e039a4-c4fe-415f-b02e-484addc18659
md"""
# Outdated

This is now an official feature of PlutoUI!

https://github.com/JuliaPluto/PlutoUI.jl/pull/164

https://github.com/JuliaPluto/PlutoUI.jl/pull/163
"""

# ╔═╡ 3bad3496-fa7e-11ea-333f-57ed97316b28
function confirm_combine(node, label="Submit")
	
	id = String(rand('a':'z', 10))
	"""
<div>
	<span>
	$(repr(MIME"text/html"(), node))
	</span>
<input type="submit" value="$(Markdown.htmlesc(label))">
<script>
	const div = currentScript.parentElement
	const inputs = div.querySelectorAll("span input")
	
	const values = Array(inputs.length)
	
	inputs.forEach(async (el,i) => {
		el.oninput = (e) => {
			e.stopPropagation()
		}
		const gen = Generators.input(el)
		while(true) {
			values[i] = await gen.next().value
			div.value = values
		}
	})
	
	const submit = div.querySelector("input[type=submit]")
	submit.onclick = () => {
		div.dispatchEvent(new CustomEvent("input", {}))
	}
</script>
</div>
	
""" |> HTML
end

# ╔═╡ e50355d6-fa7f-11ea-2e0d-673c49836136
@bind xoxo confirm_combine(md"""
A slider: $(Slider(1:10))
	
and a checkbox: $(CheckBox())

""")

# ╔═╡ fa03a8ca-fa7f-11ea-2021-bfb9dc7ff411
# sleep(1); 
xoxo

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.11"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[HypertextLiteral]]
git-tree-sha1 = "72053798e1be56026b81d4e2682dbe58922e5ec9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.0"

[[IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "9d8c00ef7a8d110787ff6f170579846f776133a9"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.0.4"

[[PlutoUI]]
deps = ["Base64", "Dates", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "0c3e067931708fa5641247affc1a1aceb53fff06"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.11"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
"""

# ╔═╡ Cell order:
# ╠═24e039a4-c4fe-415f-b02e-484addc18659
# ╠═fa03a8ca-fa7f-11ea-2021-bfb9dc7ff411
# ╠═e50355d6-fa7f-11ea-2e0d-673c49836136
# ╠═39803c9c-8d0a-499d-aef3-afed2afd9026
# ╠═3bad3496-fa7e-11ea-333f-57ed97316b28
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
