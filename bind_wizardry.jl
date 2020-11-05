### A Pluto.jl notebook ###
# v0.12.6

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

# ╔═╡ 05b01f6e-106a-11eb-2a88-5f523fafe433
begin
	using Pkg
	Pkg.activate(mktempdir())
	Pkg.add([
			Pkg.PackageSpec(name="PlutoUI", version="0.6.7-0.6"), 
			Pkg.PackageSpec(name="JSON"),
			])

	using PlutoUI
	import JSON
end

# ╔═╡ a4ac414a-1a17-11eb-278b-d7bba3013f42
md"""
# `this` persistence
"""

# ╔═╡ b75a16aa-1a17-11eb-3f6a-05f136313585
md"""
Edit `x`!
"""

# ╔═╡ aac7928c-1a17-11eb-1c5d-bffde1a43f11
x = [80, 200, 500]

# ╔═╡ bc00430a-1a17-11eb-0593-b11c999979c7
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

# ╔═╡ bf8a6938-1a17-11eb-32ef-6f04f60ecff0
md"""
(More info will follow, sorry!)
"""

# ╔═╡ 350bb500-1a17-11eb-3ccc-b567385b89eb
md"""
# Self updating cells
"""

# ╔═╡ ea4019c6-1a16-11eb-1eb2-89dda5e2e461
begin
	# we need to reference potato in this cell --before assigning to potato-- to
	# register as self-updating cell
	if !@isdefined(potato)
		# potato not defined means that this is the first run
		# when the bond sets a value, the new value will be assigned to potato
		# __before__ this cell is run.
		# so potato defined means that this cell is running as
		# response to the bond update
		
		# set a default value
		potato = 10
	end
	
	s = @bind potato Slider(1:100, default=potato)
	
	# We now assigned to potato to register as self-update
	# (`@bind x a` counts as assignment to `x`) 
	# bound values will only be set if they are assigned somewhere.
	
	md"""
	Old value: $potato
	
	New value: $s
	"""
end

# ╔═╡ 3c699970-1a17-11eb-28c1-c36551071fb0
md"""
Comments:

You see that you can't _slide_ the slider. This is because a new slider gets rendered every time the cell updates, which resets its internal (cursor) state.

If this is a problem, it can be fixed using the `this` persistence together with self-updating, see the next section.


> Everything below this cell is WIP and currently not working 100%, but you can have a preview. Will be fixed soon!
"""

# ╔═╡ 1cbc1278-1a18-11eb-34db-3704e69a8a9c
md"""

# `this` persistence + self updating
This is still somewhat WIP, and is **currently not working for self-updating cells** (cryptic issue is [here](https://github.com/fonsp/Pluto.jl/issues/619), you can subscribe to it). 

The demo below uses both techniques, but you can see that the animations are not working when you click.

"""

# ╔═╡ e8ea71fc-108e-11eb-2f27-e984fde247d2
A = [0  -1
	1    -.5]

# ╔═╡ 10853972-108f-11eb-36b5-57f656bc992e
T = LinRange(0.0, 60.0, 500)

# ╔═╡ 2187253c-108f-11eb-04a2-512ce3c17abf
ΔT = step(T)

# ╔═╡ 0af07152-108f-11eb-2c0b-d96b54bfd3a5
f(t,x) = A*x

# ╔═╡ bcac8f60-1086-11eb-1756-bb2b19f7a25f
function compute_path(first)
	accumulate(T; init=first) do x_prev, t
		x_prev + ΔT * f(t,x_prev)
	end
end

# ╔═╡ cf5f7bda-19f1-11eb-2c79-89c98f1d34da
md"""
The next one is kinda broken, come back later!
"""

# ╔═╡ e926013a-1080-11eb-24b8-034df3032883
with_d3_libs(content) = HTML("""
<script src="https://cdn.jsdelivr.net/npm/d3@6.2.0/dist/d3.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/d3-scale@3.2.3/dist/d3-scale.min.js"></script>
	
$(repr(MIME"text/html"(), content))
""")

# ╔═╡ 53dc7e0a-1081-11eb-39a3-c981848c2b1d
begin
	struct BondDefault
		element
		default
	end
	Base.show(io::IO, m::MIME"text/html", bd::BondDefault) = Base.show(io, m, bd.element)
	Base.get(bd::BondDefault) = bd.default
end

