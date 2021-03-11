### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 9431856b-2e3c-48f8-ab68-e7b724738975
import Pkg

# ╔═╡ aab2e432-575b-11eb-0e6c-7fa2b61be154
begin
	ctx = Pkg.Types.Context(env=Pkg.Types.EnvCache(joinpath(mktempdir(),"Project.toml")))
	Pkg.add(ctx, [Pkg.PackageSpec(name="JSON")])
	ctx
end

# ╔═╡ cd2c9fb3-0686-47bf-82d1-73d461ce8980
ctx.env.project

# ╔═╡ 77bb0041-fb9c-491c-a371-1e37c81b8ec1
ctx.env.manifest

# ╔═╡ 1fbaf30f-ef1b-433a-87e7-5f52ab8f51b8
updated = let
	ctx.env.project.compat["JSON"] = "^0.21.1"
	ctx.env.project
end

# ╔═╡ 63201e0d-bc3f-49db-b5d5-021ac5606cb9
pt = tempname()

# ╔═╡ 17cd3831-680c-44ab-a7c7-2a7f31ed273f
updated_2 = let
	updated
	Pkg.Types.write_env(ctx.env)
end;

# ╔═╡ 63ea0a2d-1c6b-4003-89f3-e4d7ab1f52cd
let
	updated_2
	
	Text(read(ctx.env.project_file, String))
end

# ╔═╡ 41c6fb73-b832-4028-8d01-425c2e7df2ae
let
	updated_2
	
	Text(read(ctx.env.manifest_file, String))
end

# ╔═╡ 0c2b1c17-9816-4c6c-952b-e433cf289c9e
isfile("/System/Volumes/Data/home/fons/Documents/Pluto.jl/Project.toml")

# ╔═╡ f7fddef8-631e-4aa9-89d9-1779b670e2bf
Pkg.Types.Context(env=Pkg.Types.EnvCache("/Users/fons/Documents/Pluto.jl/Project.toml"))

# ╔═╡ Cell order:
# ╠═9431856b-2e3c-48f8-ab68-e7b724738975
# ╠═aab2e432-575b-11eb-0e6c-7fa2b61be154
# ╠═cd2c9fb3-0686-47bf-82d1-73d461ce8980
# ╠═77bb0041-fb9c-491c-a371-1e37c81b8ec1
# ╠═1fbaf30f-ef1b-433a-87e7-5f52ab8f51b8
# ╠═63201e0d-bc3f-49db-b5d5-021ac5606cb9
# ╠═17cd3831-680c-44ab-a7c7-2a7f31ed273f
# ╠═63ea0a2d-1c6b-4003-89f3-e4d7ab1f52cd
# ╠═41c6fb73-b832-4028-8d01-425c2e7df2ae
# ╠═0c2b1c17-9816-4c6c-952b-e433cf289c9e
# ╠═f7fddef8-631e-4aa9-89d9-1779b670e2bf
