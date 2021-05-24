### A Pluto.jl notebook ###
# v0.14.5

using Markdown
using InteractiveUtils

# ╔═╡ 545cf963-2bc2-47eb-9703-37f59b53a8e0
using Symbolics: @variables

# ╔═╡ dca1e9f3-3436-4bf9-be3c-0ad68b018dfb
using LaTeXStrings

# ╔═╡ 1864d720-8ac8-462c-9da1-66eb6e04d726
using JuMP

# ╔═╡ 21cd0e7f-06f4-4b48-afe2-0e3211136189
m = MIME"text/latex"()

# ╔═╡ 16af878a-c829-492f-a256-81a42c61cb96
r(x) = repr(m, x) |> Text

# ╔═╡ 9232532c-4736-44dd-b7fa-8fd251617fb4
html"""
<p>Don't render $this$ as latex</p>
"""

# ╔═╡ 3ae2c074-f9a8-4e9e-8558-9318539bdc46
a = L"world"

# ╔═╡ 6aeb6f2f-4949-4e5f-976b-156a3af836c0
b = L"hello $world$"

# ╔═╡ 37dd9b26-e363-48e7-9e39-4209d35238d5
c = L"hello $world$ asdf"

# ╔═╡ 80798acd-92a7-47c5-9bc8-d59cb88ca82d
r(a), r(b), r(c)

# ╔═╡ bdf556b5-185b-4a9a-8d9b-08bb29b5cc53
@variables d e f

# ╔═╡ 0990ad15-e5c3-432d-beb9-5a3bf765bb01
d

# ╔═╡ fc5fb277-923b-4f38-84e8-9cfa93bb8f58
r(d)

# ╔═╡ cfd1d2ef-45cf-4115-aae7-5d4006d4479b
g = let
	g = Model()
	
	@variable(g, 0 <= x <= 2)
	@variable(g, 0 <= y <= 30)
	
	@objective(g, Max, 5x + 3 * y)
	
	@constraint(g, con, 1x + 5y <= 3)
	
	g
end

# ╔═╡ d280aa04-8b14-4b23-9ad3-4025ba70957e
r(g)

# ╔═╡ 486cfadb-d164-4465-9737-d78b90912ae3
h = md"""

Hello $math$ how are

```math
you?
```
"""

# ╔═╡ fd7ae8c3-681a-4c98-bb70-0383c7d2568b
repr(MIME"text/html"(), h) |> Text

# ╔═╡ Cell order:
# ╠═545cf963-2bc2-47eb-9703-37f59b53a8e0
# ╠═dca1e9f3-3436-4bf9-be3c-0ad68b018dfb
# ╠═21cd0e7f-06f4-4b48-afe2-0e3211136189
# ╠═16af878a-c829-492f-a256-81a42c61cb96
# ╠═9232532c-4736-44dd-b7fa-8fd251617fb4
# ╠═3ae2c074-f9a8-4e9e-8558-9318539bdc46
# ╠═6aeb6f2f-4949-4e5f-976b-156a3af836c0
# ╠═37dd9b26-e363-48e7-9e39-4209d35238d5
# ╠═80798acd-92a7-47c5-9bc8-d59cb88ca82d
# ╠═1864d720-8ac8-462c-9da1-66eb6e04d726
# ╠═bdf556b5-185b-4a9a-8d9b-08bb29b5cc53
# ╠═0990ad15-e5c3-432d-beb9-5a3bf765bb01
# ╠═fc5fb277-923b-4f38-84e8-9cfa93bb8f58
# ╠═cfd1d2ef-45cf-4115-aae7-5d4006d4479b
# ╠═d280aa04-8b14-4b23-9ad3-4025ba70957e
# ╠═486cfadb-d164-4465-9737-d78b90912ae3
# ╠═fd7ae8c3-681a-4c98-bb70-0383c7d2568b
