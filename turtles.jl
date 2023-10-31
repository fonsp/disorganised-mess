### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 70160fec-b0c7-11ea-0c2a-35418346592e
@bind angle HTML("<input type='range' min='0' step='$(pi/100)' max='$(pi/2)'>")

# ╔═╡ ab083f08-b0c0-11ea-0c23-315c14607f1f
md"# 🐢 definition"

# ╔═╡ 310a0c52-b0bf-11ea-3e32-69d685f2f45e
Drawing = Vector{String}

# ╔═╡ 6bbb674c-b0ba-11ea-2ff7-ebcde6573d5b
mutable struct Turtle
	pos::Tuple{Number, Number}
	heading::Number
	pen_down::Bool
	history::Drawing
end

# ╔═╡ 5560ed36-b0c0-11ea-0104-49c31d171422
md"## Turtle commands"

# ╔═╡ e6c7e5be-b0bf-11ea-1f7e-73b9aae14382
function forward!(🐢::Turtle, distance::Number)
	old_pos = 🐢.pos
	new_pos = 🐢.pos = old_pos .+ (distance .* (cos(🐢.heading), sin(🐢.heading)))
	if 🐢.pen_down
		push!(🐢.history, """<line x1="$(old_pos[1])" y1="$(old_pos[2])" x2="$(new_pos[1])" y2="$(new_pos[2])" stroke="black" stroke-width="3" />""")
	end
	🐢
end

# ╔═╡ 573c11b4-b0be-11ea-0416-31de4e217320
backward!(🐢::Turtle, by::Number) = foward!(🐢, -by)

# ╔═╡ fc44503a-b0bf-11ea-0f28-510784847241
function right!(🐢::Turtle, angle::Number)
	🐢.heading -= angle
end

# ╔═╡ 47907302-b0c0-11ea-0b27-b5cd2b4720d8
left!(🐢::Turtle, angle::Number) = right!(🐢, -angle)

# ╔═╡ 5aea06d4-b0c0-11ea-19f5-054b02e17675
md"## Function to make turtle drawings with"

# ╔═╡ 6dbce38e-b0bc-11ea-1126-a13e0d575339
function turtle_drawing(f::Function)
	🐢 = Turtle((150, 150), pi*3/2, true, String[])
	
	f(🐢)
	
	image = """<svg version="1.1"
     baseProfile="full"
     width="300" height="300"
     xmlns="http://www.w3.org/2000/svg">""" * join(🐢.history) * "</svg>"
	return HTML(image)
end

# ╔═╡ d30c8f2a-b0bf-11ea-0557-19bb61118644
turtle_drawing() do t
	
	for i in 1:100
		right!(t, angle)
		forward!(t, i)
	end
	
end

# ╔═╡ Cell order:
# ╠═70160fec-b0c7-11ea-0c2a-35418346592e
# ╠═d30c8f2a-b0bf-11ea-0557-19bb61118644
# ╟─ab083f08-b0c0-11ea-0c23-315c14607f1f
# ╠═6bbb674c-b0ba-11ea-2ff7-ebcde6573d5b
# ╠═310a0c52-b0bf-11ea-3e32-69d685f2f45e
# ╟─5560ed36-b0c0-11ea-0104-49c31d171422
# ╠═e6c7e5be-b0bf-11ea-1f7e-73b9aae14382
# ╠═573c11b4-b0be-11ea-0416-31de4e217320
# ╠═fc44503a-b0bf-11ea-0f28-510784847241
# ╠═47907302-b0c0-11ea-0b27-b5cd2b4720d8
# ╟─5aea06d4-b0c0-11ea-19f5-054b02e17675
# ╠═6dbce38e-b0bc-11ea-1126-a13e0d575339
