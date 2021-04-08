### A Pluto.jl notebook ###
# v0.14.1

using Markdown
using InteractiveUtils

# ╔═╡ 101a109f-1b87-4291-9455-cc0d08639f51
using PlutoUI

# ╔═╡ 6bcbfdc1-a9f8-4c73-b8f2-a55718bac0dd
using Base64

# ╔═╡ ef8175dc-98b9-11eb-384b-f9d9a506aac8
svg_data = read(download("https://raw.githubusercontent.com/fonsp/Pluto.jl/dd0ead4caa2d29a3a2cfa1196d31e3114782d363/frontend/img/logo_white_contour.svg"), String)

# ╔═╡ 2b6ab3a0-0773-4d4a-9948-5d8f2cd00ad9
md"""
### Displayed as SVG-inside-HTML

You cannot save this image by right-clicking it :(
"""

# ╔═╡ e9800429-1ad1-44d7-b018-70affadf0a5b
HTML("""
	<p>Here is the image:</p>
	$(svg_data)
	""")

# ╔═╡ ada092b1-b401-4808-a142-bbe9f6669460
md"""
### Displayed as <img>

Right-click to save!
"""

# ╔═╡ 0579fbb2-5e96-44a1-a7dd-7ea81a39cc8a
mime = MIME"image/svg+xml"()

# ╔═╡ 7b85a070-b4fd-46f1-8760-a869ec032d19
src = join([
		"data:", 
		string(mime),
		";base64,", 
		Base64.base64encode(svg_data)
	])

# ╔═╡ c5fb9ccf-4cca-4adc-91b9-39f8a232b3a0
PlutoUI.Resource(src, mime, Tuple{}())

# ╔═╡ 9f6063e0-9f0f-4359-a6de-c527c199c467
md"""
You can add PlutoUI as a dependency to PenPlots.jl, or you should feel free to copy the relevant source code! PlutoUI.jl is Unlicensed, which means that you can take snippets and use it how you like.
"""

# ╔═╡ Cell order:
# ╠═ef8175dc-98b9-11eb-384b-f9d9a506aac8
# ╟─2b6ab3a0-0773-4d4a-9948-5d8f2cd00ad9
# ╠═e9800429-1ad1-44d7-b018-70affadf0a5b
# ╟─ada092b1-b401-4808-a142-bbe9f6669460
# ╠═c5fb9ccf-4cca-4adc-91b9-39f8a232b3a0
# ╠═0579fbb2-5e96-44a1-a7dd-7ea81a39cc8a
# ╠═7b85a070-b4fd-46f1-8760-a869ec032d19
# ╟─9f6063e0-9f0f-4359-a6de-c527c199c467
# ╠═101a109f-1b87-4291-9455-cc0d08639f51
# ╠═6bcbfdc1-a9f8-4c73-b8f2-a55718bac0dd
