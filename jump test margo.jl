### A Pluto.jl notebook ###
# v0.12.17

using Markdown
using InteractiveUtils

# ╔═╡ ad6eca7c-3d88-4403-92f3-e7dad7d96887
using ClimateMARGO.Models

# ╔═╡ 406d4ab9-7127-4bda-a2b0-9354c2ce9f39
using ClimateMARGO.Optimization

# ╔═╡ b44a65a4-cab8-4038-b830-1eeabed4f9e9
using ClimateMARGO.Diagnostics

# ╔═╡ 2aa91e85-5a35-40ac-8657-590c8e8e8007
using JuMP

# ╔═╡ 8f260d68-b919-44a4-acae-423a357cef3c
using Plots

# ╔═╡ 0794d76e-9413-4c28-b4a9-104dc12d0b6d
using PlutoUI

# ╔═╡ a26a5645-bbe7-4efd-85d6-0d3fb3b487a7
md"""
# MARGO JuMP arrays test

"""

# ╔═╡ 3c6b68f0-4081-11eb-2393-2b8fb00657e2
import ClimateMARGO

# ╔═╡ 52597d62-c730-42da-b983-61f2b9816f01
model_parameters = deepcopy(ClimateMARGO.IO.included_configurations["default"])::ClimateModelParameters

# ╔═╡ 1cf5a0c0-0b97-4802-87f9-8410d47f4873
time = let
	d = model_parameters.domain
	d.initial_year:d.dt:d.final_year
end

# ╔═╡ fca12051-3d72-45b1-b791-7ddec21704cd


# ╔═╡ 24ffa39d-5206-4ea7-a680-6da8dc0daa1d
max_slope_M = .02

# ╔═╡ 575d53ed-ede5-4d09-a9bd-38f2a3962c55
md"""
## Simple forward model function

To keep things simple, we wrap MARGO's forward model in a number of functions with:
- input: `Vector{Real}`
- output: `Real` or `Vector{Real}`
"""

# ╔═╡ 79a0b0b4-adbc-48a2-874a-bfb88c1a2a36
function temperatures_controlled(M::Vector{<:Real})::Vector{<:Real}
	model = ClimateModel(model_parameters)
	
	model.controls.mitigate = M
	T(model; M=true, R=true, G=true)
end

# ╔═╡ cdac10a8-99a2-47f0-8e5b-6275b0801baf
sample_M = fill(0.5, length(time))

# ╔═╡ 8cf95f10-6445-41e3-b67e-0a6868af0944
temperatures_controlled(sample_M)

# ╔═╡ fde600f7-b359-44cb-878b-bfcc9d89388b
function final_temperature_controlled(M::Vector{<:Real})::Real
	temperatures_controlled(M)[end]
end

# ╔═╡ cdac2914-a1f7-4c29-97c4-931146703a94
final_temperature_controlled(sample_M)

# ╔═╡ 8c8c1573-0dac-44d2-9486-ccc134a3142d
function control_costs(M::Array{<:Real,1})::Real
	model = ClimateModel(model_parameters)
	
	model.controls.mitigate = M
	costs = cost(model; M=true, discounting=true)
	
	sum(costs .* model.domain.dt)
end

# ╔═╡ 51d79aed-0316-4e13-b25a-aadc5b1e266f
control_costs(sample_M)

# ╔═╡ 0f550146-9c67-474e-bcf5-a8f66f6d5928
md"""
## Let's optimize!
"""

# ╔═╡ 76abb0dd-3ba0-48f5-a909-c5bb97f10854
import Ipopt

# ╔═╡ 6659e62c-b019-4f42-bde6-c5957a6e9c90
setup_opt_model() = Model(optimizer_with_attributes(Ipopt.Optimizer,
	"acceptable_tol" => 1.e-8, "max_iter" => Int64(1e8),
	"acceptable_constr_viol_tol" => 1.e-3, "constr_viol_tol" => 1.e-4,
	"print_frequency_iter" => 50,  "print_timing_statistics" => "no",
	"print_level" => 0,
))

# ╔═╡ d4c7acf5-dbd7-448c-9ecf-1dcef1c00033
md"""
### Wrapping functions
We can have "vectors" in JuMP, but really, they are a list of scalar variables, with handy notation. It is not a vector in the sense of `Array`. 

You cannot call a JuMP-registered Julia function with a JuMP vector, but you can call a function that takes a long list of arguments. So if we want to register a function that takes an array as argument, we have to write a wrapper function. [This trick is described in the JuMP docs](https://jump.dev/JuMP.jl/v0.21.1/nlp/#User-defined-functions-with-vector-inputs-1)
"""

# ╔═╡ e10c98a3-1bfc-4d0a-a550-46c0a014532d
temperatures_controlled_jump(M...) = temperatures_controlled(collect(M))

