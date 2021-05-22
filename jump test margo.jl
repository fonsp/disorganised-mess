### A Pluto.jl notebook ###
# v0.14.5

using Markdown
using InteractiveUtils

# ╔═╡ 3c6b68f0-4081-11eb-2393-2b8fb00657e2
begin
	using Revise
	import ClimateMARGO
	using ClimateMARGO.Models
	using ClimateMARGO.Optimization
	using ClimateMARGO.Diagnostics
	using ClimateMARGO.Utils
end

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

# ╔═╡ 52597d62-c730-42da-b983-61f2b9816f01
model_parameters = deepcopy(ClimateMARGO.IO.included_configurations["default"])::ClimateModelParameters

# ╔═╡ 1cf5a0c0-0b97-4802-87f9-8410d47f4873
time = let
	d = model_parameters.domain
	d.initial_year:d.dt:d.final_year
end

# ╔═╡ 717b904e-1547-4718-af20-67ee34f2ed71
# N = length(time)

# ╔═╡ fca12051-3d72-45b1-b791-7ddec21704cd


# ╔═╡ 24ffa39d-5206-4ea7-a680-6da8dc0daa1d
max_slope_M = .02

# ╔═╡ bcea1e6e-0aac-44ac-ac97-1b4d5e926238
max_slope_R = .02

# ╔═╡ 575d53ed-ede5-4d09-a9bd-38f2a3962c55
md"""
## Simple forward model function

To keep things simple, we wrap MARGO's forward model in a number of functions with:
- input: `Vector{Real}`
- output: `Real` or `Vector{Real}`
"""

# ╔═╡ e0bbd81a-8680-41f1-a501-2045b1b17308
dummy_model = ClimateModel(model_parameters)

# ╔═╡ 0dd6a0ee-1a35-4870-82ea-60db6fc9c2f2
function log_JuMP(x)
        if x <= 0.
            return -1000.0
        else
            return log(x)
        end
    end

# ╔═╡ 9dfa933a-b3d4-42d2-a6f8-03ec306388f0
begin
	local m = dummy_model
	# Shorthands
    const tarr = t(m)
    const Earr = E(m)
    const τ = τd(m)
    const dt = m.domain.dt
    const t0 = tarr[1]
    const tp = m.domain.present_year
    const q = m.economics.baseline_emissions
    const qGtCO2 = ppm_to_GtCO2(q)
    const Tb = T(m)
    const N = length(tarr)
end

# ╔═╡ 1c587211-74b5-42e9-967f-3f567b3e61e4
function T_adapt_fast(m)
	
	M = m.controls.mitigate
	R = m.controls.remove
	G = m.controls.geoeng
	A = m.controls.adapt
	
	
	
	
	cumsum_qMR = Vector{Any}(undef, N)
	cumsum_qMR[1] = (dt * (m.physics.r * (q[1] * (1. - M[1]) - q[1] * R[1])))
    for i in 1:N-1
		cumsum_qMR[i+1] = cumsum_qMR[i] +
		(dt * (m.physics.r * (q[i+1] * (1. - M[i+1]) - q[1] * R[i+1])))
    end
	
	cumsum_KFdt = Vector{Any}(undef, N)
    for i in 0:N-1
            cumsum_KFdt[i+1] = (i == 0 ? 0.0 : cumsum_KFdt[i]) +
            (
                dt *
                exp( (tarr[i+1] - (t0 - dt)) / τ ) * (
                    m.physics.a * log_JuMP(
                        (m.physics.c0 + cumsum_qMR[i+1]) /
                        (m.physics.c0)
                    ) - m.economics.Finf*G[i+1] )
            )
    end	
	
	
	cumsum_KFdt
	
	map(eachindex(tarr)) do i
		(m.physics.T0 +
                (
                     (m.physics.a * log_JuMP(
                                (m.physics.c0 + cumsum_qMR[i]) /
                                (m.physics.c0)
                            ) - m.economics.Finf*G[i] 
                    ) +
                    m.physics.κ /
                    (τ * m.physics.B) *
                    exp( - (tarr[i] - (t0 - dt)) / τ ) *
                    cumsum_KFdt[i]
                ) / (m.physics.B + m.physics.κ)
            ) - A[i]*Tb[i]
	end
	
