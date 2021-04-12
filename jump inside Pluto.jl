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

# ╔═╡ 2e3d4b69-786e-4ccb-91ec-3b98f1f568e0
begin
    import Pkg
    Pkg.activate(mktempdir())
    Pkg.add([
        Pkg.PackageSpec(name="JuMP", version="0.21"),
        Pkg.PackageSpec(name="GLPK", version="0.14"),
        Pkg.PackageSpec(name="PlutoUI", version="0.7"),
    ])
    using JuMP, GLPK, PlutoUI
end

# ╔═╡ d5b9c438-b1e7-4417-870f-afdfc4ee7672
md"""
# How to use JuMP in Pluto?

JuMP uses macros to form a domain-specific language. That is very cool! but unfortunately, Pluto has trouble understanding code with macros. This is a difficult problem that we currently working on, and it is getting closer to being fixed!

For any cell, it is important that Pluto correctly understands which variables are **referenced** and which are **defined**. Pluto's runtime uses this information to keep your global scope clean, and to reactively re-run cells.
"""

# ╔═╡ 759c0a90-bb03-456e-bbf6-8bf80b249c07
md"""
## Part 1: model mutations

Because JuMP's macros _modify_ a model, it is important the the **model construction is contained in a single cell**. Use a `let` block (more in Part 2).

⛔️ Don't:
```julia
model = Model(GLPK.Optimizer)
```
```julia
@variable(model, 20 < y < 30)
```

✔️ Do:
```julia
let
	global model = Model(GLPK.Optimizer)

	@variable(model, 20 < y < 30)

	...
end
```

#### optimize!

Similarly, `optimize!` will _modify_ the model, so I recommend calling it in the same cell as the model construction.

If, for the purpose of a narrative, you need the optimization to happen in a different cell, then use a "new state, new name" trick:

```julia
begin
	optimize!(model)
	model_optimized = model
end
```

In other cells, reference `model_optimized` to access `model` to guarantee that the model optimization has already happened:

```julia
# in other cells
value(model_optimized[:x])
```
	

"""

# ╔═╡ ce6d95f3-d745-4215-844c-727c9d90861d
md"""
## Part 2: secret definitions

JuMP's macros create global variables, which are not seen by Pluto. For example, `@variable(model, 0 < x < 1)` defines a global variable called `x`, while Pluto thinks that the global variable `x` was *referenced*, not assigned.

There are two ways to solve this.

### Part 2a: `let` block (recommended)
Place the macros inside a `let` block, to locally scope any secretly created variables.

⛔️ Don't:
```julia
begin
	model = Model(GLPK.Optimizer)

	@variable(model, 20 < y < 30)
	# global variable y is now defined, but Pluto does not know it

	...
end
```

✔️ Do:
```julia
let
	global model = Model(GLPK.Optimizer)

	@variable(model, 20 < y < 30)
	# locally scoped variable y is now defined. Pluto does not know about it, but since the global scope is unaffected, this is fine

	...
end
```
"""

# ╔═╡ 8bc3d43a-1460-498b-baa8-fcb9a3338457
md"""
To access variables from the model that are hidden by a let block, use the alternative syntax:


⛔️ Don't:
```julia
value(y)
```

✔️ Do:
```julia
value(model[:y])
```

"""

# ╔═╡ cdda279d-60bf-495c-b796-a62e5dd1d699
opacity(x, op) = HTML("""<div style="opacity: $(op);">$(repr(MIME"text/html"(), x))</div>""")

# ╔═╡ 9b4e18a3-669f-4bab-8c22-565428ebf299
opacity(op) = x -> opacity(x, op)

# ╔═╡ 267e9766-e2c1-4006-abb0-ae69fba94052
md"""
### Part 2b: make definitions explicit for Pluto

Alternatively, you can manually assign to the variable that is secretly defined to make Pluto understand.

⛔️ Don't:
```julia
begin
	model = Model(GLPK.Optimizer)

	@variable(model, 20 < y < 30)
	# global variable y is now defined, but Pluto does not know it

	...
end
```

✔️ Do:
```julia
begin
	model = Model(GLPK.Optimizer)

	y = @variable(model, 20 < y < 30)
	# global variable y is now defined, and Pluto knows it

	...
end
```

""" |> opacity(.5)

# ╔═╡ b99f3213-f2c4-4d85-b34c-a60052571af3
md"""
# Example
"""

# ╔═╡ 68e07edd-55dd-45d8-9f8a-24ae75a20960
@bind xmax Slider(1:.01:4)

# ╔═╡ 470eaa98-4073-11eb-349d-e9c34e5478c2
let
	global model = Model(GLPK.Optimizer)
	
	@variable(model, 0 <= x <= xmax)
	@variable(model, 0 <= y <= 30)
	
	@objective(model, Max, 5x + 3 * y)
	
	@constraint(model, con, 1x + 5y <= 3)
	
	model
end

# ╔═╡ 2717450b-8e9d-4be4-9156-53b2020a2e5d
Text(model)

# ╔═╡ 95e0721d-321f-478c-8d02-0ac070008a5b
model_opt = let
	optimize!(model)
	model
end

# ╔═╡ 69a565bc-e250-4105-9b6b-3b9879dcb417
termination_status(model_opt)

# ╔═╡ e4d0ad7b-9e72-45c7-9eb9-0ed06567aef8
objective_value(model_opt)

# ╔═╡ 15037686-c495-42c3-b976-11ac753dde18
value(model_opt[:x])

# ╔═╡ 946b13ae-65f2-4844-a38a-693b2f01bad4
value(model_opt[:y])

# ╔═╡ Cell order:
# ╠═2e3d4b69-786e-4ccb-91ec-3b98f1f568e0
# ╟─d5b9c438-b1e7-4417-870f-afdfc4ee7672
# ╟─759c0a90-bb03-456e-bbf6-8bf80b249c07
# ╟─ce6d95f3-d745-4215-844c-727c9d90861d
# ╟─8bc3d43a-1460-498b-baa8-fcb9a3338457
# ╟─267e9766-e2c1-4006-abb0-ae69fba94052
# ╟─cdda279d-60bf-495c-b796-a62e5dd1d699
# ╟─9b4e18a3-669f-4bab-8c22-565428ebf299
# ╟─b99f3213-f2c4-4d85-b34c-a60052571af3
# ╠═470eaa98-4073-11eb-349d-e9c34e5478c2
# ╠═2717450b-8e9d-4be4-9156-53b2020a2e5d
# ╠═95e0721d-321f-478c-8d02-0ac070008a5b
# ╠═68e07edd-55dd-45d8-9f8a-24ae75a20960
# ╠═69a565bc-e250-4105-9b6b-3b9879dcb417
# ╠═e4d0ad7b-9e72-45c7-9eb9-0ed06567aef8
# ╠═15037686-c495-42c3-b976-11ac753dde18
# ╠═946b13ae-65f2-4844-a38a-693b2f01bad4
