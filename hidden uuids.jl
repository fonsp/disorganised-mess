### A Pluto.jl notebook ###
# v0.17.3

using Markdown
using InteractiveUtils

# ╔═╡ c2415f36-5c21-11ec-35d3-593bf2a9b024
import Pkg

# ╔═╡ a74ab403-9bc1-436b-b595-9b2dd4896f1d
using UUIDs

# ╔═╡ a756fb33-79dc-454f-a847-23e680f4c136


# ╔═╡ 302638b9-bc72-4e72-ade7-51a1a395d548
Pkg.Registry.status()

# ╔═╡ 2a126441-9eb0-4eb3-b7c6-007a705a8064
# (⛔️ Internal API)
"Return paths to all installed registries."
_get_registry_paths() = @static if isdefined(Pkg, :Types) && isdefined(Pkg.Types, :registries)
	Pkg.Types.registries()
elseif isdefined(Pkg, :Registry) && isdefined(Pkg.Registry, :reachable_registries)
	registry_specs = Pkg.Registry.reachable_registries()
	[s.path for s in registry_specs]
elseif isdefined(Pkg, :Types) && isdefined(Pkg.Types, :collect_registries)
	registry_specs = Pkg.Types.collect_registries()
	[s.path for s in registry_specs]
else
	String[]
end

# ╔═╡ b3f492e9-6174-4ded-80b2-300a3d98123e
# (⛔️ Internal API)
_get_registries() = map(_get_registry_paths()) do r
	@static if isdefined(Pkg, :Registry) && isdefined(Pkg.Registry, :RegistryInstance)
		Pkg.Registry.RegistryInstance(r)
	else
		r => Pkg.Types.read_registry(joinpath(r, "Registry.toml"))
	end
end

# ╔═╡ c842d107-d774-459c-8275-a6ae8f2b8e06
rs = _get_registries()

# ╔═╡ e515ffda-61a5-42a8-81bf-f31e6c02889b
r = last(rs)

# ╔═╡ dffdc676-e005-4508-949f-5070664894ea
registered_uuids = keys(r.pkgs)

# ╔═╡ e55f915f-8eb0-40d2-8be6-1b16dea745fc


# ╔═╡ a8793db2-987c-40f7-82c4-6f74503f1ee4
u2 = Base.UUID(reinterpret(Int128, codeunits("Paul Berg Berlin")) |> first)

# ╔═╡ 360a4c34-0ec7-484b-9246-4e3e68f5abd8
u = UUID("7cc45869-7501-5eee-bdea-0790c847d4ef")


# ╔═╡ 833dea89-980e-4f42-8408-efdbf194274b
u.value

# ╔═╡ 4fa9f56c-c320-46ad-b660-b8d9c50c6da7
function to_string(uuid::UUID)
	chars = reinterpret(UInt8, [uuid.value])
	result = String(chars)
	
	if isascii(result) && !any(iscntrl, result)
		result
	else
		nothing
	end
end

# ╔═╡ 515fd70f-a30d-40f9-a443-01e097701071
uuids_with_hidden_message = filter(!isnothing ∘ to_string, registered_uuids)

# ╔═╡ 9ed478ce-94f6-4108-8e2c-1a395965923a
[
	to_string(uuid) => r.pkgs[uuid]
	for uuid in uuids_with_hidden_message
]

# ╔═╡ bb33f7ea-32c9-45b3-9a0d-78ad8570a8e1
to_string(u2)

# ╔═╡ cda4c2c7-36f8-46e7-82ed-9f39a1a806c0
to_string(u)

# ╔═╡ 536bf6c9-47ee-4d05-bc4a-ff1cef617980


# ╔═╡ 27b80103-1ae9-4296-84ab-8b2fa32fd56a


# ╔═╡ 1adf03ef-e68f-44ee-ac0c-848e5749ae23
keys(r.pkgs)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Pkg = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
UUIDs = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.0"
manifest_format = "2.0"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╠═515fd70f-a30d-40f9-a443-01e097701071
# ╠═9ed478ce-94f6-4108-8e2c-1a395965923a
# ╠═a756fb33-79dc-454f-a847-23e680f4c136
# ╠═c2415f36-5c21-11ec-35d3-593bf2a9b024
# ╠═302638b9-bc72-4e72-ade7-51a1a395d548
# ╠═2a126441-9eb0-4eb3-b7c6-007a705a8064
# ╠═b3f492e9-6174-4ded-80b2-300a3d98123e
# ╠═c842d107-d774-459c-8275-a6ae8f2b8e06
# ╠═e515ffda-61a5-42a8-81bf-f31e6c02889b
# ╠═dffdc676-e005-4508-949f-5070664894ea
# ╠═e55f915f-8eb0-40d2-8be6-1b16dea745fc
# ╠═a8793db2-987c-40f7-82c4-6f74503f1ee4
# ╠═bb33f7ea-32c9-45b3-9a0d-78ad8570a8e1
# ╠═a74ab403-9bc1-436b-b595-9b2dd4896f1d
# ╠═360a4c34-0ec7-484b-9246-4e3e68f5abd8
# ╠═cda4c2c7-36f8-46e7-82ed-9f39a1a806c0
# ╠═833dea89-980e-4f42-8408-efdbf194274b
# ╠═4fa9f56c-c320-46ad-b660-b8d9c50c6da7
# ╠═536bf6c9-47ee-4d05-bc4a-ff1cef617980
# ╠═27b80103-1ae9-4296-84ab-8b2fa32fd56a
# ╠═1adf03ef-e68f-44ee-ac0c-848e5749ae23
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