end

# ╔═╡ 79a0b0b4-adbc-48a2-874a-bfb88c1a2a36
function temperature_controlled(M::Vector{<:Real}, R::Vector{<:Real})::Vector{<:Real}
	
	
	dummy_model.controls.mitigate = M
	dummy_model.controls.remove = R
	# T_adapt(dummy_model; M=true, R=true, G=true, A=true)
	T_adapt_fast(dummy_model)
end

# ╔═╡ 000ff54d-32ab-40c3-8163-8fbab273a1fe
T_adapt_fast(dummy_model)

# ╔═╡ 0745576f-a3d3-4e3a-9016-9640699c7f5c
dummy_model.physics.T0

# ╔═╡ cdac10a8-99a2-47f0-8e5b-6275b0801baf
sample_M = fill(0.5, length(time))

# ╔═╡ f1894a62-f2ef-482c-9d78-57dbf942be8c
sample_R = 0.5 .* sample_M

# ╔═╡ 8cf95f10-6445-41e3-b67e-0a6868af0944
temperature_controlled(sample_M, sample_R)

# ╔═╡ fde600f7-b359-44cb-878b-bfcc9d89388b
function final_temperature_controlled(M::Vector{<:Real}, R::Vector{<:Real})::Real
	temperature_controlled(M, R)[end]
end

# ╔═╡ 1697d698-bdce-4ffc-a58d-9467dd3da52d
function square_right_error(x, y)
	err = x - y
	if err > 0
		err ^ 2
	else
		zero(err)
	end
end

# ╔═╡ 5e2e7896-e0dd-4fce-87e2-189c505d51ab
plot(x -> square_right_error(x, 1))

# ╔═╡ cdac2914-a1f7-4c29-97c4-931146703a94
final_temperature_controlled(sample_M, sample_R)

# ╔═╡ 8c8c1573-0dac-44d2-9486-ccc134a3142d
function control_costs(M::Array{<:Real,1}, R::Vector{<:Real})::Real
	model = ClimateModel(model_parameters)
	
	model.controls.mitigate = M
	model.controls.remove = R
	costs = cost(model; M=true, R=true, discounting=true)
	
	sum(costs .* model.domain.dt)
end

# ╔═╡ 51d79aed-0316-4e13-b25a-aadc5b1e266f
control_costs(sample_M, sample_R)

# ╔═╡ 0f550146-9c67-474e-bcf5-a8f66f6d5928
md"""
## Let's optimize!
"""

# ╔═╡ 76abb0dd-3ba0-48f5-a909-c5bb97f10854
import ClimateMARGO.Optimization.Ipopt

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

# ╔═╡ 65d2ef7a-380c-4b8f-b209-ac9d37d7be6d
begin
	val(i::Int) = i
	val(i::Float64) = Int(i)
	val(i::JuMP.ForwardDiff.Dual) = Int(i.value)
end

# ╔═╡ e10c98a3-1bfc-4d0a-a550-46c0a014532d
# temperatures_controlled_jump(M...) = temperatures_controlled(collect(M))

# ╔═╡ 97aeb55a-385c-4ed8-8f68-c1f06106d1ac


# ╔═╡ 98fe65f7-7a60-43af-8509-690aaa7828c6
# final_temperature_controlled_jump(M...) = final_temperature_controlled(collect(M))

# ╔═╡ 347ed8b7-4f2f-491d-9a07-179d3615a314
temperature_controlled_memory = Dict()

# ╔═╡ a19ad6cf-5c5b-461c-b662-2da620033207
begin
	const temperature_controlled_memory_key = Ref(objectid(123))
	const temperature_controlled_memory_value = Ref{Any}(nothing)
end

# ╔═╡ da4a5313-ff17-44f4-8917-98b4bab345ad


# ╔═╡ 7ec78d92-4e6e-4dc6-9e1a-fd417b8243f3
z = []

