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

# ╔═╡ b6c99ba0-7121-11eb-0691-03ed4ba97743
begin
	# import Pkg
	# Pkg.activate(mktempdir())
	# Pkg.add(url="https://github.com/fonsp/Luxor.jl", rev="patch-1")
	using Luxor
end

# ╔═╡ b260cd04-a638-46ca-8d94-ca1fb5c162c9
using PlutoUI

# ╔═╡ 80103288-0caf-4162-91a0-839d33e5bef8
image_url = "https://user-images.githubusercontent.com/6933510/108211981-a9baf100-712d-11eb-8719-3e0819daac0e.png"

# ╔═╡ 90fec6ba-57e1-4389-aa9d-2b32564bcae1
image_filename = download(image_url)

# ╔═╡ a0e7ce75-249e-4e66-afd7-f2e52b27024f
img = readpng(image_filename)

# ╔═╡ 6a042383-3713-46af-add4-ed323e10be02
width = Int(img.width)

# ╔═╡ 9264dbbd-a992-4221-8b20-f3306c012a7c
height = Int(img.height)

# ╔═╡ 9a297aa8-7a47-4181-bcdc-998746ff37d8
md"""
## Manual animation
"""

# ╔═╡ 6c02c813-da9a-4fe8-bcec-280383ab7f6e
@bind y Slider(1:height)

# ╔═╡ 62557ef1-fec1-4b12-944a-01a2c705f670
@png begin
	placeimage(img, 0, y; centered=true)
	placeimage(img, 0, y - height; centered=true)
end width height

# ╔═╡ 6306c71d-2307-484d-9a71-6f8d0d095cad
md"""
## GIF
"""

# ╔═╡ 125abbc2-4e69-493d-820c-e4067c5ae641
speed = -2

# ╔═╡ 214a2a22-446f-445d-b92d-2d4a9b50904a
function frame(scene, y)
	y = speed * y
	placeimage(img, 0, y; centered=true)
	placeimage(img, 0, y - sign(speed) * height; centered=true)
end

# ╔═╡ 15db47da-7918-41fa-a460-fd62d8d792e7
begin
	anim = Movie(width, height, "asdf")
	
	
	
	animate(anim, [
			Scene(anim, frame, 1:height ÷ abs(speed))
			],
		creategif=true
		)
end

# ╔═╡ Cell order:
# ╠═b6c99ba0-7121-11eb-0691-03ed4ba97743
# ╠═90fec6ba-57e1-4389-aa9d-2b32564bcae1
# ╠═80103288-0caf-4162-91a0-839d33e5bef8
# ╠═a0e7ce75-249e-4e66-afd7-f2e52b27024f
# ╠═6a042383-3713-46af-add4-ed323e10be02
# ╠═9264dbbd-a992-4221-8b20-f3306c012a7c
# ╠═b260cd04-a638-46ca-8d94-ca1fb5c162c9
# ╟─9a297aa8-7a47-4181-bcdc-998746ff37d8
# ╠═6c02c813-da9a-4fe8-bcec-280383ab7f6e
# ╠═62557ef1-fec1-4b12-944a-01a2c705f670
# ╟─6306c71d-2307-484d-9a71-6f8d0d095cad
# ╠═125abbc2-4e69-493d-820c-e4067c5ae641
# ╠═214a2a22-446f-445d-b92d-2d4a9b50904a
# ╠═15db47da-7918-41fa-a460-fd62d8d792e7
