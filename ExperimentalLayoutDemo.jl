### A Pluto.jl notebook ###
# v0.16.1

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

# ╔═╡ 9cfe245c-26fc-11ec-21cc-1dafc4809eec
import Pkg

# ╔═╡ 08594582-6274-4156-8aa8-742d69bb41e1
Pkg.activate()

# ╔═╡ 4430dfa5-949c-48a0-90c5-e16603a43e11
using PlutoUI

# ╔═╡ eb2a2277-23b3-4872-a91d-ddef1763eaf0
using PlutoUI.ExperimentalLayout

# ╔═╡ fccac888-c0bc-42ad-a07d-0bfa559ecb57
using HypertextLiteral

# ╔═╡ 17301455-1f6b-475a-a51f-950bf8942302
md"""
I just released PlutoUI 0.7.15 which contains `ExperimentalLayout`. So you can try removing the `Pkg.activate` cell, restart, and see if it still works.
"""

# ╔═╡ 5ddc77bd-aa63-41b1-940a-6f32d4a7529b
grid([
	"hello" "world"
	"xoxo"  "fonsi"
])

# ╔═╡ d215146f-6373-4bca-92cc-4eac0a1328e1
myslider = @bind x Slider(1:12)

# ╔═╡ 3dd150ed-07c7-470d-b27c-1986396498c5
data = rand(x)

# ╔═╡ 1c2bdfde-0071-4695-a2f2-6cacf5e69326
text = Text(repeat("pluto ", x))

# ╔═╡ 30204075-5aff-40f0-a9a3-c4160cfa3dc5
grid([
	myslider embed_display(data)
	text text
])

# ╔═╡ 4da43cee-4ed3-4037-a80b-2d20ccf27062
md"""
To learn a bit more about `PlutoUI.ExperimentalLayout`, open [https://github.com/fonsp/PlutoUI.jl/blob/main/src/Layout.jl](https://github.com/fonsp/PlutoUI.jl/blob/main/src/Layout.jl) in pluto
"""

# ╔═╡ Cell order:
# ╠═9cfe245c-26fc-11ec-21cc-1dafc4809eec
# ╟─17301455-1f6b-475a-a51f-950bf8942302
# ╠═08594582-6274-4156-8aa8-742d69bb41e1
# ╠═4430dfa5-949c-48a0-90c5-e16603a43e11
# ╠═eb2a2277-23b3-4872-a91d-ddef1763eaf0
# ╠═fccac888-c0bc-42ad-a07d-0bfa559ecb57
# ╠═5ddc77bd-aa63-41b1-940a-6f32d4a7529b
# ╠═d215146f-6373-4bca-92cc-4eac0a1328e1
# ╠═3dd150ed-07c7-470d-b27c-1986396498c5
# ╠═1c2bdfde-0071-4695-a2f2-6cacf5e69326
# ╠═30204075-5aff-40f0-a9a3-c4160cfa3dc5
# ╟─4da43cee-4ed3-4037-a80b-2d20ccf27062
