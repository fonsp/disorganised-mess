### A Pluto.jl notebook ###
# v0.17.2

using Markdown
using InteractiveUtils

# ╔═╡ d0e203fa-4c5a-11ec-36b8-2fd4376f116e
using HypertextLiteral

# ╔═╡ c7692fc3-7f54-4a34-8bd4-53ff4cafb92d
ct_header = @htl("""


<div style="
min-height: 500px;
width: 100%;
background: #282936;
color: #fff;
padding-top: 68px;
">
<div style="
max-width: 800px;
margin: 0 auto;
">

<span style="
font-family: Vollkorn, serif;
font-weight: 700;
font-feature-settings: 'lnum', 'pnum';
"> <p style="
font-size: 1.5rem;
opacity: .8;
"><em>Section 1.1</em></p>
<p style="text-align: center; font-size: 2rem;">
<em> The Newton Method </em>
</p>

<p style="
font-size: 1.5rem;
text-align: center;
opacity: .8;
"><em>Lecture Video</em></p>
<div style="display: flex; justify-content: center;">
<div  notthestyle="position: relative; right: 0; top: 0; z-index: 300;">
<iframe src="https://www.youtube.com/embed/Wjcx9sNSLP8" width=400 height=250  frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
</div>

</div>
</div>

<style>
body {
overflow-x: hidden;
}
</style>
""")

# ╔═╡ d2a38109-8cef-444b-a55f-cc1f3b2a48e7
set_preamble_html(data) = @htl("""
<script>
const data = $(try
	repr(MIME"text/html"(), data)
catch e
	string(data)
end)

let u = new URL(window.location.href)
u.searchParams.set("preamble_html", data)



let button = html`<input type=button value="See preview!">`
button.onclick = async () => {


window.location.href = u.href
}

let code = html`<code></code>`
code.innerText = data

return html`
<pre>\${code}</pre>
\${button}
`
</script>
""")

# ╔═╡ 716bf628-921d-4606-ae10-e287543b606c
set_preamble_html(@htl("""

<script>
alert("Hello from preamble!")
</script>
"""))

# ╔═╡ 99fafcb9-b660-4b63-86f1-3faa5f1cb529
set_preamble_html(@htl("""

<marquee>asdfasdf</marquee>
"""))

# ╔═╡ 466e7aa9-45be-4df6-8500-de5b42dd2145
set_preamble_html(ct_header)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"

[compat]
HypertextLiteral = "~0.9.3"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"
"""

# ╔═╡ Cell order:
# ╠═d0e203fa-4c5a-11ec-36b8-2fd4376f116e
# ╠═716bf628-921d-4606-ae10-e287543b606c
# ╠═99fafcb9-b660-4b63-86f1-3faa5f1cb529
# ╠═c7692fc3-7f54-4a34-8bd4-53ff4cafb92d
# ╠═466e7aa9-45be-4df6-8500-de5b42dd2145
# ╠═d2a38109-8cef-444b-a55f-cc1f3b2a48e7
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
