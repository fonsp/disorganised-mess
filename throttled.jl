### A Pluto.jl notebook ###
# v0.14.0

using Markdown
using InteractiveUtils

# ╔═╡ bf71daae-3d34-11eb-1ca1-d9b018e99f18
"Create a throttled function, which calls the given function `f` at most once per given interval `max_delay`.

It is _leading_ (`f` is invoked immediately) and _not trailing_ (calls during a cooldown period are ignored)."
function throttled(f::Function, max_delay::Real, initial_offset::Real=0)
	local last_run_at = time() - max_delay + initial_offset
	# return f
	() -> begin
		now = time()
		if now - last_run_at >= max_delay
			f()
			last_run_at = now
		end
		nothing
	end
end

# ╔═╡ dde97532-3d34-11eb-030d-054b47086952
function log()
	@info "Hello" rand()
end

# ╔═╡ fac02af2-3d34-11eb-17b8-61505c641f17
log()

# ╔═╡ 55752812-3d35-11eb-3962-91f60f0b8219
t = throttled(log, 2, 5)

# ╔═╡ 5d2b13be-3d35-11eb-2e47-51223a2a47bf
t()

# ╔═╡ 0aec4a64-3d35-11eb-3d3b-a306558f610c
let
	a = time()
	b = sqrt.([200])
	time() - a
end

# ╔═╡ 880ba494-3b1f-4d1d-95b4-469a7178726c
md"""
# With cooldown delay
"""

# ╔═╡ 8a1a1300-5f32-445b-8ead-53e700fa186c
"Create a throttled function, which calls the given function `f` at most once per given interval `max_delay`.

It is _leading_ (`f` is invoked immediately) and _not trailing_ (calls during a cooldown period are ignored).

An optional third argument sets an initial cooldown period, default is `0`. With a non-zero value, the throttle is no longer _leading_."
function throttled2(f::Function, max_delay::Real, initial_offset::Real=0)
	local last_run_at = time() - max_delay + initial_offset
	# return f
	() -> begin
		now = time()
		if now - last_run_at >= max_delay
			f()
			last_run_at = now
		end
		nothing
	end
end

# ╔═╡ 8872d171-f63f-4f8f-a17a-19d05e6382c4


# ╔═╡ 8f92a451-694f-41e3-8483-61b7fd26e3eb


# ╔═╡ Cell order:
# ╠═bf71daae-3d34-11eb-1ca1-d9b018e99f18
# ╠═dde97532-3d34-11eb-030d-054b47086952
# ╠═fac02af2-3d34-11eb-17b8-61505c641f17
# ╠═55752812-3d35-11eb-3962-91f60f0b8219
# ╠═5d2b13be-3d35-11eb-2e47-51223a2a47bf
# ╠═0aec4a64-3d35-11eb-3d3b-a306558f610c
# ╟─880ba494-3b1f-4d1d-95b4-469a7178726c
# ╠═8a1a1300-5f32-445b-8ead-53e700fa186c
# ╠═8872d171-f63f-4f8f-a17a-19d05e6382c4
# ╠═8f92a451-694f-41e3-8483-61b7fd26e3eb
