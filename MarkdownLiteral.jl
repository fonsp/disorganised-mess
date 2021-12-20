### A Pluto.jl notebook ###
# v0.17.3

using Markdown
using InteractiveUtils

# ╔═╡ e96657c4-5e5b-11ec-3ee7-7f28f5b1d15f
using HypertextLiteral

# ╔═╡ cfac68c2-7c17-477d-8e2f-d4a366cdbf94
using CommonMark

# ╔═╡ 76fab621-94f8-458d-ab00-1e540f28f56d


# ╔═╡ 929bdffb-9952-439c-a33d-648879498abe
cm"""
Hello ``world``

```math
\sqrt{1+1}
```
"""

# ╔═╡ 15e93114-1eb6-431b-8649-1029f2af4609
import PlutoUI

# ╔═╡ 944333f9-70d7-435e-ba26-d3a8099cfeca
code_snippet = """
xs = [1:10..., 20]
map(xs) do x
	f(x^2)
end
"""

# ╔═╡ 2a70de06-cec0-4a2e-8768-1c875437fd96
plot(x, y) = @htl("""
<script src="https://cdn.plot.ly/plotly-1.58.0.min.js"></script>

<script>
    const container = html`<div style="width: 100%;"></div>`

    Plotly.newPlot( container, [{
        x: $(x),
        y: $(y),
    }], {
        margin: { t: 0, b:0, l: 0, r:0 } ,
		height: 100,
    })

    return container
</script>
""")

# ╔═╡ 3683590a-2886-4b57-93b2-8e85e1d77eb6
md"""
# How it works

Use HTL to do the string macro magic, and then ask CommonMark.jl to render it. That's it!
"""

# ╔═╡ 78e8e522-6fad-4f88-94c1-761b0975b2ad
macro md(expr)
	cm_parser = CommonMark.Parser()
	enable!(cm_parser, MathRule())
	quote
		result = @htl($expr)
		htl_output = repr(MIME"text/html"(), result)

		$(cm_parser)(htl_output)
	end
end

# ╔═╡ 797063b6-ba13-4915-984f-6304e1276faf
@md("""
# Hello!
This is *Markdown* but **supercharged**!!
<marquee style=$((color="purple", font_family="cursive"))>Inline HTML supported!</marquee>

Here is a list, created using simple string interpolation:
$((
	"- item $i\n" for i in 1:3
))

Another list, interpolated as HTML:
<ul>
$((
	@htl("<li>item $i</li>") for i in 1:3
))
</ul>

![](https://media.giphy.com/media/JmUfwENE6i4Jxig27n/giphy.gif)

Hello ``world``

```math
\\sqrt{1+1}
```

## Intepolating a plotly plot
It works!
$(plot(1:10, rand(10)))

## Code block
```julia
function f(x::Int64)
	"hello \$(x)"
end


# we can interpolate into code blocks!
$(code_snippet)
```
""")

# ╔═╡ 88f5be25-d5d8-46ce-a1e0-87d8c6707b1e
@md("""
# Hello!
This is *Markdown* but **supercharged**!!
""")

# ╔═╡ 5bdf3013-0edf-44da-b3a3-c7c0be8e5281
@md("""
<ul>
$((
	@htl("<li>item $i</li>") for i in 1:3
))
</ul>
""")

# ╔═╡ f9283fca-b6b0-4938-81cf-6d862b19edb1
md"""
# Stress test
"""

# ╔═╡ 3f89ddc8-663d-44cb-8a96-b48196a5b187
@htl("""
Hello\$world
""")

# ╔═╡ 60abc24d-b94c-4a12-a471-445042861da1
@md("""
Hello\$world
""")

# ╔═╡ 5f6f668a-25f2-400e-b50c-538f5f4da7ca


# ╔═╡ bf19b236-68c2-40ad-8d49-e95206647859
@htl("""
<div>helo *world*</div>
""")

# ╔═╡ 01017817-0b18-49d9-8f48-1963f5fa2681
@md("""
<div>helo *world*</div>
""")

# ╔═╡ 4c1dd370-227a-41a3-b4c6-6dce41e68c45


# ╔═╡ 0fe78dd1-24e4-457f-af27-3b9616ab085f
difficult = "asdf & 1 &amp;"

# ╔═╡ defc6ffb-b742-4234-9ef0-f07a4f0d32e5


# ╔═╡ 6f7c9079-4f96-4b3a-a535-068ca90b80e3
@md("""
hello $(difficult)

hello $(@md("""
123 $([
	@md("x$i") for i in 1:10
])
"""))
""")

# ╔═╡ 8a6345d8-543b-4306-8a50-25354588acf2


# ╔═╡ 4d2a12a1-9520-4c2f-b455-875a779b61bc


# ╔═╡ 6631cba4-5d1a-45f1-a4aa-af2c3dbc1a90


# ╔═╡ 0cd7880e-eda6-4da5-afbf-e5bb8f11371b
h1 = @md("""
<h1>asdf</h1>
""")

# ╔═╡ 071548bd-dc36-485c-bf9f-3e3954452a3a
showable(MIME"text/html"(), h1)

# ╔═╡ 43bd8a69-56db-4409-a3a4-7e71d4b4d7a7


# ╔═╡ 159cbcbc-0f87-48c9-b086-59a152c8de56
cm"""
hello $(difficult)

hello $(cm"""
123 $([
	cm"x$i" for i in 1:10
])
""")
"""

# ╔═╡ 6c19bb61-4eda-44a3-b7da-7afdfcf4ff7f


# ╔═╡ b259a168-0562-468e-ba89-5e6f3908b90f
@htl("""
Hello *$("world")*

<script>
let x = 1 *2* 3
x += 1 *$(1 + 1)* 3
return html`<code>\${x}</code>`
</script>
""")

