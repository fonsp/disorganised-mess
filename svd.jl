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

# ╔═╡ 06e84756-e4a7-11ea-0c72-351643e66b0f
begin
	import Pkg
	Pkg.activate(mktempdir())
	
	# we will work with the package Images.jl, and to display images on the screen,
	# we also need ImageIO and ImageMagick
	Pkg.add(["Images", "ImageIO", "ImageMagick"])
	
	# now that it is installed, we can import it inside out notebook:
	using Images
end

# ╔═╡ fcac2038-b7aa-11ea-1320-355e0731afb4
using LinearAlgebra

# ╔═╡ d7eadad2-b7ad-11ea-22e3-f1e5ded42255
md"# Singular Value Decomposition

Lorem ipsum SVD est."

# ╔═╡ d6f2ee1c-b7ad-11ea-0e1c-fb21a58c5711
md"## Step 1: upload your favorite image:"

# ╔═╡ 7754f882-e4bf-11ea-0cc3-3b5223f73125


# ╔═╡ 212d10d6-b7ae-11ea-1434-fb7d45aaf278
md"The camera image can be **used as a variable** inside Julia! Let's have a look at its type:"

# ╔═╡ 1cfdfacc-e4bd-11ea-2efb-8707d895025a
md"### Pixels
To get a single _pixel_ from the image, we just need to get a _value_ from the 2D array. This is done with 2D indexing:"

# ╔═╡ 3f06949c-e4bd-11ea-21d1-910dae46d2b6
md"To get its values, we use the functions `red`, `green`, `blue`. These are part of the `Images.jl` package."

# ╔═╡ 90715ff6-b7ae-11ea-3780-1d227049322c
md"You can use `img_data` like any other Julia 2D array! For example, here is the top left corner of your image:"

# ╔═╡ 7c8b8c96-b7ae-11ea-149d-61d29d35847c
md"## Step 2: running the SVD

The Julia standard library package `LinearAlgebra` contains a method to compute the SVD. "

# ╔═╡ 07834ab8-b7ba-11ea-0279-77179671d826
md"Let's look at the result."

# ╔═╡ fe4c70fe-b7b0-11ea-232b-1996facd33a0
md"Let's verify the identity

$A = U \Sigma V^{\intercal}$"

# ╔═╡ 8e7cb972-b7b1-11ea-2c4d-ed583218740a
md"Are they equal?"

# ╔═╡ 4df00b20-b7b1-11ea-0836-41314f8a2d35
md"It looks like they are **not** equal - how come?

Since we are using a _computer_, the decomposition and multiplication both introduce some numerical errors. So instead of checking whether the reconstructed matrix is _equal_ to the original, we can check how _close_ they are to each other."

# ╔═╡ 2199d7b2-b7b2-11ea-2e86-95b23658a538
md"One way to quantify the _distance_ between two matrices is to look at the **point-wise difference**. If the **sum** of all differences is close to 0, the matrices are almost equal."

# ╔═╡ 315955ac-b7b1-11ea-31a1-31a206c2ab72
p1_dist = sum(abs.(img_data_reconstructed - img_data))

# ╔═╡ 489b7c9c-b7b1-11ea-3a54-87bd17341b2c
md"There are other ways to compare two matrices, such methods are called _**matrix norms**_."

# ╔═╡ a6dcc77c-b7b2-11ea-0c7d-d5686603d182
md"### The 👀-norm"

# ╔═╡ b15d683c-b7b2-11ea-1090-b392950bedb6
md"Another popular matrix norm is the **👀_-norm_**: you turn both matrices into a picture, and use your 👀 to see how close they are:"

# ╔═╡ f0e75616-b7b2-11ea-1187-714258b32e84
[BWImage(img_data), BWImage(img_data_reconstructed)]

# ╔═╡ 064d5a78-b7b3-11ea-399c-f968bf9c910a
md"""**How similar are these images?**  $(@bind 👀_dist html"<input>")"""

# ╔═╡ 2c7c8cdc-b7b3-11ea-166c-cfd232fd2004
👀_dist

# ╔═╡ 64e51904-b7b3-11ea-0f72-359d63261b21
md"In some applications, like _**image compression**_, this is the _most imporant norm_."

# ╔═╡ d2de4480-b7b0-11ea-143d-033dc76cf6bc
md"## Step 3: compression"

# ╔═╡ dc229eae-b87a-11ea-33c8-83552d0fc8e3


# ╔═╡ 2fdd76dc-b7ce-11ea-12b1-59aa1c44ebbe
md"### Store fewer bytes"

# ╔═╡ 3bb96bf2-b7cc-11ea-377f-2d5d3f04e96d
#compressed_size(keep), uncompressed_size()

