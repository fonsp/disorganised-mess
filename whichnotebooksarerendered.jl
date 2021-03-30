### A Pluto.jl notebook ###
# v0.14.0

using Markdown
using InteractiveUtils

# ╔═╡ 364858d4-831b-11eb-3760-99f2fe147ab7
dir = "/Users/fons/Documents/18S191/"

# ╔═╡ d0e66ab4-040b-4f8e-ac2a-cc7938e0c3c3
identifier(f) = joinpath(splitpath(f)[end-1:end]...)

# ╔═╡ a2026ea6-efc1-482e-923f-5a0ec00ec116
flatmap(f::Function, xs) = vcat(map(f,xs)...)

# ╔═╡ a7feebff-78bf-42aa-be5f-4dd98021f7e2
mdfiles = flatmap(walkdir(joinpath(dir, "website"))) do (root, dirs, files)
	joinpath.([root], filter(f -> endswith(f,".md"), files))
end

# ╔═╡ 05d5f71a-3cd2-40a9-9c93-7828f4af69a0
nbfiles = flatmap(walkdir(joinpath(dir, "notebooks"))) do (root, dirs, files)
	joinpath.([root], filter(f -> endswith(f,".jl"), files))
end

# ╔═╡ c86eae01-c2f3-46d1-b081-6876386cac17
identifier.(nbfiles)

# ╔═╡ d8e3c52b-c83e-442b-b0cc-c67e7c257959
filter(nbfiles) do f
	any(mdfiles) do mf
		occursin(identifier(f), read(mf, String))
	end
end

# ╔═╡ Cell order:
# ╠═364858d4-831b-11eb-3760-99f2fe147ab7
# ╠═a7feebff-78bf-42aa-be5f-4dd98021f7e2
# ╠═05d5f71a-3cd2-40a9-9c93-7828f4af69a0
# ╠═d0e66ab4-040b-4f8e-ac2a-cc7938e0c3c3
# ╠═c86eae01-c2f3-46d1-b081-6876386cac17
# ╠═d8e3c52b-c83e-442b-b0cc-c67e7c257959
# ╠═a2026ea6-efc1-482e-923f-5a0ec00ec116
