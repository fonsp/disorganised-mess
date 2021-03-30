### A Pluto.jl notebook ###
# v0.14.0

using Markdown
using InteractiveUtils

# ╔═╡ a3a8d88a-456d-49e5-9d14-99aef55df9a8
merge_recursive(a::Dict,b::Dict) = mergewith(merge_recursive, a, b)

# ╔═╡ 027039d8-a148-4655-8e93-37df5626fcc0
merge_recursive(a,b) = b

# ╔═╡ 27c088d8-37ec-4a62-a2e6-db645efdb85e


# ╔═╡ a0b4afb4-e514-433d-8661-d32bf036f75c
test1 = merge_recursive(
	Dict("a"=>1, "b"=>2),
	Dict("a"=>3, "d"=>4),
)

# ╔═╡ 8973930d-ec5e-46c1-ba4b-9888f4144319
test1 == Dict("a"=>3,"b"=>2,"d"=>4)

# ╔═╡ aee200e6-b33b-4158-a075-432e715cac1f


# ╔═╡ c54c16d8-3776-4dbe-befe-4c7d6e96e579
test2 = merge_recursive(
	Dict("z" => Dict("a"=>1, "b"=>2)),
	Dict("z" => Dict("a"=>3, "d"=>4)),
)

# ╔═╡ e6c450a1-a020-48fd-adf5-90e04566f16a
test2 == Dict("z" => Dict("a"=>3,"b"=>2,"d"=>4))

# ╔═╡ Cell order:
# ╠═a3a8d88a-456d-49e5-9d14-99aef55df9a8
# ╠═027039d8-a148-4655-8e93-37df5626fcc0
# ╠═27c088d8-37ec-4a62-a2e6-db645efdb85e
# ╠═a0b4afb4-e514-433d-8661-d32bf036f75c
# ╠═8973930d-ec5e-46c1-ba4b-9888f4144319
# ╠═aee200e6-b33b-4158-a075-432e715cac1f
# ╠═c54c16d8-3776-4dbe-befe-4c7d6e96e579
# ╠═e6c450a1-a020-48fd-adf5-90e04566f16a
