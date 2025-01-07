### A Pluto.jl notebook ###
# v0.20.4

using Markdown
using InteractiveUtils

# ╔═╡ 76ec430d-3c01-4545-8be3-e82528257c33
using CSV, DataFrames

# ╔═╡ b5ab10a0-d0c1-477e-8985-8cfbbc38fc6b
using Dates

# ╔═╡ 9b80c3d6-ed15-499f-806b-6fa1091c417a
using HypertextLiteral

# ╔═╡ 3a1d6c48-87d5-4278-8699-9d8182d1762c
using AbstractPlutoDingetjes

# ╔═╡ 464672aa-cc48-11ef-3173-9bb6140273d2
url1 = "https://gml.noaa.gov/webdata/ccgg/trends/co2/co2_mm_mlo.csv"

# ╔═╡ 55d66238-68c1-4c7a-8159-f411fa663260
url2 = "https://gml.noaa.gov/webdata/ccgg/trends/co2/co2_daily_mlo.csv"

# ╔═╡ 1e735495-ef76-433a-b3a4-dd787fa4f669
Text(read(download(url2), String))

# ╔═╡ 3525308c-a7d7-4373-8826-f5a46a21c42a
d = CSV.read(download(url1), DataFrame; comment="#")

# ╔═╡ 063d8376-2c3b-4d74-abe8-582fe6bd9d1d
d2 = CSV.read(download(url2), DataFrame; comment="#", header=0)

# ╔═╡ cdfa1d2a-baa0-4831-a6b1-69385efa8eb3
dates = [Date(x[1], x[2], x[3]) for x in eachrow(d2)]

# ╔═╡ 3e91edb7-3a29-4288-b8e0-826296e06d20
vals = [x[5] for x in eachrow(d2)]

# ╔═╡ 0c89c8ad-7ee9-4dcf-8bc3-f3a1bf3f73a4
# line(dates, vals)

# ╔═╡ 37c1b129-f631-472a-bba8-9e4766d5739f
md"""
IDEA! when you pass in props that observablehq does not know but they exist in Plots/makie then we can show hints

like markersize, xlabel, xlims
"""

# ╔═╡ 94eaf0e3-d846-4292-801e-0ce82f1c8068


# ╔═╡ 9125e779-2903-40bc-b2f0-57864f4defd2


# ╔═╡ 1c572aae-a17e-4e4f-9d61-b3ab6644c26d


# ╔═╡ 654fe84c-783f-421e-9680-85ab2435f5b6
data = rand(100) .+ 2

# ╔═╡ 7f5f021b-60c6-4c2c-8bac-3c2167e01d9b


# ╔═╡ b525618d-5a79-4264-928c-a2b3999c10b6
@htl """
<script>

console.$(:log)(123)
</script>
"""

# ╔═╡ 9621d75f-5d2c-4893-82b3-0f9d05365352
# function PlotFunk(funkname::String, data, options)
# 	ObservableMarkLiteral(@jssnippet("""
# 		Plot.dotY(
# 			$(smart_embed_data(data)),
# 			$(options),
# 		)
# 		"""))

# ╔═╡ a2527c0e-dd8b-4f5e-a8a6-41c0abda969f


# ╔═╡ 5a39fc10-b3f9-499d-84ed-d7d8183688c5


# ╔═╡ 1f4b6b7d-48b3-422e-b353-0fa7da29f347


# ╔═╡ c09ef127-d5fb-4707-a821-d7b07b12dd8e
# z = @htl """

# <script>
# alert($(AbstractPlutoDingetjes.Display.published_to_js([1,2,3])))
# </script>
# """

# ╔═╡ 4e5cc5d3-fe3a-460a-86ff-2dd229455bee
# AAA(z)

# ╔═╡ 65925c20-4dc8-458d-a28f-31e96215fb71


# ╔═╡ 8715a978-d98b-42db-8a60-7a079af03068
# begin
# 	struct AAA
# 		x
# 	end


# 	function Base.show(io::IO, m::MIME"text/html", aa::AAA)
# 		h = repr(m, aa.x; context=io)
# 		write(io, h)
# 	end

# end

