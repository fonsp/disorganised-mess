### A Pluto.jl notebook ###
# v0.14.1

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

# ╔═╡ eebe1108-588a-4e81-a69c-f2c21e9cbbaa
using PlutoUI

# ╔═╡ 890b8d1d-1bf0-4497-ac64-9852f68e1577
using Plots

# ╔═╡ 196080df-e8c0-4120-a97c-443cf66295ff
md"""
# Positioning
"""

# ╔═╡ a22411c8-24e0-4a80-9b91-bc1f0999cc3c
Dict([1,"asdf"] => (123, [1,[2,3,[4,5, md"# asdf"]]], md"## asdf", DomainError("asdf")))

# ╔═╡ a93ac790-7a04-418d-8117-01f01e4608c8
:asdf  => 123

# ╔═╡ 88f87c39-89ef-4492-92ae-c6cd33699c59
let
	@info "a asdf   as"
	123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123
	@info "b"
	@info "c"
end

# ╔═╡ 2d01cdaa-fffe-11ea-09f5-63527a1b0f87
@bind x TextField(default="asdfassdf")

# ╔═╡ 2883b3d8-fffe-11ea-0a0f-bbd85ec665ea
begin
	
	
	
	try
		sqrt(-1)
	catch e
		@error "99" exception=(e, catch_backtrace())
	end
end

# ╔═╡ 2fbbb413-213f-4556-b5f9-df7cf6331451
b = @bind hello Slider(1:100)

# ╔═╡ 449541e2-351d-41d2-9623-34d243fe6a97
b

# ╔═╡ 0e823733-4668-47db-8d17-f079b7ed8c75
hello

# ╔═╡ 3599eb82-0003-11eb-3814-dfd0f5737846
for i in 1:10
	
	@debug i
	
	if isodd(i)
		@warn "Oh no!" i
	end
end

# ╔═╡ 5d023cd2-4fe6-4bd0-9a54-7512f52b7916
begin
	
	
	@warn md"""
	_Writing a notebook is not just about writing the final document — Pluto empowers the experiments and discoveries that are essential to getting there._

	**Explore models and share results** in a notebook that is

	-   **_reactive_** - when changing a function or variable, Pluto automatically updates all affected cells.
	-   **_lightweight_** - Pluto is written in pure Julia and is easy to install.
	-   **_simple_** - no hidden workspace state; friendly UI.
	"""
end

# ╔═╡ e5f2703b-198c-4926-867e-7f914fa10253
md"""
# Rich output in logs
"""

# ╔═╡ b52f7e61-c6b5-46ae-8025-d2b4649fed99
svg_data = download("https://diffeq.sciml.ai/stable/assets/multiODEplot.png") |> read

# ╔═╡ 52b8c0be-64f7-4950-ab4a-983c6fa50d1a
cool_plot = Show(MIME"image/png"(), svg_data)

# ╔═╡ 091d33fe-fffe-11ea-131f-01f4248b30ea
@info "23dafs lkjlkjsadf lkj asdflkj asdlkfj alskdjflkasdjflkjasdlfk jsdlkjf sdlkjf   laskjdf lkasdjflkajs df   lkjas dflkjasdlfkjsadf



asdf" x [x,x,cool_plot,x]







# ╔═╡ 504dfdc1-41da-4fcb-ba8e-aa69643d57a1
plot(args...; kwargs...) = Plots.plot(args...; kwargs..., size=(150,120)) |> as_svg

# ╔═╡ 6a7824d0-06e4-4569-9fa8-b9884d299f80
begin
	
	simulation_data = [1,2,23,2,3]
	
	@info plot(simulation_data)


	
end

# ╔═╡ 7c7b11a2-69cf-4cd5-b9e5-f2517211579f
md"""
# @bind in logs
"""

# ╔═╡ d48fb1c0-b88a-4a23-8a87-7fdcd74bf3cc
begin
	
	@info @bind wow Slider(1:100)
	
end

# ╔═╡ 6355afae-d4ad-40f4-9917-3f228a63ddaa
t = collect(1:wow)

# ╔═╡ 70fc79bb-6118-4a0d-ac6e-fbdf1ba9722a
let
	result = sin.(t)
	@info plot(t, result)

	
	result
end

# ╔═╡ d1a1bca1-d01a-4722-8bd9-b759b8ef72d4
md"""
# External logs
"""

