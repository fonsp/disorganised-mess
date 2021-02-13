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

# ╔═╡ 65780f00-ed6b-11ea-1ecf-8b35523a7ac0
begin
	import Pkg
	Pkg.activate(mktempdir())
	Pkg.add([
			Pkg.PackageSpec(name="Images", version="0.23"), 
			Pkg.PackageSpec(name="ImageMagick", version="1"), 
			Pkg.PackageSpec(name="PlutoUI", version="0.7"), 
			Pkg.PackageSpec(name="HypertextLiteral", version="0.5")
			])

	using Images
	using PlutoUI
	using HypertextLiteral
end

# ╔═╡ bed7a97f-a1dd-4b73-bb8f-fe383d4212d0
md"""
### Click somewhere on the image
"""

# ╔═╡ 74962dcb-5a1a-4f1e-93b3-0116a8ee525b
md"""
The bound variable is the click position, as fractional coordinate $(x,y) \in [0,1]^2$.
"""

# ╔═╡ 3a04da17-3309-4433-bf44-9f7674cbcc2e
md"""
We can use the dimensions of the image to turn that into integer indices:
"""

# ╔═╡ 7f8dd466-5f4c-47c3-8916-fe0d25176365
md"""
### Tracker code
"""

# ╔═╡ b0118a62-9dce-4cd6-abd3-79024be30adc
begin
	import Base64
	
	clicktracker_js(id, r) = """
	const container = document.querySelector("#$(id)")
	const graph = container.firstElementChild
	
	graph.addEventListener("dragstart", (e) => e.preventDefault())
	
	const setvalue = (e) => {
	    const svgrect = graph.getBoundingClientRect()
	    const f = [
			(e.clientX - svgrect.left) / svgrect.width, 
			(e.clientY - svgrect.top) / svgrect.height
		]
		container.value = [
			f[0] * $(r.x_scale) + $(r.x_offset),
			f[1] * $(r.y_scale) + $(r.y_offset),
		]
		container.dispatchEvent(new CustomEvent("input"), {})
		e.cancelDefault()
		e.stopPropagation()
	}
	
	
	graph.addEventListener("click", setvalue)
	
	const start_listening = () => {
		graph.addEventListener("pointermove", setvalue)
	}
	const stop_listening = () => {
		graph.removeEventListener("pointermove", setvalue)
	}
	
	graph.addEventListener("pointerdown", start_listening)
	window.addEventListener("pointerup", stop_listening)

	
	invalidation.then(() => {
	stop_listening()
	graph.removeEventListener("pointerdown", start_listening)
	window.removeEventListener("pointerup", stop_listening)
	
	})
	"""
	
	clicktracker(p::AbstractMatrix{<:AbstractRGB}) = let
		id = String(rand(('a':'z') ∪ ('A':'Z'), 12))
		
		mime = MIME"image/png"()
		
		src = join([
			"data:", 
			string(mime),
			";base64,", 
			Base64.base64encode(io -> show(io, mime, p))
		])
		
		img_render = repr(MIME"text/html"(), PlutoUI.Resource(src, mime, ()))
		
		
		
		# with this information, we can form the linear transformation from 
		# screen coordinate -> plot coordinate
		
		# this is done on the JS side, to avoid one step in the Julia side
		# we send the linear coefficients:
		r = (
		x_offset = 0,
		x_scale = 1,# size(p)[2],
		y_offset = 0,
		y_scale = 1,# size(p)[1],
		)
		HTML("""<div id=$(id)>$(img_render)<script>$(clicktracker_js(id, r))</script></div>""")
	end
end

# ╔═╡ 7f180801-cae7-4542-99d7-aaa4bc0f8c79
md"""
### Appendix
"""

# ╔═╡ 59414833-a108-4b1e-9a34-0f31dc907c6e
url = "https://user-images.githubusercontent.com/6933510/107239146-dcc3fd00-6a28-11eb-8c7b-41aaf6618935.png" 

# ╔═╡ c5484572-ee05-11ea-0424-f37295c3072d
philip_filename = download(url) # download to a local file. The filename is returned

# ╔═╡ c8ecfe5c-ee05-11ea-322b-4b2714898831
philip = load(philip_filename);

# ╔═╡ ec609166-5a8b-4337-ae10-5991766e3f31
philip_head = philip[400:800,100:400];

# ╔═╡ ba6e438d-311c-4768-85a7-b263f8941902
@bind click_coord_fractional clicktracker(philip_head)

# ╔═╡ 8c28acd5-22fd-4429-94e7-f7e6cd30ffe4
click_coord_fractional

# ╔═╡ 873d6134-9f27-49dd-be0d-7a5afc1837c7
click_pos = let
	if click_coord_fractional === missing
		(5,5)
	else
		x, y = click_coord_fractional

		to_index(x, dim) = let
			s = size(philip_head)[dim]
			clamp(ceil(Int, x * s), 1, s)
		end

		to_index(y, 1), to_index(x, 2)
	end
end

# ╔═╡ 0a3f7327-07c4-4902-83e6-becd481a767a
sample_1x1 = philip_head[click_pos[1], click_pos[2]]

# ╔═╡ 9235f0fe-3986-44a0-a952-486011df12f7
sample_7x7 = let
	row, col = click_pos
	philip_head[row-3:row+3, col-3:col+3]
end

# ╔═╡ Cell order:
# ╟─bed7a97f-a1dd-4b73-bb8f-fe383d4212d0
# ╠═ba6e438d-311c-4768-85a7-b263f8941902
# ╟─74962dcb-5a1a-4f1e-93b3-0116a8ee525b
# ╠═8c28acd5-22fd-4429-94e7-f7e6cd30ffe4
# ╟─3a04da17-3309-4433-bf44-9f7674cbcc2e
# ╠═873d6134-9f27-49dd-be0d-7a5afc1837c7
# ╠═0a3f7327-07c4-4902-83e6-becd481a767a
# ╠═9235f0fe-3986-44a0-a952-486011df12f7
# ╟─7f8dd466-5f4c-47c3-8916-fe0d25176365
# ╟─b0118a62-9dce-4cd6-abd3-79024be30adc
# ╟─7f180801-cae7-4542-99d7-aaa4bc0f8c79
# ╠═65780f00-ed6b-11ea-1ecf-8b35523a7ac0
# ╠═59414833-a108-4b1e-9a34-0f31dc907c6e
# ╠═c5484572-ee05-11ea-0424-f37295c3072d
# ╠═c8ecfe5c-ee05-11ea-322b-4b2714898831
# ╠═ec609166-5a8b-4337-ae10-5991766e3f31
