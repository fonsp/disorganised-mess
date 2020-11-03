### A Pluto.jl notebook ###
# v0.12.6

using Markdown
using InteractiveUtils

# ╔═╡ 6e310454-1db7-11eb-2113-85a7ac4bdbab
using PlutoUI

# ╔═╡ 5063ba02-1db7-11eb-17a2-7575705f1726
(1,2)

# ╔═╡ 0839fd58-1db8-11eb-3e6d-952dcef896d1
n = (a=1, b=2)

# ╔═╡ 123eca5c-1db8-11eb-1304-95199c7d3b8a
pairs(n)

# ╔═╡ c6a71be6-1db7-11eb-18db-014e1d6e3b55
1 => 2

# ╔═╡ 85e5bce8-1db7-11eb-3560-8b0d4cb2e815
f = download("https://fonsp.com/img/doggoSmall.jpg?raw=true")

# ╔═╡ 903f06fe-1db7-11eb-2a4b-15aab40de488
i = Show(MIME"image/jpg"(), read(f))

# ╔═╡ 51edb80a-1db7-11eb-1006-45ed937374bc
y = [3,4,i]

# ╔═╡ 69c515cc-1db7-11eb-3487-a5d770362251
d = Dict(1 => 2, i => i, [3,4]=>[5,6])

# ╔═╡ 3e6fac2a-1db7-11eb-021c-b58bf487d702
x = [1,d,y,n,60:160...]

# ╔═╡ Cell order:
# ╠═6e310454-1db7-11eb-2113-85a7ac4bdbab
# ╠═51edb80a-1db7-11eb-1006-45ed937374bc
# ╠═3e6fac2a-1db7-11eb-021c-b58bf487d702
# ╠═69c515cc-1db7-11eb-3487-a5d770362251
# ╠═5063ba02-1db7-11eb-17a2-7575705f1726
# ╠═123eca5c-1db8-11eb-1304-95199c7d3b8a
# ╠═0839fd58-1db8-11eb-3e6d-952dcef896d1
# ╠═c6a71be6-1db7-11eb-18db-014e1d6e3b55
# ╠═85e5bce8-1db7-11eb-3560-8b0d4cb2e815
# ╠═903f06fe-1db7-11eb-2a4b-15aab40de488
