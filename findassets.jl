### A Pluto.jl notebook ###
# v0.14.3

using Markdown
using InteractiveUtils

# ╔═╡ 4353ed5b-390c-40dd-979a-f8e839c5234f
using URIs

# ╔═╡ bcfad98a-1ba1-4557-8fdb-4cbe3000ad81
using PlutoUI

# ╔═╡ 7afb8d34-60db-4432-925b-8663437fed66
md"# asdf"

# ╔═╡ b174ad68-a3c9-11eb-04fd-531bfa823e16
import Pluto

# ╔═╡ 0070955a-3b8d-4c36-b91b-e68a5e934588
src = "editor.html"

# ╔═╡ bd3917e2-deac-4308-af81-c21274c20fab
isurl(s) = startswith(s, r"https?://")

# ╔═╡ ea52a3a7-bddf-4b18-b40f-defd7403030f
path = if isurl(src)
	download(src)
else
	Pluto.project_relative_path("frontend", src)
end

# ╔═╡ 2cbfd96f-3843-4be1-b105-f89657741398
begin
	contents = read(path, String)
	Text(contents)
end

# ╔═╡ 39a72690-2ed2-42fe-9153-2542f4d5670a
matchers = Dict(
	 "js" => r"import .*?['\"](.+?)['\"]"s,
	"mjs" => r"import .*?['\"](.+?)['\"]"s,
	"html" => r"(script|link) .*?(src|href)\=\"(.+?)\""s,
	"css" => r"url\(['\"]?(.+?)['\"]?\)"s,
)

# ╔═╡ 0059ebf7-d476-4f17-bd8a-8edb2b6083b1
filetype = splitext(src)[2][2:end]

# ╔═╡ e89281c3-1038-45bc-b287-925efcbdffc8
matcher = get(matchers, filetype, r"oiajfsdoijasoidfj")

# ╔═╡ efdd88c5-a7a3-443b-8006-0748ca6609bf
matches = eachmatch(matcher, contents) |> collect

# ╔═╡ da4f62fb-f084-4663-891e-cd273711b019
lastcapture(c) = c.captures[end]

# ╔═╡ e92c18f0-883f-4d96-9e19-a29ae03bda0d
sources = map(lastcapture, matches)

# ╔═╡ c15834bb-593b-47e7-a71a-2fde40413896
r = "http://asdfasdf/asdc/sdc/dsc/sss"

# ╔═╡ 5520ae12-88c3-431e-81ae-5cae7d95a0a5
findlast('/', r)

# ╔═╡ 46641b85-538c-4bfe-a6f9-be80e35779c0
r[1:29]

# ╔═╡ b7ddcb43-4eb7-4291-ac6c-f842d17a647a
joinpath("/a/b/c", "./x") |> normpath

# ╔═╡ 76c86df6-ab2b-479a-b5b7-a2f54822a76e
relpath

# ╔═╡ b01e0c26-9a6a-4166-8bfb-3dccdb743efe
getfiletype(src) = let
	p = isurl(src) ? URI(src).path : src
	splitext(p)[2][2:end]
end

# ╔═╡ bf2d85d1-4e49-4e3a-9186-53745ca6939d
comment_matchers = Dict(
	"css" => r"/\*.*?\*/"s,
	"html" => r"\<\!\-\-.*?\-\-\>"s,
	"mjs" => r"//.*",
	 "js" => r"//.*",
)

# ╔═╡ 8675daa8-cd40-4c67-af3c-4ea8b80e7500
function without_comments(code)
	replace(code, comment_matchers["html"] => "")
end

# ╔═╡ 8afa7481-53ff-42b7-a677-54cf6ede2e67
normuri(u) = string(URIs.absuri( URI(u).path |> normpath, URI(u)))

# ╔═╡ d9eea4e5-1c1a-41ed-9bc6-23000026c47b
function find_sources_recursive!(found::Set{String}, src::String, visited::Set{String})
	if src ∈ visited
		return found
	end
	
	push!(visited, src)
	
	filetype = getfiletype(src)
	matcher = get(matchers, filetype, nothing)
	comment_matcher = get(comment_matchers, filetype, "asfdasdfasdfasdfasdf")
	
	if matcher !== nothing
	
		path = if isurl(src)
			download(src)
		else
			@assert isabspath(src)
			src
		end

		contents = read(path, String)
		without_comments = replace(contents, comment_matcher => "")
		matches = eachmatch(matcher, without_comments)
		sources = map(lastcapture, matches)

		for s in sources
			next = if isurl(s)
				String(s)
			else
				if isurl(src)
					# ugh
					url_dir = src[1:findlast('/', src)]
					normuri(string(url_dir, s))
				else
					normpath(joinpath(dirname(src), s))
				end
			end
			push!(found, next)
			try
				find_sources_recursive!(found, next, visited)
			catch e
				@error "asdf" src next s contents exception=(e,catch_backtrace())
			end
		end
	end
	
	found
end

# ╔═╡ 6c2add9c-95fa-4e09-aed5-5f2fc2b6188f
find_sources_recursive(src) = find_sources_recursive!(Set{String}([src]), src, Set{String}())

# ╔═╡ a7b84f78-7800-4743-a178-fd5943833f40
found = find_sources_recursive(Pluto.project_relative_path("frontend", "editor.html"))

# ╔═╡ 9d002b0f-64a7-4c54-ab41-4a347936e950
remote = sort(collect(filter(isurl, found)))

# ╔═╡ Cell order:
# ╠═7afb8d34-60db-4432-925b-8663437fed66
# ╠═b174ad68-a3c9-11eb-04fd-531bfa823e16
# ╠═4353ed5b-390c-40dd-979a-f8e839c5234f
# ╠═ea52a3a7-bddf-4b18-b40f-defd7403030f
# ╠═0070955a-3b8d-4c36-b91b-e68a5e934588
# ╠═bd3917e2-deac-4308-af81-c21274c20fab
# ╠═2cbfd96f-3843-4be1-b105-f89657741398
# ╠═39a72690-2ed2-42fe-9153-2542f4d5670a
# ╠═0059ebf7-d476-4f17-bd8a-8edb2b6083b1
# ╠═e89281c3-1038-45bc-b287-925efcbdffc8
# ╠═efdd88c5-a7a3-443b-8006-0748ca6609bf
# ╠═e92c18f0-883f-4d96-9e19-a29ae03bda0d
# ╠═da4f62fb-f084-4663-891e-cd273711b019
# ╠═bcfad98a-1ba1-4557-8fdb-4cbe3000ad81
# ╠═c15834bb-593b-47e7-a71a-2fde40413896
# ╠═5520ae12-88c3-431e-81ae-5cae7d95a0a5
# ╠═46641b85-538c-4bfe-a6f9-be80e35779c0
# ╠═b7ddcb43-4eb7-4291-ac6c-f842d17a647a
# ╠═76c86df6-ab2b-479a-b5b7-a2f54822a76e
# ╠═b01e0c26-9a6a-4166-8bfb-3dccdb743efe
# ╠═d9eea4e5-1c1a-41ed-9bc6-23000026c47b
# ╠═bf2d85d1-4e49-4e3a-9186-53745ca6939d
# ╠═8675daa8-cd40-4c67-af3c-4ea8b80e7500
# ╠═6c2add9c-95fa-4e09-aed5-5f2fc2b6188f
# ╠═a7b84f78-7800-4743-a178-fd5943833f40
# ╠═9d002b0f-64a7-4c54-ab41-4a347936e950
# ╠═8afa7481-53ff-42b7-a677-54cf6ede2e67
