### A Pluto.jl notebook ###
# v0.12.20

using Markdown
using InteractiveUtils

# ╔═╡ 571613a1-6b4b-496d-9a68-aac3f6a83a4b
begin
	import Pkg
	Pkg.activate(mktempdir())
	Pkg.add(["HypertextLiteral", "JSON"])
	using HypertextLiteral
	using JSON
end

# ╔═╡ 97914842-76d2-11eb-0c48-a7eedca870fb
md"""
# Using _JavaScript_ inside Pluto

You have already seen that Pluto is designed to be _interactive_. You can make fantastic explorable documents using just the basic inputs provided by PlutoUI, together with the diff
"""

# ╔═╡ 92ba414b-17f1-4b98-a823-2dcd90578a49
md"""
# Script output

# `currentScript`
"""

# ╔═╡ f3ff3b80-0623-4251-ab8b-914673b4a629
md"""
# Script loading

To use external javascript dependencies, we recommend that you use an **ES6 import** if the library supports it.





`<script src="...">` tags with a `src` attribute set, like this tag to import the d3.js library:

```
<script src="https://cdn.jsdelivr.net/npm/d3@6.2.0/dist/d3.min.js"></script>
```

will work as expected. The execution of other script tags within the same cell is delayed until a `src` script finished loading, and Pluto will make sure that every source file is only loaded once.
"""

# ╔═╡ a9815586-1532-4fa1-bf79-905ff9de4e92
cool_thing() = html"""



"""

# ╔═╡ a33c7d7a-8071-448e-abd6-4e38b5444a3a
md"""
# Stateful output with `this`

"""

# ╔═╡ e77cfefc-429d-49db-8135-f4604f6a9f0b
md"""
## Example: d3.js transitions
"""

# ╔═╡ ae55f62e-f165-4413-a6e0-8f9c440d7adf
dot_positions = [100, 300] # edit me!

# ╔═╡ bf9b36e8-14c5-477b-a54b-35ba8e415c77
"""
<script src="https://cdn.jsdelivr.net/npm/d3@6.2.0/dist/d3.min.js"></script>

<script id="hello">

const positions = $(JSON.json(dot_positions))
	
const svg = this == null ? DOM.svg(600,200) : this
const s = this == null ? d3.select(svg) : this.s

s.selectAll("circle")
	.data(positions)
	.join("circle")
    .transition()
    .duration(300)
	.attr("cx", d => d)
	.attr("cy", 100)
	.attr("r", 10)
	.attr("fill", "gray")


const output = svg
output.s = s
return output
</script>

""" |> HTML

# ╔═╡ 91e9a6dc-b970-4c83-b2b9-dfaff706c28c
script(s) = HTML("""
	<script id="something">
	$s
	</script>
	""")

# ╔═╡ 91f3dab8-5521-44a0-9890-8d988a994076
trigger = "edit me!"

# ╔═╡ dcaae662-4a4f-4dd3-8763-89ea9eab7d43
let
	trigger
	
	html"""
	<script id="something">

	if(this == null) {
		return html`<blockquote>I am running for the first time!</blockqoute>`
	} else {
		return html`<blockquote><b>I was triggered by reactivity!</b></blockqoute>`
	}


	</script>
	"""
end

# ╔═╡ Cell order:
# ╠═97914842-76d2-11eb-0c48-a7eedca870fb
# ╠═92ba414b-17f1-4b98-a823-2dcd90578a49
# ╠═f3ff3b80-0623-4251-ab8b-914673b4a629
# ╠═a9815586-1532-4fa1-bf79-905ff9de4e92
# ╠═a33c7d7a-8071-448e-abd6-4e38b5444a3a
# ╠═dcaae662-4a4f-4dd3-8763-89ea9eab7d43
# ╟─e77cfefc-429d-49db-8135-f4604f6a9f0b
# ╠═ae55f62e-f165-4413-a6e0-8f9c440d7adf
# ╠═bf9b36e8-14c5-477b-a54b-35ba8e415c77
# ╠═91e9a6dc-b970-4c83-b2b9-dfaff706c28c
# ╠═91f3dab8-5521-44a0-9890-8d988a994076
# ╠═571613a1-6b4b-496d-9a68-aac3f6a83a4b