# ╔═╡ 6fb38f44-51e1-4f92-add3-428b7ff91fe3
@md("""
Hello *$("world")*

<script>
let x = 1 *2* 3
x += 1 *$(1 + 1)* 3
return html`<code>\${x}</code>`
</script>
""")

# ╔═╡ 1845602f-80d7-48f0-acb9-2e96e59295cd


# ╔═╡ a4748d6d-cbe0-430f-b358-7c23e39cb912
cm"""
You can use `<div>` and `</div>` to create a div.
"""

# ╔═╡ 264c73dd-0cb8-47f2-8527-6c8774fb8c69
@md("""
You can use `<div>` and `</div>` to create a div.
""")

# ╔═╡ 0a8be31c-5d30-4655-8873-2d5a6aac7f56
@md("""
You can use `<div>` to create a div.

Close it with `</div>`!
""")

# ╔═╡ 1251ebdc-10e4-4ee1-bfa5-4d534ae94f42
@md("""
You can use `<div style=$((color="red",))>` to create a red div.
""")

# ╔═╡ 7242ae7c-8072-477f-bca2-21d7718b0672
@htl("""
You can use `<div>` and `</div>` to create a div.
""")

# ╔═╡ 098c41fe-7265-40a3-89a2-8d72a454fc33


# ╔═╡ e91437b9-9f5d-4593-af31-2f8fd08e88f2


# ╔═╡ 4fa7615f-bb69-4efa-922e-3685e4b64137


# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CommonMark = "a80b9123-70ca-4bc0-993e-6e3bcb318db6"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
CommonMark = "~0.8.4"
HypertextLiteral = "~0.9.3"
PlutoUI = "~0.7.23"
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

[[deps.CommonMark]]
deps = ["Crayons", "JSON", "URIs"]
git-tree-sha1 = "7a0d74b8b007c8170dd48166fdc4be049bf68f70"
uuid = "a80b9123-70ca-4bc0-993e-6e3bcb318db6"
version = "0.8.4"

[[deps.Crayons]]
git-tree-sha1 = "3f71217b538d7aaee0b69ab47d9b7724ca8afa0d"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.0.4"

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
git-tree-sha1 = "5152abbdab6488d5eec6a01029ca6697dff4ec8f"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.23"

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

[[deps.URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╠═76fab621-94f8-458d-ab00-1e540f28f56d
# ╠═797063b6-ba13-4915-984f-6304e1276faf
# ╠═929bdffb-9952-439c-a33d-648879498abe
# ╠═88f5be25-d5d8-46ce-a1e0-87d8c6707b1e
# ╠═15e93114-1eb6-431b-8649-1029f2af4609
# ╠═5bdf3013-0edf-44da-b3a3-c7c0be8e5281
# ╠═944333f9-70d7-435e-ba26-d3a8099cfeca
# ╠═2a70de06-cec0-4a2e-8768-1c875437fd96
# ╟─3683590a-2886-4b57-93b2-8e85e1d77eb6
# ╠═e96657c4-5e5b-11ec-3ee7-7f28f5b1d15f
# ╠═cfac68c2-7c17-477d-8e2f-d4a366cdbf94
# ╠═78e8e522-6fad-4f88-94c1-761b0975b2ad
# ╟─f9283fca-b6b0-4938-81cf-6d862b19edb1
# ╠═3f89ddc8-663d-44cb-8a96-b48196a5b187
# ╠═60abc24d-b94c-4a12-a471-445042861da1
# ╟─5f6f668a-25f2-400e-b50c-538f5f4da7ca
# ╠═bf19b236-68c2-40ad-8d49-e95206647859
# ╠═01017817-0b18-49d9-8f48-1963f5fa2681
# ╟─4c1dd370-227a-41a3-b4c6-6dce41e68c45
# ╠═0fe78dd1-24e4-457f-af27-3b9616ab085f
# ╠═defc6ffb-b742-4234-9ef0-f07a4f0d32e5
# ╠═6f7c9079-4f96-4b3a-a535-068ca90b80e3
# ╠═8a6345d8-543b-4306-8a50-25354588acf2
# ╠═4d2a12a1-9520-4c2f-b455-875a779b61bc
# ╠═6631cba4-5d1a-45f1-a4aa-af2c3dbc1a90
# ╠═0cd7880e-eda6-4da5-afbf-e5bb8f11371b
# ╠═071548bd-dc36-485c-bf9f-3e3954452a3a
# ╠═43bd8a69-56db-4409-a3a4-7e71d4b4d7a7
# ╠═159cbcbc-0f87-48c9-b086-59a152c8de56
# ╟─6c19bb61-4eda-44a3-b7da-7afdfcf4ff7f
# ╠═b259a168-0562-468e-ba89-5e6f3908b90f
# ╠═6fb38f44-51e1-4f92-add3-428b7ff91fe3
# ╟─1845602f-80d7-48f0-acb9-2e96e59295cd
# ╠═a4748d6d-cbe0-430f-b358-7c23e39cb912
# ╠═264c73dd-0cb8-47f2-8527-6c8774fb8c69
# ╠═0a8be31c-5d30-4655-8873-2d5a6aac7f56
# ╠═1251ebdc-10e4-4ee1-bfa5-4d534ae94f42
# ╠═7242ae7c-8072-477f-bca2-21d7718b0672
# ╟─098c41fe-7265-40a3-89a2-8d72a454fc33
# ╠═e91437b9-9f5d-4593-af31-2f8fd08e88f2
# ╠═4fa7615f-bb69-4efa-922e-3685e4b64137
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
