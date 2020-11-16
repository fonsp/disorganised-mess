### A Pluto.jl notebook ###
# v0.12.8

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

# ╔═╡ da2116b4-2284-11eb-1f88-2b2b461ceb90
using Tables

# ╔═╡ 71697846-1fb4-11eb-053e-b73ac96850cd
using DataFrames

# ╔═╡ 0f567b92-1fb7-11eb-1313-8dd2bd83d24c
using PlutoUI

# ╔═╡ a5557e78-22bd-11eb-182b-779dcd7502e4
rar = @view DataFrame(rand(100,3))[2:2]

# ╔═╡ f0942208-22be-11eb-2832-1530b937cf60
rr = Tables.rows(rar)

# ╔═╡ 245823fa-22bf-11eb-191a-998b7bd8e0d8
@view rr[1:20]

# ╔═╡ a050d25e-1fc7-11eb-0d78-9d401cc8ecc8
sl = @bind x html"<input type=range>"

# ╔═╡ 37fc1398-1fc8-11eb-28dd-87ffa3e555a8
DataFrame(:a => [html"<input type=range>"])

# ╔═╡ 0dc69172-1fc6-11eb-20dc-41f51dbb7198
md"""
# New ✨
"""

# ╔═╡ 143603bc-1fc6-11eb-2770-0fdf336cefbd
md"""
# DataFrames.jl default
"""

# ╔═╡ d2bbe5fe-228c-11eb-2979-71c7b9451c7b
[1:100...]

# ╔═╡ 32f6d7ee-2292-11eb-189e-0d33c947f82a
ra = rand(UInt)

# ╔═╡ d1cdbe98-2281-11eb-0e9f-b3c1c09d8d94
[
	let
		a = x
		a
	end
	for x in 1:10
]

# ╔═╡ f9b7ee58-2400-11eb-3e62-4765aaaf7d50
rand(200,200)

# ╔═╡ 98253b72-1fce-11eb-1216-97e38583501d
d200 = DataFrame(rand(200,200))

# ╔═╡ 07c699ae-2285-11eb-222b-8fb3db91b21e
d200

# ╔═╡ 8d91acd8-1fdb-11eb-326a-376d2c5bdd70
collect(1:100)

# ╔═╡ cf254188-1fd0-11eb-37d9-c1ead57db23a
123

# ╔═╡ 903a4310-1fb4-11eb-0a5b-5fca37c324c1
struct Wow
	x
end

# ╔═╡ 7bdf2f0c-1fb7-11eb-2b4f-539bb59a1782
rand(['a':'z'..., '\n'], 1000) |> String |> Text

# ╔═╡ 979aa9b0-1fbc-11eb-0c9a-fb7d75463c80
collect(1:50)

# ╔═╡ c415ab82-1fb9-11eb-2358-91e1ee287f77
img = md"![](https://fonsp.com/img/doggoSmall.jpg?raw=true)"

# ╔═╡ 9d41474c-1fc7-11eb-06ae-15831e77fafe
begin
	sleep(.2)
	@info "" x
	if !@isdefined(y)
		y = 20
	end
	DataFrame(
		"❤" => [sl, (@bind y Slider(1:100, default=y)), 3], 
		"🙊" => Wow.([6,x,y]), 
		"Hondjes enzo" => [md"**Wow** dit is echt heel erg veel tekst dit gaat _sowieso_ niet passen in een klein celletje", [img, img], rand(50)]
	)
end

# ╔═╡ 86d2be04-1fb4-11eb-0394-aff72c109f2d
d1 = DataFrame(
	# "❤" => [1, 2, 3], 
	"🙊" => Wow.(6:8), 
	"Hondjes enzo" => [md"**Wow** dit is echt heel erg veel tekst dit gaat _sowieso_ niet passen in een klein celletje", [img, img], rand(50)],
	"Cool plots" => plot.([sin, cos, tan]; size=(200,100))
)

# ╔═╡ 19d47f5a-1fc7-11eb-3829-2d9b512690da
d2 = DataFrame(
	"❤" => [rand('a':'z', 10) |> String for _ in 1:3], 
	"🙊" => Wow.(6:8), 
	"Hondjes enzo" => [md"**Wow** dit is echt heel erg veel tekst dit gaat _sowieso_ niet passen in een klein celletje", [img, img], rand(50)]
)

# ╔═╡ 880bf2e2-1fc1-11eb-0787-2fda069b81d0
dbig = let
	dwide = hcat(d2, d2, d2, d2, makeunique=true)
	vcat(dwide, dwide, dwide, dwide, dwide, dwide, dwide, dwide, dwide, dwide, dwide, dwide)
end

# ╔═╡ dc3ffb9c-2284-11eb-1e7b-5b04e4e95b5e
objectid(Tables.columns(dbig))

# ╔═╡ 016ffc0a-1fb8-11eb-2d6b-056c2da7d427
d3 = DataFrame(:a => 1:1000)

# ╔═╡ b60da076-2293-11eb-1d48-45f5ec99b0ca
convert(Int64, UInt16(123))

