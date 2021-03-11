### A Pluto.jl notebook ###
# v0.14.0

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

# ╔═╡ c9ae7bcc-78e3-11eb-1aa1-8b6d049db18e
begin
	import Pkg
	Pkg.activate(mktempdir())
	Pkg.add([
			Pkg.PackageSpec(name="PNGFiles", rev="53b7bfe"),
			Pkg.PackageSpec(name="Images"),
			Pkg.PackageSpec(name="ImageIO"),
			Pkg.PackageSpec(name="PlutoUI"),
			])
	empty!(LOAD_PATH)
	push!(LOAD_PATH, "@")
	using Images
	using PlutoUI
end
	

# ╔═╡ 3ce4ef9e-8188-4af6-8547-38b2111054a7
url = "https://user-images.githubusercontent.com/6933510/107239146-dcc3fd00-6a28-11eb-8c7b-41aaf6618935.png" 

# ╔═╡ c57c2cca-dc3c-4053-b3cb-1c58e5c4b26d
philip = load(download(url))

# ╔═╡ 2c061184-b7b0-4dd3-9cd7-a96925a79106
let
	b = @bind x let
	L = size(philip)[1]
	Slider(
		1:L, 
		default=L ÷ 2
	)
	end
	md"Column: $(b)"
end

# ╔═╡ 8d8224f2-e115-461c-944d-e906a6cb6ede
let
	b = @bind y let
	L = size(philip)[1]
	Slider(
		1 : L, 
		default=L ÷ 2
	)
	end
	md"Row: $(b)"
end

# ╔═╡ 5f10f7e2-64a2-4dfb-bacc-a79a9e8cba41
let
	b = @bind Δ Slider(1:80, default=5)
	md"Window size: $(b)"
end

# ╔═╡ 63ded749-8bab-4e43-b3d8-7285122e1504
philip[
	(y - Δ:y + Δ) ∩ (1:end), 
	(x - Δ:x + Δ) ∩ (1:end)
]

# ╔═╡ Cell order:
# ╠═c9ae7bcc-78e3-11eb-1aa1-8b6d049db18e
# ╠═3ce4ef9e-8188-4af6-8547-38b2111054a7
# ╠═c57c2cca-dc3c-4053-b3cb-1c58e5c4b26d
# ╠═63ded749-8bab-4e43-b3d8-7285122e1504
# ╟─2c061184-b7b0-4dd3-9cd7-a96925a79106
# ╟─8d8224f2-e115-461c-944d-e906a6cb6ede
# ╟─5f10f7e2-64a2-4dfb-bacc-a79a9e8cba41
