### A Pluto.jl notebook ###
# v0.11.14

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

# ╔═╡ c5dd9c62-f7a6-11ea-15e4-118cb6e53508
begin
	import Pkg
	import Pluto # before switching to the clean env
	Pkg.activate(mktempdir())
	Pkg.add(["PlutoUI"])
	using PlutoUI
end

# ╔═╡ afd5941c-f7a6-11ea-34ba-f133c8de5f33
md"# Metaprogramming

#### _(How to make Pluto)_"

# ╔═╡ 7d0c9f6e-f7a7-11ea-3e45-4db0179fcc2b
md"## What is code?"

# ╔═╡ 8905bafa-f7a7-11ea-39aa-ff4b5ebd106a
md"Julia code comes in many forms. On its way from your thoughts to raw CPU instructions, the code undergoes a number of transformations. Every time that we go down a layer, we get to a structure that is more powerful and explicit, but less expressive.

1. Thoughts in your head
2. A text file with code (`String`)
3. A syntax tree (`Expr`)
...
9. CPU instructions
"

# ╔═╡ 66b909ca-f7a8-11ea-1093-113cde7cc0d4
md"""
## Syntax parsing
When you write Julia code, you do so by writing a _text file_. Try writing some Julia code in the box below!
"""

# ╔═╡ f4b37ca0-f7a6-11ea-1c99-f5b52cb6b6e2
@bind test_code TextField((50, 5); default="""
	x = let
	    # Let's do some math!
	    y=123
	    sqrt(y)
	end""")

# ╔═╡ ab3f2f72-f7a8-11ea-3b9e-774cff225ad1
md"Here is your code, in its original form, a `String`:"

# ╔═╡ 54846afe-f7a7-11ea-35dd-cfc4012189aa
test_code

# ╔═╡ b8a50dce-f7aa-11ea-1cc9-fb1d10f7f41f
typeof(test_code)

# ╔═╡ 3e80ea62-f7ab-11ea-2637-af7131039d3a


# ╔═╡ cd2e8baa-f7a8-11ea-1979-33ab25c8e6f6
md"""
This is where we begin our story. The first thing that Julia does is _syntax parsing_: it goes from a `String` to an `Expr`.
"""

# ╔═╡ 48b044d2-f7a9-11ea-3cf3-c336c733e927
md"That's right! Julia code is **just another object** in Julia! But what we see might be a little confusing: it is just the code that we typed, right?"

# ╔═╡ 28174952-f7aa-11ea-2464-6f8c2427deb1
md"

Well, not exactly. What you see is Julia's built-in rich display, which does its best to make the `Expr` readable for us. The most readable way to display an abstract `Expr` is to show the equivalent code.

So instead, let's look directly at the internal structure of `test_expr`:"

# ╔═╡ 0c91710c-f7ad-11ea-17d9-edf08d577737
md"## Evaluation"

# ╔═╡ 246af24c-f7ad-11ea-037a-7b780766b233
@bind eval_code TextField((50, 5); default="""
	x = let
	    # Let's do some math!
	    y=123
	    sqrt(y)
	end""")

# ╔═╡ 876a3720-f7ad-11ea-0269-5519680cba39


# ╔═╡ ff3a81c4-f7aa-11ea-1b47-8fcabe2eac3c
html"<br><br><br><br>"

# ╔═╡ fccf2e14-f7a8-11ea-205e-19f63917c9c8
function sprint_dump(x)
	Text(sprint(Base.dump, x))
end

# ╔═╡ 8e160dc0-f7a9-11ea-343f-b9d2e4b8f2a7
function parse_clean(code)
	Base.remove_linenums!(Meta.parse(code, raise=false))
end

# ╔═╡ 269fb5f6-f7a9-11ea-3ac6-d53bf17b7d2d
test_expr = parse_clean(test_code)

# ╔═╡ b34303fe-f7aa-11ea-06d8-a72c82742964
typeof(test_expr)

# ╔═╡ bf4776c2-f7a9-11ea-2242-c3590f69411b
sprint_dump(test_expr)

# ╔═╡ 38031b52-f7ad-11ea-1143-0dbbe8a3d162
eval_expr = parse_clean(eval_code)

# ╔═╡ 45a78aa8-f7ad-11ea-216c-8157cc182ae4
let
	🏡 = Module()
	Core.eval(🏡, eval_expr)
end

# ╔═╡ Cell order:
# ╟─afd5941c-f7a6-11ea-34ba-f133c8de5f33
# ╠═c5dd9c62-f7a6-11ea-15e4-118cb6e53508
# ╟─7d0c9f6e-f7a7-11ea-3e45-4db0179fcc2b
# ╟─8905bafa-f7a7-11ea-39aa-ff4b5ebd106a
# ╟─66b909ca-f7a8-11ea-1093-113cde7cc0d4
# ╟─f4b37ca0-f7a6-11ea-1c99-f5b52cb6b6e2
# ╟─ab3f2f72-f7a8-11ea-3b9e-774cff225ad1
# ╠═54846afe-f7a7-11ea-35dd-cfc4012189aa
# ╠═b8a50dce-f7aa-11ea-1cc9-fb1d10f7f41f
# ╟─3e80ea62-f7ab-11ea-2637-af7131039d3a
# ╟─cd2e8baa-f7a8-11ea-1979-33ab25c8e6f6
# ╟─269fb5f6-f7a9-11ea-3ac6-d53bf17b7d2d
# ╠═b34303fe-f7aa-11ea-06d8-a72c82742964
# ╟─48b044d2-f7a9-11ea-3cf3-c336c733e927
# ╟─28174952-f7aa-11ea-2464-6f8c2427deb1
# ╠═bf4776c2-f7a9-11ea-2242-c3590f69411b
# ╟─0c91710c-f7ad-11ea-17d9-edf08d577737
# ╟─246af24c-f7ad-11ea-037a-7b780766b233
# ╠═38031b52-f7ad-11ea-1143-0dbbe8a3d162
# ╠═45a78aa8-f7ad-11ea-216c-8157cc182ae4
# ╠═876a3720-f7ad-11ea-0269-5519680cba39
# ╟─ff3a81c4-f7aa-11ea-1b47-8fcabe2eac3c
# ╠═fccf2e14-f7a8-11ea-205e-19f63917c9c8
# ╠═8e160dc0-f7a9-11ea-343f-b9d2e4b8f2a7
