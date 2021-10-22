### A Pluto.jl notebook ###
# v0.16.2

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

# ╔═╡ 833969da-caf1-4ab0-9ee8-4b0159566496
begin
    import Pkg
    Pkg.activate(mktempdir())
    Pkg.add(url="https://github.com/Pangoraw/PlutoUI.jl", rev="possible_bind_values")
end

# ╔═╡ da3133c4-332b-11ec-1659-29ae989d67f3
using PlutoUI

# ╔═╡ 3ac888c6-4dc8-4dc2-a418-f91499b20df6
using HypertextLiteral

# ╔═╡ 8399c52d-c00c-456b-8178-c692d2749868
@bind y Slider(6:.1:7)

# ╔═╡ 847d3057-f8f7-4983-a915-aed0ac961bce
@bind x Slider(1:10)

# ╔═╡ a658292c-44ff-4a5e-8571-798e955a2311
@bind cool CheckBox(false)

# ╔═╡ f62f80c8-502c-4ce2-9223-6c2d15d57a80
HTML("""
<div style="width: 200px; height: 200px; background: salmon;">

<div style="width: 1em; height: 1em; background: $(cool ? "darkblue" : "green"); position: absolute; left: $(x * 20)px; top: $(y * 20)px;"></div>

</div>
""")

# ╔═╡ e945bec5-a7db-4014-b9fe-86c471237f6f
(x,y)

# ╔═╡ 1f50941b-7155-4341-900a-b37f90a6fb04
md"---"

# ╔═╡ 9ad17c17-78cf-4977-82a6-27d5f7a01b03
@bind hellooooo Slider(1:100)

# ╔═╡ 0b820f97-fe42-4f97-b001-ab32dc7b50da
"hello $(hellooooo)"

# ╔═╡ 99c4dca6-e670-47be-b006-fa90a000fec8
md"---"

# ╔═╡ Cell order:
# ╠═833969da-caf1-4ab0-9ee8-4b0159566496
# ╠═f62f80c8-502c-4ce2-9223-6c2d15d57a80
# ╠═8399c52d-c00c-456b-8178-c692d2749868
# ╠═847d3057-f8f7-4983-a915-aed0ac961bce
# ╠═a658292c-44ff-4a5e-8571-798e955a2311
# ╠═e945bec5-a7db-4014-b9fe-86c471237f6f
# ╟─1f50941b-7155-4341-900a-b37f90a6fb04
# ╠═9ad17c17-78cf-4977-82a6-27d5f7a01b03
# ╠═0b820f97-fe42-4f97-b001-ab32dc7b50da
# ╟─99c4dca6-e670-47be-b006-fa90a000fec8
# ╠═da3133c4-332b-11ec-1659-29ae989d67f3
# ╠═3ac888c6-4dc8-4dc2-a418-f91499b20df6