# ╔═╡ 6fc4a76c-e967-4e39-a4b2-12c8520878f5
function temperature_controlled_jump(MRi...)
	
	i = val(MRi[end])
	
	id = objectid(MRi[1:2*N])
	
	a = get!(temperature_controlled_memory, id) do
		M = collect(MRi[        1 : 1 * N])
		R = collect(MRi[    N + 1 : 2 * N])
		temperature_controlled(M, R)
	end
	
	# a = if temperature_controlled_memory_key[] === id
	# 	temperature_controlled_memory_value[]
	# else
	# 	temperature_controlled_memory_value[] = temperature_controlled(M, R)
	# end
	
	# a = temperature_controlled(M, R)
	# b = temperature_controlled(M, R)
	
# 	push!(z, eltype(M))
	
# 	if a != b
# 		@warn "Not equal!" a b
# 	end
	
	a[i]
end

# ╔═╡ ea6af56d-bf06-42ed-a52e-c1885a2db2cd
# function temperature_controlled_jump2(MR...)
	
# 	M = collect(MR[        1 : 1 * N])
# 	R = collect(MR[    N + 1 : 2 * N])
	
# 	get!(temperature_controlled_memory, (M,R)) do
# 		temperature_controlled(M, R)
# 	end
# end

# ╔═╡ 5a7345e2-6da1-4123-9df7-5a77972a806c
function final_temperature_controlled_jump(MR...)
	
	M = collect(MR[        1 : 1 * N])
	R = collect(MR[    N + 1 : 2 * N])
	
	final_temperature_controlled(M, R)
end

# ╔═╡ 11612fc8-382a-4fdb-ae87-51d7819c284d
function control_costs_jump(MR...)
	
	M = collect(MR[        1 : 1 * N])
	R = collect(MR[    N + 1 : 2 * N])
	
	control_costs(M, R)
end

# ╔═╡ 354c0322-7aa8-4541-bd88-4193aaa7c2d4
md"""
### Run the optimization
"""

# ╔═╡ 3c6b1f01-bc0e-492e-b6d0-aca9a26c9f86
T_max = 3

# ╔═╡ 4a9ee95b-ef60-4e9b-b40c-df37c0093e6d
function total_overshoot_temperature_controlled(M::Vector{<:Real}, R::Vector{<:Real})::Real
	T = temperature_controlled(M, R)
	
	sum(square_right_error.(T, (T_max,)))
end

# ╔═╡ 29aa2a7b-6f0b-425b-88f7-40a2578f7f1b
function total_overshoot_temperature_controlled_jump(MR...)
	
	M = collect(MR[        1 : 1 * N])
	R = collect(MR[    N + 1 : 2 * N])
	
	total_overshoot_temperature_controlled(M, R)
end

