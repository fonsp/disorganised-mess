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

# ╔═╡ c8c90d70-59df-11ec-1722-679b0664137d
using PlutoUI

# ╔═╡ e4ed7fa7-8ad5-4be2-b80b-02aef5e36adc
using Unitful

# ╔═╡ ab34cb19-7870-41ea-88cf-1dda28d570d9


# ╔═╡ 9d70ddc1-86c1-4da0-8296-9717898068ee


# ╔═╡ f040cde5-b270-46d3-aed3-3c4e2fc32807


# ╔═╡ 763035a8-2f6d-4f87-9596-98a8010dfb0e
md"""
# 📏 Unitful sliders!
"""

# ╔═╡ 57f84a5f-e161-4bee-b382-d4ca0c52f47f
@bind x Slider(1:100)

# ╔═╡ 1ea35353-eaf4-42b0-8bcd-57130f380f8f
x

# ╔═╡ 6ff4d580-5884-44a1-b095-3d8416b5892f


# ╔═╡ 2a027a65-d5f2-4583-a064-749f87a9f85d


# ╔═╡ 0fea9b48-8fc6-407a-9ff7-a9a9f677edb4


# ╔═╡ 09c1feed-1fe3-4995-b362-8bbf4ddaa253
1u"km" + 200u"m"

# ╔═╡ 45a041a3-9a03-4d5c-af5d-acb15570bf42


# ╔═╡ 1a58dc21-d1e7-445a-8e5d-4a6a534dd470


# ╔═╡ a7fbcb62-7880-4639-86a5-018f206491d0


# ╔═╡ f67c306e-c0e2-4c6d-91c5-192d8a14d938


# ╔═╡ 9caca418-e708-47da-a7ad-ae360a510229
md"""
Together!
"""

# ╔═╡ cb9e30fa-087f-42b7-8c5a-bb8b803c761e
@bind diameter Slider((1:20)u"cm")

# ╔═╡ 30682263-bdb6-422b-80c5-f7bb0b1655fc


# ╔═╡ e99f6b0c-8356-47e1-9074-31c1ea008da9


# ╔═╡ b07bcdab-518f-4dc8-ae08-a35bb65d7d5a


# ╔═╡ 342a9bdc-6d0f-4518-96d0-655fd2417441


# ╔═╡ 67fc47df-c413-494c-9a39-382f33326f9a


# ╔═╡ 721a8154-7620-4b2c-96bd-de953dd706c0


# ╔═╡ 7b36524c-e6fc-4b3e-a023-89651eebcf2c
md"""
# 👀 Function slider
"""

# ╔═╡ f543633f-3095-4c20-932c-4afe2a9e98bc
md"""
Let's define two functions:
"""

# ╔═╡ 47d17f34-b92f-4265-9d32-79e2a431fa09
square_area(x) = x^2

# ╔═╡ 39048c7f-d952-4127-b1a5-57fdc20fb43d
circle_area(x) = π * x^2

# ╔═╡ ca1b7717-4bac-420f-ab16-67bbfd421cd6
@bind f Select([square_area, circle_area])

# ╔═╡ bfd63466-7597-46a3-8c4c-6e7b9dbce235
f(diameter)

# ╔═╡ be63623a-3fe2-46d5-ab8f-cadc74b43565


# ╔═╡ 202f3572-52a0-4964-884a-6551dd257b9c


# ╔═╡ d1d678db-6e6e-44ab-9a77-630c38b531c5
md"""
We can slide through a list of functions!
"""

# ╔═╡ 2cb304f8-2845-4b97-b1e2-79dbac112db1
f

# ╔═╡ a9bad0b0-93b6-48a5-a8b9-80af898c8339


# ╔═╡ 5917df7e-8ec8-4874-a847-9404f3864175


# ╔═╡ 9776c64f-f5e3-4211-b1e8-906ae40b8e0d


# ╔═╡ 3f70859e-12ba-440d-b0c7-c1fedf248588


# ╔═╡ 25d8b18b-45a1-4a98-95f3-f8c32f196d88


