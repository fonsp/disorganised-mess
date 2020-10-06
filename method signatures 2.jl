### A Pluto.jl notebook ###
# v0.12.0

using Markdown
using InteractiveUtils

# ╔═╡ 97b2a67c-0816-11eb-35c8-3f73ed213afe
using PlutoUI

# ╔═╡ a73b0484-0818-11eb-2750-f157708c703a
r(

# ╔═╡ 6bab1816-0816-11eb-112e-15d837ae74cf
f = (quote
	function f(x, y::Any, z::e(Union{a,b})=1, b=b; b::E=3)
		123
			123
			123
			123
			123
	end
end).args[2].args[1]

# ╔═╡ 35f013ec-0817-11eb-22be-7711e29adc77
g = (quote
	function g(a,z::f...) where T <: 123
		123
			123
			123
			123
			123
	end
end).args[2].args[1]

# ╔═╡ 9db60eea-0816-11eb-1237-192f4c1e7749
Dump(f, maxdepth=123)

# ╔═╡ 39ee0048-0818-11eb-107f-6bb02110560b
begin
	function hide_argument_name(ex::Expr)
		if ex.head == :(::) && length(ex.args) > 1
			Expr(:(::), nothing, ex.args[2:end]...)
		elseif ex.head == :(...)
			Expr(:(...), hide_argument_name(ex.args[1]))
		elseif ex.head == :kw
			Expr(:kw, hide_argument_name(ex.args[1]), nothing)
		else
			ex
		end
	end
	hide_argument_name(::Symbol) = nothing
	hide_argument_name(x::Any) = x
end

# ╔═╡ e5368972-0816-11eb-151c-9d654a613afb
function canonalize(ex::Expr)
	if ex.head == :where
		Expr(:where, canonalize(ex.args[1]), ex.args[2:end]...)
	elseif ex.head == :call
		ex.args[1] # is the function name, we dont want it

		interesting = filter(ex.args[2:end]) do arg
			!(arg isa Expr && arg.head == :parameters)
		end
		
		hide_argument_name.(interesting)
	else
		@error "Huh" ex
		nothing
	end
end

# ╔═╡ 2e81c690-0818-11eb-1cf7-af954e560488
Dump(canonalize(f), maxdepth=234)

# ╔═╡ Cell order:
# ╠═a73b0484-0818-11eb-2750-f157708c703a
# ╠═6bab1816-0816-11eb-112e-15d837ae74cf
# ╠═35f013ec-0817-11eb-22be-7711e29adc77
# ╠═97b2a67c-0816-11eb-35c8-3f73ed213afe
# ╠═9db60eea-0816-11eb-1237-192f4c1e7749
# ╠═2e81c690-0818-11eb-1cf7-af954e560488
# ╠═e5368972-0816-11eb-151c-9d654a613afb
# ╠═39ee0048-0818-11eb-107f-6bb02110560b
