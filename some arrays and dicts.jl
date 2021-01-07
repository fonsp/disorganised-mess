### A Pluto.jl notebook ###
# v0.12.6

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

# ╔═╡ 6e310454-1db7-11eb-2113-85a7ac4bdbab
using PlutoUI

# ╔═╡ 515fd0f2-1ef8-11eb-37ef-b3967cc01b5a
sleep(3)

# ╔═╡ ce65cb8a-1e15-11eb-337a-21da2419cfb3


# ╔═╡ 61432b0a-1dc1-11eb-152e-a94a44ab32c0
@bind N2 Slider(0:0.000000000001:1)

# ╔═╡ aeb47386-1ef6-11eb-0a27-ff5fabc1b454
[1:5..., N2, 70:800...]

# ╔═╡ a0bd8222-1ef6-11eb-24e6-4f50d30fdb59
N = rand()

# ╔═╡ 3705ff06-1e12-11eb-3af8-21d509353c1b
mutable struct A
	x
	y
end

# ╔═╡ 338f80fe-1e12-11eb-0bcf-e7af81013558
begin
	a = A(6,6)
	a.x = [1,a]
	a
end

# ╔═╡ 2af983dc-1eb1-11eb-0114-6b414bbd5665
Dict(i => i for i in 1:100)

# ╔═╡ d21fc9d8-1e15-11eb-08ed-3754e6bd8957
html"""
<script>
const x = html`<img src="https://i.imgur.com/2j12AxI.jpg">`

var i = 0
setInterval(() => {
	x.setAttribute("height", 200 + 200*Math.sin(i / 5))
	i++
}, 500)

return x
</script>
"""

# ╔═╡ 5063ba02-1db7-11eb-17a2-7575705f1726
(1,2)

# ╔═╡ 123eca5c-1db8-11eb-1304-95199c7d3b8a
# map(identity, zip(eachindex(n), n))

# ╔═╡ 0839fd58-1db8-11eb-3e6d-952dcef896d1
n = (a=1, b=2)

# ╔═╡ 238cdee4-1e18-11eb-378b-5defb8a09eea


# ╔═╡ c6a71be6-1db7-11eb-18db-014e1d6e3b55
1 => 2

# ╔═╡ 85e5bce8-1db7-11eb-3560-8b0d4cb2e815
f = download("https://fonsp.com/img/doggoSmall.jpg?raw=true")

# ╔═╡ 4fb86b34-1e16-11eb-132a-97a616455892
f2 = download("https://i.imgur.com/2j12AxI.jpg")

# ╔═╡ 903f06fe-1db7-11eb-2a4b-15aab40de488
i = Show(MIME"image/jpg"(), read(f))

# ╔═╡ 51edb80a-1db7-11eb-1006-45ed937374bc
y = [3,4,i]

# ╔═╡ 69c515cc-1db7-11eb-3487-a5d770362251
d = Dict(1 => 2, i => i, [3,4]=>[5,6])

# ╔═╡ 3e6fac2a-1db7-11eb-021c-b58bf487d702
x = [Ref(1), a, d,y,n,[1,N],60:300...]

# ╔═╡ 219835ae-1eb4-11eb-339f-ddf151b74b51
[x,x]

# ╔═╡ 655b28e2-1eb0-11eb-1de4-8972abe3b129
objectid(x)

# ╔═╡ 458e985a-1e15-11eb-37d1-a9cf4f748771
i

# ╔═╡ 4d85fb88-1e16-11eb-358b-3b2e2c0718c0
i2 = Show(MIME"image/jpg"(), read(f2))

# ╔═╡ Cell order:
# ╠═515fd0f2-1ef8-11eb-37ef-b3967cc01b5a
# ╠═6e310454-1db7-11eb-2113-85a7ac4bdbab
# ╠═ce65cb8a-1e15-11eb-337a-21da2419cfb3
# ╠═51edb80a-1db7-11eb-1006-45ed937374bc
# ╠═61432b0a-1dc1-11eb-152e-a94a44ab32c0
# ╠═aeb47386-1ef6-11eb-0a27-ff5fabc1b454
# ╠═a0bd8222-1ef6-11eb-24e6-4f50d30fdb59
# ╠═3705ff06-1e12-11eb-3af8-21d509353c1b
# ╠═338f80fe-1e12-11eb-0bcf-e7af81013558
# ╠═3e6fac2a-1db7-11eb-021c-b58bf487d702
# ╠═219835ae-1eb4-11eb-339f-ddf151b74b51
# ╠═2af983dc-1eb1-11eb-0114-6b414bbd5665
# ╠═655b28e2-1eb0-11eb-1de4-8972abe3b129
# ╠═d21fc9d8-1e15-11eb-08ed-3754e6bd8957
# ╠═69c515cc-1db7-11eb-3487-a5d770362251
# ╠═5063ba02-1db7-11eb-17a2-7575705f1726
# ╠═123eca5c-1db8-11eb-1304-95199c7d3b8a
# ╠═0839fd58-1db8-11eb-3e6d-952dcef896d1
# ╠═458e985a-1e15-11eb-37d1-a9cf4f748771
# ╠═238cdee4-1e18-11eb-378b-5defb8a09eea
# ╠═c6a71be6-1db7-11eb-18db-014e1d6e3b55
# ╠═85e5bce8-1db7-11eb-3560-8b0d4cb2e815
# ╠═4fb86b34-1e16-11eb-132a-97a616455892
# ╠═903f06fe-1db7-11eb-2a4b-15aab40de488
# ╠═4d85fb88-1e16-11eb-358b-3b2e2c0718c0
