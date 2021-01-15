### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 505c8ff2-14ab-44ff-9936-e6823a7ad57c
function Base.first(f::Function, xs)
	for x in xs
		if f(x)
			return x
		end
	end
	error("Not found")
end

# ╔═╡ df8d25d0-5753-11eb-2ac2-d578421390cf
import Pkg

# ╔═╡ d557ce18-ec63-4579-8971-d2ff8bcd30e8
packages_i_want = ["SpecialFunctions", "zz"]#, "DataArrays"]

# ╔═╡ 7d8912a5-7979-4811-b77d-ec17503b8050
Pkg.PRESERVE_ALL < Pkg.PRESERVE_NONE

# ╔═╡ d16de3a2-3ed1-45a1-a56c-b42892b96ead
Pkg.PreserveLevel(Int64(Pkg.PRESERVE_ALL) + 1)

# ╔═╡ beac924c-9335-4803-afa6-ae4c3a8d5054
tiers = [
	Pkg.PRESERVE_ALL,
	Pkg.PRESERVE_DIRECT,
	Pkg.PRESERVE_SEMVER,
	Pkg.PRESERVE_NONE,
]

# ╔═╡ 78a59722-62b7-4763-9feb-638089041d1b
i = iterate(tiers, 4)

# ╔═╡ 6b769e86-2121-4813-a0c6-837922b5ad95


# ╔═╡ b2c40cf8-fc33-412e-9ba7-b5b1322cca84
function update_project_pkg(ctx, new_packages)
    if ctx !== nothing
		new_packages = String.(new_packages)
		
		removed = setdiff(keys(ctx.env.project.deps), new_packages)
		added = setdiff(new_packages, keys(ctx.env.project.deps))
		
		
		to_remove = filter(removed) do p
			haskey(ctx.env.project.deps, p)
		end
		if !isempty(to_remove)
			Pkg.rm(ctx, [
				Pkg.PackageSpec(name=p)
				for p in to_remove
			])
		end
		
		local used_tier = Pkg.PRESERVE_ALL
		
		to_add = added
		if !isempty(to_add)
			for tier in [
				Pkg.PRESERVE_ALL,
				Pkg.PRESERVE_DIRECT,
				Pkg.PRESERVE_SEMVER,
				Pkg.PRESERVE_NONE,
			]
				used_tier = tier
				try
					Pkg.add(ctx, [
						Pkg.PackageSpec(name=p)
						for p in to_add
					]; preserve=used_tier)
					
					break
				catch e
					if used_tier == Pkg.PRESERVE_NONE
						# give up
						rethrow(e)
					end
				end
			end
			
			# for p in to_add
			# 	entry = first(e -> e.name == p, values(ctx.env.manifest))
			# 	if entry.version !== nothing
			# 		ctx.env.project.compat[p] = "^" * string(entry.version)
			# 	end
			# end
			# Pkg.Types.write_env(ctx.env)
		end
    end
	(
		used_tier=used_tier,
		# changed_versions=Dict{String,Pair}(),
		restart_recommended=(!isempty(to_remove) || used_tier != Pkg.PRESERVE_ALL),
		restart_required=(used_tier ∈ [Pkg.PRESERVE_SEMVER, Pkg.PRESERVE_NONE]),
	)
end

# ╔═╡ a9ee527c-90e5-44c2-b8b2-4d0304494c54
ctx = Pkg.Types.Context(env=Pkg.Types.EnvCache(joinpath(mktempdir(),"Project.toml")))

# ╔═╡ 3a45375a-906a-41e4-a3c0-c29461b44e70
try
	global result = update_project_pkg(ctx, packages_i_want)
catch e
	global result_err = e
end

# ╔═╡ 16e6033a-4b78-46a2-9ce0-809f6ede80a5
let
	try result catch end
	
	Text(read(ctx.env.project_file, String))
end

# ╔═╡ 090289d4-2160-445c-b409-8d6606ff8d7f
let
	result
	sort([e.name => e.version for e in values(ctx.env.manifest)]; by=first)
end

# ╔═╡ e222c698-644d-4849-bf2c-296f11ce96fe
let
	try result catch end
	
	Text(read(ctx.env.manifest_file, String))
end

# ╔═╡ 33c76e41-54a7-4c11-8659-50e93bfd30e8
entry = first(e -> e.name == "MsgPack", values(ctx.env.manifest))

# ╔═╡ 1666277b-7593-4889-bc50-80b50279448a
let
	try result catch end
	ctx.env
end

# ╔═╡ e9f1a9e5-672e-4df0-8967-5870a6e849e1
pt = tempname()

# ╔═╡ Cell order:
# ╠═505c8ff2-14ab-44ff-9936-e6823a7ad57c
# ╠═df8d25d0-5753-11eb-2ac2-d578421390cf
# ╠═3a45375a-906a-41e4-a3c0-c29461b44e70
# ╠═d557ce18-ec63-4579-8971-d2ff8bcd30e8
# ╠═16e6033a-4b78-46a2-9ce0-809f6ede80a5
# ╠═090289d4-2160-445c-b409-8d6606ff8d7f
# ╠═e222c698-644d-4849-bf2c-296f11ce96fe
# ╠═7d8912a5-7979-4811-b77d-ec17503b8050
# ╠═d16de3a2-3ed1-45a1-a56c-b42892b96ead
# ╠═beac924c-9335-4803-afa6-ae4c3a8d5054
# ╠═78a59722-62b7-4763-9feb-638089041d1b
# ╠═6b769e86-2121-4813-a0c6-837922b5ad95
# ╠═b2c40cf8-fc33-412e-9ba7-b5b1322cca84
# ╠═33c76e41-54a7-4c11-8659-50e93bfd30e8
# ╠═1666277b-7593-4889-bc50-80b50279448a
# ╠═a9ee527c-90e5-44c2-b8b2-4d0304494c54
# ╠═e9f1a9e5-672e-4df0-8967-5870a6e849e1
