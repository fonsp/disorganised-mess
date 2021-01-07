### A Pluto.jl notebook ###
# v0.12.4

using Markdown
using InteractiveUtils

# ╔═╡ 05b01f6e-106a-11eb-2a88-5f523fafe433
begin
	using Pkg
	Pkg.activate(mktempdir())
	Pkg.add([
			Pkg.PackageSpec(name="JSON"),
			])
	import JSON
end

# ╔═╡ eb6c2274-19f6-11eb-3cc4-876a349b49d2
md"""
Edit `x`!
"""

# ╔═╡ 0ba5a304-107d-11eb-3252-d9f15172fbf9
x = [80, 500]

# ╔═╡ ad5b94c6-1071-11eb-25f6-bf800b21b265
"""
<script src="https://cdn.jsdelivr.net/npm/d3@6.2.0/dist/d3.min.js"></script>

<script id="hello">

const x = $(JSON.json(x))
	
const svg = this == null ? DOM.svg(600,200) : this
const s = this == null ? d3.select(svg) : this.s

s.selectAll("circle")
	.data(x)
	.join("circle")
    .transition()
    .duration(300)
	.attr("cx", d => d)
	.attr("cy", 100)
	.attr("r", 10)
	.attr("fill", "gray")


const output = svg
output.s = s
return output
</script>

""" |> HTML

# ╔═╡ Cell order:
# ╠═eb6c2274-19f6-11eb-3cc4-876a349b49d2
# ╠═0ba5a304-107d-11eb-3252-d9f15172fbf9
# ╠═ad5b94c6-1071-11eb-25f6-bf800b21b265
# ╠═05b01f6e-106a-11eb-2a88-5f523fafe433
