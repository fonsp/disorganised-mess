### A Pluto.jl notebook ###
# v0.12.17

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

# ╔═╡ 030017c4-4073-11eb-3fe0-e5cc350da539
using JuMP

# ╔═╡ 1ebf08ce-4073-11eb-05f0-9d0315ad5ebf
using GLPK

# ╔═╡ 7ef0bf58-6414-4c6f-8bce-5ec280663579
using PlutoUI

# ╔═╡ 68e07edd-55dd-45d8-9f8a-24ae75a20960
@bind xmax Slider(1:.01:4)

# ╔═╡ 470eaa98-4073-11eb-349d-e9c34e5478c2
begin
	model = Model(GLPK.Optimizer)
	x = @variable(model, 0 <= x <= xmax)
	y = @variable(model, 0 <= y <= 30)
	
	Max = @objective(model, Max, 5x + 3 * y)
	
	con = @constraint(model, con, 1x + 5y <= 3)
	
	model
end

# ╔═╡ 2717450b-8e9d-4be4-9156-53b2020a2e5d
Print(model)

# ╔═╡ 95e0721d-321f-478c-8d02-0ac070008a5b
model_optimized = let
	optimize!(model)
	model
end

# ╔═╡ 69a565bc-e250-4105-9b6b-3b9879dcb417
termination_status(model_optimized)

# ╔═╡ e4d0ad7b-9e72-45c7-9eb9-0ed06567aef8
objective_value(model)

# ╔═╡ 15037686-c495-42c3-b976-11ac753dde18
value(x)

# ╔═╡ 946b13ae-65f2-4844-a38a-693b2f01bad4
value(y)

# ╔═╡ f33c8560-c309-46b3-9d01-be116137d19a
f(a::Number, b::Number) = 5a + 3b

# ╔═╡ b2dcea20-334e-4cac-acdc-42a183b72e6e
f(a, b) = a

# ╔═╡ dae4fa14-fc3a-4d89-8b80-16b929c6c337
md"""
# Arrays
"""

# ╔═╡ 2f4cce86-6864-4772-83ff-4bce7b204f00


# ╔═╡ Cell order:
# ╠═030017c4-4073-11eb-3fe0-e5cc350da539
# ╠═1ebf08ce-4073-11eb-05f0-9d0315ad5ebf
# ╠═7ef0bf58-6414-4c6f-8bce-5ec280663579
# ╠═68e07edd-55dd-45d8-9f8a-24ae75a20960
# ╠═470eaa98-4073-11eb-349d-e9c34e5478c2
# ╠═2717450b-8e9d-4be4-9156-53b2020a2e5d
# ╠═95e0721d-321f-478c-8d02-0ac070008a5b
# ╠═69a565bc-e250-4105-9b6b-3b9879dcb417
# ╠═e4d0ad7b-9e72-45c7-9eb9-0ed06567aef8
# ╠═15037686-c495-42c3-b976-11ac753dde18
# ╠═946b13ae-65f2-4844-a38a-693b2f01bad4
# ╠═f33c8560-c309-46b3-9d01-be116137d19a
# ╠═b2dcea20-334e-4cac-acdc-42a183b72e6e
# ╠═dae4fa14-fc3a-4d89-8b80-16b929c6c337
# ╠═2f4cce86-6864-4772-83ff-4bce7b204f00