# ╔═╡ ad9dcac4-1381-479d-881d-b8cc2807aba8
"The same as `IOContext(io)` but this one actually works. The implementation from Base only keeps the `:color` field..."
function context_from_anything(io::IO)
	IOContext(io, (k => get(io, k, nothing) for k in keys(io))...)
end

# ╔═╡ ab5f5fab-7fde-4051-930c-91705fc4f924
context_from_anything(stdout)

# ╔═╡ 5682442b-8010-42e1-8a28-d0c348435bc1
begin
	struct RenderWithoutScriptTags
		x
	end

	function Base.show(io::IO, m::MIME"text/javascript", r::RenderWithoutScriptTags)
		full_result = repr(MIME"text/html"(), r.x; context=context_from_anything(io))
		write(io, full_result[1+length("<script>"):end-length("</script>")])
	end

	# function Base.show(io::IO, m::MIME"text/javascript", rs::AbstractVector{RenderWithoutScriptTags})
	# 	write(io, "[")
	# 	for r in rs
	# 		show(io, m, r)
	# 		write(",")
	# 	end
	# 	write(io, "]")
	# end
end

# ╔═╡ 9aef723c-597c-4b99-ae57-85af4b48c48a
begin


	abstract type ObservableMark end


	

	
	
	struct ObservableMarkLiteral <: ObservableMark
		x
	end

	get_js_content(oml::ObservableMarkLiteral) = oml.x

	
	
	Base.@kwdef struct ObservablePlot
		options=Dict{String,Any}()
		marks::Vector{ObservableMark}=[]
	end

	function Base.show(io::IO, m::MIME"text/html", p::ObservableMark)
		Base.show(io, m, ObservablePlot(marks=[p]))
	end

	function Base.show(io::IO, m::MIME"text/html", p::ObservablePlot)
		Base.show(io, m, @htl """
		<div>
		
		<script id="yolo">
		
		
		const Plot = this?.plotlib ?? await import("https://cdn.jsdelivr.net/npm/@observablehq/plot@0.6/+esm");
		
		
		const plot = Plot.plot({
			...$(p.options),
			marks: $(get_js_content.(p.marks)),
		})

		
		const div = this ?? document.createElement("div")
		div.innerHTML = ""
		div.append(plot);

		div.plotlib = Plot
		return div
		
		</script>
		</div>
		
		""")
	end
end

# ╔═╡ 507168a9-54ea-49c5-90a3-ef78d795b4d3
function plot(marks...; options...)
	ObservablePlot(; marks=collect(marks), options)
end

# ╔═╡ 3fd6a26e-d41a-4ee5-91c2-c6db632e4020
esc_if_needed(x::String) = x

# ╔═╡ 80fb577e-3146-4b78-add3-4449c8f60249
esc_if_needed(x) = esc(x)

# ╔═╡ a7a9904a-902d-4cd5-9f90-14553346d44e
macro jsl(str_expr)
	QuoteNode(str_expr)

	quote
		result = @htl( $(
			if str_expr isa String
				Expr(:string, "<script>", str_expr, "</script>")
			else
				Expr(:string, "<script>", esc_if_needed.(str_expr.args)..., "</script>")
			end
		) )
		RenderWithoutScriptTags(result)
	end

end

# ╔═╡ 0f32d85d-bdd9-4298-bc68-f053d664e0cf
begin
	smart_embed_data(x) = x
	smart_embed_data(xs::Vector{<:TimeType}) = AbstractPlutoDingetjes.Display.published_to_js(convert.(DateTime, xs))
	function smart_embed_data(xs::Vector{Float64})
		if length(xs) > 10_000
			@jsl("Array.from($(AbstractPlutoDingetjes.Display.published_to_js(xs)))")
		else
			xs
		end
	end

	function smart_embed_data(z::Iterators.Zip)
		@jsl """(() => {
			const flat = $(smart_embed_data.(z.is))
			return _.zip(...flat)
		})()"""
	end
end

# ╔═╡ 738ae819-0eb4-4b1b-8f2e-3dea846bee88
function tidy(args...)
	@jsl """(() => {
		const flat = $(smart_embed_data.(args))
		return _.zip(...flat)
	})()"""
end

# ╔═╡ 3c58352f-ecc3-4d8e-bf9a-00c97141cd0c
tidy(x=[1,2])

