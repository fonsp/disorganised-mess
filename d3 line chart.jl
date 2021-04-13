### A Pluto.jl notebook ###
# v0.14.1

using Markdown
using InteractiveUtils

# ╔═╡ 40422ff2-9cae-11eb-3abf-a768fc012606
using HypertextLiteral

# ╔═╡ 18d8e6f3-5ef0-419f-a47f-6019a45b931f
using JSON

# ╔═╡ a4596540-bec9-454a-bf0b-3e99129e68bd
html"""
<video src="https://user-images.githubusercontent.com/6933510/114635325-c6564e00-9cc4-11eb-80ed-319b257c8268.mov" data-canonical-src="https://user-images.githubusercontent.com/6933510/114635325-c6564e00-9cc4-11eb-80ed-319b257c8268.mov" controls="controls" muted="muted" class="d-block rounded-bottom-2 width-fit" style="max-height:640px;">

  </video>
"""

# ╔═╡ d5ba52a0-a8e3-46eb-9571-4e2e9fef4212
x = 1:100

# ╔═╡ 6878537e-732a-4107-bbd8-0a83be88c355
y = sqrt.(x)

# ╔═╡ 083c5140-4037-498d-85f4-00aaf11719d3
@htl("""
<script src="https://cdn.jsdelivr.net/npm/d3@6.2.0/dist/d3.min.js"></script>

<script id="hello">

const setup = this == null
const svg = setup ? DOM.svg(600,200) : this
const s = setup ? d3.select(svg).append("g"): this.s
	
	
	if(setup) {
		s.append("g").classed("axes",true)
		s.append("g").classed("graph",true)
	}
	
	const height = 200
	const width = 600
	
	const margin = ({top: 20, right: 30, bottom: 30, left: 40})
	
	
	const on_setup = () => {
	
	
	
	}
	
	const on_update = () => {
	
	}
	
	
	
	const raw_x = $(JSON.json(x))
	const raw_y = $(JSON.json(y))
	
	const x = d3.scaleLinear()
    .domain(d3.extent(raw_x))
    .range([margin.left, width - margin.right])
	
	const y = d3.scaleLinear()
    .domain(d3.extent(raw_y)).nice()
    .range([height - margin.bottom, margin.top])
	
	
	const yAxis = g => g
    .attr("transform", `translate(\${margin.left},0)`)
    .call(d3.axisLeft(y))
    .call(g => g.select(".domain").remove())
    .call(g => g.select(".tick:last-of-type text").clone()
        .attr("x", 3)
        .attr("text-anchor", "start")
        .attr("font-weight", "bold")
        .text("Y label"))
	
	const xAxis = g => g
    .attr("transform", `translate(0,\${height - margin.bottom})`)
    .call(d3.axisBottom(x).ticks(width / 80).tickSizeOuter(0))
	
	const line = d3.line()
    .x(d => x(d[0]))
    .y(d => y(d[1]))
	
	const zipped = d3.zip(raw_x, raw_y)
	
	const axes_g = s.select("g.axes")
		.call(g => g.selectAll("g.x").data([zipped]).join("g").classed("x",true).call(xAxis))
		.call(g => g.selectAll("g.y").data([zipped]).join("g").classed("y",true).call(yAxis))
		

  s.select("g.graph")
	.selectAll("path")
      .data([zipped])
		.join("path")
      .attr("fill", "none")
      .attr("stroke", "steelblue")
      .attr("stroke-width", 1.5)
      .attr("stroke-linejoin", "round")
      .attr("stroke-linecap", "round")
    .transition()
    .duration(300)
      .attr("d", line);


const output = svg
output.s = s
return output
</script>

""")

# ╔═╡ 52b4eeb5-9fb2-4c62-b872-692f1806e408


# ╔═╡ e0180729-5f67-4f98-873d-bb0e877834ea


# ╔═╡ 9a2d119e-5216-4f4a-b972-9079882a7eac


# ╔═╡ 4477e93d-a407-4e8b-8f2f-6262619f3a25
dot_positions = [100, 400]

# ╔═╡ 5097f0dc-8e21-4f8f-bf82-58d66865bcb0
@htl("""
<script src="https://cdn.jsdelivr.net/npm/d3@6.2.0/dist/d3.min.js"></script>

<script id="hello">

const positions = $(JSON.json(dot_positions))
	
const svg = this == null ? DOM.svg(600,200) : this
const s = this == null ? d3.select(svg) : this.s

s.selectAll("circle")
	.data(positions)
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

""")

# ╔═╡ Cell order:
# ╟─a4596540-bec9-454a-bf0b-3e99129e68bd
# ╠═40422ff2-9cae-11eb-3abf-a768fc012606
# ╠═18d8e6f3-5ef0-419f-a47f-6019a45b931f
# ╠═d5ba52a0-a8e3-46eb-9571-4e2e9fef4212
# ╠═6878537e-732a-4107-bbd8-0a83be88c355
# ╠═083c5140-4037-498d-85f4-00aaf11719d3
# ╠═52b4eeb5-9fb2-4c62-b872-692f1806e408
# ╠═e0180729-5f67-4f98-873d-bb0e877834ea
# ╠═9a2d119e-5216-4f4a-b972-9079882a7eac
# ╠═4477e93d-a407-4e8b-8f2f-6262619f3a25
# ╠═5097f0dc-8e21-4f8f-bf82-58d66865bcb0
