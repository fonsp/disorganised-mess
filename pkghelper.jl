### A Pluto.jl notebook ###
# v0.15.0

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

# ╔═╡ af583068-81e1-11eb-36f3-47394c281524
begin
	import Pkg
	Pkg.activate(mktempdir())
	Pkg.add(["PlutoUI"])
	using PlutoUI
end

# ╔═╡ 5cd2f666-8d49-4cff-8734-5c18aa32aef3
md"""
#### To use these packages...
(Edit me!)
"""

# ╔═╡ 7dc112be-ff31-4423-896c-f199f621d882
@bind packages_raw TextField((60,5), default="Plots, PlutoUI, LinearAlgebra")

# ╔═╡ ac000595-fbe1-461c-a67e-8464c512bbe2
md"""
#### ... you can use this Pkg cell!
(Copy me!)
"""

# ╔═╡ 848c1b97-890a-4815-a182-e01bd0daf549
html"""
<br>
<br>
<br>
<br>
<h1>Appendix</h1>
"""

# ╔═╡ 1e1d983e-fac9-4b38-9d93-78d09ecec971
package_names = setdiff(
	split(replace(packages_raw, r"\W" => " "), keepempty=false),
	["using", "import"]
)

# ╔═╡ 733ffd48-f375-4cc0-9f85-d504e9864f1c
v = v"1.2.3"

# ╔═╡ 118d110f-be9b-4f84-94f6-1ada6f460cb9
v.major == 0

# ╔═╡ d0daa204-f53f-46b0-95fc-2fc9551962ac
function recommended_range(v::VersionNumber)
	if v.major == 0
		if v.minor == 0
			"0.0.$(v.patch)"
		else
			"0.$(v.minor)"
		end
	else
		"$(v.major)"
	end
end

# ╔═╡ d7bbabf3-d1db-4aa7-92ce-9df5bb48b54a
function recommended_range(versions::Vector{VersionNumber})
	if isempty(versions)
		nothing
	else
		v = maximum(versions)
		recommended_range(v)
	end
end

# ╔═╡ 998e2060-a0ac-44e9-8d0a-6cda3ac7a887
md"""
Pkg code from [https://github.com/fonsp/Pluto.jl/pull/844](https://github.com/fonsp/Pluto.jl/pull/844):
"""

# ╔═╡ e4caaba6-87b0-469e-a85f-4678b7176718
module PkgTools

export package_versions, package_completions

import Pkg
import Pkg.Types: VersionRange

function getfirst(f::Function, xs)
	for x ∈ xs
		if f(x)
			return x
		end
	end
	error("Not found")
end

create_empty_ctx() = Pkg.Types.Context(env=Pkg.Types.EnvCache(joinpath(mktempdir(),"Project.toml")))

# TODO: technically this is not constant
const registry_paths = @static if isdefined(Pkg.Types, :registries)
	Pkg.Types.registries()
else
	registry_specs = Pkg.Types.collect_registries()
	[s.path for s in registry_specs]
end

const registries = map(registry_paths) do r
	r => Pkg.Types.read_registry(joinpath(r, "Registry.toml"))
end

const stdlibs = readdir(Pkg.Types.stdlib_dir())::Vector{String}

is_stdlib(package_name::AbstractString) = package_name ∈ stdlibs
is_stdlib(pkg::Pkg.Types.PackageEntry) = pkg.version === nothing && (pkg.name ∈ stdlibs)

# TODO: should this be the notebook context? it only matters for which registry is used
const global_ctx = Pkg.Types.Context()

###
# Package names
###

function registered_package_completions(partial_name::AbstractString)
	# compat
	@static if hasmethod(Pkg.REPLMode.complete_remote_package, (String,))
		Pkg.REPLMode.complete_remote_package(partial_name)
	else
		Pkg.REPLMode.complete_remote_package(partial_name, 1, length(partial_name))[1]
	end
end

function package_completions(partial_name::AbstractString)::Vector{String}
	String[
		filter(s -> startswith(s, partial_name), stdlibs);
		registered_package_completions(partial_name)
	]
end


###
# Package versions
###

function registries_path(registries::Vector, package_name::AbstractString)::Union{Nothing,String}
	for (rpath, r) in registries
		packages = values(r["packages"])
		ds = Iterators.filter(d -> d["name"] == package_name, packages)
		if !isempty(ds)
			return joinpath(rpath, first(ds)["path"])
		end
	end
