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

# ╔═╡ 6b473b2d-4326-46b4-af38-07b61de287fc
begin
	import Pkg
	Pkg.activate(mktempdir())
	Pkg.add([
			Pkg.PackageSpec(name="Images", version="0.22.4"), 
			Pkg.PackageSpec(name="ImageMagick", version="0.7"), 
			Pkg.PackageSpec(name="PlutoUI", version="0.7"), 
			Pkg.PackageSpec(name="HypertextLiteral", version="0.5")
			])

	using Images
	using PlutoUI
	using HypertextLiteral
end

# ╔═╡ 2e8c4a48-d535-44ac-a1f1-4cb26c4aece6
filter!(LOAD_PATH) do path
	path != "@v#.#"
end;

# ╔═╡ 4fcb4ac1-1ad1-406e-8776-4675c0fdbb43
img = load(download("https://user-images.githubusercontent.com/6933510/108605549-fb28e180-73b4-11eb-8520-7e29db0cc965.png"))

# ╔═╡ 6b558238-6283-4583-9940-6da64000c1c6
function trygetpixel(A::AbstractMatrix, i::Int, j::Int)
	rows, cols = size(A)
	if 1 ≤ i ≤ rows && 1 ≤ j ≤ cols
		A[i,j]
	else
		zero(eltype(img))
	end
end

# ╔═╡ f1076e9a-1310-4896-a57c-ed729015ca10
function trygetpixel(A::AbstractMatrix, i::Real, j::Real)
	trygetpixel(A, floor(Int, i), floor(Int, j))
end

# ╔═╡ 35904b8e-7a28-4dbc-bbf9-b45da448452c
let
	range = -1:.1:2
	md"""
	 $(@bind a11 Scrubbable(range, default=1.0)) $(@bind a12 Scrubbable(range, default=0.0))
	
	 $(@bind a21 Scrubbable(range, default=0.0)) $(@bind a22 Scrubbable(range, default=1.0))
	"""
end

# ╔═╡ f085296d-48b1-4db6-bb87-db863bb54049
A = [
	a11 a12
	a21 a22
	]

# ╔═╡ 772d54a1-46a4-43a7-a40b-3d190208e242
map(CartesianIndices(img)) do I
	new_coord = inv(A) * collect(Tuple(I))
	trygetpixel(img, new_coord...)
end

# ╔═╡ Cell order:
# ╠═6b473b2d-4326-46b4-af38-07b61de287fc
# ╟─2e8c4a48-d535-44ac-a1f1-4cb26c4aece6
# ╠═4fcb4ac1-1ad1-406e-8776-4675c0fdbb43
# ╠═6b558238-6283-4583-9940-6da64000c1c6
# ╠═f1076e9a-1310-4896-a57c-ed729015ca10
# ╠═772d54a1-46a4-43a7-a40b-3d190208e242
# ╟─35904b8e-7a28-4dbc-bbf9-b45da448452c
# ╟─f085296d-48b1-4db6-bb87-db863bb54049
