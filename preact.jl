### A Pluto.jl notebook ###
# v0.15.0

using Markdown
using InteractiveUtils

# ╔═╡ e26f37c4-7e6e-11eb-101c-1db0eda6940e
using JSON

# ╔═╡ 359596df-78a4-4e9b-aa7b-665ab29dc7ec
md"""
Modify `x`, add and remove elements, and notice that preact maintains its state.
"""

# ╔═╡ e4d31294-5369-4473-b319-3d7962164953
x = ["hi!", "pluto is cool", 1]

# ╔═╡ 7e226ea0-dfd6-4f5f-a3c3-88c8bbba97a1
state = Dict(
	:x => x
	)

# ╔═╡ 63d20a5e-ef56-4372-8d52-c042b183206b
HTML("""
<script type="module" id="asdf">
	
	const { html, render, Component, useEffect, useLayoutEffect, useState, useRef, useMemo, createContext, useContext, } = await import( "https://cdn.jsdelivr.net/npm/htm@3.0.4/preact/standalone.mjs")

	const node = this ?? document.createElement("div")
	
	const new_state = $(json(state))
	
	if(this == null){
	
	
	const Item = ({value}) => {
		const [loading, set_loading] = useState(true)
		
		useEffect(() => {
			
			const handle = setTimeout(() => {
				set_loading(false)
			}, 1000)
			
			return () => clearTimeout(handle)
		})
		
		return html`<li>\${loading ? 
			html`<em>Loading...</em>` : 
			value
		}</li>`
	}
	
  const App = () => {
	
	const [state, set_state] = useState(new_state)
	node.set_app_state = set_state
	
    return html`<h1>Hello world!</h1>
		<ul>\${
		state.x.map((x,i) => html`<\${Item} value=\${x} key=\${i}/>`)
	}</ul>`;
  }
	
	

  render(html`<\${App}/>`, node);
	
	} else {
		
		node.set_app_state(new_state)
	}
	return node
</script>
""")

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
JSON = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"

[compat]
JSON = "^0.21.1"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "81690084b6198a2e1da36fcfda16eeca9f9f24e4"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.1"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "223a825cccef2228f3fdbf2ecc7ca93363059073"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "1.0.16"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
"""

# ╔═╡ Cell order:
# ╠═e26f37c4-7e6e-11eb-101c-1db0eda6940e
# ╟─359596df-78a4-4e9b-aa7b-665ab29dc7ec
# ╠═e4d31294-5369-4473-b319-3d7962164953
# ╠═63d20a5e-ef56-4372-8d52-c042b183206b
# ╠═7e226ea0-dfd6-4f5f-a3c3-88c8bbba97a1
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
