### A Pluto.jl notebook ###
# v0.17.2

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

# ╔═╡ d85ef8c8-09da-482b-9695-dc7ae57a4904
using Base64

# ╔═╡ 8b0e6919-8d23-4e3d-930e-f2b66bbfcff6
using PlutoUI

# ╔═╡ 71b0a294-5a77-4af1-9286-ae72362b318d
using HypertextLiteral

# ╔═╡ 34ecec7d-40ed-4c0a-9632-1decb8db41c7
md"""
# Including local JS modules
"""

# ╔═╡ 72aa797d-6dc2-4f7d-a422-5a6efa8cd405
md"""
## Sample ES6 project

Create a sample folder and populate it with some JS modules:
"""

# ╔═╡ f5dcd487-5d0a-452d-a70b-d072f9dd9159
source_folder = begin
	f = mktempdir()

	
	write(joinpath(f, "index.js"), """
		import { cool } from "./cool.js"
		import { also_cool } from "./also/cool.js"
	
		export const hello = (x) => [cool(x), also_cool(x)]
	""")
	

	write(joinpath(f, "cool.js"), """
		// I can import from URLs, they will join the bundle:
		
		import _ from "https://cdn.esm.sh/v58/lodash-es@4.17.21/es2021/lodash-es.js"
	
		export let cool = x => _.repeat("hello ", x)
	""")
	

	mkdir(joinpath(f, "also" ))
	write(joinpath(f, "also", "cool.js"), """
		export let also_cool = (x) => " world!"
	""")


	f
end

# ╔═╡ 115c30d6-1c43-4b1d-8b9c-8119caeaa8e7
readdir(f)

# ╔═╡ 8dd3a5e2-3d64-4a22-88c2-674e5caf7f13
input_file = joinpath(source_folder, "index.js")

# ╔═╡ 87fa1f5c-4f23-4ef1-9114-800ade761b75
md"""
## Bundle

Try changing the code in one of the JS files in the first section (above), and the bundler will automatically re-run!
"""

# ╔═╡ ad5c76aa-d336-4b79-9c66-507a741ae39d
import Deno_jll: deno

# ╔═╡ 1d9a16b8-9c24-4b49-bb6d-e378683d5131
bundle_code = begin
	error_file = tempname()

	try
		read(pipeline(`$(deno()) bundle $(input_file)`, stderr=error_file), String)
	catch e
		if e isa ProcessFailedException
			@htl("""
			<h4>❌ Bundle failed</h4>
			<pre><code>$(read(error_file, String))</code></pre>
			""")
		else
			rethrow(e)
		end
	end
end

# ╔═╡ 5e3de125-24fb-40b0-96f7-debad8bd65a2
md"""
## Use it inside code
"""

# ╔═╡ e25b7d66-b309-44bf-afd6-3ac4ff1dd5d2
@bind x Slider(1:1000)

# ╔═╡ 1cf23044-492b-4f97-a48d-3659f434d05c
md"""
# Magic

We use [`publish_to_js`](https://github.com/fonsp/Pluto.jl/pull/1124) to make the string available to JS running in the cell output. Inside the JS, we turn the string into a blob URL and call `import()` on that.

We create a `Map`, called `window.created_imports`, to keep track of strings that we already imported. When you re-import the same string a second time, the original import result is retured.
"""

# ╔═╡ d71abee5-6d3c-420c-b064-d3a346e197d9
function import_local_js(code::AbstractString)

	code_js = 
		try
		Main.PlutoRunner.publish_to_js(code)
	catch
		repr(code)
	end
	
	HypertextLiteral.JavaScript(
		"""
		await (() => {
		
		window.created_imports = window.created_imports ?? new Map()
		
		let code = $(code_js)

		if(created_imports.has(code)){
			return created_imports.get(code)
		} else {
			let blob_promise = new Promise((r) => {
        		const reader = new FileReader()
        		reader.onload = async () => r(await import(reader.result))
        		reader.readAsDataURL(
				new Blob([code], {type : "text/javascript"}))
    		})
			created_imports.set(code, blob_promise)
			return blob_promise
		}
		})()
		"""
	)
end

# ╔═╡ 489833d3-e9ed-4737-95f3-0a41101e5245
function my_widget(x)
	@htl("""
	
	<script>
	
	const { hello } = $(import_local_js(bundle_code))
	
	let result = hello($(x))
	return html`<span>\${result}</span>`
	</script>
	
	""")
