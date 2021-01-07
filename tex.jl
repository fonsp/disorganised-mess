### A Pluto.jl notebook ###
# v0.8.4

using Markdown

# ╔═╡ a94abf82-92c6-11ea-170a-4d794cf8ac63
md"$z$"

# ╔═╡ 1b5f812e-92c3-11ea-3a0a-d5bed15a8d38
md"a
$\require{physics}$
b"

# ╔═╡ b2d786ec-7f73-11ea-1a0c-f38d7b6bbc1e
md"# The Basel problem

_Leonard Euler_ proved $x$ in 1741 that the series

$$\frac{1}{1} + \frac{1}{4} + \frac{1}{9} + \cdots$$

converges to

$$\order{R}{x} \frac{\pi^2}{6}$$"

# ╔═╡ b2d79330-7f73-11ea-0d1c-a9aad1efaae1
n = 1:100000

# ╔═╡ b2d79376-7f73-11ea-2dce-cb9c449eece6
seq = n .^ -2

# ╔═╡ b2d792c2-7f73-11ea-0c65-a5042701e9f3
sqrt(sum(seq) * 6.0)

# ╔═╡ 0cf88ec0-92c3-11ea-084d-b758f62f4c84


# ╔═╡ Cell order:
# ╠═a94abf82-92c6-11ea-170a-4d794cf8ac63
# ╠═1b5f812e-92c3-11ea-3a0a-d5bed15a8d38
# ╠═b2d786ec-7f73-11ea-1a0c-f38d7b6bbc1e
# ╠═b2d792c2-7f73-11ea-0c65-a5042701e9f3
# ╠═b2d79330-7f73-11ea-0d1c-a9aad1efaae1
# ╠═b2d79376-7f73-11ea-2dce-cb9c449eece6
# ╠═0cf88ec0-92c3-11ea-084d-b758f62f4c84
