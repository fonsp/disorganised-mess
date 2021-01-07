### A Pluto.jl notebook ###
# v0.9.2

using Markdown
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.peek, el) ? Base.peek(el) : missing
        el
    end
end

# ╔═╡ 208d21d4-7cf8-11ea-00d8-6ddebdbd8b4e
b = 2

# ╔═╡ 1d26246e-7cf8-11ea-2d71-81a145d6dc31
a = b

# ╔═╡ 3958f2ca-7ca9-11ea-373c-a181ef1bb265
md"_This notebook is not executable._"

# ╔═╡ 51c8c0a4-7ca9-11ea-2ab5-ed47c171d3f4
md"You already have interactivity in Pluto - by defining variables in separate cells, and changing their value. The only thing missing is UI to replace the process of _type-new-value-and-run_. Because this is only a minor change, the syntax should be minimal.

You should be able to go from a cell like:"

# ╔═╡ b2d35936-7ca9-11ea-0564-0f68a1774078
md"to something like"

# ╔═╡ a3aefccc-7ce9-11ea-1793-0bbb6c254e2c
md"""this `@bind var domobject` expression will modify the domobject and return the modified object, which will `show` to `text/html` as:

```
<input type="range" min="1" max="9" defines="x">
```

this custom `modifies` attribute contains the space-separated list of workspace variable names that it will set its value to.

The Pluto JS client will check all output for HTML inputs with this attribute set, and attach the appropriate event listeners."""

# ╔═╡ bf786884-7cea-11ea-0529-4521e57afdb0
myslider = html"""<input type="range" min="1" max="9" defines="x">"""

# ╔═╡ e7550560-7cea-11ea-2755-339fef9b4cfb
md"exactly _what_ the `Slider` object will be, I still haven't decided - it would be nice to re-use a lightweight DOM library, like `Hyperscript.jl`."

# ╔═╡ 785fd432-7cea-11ea-0c9c-91ddf45ac4c9
md"### Type"

# ╔═╡ 8ecb4342-7ce9-11ea-0569-0ba3f63a251b
md"The variable `t` is still of type `Int64`, and changing its value using the DOM input will behave identically to changing the code from `t = 1` to `t = 2`. This means that you write 'interactive listeners' using the syntax:"

# ╔═╡ c17e53a0-7ca9-11ea-2939-719a1226c9af
sqrt(t)

# ╔═╡ aad4a2ba-7cea-11ea-1998-776ca592cc8e
md"### Complex UI"

# ╔═╡ 7cc243e8-7cea-11ea-3044-b5237e51c11a
md"""the `"@bind` expression returns the slider object, so you can create more complicated UI like this:"""

# ╔═╡ 3903c360-7ceb-11ea-0a57-afe3d80cbc10
begin
	xslider = @bind x Slider(1:9)
	yslider = @bind y Slider(1:9)
	
	md"Lorem $(xslider) ipsum $(yslider)"
end

# ╔═╡ 744a4e58-7ceb-11ea-37d2-a1283396e4d8
md"(you can put HTML objects like $(myslider) inside a markdown literal)"

# ╔═╡ b01306f6-7ca9-11ea-1b02-a74411e219e9
t = 5

# ╔═╡ bb7d74d6-7ca9-11ea-276a-0501cbcf454a
@bind t Slider(1:9)

# ╔═╡ Cell order:
# ╠═1d26246e-7cf8-11ea-2d71-81a145d6dc31
# ╠═208d21d4-7cf8-11ea-00d8-6ddebdbd8b4e
# ╠═3958f2ca-7ca9-11ea-373c-a181ef1bb265
# ╠═51c8c0a4-7ca9-11ea-2ab5-ed47c171d3f4
# ╠═b01306f6-7ca9-11ea-1b02-a74411e219e9
# ╠═b2d35936-7ca9-11ea-0564-0f68a1774078
# ╠═bb7d74d6-7ca9-11ea-276a-0501cbcf454a
# ╠═a3aefccc-7ce9-11ea-1793-0bbb6c254e2c
# ╠═bf786884-7cea-11ea-0529-4521e57afdb0
# ╠═e7550560-7cea-11ea-2755-339fef9b4cfb
# ╠═785fd432-7cea-11ea-0c9c-91ddf45ac4c9
# ╠═8ecb4342-7ce9-11ea-0569-0ba3f63a251b
# ╠═c17e53a0-7ca9-11ea-2939-719a1226c9af
# ╠═aad4a2ba-7cea-11ea-1998-776ca592cc8e
# ╠═7cc243e8-7cea-11ea-3044-b5237e51c11a
# ╠═3903c360-7ceb-11ea-0a57-afe3d80cbc10
# ╠═744a4e58-7ceb-11ea-37d2-a1283396e4d8
