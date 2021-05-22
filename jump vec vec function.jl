### A Pluto.jl notebook ###
# v0.14.5

using Markdown
using InteractiveUtils

# ╔═╡ e69db074-bb0d-11eb-3d84-1dabc280f0fb
using JuMP, Ipopt

# ╔═╡ db655d0f-a3d7-4e50-acfb-0d7860a5cd98
setup_opt_model() = Model(optimizer_with_attributes(Ipopt.Optimizer,
	"acceptable_tol" => 1.e-8, "max_iter" => Int64(1e8),
	"acceptable_constr_viol_tol" => 1.e-3, "constr_viol_tol" => 1.e-4,
	"print_frequency_iter" => 50,  "print_timing_statistics" => "no",
	"print_level" => 0,
))

# ╔═╡ 18cea20f-9923-484e-97e3-c603e084cee0
function halfsum(xs::Vector{<:Real})
	sum((xs .- 0.5).^2) + .001 * (sum(xs) - 50)^2
end

# ╔═╡ ca6432a8-e5be-4f99-85fe-3d6dba517674
function halfsum_jump(xs...)
	halfsum(collect(xs))
end

# ╔═╡ 796f0ad9-09fb-4608-a1de-7a7f1ee19e4e
N = 200

# ╔═╡ b80fae33-911a-4855-8b3f-b1f7d4f05651
function cumsum_jump(xsi...)
	
	xs = collect(xsi[1:N])
	
	cumsum(collect(xs))
end

# ╔═╡ a2f49aec-df33-4746-a118-6742cb01f0c4
begin
	model_optimizer = setup_opt_model()
	
	local m = model_optimizer
	
	M = @variable(model_optimizer, 0.0 <= M[1:N] <= 1.0)
	
	

	
	# Register our wrapper functions
	###
	
	register(m, 
		:halfsum_jump, 
		N, 
		halfsum_jump, 
		autodiff=true
	)
	
	
	# Objective
	###
	
	min_objective = @NLobjective(
		m, Min, 
		halfsum_jump(M...)
	)
	
	for i in 1:N
		@NLconstraint(m,
			M[i] >= i / N
		)
	end
	
	min_objective
end;

# ╔═╡ 38835535-cb53-4c49-b4a4-a38e87851a45
model_optimized = let
	optimize!(model_optimizer)
	model_optimizer
end

# ╔═╡ 0ae46e78-c3af-4eb9-a0f5-aabafe348d89
termination_status(model_optimized)

# ╔═╡ 6d688f9c-0bbf-4c52-8656-1d44ad6fcb32
value.(M)

# ╔═╡ 0565c023-62fc-4bdf-a8a3-7688c8ce5c3f
begin
	model_optimizer2 = setup_opt_model()
	
	local m = model_optimizer2
	
	M2 = @variable(m, 0.0 <= M2[1:N] <= 1.0)
	
	
	
	# Objective
	###
	
	
	for i in 1:N
		@NLconstraint(m,
			M2[i] >= i / N
		)
	end
	
	min_objective2 = @NLobjective(
		m, Min, 
		# sum(
		# 	(M2[i] - 0.5) ^ 2
		# 	for i in 1:N
		# )
		sum(
			(M2[i] - 0.5)^2
			for i in 1:N) + .001 * (sum(M2[i] for i in 1:N) - 50)^2
	)
	
	min_objective2
end;

# ╔═╡ 2fee1e9c-96d2-4403-ba6e-1f3f3bdb09c1
model_optimized2 = let
	optimize!(model_optimizer2)
	model_optimizer2
end

# ╔═╡ eecca8bb-3740-437d-85ec-c1a18f6016f3
value.(M2)

# ╔═╡ Cell order:
# ╠═e69db074-bb0d-11eb-3d84-1dabc280f0fb
# ╠═db655d0f-a3d7-4e50-acfb-0d7860a5cd98
# ╠═18cea20f-9923-484e-97e3-c603e084cee0
# ╠═ca6432a8-e5be-4f99-85fe-3d6dba517674
# ╠═b80fae33-911a-4855-8b3f-b1f7d4f05651
# ╠═796f0ad9-09fb-4608-a1de-7a7f1ee19e4e
# ╠═a2f49aec-df33-4746-a118-6742cb01f0c4
# ╠═38835535-cb53-4c49-b4a4-a38e87851a45
# ╠═0ae46e78-c3af-4eb9-a0f5-aabafe348d89
# ╠═6d688f9c-0bbf-4c52-8656-1d44ad6fcb32
# ╠═0565c023-62fc-4bdf-a8a3-7688c8ce5c3f
# ╠═2fee1e9c-96d2-4403-ba6e-1f3f3bdb09c1
# ╠═eecca8bb-3740-437d-85ec-c1a18f6016f3
