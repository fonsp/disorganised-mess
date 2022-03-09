### A Pluto.jl notebook ###
# v0.18.1

using Markdown
using InteractiveUtils

# ╔═╡ a3516ccc-9f1c-11ec-2eb1-edafbf215529
using Downloads

# ╔═╡ a9fa19b4-3127-4f6d-99a5-bbdc11f0ad3e
using JSON

# ╔═╡ 558432cf-a471-4519-ac35-5b8c79630d03
using BenchmarkTools

# ╔═╡ 297d4e59-afa8-4d00-9270-a96baa7e5efd
md"""
# Fetch.jl: *a simple HTTP request function*
### inspired by `fetch` from JS


"""

# ╔═╡ 9c26f455-266e-40aa-836f-e9e4258233bd
md"""
You can use Fetch.jl to request something from the web:
"""

# ╔═╡ be620b3c-dc9f-441e-9298-e653f085645e


# ╔═╡ dcaf3b5d-494c-45ec-858c-1fff28aec97f
md"""
## Response

The `fetch` function returns a special object, a `FetchResponse`, containing the response status and headers.
"""

# ╔═╡ a18adf27-e71c-46bb-b121-04b73ace6326


# ╔═╡ bf44f90e-453c-421b-ad0a-c7678b8e50e3
md"""
### Reading data
You can use `.json()`, `.text()` or `.arrayBuffer()` to read the response data. Let's read the response as JSON:
"""

# ╔═╡ 8bddd66f-76ed-448c-aea3-8145aafb2dfb
md"""
Each response can only be read once. Reading it a second time will raise an error:
"""

# ╔═╡ 893edb29-6694-4ac6-996c-74b6fc3a6fed


# ╔═╡ 866ab521-6c8a-46d4-9bb0-30098a6dc925
md"""
There are three ways to read a response:
"""

# ╔═╡ 40095c59-1f50-4be9-8717-00ee3dcbbd94


# ╔═╡ 591873a2-5ab3-4cba-8783-90800badd655
md"""
## Request
Besides *getting* data from a URL, you can also make requests with a `body`. Here is an example of a `POST` request:
"""

# ╔═╡ 6a992506-1875-4359-8460-bd4e17839570


# ╔═╡ 8ae55444-5923-45ba-9818-6125ebfaae5e
md"""
# Implementation
"""

# ╔═╡ e7f085e1-0b61-4013-90da-b61c100a41ec
md"""
## Reading response data
"""

# ╔═╡ 13804114-9b8f-4612-a3b1-26138341490b
body_data(x::AbstractVector{UInt8}) = x

# ╔═╡ a90b7d4f-267d-4fd5-b9fa-082c0482c2d5
body_data(x::AbstractString) = codeunits(x)

# ╔═╡ 90042d71-125c-46b4-b022-b7a62eff4a0b
md"""
### Examples
"""

# ╔═╡ 1edbbdae-58fa-4484-b9f8-9f721175de98
const url_uuid = "https://httpbin.org/uuid"

# ╔═╡ f8ddb016-4756-452a-973b-5e9e72f5f2fc
const url_npm_react = "https://registry.npmjs.org/react"

# ╔═╡ 9b275116-0746-4045-b5f3-ed2fc910eb5e
r = request(url_uuid)

# ╔═╡ fcc82da3-da5c-4c19-9a50-0d9103406ccc


# ╔═╡ 77736f63-ce68-44f7-8802-fffcc4a14ee7
md"""
## Multipart form data
"""

# ╔═╡ e8283b18-0333-4a52-961e-f8ff08b174c7
import HTTP

# ╔═╡ 1ed6f599-0b91-4672-9d1d-05211f176997
Base.@kwdef struct FormFile
	data
	name
	contenttype
	filename
end

# ╔═╡ c999bedb-0379-481b-9f5b-d6e9d0539118
function read_form_data(r)
	fs = HTTP.parse_multipart_form(
		HTTP.Request(
			"GET", 
			"http://asfd.com", 
			r.headers, 
			r.body
		)
	)

	map(fs) do f
		FormFile(;
			data = take!(f.data),
			name = f.name,
			filename = f.filename,
			contenttype = f.contenttype,
		)
	end
end

