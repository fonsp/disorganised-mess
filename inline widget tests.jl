### A Pluto.jl notebook ###
# v0.16.1

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ c189c4f8-5779-4d7c-9c0b-2ea780eea3a4
import Pkg

# ╔═╡ 61a91c90-c6f4-45ab-8fc2-262d060d00fb
howmany = @coolbind(Counter(124))  + @coolbind(Counter(135))
howmany = @coolbind(Counter(124))  + @coolbind(Counter(134))
howmany = @coolbind(Counter(124))  + @coolbind(Counter(134))
howmany = @coolbind(Counter(124))  + @coolbind(Counter(134))
howmany = @coolbind(Counter(124))  + @coolbind(Counter(134))
howmany = @coolbind(Counter(124))  + @coolbind(Counter(134))
howmany = @coolbind(Counter(124))  + @coolbind(Counter(134))


# ╔═╡ f7e010b1-4461-4479-ae5d-206233f97ac4
macro coolbind(ex)
	esc(ex)
end

# ╔═╡ 2ca0d7c4-611a-4002-ba55-e2dd4f363366
x = @coolbind(Splitter(["fonsi", "\"\"\\asd", "fasd", "f"] ; potato = 123))#==#

# ╔═╡ b23e1f65-e03f-4feb-8170-9a575e1a95c1
xx = @coolbind(Slider(  45   ;  show_value=false))

# ╔═╡ 8074ac8e-7fef-4e41-a551-6c93b6d52cdb
xx

# ╔═╡ dfbe06cc-2057-41cc-aaf4-4ddcdd109461
begin
	Slider(; start=0., stop=1.0, kwargs...) = start
	Slider(value; start=0., stop=1.0, kwargs...) = value
end

# ╔═╡ 29733d72-d75c-4ad6-a61e-6eb0f0b4471b
1 + 1

# ╔═╡ 5928832f-8434-45a6-92fb-537ce811406c
Splitter(splits; kwargsadfsdfaz...) = splits

# ╔═╡ 8b12be17-d71a-452b-9948-27487b1ef064
Counter(splits; kwargsadfsdfaz...) = splits

# ╔═╡ e0cfefab-16ae-469c-b0d3-aca534511ed0
# begin
# 	PlutoRunner._inline_widgets_changed[] = true
# 	PlutoRunner._inline_widgets |> empty!
# end

# ╔═╡ acba291c-bc36-4a92-a92b-76462d92c90d
PlutoRunner.register_inline_widget(:Slider, """
	console.log("PROPS ", props)
	const container = document.createElement("span")
	const el = document.createElement("input")
		const value = document.createElement("span")
	el.type = "range"
	el.valueAsNumber = getState()
	el.addEventListener("input", () => {
		setState(el.valueAsNumber)
		value.innerText = el.valueAsNumber
	})
	container.appendChild(el)
	if (props.show_value) {
		value.innerText = getState()
		container.appendChild(value)
	}
	return container
""")

# ╔═╡ 7103218a-20d4-46e6-ae04-476d97dede06
PlutoRunner.register_inline_widget(:Splitter, """
	const el = document.createElement("input")
	el.value = (getState() ?? []).join(" ")
	el.addEventListener("input", () => {
		setState(el.value.split(" "))
	})
	const span = document.createElement("span")
	span.appendChild(el)
	return span
""")

# ╔═╡ 6890ea03-893e-4e20-9ad7-51d7acce43d2
PlutoRunner.register_inline_widget(:Counter, """

	const dec = html`<button>-</button>`
	const inc = html`<button>+</button>`

	const counter = html`<span></span>`

	counter.innerText = getState()

	dec.onclick = async () => {
		await setState(getState() - 1)
		counter.innerText = getState()
	}
	inc.onclick = () => {
		setState(getState() + 1)
		counter.innerText = getState()
	}
	return html`\${dec}\${counter}\${inc}`
""")

# ╔═╡ ab7ad0a6-d6a8-4bda-acab-df7870b87124
hello world

# ╔═╡ e2fdad25-cd31-48f5-92e3-6df47d56ec83
["hello", "world"]

# ╔═╡ f810f477-74ee-43f2-b3d2-ef0c63cec38b
@bind s html"<input value='Slider(x; start=1, stop=[2,3])'>"

