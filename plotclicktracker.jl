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

# ╔═╡ 3c766a76-2104-11eb-3e54-dfb498ef1766
using PlutoUI

# ╔═╡ e9eacfd0-20fd-11eb-0d0f-97a6fe34a16f
begin
	import Pkg
	Pkg.activate(mktempdir())
	Pkg.add([
			Pkg.PackageSpec(name="Plots", version="1.6-1"),
			])
	using Plots
end

# ╔═╡ 4e360478-20fe-11eb-3f6d-9111d385b33d
md"""
# Plots.jl click input

Click somewhere on this graph:
"""

# ╔═╡ 58349090-20fe-11eb-2344-a9895f29ce31
function linepoint(click_coordinate)
	p = plot(1:10)
	scatter!(p, click_coordinate[1:1], click_coordinate[2:2])
end

# ╔═╡ 607d58da-20ff-11eb-2a49-218d6307d7f2
md"""
---
Why is this special? Because normally, the _input_ (`@bind`) and _output_ live in two separate cells:
"""

# ╔═╡ b0084aa8-2100-11eb-18f7-8b68a3a6f85d
@bind x html"<input type=range>"

# ╔═╡ b00c1d36-2100-11eb-395c-6bb0bc0f64bf
sqrt(x)

# ╔═╡ b0190fc8-2100-11eb-073a-95ff9fa6c7c4
md"""
But in our interactive plot, the input and output are inside _the same cell_. To achieve this, we need a couple of Pluto tricks -- have a look at the code behind the first plot if you are curious. 

# Template

The code is complicated, but luckily, it is _the same code_ for every plot that takes the mouse as input coordinate. We have written a template below, with three simple steps to create this kind of plot yourself.
"""

# ╔═╡ 8b129e70-20ff-11eb-1e52-4fed0031b63e
function COOL_PLOT(q0)
	p = plot(1:10)
	scatter!(p, q0[1:1], q0[2:2])
	
	return p
end

# ╔═╡ c59120f6-2133-11eb-08aa-4f77f9ece24c
md"""
# TO DAVID

I was working on a macro to do this automatically, it's pretty much finished but not entirely - sneak peek below
"""

# ╔═╡ 18b00acc-2109-11eb-2074-01caf7f8e3e5


# ╔═╡ 623fea10-2105-11eb-00d5-dd3306468200
Dumpall(x) = Dump(x, maxdepth=999999)

# ╔═╡ eaea1bc6-2103-11eb-3088-f155fc10ff5d
macroexpand(@__MODULE__, quote
		@hello [3,3] @bind snota plotclicktracker(COOL_PLOT(snota))
	end; recursive=false) |> Base.remove_linenums! |> Dumpall

# ╔═╡ 3208086c-2109-11eb-15c7-0ded6799e390
quote

# ╔═╡ 3701f512-2107-11eb-35bf-251d49e57295
function helloresult(default, bind_expr::Expr)
	sym = bind_expr.args[3]
	quote
		if false == @isdefined($sym)
			$(esc(sym)) = $(esc(default))
		end
		
		@bind $(sym) $(esc(bind_expr.args[4]))
	end
end

# ╔═╡ d5440fca-2103-11eb-1d37-57423037da83
macro hello(default::Any, bind_expr::Expr)
	a = bind_expr.args
# 	if expr.head != :macrocall || a[1] != Symbol("@bind")
# 		return :(error("Needs to be applied to a @bind expression"))
# 	end
	
# 	if !(length(a) == 4 && 
# 			(a[3] isa Expr && a[3].head == :(=) && a[3].args[1] isa Symbol))
# 		return :(error("You need to assign a default value. Examle:"))
# 	end
	
	
	
# 	return expr
# 	sym = bind_expr.args[1])
# 	default = esc(a[3].args[2])
	
# 	# :(esc(:Dump)($(esc(expr))))
# 	quote
# 		if !@isdefined($sym)
# 			$sym = $default
# 		end
		
# 		@bind $sym $(esc(a[4]))
# 	end
	helloresult(default, bind_expr)
end

# ╔═╡ b19a3982-2106-11eb-1751-f3e91ba65a77
# function helloresult(expr)
# 	a = expr.args
# 	sym = a[3].args[1]
# 	default = a[3].args[2]
# 	quote
# 		if !@isdefined($sym)
# 			$sym = $default
# 		end
		
# 		@bind $sym $(expr.args[4])
# 	end
# end

# ╔═╡ 1e1d4f72-2109-11eb-05d6-df3767e99434
macroexpand(@__MODULE__, quote
		@bye [3,3] @bind snota plotclicktracker(COOL_PLOT(snota))
	end; recursive=false) |> Base.remove_linenums! |> Dumpall