# ╔═╡ 04b79b02-1086-11eb-322b-cd995fa4196e
function wow(previous)
	path = compute_path(previous)
	
	c = """
	<script id="aa">
	
	const path = $(JSON.json(path))

	const svg = this == null ? DOM.svg(600,400) : this
	const s = this == null ? d3.select(svg) : this.s
	
	svg.value = $(JSON.json(previous))
	
	
	const xscale = d3.scaleLinear()
		.domain([-3,3])
		.range([20, 580])
	
	const yscale = d3.scaleLinear()
		.domain([-2,2])
		.range([380, 20])
	
	if(this == null) {
		s.append("g")
    		.attr("transform", `translate(\${xscale(0)},0)`)
			.call(d3.axisLeft(yscale))
		s.append("g")
    		.attr("transform", `translate(0,\${yscale(0)})`)
			.call(d3.axisBottom(xscale))
		s.append("g").classed("thepath", true)
	}
	
	const down_handler =(e) => {
		svg.value = [xscale.invert(e.clientX - svg.getBoundingClientRect().left), yscale.invert(e.clientY - svg.getBoundingClientRect().top)]
		svg.dispatchEvent(new CustomEvent("input", {}))
	}
	
	svg.addEventListener("pointerdown", down_handler)
	invalidation.then(() => svg.removeEventListener("pointerdown", down_handler))
	
	s.select("g.thepath").selectAll("path")
		.data([path])
		.join("path")
		.transition()
		.duration(300)
		.attr("d", d => d3.line()
							.x(p => xscale(p[0]))
							.y(p => yscale(p[1]))(d))
		.attr("stroke", "gray")
    	.attr('stroke-width', 5)
		.attr("fill", "none")

	const output = svg
	output.s = s
	return output
	</script>

	"""
	BondDefault(HTML(c), previous)
end

# ╔═╡ 99a6a906-1086-11eb-3528-fb705460853e
begin
	if !@isdefined(x0)
		x0 = [0.5, 0.5]
	end
	
	@bind x0 wow(x0)
	
end |> with_d3_libs

# ╔═╡ 337ece1a-1225-11eb-3e24-9b4a816a1ee1
x0

# ╔═╡ ad5b94c6-1071-11eb-25f6-bf800b21b265
let
	previous = if @isdefined(pos)
		pos
	else
		100
	end
	
	x = previous * (1:10)
	
	c = """
	<script id="helloaza">
	
	const x = $(JSON.json(x))

	const svg = this == null ? DOM.svg(600,200) : this
	const s = this == null ? d3.select(svg) : this.s
	
	svg.value = $(previous)
	
	const down_handler =(e) => {
		svg.value = e.clientX - svg.getBoundingClientRect().left
		svg.dispatchEvent(new CustomEvent("input", {}))
		console.log(svg.value)
	}
	
	svg.addEventListener("pointerdown", down_handler)
	invalidation.then(() => svg.removeEventListener("pointerdown", down_handler))
	
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

	"""
	with_d3_libs(@bind pos BondDefault(HTML(c), previous))
end

# ╔═╡ 847b089a-1083-11eb-04d6-e12a4385a8fa
pos

# ╔═╡ Cell order:
# ╠═05b01f6e-106a-11eb-2a88-5f523fafe433
# ╟─a4ac414a-1a17-11eb-278b-d7bba3013f42
# ╠═b75a16aa-1a17-11eb-3f6a-05f136313585
# ╠═aac7928c-1a17-11eb-1c5d-bffde1a43f11
# ╟─bc00430a-1a17-11eb-0593-b11c999979c7
# ╟─bf8a6938-1a17-11eb-32ef-6f04f60ecff0
# ╟─350bb500-1a17-11eb-3ccc-b567385b89eb
# ╠═ea4019c6-1a16-11eb-1eb2-89dda5e2e461
# ╟─3c699970-1a17-11eb-28c1-c36551071fb0
# ╟─1cbc1278-1a18-11eb-34db-3704e69a8a9c
# ╠═e8ea71fc-108e-11eb-2f27-e984fde247d2
# ╠═99a6a906-1086-11eb-3528-fb705460853e
# ╠═337ece1a-1225-11eb-3e24-9b4a816a1ee1
# ╠═04b79b02-1086-11eb-322b-cd995fa4196e
# ╠═10853972-108f-11eb-36b5-57f656bc992e
# ╠═2187253c-108f-11eb-04a2-512ce3c17abf
# ╠═bcac8f60-1086-11eb-1756-bb2b19f7a25f
# ╠═0af07152-108f-11eb-2c0b-d96b54bfd3a5
# ╟─cf5f7bda-19f1-11eb-2c79-89c98f1d34da
# ╠═ad5b94c6-1071-11eb-25f6-bf800b21b265
# ╠═847b089a-1083-11eb-04d6-e12a4385a8fa
# ╠═e926013a-1080-11eb-24b8-034df3032883
# ╠═53dc7e0a-1081-11eb-39a3-c981848c2b1d