# ╔═╡ 28e345c0-9b4c-47b5-9d87-4c0d7ef96de3
begin
	empty!(temperature_controlled_memory)
	
	model_optimizer = setup_opt_model()
	
	local mo = model_optimizer
	local m = dummy_model
	local N = length(time)
	
	local odx = N
	local temp_overshoot = T_max
	local temp_goal = T_max
	
	
	M = @variable(model_optimizer, 0.0 <= M[1:N] <= 1.0)
	R = @variable(model_optimizer, 0.0 <= R[1:N] <= 1.0)
	G = @variable(model_optimizer, 0.0 <= G[1:N] <= 1.0)
	A = @variable(model_optimizer, 0.0 <= A[1:N] <= 1.0)

	
	for i in 1:N
		@constraint(mo, 0 == G[i])
		@constraint(mo, 0 == A[i])
	end
	
	
	# Register our wrapper functions
	###
	
	register(mo, 
		:final_temperature_controlled_jump, 
		N * 2, 
		final_temperature_controlled_jump, 
		autodiff=true
	)
	# register(m, 
	# 	:total_overshoot_temperature_controlled_jump, 
	# 	N * 2, 
	# 	total_overshoot_temperature_controlled_jump, 
	# 	autodiff=true
	# )
	register(mo, 
		:control_costs_jump, 
		N * 2, 
		control_costs_jump, 
		autodiff=true
	)
	register(mo, 
		:temperature_controlled_jump, 
		N * 2 + 1, 
		temperature_controlled_jump, 
		autodiff=true
	)
	# register(m, 
	# 	:temperature_controlled_jump2, 
	# 	N * 2, 
	# 	temperature_controlled_jump2, 
	# 	autodiff=true
	# )
	
    register(model_optimizer, :log_JuMP, 1, log_JuMP, autodiff=true)
	
	# Temperature constraint
	###
	
		# temp_constraints = @NLconstraint(m, 
		# final_temperature_controlled_jump(M..., R...) <= T_max)
	
	for i in 1:N
		# temp_constraints = @NLconstraint(m, 
		# 	temperature_controlled_jump(M..., R..., i) <= T_max)
		# temp_constraints = @NLconstraint(m, 
		# 	temperature_controlled_jump2(M..., R...)[i] <= T_max)
	end
	
	
		# temp_constraints = @NLconstraint(m, 
		# total_overshoot_temperature_controlled_jump(M..., R...) <= 0.0)
	
	
	
	
	# add integral function as a new variable defined by first order finite differences
    cumsum_qMR = @variable(model_optimizer, cumsum_qMR[1:N]);
    for i in 1:N-1
        @constraint(
            model_optimizer, cumsum_qMR[i+1] - cumsum_qMR[i] ==
            (dt * (m.physics.r * (q[i+1] * (1. - M[i+1]) - q[1] * R[i+1])))
        )
    end
    @constraint(
        model_optimizer, cumsum_qMR[1] == (dt * (m.physics.r * (q[1] * (1. - M[1]) - q[1] * R[1])))
    );
    
    # add temperature kernel as new variable defined by first order finite difference
    cumsum_KFdt = @variable(model_optimizer, cumsum_KFdt[1:N]);
    for i in 1:N-1
        @NLconstraint(
            model_optimizer, cumsum_KFdt[i+1] - cumsum_KFdt[i] ==
            (
                dt *
                exp( (tarr[i+1] - (t0 - dt)) / τ ) * (
                    m.physics.a * log_JuMP(
                        (m.physics.c0 + cumsum_qMR[i+1]) /
                        (m.physics.c0)
                    ) - m.economics.Finf*G[i+1] )
            )
        )
    end
    @NLconstraint(
        model_optimizer, cumsum_KFdt[1] == 
        (
            dt *
            exp( dt / τ ) * (
                m.physics.a * log_JuMP(
                    (m.physics.c0 + cumsum_qMR[1]) /
                    (m.physics.c0)
                ) - m.economics.Finf*G[1] )
         )
    );
	
	
	# Subject to temperature goal (during overshoot period)
        for i in 1:odx-1
            # @NLconstraint(model_optimizer,
            #     T_adapt_JuMP(M..., R..., G..., A..., i) <= temp_overshoot
            # )
            @NLconstraint(model_optimizer,
            ((m.physics.T0 +
                (
                     (m.physics.a * log_JuMP(
                                (m.physics.c0 + cumsum_qMR[i]) /
                                (m.physics.c0)
                            ) - m.economics.Finf*G[i] 
                    ) +
                    m.physics.κ /
                    (τ * m.physics.B) *
                    exp( - (tarr[i] - (t0 - dt)) / τ ) *
                    cumsum_KFdt[i]
                ) / (m.physics.B + m.physics.κ)
            )
            - A[i]*Tb[i]) <=
                temp_overshoot
            )
        end
        # Subject to temperature goal (after temporary overshoot period)
        for i in odx:N
            @NLconstraint(model_optimizer,
            ((m.physics.T0 + 
                (
                     (m.physics.a * log_JuMP(
                                (m.physics.c0 + cumsum_qMR[i]) /
                                (m.physics.c0)
                            ) - m.economics.Finf*G[i] 
                    ) +
                    m.physics.κ /
                    (τ * m.physics.B) *
                    exp( - (tarr[i] - (t0 - dt)) / τ ) *
                    cumsum_KFdt[i]
                ) / (m.physics.B + m.physics.κ)
            )
            - A[i]*Tb[i]) <=
                    temp_goal
            )
        end
	
	
	
	# Slope constraint
	###
	
	max_difference_M = max_slope_M * step(time)
	max_difference_R = max_slope_R * step(time)
	
	dM = @variable(mo, 
		-max_difference_M <= dM[1:N-1] <= max_difference_M
	)
	dR = @variable(mo, 
		-max_difference_R <= dR[1:N-1] <= max_difference_R
	)
	diff_con_M = @constraint(mo, diff_con_M[i = 1:N-1],
		dM[i] == (M[i+1] - M[i])
	)
	diff_con_R = @constraint(mo, diff_con_R[i = 1:N-1],
		dR[i] == (R[i+1] - R[i])
	)
	
	# Initial value constraint
	###
	
	init_con_M = @constraint(mo, init_con_M,
		M[1] == 0.0
	)
	init_con_R = @constraint(mo, init_con_R,
		R[1] == 0.0
	)
	
	
	# Objective
	###
	
	min_objective = @NLobjective(
		mo, Min, 
		control_costs_jump(M..., R...)
	)
	
	model_optimizer