# ╔═╡ 1272f4a6-210b-11eb-33ff-a54af8f714c1
default_usage_error = :(error("Example usage:\n\n@default [1,2] @bind x f(x)\n"))

# ╔═╡ 512eacd4-210a-11eb-222d-0d7309e3e6ab
macro default(::Any)
	default_usage_error
end

# ╔═╡ 2839c27e-2109-11eb-3763-715e13deb9c7
function bye_funk(default, bind_expr)
	sym = bind_expr.args[3]
	quote
		if !@isdefined($sym)
			$sym = $default
		end
		
		@bind $sym $(bind_expr.args[4])
	end
end

# ╔═╡ 2105339e-2109-11eb-05e5-43a837b52a7e
macro default(default, bind_expr::Expr)
	if bind_expr.head != :macrocall || bind_expr.args[1] != Symbol("@bind")
		return default_usage_error
	end
	
	# warn if the first argument is a @bind
	if default isa Expr && default.head == :macrocall && default.args[1] == Symbol("@bind")
		return default_usage_error
	end
		
	esc(bye_funk(default, bind_expr))
end

# ╔═╡ 9e3a08ce-2101-11eb-0b21-31a5843403ca
md"""
The third step is to write a function that:
- takes a **click coordinate** (a vector `[x, y]`) as input, and 
- returns a plot.

It's up to _you_ to use this coordinate in a creative way!
"""

# ╔═╡ c42299fa-2103-11eb-0a3b-cd0e2c10dc33
md"""
#### Why not create a macro?

Because Pluto does not understand macros yet. 
"""

# ╔═╡ 15e0dc00-20ff-11eb-1a4d-71579b2970b7
md"""
## Necessary functions

You can copy these cells into your notebook by selecting them (start dragging a selection rectangle from inbetween two cells), and dragging them into another notebook. 
"""

# ╔═╡ 61360a66-20fe-11eb-2690-83091d06da81
begin
	"Wrap around an element, and give it a default value for `@bind`."
	struct BondDefault
		element
		default
	end
	Base.show(io::IO, m::MIME"text/html", bd::BondDefault) = Base.show(io, m, bd.element)
	Base.get(bd::BondDefault) = bd.default
	BondDefault
end

# ╔═╡ 6a95ebb2-20fe-11eb-33c4-6d5c2c0af706
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
	container.dispatchEvent(new CustomEvent("input"), {})
}

graph.addEventListener("click", onclick)