# ╔═╡ 98fe65f7-7a60-43af-8509-690aaa7828c6
final_temperature_controlled_jump(M...) = final_temperature_controlled(collect(M))

# ╔═╡ 11612fc8-382a-4fdb-ae87-51d7819c284d
control_costs_jump(M...) = control_costs(collect(M))

# ╔═╡ 3c6b1f01-bc0e-492e-b6d0-aca9a26c9f86
T_max = 2.5

# ╔═╡ 28e345c0-9b4c-47b5-9d87-4c0d7ef96de3
begin
	model_optimizer = setup_opt_model()
	
	local m = model_optimizer
	local N = length(time)
	
	M = @variable(model_optimizer, 0.0 <= M[1:N] <= 1.0)

	
	# Register our wrapper functions
	###
	
	register(m, 
		:final_temperature_controlled_jump, 
		N, 
		final_temperature_controlled_jump, 
		autodiff=true
	)
	register(m, 
		:control_costs_jump, 
		N, 
		control_costs_jump, 
		autodiff=true
	)
	# register(m, 
	# 	:temperatures_controlled_jump, 
	# 	N, 
	# 	temperatures_controlled_jump, 
	# 	autodiff=true
	# )
	
	
	# Temperature constraint
	###
	
    temp_constraints = @NLconstraint(m, 
		final_temperature_controlled_jump(M...) <= T_max)
	
	
	
	# Slope constraint
	###
	
	max_difference_M = max_slope_M * step(time)
	
	dM = @variable(m, 
		-max_difference_M <= dM[1:N-1] <= max_difference_M
	)
	diff_con = @constraint(m, diff_con[i = 1:N-1],
		dM[i] == (M[i+1] - M[i])
	)
	
	# Initial value constraint
	###
	
	init_con = @constraint(m, init_con,
		M[1] == 0.0
	)
	
	
	# Objective
	###
	
	min_objective = @NLobjective(
		m, Min, 
		control_costs_jump(M...)
	)
	
	model_optimizer
end;

# ╔═╡ 354c0322-7aa8-4541-bd88-4193aaa7c2d4
md"""
### Run the optimization
"""

# ╔═╡ e62e59d7-05f5-41dc-9162-f8a9f0825169
model_optimized = let
	optimize!(model_optimizer)
	model_optimizer
end

# ╔═╡ 2cbcf37f-657e-4b0e-933f-ff2818b54a57
termination_status(model_optimized)

# ╔═╡ 8e9344df-0633-4608-8fc1-0ab601d69bd6
objective_value(model_optimized)

# ╔═╡ fd32e430-3b4f-4de6-aa46-2ce265de5add
M_optimized = let
	model_optimized
	value.(M)
end

# ╔═╡ f7c5bb61-9bee-41e5-b337-b68850c3f956
md"""
## Result
"""

# ╔═╡ 333a1520-9edf-4789-ac1f-75c5e7e2a694
plot(time, M_optimized, 
	title="Optimized Mitigation",
	dpi=300, size=(400,200))

# ╔═╡ 7a5f2082-c634-4b67-9ab5-c65fca14c169
plot(time, temperatures_controlled(M_optimized), 
	title="Temperature increase",
	dpi=300, size=(400,200))

# ╔═╡ c3dcfc24-2bab-4327-a639-30f3020a8f2f
md"""
# Conclusion

I was able to run some MARGO functions directly inside JuMP:
- The total control costs
- The final temperature

These are both functions that take the `M` array as input, and return a scalar. I had to make one modification to ClimateMARGO.jl: the type of the control vectors changed from `Vector{Float64}` to `Vector{<:Real}`. This is necessary because JuMP uses forward mode automatic diff: it runs your function with dual numbers instead of floats. See the diff [here](https://github.com/ClimateMARGO/ClimateMARGO.jl/compare/forward-diffable) (don't merge this yet).

Using these two I was able to: _minimize_ control costs _subject to_ `temp[2200] <= T_max` (i.e. overshoot allowed).

---

**I was not able** to write the global temperature constraint, without calculating the entire temperature series once for each variable M. To my knowledge, it is not possible have this NLconstraint:
```
f(my_vector...) <= my_scalar
```

because you can only give scalar equations & constraints to JuMP. If you write a 'vector constraint' in JuMP, it is really just a pointwise scalar constraint, and this is not the case with our 'black box' Vector->Vector function.
"""

# ╔═╡ 06170709-ac84-46ec-ada4-149732b08256
md"""
## 4 vectors instead of 1

The unwrapping trick can also be used to take the M, R, G, A arrays as inputs:
"""

# ╔═╡ 6cce8e6f-fffd-4a81-b1f9-0dfc34ff746e
small_N = 2

