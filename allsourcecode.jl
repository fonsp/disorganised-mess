### A Pluto.jl notebook ###
# v0.19.16

using Markdown
using InteractiveUtils

# ╔═╡ 82a33734-c1cf-11ea-242f-55472983b28e
import Pkg

# ╔═╡ 6d657a8e-c1dd-11ea-2eb7-f956b3819670
import LibGit2

# ╔═╡ c41baab4-c1dd-11ea-0f86-e1c4cb2b9e0f
repo = "https://github.com/fonsp/Pluto.jl"

# ╔═╡ a1513222-c1dd-11ea-1d6b-833308aa7453
begin
	dir = mktempdir(cleanup=false)
	LibGit2.clone(repo, dir)
end

# ╔═╡ 6d7b5b2a-c1cf-11ea-2a51-bb03b34976a7


# ╔═╡ 8454900a-c1cf-11ea-0897-7d3d3b113d82
all_files = let
	x = String[]
	for sub in ["src", "frontend", "test"]
		for (root, dirs, files) in walkdir(joinpath(dir, sub))
			paths = joinpath.([root], files)

			union!(x, filter(paths) do f
				!occursin("img", f) && 
				!occursin(joinpath("frontend","imports"), f) &&
				!occursin("package-lock", f) &&
				!occursin("Manifest.toml", f)
			end)
		end
	end
	x
end

# ╔═╡ 92a09410-c1cf-11ea-13ee-85cbcd4de2d8
all_contents = read.(all_files, [String])

# ╔═╡ 52d6c307-7679-427b-960b-3d461f6aa188
per_filetype = reduce(all_files; init=Dict{String,Vector{String}}()) do d, f
	list = get!(() -> String[], d, splitext(f)[2])
	push!(list, f)
	d
end

# ╔═╡ 5d970c62-6eef-4c80-829f-fed9a309eb17
lines_per_filetype = Dict(
	t => sum(1 + count(isequal('\n'), filter(isvalid, read(path, String))) for path in paths)
	for (t,paths) in per_filetype
)

# ╔═╡ 9d842c9e-c1d0-11ea-2dae-f5726c92cac0
joined = join(all_contents, "\n")

# ╔═╡ 19273226-5ad0-48e4-9ec9-affb2514c450
Text(joined[1:1000])

# ╔═╡ 8490e2c4-d986-4890-bd20-704b03f10ddd
to_display = replace(joined, r"\s+"s => " ")

# ╔═╡ 4d22e6d6-188f-4cce-a293-e3daec21e19e
Text(to_display[1:1000])

# ╔═╡ 50d1c84e-c1dc-11ea-2cf4-8da2f0126dd5
count(isequal('\n'), filter(isvalid, join(all_contents)))

# ╔═╡ 4328c540-c1d1-11ea-0a99-efb01d8604af
import Markdown: htmlesc

# ╔═╡ c7a586ce-c1d0-11ea-0b59-13c418e1eb35
HTML("""
<code><pre style='word-break: break-all;
white-space: break-spaces; width: 576px; font-size: 10px; font-family: monospace;'>$(htmlesc(filter(isascii, to_display)))</pre></code>
""")

# ╔═╡ b5b5bd14-c1d8-11ea-2f33-839c40199b6f


# ╔═╡ ead40792-c1d5-11ea-0053-9fc2ea5f8720
x = [1,2,3]

# ╔═╡ efc1e762-c1d5-11ea-2bdc-d9e56fbeb264


# ╔═╡ 3da1df68-c1d5-11ea-210f-4f277921f9bf
line_length = 40

# ╔═╡ 62d07b14-c1d5-11ea-36ae-8f944f2d40e2
let
	chars = collect(all_together)
	edges = 1:40:(length(chars) + 1)
	
	String.(map(chars[], i ∈ 1:length(edges)-1))
end

# ╔═╡ 3f9c4fec-c1d5-11ea-3e40-7b6b696eb978
let
	
	lines = reshape
	combined = join()
	HTML("""
<code><pre style='word-break: break-all;
white-space: break-spaces; width: 576px; font-size: 10px; font-family: monospace;'>$(htmlesc(all_together))</pre></code>
""")
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
LibGit2 = "76f85450-5226-5b5a-8eaa-529ad045b433"
Markdown = "d6f4376e-aef5-505a-96c1-9c027394607a"
Pkg = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.3"
manifest_format = "2.0"
project_hash = "cb21bd95df119ce439b7ead9505a19d8d4fc8e07"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

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
version = "2.28.0+0"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.2.1"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

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
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.12+3"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
"""

# ╔═╡ Cell order:
# ╠═6d657a8e-c1dd-11ea-2eb7-f956b3819670
# ╠═82a33734-c1cf-11ea-242f-55472983b28e
# ╠═a1513222-c1dd-11ea-1d6b-833308aa7453
# ╠═c41baab4-c1dd-11ea-0f86-e1c4cb2b9e0f
# ╠═6d7b5b2a-c1cf-11ea-2a51-bb03b34976a7
# ╠═8454900a-c1cf-11ea-0897-7d3d3b113d82
# ╠═92a09410-c1cf-11ea-13ee-85cbcd4de2d8
# ╠═52d6c307-7679-427b-960b-3d461f6aa188
# ╠═5d970c62-6eef-4c80-829f-fed9a309eb17
# ╠═9d842c9e-c1d0-11ea-2dae-f5726c92cac0
# ╠═19273226-5ad0-48e4-9ec9-affb2514c450
# ╠═4d22e6d6-188f-4cce-a293-e3daec21e19e
# ╠═8490e2c4-d986-4890-bd20-704b03f10ddd
# ╠═50d1c84e-c1dc-11ea-2cf4-8da2f0126dd5
# ╠═4328c540-c1d1-11ea-0a99-efb01d8604af
# ╠═c7a586ce-c1d0-11ea-0b59-13c418e1eb35
# ╠═b5b5bd14-c1d8-11ea-2f33-839c40199b6f
# ╠═ead40792-c1d5-11ea-0053-9fc2ea5f8720
# ╠═efc1e762-c1d5-11ea-2bdc-d9e56fbeb264
# ╠═3da1df68-c1d5-11ea-210f-4f277921f9bf
# ╠═62d07b14-c1d5-11ea-36ae-8f944f2d40e2
# ╠═3f9c4fec-c1d5-11ea-3e40-7b6b696eb978
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