# ╔═╡ 0dfb97b7-eb0e-47d6-8a81-30bbaeb88a49
function line(xs, ys; options...)
	ObservableMarkLiteral(@jsl("""
		(() => {
			const xs = $(smart_embed_data(xs))
			const ys = $(smart_embed_data(ys))
			return Plot.line(
				xs, 
				{x: (d,i)=>xs[i], y: (d,i)=>ys[i], ...$(options)},
			)
		})()
		"""))
	
end

# ╔═╡ bb098f9f-420c-442c-b032-cda2e840bfa3
function lineY(ys; options...)
	ObservableMarkLiteral(@jsl("""
		Plot.lineY(
			$(smart_embed_data(ys)), 
			$(options),
		)
		"""))
	
end

# ╔═╡ 468ca161-92f6-4f51-b1fb-7d3a14ca47b4
lineY(vals; tip=true)

# ╔═╡ c8224122-8307-46e4-85c9-82ed6591ba5b
lineY(vals; x=smart_embed_data(dates))

# ╔═╡ 59e975de-118b-4cf2-9c9c-5cdbfdb2d9a5
function dot(data; options...)
	ObservableMarkLiteral(@jsl("""
		Plot.dot(
			$(smart_embed_data(data)),
			$(options),
		)
		"""))
end

# ╔═╡ 9a4b7cd3-c436-48ca-9d61-214f76b217fe
plot(
	line(dates[1:100], vals[1:100]; curve="catmull-rom",),
	dot(dates[1:100], vals[1:100]; tip=true);
	
	y=(
		grid=true,
		transform=@jsl("x => x*2"),
	),
)

# ╔═╡ 32c9e066-d734-4226-bcf9-c8f2e9aa01e0
dot(zip(dates, vals))

# ╔═╡ 46f2855a-0def-4a75-aaa2-ffe1ae7fdc0e
function dotY(data; options...)
	ObservableMarkLiteral(@jsl("""
		Plot.dotY(
			$(smart_embed_data(data)),
			$(options),
		)
		"""))
end

# ╔═╡ 6a13b7fe-f12c-4518-a1df-9bbd55174765
let
	plot(
		dotY(data; ),
		lineY(data; tip=true),
		# line([data..., data...]),
	;
		# x=(domain=[100,0],),

		x=(label="YayYY!",),
		
		# y=(type="log",),
		# aspectRatio=.1,
		height=200,
	)
end

# ╔═╡ 1576f9f3-74d0-4c70-8e33-8a54ec79e4f8
dotY(data; x=eachindex(data))

# ╔═╡ 53b1e43e-ec6e-4f88-b234-d0c4b098b418
Text(@jsl "x => x+1")

# ╔═╡ aacb83e7-e509-4260-9f23-d4c403cc2559
Text(@jsl "x => x+$(1+1)")

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
AbstractPlutoDingetjes = "6e696c72-6542-2067-7265-42206c756150"
CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
Dates = "ade2ca70-3891-5945-98fb-dc099432e06a"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"

[compat]
AbstractPlutoDingetjes = "~1.3.2"
CSV = "~0.10.15"
DataFrames = "~1.7.0"
HypertextLiteral = "~0.9.5"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.2"
manifest_format = "2.0"
project_hash = "62b7deec49b42ee7207be3ec7f140653014de381"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.2"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
version = "1.11.0"

[[deps.CSV]]
deps = ["CodecZlib", "Dates", "FilePathsBase", "InlineStrings", "Mmap", "Parsers", "PooledArrays", "PrecompileTools", "SentinelArrays", "Tables", "Unicode", "WeakRefStrings", "WorkerUtilities"]
git-tree-sha1 = "deddd8725e5e1cc49ee205a1964256043720a6c3"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.10.15"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "bce6804e5e6044c6daab27bb533d1295e4a2e759"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.6"

[[deps.Compat]]
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "8ae8d32e09f0dcf42a36b90d4e17f5dd2e4c4215"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.16.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.DataAPI]]
git-tree-sha1 = "abe83f3a2f1b857aac70ef8b269080af17764bbe"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.16.0"

