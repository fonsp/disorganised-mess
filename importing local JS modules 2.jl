### A Pluto.jl notebook ###
# v0.19.38

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

# ╔═╡ 2b517038-9a33-4aa7-b33e-9835b68b68e2
using HypertextLiteral

# ╔═╡ ce9d33f2-ca7b-11ee-3907-c534f702f4c1
import AbstractPlutoDingetjes

# ╔═╡ 4d08d092-2caf-47b7-8423-b94bb07d78bf
md"""
# Loading the dependency

This should be done once, during package init.
"""

# ╔═╡ d6eb8b85-6d41-40da-8072-0198aed0e787
# this would be better if it was from an artifact
js_dep_path = download("https://esm.sh/v135/plotly.js-dist-min@2.29.1/es2022/plotly.js-dist-min.bundle.mjs")

# ╔═╡ 31859a35-9779-4165-a926-9abe574c0658
js_dep_contents = read(js_dep_path, String)

# ╔═╡ a02834ab-5a6a-4516-a2d8-9e12a8cbe176
Text("$(length(js_dep_contents) / 1e6) MB")

# ╔═╡ bb536569-d8bb-4049-9ec8-5ce32af6e27c
md"""
# Magic

We use [`AbstractPlutoDingetjes.Display.published_to_js`](https://plutojl.org/en/docs/abstractplutodingetjes/#published_to_js) to make the string available to JS running in the cell output. Inside the JS, we turn the string into a blob URL and call `import()` on that.

We create a `Map`, called `window.created_imports`, to keep track of strings that we already imported. When you re-import the same string a second time, the original import result is retured.
"""

# ╔═╡ 47873b9e-e4d3-4fd2-b5c1-912b4710c825
begin
	struct _ImportedLocalJS
		published
	end

	function Base.show(io, m::MIME"text/javascript", i::_ImportedLocalJS)
		write(io, 
			"""
			await (() => {
			window.created_imports = window.created_imports ?? new Map();
			let code = """
		)
		Base.show(io, m, i.published)

		write(io,
			""";
			if(created_imports.has(code)){
				return created_imports.get(code);
			} else {
				let blob_promise = new Promise((resolve, reject) => {
	        		const reader = new FileReader();
	        		reader.onload = async () => {
						try {
							resolve(await import(reader.result));
						} catch(e) {
							reject();
						}
					}
					reader.onerror = () => reject();
					reader.onabort = () => reject();
	        		reader.readAsDataURL(
						new Blob([code], {type : "text/javascript"}))
		    		});
					created_imports.set(code, blob_promise);
					return blob_promise;
				}
			})()
			"""
		)
	end
	

	"""
	```julia
	import_local_js(js_module_code::AbstractString)
	```

	Make the contents of an ES6 module available to JavaScript. This function uses fancy Pluto data transfer and caching to make sure that the actual module code is only downloaded and loaded once by the browser, when the same data is used (multiple times) by multiple cells.

	Use it like so:

	```julia
	HypertextLiteral.@htl(""\"
	const themodule = \$(import_local_js(js_dep_contents))
	"\"")
	```

	# What is an ES6 module?
	This function is for ES6 modules, which you would typically load with
	```js
	import {something} from "https://esm.sh/somepackage@1.2.3"

	// or in Pluto cells:
	const {something} = await import
	```

	If your library is loaded in the old-school way, then it cannot be loaded (yet) with `import_local_js`:

	```html
	<!-- Modules that you import with a <script> tag are not supported: -->
	<script src="https://cdn.plot.ly/plotly-2.29.1.min.js" charset="utf-8"></script>
	```

	If this is your case, consider using [esm.sh](esm.sh) to turn the package into an ES6 module.
	
	# Why?
	Using this function in your package (instead of just `await import("https://esm.sh/...")` in JavaScript), in combination with Artifacts.toml ensures that the module is available when viewing a Pluto notebook offline. The same is true for exported HTML documents.
	

	# Bundled
	This only works well if your ES6 module is bundled: it contains no further `import`s. 
	
	If you are working with a local JS codebase, then you could use `deno bundle` or other bundling tools to get a single JS file. If you use a package from a CDN, then see if your CDN has the option to bundle it for you. In esm, this means adding `.bundle.js` to the URL.
	

	# Example

	```julia
	js_dep_path = download("https://esm.sh/v135/plotly.js-dist-min@2.29.1/es2022/plotly.js-dist-min.bundle.mjs")
	
	js_dep_contents = read(js_dep_path, String)

	@htl("\""
	
	<script>
	
	const plotlyjs_module = \$(import_local_js(js_dep_contents))
	const plotlyjs = plotlyjs_module.default
	
	return html`
		<p>PlotlyJS version \${plotlyjs.version}</p>
	`
	</script>
	"\"")
	```
	
	"""
	function import_local_js(code::AbstractString)

		code_js = 
			try
			AbstractPlutoDingetjes.Display.published_to_js(code)
		catch e
			@warn "published_to_js did not work" exception=(e,catch_backtrace()) maxlog=1
			repr(code)
		end

		_ImportedLocalJS(code_js)
	end
end

# ╔═╡ 6da1183a-cc84-41f1-8e7c-b5d20e76563d


# ╔═╡ 5b01c9bd-bd44-4650-91ba-a492686b522d
@bind x html"<input type=range max=100000>"

# ╔═╡ 1a4a8409-6613-4507-9d36-e93a776db19b
function my_widget(x)
	@htl("""
	
	<script>
	
	const plotlyjs_module = $(import_local_js(js_dep_contents))
	const plotlyjs = plotlyjs_module.default
	
	let result = $(x)
	return html`
		<p><code>x</code> is \${result}</p>
		<p>PlotlyJS version \${plotlyjs.version}</p>
	`
	</script>
	
	""")
end

# ╔═╡ 2328495c-b4fb-4dfd-916e-1bdefc0212ea
my_widget(x)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
AbstractPlutoDingetjes = "6e696c72-6542-2067-7265-42206c756150"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"

[compat]
AbstractPlutoDingetjes = "~1.2.3"
HypertextLiteral = "~0.9.5"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.0"
manifest_format = "2.0"
project_hash = "70be3486f293846b1ddc7c639dfbf884afc3561e"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "c278dfab760520b8bb7e9511b968bf4ba38b7acc"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.3"

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

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.4.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.6.4+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

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
version = "2.28.2+1"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.1.10"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.10.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA"]
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
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Tricks]]
git-tree-sha1 = "eae1bb484cd63b36999ee58be2de6c178105112f"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.8"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.52.0+1"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"
"""

# ╔═╡ Cell order:
# ╠═ce9d33f2-ca7b-11ee-3907-c534f702f4c1
# ╠═2b517038-9a33-4aa7-b33e-9835b68b68e2
# ╟─4d08d092-2caf-47b7-8423-b94bb07d78bf
# ╠═d6eb8b85-6d41-40da-8072-0198aed0e787
# ╠═31859a35-9779-4165-a926-9abe574c0658
# ╟─a02834ab-5a6a-4516-a2d8-9e12a8cbe176
# ╟─bb536569-d8bb-4049-9ec8-5ce32af6e27c
# ╟─47873b9e-e4d3-4fd2-b5c1-912b4710c825
# ╠═6da1183a-cc84-41f1-8e7c-b5d20e76563d
# ╠═5b01c9bd-bd44-4650-91ba-a492686b522d
# ╠═2328495c-b4fb-4dfd-916e-1bdefc0212ea
# ╠═1a4a8409-6613-4507-9d36-e93a776db19b
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
