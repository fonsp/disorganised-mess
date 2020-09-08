### A Pluto.jl notebook ###
# v0.11.12

using Markdown
using InteractiveUtils

# ╔═╡ 7836c27a-f136-11ea-3599-c75d159ba2be
e = quote
	function f(x)
		x + y
	end
end

# ╔═╡ 86f68e3a-f136-11ea-0f66-6d35328b58a4
sprint() do io
	dump(io, e)
end |> Text

# ╔═╡ 7bc25e22-f136-11ea-369b-5dc36a57d2a2


# ╔═╡ e9078d86-f131-11ea-2fb5-275dab3b0323
begin
	import Pkg
	Pkg.activate(mktempdir())
end

# ╔═╡ f0029054-f131-11ea-2510-0f81ba3abaa0
begin
	Pkg.add(["Images", "ImageIO", "ImageMagick"])
	using Images
end

# ╔═╡ fc852b52-f131-11ea-1caf-17c0da3dca45
begin
	
	struct Animation
		slides
		fps::Number
	end
	Animation(slides; fps=10) = Animation(slides, fps)
	
	
	function Base.show(io::IO, ::MIME"text/html", animation::Animation)
		# This code is UGLY and it does some NASTY tricks and please don't take inspiration from it - it will not work in a couple of months stop reading this please
		# xoxo fonsi

		id = String(rand('a':'z', 10))
		Markdown.withtag(io, :div, :class=>"plutoui_slideshow", :id=>id) do
			for slide in animation.slides
				Markdown.withtag(io, :div, :class=>"plutoui_slide") do
					PlutoRunner.show_richest(io, slide, onlyhtml=true)
				end
			end
		end
		print(io, """
			<script>
			const slideshow = document.querySelector("#$(id)")
			const slides = Array.from(slideshow.children)
			
			slideshow.style.height = Math.max(...slides.map(s => s.scrollHeight)) + "px"
			var i = 0
			var handler = 0
			handler = setInterval(() => {
				if(!document.body.contains(slideshow)) {
					clearInterval(handler)
				}
				slides.forEach(s => s.style.display = "none")
				slides[i % slides.length].style.display = ""
				i++
			}, $(1000.0 / animation.fps))
			</script>
			
			""")
	end
end

# ╔═╡ a5a1053c-f158-11ea-1597-c7d15683f012
Animation([
	"$i is smaller than $j"
	for i in 1:10
	for j in 10:20
])

# ╔═╡ 7978fe4c-f158-11ea-19a0-491ee867c54f
@animate for i in 1:10
	for j in 10:20
		"$i is smaller than $j"
	end
end

# ╔═╡ 0ef8106a-f132-11ea-178a-19b0d521cf59
cool = [md"# Hello", md"# World", 
	html"how",
	html"<br>are",
	html"<br><br>you",
	html"<br><br><br>doing?",
	Gray.(fill(0.0, (100,100))),
	[Gray.(fill(0.1 * i, (100i,100i))) for i in 1:5]...
	]

# ╔═╡ 2832d92e-f133-11ea-1f04-d51d3cf072b1
Animation(cool; fps=5)

# ╔═╡ 1c337c36-f134-11ea-3063-71f3c442e041
load(download("https://fonsp.com/img/doggoSmall.jpg?raw=true"))

# ╔═╡ d2c77070-f133-11ea-1141-ede5ff754fe2
let
	x = RGB.(Gray.(fill(0.2, (200,200))))
	x[10,10] = RGB(1.0, 1.0, 1.0)
	x
end

# ╔═╡ Cell order:
# ╠═7836c27a-f136-11ea-3599-c75d159ba2be
# ╠═86f68e3a-f136-11ea-0f66-6d35328b58a4
# ╠═7bc25e22-f136-11ea-369b-5dc36a57d2a2
# ╠═e9078d86-f131-11ea-2fb5-275dab3b0323
# ╠═f0029054-f131-11ea-2510-0f81ba3abaa0
# ╠═fc852b52-f131-11ea-1caf-17c0da3dca45
# ╠═a5a1053c-f158-11ea-1597-c7d15683f012
# ╠═7978fe4c-f158-11ea-19a0-491ee867c54f
# ╠═2832d92e-f133-11ea-1f04-d51d3cf072b1
# ╠═0ef8106a-f132-11ea-178a-19b0d521cf59
# ╠═1c337c36-f134-11ea-3063-71f3c442e041
# ╠═d2c77070-f133-11ea-1141-ede5ff754fe2
