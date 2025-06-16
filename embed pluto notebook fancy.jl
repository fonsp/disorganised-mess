### A Pluto.jl notebook ###
# v0.20.8

using Markdown
using InteractiveUtils

# ╔═╡ ba18da98-1085-11f0-2ce3-933581feb6e5
using HypertextLiteral

# ╔═╡ 7bd18f3b-6ac1-4da6-aeb4-22499b1715a8
h(x) = Text(repr(MIME"text/html"(), x))

# ╔═╡ 427de4b4-8731-4181-a09b-efcc408cb29e
function embed_pluto_notebook(; kwargs...)
	@htl """
	<div class="embed-pe">
	<pluto-editor
		id=$("pe-$(rand(1:1000000))")
		$(kwargs)
	>
	</pluto-editor>
	</div>

	<style>
	.embed-pe {
		height: 300px;
		overflow-y: auto;
		border-radius: 4px;
	}
	</style>
	"""
end

# ╔═╡ 09c22e1f-8695-4e10-a70a-0c08b1c4c922
# embed_pluto_notebook(; 
# 	notebookfile="https://featured.plutojl.org/basic/Basic%20mathematics.jl",
# 	notebookfile_integrity="sha256-gQ80NOuWT2AIckkUMVh2scKYdSD8wnurFqZ/R+WpI3c=",
# 	statefile="https://featured.plutojl.org/basic/Basic%20mathematics.plutostate",
# 	disable_ui=true,
# 	slider_server_url="https://fonsi.armada.silentech.gr/",
# )

# ╔═╡ bb618eee-6733-44d0-b1bd-c6b0cd544993
import Downloads

# ╔═╡ 5f03b0ab-1f8f-459b-a0e5-b3b946bd6323
import URIs

# ╔═╡ 0fa9ed99-b2fd-4149-96d2-7478020d66bf
function get(args...; kwargs...)
	local resp
	s = sprint() do io
		resp = Downloads.request(args...; kwargs..., output=io, throw=false)
	end
	s, resp
end

# ╔═╡ d1167a2e-a336-4dce-8cf2-2b9b78b6229e
import JSON

# ╔═╡ 9adb42b4-6ee0-4132-b5f1-4ae3e618d230
function find_root_json(start_url)
	url = URIs.URI(start_url)
	path_parts = split(url.path, "/")
	for i in eachindex(path_parts)
		newpath = join([path_parts[begin:i]..., "pluto_export.json"], "/")
		newurl = URIs.URI(url; path=newpath)

		htmlpath_relative = join(path_parts[i+1:end], "/")

		data, resp = get(string(newurl))
		
		if resp.status ∈ 200:299
			data_parsed = JSON.parse(data)
			nbs = data_parsed["notebooks"]

			matches_html = filter(nbs) do (_jl, nbdata)
				lowercase(nbdata["html_path"]) == lowercase(htmlpath_relative)
			end

			jlpath_relative = only(keys(matches_html))
			notebook_data = only(values(matches_html))
			
			return (
				json_url=newurl,
				json_data=data_parsed,
				htmlpath_relative,
				jlpath_relative,
				notebook_data,
			)
		end
	end
	error("Not found. Are you sure that this website is generated with PlutoSliderServer or PlutoPages?")
end

# ╔═╡ 9567de35-7d0f-4d38-b736-e094124acbd9
turtles = "https://featured.plutojl.org/basic/turtles-art.html"

# ╔═╡ 053cd106-2161-4bd7-a8e0-5b13ff920bb7
get(turtles)

# ╔═╡ 8dfbcc63-6889-4305-aab2-65781a9b7f71
frj = find_root_json(turtles)

# ╔═╡ 23c30c43-8562-479f-bbaa-89820f5f6f76
frj.notebook_data["frontmatter"] |> JSON.json |> Text

# ╔═╡ e05ba76b-c377-4adf-b07f-755400c6dc17
start_url = turtles

# ╔═╡ a80e1603-50b6-4bae-9e32-daaf0a499a3d
url = URIs.URI(start_url)

# ╔═╡ fc4babaf-9b37-4afa-bf01-fcde2a427bdc
url.path

# ╔═╡ b8d82767-73aa-4b57-9e7e-f950cbbd7f6e
split(url.path, "/")

