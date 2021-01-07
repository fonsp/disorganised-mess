### A Pluto.jl notebook ###
# v0.12.7

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

# ╔═╡ dd5dbc50-20f0-11eb-3bd5-e50d0f23b0b0
using Plots

# ╔═╡ 3027a4ae-20f2-11eb-1dc6-49c6632ef9f9
using PlutoUI

# ╔═╡ 15f01666-20f2-11eb-2b42-9920f62e4fc4
using Hyperscript

# ╔═╡ 3db76506-20f1-11eb-0480-ebaff43db46e
using Plots.Measures

# ╔═╡ 767c4e86-20f3-11eb-27a1-591e93e2fc35
script = m(Hyperscript.NOESCAPE_HTMLSVG_CONTEXT, "script")

# ╔═╡ 86b89410-20f3-11eb-1bcc-1fc2a6ce9bad
div = m("div")

# ╔═╡ b51deea6-20f3-11eb-187e-6f3bb2900f89
randid() = String(rand(('a':'z') ∪ ('A':'Z'), 12))

# ╔═╡ f08af15a-20f3-11eb-2c92-dbbd5b6cd8f1
clicktracker_js(id) = """
const container = document.querySelector("#$(id)")
const graph = container.firstElementChild

const onclick = (e) => {
    const svgrect = graph.getBoundingClientRect()
    container.value = [
		(e.clientX - svgrect.left) / svgrect.width, 
		(e.clientY - svgrect.top) / svgrect.height
	]
	container.dispatchEvent(new CustomEvent("input"), {})
}

graph.addEventListener("click", onclick)

invalidation.then(() => {
graph.removeEventListener("click", onclick)
})
"""

# ╔═╡ 01a41608-20f2-11eb-0292-e91712cd52de
clicktracker(x) = let
	id = randid()
	div(id=id, x, script(clicktracker_js(id)))
end

# ╔═╡ dda949f2-20f7-11eb-25d3-bd75bd65e429


# ╔═╡ f1886bda-20f0-11eb-0319-bb2934a24968
p = plot(1:10)

# ╔═╡ 2618a9f6-20f2-11eb-0095-a7c681b42bc0
@bind qq clicktracker(p)

# ╔═╡ 4534f31e-20f5-11eb-3650-adcfa5e05128
qq

# ╔═╡ 6aee3766-20f6-11eb-2c7b-a14979dc3eda
function image_coord_to_plot_coord(x, plt::Plots.Plot)
	
	if length(plt) != 1
		error("This does not work with subplots yet")
	end
	
	big = bbox(p.layout)
	small = plotarea(p[1])
	
	physical_coords = x .* big.a
	fractional_plot_coords = (physical_coords .- small.x0) ./ small.a
	plot_coords = let
		xl = xlims(plt)
		yl = ylims(plt)
		[
			fractional_plot_coords[1] * (xl[2] - xl[1]) + xl[1],
			(1.0 - fractional_plot_coords[2]) * (yl[2] - yl[1]) + yl[1],
		]
	end
	plot_coords
end

# ╔═╡ 7fb74a66-20f6-11eb-134c-29e4bbe5c43a
image_coord_to_plot_coord(qq, p)

# ╔═╡ e51ae92c-20f5-11eb-2eaf-a5ce9bd58a83
ylims(p)

# ╔═╡ 0257d3f6-20f1-11eb-27cf-d96172b2ea26
p.layout

# ╔═╡ 0fa180fc-20f1-11eb-2fd7-391576c05f6a
big = bbox(p.layout)

# ╔═╡ 8b8e511e-20f5-11eb-3821-edbcd53d9d28
physical_coords = qq .* big.a

# ╔═╡ f5f0f42a-20f1-11eb-0f90-5f29a12150b7
big.a

# ╔═╡ f8175942-20f1-11eb-024d-0d10472e3282
big.x0

# ╔═╡ 245433c8-20f1-11eb-3aa7-4f1ed8b287bf
p[1]

# ╔═╡ 26d39ddc-20f1-11eb-348f-9d208c077419
small = plotarea(p[1])

# ╔═╡ ca5a244a-20f5-11eb-0a05-976437fd457d
fractional_plot_coords = (physical_coords .- small.x0) ./ small.a

# ╔═╡ dfc4eb30-20f5-11eb-2737-0bbd53fd295e
plot_coords = let
	xl = xlims(p)
	yl = ylims(p)
	[
		fractional_plot_coords[1] * (xl[2] - xl[1]) + xl[1],
		(1.0 - fractional_plot_coords[2]) * (yl[2] - yl[1]) + yl[1],
	]
end

# ╔═╡ 27bf0be6-20f6-11eb-0482-ebd4ef3dfa9c
let
	p = plot(1:10)
	scatter!(p, plot_coords[1:1], plot_coords[2:2])
end

# ╔═╡ a06a8ed4-20f5-11eb-18c7-1fae86ae46bd
small.a

# ╔═╡ b93630aa-20f5-11eb-3dd7-3d0f1cf9a263
small.x0

