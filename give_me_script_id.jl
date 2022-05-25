### A Pluto.jl notebook ###
# v0.18.4

using Markdown
using InteractiveUtils

# ╔═╡ 07a6a296-a148-11ec-2e74-79c8e4f396b4
using HypertextLiteral

# ╔═╡ b36fe7c3-e7bb-4890-ad59-5c7072151c1b
using PlutoUI

# ╔═╡ fd9be947-b78b-440a-9bc8-96a8b0d5b7e8
# little patch for HTL
Base.get(ep::HypertextLiteral.EscapeProxy, name, default) = get(ep.io, name, default)

# ╔═╡ c8a6ec37-1001-47f2-a57b-1e188b7433b4
@assert :b == get(
	HypertextLiteral.EscapeProxy(IOContext(devnull, :a => :b)),
	:a,
	123
)

# ╔═╡ 280a1cfd-3507-47ce-8ddd-5ea9aacbd112
const Layout = PlutoUI.ExperimentalLayout

# ╔═╡ 6098cc79-89f5-4cc5-ba41-ca7c08d750f7


# ╔═╡ 9ba89501-32ee-402b-8954-7d52c8aa79f4
md"""
# Examples
"""

# ╔═╡ cd475c0f-4171-49fb-b598-2c52a909a8c9
x = 123

# ╔═╡ 50e27110-0501-49a2-9d8a-10e717d3e282
md"""
## What the HTML looks like
"""

# ╔═╡ 8ad38fc1-ff49-4773-801d-9d866fb88245
md"""
# Counter stack
"""

# ╔═╡ 4216cc8a-0b40-479a-93e9-8ad8c0896f1c
const StackElement = Union{Symbol,Int}

# ╔═╡ a5404f55-2f87-4e9b-b7ba-11c591327b72
function get_and_increment_counter!(io::IO)
	stack = get(io, :script_id_counter, StackElement[])::Vector{StackElement}

	if length(stack) >= 1
		stack[end] += 1
		return join(stack, ",")
	else
		# Some fallback for when you use GiveMeScriptID inside an IO that never received a counter:
		string(rand(Int))
	end
end

# ╔═╡ 9c68e30b-1e07-484d-9fa8-2eef6aa57c52
function with_counter(f::Function, io::IO, addkey::Union{StackElement,Nothing}=nothing)
	oldstack = get(io, :script_id_counter, StackElement[])::Vector{StackElement}
	
	newstack = if addkey === nothing
		StackElement[oldstack..., 0]
	else
		StackElement[oldstack..., addkey, 0]
	end
	
	f(IOContext(io, 
		:script_id_counter => newstack,
	))
end

# ╔═╡ a19d3e4f-9a1b-43a9-be09-a3e9f92d0fc1
md"""
# Macro that uses it for a script ID
"""

# ╔═╡ c86006c1-fbb3-4c9b-8782-ec5426c73d86
begin
	struct ScriptIDGiver
		source::LineNumberNode
	end

	function Base.show(io::IO, g::ScriptIDGiver)
		
		
		name = "id_$(
			string(hash(g.source), base=62)
		)_$(
			get_and_increment_counter!(io)
		)"

		write(io, name)
	end

	ScriptIDGiver
end

# ╔═╡ 3315fe51-0577-4f96-973d-8f055a0ab19c
begin
	struct PlutoDiv
		contents::Vector
	end

	function Base.show(io::IO, m::MIME"text/html", p::PlutoDiv)
		get_and_increment_counter!(io)
		write(io, "<div>")
		for (i,e) in enumerate(p.contents)
			with_counter(io, i) do io
				show(io, m, e)
			end
		end
		write(io, "</div>")
	end
end

# ╔═╡ cdd3254e-57e4-48f9-898c-b675c7b1edd1
begin
	struct PlutoKeyedDiv
		contents::Vector{Pair{Symbol,Any}}
	end

	function Base.show(io::IO, m::MIME"text/html", p::PlutoKeyedDiv)
		get_and_increment_counter!(io)
		write(io, "<div>")
		for (i,e) in p.contents
			with_counter(io, i) do io
				show(io, m, e)
			end
		end
		write(io, "</div>")
	end
end

# ╔═╡ 49e90b1a-7c3e-49e0-b5fb-580d2c317d4e


# ╔═╡ f17d1d75-9080-42e8-9e3a-0cea4262d22a
# begin
# 	Base.get(io::HypertextLiteral.EscapeProxy, args...) = Base.get(io.io, args...)
# 	Base.get!(io::HypertextLiteral.EscapeProxy, args...) = Base.get!(io.io, args...)
# 	Base.get!(f, io::HypertextLiteral.EscapeProxy, args...) = Base.get!(f, io.io, args...)
# 	Base.get(io::HypertextLiteral.EscapeProxy, args...) = Base.get(io.io, args...)
# 	IOContext

# ╔═╡ 4342f39f-0b79-472f-8b1b-766401c564eb
render_like_plutorunner_would(x) = sprint() do io_raw
	with_counter(io_raw) do io
		show(io, MIME"text/html"(), x)
	end
end |> HTML

# ╔═╡ 01189d5c-938d-44a8-80e0-37a3f1958849
give_me_script_id(s::LineNumberNode) = ScriptIDGiver(s)

# ╔═╡ 8b1ebbaa-c64d-4d97-a063-ba8e6ab7c579
begin
	give_me_script_id
	macro give_me_script_id()
		give_me_script_id(__source__)
	end
end