end

function package_versions_from_path(registry_entry_fullpath::AbstractString; ctx=global_ctx)::Vector{VersionNumber}
	# compat
    (@static if hasmethod(Pkg.Operations.load_versions, (String,))
        Pkg.Operations.load_versions(registry_entry_fullpath)
    else
        Pkg.Operations.load_versions(ctx, registry_entry_fullpath)
    end) |> keys |> collect |> sort!
end

function package_versions(package_name::AbstractString)::Vector
    if package_name ∈ stdlibs
        ["stdlib"]
    else
        p = registries_path(registries, package_name)
        if p === nothing
            VersionNumber[]
        else
            package_versions_from_path(p)
        end
    end
end

package_exists(package_name::AbstractString) =
    package_name ∈ stdlibs || 
    registries_path(registries, package_name) !== nothing

get_manifest_entry(ctx::Pkg.Types.Context, package_name::AbstractString) = 
    getfirst(e -> e.name == package_name, values(ctx.env.manifest))

function get_manifest_version(ctx, package_name)
    if package_name ∈ stdlibs
        "stdlib"
    else
        entry = get_manifest_entry(ctx, package_name)
        entry.version
    end
end

end

# ╔═╡ c0db5117-762a-4dd3-8a48-cc64a623c8dc
PkgTools.is_stdlib.(package_names)

# ╔═╡ 10dc0798-367e-4038-905a-905710d7df53
PkgTools.package_versions("Plots")

# ╔═╡ 3d345deb-253f-4174-84b8-c54bcf111eae
function recommended_range(package_name::AbstractString)
	if PkgTools.is_stdlib(package_name)
		nothing
	else
		recommended_range(PkgTools.package_versions(package_name))
	end
end

# ╔═╡ 9d78c366-2fcc-4948-be5f-acea8a1bfeac
code = """
begin
	import Pkg
	Pkg.activate(mktempdir())
	Pkg.add([
$(join([
let
	v = recommended_range(p)
	vstring = v === nothing ? "" : ", version=\"$(v)\""

	"		Pkg.PackageSpec(name=\"$(p)\"$(vstring)),"
end
for p in filter(!PkgTools.is_stdlib, package_names)], "\n"))
	])
	using $(join(package_names, ", "))
end
""";

# ╔═╡ a6f8c49f-e671-40aa-a84e-9c1c58a90312
Markdown.MD(Markdown.Code("julia", code))

# ╔═╡ 449d49c8-18e0-47ec-ad0a-0778e4e12406
recommended_range.(package_names)

# ╔═╡ 11695f49-fd55-40c2-89f9-3e0fd7ed623c
recommended_range([v"0.0.123"])

# ╔═╡ Cell order:
# ╟─5cd2f666-8d49-4cff-8734-5c18aa32aef3
# ╟─7dc112be-ff31-4423-896c-f199f621d882
# ╟─ac000595-fbe1-461c-a67e-8464c512bbe2
# ╟─a6f8c49f-e671-40aa-a84e-9c1c58a90312
# ╟─848c1b97-890a-4815-a182-e01bd0daf549
# ╠═1e1d983e-fac9-4b38-9d93-78d09ecec971
# ╠═9d78c366-2fcc-4948-be5f-acea8a1bfeac
# ╠═c0db5117-762a-4dd3-8a48-cc64a623c8dc
# ╠═449d49c8-18e0-47ec-ad0a-0778e4e12406
# ╠═10dc0798-367e-4038-905a-905710d7df53
# ╠═733ffd48-f375-4cc0-9f85-d504e9864f1c
# ╠═118d110f-be9b-4f84-94f6-1ada6f460cb9
# ╠═11695f49-fd55-40c2-89f9-3e0fd7ed623c
# ╠═d0daa204-f53f-46b0-95fc-2fc9551962ac
# ╠═d7bbabf3-d1db-4aa7-92ce-9df5bb48b54a
# ╠═3d345deb-253f-4174-84b8-c54bcf111eae
# ╠═af583068-81e1-11eb-36f3-47394c281524
# ╟─998e2060-a0ac-44e9-8d0a-6cda3ac7a887
# ╠═e4caaba6-87b0-469e-a85f-4678b7176718
