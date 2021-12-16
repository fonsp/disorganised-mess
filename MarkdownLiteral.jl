### A Pluto.jl notebook ###
# v0.17.3

using Markdown
using InteractiveUtils

# ╔═╡ e96657c4-5e5b-11ec-3ee7-7f28f5b1d15f
using HypertextLiteral

# ╔═╡ cfac68c2-7c17-477d-8e2f-d4a366cdbf94
using CommonMark

# ╔═╡ 36eef302-5c0a-4591-a781-2ad0f16f903b
md"""
# First attempt

Use HTL to do the string macro magic, and then pass the raw HTML result to JS. We then use `markdown-it` to render to HTML, and `innerHTML` that into the DOM.
"""

# ╔═╡ c27a5c3e-53b0-4747-ac67-09b41c6e66b0
macro md_js(expr)
	quote
		var"@htl" = $(HypertextLiteral.var"@htl")
		result = @htl($expr)
		@htl("""
		<div>
		<script src='https://cdn.jsdelivr.net/npm/markdown-it@12.3.0/dist/markdown-it.js'></script>
		<script>
		let raw = $(repr(MIME"text/html"(), result))
		let div = currentScript.parentElement
		let md = markdownit({html: true})

		div.innerHTML = md.render(raw)
		</script>
		</div>
		""")
	end
end

# ╔═╡ 3683590a-2886-4b57-93b2-8e85e1d77eb6
md"""
# Second attempt

Use HTL to do the string macro magic, and then ask CommonMark.jl to render it.
"""

# ╔═╡ 78e8e522-6fad-4f88-94c1-761b0975b2ad
macro md_cm(expr)
	cm_parser = CommonMark.Parser()
	quote
		result = @htl($expr)
		htl_output = repr(MIME"text/html"(), result)

		$(cm_parser)(htl_output)
	end
end

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
        margin: { t: 0 } 
    })

    return container
</script>
""")

# ╔═╡ 95833ce7-9005-480f-bd74-37e6c7adad94
@md_js("""
# Hello!
This is *Markdown* but **supercharged**!!
<marquee style='color: purple; font-family: cursive;'>Inline HTML supported!</marquee>

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

## Intepolating a plotly plot
**Does not work**, because the `script` tag does not work :(
$(plot(1:10, rand()))

## Code block
```julia
function f(x::Int64)
	"hello \$(x)"
end


# we can interpolate into code blocks!
$(code_snippet)
```
""")

# ╔═╡ 797063b6-ba13-4915-984f-6304e1276faf
@md_cm("""
# Hello!
This is *Markdown* but **supercharged**!!
<marquee style='color: purple; font-family: cursive;'>Inline HTML supported!</marquee>

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

# ╔═╡ 506e79b9-8373-4d03-bbbc-c6d691f93865
plot(1:10, rand(10))

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CommonMark = "a80b9123-70ca-4bc0-993e-6e3bcb318db6"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"

[compat]
CommonMark = "~0.8.4"
HypertextLiteral = "~0.9.3"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.0"
manifest_format = "2.0"

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

[[deps.HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "ae4bbcadb2906ccc085cf52ac286dc1377dceccc"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.1.2"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
"""

# ╔═╡ Cell order:
# ╠═e96657c4-5e5b-11ec-3ee7-7f28f5b1d15f
# ╟─36eef302-5c0a-4591-a781-2ad0f16f903b
# ╠═c27a5c3e-53b0-4747-ac67-09b41c6e66b0
# ╠═95833ce7-9005-480f-bd74-37e6c7adad94
# ╟─3683590a-2886-4b57-93b2-8e85e1d77eb6
# ╠═cfac68c2-7c17-477d-8e2f-d4a366cdbf94
# ╠═78e8e522-6fad-4f88-94c1-761b0975b2ad
# ╠═797063b6-ba13-4915-984f-6304e1276faf
# ╠═944333f9-70d7-435e-ba26-d3a8099cfeca
# ╠═506e79b9-8373-4d03-bbbc-c6d691f93865
# ╠═2a70de06-cec0-4a2e-8768-1c875437fd96
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