# ╔═╡ 4ca5f24f-3139-4dee-a28a-007c936c7363
md"""
### Function defined in another cell:
"""

# ╔═╡ 25bca319-2b63-4013-88be-7607eff3630f
function f(x)
	
	@warn "x might be too large!" x
end

# ╔═╡ 2ade9e4d-11cc-47ae-aaa6-76864757bd21
f(123)

# ╔═╡ 37108eb9-77db-49fa-b168-f9c1c25955fa
md"""
### Function defined in another file:
"""

# ╔═╡ 0bf3e7bd-1da7-441a-9807-6c9473944048
external_src = let
	f = tempname()
	code = """
	function g(x)

		@warn "x might be too large!" x
	end
	"""
	write(f, code)
	f
end

# ╔═╡ cd6c50f6-16d6-4a07-8f20-7450392cd643
function ingredients(path::String)
	# this is from the Julia source code (evalfile in base/loading.jl)
	# but with the modification that it returns the module instead of the last object
	name = Symbol(basename(path))
	m = Module(name)
	Core.eval(m,
        Expr(:toplevel,
             :(eval(x) = $(Expr(:core, :eval))($name, x)),
             :(include(x) = $(Expr(:top, :include))($name, x)),
             :(include(mapexpr::Function, x) = $(Expr(:top, :include))(mapexpr, $name, x)),
             :(include($path))))
	m
end

# ╔═╡ 9cc753a0-f8be-4045-a432-295a05388a4a
m = ingredients(external_src)

# ╔═╡ 1a088b03-ac41-440b-8c82-bd5760590665
m.g(123)

# ╔═╡ 0c9de395-19a9-4ec3-a918-ea3f9835ef18


# ╔═╡ Cell order:
# ╠═eebe1108-588a-4e81-a69c-f2c21e9cbbaa
# ╟─196080df-e8c0-4120-a97c-443cf66295ff
# ╠═a22411c8-24e0-4a80-9b91-bc1f0999cc3c
# ╠═091d33fe-fffe-11ea-131f-01f4248b30ea
# ╠═a93ac790-7a04-418d-8117-01f01e4608c8
# ╠═88f87c39-89ef-4492-92ae-c6cd33699c59
# ╠═2d01cdaa-fffe-11ea-09f5-63527a1b0f87
# ╠═2883b3d8-fffe-11ea-0a0f-bbd85ec665ea
# ╠═2fbbb413-213f-4556-b5f9-df7cf6331451
# ╠═449541e2-351d-41d2-9623-34d243fe6a97
# ╠═0e823733-4668-47db-8d17-f079b7ed8c75
# ╠═3599eb82-0003-11eb-3814-dfd0f5737846
# ╠═5d023cd2-4fe6-4bd0-9a54-7512f52b7916
# ╟─e5f2703b-198c-4926-867e-7f914fa10253
# ╠═b52f7e61-c6b5-46ae-8025-d2b4649fed99
# ╠═52b8c0be-64f7-4950-ab4a-983c6fa50d1a
# ╠═504dfdc1-41da-4fcb-ba8e-aa69643d57a1
# ╠═6a7824d0-06e4-4569-9fa8-b9884d299f80
# ╟─7c7b11a2-69cf-4cd5-b9e5-f2517211579f
# ╠═d48fb1c0-b88a-4a23-8a87-7fdcd74bf3cc
# ╠═890b8d1d-1bf0-4497-ac64-9852f68e1577
# ╠═6355afae-d4ad-40f4-9917-3f228a63ddaa
# ╠═70fc79bb-6118-4a0d-ac6e-fbdf1ba9722a
# ╟─d1a1bca1-d01a-4722-8bd9-b759b8ef72d4
# ╟─4ca5f24f-3139-4dee-a28a-007c936c7363
# ╠═25bca319-2b63-4013-88be-7607eff3630f
# ╠═2ade9e4d-11cc-47ae-aaa6-76864757bd21
# ╟─37108eb9-77db-49fa-b168-f9c1c25955fa
# ╠═0bf3e7bd-1da7-441a-9807-6c9473944048
# ╟─cd6c50f6-16d6-4a07-8f20-7450392cd643
# ╠═9cc753a0-f8be-4045-a432-295a05388a4a
# ╠═1a088b03-ac41-440b-8c82-bd5760590665
# ╠═0c9de395-19a9-4ec3-a918-ea3f9835ef18