# ╔═╡ aed97580-20f1-11eb-285e-89a3c1696618
small.a

# ╔═╡ d655872a-20f1-11eb-0373-953623bf4ba2
1mm

# ╔═╡ c679265e-20f6-11eb-181b-9b398629a76c
begin
	struct BondDefault
		element
		default
	end
	Base.show(io::IO, m::MIME"text/html", bd::BondDefault) = Base.show(io, m, bd.element)
	Base.get(bd::BondDefault) = bd.default
end

# ╔═╡ b73aee2a-20f6-11eb-0f99-7f9fb1352012
let
	if !@isdefined(x0_img_coords)
		global x0_img_coords = [0,0]
	end
	
	p = plot(1:10)
	x0 = image_coord_to_plot_coord(x0_img_coords, p)

	scatter!(p, x0[1:1], x0[2:2])
	
	@bind x0_img_coords BondDefault(clicktracker(p), x0_img_coords)
end

# ╔═╡ 7e3e8ca0-20f9-11eb-3680-4fc0ec2a4a22
md"""
### Scaling directly inside JS
"""

# ╔═╡ c58071c0-20f7-11eb-2473-7bfc5d381182
((x * big.a[1] - small.x0[1]) / small.a[1]) * (xl[2] - xl[1]) + xl[1]

=

x * (big.a[1] / small.a[1]) * (xl[2] - xl[1]) + xl[1] - (xl[2] - xl[1]) * small.x0[1] / small.a[1]

# ╔═╡ a3f00f9c-20f8-11eb-1cdf-73192c3ef4e9
r = let
	xl = xlims(p)
	yl = ylims(p)
	(
		x_offset = xl[1] - (xl[2] - xl[1]) * small.x0[1] / small.a[1],
		x_scale = (big.a[1] / small.a[1]) * (xl[2] - xl[1]),
		y_offset = (yl[2] - yl[1]) + (small.x0[2] / small.a[2]) * (yl[2] - yl[1]) + yl[1],
		y_scale = -(big.a[2]/ small.a[2]) * (yl[2] - yl[1])
	)
end

# ╔═╡ fbe4ed80-20f8-11eb-2db2-015e847f899e
[qq[1] * r.x_scale + r.x_offset, qq[2] * r.y_scale + r.y_offset]

# ╔═╡ 2f5816ea-20f8-11eb-2662-c155f6d71d87
(1.0 - (y * big.a[2] - small.x0[2]) / small.a[2]) * (yl[2] - yl[1]) + yl[1]

=
(1.0 - (y * big.a[2]/ small.a[2] - small.x0[2] / small.a[2]))
* (yl[2] - yl[1])

+ yl[1]

= 

(yl[2] - yl[1]) - 
(y * big.a[2]/ small.a[2] - small.x0[2] / small.a[2])
* (yl[2] - yl[1])

+ yl[1]

= 

(yl[2] - yl[1]) +
-(y * big.a[2]/ small.a[2])
* (yl[2] - yl[1])
+
(small.x0[2] / small.a[2])
* (yl[2] - yl[1])
+ yl[1]

# ╔═╡ a73894a4-20f7-11eb-371a-1bf4c67b41a5
plotclicktracker_js(id, r) = """
const container = document.querySelector("#$(id)")
const graph = container.firstElementChild

const onclick = (e) => {
    const svgrect = graph.getBoundingClientRect()
    const f = [
		(e.clientX - svgrect.left) / svgrect.width, 
		(e.clientY - svgrect.top) / svgrect.height
	]
	container.value = [
		f[0] * $(r.x_scale) + $(r.x_offset),
		f[1] * $(r.y_scale) + $(r.y_offset),
	]
console.log(container.value)
	container.dispatchEvent(new CustomEvent("input"), {})
}

graph.addEventListener("click", onclick)

invalidation.then(() => {
graph.removeEventListener("click", onclick)
})
"""

# ╔═╡ abd30a76-20f7-11eb-3cb6-a3ee8b266a38
plotclicktracker(p::Plots.Plot) = let
	id = randid()
	
	# we need to render the plot before its dimensions are available:
	plot_render = repr(MIME"text/html"(), p)
	
	big = bbox(p.layout)
	small = plotarea(p[1])
	
	xl = xlims(p)
	yl = ylims(p)
	r = (
	x_offset = xl[1] - (xl[2] - xl[1]) * small.x0[1] / small.a[1],
	x_scale = (big.a[1] / small.a[1]) * (xl[2] - xl[1]),
	y_offset = (yl[2] - yl[1]) + (small.x0[2] / small.a[2]) * (yl[2] - yl[1]) + yl[1],
	y_scale = -(big.a[2]/ small.a[2]) * (yl[2] - yl[1])
	)
	@info r xl yl big small
	div(id=id, HTML(plot_render), script(plotclicktracker_js(id, r)))
end

# ╔═╡ fbe98b64-20f9-11eb-1a21-d39ef9c0313b
@bind rar plotclicktracker(p)

# ╔═╡ 3a0bd6e0-20fa-11eb-00df-d921f4ac8756
rar

