### A Pluto.jl notebook ###
# v0.19.12

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

# ╔═╡ 368d610a-4beb-11ed-2c67-89a2da68b026
using HypertextLiteral

# ╔═╡ a59d2b71-cb44-4b5c-afd2-dd960ec798c6
@bind result @htl """

<div class="zoomjs container" style="width: 600px; height: 600px;">


	<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/e/ef/Pluto_in_True_Color_-_High-Res.jpg/1024px-Pluto_in_True_Color_-_High-Res.jpg">

	<script>

		let value = [[], 1]

		const {default: zoomjs} = await import("https://esm.sh/vanilla-js-wheel-zoom@6.16.0?pin=v96")

		const parent = currentScript.parentElement
		const img = parent.firstElementChild


		let zoomjs_result
		
		const update_value = () => {
			parent.value = [
				[
					zoomjs_result.content.currentLeft,
					zoomjs_result.content.currentTop,
				],
				zoomjs_result.content.currentScale,
			]
			parent.dispatchEvent(new CustomEvent("input"))
		}
		
		zoomjs_result = zoomjs.create(img, {
			maxScale: 10,
			rescale: update_value,
			dragScrollableOptions: {
				onMove: update_value,
			},
		})

		update_value()
		
	</script>

	<style>
		.zoomjs.container {
    display: flex;
    align-items: center;
    justify-content: center;
    overflow: hidden;
    background: #999;
}

.zoomjs img {
    position: relative;
    display: flex;
    align-items: center;
}
	</style>
</span>

"""

# ╔═╡ 3844536e-87e9-41a7-a1d5-8fd98bbb0d65
center_position, scale = result;

# ╔═╡ 1e68254c-7762-4b0d-a105-6bdefcc17041
center_position

# ╔═╡ 75c0ec8b-1701-45c8-a510-1519a6a82cfe
scale

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

julia_version = "1.8.0"
manifest_format = "2.0"
project_hash = "312e4b9e605df01eeae246a2087d05a62416059a"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"
"""

# ╔═╡ Cell order:
# ╠═368d610a-4beb-11ed-2c67-89a2da68b026
# ╠═3844536e-87e9-41a7-a1d5-8fd98bbb0d65
# ╠═1e68254c-7762-4b0d-a105-6bdefcc17041
# ╠═75c0ec8b-1701-45c8-a510-1519a6a82cfe
# ╠═a59d2b71-cb44-4b5c-afd2-dd960ec798c6
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
