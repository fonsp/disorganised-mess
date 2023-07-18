### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# ╔═╡ 0fbcbe4e-2580-11ee-1d34-71bbfcec921e
using HypertextLiteral

# ╔═╡ 71ff15f4-a183-4222-bba0-8785668af3fb
md"""
# Switching images depending on light/dark mode

Switch your screen between light and dark mode and watch this content automatically update!

One nice way to use this in Julia is to generate two plots in two color themes, and use this to make sure that the right one is displayed to the reader.
"""

# ╔═╡ 36d3abc9-aadd-4fa5-b8bf-9f35349c461a
md"""
# Test images
"""

# ╔═╡ d1bdbaaa-91fb-424e-8356-141aedfa0764
big(x) = @htl """
<span style="font-size: 10rem;">$x</span>
"""

# ╔═╡ 1a25bc4a-dbdf-4cb4-ae78-c1eca48ee7e1
dark_plot = big("🌚")

# ╔═╡ 176b2f2e-d648-4af7-9d5b-cafc2304166a
light_plot = big("🌝")

# ╔═╡ 75b365ee-bc3d-42e8-9b16-44d165584f89
md"""
# How it works
"""

# ╔═╡ 526aa50e-14c8-4264-b886-eabbff48e308
lightdark(light, dark) = @htl """
<style>
		
	.plutoui-only-when-light {
		display: unset;
	}
	.plutoui-only-when-dark {
		display: none;
	}

	@media (prefers-color-scheme: dark) {
	
		.plutoui-only-when-light {
			display: none;
		}
		.plutoui-only-when-dark {
			display: unset;
		}
	}
</style>
<span class="plutoui-only-when-light">$light</span>
<span class="plutoui-only-when-dark">$dark</span>
"""

# ╔═╡ 2161b66e-73bf-41aa-b692-238eccfab347
lightdark(light_plot, dark_plot)

# ╔═╡ f59cd504-2385-4e21-8150-9bc8bb443438
lightdark(md"You are in **light** mode!", md"You are in **dark** mode!")

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"

[compat]
HypertextLiteral = "~0.9.4"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.3"
manifest_format = "2.0"
project_hash = "fc304fba520d81fb78ea25b98f5762b4591b1182"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.Tricks]]
git-tree-sha1 = "aadb748be58b492045b4f56166b5188aa63ce549"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.7"
"""

# ╔═╡ Cell order:
# ╟─71ff15f4-a183-4222-bba0-8785668af3fb
# ╠═2161b66e-73bf-41aa-b692-238eccfab347
# ╠═f59cd504-2385-4e21-8150-9bc8bb443438
# ╟─36d3abc9-aadd-4fa5-b8bf-9f35349c461a
# ╠═d1bdbaaa-91fb-424e-8356-141aedfa0764
# ╠═1a25bc4a-dbdf-4cb4-ae78-c1eca48ee7e1
# ╠═176b2f2e-d648-4af7-9d5b-cafc2304166a
# ╟─75b365ee-bc3d-42e8-9b16-44d165584f89
# ╠═0fbcbe4e-2580-11ee-1d34-71bbfcec921e
# ╠═526aa50e-14c8-4264-b886-eabbff48e308
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
