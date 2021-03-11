### A Pluto.jl notebook ###
# v0.14.0

using Markdown
using InteractiveUtils

# ╔═╡ 45cb771b-fa2d-4e09-adae-ed3a1d199ce7
using BenchmarkTools

# ╔═╡ 8933fcc1-7d5a-4c4c-ba5c-0ec0207149e5


# ╔═╡ e45c2d23-b3df-46fc-9934-d4172ea1bf77
md"""
# `@eval` for faster array check
"""

# ╔═╡ 391a0932-bff9-484d-b758-cdfff2d37131
xs = [1,2,3]

# ╔═╡ 2a11ef44-bea5-4e6e-ac1b-089c0822787d
md"""
## Base case
"""

# ╔═╡ fa8e2497-91bd-4333-bdd5-c97b55d20421
function issmall1(x)
	x ∈ xs
end

# ╔═╡ 568651ad-a2c8-441f-bdea-9f397bcd0790
@benchmark issmall1(5)

# ╔═╡ 496372f0-c7b4-49ad-8eda-3306240077f7
@benchmark issmall1(2)

# ╔═╡ 674354fa-236a-4f0f-99c7-3ac4cdb3ff24
md"""
## With `@eval`
"""

# ╔═╡ 09067792-d450-4178-adaf-2e5e98f9ce4f
or_sequence(exprs) = foldl(Iterators.reverse(exprs)) do e, next
	:($(next) || $(e))
end

# ╔═╡ 744b6299-d9c3-4e49-ba30-b03504e6ef2f
@eval function issmall2(x)
	$(or_sequence(:(x == $v) for v in xs))
end

# ╔═╡ 5adabd08-0a7b-4770-88d6-d9d52a1eb7c7
@benchmark issmall2(2)

# ╔═╡ 0b4e358f-7a05-4350-a9bf-beef4287715f
@benchmark issmall2(5)

# ╔═╡ 9c53bb9c-0fe8-4805-94de-d8ccbb3c76bf
or_sequence(xs)

# ╔═╡ Cell order:
# ╠═8933fcc1-7d5a-4c4c-ba5c-0ec0207149e5
# ╟─e45c2d23-b3df-46fc-9934-d4172ea1bf77
# ╠═45cb771b-fa2d-4e09-adae-ed3a1d199ce7
# ╠═391a0932-bff9-484d-b758-cdfff2d37131
# ╟─2a11ef44-bea5-4e6e-ac1b-089c0822787d
# ╠═fa8e2497-91bd-4333-bdd5-c97b55d20421
# ╠═568651ad-a2c8-441f-bdea-9f397bcd0790
# ╠═496372f0-c7b4-49ad-8eda-3306240077f7
# ╟─674354fa-236a-4f0f-99c7-3ac4cdb3ff24
# ╠═744b6299-d9c3-4e49-ba30-b03504e6ef2f
# ╠═5adabd08-0a7b-4770-88d6-d9d52a1eb7c7
# ╠═0b4e358f-7a05-4350-a9bf-beef4287715f
# ╠═09067792-d450-4178-adaf-2e5e98f9ce4f
# ╠═9c53bb9c-0fe8-4805-94de-d8ccbb3c76bf