# ╔═╡ 071b58a2-6acc-478b-bd44-ce91f625c027
function handle_getproperty(r, name)
	function with_use_body(f)
		function()
			ref = getfield(r, :bodyUsed_ref)
			@assert !ref[] "Body stream has already been read."
			ref[] = true
			f()
		end
	end
	
	if name === :json
		with_use_body() do
			JSON.parse(String(r.body))
		end
	elseif name === :text
		with_use_body() do
			String(r.body)
		end
	elseif name === :arrayBuffer
		with_use_body() do
			r.body
		end
	elseif name === :formData || name === :formdata
		with_use_body() do
			read_form_data(r)
		end
	elseif name === :bodyUsed
		getfield(r, :bodyUsed_ref)[]
	else
		getfield(r, name)
	end
end

# ╔═╡ 7ce81c80-d63b-44e4-a1f8-ea457c0ed14c
begin
	Base.@kwdef struct FetchResponse
		url::String
		body::Vector{UInt8}
		bodyUsed_ref::Ref{Bool}=Ref(false)
		status::Int
		statusText::String=""
		headers :: Vector{Pair{String,String}}
	
		ok::Bool=true
		redirected::Bool=false
	end
	function Base.getproperty(r::FetchResponse, name::Symbol)
		handle_getproperty(r, name)
	end
end

# ╔═╡ 9e2005e9-2ce2-41d2-82fa-f46ab716e4a0
function fetch(url;
	method=nothing,
	headers=Pair{String,String}[],
	body::Union{Nothing,AbstractVector{UInt8},AbstractString}=nothing,
	# credentials=nothing,
	# cache=nothing,
	# redirect=nothing,
	# referrer,
	# referrerPolicy,
	# integrity,
	# keepalive
	# signal
)
	has_input = body !== nothing
	input = has_input ? IOBuffer(body_data(body); write=false, append=false, read=true) : nothing
	output = IOBuffer()
	
	result = request(url;
		method,
		headers,
		input,
		output,
	)

	FetchResponse(;
		url,
		body=take!(output),
		status=result.status,
		statusText=result.message,
		headers=result.headers,
	)
end

# ╔═╡ ff133dd6-d50f-43a3-abd9-a6bd24c1467f
fetch("https://api.github.com/users/JuliaLang").json()

# ╔═╡ 66d5d86a-2cc3-4076-a944-c739b89bbc00
response = fetch("https://api.github.com/users/JuliaLang")

# ╔═╡ 7437bcfb-3f04-4496-a11e-1d849571f4a5
response.status

# ╔═╡ 8d077631-9597-405a-a287-53ed81c7f044
response.headers

# ╔═╡ 9a68e78e-6683-41de-8c95-8d9fa359d4c2
response.json()

# ╔═╡ 79b14e65-c234-46dd-9255-892033f8b842
response.json()

# ╔═╡ 2c65145f-9f60-4527-94e9-b69bec938ea5
fetch("https://api.github.com/users/JuliaLang").json()

# ╔═╡ 4e66c73e-3e61-4f6f-abd9-c6c2d6b4cb7b
fetch("https://api.github.com/users/JuliaLang").text()

# ╔═╡ 599609e9-82ac-4b0c-8195-84a024c13f35
fetch("https://api.github.com/users/JuliaLang").arrayBuffer()

# ╔═╡ 0deb6ad0-85b4-4a58-ab84-03291d73ba1e
fetch(
	"https://httpbin.org/post"; 
	method="POST",
	body="hello!", 
).json()

# ╔═╡ 95749001-ca30-4c1c-a00f-362cb365f92f
rm1.

# ╔═╡ 3e579c29-3a35-40f5-8f2b-91362aad520b
const mpt = replace("""

--WebKitFormBoundary
Content-Disposition: form-data; name="text"

invoice_text
--WebKitFormBoundary
Content-Disposition: form-data; name="title"

invoice_title
--WebKitFormBoundary
Content-Disposition: form-data; name="invoice"; filename="invoice.pdf"
Content-Type: application/pdf

$(String(rand(UInt8, 50)))
--WebKitFormBoundary--
""", "\n" => "\r\n")

# ╔═╡ 01408935-8a77-4953-9467-43445cf2759b
rm = HTTP.parse_multipart_form(HTTP.Request("GET", "http://asfd.com", ["Content-Type" => "multipart/form-data; boundary=WebKitFormBoundary"], mpt))

# ╔═╡ 8c6b3ae6-3d51-440a-8986-3d58bb93ccf6
rm1 = rm[3]

# ╔═╡ c1811857-9cc4-43fe-81b3-7d473be00cd2
take!(rm1.data)

# ╔═╡ 0fff3a13-a082-4ba8-8592-b67d2251ce50
methods(HTTP.parse_multipart_form)

# ╔═╡ 5b55d5a5-d552-4652-94ff-9307b2ad615c
md"""
# Experiments
"""

