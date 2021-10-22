### A Pluto.jl notebook ###
# v0.16.2

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ da3133c4-332b-11ec-1659-29ae989d67f3
using PlutoUI

# ╔═╡ 3ac888c6-4dc8-4dc2-a418-f91499b20df6
using HypertextLiteral

# ╔═╡ 8399c52d-c00c-456b-8178-c692d2749868
@bind y Slider(6:.1:7)

# ╔═╡ 847d3057-f8f7-4983-a915-aed0ac961bce
@bind x Slider(1:10)

# ╔═╡ a658292c-44ff-4a5e-8571-798e955a2311
@bind cool CheckBox(false)

# ╔═╡ f62f80c8-502c-4ce2-9223-6c2d15d57a80
HTML("""
<div style="width: 200px; height: 200px; background: salmon;">

<div style="width: 1em; height: 1em; background: $(cool ? "darkblue" : "green"); position: absolute; left: $(x * 20)px; top: $(y * 20)px;"></div>

</div>
""")

# ╔═╡ e945bec5-a7db-4014-b9fe-86c471237f6f
(x,y)

# ╔═╡ 1f50941b-7155-4341-900a-b37f90a6fb04
md"---"

# ╔═╡ 9ad17c17-78cf-4977-82a6-27d5f7a01b03
@bind hellooooo Slider(1:100)

# ╔═╡ 0b820f97-fe42-4f97-b001-ab32dc7b50da
"hello $(hellooooo)"

# ╔═╡ 99c4dca6-e670-47be-b006-fa90a000fec8
md"---"

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
HypertextLiteral = "~0.9.1"
PlutoUI = "~0.7.16"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[HypertextLiteral]]
git-tree-sha1 = "f6532909bf3d40b308a0f360b6a0e626c0e263a8"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.1"

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
git-tree-sha1 = "f19e978f81eca5fd7620650d7dbea58f825802ee"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.1.0"

[[PlutoUI]]
deps = ["Base64", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "4c8a7d080daca18545c56f1cac28710c362478f3"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.16"

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

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
"""

# ╔═╡ Cell order:
# ╠═f62f80c8-502c-4ce2-9223-6c2d15d57a80
# ╠═8399c52d-c00c-456b-8178-c692d2749868
# ╠═847d3057-f8f7-4983-a915-aed0ac961bce
# ╠═a658292c-44ff-4a5e-8571-798e955a2311
# ╠═e945bec5-a7db-4014-b9fe-86c471237f6f
# ╟─1f50941b-7155-4341-900a-b37f90a6fb04
# ╠═9ad17c17-78cf-4977-82a6-27d5f7a01b03
# ╠═0b820f97-fe42-4f97-b001-ab32dc7b50da
# ╟─99c4dca6-e670-47be-b006-fa90a000fec8
# ╠═da3133c4-332b-11ec-1659-29ae989d67f3
# ╠═3ac888c6-4dc8-4dc2-a418-f91499b20df6
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