end;

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

# ╔═╡ a6fad854-a165-4693-9034-4d8f1b1d9841
R_optimized = let
	model_optimized
	value.(R)
end

# ╔═╡ f7c5bb61-9bee-41e5-b337-b68850c3f956
md"""
## Result
"""

# ╔═╡ 333a1520-9edf-4789-ac1f-75c5e7e2a694
plot(time, M_optimized, 
	title="Optimized Mitigation",
	dpi=300, size=(400,200))

# ╔═╡ 9526372e-2180-42a9-8221-7caa1bb5521e
plot(time, R_optimized, 
	title="Optimized Removal",
	dpi=300, size=(400,200))

# ╔═╡ 7a5f2082-c634-4b67-9ab5-c65fca14c169
plot(time, temperature_controlled(M_optimized, R_optimized), 
	title="Temperature increase",
	dpi=300, size=(400,200))

# ╔═╡ 17b9f7be-87f2-418f-8a53-d6b3cc735768
let
	optimize_controls!(dummy_model; temp_goal=3)
end

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
	A = collect(MRGA[3 * small_N + 1 : 4 * small_N])
	
	# remaining arguments
	e = collect(MRGA[4 * small_N + 1 : end])
	
	f(M, R, G, A, e...)
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

# ╔═╡ 9f229c35-fa35-49a4-8ed4-a8dc9264920e
g(M,R,G,A,i) = f(M,R,G,A)[i]

# ╔═╡ 9c920e1a-9e47-4fb1-9ed2-581aad8779a3
function g_wrapped(MRGA...)
	M = collect(MRGA[              1 : 1 * small_N])
	R = collect(MRGA[    small_N + 1 : 2 * small_N])
	G = collect(MRGA[2 * small_N + 1 : 3 * small_N])
	A = collect(MRGA[3 * small_N + 1 : 4 * small_N])
	
	# remaining arguments
	e = collect(MRGA[4 * small_N + 1 : end])
	
	g(M, R, G, A, e...)
end

# ╔═╡ c6a3509c-5655-406b-a0d7-162b19cbfda0
let
	# in jump it would look a bit like:
	M = [1, 0]
	R = [2, 0]
	G = [3, 0]
	A = [4, 0]
	g_wrapped(M..., R..., G..., A..., 1)
end

