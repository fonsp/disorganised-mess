### A Pluto.jl notebook ###
# v0.11.6

using Markdown
using InteractiveUtils

# ╔═╡ 673b77fc-e16d-11ea-3718-113715701f75
md"# Hello"

# ╔═╡ aba17712-e16f-11ea-3a8e-f338dc28583c
md"# World"

# ╔═╡ 27096552-e16d-11ea-0190-c3adf4a91cec
html"""
<script>
const headers = Array.from(
	document.querySelectorAll(
		"pluto-notebook pluto-output h1"
	)
)

return html`<ul>${headers.map(h1 => 
			html`<li>${h1.innerText}</li>`
	)}</ul>`

</script>
"""

# ╔═╡ Cell order:
# ╠═673b77fc-e16d-11ea-3718-113715701f75
# ╠═aba17712-e16f-11ea-3a8e-f338dc28583c
# ╠═27096552-e16d-11ea-0190-c3adf4a91cec