# ╔═╡ 833666d8-5d80-417b-a6f8-45ed1d85430d
e = Meta.parse(s)

# ╔═╡ d60bfa0c-8127-42e3-98c0-b8c8c7da1ebf
begin
	params = e.args[2]

	new_ex = Expr(:call, :Dict, map(kw -> Expr(:call, :(=>), QuoteNode(kw.args[1]), kw.args[2]), params.args)...)
end

# ╔═╡ e1b398e5-c7dc-4254-99b8-b9fa1b10beb7
eval(new_ex)

# ╔═╡ 2be51c6a-e56d-4c83-ad75-5691e0f9a601
if Meta.isexpr(e.args[2], :parameters)
	e.args[3]
else
	e.args[2]
end

# ╔═╡ 18598ed8-84a7-4f52-bf85-2a4d631dfc8d
macro mymacro(df_expression)
	A1 = df[:A, :1]
end

# ╔═╡ 78ace354-2edf-4738-8a43-dd9ea20a4f1a
function f()

end

# ╔═╡ 89727ade-b10c-4f04-8a2c-c236fac7fe87
Slider(1; functions=[f, sin, exp])

# ╔═╡ b2dbff56-22f7-4c6f-b42e-acfc7e408056
Meta.parse("Slider(1)")

# ╔═╡ 04745828-fafc-4cbd-b5e7-ba57a6077cad
y = 100

# ╔═╡ 256e7993-c76c-4216-9302-2e4a3760e894
@c00lbind(Slider(; start=y, stop=y+10))

# ╔═╡ e5aa72a0-c3a0-43d7-83d8-1ae394439ec1
# x = 

# ╔═╡ 753d58c1-1c5f-47f6-bfa7-1e588517a57e
# @coolbind(NotASlider())

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Pkg = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╠═c189c4f8-5779-4d7c-9c0b-2ea780eea3a4
# ╠═61a91c90-c6f4-45ab-8fc2-262d060d00fb
# ╠═2ca0d7c4-611a-4002-ba55-e2dd4f363366
# ╠═b23e1f65-e03f-4feb-8170-9a575e1a95c1
# ╠═8074ac8e-7fef-4e41-a551-6c93b6d52cdb
# ╠═f7e010b1-4461-4479-ae5d-206233f97ac4
# ╠═dfbe06cc-2057-41cc-aaf4-4ddcdd109461
# ╠═29733d72-d75c-4ad6-a61e-6eb0f0b4471b
# ╠═5928832f-8434-45a6-92fb-537ce811406c
# ╠═8b12be17-d71a-452b-9948-27487b1ef064
# ╠═e0cfefab-16ae-469c-b0d3-aca534511ed0
# ╠═acba291c-bc36-4a92-a92b-76462d92c90d
# ╠═7103218a-20d4-46e6-ae04-476d97dede06
# ╠═6890ea03-893e-4e20-9ad7-51d7acce43d2
# ╠═ab7ad0a6-d6a8-4bda-acab-df7870b87124
# ╠═e2fdad25-cd31-48f5-92e3-6df47d56ec83
# ╠═f810f477-74ee-43f2-b3d2-ef0c63cec38b
# ╠═833666d8-5d80-417b-a6f8-45ed1d85430d
# ╠═d60bfa0c-8127-42e3-98c0-b8c8c7da1ebf
# ╠═e1b398e5-c7dc-4254-99b8-b9fa1b10beb7
# ╠═2be51c6a-e56d-4c83-ad75-5691e0f9a601
# ╠═18598ed8-84a7-4f52-bf85-2a4d631dfc8d
# ╠═78ace354-2edf-4738-8a43-dd9ea20a4f1a
# ╠═89727ade-b10c-4f04-8a2c-c236fac7fe87
# ╠═b2dbff56-22f7-4c6f-b42e-acfc7e408056
# ╠═04745828-fafc-4cbd-b5e7-ba57a6077cad
# ╠═256e7993-c76c-4216-9302-2e4a3760e894
# ╠═e5aa72a0-c3a0-43d7-83d8-1ae394439ec1
# ╠═753d58c1-1c5f-47f6-bfa7-1e588517a57e
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