# ╔═╡ fecb1c3f-a9a0-4c2c-8451-a1f83711acd8
counter1() = @htl """
<script id=$(@give_me_script_id())>
let node
if(this == null) {
	node = html`<span style='color: green'></span>`
	node.val = {current: 0}
} else {
	node = this
}
const val = node.val
val.current += 1
node.innerText = val.current

return node
</script>
"""

# ╔═╡ e8c820f2-4511-4243-932c-9496648e02df
repr(MIME"text/html"(), counter1()) |> Text

# ╔═╡ 74dd3ae7-daa3-4da1-8674-37278d94702b
counter2() = @htl """
<script id=$(@give_me_script_id())>
let node
if(this == null) {
	node = html`<span style='color: red'></span>`
	node.val = {current: 0}
} else {
	node = this
}
const val = node.val
val.current += 1
node.innerText = val.current

return node
</script>
"""

# ╔═╡ 1a67c72f-fa43-4e86-8c97-dbe98a7a8f8f
let
	x
	
	PlutoDiv([
		counter1(),
		counter2(),
	])
end

# ╔═╡ fa1a618e-88fe-4809-9a8b-68a321b82629
just_script() = @htl """

<script id=$(@give_me_script_id())>
</script>

"""

# ╔═╡ c1b22768-672b-4a29-a542-2417d87985c5
render_like_plutorunner_would(@htl """
$(just_script())
$(just_script())
""").content |> Text

# ╔═╡ 812c5dd0-7f18-4ab0-bccf-0f373f14559d
render_like_plutorunner_would(@htl """
$(just_script())
$(just_script())
$(PlutoDiv([
	just_script(),
	just_script(),
]))
$(just_script())
""").content |> Text

# ╔═╡ 9705bc7c-57e7-4141-8e9e-d5bb77ff331d
render_like_plutorunner_would(@htl """
$(just_script())
$(just_script())
$(PlutoKeyedDiv([
	:aa => just_script(),
	Symbol("aa'bb") => just_script(),
]))
$(just_script())
""").content |> Text

# ╔═╡ b8f33885-3b01-4858-bc99-9475f36d2adc
# hier maken wij automatisch keys: 1,2,3,...

PlutoLayout.hbox([
	thing,
	ook_thing,
	hello
])

# maar dit is bv een probleem in dit geval:

PlutoLayout.hbox(cool ? [
	first,
	second
] : [
	second,
	first
])

# hierom kan je zelf keys aangeven:
# (API bestaat nog niet)

PlutoLayout.hbox(cool ? [
	:e1 => first,
	:e2 => second
] : [
	:e2 => second,
	:e1 => first
])

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
HypertextLiteral = "~0.9.3"
PlutoUI = "~0.7.37"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.0"
manifest_format = "2.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

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

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

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

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "85b5da0fa43588c75bb1ff986493443f821c70b7"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.2.3"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "bf0a1121af131d9974241ba53f601211e9303a9e"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.37"

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

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

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

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╠═07a6a296-a148-11ec-2e74-79c8e4f396b4
# ╠═fd9be947-b78b-440a-9bc8-96a8b0d5b7e8
# ╠═c8a6ec37-1001-47f2-a57b-1e188b7433b4
# ╠═b36fe7c3-e7bb-4890-ad59-5c7072151c1b
# ╠═280a1cfd-3507-47ce-8ddd-5ea9aacbd112
# ╟─6098cc79-89f5-4cc5-ba41-ca7c08d750f7
# ╟─9ba89501-32ee-402b-8954-7d52c8aa79f4
# ╠═fecb1c3f-a9a0-4c2c-8451-a1f83711acd8
# ╠═74dd3ae7-daa3-4da1-8674-37278d94702b
# ╠═cd475c0f-4171-49fb-b598-2c52a909a8c9
# ╠═1a67c72f-fa43-4e86-8c97-dbe98a7a8f8f
# ╠═fa1a618e-88fe-4809-9a8b-68a321b82629
# ╟─50e27110-0501-49a2-9d8a-10e717d3e282
# ╠═c1b22768-672b-4a29-a542-2417d87985c5
# ╠═812c5dd0-7f18-4ab0-bccf-0f373f14559d
# ╟─8ad38fc1-ff49-4773-801d-9d866fb88245
# ╠═4216cc8a-0b40-479a-93e9-8ad8c0896f1c
# ╠═a5404f55-2f87-4e9b-b7ba-11c591327b72
# ╠═9c68e30b-1e07-484d-9fa8-2eef6aa57c52
# ╟─a19d3e4f-9a1b-43a9-be09-a3e9f92d0fc1
# ╠═c86006c1-fbb3-4c9b-8782-ec5426c73d86
# ╠═9705bc7c-57e7-4141-8e9e-d5bb77ff331d
# ╠═3315fe51-0577-4f96-973d-8f055a0ab19c
# ╠═cdd3254e-57e4-48f9-898c-b675c7b1edd1
# ╠═49e90b1a-7c3e-49e0-b5fb-580d2c317d4e
# ╠═f17d1d75-9080-42e8-9e3a-0cea4262d22a
# ╠═e8c820f2-4511-4243-932c-9496648e02df
# ╠═4342f39f-0b79-472f-8b1b-766401c564eb
# ╠═01189d5c-938d-44a8-80e0-37a3f1958849
# ╠═8b1ebbaa-c64d-4d97-a063-ba8e6ab7c579
# ╠═b8f33885-3b01-4858-bc99-9475f36d2adc
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