[[deps.DataFrames]]
deps = ["Compat", "DataAPI", "DataStructures", "Future", "InlineStrings", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrecompileTools", "PrettyTables", "Printf", "Random", "Reexport", "SentinelArrays", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "fb61b4812c49343d7ef0b533ba982c46021938a6"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.7.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "1d0a14036acb104d9e89698bd408f63ab58cdc82"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.20"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FilePathsBase]]
deps = ["Compat", "Dates"]
git-tree-sha1 = "7878ff7172a8e6beedd1dea14bd27c3c6340d361"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.22"

    [deps.FilePathsBase.extensions]
    FilePathsBaseMmapExt = "Mmap"
    FilePathsBaseTestExt = "Test"

    [deps.FilePathsBase.weakdeps]
    Mmap = "a63ad114-7e13-5084-954f-fe012c677804"
    Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"
version = "1.11.0"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"
version = "1.11.0"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.InlineStrings]]
git-tree-sha1 = "45521d31238e87ee9f9732561bfee12d4eebd52d"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.4.2"

    [deps.InlineStrings.extensions]
    ArrowTypesExt = "ArrowTypes"
    ParsersExt = "Parsers"

    [deps.InlineStrings.weakdeps]
    ArrowTypes = "31f734f8-188a-4ce0-8406-c8a06bd891cd"
    Parsers = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
version = "1.11.0"

[[deps.InvertedIndices]]
git-tree-sha1 = "6da3c4316095de0f5ee2ebd875df8721e7e0bdbe"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.3.1"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "dda21b8cbd6a6c40d9d02a73230f9d70fed6918c"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.4.0"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.6.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"
version = "1.11.0"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.7.2+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
version = "1.11.0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
version = "1.11.0"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"
version = "1.11.0"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"
version = "1.11.0"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.6+0"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "ec4f7fbeab05d7747bdf98eb74d130a2a2ed298d"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.2.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"
version = "1.11.0"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.12.12"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.27+1"

[[deps.OrderedCollections]]
git-tree-sha1 = "12f1439c4f986bb868acda6ea33ebc78e19b95ad"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.7.0"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "Random", "SHA", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.11.0"

    [deps.Pkg.extensions]
    REPLExt = "REPL"

    [deps.Pkg.weakdeps]
    REPL = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "36d8b4b899628fb92c2749eb488d884a926614d3"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.3"

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

[[deps.PrettyTables]]
deps = ["Crayons", "LaTeXStrings", "Markdown", "PrecompileTools", "Printf", "Reexport", "StringManipulation", "Tables"]
git-tree-sha1 = "1101cd475833706e4d0e7b122218257178f48f34"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "2.4.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "712fb0231ee6f9120e005ccd56297abbc053e7e0"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.4.8"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "66e0a8e672a0bdfca2c3f5937efb8538b9ddc085"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.1"

[[deps.Statistics]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "ae3bb1eb3bba077cd276bc5cfc337cc65c3075c0"
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.11.1"

    [deps.Statistics.extensions]
    SparseArraysExt = ["SparseArrays"]

    [deps.Statistics.weakdeps]
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.StringManipulation]]
deps = ["PrecompileTools"]
git-tree-sha1 = "a6b1675a536c5ad1a60e5a5153e1fee12eb146e3"
uuid = "892a3eda-7b42-436c-8928-eab12a02cf0e"
version = "0.4.0"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "OrderedCollections", "TableTraits"]
git-tree-sha1 = "598cd7c1f68d1e205689b1c2fe65a9f85846f297"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.12.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TranscodingStreams]]
git-tree-sha1 = "0c45878dcfdcfa8480052b6ab162cdd138781742"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.11.3"

[[deps.Tricks]]
git-tree-sha1 = "7822b97e99a1672bfb1b49b668a6d46d58d8cbcb"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.9"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"
version = "1.11.0"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"

[[deps.WeakRefStrings]]
deps = ["DataAPI", "InlineStrings", "Parsers"]
git-tree-sha1 = "b1be2855ed9ed8eac54e5caff2afcdb442d52c23"
uuid = "ea10d353-3f73-51f8-a26c-33c1cb351aa5"
version = "1.4.2"

