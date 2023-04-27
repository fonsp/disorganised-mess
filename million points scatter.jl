### A Pluto.jl notebook ###
# v0.19.14

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 2aa03781-5ea6-463f-b632-5315f9cefd77
using PlutoUI

# ╔═╡ ba485dba-f7e5-439d-b1a7-b8240b956052
using HypertextLiteral

# ╔═╡ a11778e1-ce31-43cd-b91d-2ea4f6af557a
@bind ms Slider(0:.01:10; default=1)

# ╔═╡ 1ed6d4c2-e356-11ec-2abe-03feb2309707
n = 1000_000

# ╔═╡ 108502ea-e957-480e-97db-66013ca533dc
x = randn(n) * .5

# ╔═╡ 5fd1fff2-1873-40d3-b94f-8eff96d1c51a
y = randn(n) * .5

# ╔═╡ 5916ea15-cc6b-4bda-9e95-d3c27fc7e7b3


# ╔═╡ fc99db75-bdba-4cf3-b18c-afb54adf023c
md"""
# Definition
"""

# ╔═╡ d8899cc8-513b-48c7-b7a8-2d8bd71d45bb
# begin
# 	Base.@kwdef struct FastScatter
# 		x::Vector{<:Real}
# 		y::Vector{<:Real}
# 		color::String="#ffffff"
# 		marker_size::Real=5
# 	end

# 	function Base.show(io::IO, m::MIME"text/html", f::FastScatter)
		
# 	show(io, m, @htl("""
# 		<div>
# 		<script id=asdfasdf>
# 		const {default: createScatterplot} = await import('https://esm.sh/regl-scatterplot@1.2.3');
		
# 		const canvas = this ?? document.createElement("canvas")
# 		canvas.style = `width: 100%; aspect-ratio: 1; border-radius: .6em;`
	
# 		currentScript.parentElement.append(canvas)
		
# 		const { width, height } = canvas.getBoundingClientRect();
		
# 		const scatterplot = canvas._scatterplot ?? createScatterplot({
# 			canvas,
# 			width,
# 			height,
# 		});
# 		scatterplot.set({
# 			pointSize: $(f.marker_size),
# 			pointColor: [$(f.color)],
# 			performanceMode: false,
# 		})
# 		canvas._scatterplot = scatterplot
	

# 		const raw_x = $(Main.PlutoRunner.publish_to_js(convert(Vector{Float32}, f.x)))
# 		const raw_y = $(Main.PlutoRunner.publish_to_js(convert(Vector{Float32}, f.y)))

# 		const points = Array.prototype.map.call(raw_x, (x,i) => [x,raw_y[i]])
# 		scatterplot.draw(points)
	
# 		/*scatterplot.draw({
# 			x: raw_x,
# 			y: raw_y,
# 			valueA: 0,
# 		});*/

# 		invalidation.then(() => {
# 			// clear memory
# 			points.length = 0
# 			//scatterplot.clear()
# 			//scatterplot.destroy()
# 		})

# 		return canvas
# 		</script>
# 		</div>
# 	"""))
# 	end
# end

# ╔═╡ efd2d320-a7d2-404b-9786-04d116d24b6e
begin
	Base.@kwdef struct FastScatter
		x::Vector{<:Real}
		y::Vector{<:Real}
		color::String="#000000"
		marker_size::Real=5
	end

	function Base.show(io::IO, m::MIME"text/html", f::FastScatter)
		
	show(io, m, @htl("""
		<div>
		<canvas style="width: 100%; aspect-ratio: 1; border-radius: .6em;"></canvas>
		<script>
		const {default: createScatterplot} = await import('https://esm.sh/regl-scatterplot@1.2.3');
		
		const canvas = currentScript.parentElement.querySelector("canvas")
		
		const { width, height } = canvas.getBoundingClientRect();
		
		const scatterplot = createScatterplot({
			canvas,
			width,
			height,
			pointSize: $(f.marker_size),
			pointColor: [$(f.color)],
			performanceMode: true,
		});

		const raw_x = $(Main.PlutoRunner.publish_to_js(convert(Vector{Float32}, f.x)))
		const raw_y = $(Main.PlutoRunner.publish_to_js(convert(Vector{Float32}, f.y)))
		const points = Array.prototype.map.call(raw_x, (x,i) => [x,raw_y[i]])
			console.log(points.length, [...points[0]])
			
		// const points = new Array(10000)
		//   .fill()
		//   .map(() => [-1 + Math.random() * 2, -1 + Math.random() * 2, 0]);
		
		scatterplot.draw(points);

			invalidation.then(() => {
				// clear memory
				points.length = 0
				scatterplot.clear()
				scatterplot.destroy()
			})
		
		</script>
		</div>
	"""))
	end
end

# ╔═╡ 50f3b397-7668-4d01-8736-452149978399
scatter(x,y; kwargs...) = FastScatter(;x, y, kwargs...)

# ╔═╡ c6ac6f31-69b6-4532-a666-3f0a4c8ccaae
scatter(x,y; marker_size=ms)

# ╔═╡ 0ba77e2c-8202-408c-b193-4b232d3458ce
# begin
# 	Base.@kwdef struct FastScatter
# 		x
# 		y
# 	end

# 	function Base.show(io::IO, m::MIME"text/html", f::FastScatter)
		
# 	show(io, m, @htl("""
# 		<div>
# 		<canvas style="width: 100%; height: 300px"></canvas>
# 		<script>
# 		const {default: createScatterplot} = await import('https://esm.sh/regl-scatterplot@1.2.3');
		
# 		const raw_x = $(Main.PlutoRunner.publish_to_js(convert(Vector{Float32}, f.x)))
# 		const raw_y = $(Main.PlutoRunner.publish_to_js(convert(Vector{Float32}, f.y)))
# 		const points = Array.prototype.map.call(raw_x, (x,i) => [x,raw_y[i],0])
# 			console.log(points.length)
		
# 		</script>
# 		</div>
# 	"""))
# 	end
# end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
HypertextLiteral = "~0.9.4"
PlutoUI = "~0.7.39"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.0"
manifest_format = "2.0"
project_hash = "76fe9282f386a17bdec28e0adfe6e55a2e4613fd"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "0f4e115f6f34bbe43c19751c90a38b2f380637b9"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.3"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "0.5.2+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

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

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.0+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.2.1"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "1285416549ccfcdf0c50d4997a94331e88d68413"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.3.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "8d1f54886b9037091edf146b517989fc4a09efec"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.39"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

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

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.12+3"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.1+0"

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
# ╠═a11778e1-ce31-43cd-b91d-2ea4f6af557a
# ╠═1ed6d4c2-e356-11ec-2abe-03feb2309707
# ╟─108502ea-e957-480e-97db-66013ca533dc
# ╠═5fd1fff2-1873-40d3-b94f-8eff96d1c51a
# ╠═c6ac6f31-69b6-4532-a666-3f0a4c8ccaae
# ╠═2aa03781-5ea6-463f-b632-5315f9cefd77
# ╟─5916ea15-cc6b-4bda-9e95-d3c27fc7e7b3
# ╟─fc99db75-bdba-4cf3-b18c-afb54adf023c
# ╠═ba485dba-f7e5-439d-b1a7-b8240b956052
# ╠═50f3b397-7668-4d01-8736-452149978399
# ╟─d8899cc8-513b-48c7-b7a8-2d8bd71d45bb
# ╠═efd2d320-a7d2-404b-9786-04d116d24b6e
# ╠═0ba77e2c-8202-408c-b193-4b232d3458ce
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
