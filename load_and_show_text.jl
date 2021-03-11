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

# ╔═╡ 59025ce6-7234-11eb-0e39-a17942f02312
using PlutoUI

# ╔═╡ 68db6117-e20a-4a56-80c7-c54c2b2b9079
@bind file FilePicker()

# ╔═╡ 512a40bc-9627-470a-a48c-2ce7d5fad52e
file_tekst = String(file["data"])

# ╔═╡ 6c87329c-6676-4db1-90b0-fea24229a3d2
md"""
### Alleen de tekst laten zien
"""

# ╔═╡ 93b29a67-9e36-48bf-bc63-6bfed0a7014e
Text(file_tekst)

# ╔═╡ 1f71857a-cc59-44be-bc20-d6f308594ebf
md"""
### In een `textarea`
"""

# ╔═╡ b7245655-1e6a-4ed1-8356-fd5f3e696a10
TextField((80,30); default=file_tekst)

# ╔═╡ Cell order:
# ╠═59025ce6-7234-11eb-0e39-a17942f02312
# ╠═68db6117-e20a-4a56-80c7-c54c2b2b9079
# ╠═512a40bc-9627-470a-a48c-2ce7d5fad52e
# ╟─6c87329c-6676-4db1-90b0-fea24229a3d2
# ╠═93b29a67-9e36-48bf-bc63-6bfed0a7014e
# ╟─1f71857a-cc59-44be-bc20-d6f308594ebf
# ╠═b7245655-1e6a-4ed1-8356-fd5f3e696a10