# ╔═╡ 4fb435ce-5929-4595-9a89-8ffbfdc14c0f
f(M, R, G, A) = M .+ R .+ G .+ A

# ╔═╡ 57b82807-2954-43ad-9c54-7745944986da
function f_wrapped(MRGA...)
	M = collect(MRGA[              1 : 1 * small_N])
	R = collect(MRGA[    small_N + 1 : 2 * small_N])
	G = collect(MRGA[2 * small_N + 1 : 3 * small_N])
	A = collect(MRGA[3 * small_N + 1 : end])
	f(M, R, G, A)
end

# ╔═╡ b05800fb-2075-441b-b2c7-7182fd1adb3f
f_wrapped(1, 0, 2, 0, 3, 0, 4, 0)

# ╔═╡ 0eab42af-b05c-47ef-9ce4-d49dddf6e2bd
let
	# in jump it would look a bit like:
	M = [1, 0]
	R = [2, 0]
	G = [3, 0]
	A = [4, 0]
	f_wrapped(M..., R..., G..., A...)
end

# ╔═╡ Cell order:
# ╟─a26a5645-bbe7-4efd-85d6-0d3fb3b487a7
# ╠═3c6b68f0-4081-11eb-2393-2b8fb00657e2
# ╠═ad6eca7c-3d88-4403-92f3-e7dad7d96887
# ╠═406d4ab9-7127-4bda-a2b0-9354c2ce9f39
# ╠═b44a65a4-cab8-4038-b830-1eeabed4f9e9
# ╟─52597d62-c730-42da-b983-61f2b9816f01
# ╠═1cf5a0c0-0b97-4802-87f9-8410d47f4873
# ╠═fca12051-3d72-45b1-b791-7ddec21704cd
# ╠═24ffa39d-5206-4ea7-a680-6da8dc0daa1d
# ╟─575d53ed-ede5-4d09-a9bd-38f2a3962c55
# ╠═79a0b0b4-adbc-48a2-874a-bfb88c1a2a36
# ╟─cdac10a8-99a2-47f0-8e5b-6275b0801baf
# ╠═8cf95f10-6445-41e3-b67e-0a6868af0944
# ╠═fde600f7-b359-44cb-878b-bfcc9d89388b
# ╠═cdac2914-a1f7-4c29-97c4-931146703a94
# ╠═8c8c1573-0dac-44d2-9486-ccc134a3142d
# ╠═51d79aed-0316-4e13-b25a-aadc5b1e266f
# ╟─0f550146-9c67-474e-bcf5-a8f66f6d5928
# ╠═2aa91e85-5a35-40ac-8657-590c8e8e8007
# ╠═76abb0dd-3ba0-48f5-a909-c5bb97f10854
# ╠═6659e62c-b019-4f42-bde6-c5957a6e9c90
# ╟─d4c7acf5-dbd7-448c-9ecf-1dcef1c00033
# ╠═e10c98a3-1bfc-4d0a-a550-46c0a014532d
# ╠═98fe65f7-7a60-43af-8509-690aaa7828c6
# ╠═11612fc8-382a-4fdb-ae87-51d7819c284d
# ╠═3c6b1f01-bc0e-492e-b6d0-aca9a26c9f86
# ╠═28e345c0-9b4c-47b5-9d87-4c0d7ef96de3
# ╟─354c0322-7aa8-4541-bd88-4193aaa7c2d4
# ╠═e62e59d7-05f5-41dc-9162-f8a9f0825169
# ╠═2cbcf37f-657e-4b0e-933f-ff2818b54a57
# ╠═8e9344df-0633-4608-8fc1-0ab601d69bd6
# ╠═fd32e430-3b4f-4de6-aa46-2ce265de5add
# ╟─f7c5bb61-9bee-41e5-b337-b68850c3f956
# ╠═8f260d68-b919-44a4-acae-423a357cef3c
# ╠═0794d76e-9413-4c28-b4a9-104dc12d0b6d
# ╠═333a1520-9edf-4789-ac1f-75c5e7e2a694
# ╠═7a5f2082-c634-4b67-9ab5-c65fca14c169
# ╟─c3dcfc24-2bab-4327-a639-30f3020a8f2f
# ╟─06170709-ac84-46ec-ada4-149732b08256
# ╠═6cce8e6f-fffd-4a81-b1f9-0dfc34ff746e
# ╠═4fb435ce-5929-4595-9a89-8ffbfdc14c0f
# ╠═57b82807-2954-43ad-9c54-7745944986da
# ╠═b05800fb-2075-441b-b2c7-7182fd1adb3f
# ╠═0eab42af-b05c-47ef-9ce4-d49dddf6e2bd
