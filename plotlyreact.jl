### A Pluto.jl notebook ###
# v0.12.20

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

# ╔═╡ c2ab466b-fdbd-455f-a3ee-4b411be16610
using PlutoUI

# ╔═╡ 35c6b5b4-77bc-11eb-3705-2b94706d56e6
using JSON

# ╔═╡ 5cd93d37-23b6-4f98-ade3-3425383e3848
using Plots

# ╔═╡ 7c64dce8-e01c-4f25-b5ce-7146bea416e4
plot(x, y) = """
<script src="https://cdn.plot.ly/plotly-1.58.0.min.js"></script>

<script id="asdf">
    const container = this ?? html`<div style="width: 200px;"></div>`

    Plotly.react( container, [{
        x: $(JSON.json(x)),
        y: $(JSON.json(y)),
    }], {

	width: 600,
        margin: {
		t: 0,
	l:60,
r:20,
b:60
}
    },{staticPlot: true})

    return container
</script>
""" |> HTML

# ╔═╡ b2d49a2f-b3f6-4c2e-b7df-5dda753127de
c3(x,y) = """

<!-- Load c3.css -->
<link href="https://cdn.jsdelivr.net/npm/c3@0.7.20/c3.min.css" rel="stylesheet">

<!-- Load d3.js and c3.js -->
<script src="/path/to/d3.v5.min.js" charset="utf-8"></script>
<script src="https://cdn.jsdelivr.net/npm/c3@0.7.20/c3.min.js"></script>


<script id="asdf">
    const container = this ?? html`<div id="aaa" style="width: 200px;"></div>`
var chart = c3.generate({
    bindto: "#aaa",
    data: {
      columns: [
        ['data1', 30, 200, 100, 400, 150, 250],
        ['data2', 50, 20, 10, 40, 15, 25]
      ]
    }
});
    return container
</script>

""" |> HTML

# ╔═╡ e8f94d2b-5638-4a2a-8cb8-e32c3f531cda
c3([1,2], [3,3])

# ╔═╡ c4e0c97c-4dfe-4f6b-ae6c-671c6f015d5b
x = 1:.1:10000

# ╔═╡ 672cd1ed-bb7d-4e6d-a2d6-6298d1d1749b
@bind z Slider(0:0.00001:0.1)

# ╔═╡ 4d6de989-99dd-430c-8eb9-1019038447fa
y = sin.(x .* z)

# ╔═╡ 3dcf3c36-4fc1-4121-b378-b91d0b14088d
JSON.json(x);

# ╔═╡ 4a03e3e1-eb91-4a77-b85d-c298dd161787
plot(x,y)

# ╔═╡ 8c512c41-f7ba-475b-bceb-7b3ea6e183bd
@bind z2 Slider(0:0.00001:0.1)

# ╔═╡ 194f0709-c592-4e69-b3b6-2ec67858fe75
y2 = sin.(x .* z2)

# ╔═╡ 370df608-a393-4ec6-9df6-deaa685acea6
PlutoUI.as_svg(Plots.plot(x, y2))

# ╔═╡ b25cf639-1399-491b-b4ad-99e559fa514a







































# ╔═╡ Cell order:
# ╠═c2ab466b-fdbd-455f-a3ee-4b411be16610
# ╠═35c6b5b4-77bc-11eb-3705-2b94706d56e6
# ╠═7c64dce8-e01c-4f25-b5ce-7146bea416e4
# ╠═b2d49a2f-b3f6-4c2e-b7df-5dda753127de
# ╠═e8f94d2b-5638-4a2a-8cb8-e32c3f531cda
# ╠═c4e0c97c-4dfe-4f6b-ae6c-671c6f015d5b
# ╠═4d6de989-99dd-430c-8eb9-1019038447fa
# ╠═672cd1ed-bb7d-4e6d-a2d6-6298d1d1749b
# ╠═3dcf3c36-4fc1-4121-b378-b91d0b14088d
# ╠═4a03e3e1-eb91-4a77-b85d-c298dd161787
# ╠═5cd93d37-23b6-4f98-ade3-3425383e3848
# ╠═194f0709-c592-4e69-b3b6-2ec67858fe75
# ╠═8c512c41-f7ba-475b-bceb-7b3ea6e183bd
# ╠═370df608-a393-4ec6-9df6-deaa685acea6
# ╠═b25cf639-1399-491b-b4ad-99e559fa514a