[[deps.WorkerUtilities]]
git-tree-sha1 = "cd1659ba0d57b71a464a29e64dbc67cfe83d54e7"
uuid = "76eceee3-57b5-4d4a-8e66-0e911cebbf60"
version = "1.6.1"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.11.0+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.59.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"
"""

# ╔═╡ Cell order:
# ╠═464672aa-cc48-11ef-3173-9bb6140273d2
# ╠═55d66238-68c1-4c7a-8159-f411fa663260
# ╠═1e735495-ef76-433a-b3a4-dd787fa4f669
# ╠═76ec430d-3c01-4545-8be3-e82528257c33
# ╠═3525308c-a7d7-4373-8826-f5a46a21c42a
# ╠═063d8376-2c3b-4d74-abe8-582fe6bd9d1d
# ╠═cdfa1d2a-baa0-4831-a6b1-69385efa8eb3
# ╠═3e91edb7-3a29-4288-b8e0-826296e06d20
# ╠═0c89c8ad-7ee9-4dcf-8bc3-f3a1bf3f73a4
# ╠═b5ab10a0-d0c1-477e-8985-8cfbbc38fc6b
# ╠═9b80c3d6-ed15-499f-806b-6fa1091c417a
# ╠═6a13b7fe-f12c-4518-a1df-9bbd55174765
# ╠═37c1b129-f631-472a-bba8-9e4766d5739f
# ╠═9a4b7cd3-c436-48ca-9d61-214f76b217fe
# ╠═468ca161-92f6-4f51-b1fb-7d3a14ca47b4
# ╠═c8224122-8307-46e4-85c9-82ed6591ba5b
# ╠═94eaf0e3-d846-4292-801e-0ce82f1c8068
# ╠═3c58352f-ecc3-4d8e-bf9a-00c97141cd0c
# ╠═738ae819-0eb4-4b1b-8f2e-3dea846bee88
# ╠═9125e779-2903-40bc-b2f0-57864f4defd2
# ╠═32c9e066-d734-4226-bcf9-c8f2e9aa01e0
# ╠═1c572aae-a17e-4e4f-9d61-b3ab6644c26d
# ╠═0f32d85d-bdd9-4298-bc68-f053d664e0cf
# ╠═654fe84c-783f-421e-9680-85ab2435f5b6
# ╠═507168a9-54ea-49c5-90a3-ef78d795b4d3
# ╠═3a1d6c48-87d5-4278-8699-9d8182d1762c
# ╠═7f5f021b-60c6-4c2c-8bac-3c2167e01d9b
# ╠═0dfb97b7-eb0e-47d6-8a81-30bbaeb88a49
# ╠═bb098f9f-420c-442c-b032-cda2e840bfa3
# ╠═59e975de-118b-4cf2-9c9c-5cdbfdb2d9a5
# ╠═46f2855a-0def-4a75-aaa2-ffe1ae7fdc0e
# ╠═b525618d-5a79-4264-928c-a2b3999c10b6
# ╠═1576f9f3-74d0-4c70-8e33-8a54ec79e4f8
# ╠═9621d75f-5d2c-4893-82b3-0f9d05365352
# ╠═a2527c0e-dd8b-4f5e-a8a6-41c0abda969f
# ╠═9aef723c-597c-4b99-ae57-85af4b48c48a
# ╠═5a39fc10-b3f9-499d-84ed-d7d8183688c5
# ╠═1f4b6b7d-48b3-422e-b353-0fa7da29f347
# ╠═c09ef127-d5fb-4707-a821-d7b07b12dd8e
# ╠═4e5cc5d3-fe3a-460a-86ff-2dd229455bee
# ╠═65925c20-4dc8-458d-a28f-31e96215fb71
# ╠═8715a978-d98b-42db-8a60-7a079af03068
# ╠═ad9dcac4-1381-479d-881d-b8cc2807aba8
# ╠═ab5f5fab-7fde-4051-930c-91705fc4f924
# ╠═5682442b-8010-42e1-8a28-d0c348435bc1
# ╠═53b1e43e-ec6e-4f88-b234-d0c4b098b418
# ╠═aacb83e7-e509-4260-9f23-d4c403cc2559
# ╠═a7a9904a-902d-4cd5-9f90-14553346d44e
# ╠═3fd6a26e-d41a-4ee5-91c2-c6db632e4020
# ╠═80fb577e-3146-4b78-add3-4449c8f60249
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