end

# ╔═╡ 8eded271-246c-4371-8882-b0c2026b5c18
my_widget(x)

# ╔═╡ 4a37b507-8234-4948-a93a-6cdda79f5c82
md"""
## Other attempts
"""

# ╔═╡ 0b9212ec-e30a-4618-9959-014a45fe8e25
code = """
console.log("I should run only once!")

export const x = 345
"""

# ╔═╡ c3144960-5c3a-46d0-a58d-baf07179afe2
base64url = "data:text/javascript;base64,$(base64encode(code))"

# ╔═╡ 9ff0d49a-52fb-11ec-20da-2da3449ac5bc
@htl("""



<script>

const { x } = await import($(base64url))


console.log(x)



</script>



""")

# ╔═╡ 565a58b0-9db4-4a7c-8432-368f155fd2bb
code2 = """
console.log("I should run only once!")

export const x = 32
"""

# ╔═╡ 2cc41025-df03-4a1e-950c-6d91edca2eea
@htl("""
<script>

const {x} = $(import_local_js(code2))

console.log(x)

</script>
""")

# ╔═╡ 4db47392-dbb4-49ec-8c53-d5be4f0c70b3
@bind x2 Slider(1:1000)

# ╔═╡ 57a6c86a-f3c1-465e-a937-beae5ff3db10
@htl("""
<script>

const x = $(PlutoRunner.publish_to_js(x2))


return html`<span>\${x}</span>`

</script>

""")

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Base64 = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
Deno_jll = "04572ae6-984a-583e-9378-9577a1c2574d"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
Deno_jll = "~1.16.3"
HypertextLiteral = "~0.9.3"
PlutoUI = "~0.7.21"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.0"
manifest_format = "2.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "abb72771fd8895a7ebd83d5632dc4b989b022b5b"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.2"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Deno_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "244309ef7003f30c7a5fe571f6b860c6b032b691"
uuid = "04572ae6-984a-583e-9378-9577a1c2574d"
version = "1.16.3+0"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "642a199af8b68253517b80bd3bfd17eb4e84df6e"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.3.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

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

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "ae4bbcadb2906ccc085cf52ac286dc1377dceccc"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.1.2"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "b68904528fd538f1cb6a3fbc44d2abdc498f9e8e"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.21"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00cfd92944ca9c760982747e9a1d0d5d86ab1e5a"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.2"

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

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

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
# ╟─34ecec7d-40ed-4c0a-9632-1decb8db41c7
# ╟─72aa797d-6dc2-4f7d-a422-5a6efa8cd405
# ╠═f5dcd487-5d0a-452d-a70b-d072f9dd9159
# ╠═115c30d6-1c43-4b1d-8b9c-8119caeaa8e7
# ╠═8dd3a5e2-3d64-4a22-88c2-674e5caf7f13
# ╟─87fa1f5c-4f23-4ef1-9114-800ade761b75
# ╠═ad5c76aa-d336-4b79-9c66-507a741ae39d
# ╠═1d9a16b8-9c24-4b49-bb6d-e378683d5131
# ╟─5e3de125-24fb-40b0-96f7-debad8bd65a2
# ╠═e25b7d66-b309-44bf-afd6-3ac4ff1dd5d2
# ╠═8eded271-246c-4371-8882-b0c2026b5c18
# ╠═489833d3-e9ed-4737-95f3-0a41101e5245
# ╟─1cf23044-492b-4f97-a48d-3659f434d05c
# ╠═d71abee5-6d3c-420c-b064-d3a346e197d9
# ╟─4a37b507-8234-4948-a93a-6cdda79f5c82
# ╠═0b9212ec-e30a-4618-9959-014a45fe8e25
# ╠═d85ef8c8-09da-482b-9695-dc7ae57a4904
# ╠═c3144960-5c3a-46d0-a58d-baf07179afe2
# ╠═9ff0d49a-52fb-11ec-20da-2da3449ac5bc
# ╠═2cc41025-df03-4a1e-950c-6d91edca2eea
# ╠═565a58b0-9db4-4a7c-8432-368f155fd2bb
# ╠═8b0e6919-8d23-4e3d-930e-f2b66bbfcff6
# ╠═4db47392-dbb4-49ec-8c53-d5be4f0c70b3
# ╠═57a6c86a-f3c1-465e-a937-beae5ff3db10
# ╠═71b0a294-5a77-4af1-9286-ae72362b318d
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