# ╔═╡ 075510e6-b7cc-11ea-1abe-8725d3153c12
function uncompressed_size()
	num_el = length(img_data)
	return num_el * 8 ÷ 8
end

# ╔═╡ 906a267a-b7ca-11ea-1e73-a56b7e7c9115
#BWImage(Float16.(F.U)[:,1:keep] * Diagonal(Float16.(F.S[1:keep])) * Float16.(F.V)'[1:keep,:])

# ╔═╡ 444bc786-b7ce-11ea-0016-ff1fbb17d736
md"JPEG works in a similar way"

# ╔═╡ 1c55bd84-b7c9-11ea-0aa5-b95f58fae242
md"### Individual pairs"

# ╔═╡ 779fc8e6-b7c9-11ea-0d74-4da167b76227
normalize_mat(A, p=2) = A ./ norm(A, p)

# ╔═╡ 7485990a-b7af-11ea-10e4-53a3ab5dcea7
md"## Going further

More stuff to learn about SVD

To keep things simple (and dependency-free), this notebook only works with downscaled black-and-white images that you pick using the button. For **color**, **larger images**, or **images from your disk**, you should look into the [`Images.jl`](https://github.com/JuliaImages/Images.jl) package!"

# ╔═╡ 1b7fedd2-e4bf-11ea-2947-dded12a5ea95
md"# Appendix"

# ╔═╡ 74cac824-b861-11ea-37e9-e97065879618
function camera_input(;maxsize=200, default_url="https://i.imgur.com/VGPeJ6s.jpg")
"""
<span class="pl-image">
<style>

.pl-image video {
	max-width: 250px;
}
.pl-image prompt {
	max-width: 250px;
}

.pl-image video.takepicture {
	animation: pictureflash 200ms linear;
}

@keyframes pictureflash {
	0% {
		filter: grayscale(1.0) contrast(2.0);
	}

	100% {
		filter: grayscale(0.0) contrast(1.0);
	}
}
</style>

<div id="video-container" title="Click to take a picture">
	<video playsinline autoplay></video>
	<div id="prompt">Enable 📸</div>
</div>

<script>
// based on https://github.com/fonsp/printi-static (by the same author)

const span = this.currentScript.parentElement
const video = span.querySelector("video")

const maxsize = $(maxsize)

const send_source = (source, src_width, src_height) => {
	const scale = Math.min(1.0, maxsize / src_width, maxsize / src_height)

	const width = Math.floor(src_width * scale)
	const height = Math.floor(src_height * scale)

	const canvas = html`<canvas width=\${width} height=\${height}>`
	const ctx = canvas.getContext("2d")
	ctx.drawImage(source, 0, 0, width, height)

	span.value = {
		width: width,
		height: height,
		data: ctx.getImageData(0, 0, width, height).data,
	}
	span.dispatchEvent(new CustomEvent("input"))
}


navigator.mediaDevices.getUserMedia({
	audio: false,
	video: {
		facingMode: "environment",
	},
}).then(function(stream) {

	window.stream = stream
	video.srcObject = stream
	window.cameraConnected = true
	video.controls = false
	video.play()
	video.controls = false

}).catch(function(error) {
	console.log(error)
});

span.querySelector("#video-container").onclick = function() {
	const cl = video.classList
	cl.remove("takepicture")
	void video.offsetHeight
	cl.add("takepicture")
	video.play()
	video.controls = false
	console.log(video)
	send_source(video, video.videoWidth, video.videoHeight)
};


const img = html`<img crossOrigin="anonymous">`
	
img.onload = () => {
	send_source(img, img.width, img.height)
}
img.src = "$(default_url)"


</script>
</span>
""" |> HTML
end

# ╔═╡ 54f79f6e-b865-11ea-2f16-ff76fe1f14ed
@bind raw_camera_data camera_input()

# ╔═╡ 07ec56da-e51d-11ea-3e12-496f3c94775b
raw_camera_data

# ╔═╡ 2d36d628-e51c-11ea-12d2-3d5bfcc4a297
camera_input()

# ╔═╡ ef44d20c-e4a8-11ea-0bb5-8fbafddaf2b5
function process_raw_camera_data(raw_camera_data)
	# the raw image data is a long byte array, we need to transform it into something
	# more "Julian" - something with more _structure_.
	
	# The encoding of the raw byte stream is:
	# every 4 bytes is a single pixel
	# every pixel has 4 values: Red, Green, Blue, Alpha
	# (we ignore alpha for this notebook)
	
	# So to get the red values for each pixel, we take every 4th value, starting at 
	# the 1st:
	reds_flat = UInt8.(raw_camera_data["data"][1:4:end])
	greens_flat = UInt8.(raw_camera_data["data"][2:4:end])
	blues_flat = UInt8.(raw_camera_data["data"][3:4:end])
	
	# but these are still 1-dimensional arrays, nicknamed 'flat' arrays
	# We will 'reshape' this into 2D arrays:
	
	width = raw_camera_data["width"]
	height = raw_camera_data["height"]
	
	# shuffle and flip to get it in the right shape
	reds = reshape(reds_flat, (width, height))' / 255.0
	greens = reshape(greens_flat, (width, height))' / 255.0
	blues = reshape(blues_flat, (width, height))' / 255.0
	
	# we have our 2D array for each color
	# Let's create a single 2D array, where each value contains the R, G and B value of 
	# that pixel
	
	RGB.(reds, greens, blues)
end

# ╔═╡ fb667d22-e4be-11ea-073a-65449018db8c
img = process_raw_camera_data(raw_camera_data)

# ╔═╡ 27f61a6e-e4bf-11ea-1130-d3d1ad366536
color .- img

# ╔═╡ 7b3ee492-e4b7-11ea-0637-bf80c9d4c3a9
typeof(img)

# ╔═╡ 0cec122a-e4b8-11ea-3780-a9f681edd329
md"It's a 2D array, and its elements are of the type _$(eltype(img))_"

# ╔═╡ 848d85ee-e4b7-11ea-3e0c-eb232a9883ef
firstpixel = img[1,1]

# ╔═╡ 8e7c030c-e4b7-11ea-3429-312395080f75
typeof(firstpixel)

# ╔═╡ d263df02-e4b7-11ea-3280-6de622af30d3
red(firstpixel), green(firstpixel), blue(firstpixel)

# ╔═╡ 87d77024-e4bd-11ea-3ceb-d3b8dcc7564b
red.(img)

# ╔═╡ b8f3fa2e-b7ae-11ea-1089-3d08cd1e7874
topleft = let
	# the first coordinate is vertical, the second is horizontal (it's a matrix!)
	half_height = size(img)[1] ÷ 2
	half_width = size(img)[2] ÷ 2
	
	img[1:half_height, 1:half_width]
end

# ╔═╡ 8e009aea-e4aa-11ea-03eb-bd3a7533d818
bw = Gray.(img)

# ╔═╡ a404b9f8-b7ab-11ea-0b07-a733a3c4f353
📚 = svd(bw);

# ╔═╡ a8039914-b7ce-11ea-25fe-03f554383d31
📚

# ╔═╡ dbfa7a96-b7b0-11ea-2737-c7bfd486db3c
bw_reconstructed = 📚.U * Diagonal(📚.S) * 📚.V'

# ╔═╡ 1e866730-b7ac-11ea-3df1-9f7f92d504db
@bind keep HTML("<input type='range' max='$(length(📚.S))' value='10'>")

# ╔═╡ 9b18067e-b7b3-11ea-0372-d351201a0e7d
md"Showing the **first $(keep) singular pairs**."

# ╔═╡ 04c34a64-b7ac-11ea-0cc0-6709153eaf18
Gray.(
	📚.U[:,1:keep] * 
	Diagonal(📚.S[1:keep]) * 
	📚.V'[1:keep,:]
)

# ╔═╡ 3909738e-b7d1-11ea-0e12-955a86967870
[Gray.(
	📚.U[:,1:keep] * 
	Diagonal(📚.S[1:keep]) * 
	📚.V'[1:keep,:]
) for keep in 0:20]

# ╔═╡ db5c4ad6-b7cb-11ea-096f-a35ef7bc2c7c
function compressed_size(keep)
	num_el = (
		length(📚.U[:,1:keep]) + 
		length(📚.S[1:keep]) + 
		length(📚.V'[1:keep,:])
	)
	return num_el * 16 ÷ 8
end

# ╔═╡ 27a61bb6-b7c9-11ea-0122-09850dc4322c
@bind pair_index HTML("<input type='range' min='1' max='$(length(📚.S))' value='10'>")

# ╔═╡ 379d608c-b7c9-11ea-1ae2-89a2713a91ff
Gray.(normalize_mat((
		📚.U[:,pair_index:pair_index] * 
		Diagonal(📚.S[pair_index:pair_index]) * 
		📚.V'[pair_index:pair_index,:]
	), Inf))

# ╔═╡ 917b7e88-b7b1-11ea-1d05-ef95e73ff181
bw == bw_reconstructed

# ╔═╡ Cell order:
# ╠═06e84756-e4a7-11ea-0c72-351643e66b0f
# ╟─d7eadad2-b7ad-11ea-22e3-f1e5ded42255
# ╟─d6f2ee1c-b7ad-11ea-0e1c-fb21a58c5711
# ╠═54f79f6e-b865-11ea-2f16-ff76fe1f14ed
# ╠═07ec56da-e51d-11ea-3e12-496f3c94775b
# ╠═fb667d22-e4be-11ea-073a-65449018db8c
# ╠═7754f882-e4bf-11ea-0cc3-3b5223f73125
# ╠═27f61a6e-e4bf-11ea-1130-d3d1ad366536
# ╟─212d10d6-b7ae-11ea-1434-fb7d45aaf278
# ╠═7b3ee492-e4b7-11ea-0637-bf80c9d4c3a9
# ╟─0cec122a-e4b8-11ea-3780-a9f681edd329
# ╟─1cfdfacc-e4bd-11ea-2efb-8707d895025a
# ╠═848d85ee-e4b7-11ea-3e0c-eb232a9883ef
# ╠═8e7c030c-e4b7-11ea-3429-312395080f75
# ╟─3f06949c-e4bd-11ea-21d1-910dae46d2b6
# ╠═d263df02-e4b7-11ea-3280-6de622af30d3
# ╠═87d77024-e4bd-11ea-3ceb-d3b8dcc7564b
# ╟─90715ff6-b7ae-11ea-3780-1d227049322c
# ╠═b8f3fa2e-b7ae-11ea-1089-3d08cd1e7874
# ╟─7c8b8c96-b7ae-11ea-149d-61d29d35847c
# ╠═fcac2038-b7aa-11ea-1320-355e0731afb4
# ╠═8e009aea-e4aa-11ea-03eb-bd3a7533d818
# ╠═a404b9f8-b7ab-11ea-0b07-a733a3c4f353
# ╟─07834ab8-b7ba-11ea-0279-77179671d826
# ╠═a8039914-b7ce-11ea-25fe-03f554383d31
# ╟─fe4c70fe-b7b0-11ea-232b-1996facd33a0
# ╠═dbfa7a96-b7b0-11ea-2737-c7bfd486db3c
# ╟─8e7cb972-b7b1-11ea-2c4d-ed583218740a
# ╠═917b7e88-b7b1-11ea-1d05-ef95e73ff181
# ╟─4df00b20-b7b1-11ea-0836-41314f8a2d35
# ╟─2199d7b2-b7b2-11ea-2e86-95b23658a538
# ╠═315955ac-b7b1-11ea-31a1-31a206c2ab72
# ╟─489b7c9c-b7b1-11ea-3a54-87bd17341b2c
# ╟─a6dcc77c-b7b2-11ea-0c7d-d5686603d182
# ╟─b15d683c-b7b2-11ea-1090-b392950bedb6
# ╠═f0e75616-b7b2-11ea-1187-714258b32e84
# ╟─064d5a78-b7b3-11ea-399c-f968bf9c910a
# ╠═2c7c8cdc-b7b3-11ea-166c-cfd232fd2004
# ╟─64e51904-b7b3-11ea-0f72-359d63261b21
# ╟─d2de4480-b7b0-11ea-143d-033dc76cf6bc
# ╟─1e866730-b7ac-11ea-3df1-9f7f92d504db
# ╟─9b18067e-b7b3-11ea-0372-d351201a0e7d
# ╠═04c34a64-b7ac-11ea-0cc0-6709153eaf18
# ╠═3909738e-b7d1-11ea-0e12-955a86967870
# ╠═dc229eae-b87a-11ea-33c8-83552d0fc8e3
# ╟─2fdd76dc-b7ce-11ea-12b1-59aa1c44ebbe
# ╠═3bb96bf2-b7cc-11ea-377f-2d5d3f04e96d
# ╠═075510e6-b7cc-11ea-1abe-8725d3153c12
# ╠═db5c4ad6-b7cb-11ea-096f-a35ef7bc2c7c
# ╠═906a267a-b7ca-11ea-1e73-a56b7e7c9115
# ╟─444bc786-b7ce-11ea-0016-ff1fbb17d736
# ╟─1c55bd84-b7c9-11ea-0aa5-b95f58fae242
# ╟─27a61bb6-b7c9-11ea-0122-09850dc4322c
# ╠═379d608c-b7c9-11ea-1ae2-89a2713a91ff
# ╠═779fc8e6-b7c9-11ea-0d74-4da167b76227
# ╟─7485990a-b7af-11ea-10e4-53a3ab5dcea7
# ╟─1b7fedd2-e4bf-11ea-2947-dded12a5ea95
# ╠═2d36d628-e51c-11ea-12d2-3d5bfcc4a297
# ╠═74cac824-b861-11ea-37e9-e97065879618
# ╠═ef44d20c-e4a8-11ea-0bb5-8fbafddaf2b5
