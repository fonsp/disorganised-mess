### A Pluto.jl notebook ###
# v0.12.20

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 5c0ff932-6c84-11eb-17af-dd9a537df03f
using PlutoUI

# ╔═╡ 251d25c3-fa6c-4c27-aeb6-7574d377bf73
md"""
### Start both clocks:
and wait 6 seconds
"""

# ╔═╡ 460b90ba-4ac3-474f-93d9-53a7913ff94e
md"""Run superclock: $(@bind do_clock html"<input type=checkbox>")"""

# ╔═╡ a401b05b-2c2a-4b26-a570-ece0c7bf0261
num_ticks = Ref(0)

# ╔═╡ 94a73fa4-32fb-4764-b95e-2cdb68e81598
Δt = 3

# ╔═╡ d5a1374e-93d1-42d1-8e08-b0f70c6bf1ca
@bind reset Clock(Δt)

# ╔═╡ 6faf8c8b-74b2-4bff-861c-028c2b4715ed
let
	reset
	freq = num_ticks[] / Δt
	num_ticks[] = 0

	md"Reached **$(freq) ticks per second**"
end

# ╔═╡ 9f43441e-0a20-422f-b422-ac7b24931d67
supertimer = html"""
<script>
let i = 0

const handle = setInterval(() => {
i += 1
currentScript.value = i
currentScript.dispatchEvent(new CustomEvent("input"))
}, 1)

invalidation.then(() => {
	clearInterval(handle)
})

</script>
""";

# ╔═╡ 7d42bb8f-0cb6-4b3f-a5b4-0e9f7c0c6383
if do_clock === true
	@bind trigger supertimer
end

# ╔═╡ 92ba441d-5828-4c23-bd6a-6f9fdc1c861d
let
	trigger
	num_ticks[] += 1
end

# ╔═╡ Cell order:
# ╠═5c0ff932-6c84-11eb-17af-dd9a537df03f
# ╟─251d25c3-fa6c-4c27-aeb6-7574d377bf73
# ╠═d5a1374e-93d1-42d1-8e08-b0f70c6bf1ca
# ╠═460b90ba-4ac3-474f-93d9-53a7913ff94e
# ╠═7d42bb8f-0cb6-4b3f-a5b4-0e9f7c0c6383
# ╠═6faf8c8b-74b2-4bff-861c-028c2b4715ed
# ╠═a401b05b-2c2a-4b26-a570-ece0c7bf0261
# ╠═92ba441d-5828-4c23-bd6a-6f9fdc1c861d
# ╠═94a73fa4-32fb-4764-b95e-2cdb68e81598
# ╠═9f43441e-0a20-422f-b422-ac7b24931d67
