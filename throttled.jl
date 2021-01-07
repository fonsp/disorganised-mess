### A Pluto.jl notebook ###
# v0.12.17

using Markdown
using InteractiveUtils

# ╔═╡ a2100c7c-3d36-11eb-050c-8d8983dc6f41


# ╔═╡ b018c59e-3d35-11eb-3bb6-096de1f76c72
function()
end

# ╔═╡ bf71daae-3d34-11eb-1ca1-d9b018e99f18
function throttled(f::Function, max_delay::Real)
	local last_run_at = 0.0
	
	() -> begin
		now = time()
		if now - last_run_at >= max_delay
			f()
			last_run_at = now
		end
		nothing
	end
end

# ╔═╡ 07ec5290-3d36-11eb-05e4-d37463b62eda


# ╔═╡ 2abd4500-3d35-11eb-01a1-53b1eafa0aa4
time()

# ╔═╡ dde97532-3d34-11eb-030d-054b47086952
function log()
	@info "Hello" rand()
end

# ╔═╡ fac02af2-3d34-11eb-17b8-61505c641f17
log()

# ╔═╡ 55752812-3d35-11eb-3962-91f60f0b8219
t = throttled(log, 2)

# ╔═╡ 5d2b13be-3d35-11eb-2e47-51223a2a47bf
t()

# ╔═╡ 0aec4a64-3d35-11eb-3d3b-a306558f610c
let
	a = time()
	b = sqrt.([200])
	time() - a
end

# ╔═╡ Cell order:
# ╠═a2100c7c-3d36-11eb-050c-8d8983dc6f41
# ╠═b018c59e-3d35-11eb-3bb6-096de1f76c72
# ╠═bf71daae-3d34-11eb-1ca1-d9b018e99f18
# ╠═07ec5290-3d36-11eb-05e4-d37463b62eda
# ╠═2abd4500-3d35-11eb-01a1-53b1eafa0aa4
# ╠═dde97532-3d34-11eb-030d-054b47086952
# ╠═fac02af2-3d34-11eb-17b8-61505c641f17
# ╠═55752812-3d35-11eb-3962-91f60f0b8219
# ╠═5d2b13be-3d35-11eb-2e47-51223a2a47bf
# ╠═0aec4a64-3d35-11eb-3d3b-a306558f610c