# ╔═╡ 9528b5ed-3eb1-45bb-99c9-72d55ccb8916
md"""
# Want to learn more?

`Pluto.jl` is an open source, interactive programming environment for [Julia](https://julialang.org/), designed for teachers. 



> ### Try it out today! [plutojl.org](https://github.com/fonsp/Pluto.jl)
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[compat]
PlutoUI = "~0.7.21"
Unitful = "~1.9.2"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.0"
manifest_format = "2.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "abb72771fd8895a7ebd83d5632dc4b989b022b5b"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.2"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f74e9d5388b8620b4cee35d4c5a618dd4dc547f4"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.3.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

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
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

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
git-tree-sha1 = "ae4bbcadb2906ccc085cf52ac286dc1377dceccc"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.1.2"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "b68904528fd538f1cb6a3fbc44d2abdc498f9e8e"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.21"

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

[[deps.Unitful]]
deps = ["ConstructionBase", "Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "0992ed0c3ef66b0390e5752fe60054e5ff93b908"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.9.2"

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
# ╟─ab34cb19-7870-41ea-88cf-1dda28d570d9
# ╟─9d70ddc1-86c1-4da0-8296-9717898068ee
# ╟─f040cde5-b270-46d3-aed3-3c4e2fc32807
# ╟─763035a8-2f6d-4f87-9596-98a8010dfb0e
# ╠═c8c90d70-59df-11ec-1722-679b0664137d
# ╠═57f84a5f-e161-4bee-b382-d4ca0c52f47f
# ╠═1ea35353-eaf4-42b0-8bcd-57130f380f8f
# ╟─6ff4d580-5884-44a1-b095-3d8416b5892f
# ╟─2a027a65-d5f2-4583-a064-749f87a9f85d
# ╟─0fea9b48-8fc6-407a-9ff7-a9a9f677edb4
# ╠═e4ed7fa7-8ad5-4be2-b80b-02aef5e36adc
# ╠═09c1feed-1fe3-4995-b362-8bbf4ddaa253
# ╟─45a041a3-9a03-4d5c-af5d-acb15570bf42
# ╟─1a58dc21-d1e7-445a-8e5d-4a6a534dd470
# ╟─a7fbcb62-7880-4639-86a5-018f206491d0
# ╟─f67c306e-c0e2-4c6d-91c5-192d8a14d938
# ╟─9caca418-e708-47da-a7ad-ae360a510229
# ╠═ca1b7717-4bac-420f-ab16-67bbfd421cd6
# ╠═cb9e30fa-087f-42b7-8c5a-bb8b803c761e
# ╠═bfd63466-7597-46a3-8c4c-6e7b9dbce235
# ╟─30682263-bdb6-422b-80c5-f7bb0b1655fc
# ╟─e99f6b0c-8356-47e1-9074-31c1ea008da9
# ╟─b07bcdab-518f-4dc8-ae08-a35bb65d7d5a
# ╟─342a9bdc-6d0f-4518-96d0-655fd2417441
# ╟─67fc47df-c413-494c-9a39-382f33326f9a
# ╟─721a8154-7620-4b2c-96bd-de953dd706c0
# ╟─7b36524c-e6fc-4b3e-a023-89651eebcf2c
# ╟─f543633f-3095-4c20-932c-4afe2a9e98bc
# ╠═47d17f34-b92f-4265-9d32-79e2a431fa09
# ╠═39048c7f-d952-4127-b1a5-57fdc20fb43d
# ╟─be63623a-3fe2-46d5-ab8f-cadc74b43565
# ╟─202f3572-52a0-4964-884a-6551dd257b9c
# ╟─d1d678db-6e6e-44ab-9a77-630c38b531c5
# ╠═2cb304f8-2845-4b97-b1e2-79dbac112db1
# ╟─a9bad0b0-93b6-48a5-a8b9-80af898c8339
# ╟─5917df7e-8ec8-4874-a847-9404f3864175
# ╟─9776c64f-f5e3-4211-b1e8-906ae40b8e0d
# ╟─3f70859e-12ba-440d-b0c7-c1fedf248588
# ╟─25d8b18b-45a1-4a98-95f3-f8c32f196d88
# ╟─9528b5ed-3eb1-45bb-99c9-72d55ccb8916
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
