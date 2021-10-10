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

# ╔═╡ f7e010b1-4461-4479-ae5d-206233f97ac4
macro coolbind(ex)
	esc(ex)
end

# ╔═╡ dfbe06cc-2057-41cc-aaf4-4ddcdd109461
begin
	Slider(; start=0., stop=1.0, kwargs...) = start
	Slider(value; start=0., stop=1.0, kwargs...) = value
end

# ╔═╡ b23e1f65-e03f-4feb-8170-9a575e1a95c1
xx = #==# @coolbind(Slider(   41    ,  show_value=true, x=123)) #==#

# ╔═╡ 8074ac8e-7fef-4e41-a551-6c93b6d52cdb
xx

# ╔═╡ 29733d72-d75c-4ad6-a61e-6eb0f0b4471b


# ╔═╡ 5928832f-8434-45a6-92fb-537ce811406c
Splitter(splits; kwargsadfsdfaz...) = splits

# ╔═╡ 2ca0d7c4-611a-4002-ba55-e2dd4f363366
x = #==#@coolbind(Splitter(["fonsi", "\"\"\\"] ; potato = 123))#==#

# ╔═╡ 8b12be17-d71a-452b-9948-27487b1ef064
Counter(splits; kwargsadfsdfaz...) = splits

# ╔═╡ 61a91c90-c6f4-45ab-8fc2-262d060d00fb
howmany = @coolbind(Counter(148))

# ╔═╡ acba291c-bc36-4a92-a92b-76462d92c90d
PlutoRunner.inline_widgets[:Slider] = """
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
"""

# ╔═╡ 7103218a-20d4-46e6-ae04-476d97dede06
PlutoRunner.inline_widgets[:Splitter] = """
	const el = document.createElement("input")
	el.value = (getState() ?? []).join(" ")
	el.addEventListener("input", () => {
		setState(el.value.split(" "))
	})
	const span = document.createElement("span")
	span.appendChild(el)
	return span
"""

# ╔═╡ 6890ea03-893e-4e20-9ad7-51d7acce43d2
PlutoRunner.inline_widgets[:Counter] = """

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
"""

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

# ╔═╡ Cell order:
# ╠═61a91c90-c6f4-45ab-8fc2-262d060d00fb
# ╠═2ca0d7c4-611a-4002-ba55-e2dd4f363366
# ╠═b23e1f65-e03f-4feb-8170-9a575e1a95c1
# ╠═8074ac8e-7fef-4e41-a551-6c93b6d52cdb
# ╠═f7e010b1-4461-4479-ae5d-206233f97ac4
# ╠═dfbe06cc-2057-41cc-aaf4-4ddcdd109461
# ╠═29733d72-d75c-4ad6-a61e-6eb0f0b4471b
# ╠═5928832f-8434-45a6-92fb-537ce811406c
# ╠═8b12be17-d71a-452b-9948-27487b1ef064
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