# ╔═╡ e50efbc3-f23f-473b-8594-12a5e87c93d4
let
	io = IOBuffer(; maxsize=100)

	xs = zeros(Int, 10000)

	r = request(url_npm_react;
		output=io
	)
	for i in eachindex(xs)
		xs[i] = io.ptr
	end
	xs
end

# ╔═╡ a7495352-6735-42f6-b6ac-99b55f0b6682
function f1(url)
	pipe = Pipe()
    Base.link_pipe!(pipe; reader_supports_async = true, writer_supports_async = true)
	json_task = @async JSON.parse(read(pipe, String))
	request(url;
		output=pipe.in,
	)
	
	fetch(json_task)
end

# ╔═╡ 815d9ffe-6b4e-476e-b9dc-39a555318989
function f2(url)
	
	s = sprint() do io
		request(url;
			output=io,
		)
	end

	JSON.parse(s)
end

# ╔═╡ fc94db36-1764-4ac8-b5ee-3d3f7444ea90
@time f2(url_uuid)

# ╔═╡ 8f5fe53f-b151-4e79-9a99-08bc0481c99e
@time f1(url_uuid)

# ╔═╡ 139c8c41-e680-4733-8366-7244575803bb
@time f2(url_npm_react)

# ╔═╡ e8dab683-ff44-40f9-9c15-a3ccb9d1ed7a
@time f1(url_npm_react)

# ╔═╡ 219ea902-8cf0-4dde-b3a6-50f45c0da333
sprint() do io
	request(url_uuid;
		output=io
		)
end

# ╔═╡ 049d1b0d-16ed-45b8-97ce-8d039332302a
md"""
# `JSON.parse(io::IO)` benchmark

Some benchmarks with [https://github.com/JuliaIO/JSON.jl/issues/339](https://github.com/JuliaIO/JSON.jl/issues/339) as conclusion.
"""

# ╔═╡ 9a42016b-eddf-4c79-aea3-bb3cef8fdd36
j1(io) = JSON.parse(read(io, String))

# ╔═╡ 291f4ee1-6e84-4994-9ffc-98447a05458b
j2(io) = JSON.parse(io)

# ╔═╡ 876d4f01-f7f7-49e4-8d29-34f4c9d381f2
nrs = sprint() do io
	request(url_npm_react;
		output=io,
	)
end

# ╔═╡ 2e7d4d51-1f47-4627-b292-940f22cff03f
@benchmark let
	io = IOBuffer()
	write(io, $nrs)
	seekstart(io)
	r = j1(io)
	close(io)
	r
end

# ╔═╡ c5730593-ee9d-444a-a2ea-7b2734ac5b64
@benchmark let
	io = IOBuffer()
	write(io, $nrs)
	seekstart(io)
	r = j2(io)
	close(io)
	r
end

# ╔═╡ bf55bbb7-672a-477b-b5ec-b5a57c5e5098
@which JSON.parse(stdin)

# ╔═╡ 1a6d9b08-c1b8-487b-9b9d-a987661e620a
@which JSON.parse("asdf")

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
BenchmarkTools = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
Downloads = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
HTTP = "cd3eb016-35fb-5094-929b-558a96fad6f3"
JSON = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"

[compat]
BenchmarkTools = "~1.3.1"
HTTP = "~0.9.17"
JSON = "~0.21.3"
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

[[deps.BenchmarkTools]]
deps = ["JSON", "Logging", "Printf", "Profile", "Statistics", "UUIDs"]
git-tree-sha1 = "4c10eee4af024676200bc7752e536f858c6b8f93"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.3.1"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "0fa77022fe4b511826b39c894c90daf5fce3334a"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.17"

