### A Pluto.jl notebook ###
# v0.14.5

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

# ╔═╡ ff098dd8-fe89-4938-b05c-1780ba5620d0
using HypertextLiteral

# ╔═╡ df0161b2-9889-4212-bceb-b55587ddf1ea
@bind period html"<input type=range step=0.001>"

# ╔═╡ 9f1a6fa8-d978-4de9-8bee-8da14c079468
x = rand(5000)

# ╔═╡ 7d9ba2a5-d6d7-4cb4-a67f-69257c11f0d7
y = sin.(x .* period)

# ╔═╡ 0df30663-ceef-4f4d-988b-5e9b5fd02d12
PlutoRunner.publish_to_js

# ╔═╡ 4a4e8fea-b73b-11eb-1a16-014340198d2c
"""

<script id="asdf">

await new Promise(r => {
setTimeout(r, 1000)
})

//const Plot = window.Plot = window.Plot ?? await import("https://cdn.skypack.dev/@observablehq/plot@0.1")
const Plot = await import("https://cdn.skypack.dev/@observablehq/plot@0.1")


return Plot.dot($(PlutoRunner.publish_to_js(x)), {x: $(PlutoRunner.publish_to_js(x)), y: $(PlutoRunner.publish_to_js(y))}).plot()


</script>


""" |> HTML

# ╔═╡ Cell order:
# ╠═df0161b2-9889-4212-bceb-b55587ddf1ea
# ╠═9f1a6fa8-d978-4de9-8bee-8da14c079468
# ╠═7d9ba2a5-d6d7-4cb4-a67f-69257c11f0d7
# ╠═0df30663-ceef-4f4d-988b-5e9b5fd02d12
# ╠═4a4e8fea-b73b-11eb-1a16-014340198d2c
# ╠═ff098dd8-fe89-4938-b05c-1780ba5620d0
