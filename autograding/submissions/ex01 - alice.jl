### A Pluto.jl notebook ###
# v0.12.4

using Markdown
using InteractiveUtils

# ╔═╡ 7308bc54-e6cd-11ea-0eab-83f7535edf25
student = (name="Alice Doe", email="alice@mit.edu", number=1)

# ╔═╡ a2181260-e6cd-11ea-2a69-8d9d31d1ef0e
md"""
# Homework 0: test

Submission by: **_$(student.name)_** ($(student.email))
"""

# ╔═╡ 094e39c8-e6ce-11ea-131b-07c4a1199edf


# ╔═╡ 31a8fbf8-e6ce-11ea-2c66-4b4d02b41995


# ╔═╡ 339c2d5c-e6ce-11ea-32f9-714b3628909c
md"## Exercise 1

Give a number larger than 100:"

# ╔═╡ 52ad29c8-e6ce-11ea-1518-339a995bb0d7
big_number = 200

# well done!

# ╔═╡ 56866718-e6ce-11ea-0804-d108af4e5653


# ╔═╡ 5e24d95c-e6ce-11ea-24be-bb19e1e14657
md"## Exercise 2

Write a function that checks whether a number is positive:"

# ╔═╡ 634b49a2-e6ce-11ea-15ae-2d0680e3d7cc
function ispositive(x)
	return x > -1
end

# ╔═╡ c9bf4288-e6ce-11ea-0e13-a36b5e685998


# ╔═╡ d3625d20-e6ce-11ea-394a-53208540d626


# ╔═╡ Cell order:
# ╟─a2181260-e6cd-11ea-2a69-8d9d31d1ef0e
# ╠═7308bc54-e6cd-11ea-0eab-83f7535edf25
# ╟─094e39c8-e6ce-11ea-131b-07c4a1199edf
# ╟─31a8fbf8-e6ce-11ea-2c66-4b4d02b41995
# ╟─339c2d5c-e6ce-11ea-32f9-714b3628909c
# ╠═52ad29c8-e6ce-11ea-1518-339a995bb0d7
# ╟─56866718-e6ce-11ea-0804-d108af4e5653
# ╟─5e24d95c-e6ce-11ea-24be-bb19e1e14657
# ╠═634b49a2-e6ce-11ea-15ae-2d0680e3d7cc
# ╟─c9bf4288-e6ce-11ea-0e13-a36b5e685998
# ╟─d3625d20-e6ce-11ea-394a-53208540d626
