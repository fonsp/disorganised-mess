### A Pluto.jl notebook ###
# v0.11.8

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

# ╔═╡ 4dea78e4-e603-11ea-395c-a34b645dba9e
using LinearAlgebra

# ╔═╡ 548722e2-e601-11ea-3a1f-770d7456c77c
begin
	import Pkg
	Pkg.activate(mktempdir())
end

# ╔═╡ 8f3a3e06-e601-11ea-201d-23a204daa10f
begin
	# we will work with the package Images.jl, and to display images on the screen,
	# we also need ImageIO and ImageMagick
	Pkg.add(["Images", "ImageIO", "ImageMagick"])
	# we also use PlutoUI for some interactivity
	Pkg.add("PlutoUI")
	
	# now that it is installed, we can import it inside out notebook:
	using Images
	using PlutoUI
end

# ╔═╡ 3d9d9c80-e603-11ea-3845-cf9ee612316f
function svd_compress(i, N)
	📚 = svd(i)
	📚.U[:,1:N] * Diagonal(📚.S[1:N]) * 📚.Vt[1:N,:] .|> Gray
end

# ╔═╡ 46a589f4-e604-11ea-345f-397b1b0c4f80
@bind n Slider(1:20)

# ╔═╡ 7f4b0e1e-7f16-11ea-02d3-7955921a70bd
@bind img html"""
<canvas width="200" height="200" style="position: relative; display: block;"></canvas>
<button>Clear</button>

<script>
const canvas = this.querySelector("canvas")
const button = this.querySelector("button")
const ctx = canvas.getContext("2d")

function send_image(){
	// 🐸 We send the value back to Julia 🐸 //
	canvas.value = {
		width: 200,
		height: 200,
		data: ctx.getImageData(0,0,200,200).data,
	}
	canvas.dispatchEvent(new CustomEvent("input"))
}

var prev_pos = [80, 40]

function clear(){
	ctx.fillStyle = '#ffecec'
	ctx.fillRect(0, 0, 200, 200)

	send_image()
}
clear()

function onmove(e){
	const new_pos = [e.layerX, e.layerY]
	ctx.lineTo(...new_pos)
	ctx.stroke()
	prev_pos = new_pos

	send_image()
}

canvas.onmousedown = e => {
	prev_pos = [e.layerX, e.layerY]
	ctx.strokeStyle = '#003d6d'
	ctx.lineWidth = 5
	ctx.beginPath()
	ctx.moveTo(...prev_pos)
	canvas.onmousemove = onmove
}

button.onclick = clear

canvas.onmouseup = e => {
	canvas.onmousemove = null
}

// Fire a fake mousemoveevent to show something
onmove({layerX: 130, layerY: 160})

</script>
"""

# ╔═╡ a5353288-e601-11ea-09cc-5d049ce1bc93
function unwrap_js_image_data(raw_js_image_data)
	# the raw image data is a long byte array, we need to transform it into something
	# more "Julian" - something with more _structure_.
	
	# The encoding of the raw byte stream is:
	# every 4 bytes is a single pixel
	# every pixel has 4 values: Red, Green, Blue, Alpha
	# (we ignore alpha for this notebook)
	
	# So to get the red values for each pixel, we take every 4th value, starting at 
	# the 1st:
	reds_flat = UInt8.(raw_js_image_data["data"][1:4:end])
	greens_flat = UInt8.(raw_js_image_data["data"][2:4:end])
	blues_flat = UInt8.(raw_js_image_data["data"][3:4:end])
	
	# but these are still 1-dimensional arrays, nicknamed 'flat' arrays
	# We will 'reshape' this into 2D arrays:
	
	width = raw_js_image_data["width"]
	height = raw_js_image_data["height"]
	
	# shuffle and flip to get it in the right shape
	reds = reshape(reds_flat, (width, height))' / 255.0
	greens = reshape(greens_flat, (width, height))' / 255.0
	blues = reshape(blues_flat, (width, height))' / 255.0
	
	(reds=reds, greens=greens, blues=blues)
end

# ╔═╡ fb5112f0-e605-11ea-2f00-6d621a6c36a1
function process_raw_js_image_data(raw_js_image_data)
	# we have our 2D array for each color
	# Let's create a single 2D array, where each value contains the R, G and B value of 
	# that pixel
	
	RGB.(unwrap_js_image_data(raw_js_image_data)...)
end

# ╔═╡ 7ff9aa7e-e603-11ea-1955-c7907182b1ec
let
	i = process_raw_js_image_data(img)
	svd_compress(i .|> red, n)
end

# ╔═╡ Cell order:
# ╠═548722e2-e601-11ea-3a1f-770d7456c77c
# ╠═8f3a3e06-e601-11ea-201d-23a204daa10f
# ╠═4dea78e4-e603-11ea-395c-a34b645dba9e
# ╠═3d9d9c80-e603-11ea-3845-cf9ee612316f
# ╠═46a589f4-e604-11ea-345f-397b1b0c4f80
# ╟─7ff9aa7e-e603-11ea-1955-c7907182b1ec
# ╠═7f4b0e1e-7f16-11ea-02d3-7955921a70bd
# ╠═a5353288-e601-11ea-09cc-5d049ce1bc93
# ╠═fb5112f0-e605-11ea-2f00-6d621a6c36a1