# ╔═╡ f3d57086-20fa-11eb-23ce-e5dcb1a2b61d
function linepoint(q0)
	p = plot(1:10)
	scatter!(p, q0[1:1], q0[2:2])
end

# ╔═╡ 98835078-20f9-11eb-0dd5-af2892756511
let
	# STEP 1: replace q0 with your variable name in 5 places
	
	if !@isdefined(q0)
		
		# STEP 2: set the initial 'click' location:
		global q0 = [5,5]
	end
	
	# STEP 3: in another cell, write a function that takes the click position as 
	# argument returning a plot. REPLACE `hello` with the name of your function.
	p = linepoint(q0)
	
	@bind q0 BondDefault(plotclicktracker(p), q0)
end

# ╔═╡ 996811d4-20fb-11eb-0292-9f04af86973b
let
	# STEP 1: REPLACE 👀👀👀 with your variable name in 5 places (double click)
	
	if !@isdefined( 👀👀👀 )
		
		# STEP 2: set the initial 'click' location:
		global 👀👀👀 = [5,5]
	end
	
	# STEP 3: in another cell, write a function that takes the click position as 
	# argument returning a plot. REPLACE `COOL_PLOT` with the name of your function.
	p = COOL_PLOT( 👀👀👀 )
	
	@bind 👀👀👀 BondDefault(plotclicktracker(p), 👀👀👀 )
end

# ╔═╡ Cell order:
# ╠═dd5dbc50-20f0-11eb-3bd5-e50d0f23b0b0
# ╠═3027a4ae-20f2-11eb-1dc6-49c6632ef9f9
# ╠═15f01666-20f2-11eb-2b42-9920f62e4fc4
# ╠═767c4e86-20f3-11eb-27a1-591e93e2fc35
# ╠═86b89410-20f3-11eb-1bcc-1fc2a6ce9bad
# ╠═b51deea6-20f3-11eb-187e-6f3bb2900f89
# ╠═f08af15a-20f3-11eb-2c92-dbbd5b6cd8f1
# ╠═01a41608-20f2-11eb-0292-e91712cd52de
# ╠═2618a9f6-20f2-11eb-0095-a7c681b42bc0
# ╠═27bf0be6-20f6-11eb-0482-ebd4ef3dfa9c
# ╠═7fb74a66-20f6-11eb-134c-29e4bbe5c43a
# ╠═dda949f2-20f7-11eb-25d3-bd75bd65e429
# ╠═6aee3766-20f6-11eb-2c7b-a14979dc3eda
# ╠═4534f31e-20f5-11eb-3650-adcfa5e05128
# ╠═8b8e511e-20f5-11eb-3821-edbcd53d9d28
# ╠═ca5a244a-20f5-11eb-0a05-976437fd457d
# ╠═dfc4eb30-20f5-11eb-2737-0bbd53fd295e
# ╠═e51ae92c-20f5-11eb-2eaf-a5ce9bd58a83
# ╠═a06a8ed4-20f5-11eb-18c7-1fae86ae46bd
# ╠═b93630aa-20f5-11eb-3dd7-3d0f1cf9a263
# ╠═f1886bda-20f0-11eb-0319-bb2934a24968
# ╠═0257d3f6-20f1-11eb-27cf-d96172b2ea26
# ╠═0fa180fc-20f1-11eb-2fd7-391576c05f6a
# ╠═f5f0f42a-20f1-11eb-0f90-5f29a12150b7
# ╠═f8175942-20f1-11eb-024d-0d10472e3282
# ╠═245433c8-20f1-11eb-3aa7-4f1ed8b287bf
# ╠═26d39ddc-20f1-11eb-348f-9d208c077419
# ╠═aed97580-20f1-11eb-285e-89a3c1696618
# ╠═3db76506-20f1-11eb-0480-ebaff43db46e
# ╠═d655872a-20f1-11eb-0373-953623bf4ba2
# ╠═c679265e-20f6-11eb-181b-9b398629a76c
# ╠═b73aee2a-20f6-11eb-0f99-7f9fb1352012
# ╟─7e3e8ca0-20f9-11eb-3680-4fc0ec2a4a22
# ╠═c58071c0-20f7-11eb-2473-7bfc5d381182
# ╠═fbe4ed80-20f8-11eb-2db2-015e847f899e
# ╠═a3f00f9c-20f8-11eb-1cdf-73192c3ef4e9
# ╠═2f5816ea-20f8-11eb-2662-c155f6d71d87
# ╠═a73894a4-20f7-11eb-371a-1bf4c67b41a5
# ╠═abd30a76-20f7-11eb-3cb6-a3ee8b266a38
# ╠═3a0bd6e0-20fa-11eb-00df-d921f4ac8756
# ╠═fbe98b64-20f9-11eb-1a21-d39ef9c0313b
# ╠═98835078-20f9-11eb-0dd5-af2892756511
# ╠═f3d57086-20fa-11eb-23ce-e5dcb1a2b61d
# ╠═996811d4-20fb-11eb-0292-9f04af86973b