[[deps.IniFile]]
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "Random", "Sockets"]
git-tree-sha1 = "1c38e51c3d08ef2278062ebceade0e46cefc96fe"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.0.3"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "85b5da0fa43588c75bb1ff986493443f821c70b7"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.2.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Profile]]
deps = ["Printf"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
"""

# ╔═╡ Cell order:
# ╟─297d4e59-afa8-4d00-9270-a96baa7e5efd
# ╟─9c26f455-266e-40aa-836f-e9e4258233bd
# ╠═ff133dd6-d50f-43a3-abd9-a6bd24c1467f
# ╟─be620b3c-dc9f-441e-9298-e653f085645e
# ╟─dcaf3b5d-494c-45ec-858c-1fff28aec97f
# ╠═66d5d86a-2cc3-4076-a944-c739b89bbc00
# ╠═7437bcfb-3f04-4496-a11e-1d849571f4a5
# ╠═8d077631-9597-405a-a287-53ed81c7f044
# ╟─a18adf27-e71c-46bb-b121-04b73ace6326
# ╟─bf44f90e-453c-421b-ad0a-c7678b8e50e3
# ╠═9a68e78e-6683-41de-8c95-8d9fa359d4c2
# ╟─8bddd66f-76ed-448c-aea3-8145aafb2dfb
# ╠═79b14e65-c234-46dd-9255-892033f8b842
# ╟─893edb29-6694-4ac6-996c-74b6fc3a6fed
# ╟─866ab521-6c8a-46d4-9bb0-30098a6dc925
# ╠═2c65145f-9f60-4527-94e9-b69bec938ea5
# ╠═4e66c73e-3e61-4f6f-abd9-c6c2d6b4cb7b
# ╠═599609e9-82ac-4b0c-8195-84a024c13f35
# ╟─40095c59-1f50-4be9-8717-00ee3dcbbd94
# ╟─591873a2-5ab3-4cba-8783-90800badd655
# ╠═0deb6ad0-85b4-4a58-ab84-03291d73ba1e
# ╟─6a992506-1875-4359-8460-bd4e17839570
# ╟─8ae55444-5923-45ba-9818-6125ebfaae5e
# ╠═a3516ccc-9f1c-11ec-2eb1-edafbf215529
# ╠═9e2005e9-2ce2-41d2-82fa-f46ab716e4a0
# ╠═7ce81c80-d63b-44e4-a1f8-ea457c0ed14c
# ╟─e7f085e1-0b61-4013-90da-b61c100a41ec
# ╠═a9fa19b4-3127-4f6d-99a5-bbdc11f0ad3e
# ╠═071b58a2-6acc-478b-bd44-ce91f625c027
# ╠═13804114-9b8f-4612-a3b1-26138341490b
# ╠═a90b7d4f-267d-4fd5-b9fa-082c0482c2d5
# ╟─90042d71-125c-46b4-b022-b7a62eff4a0b
# ╠═1edbbdae-58fa-4484-b9f8-9f721175de98
# ╠═f8ddb016-4756-452a-973b-5e9e72f5f2fc
# ╠═9b275116-0746-4045-b5f3-ed2fc910eb5e
# ╠═fcc82da3-da5c-4c19-9a50-0d9103406ccc
# ╟─77736f63-ce68-44f7-8802-fffcc4a14ee7
# ╠═e8283b18-0333-4a52-961e-f8ff08b174c7
# ╠═1ed6f599-0b91-4672-9d1d-05211f176997
# ╠═c999bedb-0379-481b-9f5b-d6e9d0539118
# ╠═01408935-8a77-4953-9467-43445cf2759b
# ╠═8c6b3ae6-3d51-440a-8986-3d58bb93ccf6
# ╠═95749001-ca30-4c1c-a00f-362cb365f92f
# ╠═c1811857-9cc4-43fe-81b3-7d473be00cd2
# ╠═3e579c29-3a35-40f5-8f2b-91362aad520b
# ╠═0fff3a13-a082-4ba8-8592-b67d2251ce50
# ╟─5b55d5a5-d552-4652-94ff-9307b2ad615c
# ╠═e50efbc3-f23f-473b-8594-12a5e87c93d4
# ╠═a7495352-6735-42f6-b6ac-99b55f0b6682
# ╠═815d9ffe-6b4e-476e-b9dc-39a555318989
# ╠═fc94db36-1764-4ac8-b5ee-3d3f7444ea90
# ╠═8f5fe53f-b151-4e79-9a99-08bc0481c99e
# ╠═139c8c41-e680-4733-8366-7244575803bb
# ╠═e8dab683-ff44-40f9-9c15-a3ccb9d1ed7a
# ╠═219ea902-8cf0-4dde-b3a6-50f45c0da333
# ╟─049d1b0d-16ed-45b8-97ce-8d039332302a
# ╠═9a42016b-eddf-4c79-aea3-bb3cef8fdd36
# ╠═291f4ee1-6e84-4994-9ffc-98447a05458b
# ╠═876d4f01-f7f7-49e4-8d29-34f4c9d381f2
# ╠═558432cf-a471-4519-ac35-5b8c79630d03
# ╠═2e7d4d51-1f47-4627-b292-940f22cff03f
# ╠═c5730593-ee9d-444a-a2ea-7b2734ac5b64
# ╠═bf55bbb7-672a-477b-b5ec-b5a57c5e5098
# ╠═1a6d9b08-c1b8-487b-9b9d-a987661e620a
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