# ╔═╡ c6d7db6a-2293-11eb-23e6-b982c992e486
asdf(x::Int64) = x

# ╔═╡ cb6ffec8-2293-11eb-1bb1-a5ea012fb74a
asdf(UInt16(123))

# ╔═╡ 4d267b74-1fb8-11eb-30a4-1dc7ad25f33f
default_iocontext = IOContext(devnull, :color => false, :limit => true, :displaysize => (18, 88))

# ╔═╡ 11e8a2ea-1fb7-11eb-2c30-bb886f8725d2
old(x) = HTML(repr(MIME"text/html"(), x; context=default_iocontext))

# ╔═╡ 11a61136-1fb8-11eb-1a02-0b9d7651e876
old(dbig)

# ╔═╡ 1e165c64-1fb8-11eb-17cd-0f93602efc3c
old(d2)

# ╔═╡ 94fabb8c-1fb7-11eb-3b18-6b32f209810b
replace(repr(MIME"text/html"(), d1), "><"=>">\n<") |> Text

# ╔═╡ 052e4444-1fc4-11eb-2bdc-6def590dfe5d
DataFrame()

# ╔═╡ 37fd775e-22bd-11eb-3115-b969364db3e4
DataFrame(rand(20,2000))

# ╔═╡ bafe4134-2401-11eb-31aa-3b18140682ef
DataFrame(rand(1:9,2002,200))

# ╔═╡ 3c4a1f92-22bd-11eb-1d59-5b709e450c82
DataFrame(rand(2000,20))

# ╔═╡ 0d0e93a4-2400-11eb-2d0f-1311057e617f
collect(1:200)

# ╔═╡ Cell order:
# ╠═a5557e78-22bd-11eb-182b-779dcd7502e4
# ╠═f0942208-22be-11eb-2832-1530b937cf60
# ╠═245823fa-22bf-11eb-191a-998b7bd8e0d8
# ╠═a050d25e-1fc7-11eb-0d78-9d401cc8ecc8
# ╠═37fc1398-1fc8-11eb-28dd-87ffa3e555a8
# ╠═9d41474c-1fc7-11eb-06ae-15831e77fafe
# ╟─0dc69172-1fc6-11eb-20dc-41f51dbb7198
# ╠═86d2be04-1fb4-11eb-0394-aff72c109f2d
# ╠═19d47f5a-1fc7-11eb-3829-2d9b512690da
# ╟─143603bc-1fc6-11eb-2770-0fdf336cefbd
# ╠═11a61136-1fb8-11eb-1a02-0b9d7651e876
# ╠═880bf2e2-1fc1-11eb-0787-2fda069b81d0
# ╠═d2bbe5fe-228c-11eb-2979-71c7b9451c7b
# ╠═32f6d7ee-2292-11eb-189e-0d33c947f82a
# ╠═d1cdbe98-2281-11eb-0e9f-b3c1c09d8d94
# ╠═f9b7ee58-2400-11eb-3e62-4765aaaf7d50
# ╠═98253b72-1fce-11eb-1216-97e38583501d
# ╠═07c699ae-2285-11eb-222b-8fb3db91b21e
# ╠═da2116b4-2284-11eb-1f88-2b2b461ceb90
# ╠═dc3ffb9c-2284-11eb-1e7b-5b04e4e95b5e
# ╠═8d91acd8-1fdb-11eb-326a-376d2c5bdd70
# ╠═71697846-1fb4-11eb-053e-b73ac96850cd
# ╠═cf254188-1fd0-11eb-37d9-c1ead57db23a
# ╠═903a4310-1fb4-11eb-0a5b-5fca37c324c1
# ╠═7bdf2f0c-1fb7-11eb-2b4f-539bb59a1782
# ╠═979aa9b0-1fbc-11eb-0c9a-fb7d75463c80
# ╠═c415ab82-1fb9-11eb-2358-91e1ee287f77
# ╠═0f567b92-1fb7-11eb-1313-8dd2bd83d24c
# ╠═016ffc0a-1fb8-11eb-2d6b-056c2da7d427
# ╠═b60da076-2293-11eb-1d48-45f5ec99b0ca
# ╠═c6d7db6a-2293-11eb-23e6-b982c992e486
# ╠═cb6ffec8-2293-11eb-1bb1-a5ea012fb74a
# ╠═1e165c64-1fb8-11eb-17cd-0f93602efc3c
# ╠═4d267b74-1fb8-11eb-30a4-1dc7ad25f33f
# ╠═11e8a2ea-1fb7-11eb-2c30-bb886f8725d2
# ╠═94fabb8c-1fb7-11eb-3b18-6b32f209810b
# ╠═052e4444-1fc4-11eb-2bdc-6def590dfe5d
# ╠═37fd775e-22bd-11eb-3115-b969364db3e4
# ╠═bafe4134-2401-11eb-31aa-3b18140682ef
# ╠═3c4a1f92-22bd-11eb-1d59-5b709e450c82
# ╠═0d0e93a4-2400-11eb-2d0f-1311057e617f