invalidation.then(() => {
graph.removeEventListener("click", onclick)
})
"""

# ╔═╡ 6a998f62-20fe-11eb-3104-5d96f4718ccb
plotclicktracker(p::Plots.Plot) = let
	id = String(rand(('a':'z') ∪ ('A':'Z'), 12))
	
	# we need to render the plot before its dimensions are available:
	plot_render = repr(MIME"text/html"(), p)
	
	# these are the _bounding boxes_ of our plot
	big = bbox(p.layout)
	small = plotarea(p[1])
	
	# the axis limits
	xl = xlims(p)
	yl = ylims(p)
	
	# with this information, we can form the linear transformation from 
	# screen coordinate -> plot coordinate
	
	# this is done on the JS side, to avoid one step in the Julia side
	# we send the linear coefficients:
	r = (
	x_offset = xl[1] - (xl[2] - xl[1]) * small.x0[1] / small.a[1],
	x_scale = (big.a[1] / small.a[1]) * (xl[2] - xl[1]),
	y_offset = (yl[2] - yl[1]) + (small.x0[2] / small.a[2]) * (yl[2] - yl[1]) + yl[1],
	y_scale = -(big.a[2]/ small.a[2]) * (yl[2] - yl[1])
	)
	HTML("""<div id=$(id)>$(plot_render)<script>$(plotclicktracker_js(id, r))</script></div>""")
end

# ╔═╡ 5711a7d4-20fe-11eb-3058-69e4348b96e6
let
	# we need to reference x0 in this cell --before assigning to x0-- to
	# register as self-updating cell
	if !@isdefined( x0 )
		# x0 not defined means that this is the first run
		# when the bond sets a value, the new value will be assigned to x0
		# __before__ this cell is run.
		# so x0 defined means that this cell is running as
		# response to the bond update
		
		# set a default value
		global x0 = [5,5]
	end
	
	# we generate the plot, which uses the clicked coordinate
	p = linepoint( x0 )
	
	# we use BondDefault to make sure that the default @bind value is 
	# equal to the old value. This is not strictly necessary (because we already 
	# generated the plot with the correct value for x0), but if we don't then
	# x0 will equal `missing` in _other_ cells.
	@bind x0 BondDefault(plotclicktracker(p), x0 )
end

# ╔═╡ 59eb1f44-2103-11eb-04dd-594b96f10c15
x0

# ╔═╡ 5ce01c3a-20ff-11eb-26d6-57c07dfdc276
let
	# STEP 1: REPLACE 👀👀👀 with your variable name everywhere
	
	if !@isdefined( 👀👀👀 )
		
		# STEP 2: set the initial 'click' location:
		global 👀👀👀 = [5,5]
	end
	
	# STEP 3: in another cell, write a function that takes the click position as 
	# argument returning a plot. REPLACE `COOL_PLOT` with the name of your function.
	p = COOL_PLOT( 👀👀👀 )
	
	@bind 👀👀👀 BondDefault(plotclicktracker(p), 👀👀👀 )
end

# ╔═╡ 21a56a1a-2106-11eb-2c39-b9b396bce992
@hello [3,3] @bind w plotclicktracker(COOL_PLOT(w))

# ╔═╡ e670e390-2108-11eb-15c7-792518acf12f
w

# ╔═╡ 8955aaf0-2109-11eb-0204-e5a031587e12
@default [3,3] @bind c BondDefault(plotclicktracker(COOL_PLOT(c)), c)

# ╔═╡ 45b15942-210a-11eb-2722-938624e89e9a
@default [1,2] @bind ca plotclicktracker(COOL_PLOT(ca))

# ╔═╡ 91a3614a-2102-11eb-3e5b-dd99598e57d0
md"""
You can also use [`ingredients`](https://github.com/fonsp/Pluto.jl/issues/115#issuecomment-661722426) to load this notebook into another notebook.
"""

# ╔═╡ 119f2e96-20ff-11eb-1cc1-259f842a8cd8
md"""
## Packages

(We only need Plots.jl)
"""

# ╔═╡ Cell order:
# ╟─4e360478-20fe-11eb-3f6d-9111d385b33d
# ╟─5711a7d4-20fe-11eb-3058-69e4348b96e6
# ╠═59eb1f44-2103-11eb-04dd-594b96f10c15
# ╠═58349090-20fe-11eb-2344-a9895f29ce31
# ╟─607d58da-20ff-11eb-2a49-218d6307d7f2
# ╠═b0084aa8-2100-11eb-18f7-8b68a3a6f85d
# ╠═b00c1d36-2100-11eb-395c-6bb0bc0f64bf
# ╟─b0190fc8-2100-11eb-073a-95ff9fa6c7c4
# ╠═5ce01c3a-20ff-11eb-26d6-57c07dfdc276
# ╠═8b129e70-20ff-11eb-1e52-4fed0031b63e
# ╠═c59120f6-2133-11eb-08aa-4f77f9ece24c
# ╠═21a56a1a-2106-11eb-2c39-b9b396bce992
# ╠═18b00acc-2109-11eb-2074-01caf7f8e3e5
# ╠═e670e390-2108-11eb-15c7-792518acf12f
# ╠═eaea1bc6-2103-11eb-3088-f155fc10ff5d
# ╠═623fea10-2105-11eb-00d5-dd3306468200
# ╠═3c766a76-2104-11eb-3e54-dfb498ef1766
# ╠═d5440fca-2103-11eb-1d37-57423037da83
# ╠═3208086c-2109-11eb-15c7-0ded6799e390
# ╠═3701f512-2107-11eb-35bf-251d49e57295
# ╠═b19a3982-2106-11eb-1751-f3e91ba65a77
# ╠═1e1d4f72-2109-11eb-05d6-df3767e99434
# ╠═8955aaf0-2109-11eb-0204-e5a031587e12
# ╠═45b15942-210a-11eb-2722-938624e89e9a
# ╠═1272f4a6-210b-11eb-33ff-a54af8f714c1
# ╠═512eacd4-210a-11eb-222d-0d7309e3e6ab
# ╠═2105339e-2109-11eb-05e5-43a837b52a7e
# ╠═2839c27e-2109-11eb-3763-715e13deb9c7
# ╟─9e3a08ce-2101-11eb-0b21-31a5843403ca
# ╠═c42299fa-2103-11eb-0a3b-cd0e2c10dc33
# ╠═15e0dc00-20ff-11eb-1a4d-71579b2970b7
# ╟─61360a66-20fe-11eb-2690-83091d06da81
# ╟─6a95ebb2-20fe-11eb-33c4-6d5c2c0af706
# ╟─6a998f62-20fe-11eb-3104-5d96f4718ccb
# ╟─91a3614a-2102-11eb-3e5b-dd99598e57d0
# ╟─119f2e96-20ff-11eb-1cc1-259f842a8cd8
# ╠═e9eacfd0-20fd-11eb-0d0f-97a6fe34a16f
