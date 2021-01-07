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

# ╔═╡ 640d83a2-2376-11eb-020b-af01a448c337
@bind input html"<input>"

# ╔═╡ 732aafa8-236d-11eb-2edb-75a99c743a73
Base.loaded_modules

# ╔═╡ daf92b50-236d-11eb-1fa6-3b8ccd4ec112
import Pkg

# ╔═╡ 750525b4-236e-11eb-0ec6-c1d8aa15868e
Pkg.Types.stdlibs()

# ╔═╡ 07dc4dbc-2370-11eb-2f5a-35056bded5c5
ctx = Pkg.Types.Context()

# ╔═╡ f549a6da-2370-11eb-2659-a1c1601d9b55


# ╔═╡ f239a306-236f-11eb-270d-65ee9a64dd5c
version_info = Pkg.Operations.load_versions(ctx, path; include_yanked=true)

# ╔═╡ d4b4dfea-236e-11eb-0bf5-2f1941799e70
general_path = let
	reg = first(Pkg.Types.collect_registries())
	reg.path
end

# ╔═╡ a61f9f58-2378-11eb-1d02-c3da6d925391
general = Pkg.Types.read_registry(joinpath(general_path, "Registry.toml"))

# ╔═╡ 1d0851dc-236f-11eb-2fbb-d30073da3479
packages = general["packages"] |> values |> collect

# ╔═╡ da7b9954-2379-11eb-1a28-83f20d8e0562
fav = packages[203]

# ╔═╡ 603049dc-2370-11eb-3553-45eb6ed226ed
Pkg.Types.read_package(joinpath(general_path, path, "Package.toml"))

# ╔═╡ ad286de8-2373-11eb-083f-af582cd75822
Pkg.REPLMode.complete_add_dev(nothing, "Pl", 1, 3)

# ╔═╡ b1f816fa-2375-11eb-1b75-1f006ec1b45c
ps = Pkg.PackageSpec(
	name="PlutoUI"
	)

# ╔═╡ a7016b5c-2375-11eb-3c10-5392a601cf3a
Pkg.Operations.source_path(ctx, ps)

# ╔═╡ c5492618-2375-11eb-1d27-81c3ff34f9ec
Pkg.Operations.project_rel_path(ctx

# ╔═╡ 3f5b9800-2376-11eb-1940-c9d7bffdc260
function packagecompletions(partial_name)
	Pkg.REPLMode.complete_remote_package(partial_name)
end

# ╔═╡ 5e95099a-2376-11eb-39fa-3f6bb72bac13
suggestions = isempty(input) ? [] : packagecompletions(input)

# ╔═╡ 811d0814-2376-11eb-0dd3-9d424051c3b0
choice = first(suggestions)

# ╔═╡ a128d40a-2379-11eb-286b-610af6ce6391


# ╔═╡ ad379bd0-2376-11eb-2dae-dff97dbc78c7
function registry_path(registry, package_name)
	packages = values(registry["packages"])
	d = Iterators.filter(d -> d["name"] == package_name, packages) |> first
	d["path"]
end

# ╔═╡ 2a49c4ca-2379-11eb-0623-a5b3ec1156d4
choice_path = registry_path(general, choice)

# ╔═╡ fc884172-2375-11eb-36b9-27d0b37bb8e1
fullpath = joinpath(choice_path, path)

# ╔═╡ 955d41e0-2379-11eb-104b-811b90596250
choice_fullpath = joinpath(general_path, choice_path)

# ╔═╡ 52365d62-237a-11eb-0bff-cd46a30bad41
choice_versions = Pkg.Operations.load_versions(ctx, choice_fullpath) |> keys |> collect |> sort!

# ╔═╡ 5255157c-2375-11eb-0928-37ec6b0b40c8
Pkg.Operations.load_versions(ctx, fullpath)

# ╔═╡ Cell order:
# ╟─640d83a2-2376-11eb-020b-af01a448c337
# ╟─5e95099a-2376-11eb-39fa-3f6bb72bac13
# ╟─811d0814-2376-11eb-0dd3-9d424051c3b0
# ╟─52365d62-237a-11eb-0bff-cd46a30bad41
# ╠═732aafa8-236d-11eb-2edb-75a99c743a73
# ╠═daf92b50-236d-11eb-1fa6-3b8ccd4ec112
# ╠═750525b4-236e-11eb-0ec6-c1d8aa15868e
# ╠═a61f9f58-2378-11eb-1d02-c3da6d925391
# ╠═1d0851dc-236f-11eb-2fbb-d30073da3479
# ╠═07dc4dbc-2370-11eb-2f5a-35056bded5c5
# ╠═603049dc-2370-11eb-3553-45eb6ed226ed
# ╠═f549a6da-2370-11eb-2659-a1c1601d9b55
# ╠═da7b9954-2379-11eb-1a28-83f20d8e0562
# ╠═f239a306-236f-11eb-270d-65ee9a64dd5c
# ╠═d4b4dfea-236e-11eb-0bf5-2f1941799e70
# ╠═ad286de8-2373-11eb-083f-af582cd75822
# ╠═b1f816fa-2375-11eb-1b75-1f006ec1b45c
# ╠═fc884172-2375-11eb-36b9-27d0b37bb8e1
# ╠═a7016b5c-2375-11eb-3c10-5392a601cf3a
# ╠═c5492618-2375-11eb-1d27-81c3ff34f9ec
# ╠═3f5b9800-2376-11eb-1940-c9d7bffdc260
# ╠═2a49c4ca-2379-11eb-0623-a5b3ec1156d4
# ╠═955d41e0-2379-11eb-104b-811b90596250
# ╠═a128d40a-2379-11eb-286b-610af6ce6391
# ╠═ad379bd0-2376-11eb-2dae-dff97dbc78c7
# ╠═5255157c-2375-11eb-0928-37ec6b0b40c8