# ╔═╡ 802e7131-c0ab-40f7-b4ca-36c4f23fd909
function embed_pluto_notebook_from_index(just_an_html_path::String)
	result = find_root_json(turtles)
	
	Markdown.MD([
		Markdown.Paragraph("Use this instead:")
		Markdown.Code("julia", "embed_pluto_notebook_from_index(\n\t$(repr(string(result.json_url))),\n)")
	])
end

# ╔═╡ 57ac49b5-1af6-4f6c-9387-d7b0ec14fef6
function embed_pluto_notebook_from_index(
	root_site,
	
)
	



end

# ╔═╡ 680a3ac2-24cc-47a5-9296-02f9285eb035
embed_pluto_notebook_from_index(
	"https://featured.plutojl.org/basic/Basic%20mathematics.jl"
)

# ╔═╡ 4f36f892-21d1-45c7-8dd8-3ff45bc85d35
# embed_pluto_notebook(; 
# 	notebook_id="a9823594-1137-11f0-1703-6550d1b2018d"
# )

# ╔═╡ cc371cbf-d950-40c9-8565-a74bcf79789e
md"""
And here is a live Pluto notebook:
"""

# ╔═╡ 0949c4ec-7c3b-4b01-84f9-8bf92ed3f343
md"""
Here is a featured notebook!
"""

# ╔═╡ 7593ee37-2c14-4ba1-b572-1cc69983b1e2
function fancyu

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Downloads = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
JSON = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
URIs = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"

[compat]
HypertextLiteral = "~0.9.5"
JSON = "~0.21.4"
URIs = "~1.5.2"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.5"
manifest_format = "2.0"
project_hash = "f96551a99760e1dbed512c7e97edca5503e2d882"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.2"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"
version = "1.11.0"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.6.0+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
version = "1.11.0"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.6+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"
version = "1.11.0"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.12.12"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tricks]]
git-tree-sha1 = "6cae795a5a9313bbb4f60683f7263318fc7d1505"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.10"

[[deps.URIs]]
git-tree-sha1 = "cbbebadbcc76c5ca1cc4b4f3b0614b3e603b5000"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.2"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"
version = "1.11.0"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.59.0+0"
"""

# ╔═╡ Cell order:
# ╠═ba18da98-1085-11f0-2ce3-933581feb6e5
# ╠═7bd18f3b-6ac1-4da6-aeb4-22499b1715a8
# ╠═427de4b4-8731-4181-a09b-efcc408cb29e
# ╠═09c22e1f-8695-4e10-a70a-0c08b1c4c922
# ╠═bb618eee-6733-44d0-b1bd-c6b0cd544993
# ╠═5f03b0ab-1f8f-459b-a0e5-b3b946bd6323
# ╠═0fa9ed99-b2fd-4149-96d2-7478020d66bf
# ╠═053cd106-2161-4bd7-a8e0-5b13ff920bb7
# ╠═d1167a2e-a336-4dce-8cf2-2b9b78b6229e
# ╠═9adb42b4-6ee0-4132-b5f1-4ae3e618d230
# ╠═8dfbcc63-6889-4305-aab2-65781a9b7f71
# ╠═23c30c43-8562-479f-bbaa-89820f5f6f76
# ╠═9567de35-7d0f-4d38-b736-e094124acbd9
# ╠═e05ba76b-c377-4adf-b07f-755400c6dc17
# ╠═a80e1603-50b6-4bae-9e32-daaf0a499a3d
# ╠═fc4babaf-9b37-4afa-bf01-fcde2a427bdc
# ╠═b8d82767-73aa-4b57-9e7e-f950cbbd7f6e
# ╠═802e7131-c0ab-40f7-b4ca-36c4f23fd909
# ╠═57ac49b5-1af6-4f6c-9387-d7b0ec14fef6
# ╠═680a3ac2-24cc-47a5-9296-02f9285eb035
# ╠═4f36f892-21d1-45c7-8dd8-3ff45bc85d35
# ╟─cc371cbf-d950-40c9-8565-a74bcf79789e
# ╟─0949c4ec-7c3b-4b01-84f9-8bf92ed3f343
# ╠═7593ee37-2c14-4ba1-b572-1cc69983b1e2
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