# ╔═╡ Cell order:
# ╟─a26a5645-bbe7-4efd-85d6-0d3fb3b487a7
# ╠═3c6b68f0-4081-11eb-2393-2b8fb00657e2
# ╟─52597d62-c730-42da-b983-61f2b9816f01
# ╠═1cf5a0c0-0b97-4802-87f9-8410d47f4873
# ╠═717b904e-1547-4718-af20-67ee34f2ed71
# ╠═fca12051-3d72-45b1-b791-7ddec21704cd
# ╠═24ffa39d-5206-4ea7-a680-6da8dc0daa1d
# ╠═bcea1e6e-0aac-44ac-ac97-1b4d5e926238
# ╟─575d53ed-ede5-4d09-a9bd-38f2a3962c55
# ╠═e0bbd81a-8680-41f1-a501-2045b1b17308
# ╠═79a0b0b4-adbc-48a2-874a-bfb88c1a2a36
# ╠═0dd6a0ee-1a35-4870-82ea-60db6fc9c2f2
# ╠═000ff54d-32ab-40c3-8163-8fbab273a1fe
# ╠═9dfa933a-b3d4-42d2-a6f8-03ec306388f0
# ╠═1c587211-74b5-42e9-967f-3f567b3e61e4
# ╠═0745576f-a3d3-4e3a-9016-9640699c7f5c
# ╟─cdac10a8-99a2-47f0-8e5b-6275b0801baf
# ╠═f1894a62-f2ef-482c-9d78-57dbf942be8c
# ╠═8cf95f10-6445-41e3-b67e-0a6868af0944
# ╠═fde600f7-b359-44cb-878b-bfcc9d89388b
# ╠═4a9ee95b-ef60-4e9b-b40c-df37c0093e6d
# ╠═1697d698-bdce-4ffc-a58d-9467dd3da52d
# ╠═5e2e7896-e0dd-4fce-87e2-189c505d51ab
# ╠═cdac2914-a1f7-4c29-97c4-931146703a94
# ╠═8c8c1573-0dac-44d2-9486-ccc134a3142d
# ╠═51d79aed-0316-4e13-b25a-aadc5b1e266f
# ╟─0f550146-9c67-474e-bcf5-a8f66f6d5928
# ╠═2aa91e85-5a35-40ac-8657-590c8e8e8007
# ╠═76abb0dd-3ba0-48f5-a909-c5bb97f10854
# ╠═6659e62c-b019-4f42-bde6-c5957a6e9c90
# ╟─d4c7acf5-dbd7-448c-9ecf-1dcef1c00033
# ╠═65d2ef7a-380c-4b8f-b209-ac9d37d7be6d
# ╠═e10c98a3-1bfc-4d0a-a550-46c0a014532d
# ╠═97aeb55a-385c-4ed8-8f68-c1f06106d1ac
# ╠═98fe65f7-7a60-43af-8509-690aaa7828c6
# ╠═347ed8b7-4f2f-491d-9a07-179d3615a314
# ╠═a19ad6cf-5c5b-461c-b662-2da620033207
# ╠═da4a5313-ff17-44f4-8917-98b4bab345ad
# ╠═7ec78d92-4e6e-4dc6-9e1a-fd417b8243f3
# ╠═6fc4a76c-e967-4e39-a4b2-12c8520878f5
# ╠═ea6af56d-bf06-42ed-a52e-c1885a2db2cd
# ╠═5a7345e2-6da1-4123-9df7-5a77972a806c
# ╠═29aa2a7b-6f0b-425b-88f7-40a2578f7f1b
# ╠═11612fc8-382a-4fdb-ae87-51d7819c284d
# ╠═28e345c0-9b4c-47b5-9d87-4c0d7ef96de3
# ╟─354c0322-7aa8-4541-bd88-4193aaa7c2d4
# ╠═e62e59d7-05f5-41dc-9162-f8a9f0825169
# ╠═2cbcf37f-657e-4b0e-933f-ff2818b54a57
# ╠═8e9344df-0633-4608-8fc1-0ab601d69bd6
# ╠═fd32e430-3b4f-4de6-aa46-2ce265de5add
# ╠═a6fad854-a165-4693-9034-4d8f1b1d9841
# ╠═3c6b1f01-bc0e-492e-b6d0-aca9a26c9f86
# ╟─f7c5bb61-9bee-41e5-b337-b68850c3f956
# ╠═8f260d68-b919-44a4-acae-423a357cef3c
# ╠═0794d76e-9413-4c28-b4a9-104dc12d0b6d
# ╠═333a1520-9edf-4789-ac1f-75c5e7e2a694
# ╠═9526372e-2180-42a9-8221-7caa1bb5521e
# ╠═7a5f2082-c634-4b67-9ab5-c65fca14c169
# ╠═17b9f7be-87f2-418f-8a53-d6b3cc735768
# ╟─c3dcfc24-2bab-4327-a639-30f3020a8f2f
# ╟─06170709-ac84-46ec-ada4-149732b08256
# ╠═6cce8e6f-fffd-4a81-b1f9-0dfc34ff746e
# ╠═4fb435ce-5929-4595-9a89-8ffbfdc14c0f
# ╠═57b82807-2954-43ad-9c54-7745944986da
# ╠═b05800fb-2075-441b-b2c7-7182fd1adb3f
# ╠═0eab42af-b05c-47ef-9ce4-d49dddf6e2bd
# ╠═9f229c35-fa35-49a4-8ed4-a8dc9264920e
# ╠═9c920e1a-9e47-4fb1-9ed2-581aad8779a3
# ╠═c6a3509c-5655-406b-a0d7-162b19cbfda0
