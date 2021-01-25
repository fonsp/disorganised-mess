### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 36ad3558-5b14-11eb-2376-7df618f09add
begin
	import Pkg
	Pkg.activate("/Users/fons/Documents/MargoAPI.jl/")
	ENV["JULIA_MARGO_LOAD_PYPLOT"] = "no thank you"
	import ClimateMARGO
	using ClimateMARGO.Models
	using ClimateMARGO.Optimization
	using ClimateMARGO.Diagnostics
end

# ╔═╡ 05839505-0734-4845-b643-9af16924b780


# ╔═╡ 58ff058a-b519-4196-ab4d-594961245f94
dt = 12

# ╔═╡ 1a637eb6-261d-42d0-b690-7b9b5eeebc00
begin
	model_parameters = deepcopy(ClimateMARGO.IO.included_configurations["default"])::ClimateModelParameters
    model_parameters.domain = Domain(Float64(dt), 2020.0, 2200.0)
    model_parameters.economics.baseline_emissions = ramp_emissions(model_parameters.domain)
    model_parameters.economics.extra_CO₂ = zeros(size(model_parameters.economics.baseline_emissions))
end

# ╔═╡ 7215dff3-7591-4995-8a25-f15c35d188f8

Base.@kwdef mutable struct MRGA{T}
    M::T
    R::T
    G::T
    A::T
end

# ╔═╡ d2254778-f7c2-4d65-94e0-46cc5fe760b5
model = ClimateModel(model_parameters)

# ╔═╡ 72b63df2-4d37-45e9-81bb-62c3382b8f23
max_slope = Dict("mitigate"=>1. /40., "remove"=>1. /40., "geoeng"=>1. /80., "adapt"=> 0.)

# ╔═╡ bdeb8a0f-8bad-4ecc-a320-cda223f34ea9
md"""
# Current syntax
"""

# ╔═╡ 2b9443d4-3881-4c06-8302-c85d35557163
function enforce_maxslope!(controls;
		dt,
	max_slope=Dict("mitigate"=>1. /40., "remove"=>1. /40., "geoeng"=>1. /80., "adapt"=> 0.)
	)
	controls.mitigate[1] = 0.0
	controls.remove[1] = 0.0
	controls.geoeng[1] = 0.0
	# controls.adapt[1] = 0.0
	
	
	for i in 2:length(controls.mitigate)
		controls.mitigate[i] = clamp(
			controls.mitigate[i], 
			controls.mitigate[i-1] - max_slope["mitigate"]*dt, 
			controls.mitigate[i-1] + max_slope["mitigate"]*dt
		)
		controls.remove[i] = clamp(
			controls.remove[i], 
			controls.remove[i-1] - max_slope["remove"]*dt, 
			controls.remove[i-1] + max_slope["remove"]*dt
		)
		controls.geoeng[i] = clamp(
			controls.geoeng[i], 
			controls.geoeng[i-1] - max_slope["geoeng"]*dt, 
			controls.geoeng[i-1] + max_slope["geoeng"]*dt
		)
		controls.adapt[i] = clamp(
			controls.adapt[i], 
			controls.adapt[i-1] - max_slope["adapt"]*dt, 
			controls.adapt[i-1] + max_slope["adapt"]*dt
		)
	end
end

# ╔═╡ b02930bb-11e6-4147-ae9f-b4ff9ff09eaa
N = length(t(model))

# ╔═╡ 43fb5489-de68-4aa4-8e05-b2b4ba739842
begin
	
	model.controls.geoeng .= 0.5
	
	enforce_maxslope!(model.controls; dt=dt)
	
	
	
	model.controls
end

# ╔═╡ e8d45e34-05d6-462c-9e73-4619e625ac1a
md"""
# Compact syntax
"""

# ╔═╡ 600ee5be-a409-47a1-adb9-9a12948edaf9
# function enforce_maxslope!(controls; 
# 	max_slope=MRGA(1/40, 1/40, 1/80, 0)
# 	)
	
# 	for (tech, value) in controls
# 		value[1] = 0.0
		
# 		for i in 2:N
# 			value[i] = clamp(
# 				value[i], 
# 				value[i-1] - max_slope[tech]*dt, 
# 				value[i-1] + max_slope[tech]*dt
# 			)
# 		end
# 	end
# end

# ╔═╡ b8319ffb-b49a-4287-95e4-a9b6a8f1d8eb
model.economics

# ╔═╡ 5b3f226e-3cb1-42d8-9982-5c2c4934af9c




function costs_dict(costs, model)
    Dict(
        :discounted => costs,
        :total_discounted => sum(costs .* model.domain.dt),
    )
end


# ╔═╡ dbbadb20-9552-45f9-a65c-f46d34cd89ad

model_results(model::ClimateModel) = Dict(
    :controls => model.controls,
    :computed => Dict(
        :temperatures => Dict(
            :baseline => T_adapt(model),
            :M => T_adapt(model; M=true),
            :MR => T_adapt(model; M=true, R=true),
            :MRG => T_adapt(model; M=true, R=true, G=true),
            :MRGA => T_adapt(model; M=true, R=true, G=true, A=true),
        ),
        :emissions => Dict(
            :baseline => effective_emissions(model),
            :M => effective_emissions(model; M=true),
            :MRGA => effective_emissions(model; M=true, R=true),
        ),
        :concentrations => Dict(
            :baseline => c(model),
            :M => c(model; M=true),
            :MRGA => c(model; M=true, R=true),
        ),
        :damages => Dict(
            :baseline => costs_dict(damage(model; discounting=true), model),
            :MRGA => costs_dict(damage(model; M=true, R=true, G=true, A=true, discounting=true), model),
        ),
        :costs => Dict(
            :M => costs_dict(cost(model; M=true, discounting=true), model),
            :R => costs_dict(cost(model; R=true, discounting=true), model),
            :G => costs_dict(cost(model; G=true, discounting=true), model),
            :A => costs_dict(cost(model; A=true, discounting=true), model),
            :MRGA => costs_dict(cost(model; M=true, R=true, G=true, A=true, discounting=true), model),
        ),
    ),
)

# ╔═╡ 0340e5f3-2478-4461-b6b5-71881436b975
model_results(model)

# ╔═╡ Cell order:
# ╠═36ad3558-5b14-11eb-2376-7df618f09add
# ╠═05839505-0734-4845-b643-9af16924b780
# ╠═58ff058a-b519-4196-ab4d-594961245f94
# ╠═1a637eb6-261d-42d0-b690-7b9b5eeebc00
# ╠═7215dff3-7591-4995-8a25-f15c35d188f8
# ╠═d2254778-f7c2-4d65-94e0-46cc5fe760b5
# ╠═0340e5f3-2478-4461-b6b5-71881436b975
# ╠═72b63df2-4d37-45e9-81bb-62c3382b8f23
# ╟─bdeb8a0f-8bad-4ecc-a320-cda223f34ea9
# ╠═2b9443d4-3881-4c06-8302-c85d35557163
# ╠═b02930bb-11e6-4147-ae9f-b4ff9ff09eaa
# ╠═43fb5489-de68-4aa4-8e05-b2b4ba739842
# ╟─e8d45e34-05d6-462c-9e73-4619e625ac1a
# ╠═600ee5be-a409-47a1-adb9-9a12948edaf9
# ╠═b8319ffb-b49a-4287-95e4-a9b6a8f1d8eb
# ╠═dbbadb20-9552-45f9-a65c-f46d34cd89ad
# ╠═5b3f226e-3cb1-42d8-9982-5c2c4934af9c
