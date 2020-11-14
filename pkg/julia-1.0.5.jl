### A Pluto.jl notebook ###
# v0.12.7

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

# ╔═╡ 226fe150-2377-11eb-1b6b-1b5dda79c780
@bind input html"<input>"

# ╔═╡ 1ed85fb0-2398-11eb-325f-11a104b7ecd2
readdir(Pkg.Types.stdlib_dir())

# ╔═╡ 8020a160-2375-11eb-2e97-71bc04edf349
VERSION

# ╔═╡ a72abbb0-237a-11eb-3fcd-7f855607ffb3


# ╔═╡ 47a0a162-2374-11eb-192d-a321eded9f93
import Pkg

# ╔═╡ 5a672622-2374-11eb-094f-bbd06a5c3f0b
Pkg.REPLMode.complete_remote_package("Pl", 1, 3)

# ╔═╡ 2356bee0-2377-11eb-3060-f72278809757
function packagecompletions(partial_name)
	Pkg.REPLMode.complete_remote_package(partial_name, 1, length(partial_name))[1]
end

# ╔═╡ 277b1430-2377-11eb-387c-d3547c8b7721
suggestions = isempty(input) ? [] : packagecompletions(input)

# ╔═╡ 2b8cf2f2-2377-11eb-1271-d55d8cc52886
choice = first(suggestions)

# ╔═╡ 2fa07f60-2377-11eb-3aa8-230fa0aba9fe
choicespec = Pkg.PackageSpec(choice)

# ╔═╡ 8875e440-2377-11eb-2474-5b9b7933bb39
ctx = Pkg.Types.Context()

# ╔═╡ 326e4560-2377-11eb-22bb-c93d270389cc
general_path = Pkg.Types.registries()[1]

# ╔═╡ e7bbb150-2377-11eb-00ac-2d5d4cdf128c
general = Pkg.Types.read_registry(joinpath(general_path, "Registry.toml"))

# ╔═╡ c1177600-2378-11eb-39a5-554f9266aabd
function registry_path(registry, package_name)
	packages = values(registry["packages"])
	d = Iterators.filter(d -> d["name"] == package_name, packages) |> first
	d["path"]
end

# ╔═╡ de5a7550-2378-11eb-2ebf-6996a8588f7f
choice_path = registry_path(general, choice)

# ╔═╡ 3d9c2e3e-237a-11eb-3834-fdd176ce7791
choice_fullpath = joinpath(general_path, choice_path)

# ╔═╡ 2756bbee-237a-11eb-04d9-4109c95ce927
choice_versions = Pkg.Operations.load_versions(choice_fullpath) |> keys |> collect |> sort!

# ╔═╡ Cell order:
# ╟─226fe150-2377-11eb-1b6b-1b5dda79c780
# ╟─277b1430-2377-11eb-387c-d3547c8b7721
# ╟─2b8cf2f2-2377-11eb-1271-d55d8cc52886
# ╠═1ed85fb0-2398-11eb-325f-11a104b7ecd2
# ╠═2756bbee-237a-11eb-04d9-4109c95ce927
# ╠═8020a160-2375-11eb-2e97-71bc04edf349
# ╠═a72abbb0-237a-11eb-3fcd-7f855607ffb3
# ╠═47a0a162-2374-11eb-192d-a321eded9f93
# ╠═5a672622-2374-11eb-094f-bbd06a5c3f0b
# ╠═2356bee0-2377-11eb-3060-f72278809757
# ╠═2fa07f60-2377-11eb-3aa8-230fa0aba9fe
# ╠═8875e440-2377-11eb-2474-5b9b7933bb39
# ╠═326e4560-2377-11eb-22bb-c93d270389cc
# ╠═e7bbb150-2377-11eb-00ac-2d5d4cdf128c
# ╠═de5a7550-2378-11eb-2ebf-6996a8588f7f
# ╠═3d9c2e3e-237a-11eb-3834-fdd176ce7791
# ╠═c1177600-2378-11eb-39a5-554f9266aabd
