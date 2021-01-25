### A Pluto.jl notebook ###
# v0.12.18

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

# ╔═╡ a58cd747-4f7e-4277-a3a8-7ad60f21aa35
begin
	using Pkg
	Pkg.activate(mktempdir())
	Pkg.add([
			Pkg.PackageSpec(name="PlutoUI", version="0.6.7-0.6"), 
			Pkg.PackageSpec(name="Plots", version="1.6-1"),
			Pkg.PackageSpec(name="Combinatorics"),
			])

	using Plots
	gr()
	using PlutoUI
	using Combinatorics
end

# ╔═╡ 5939ffe6-5f2b-11eb-16b0-37c3cbfabe7a
html"""<button style="font-size: 1rem; margin:auto; display: block;" onClick="present()">Start presentation mode!</button>"""

# ╔═╡ 141efa5d-e66a-4212-b3ad-040f253b1e78
@bind prof_size Slider(0 : 0.01 : 2)

# ╔═╡ 00d81ec5-c9e1-459d-8de7-f193e05241c0
"""
<h1 style="text-align: center">Computational Thinking</h1>
<h3 style="font-style: italic; opacity: .6; font-weight: 100; text-align: right; margin-top: -.2em; margin-right: 1rem">Math from Computation</h3>
<h3 style="font-style: italic; opacity: .4; font-weight: 100; text-align: right; margin-top: -.2em;">Math with Computation</h3>
<br>
<br>
<br>
<em style="font-size: $(prof_size)rem;">Alan Edelman</em>

""" |> HTML

# ╔═╡ e545a33e-3c48-48ac-9c9f-660bd61132ad
md"n = $(@bind n Slider(1:10, show_value=true, default=3))"

# ╔═╡ f2e1c626-ae31-4e33-9409-e9f696d38142
let
	bar(
		[length(combinations(1:n, k)) for k in 1:n],
		dpi=400, size=(400,200), leg=false
	)
end

# ╔═╡ e2cd7b2d-c09f-4dc8-85a0-94cf9409b2cd
@bind n_again Slider(1:50)

# ╔═╡ a741afd6-61e7-43b6-b242-acad152284d4
let
	bar(
		[length(combinations(1:n_again, k)) for k in 1:n_again], 
		dpi=400, size=(600,300), leg=false
	)
end

# ╔═╡ b88bf072-604f-4d70-985b-b413a41614ee
function onoff(permutation)
	text = map(1:n) do i
		if i ∈ permutation
			"🌕"
		else
			"🌑"
		end
	end |> join
end

# ╔═╡ b672d26a-cafd-4332-9a31-70a32ea46d96
md"k = $(@bind k Slider(1:n, show_value=true))"

# ╔═╡ 82b64095-60f3-413e-940a-f4358077d67a
prettylist(x) = join([string(p) * "\n" for p in x]) |> Text

# ╔═╡ d2b09aa9-bc70-4a20-bf42-24495a07445f
Any[prettylist(combinations(1:n, k)) for k in 1:n]

# ╔═╡ a6495f5c-f91a-4655-b4c5-ce68f6bdf9f2
Any[prettylist(combinations(1:n, k) .|> onoff) for k in 1:n]

# ╔═╡ 8035c639-4f78-4df0-b6be-1db2a1a0ba2a
combinations(1:n, k) |> prettylist

# ╔═╡ 4909a6ad-cc17-4233-8056-8b2b2b12116a
md"""
## First example

asdfasdf

"""

# ╔═╡ c7064213-e778-4fab-91a9-c05cd35005a1
md"""
## **Exercise 1**: _Calculus without calculus_
"""

# ╔═╡ c06f344b-47d4-43de-ac3b-c498375f3ba8
md"""
Before we jump in to simulating the SIR equations, let's experiment with a simple 1D function. In calculus, we learn techniques for differentiating and integrating _symbolic_ equations, e.g. ``\frac{d}{dx} x^n = nx^{n-1}``. But in real applications, it is often impossible to apply these techniques, either because the problem is too complicated to solve symbolically, or because our problem has no symbolic expression, like when working with experimental results.

Instead, we use ✨ _computers_ ✨ to approximate derivatives and integrals. Instead of applying rules to symbolic expressions, we use much simpler strategies that _only use the output values of our function_.

As a first example, we will approximate the _derivative_ of a function. Our method is inspired by the analytical definition of the derivative!

$$f'(a) := \lim_{h \rightarrow 0} \frac{f(a + h) - f(a)}{h}.$$

The finite difference method simply fixes a small value for $h$, say $h = 10^{-3}$, and then approximates the derivative as:

$$f'(a) \simeq \frac{f(a + h) - f(a)}{h}.$$
"""

# ╔═╡ 630a149e-e89a-44d9-89b5-6bef1c7e66d0
md"""
#### Exercise 1.1 - _tangent line_

👉 Write a function `finite_difference_slope` that takes a function `f` and numbers `a` and `h`. It returns the slope ``f'(a)``, approximated using the finite difference formula above.
"""

# ╔═╡ 0bdc3d8d-8bf2-4f18-8e40-3a30eca09133
function finite_difference_slope(f::Function, a, h=1e-3)
	(f(a+h) - f(a)) / h
end

# ╔═╡ 98cef02d-6384-48d9-b0bc-8bc52cb80747
# function finite_difference_slope(f::Function, a, h=1e-3)
	
# 	return missing
# end

# ╔═╡ f3d215c0-fbb6-4598-bd99-69edb135f05a
finite_difference_slope(sqrt, 4.0, 5.0)

# ╔═╡ f876cc6c-7eeb-4fef-bf2b-03c583c8b421
md"""
👉 Write a function `tangent_line` that takes the same arguments `f`, `a` and `g`, but it **returns a function**. This function (``\mathbb{R} \rightarrow \mathbb{R}``) is the _tangent line_ with slope ``f'(a)`` (computed using `finite_difference_slope`) that passes through ``(a, f(a))``.
"""

# ╔═╡ 7ec17a1a-30f8-46b1-8be1-5f489fb99db8
function tangent_line(f, a, h)
	slope = finite_difference_slope(f, a, h)
	value = f(a)
	
	x -> (x - a)*slope + value
end

# ╔═╡ 534b80d7-0928-4614-b51d-de59ee9bc531
# function tangent_line(f, a, h)
	
# 	return missing
# end

# ╔═╡ 6aab5dc7-0976-4db4-9673-610d7a0651e5
# this is our test function
wavy(x) = .1x^3 - 1.6x^2 + 7x - 3;

# ╔═╡ 84b7c809-cc1f-445c-b50c-9ba48b443f40
md"""
The slider below controls ``h`` using a _log scale_. In the (mathematical) definition of the derivative, we take ``\lim_{h \rightarrow 0}``. This corresponds to moving the slider to the left. 

Notice that, as you decrease ``h``, the tangent line gets more accurate, but what happens if you make ``h`` too small?
"""

# ╔═╡ 238b7126-c316-489e-8982-8e08ebd6c34f
@bind log_h Slider(-16:0.01:.5, default=-.5)

# ╔═╡ ceb46944-56cb-43aa-a3dc-d89564664fdb
h_finite_diff = 10.0^log_h

# ╔═╡ d4c863e4-2ac4-4f20-9c61-a25b0ada3d2e
zeroten = LinRange(0.0, 10.0, 300);

# ╔═╡ 5198981a-e29d-4d04-a859-d6a4b9b1c947
@bind a_finite_diff Slider(zeroten, default=4)

# ╔═╡ b8ca714c-d383-4712-92db-305e0080e62f
let
	p = plot(zeroten, wavy, label="f(x)")
	scatter!(p, [a_finite_diff], [wavy(a_finite_diff)], label="a", color="red")
	vline!(p, [a_finite_diff], label=nothing, color="red", linestyle=:dash)
	scatter!(p, [a_finite_diff+h_finite_diff], [wavy(a_finite_diff+h_finite_diff)], label="a + h", color="green")
	
	try
		result = tangent_line(wavy, a_finite_diff, h_finite_diff)
		
		plot!(p, zeroten, result, label="tangent", color="purple")
	catch
	end
	
	plot!(p, xlim=(0,10), ylim=(-2, 8))
end |> as_svg

# ╔═╡ eb43af8d-fb70-4ed6-b5a7-957e29513556
md"""
$(html"<span id=theslopeequation></span>")
#### Exercise 1.2 - _antiderivative_

In the finite differences method, we approximated the derivative of a function:

$$f'(a) \simeq \frac{f(a + h) - f(a)}{h}$$

We can do something very similar to approximate the 'antiderivate' of a function. Finding the antiderivative means that we use the _slope_ ``f'`` to compute ``f`` numerically!

This antiderivative problem is illustrated below. The only information that we have is the **slope** at any point ``a \in \mathbb{R}``, and we have one **initial value**, ``f(1)``.
"""

# ╔═╡ ebba6c76-ef1c-461d-9d69-b8886871ccfb
# in this exercise, only the derivative is given
wavy_deriv(x) = .3x^2 - 3.2x + 7;

# ╔═╡ c9cc9ac6-f88a-4dcf-90ac-c1a0673cdc6c
@bind a_euler Slider(zeroten, default=1)

# ╔═╡ 6a21ac53-24eb-4aa5-b41c-4f5ae993b4f7
let
	slope = wavy_deriv(a_euler)
	
	p = plot(LinRange(1.0 - 0.1, 1.0 + 0.1, 2), wavy, label=nothing, lw=3)
	scatter!(p, [1], wavy, label="f(1)", color="blue", lw=3)
	# p = plot()
	x = [a_euler - 0.2,a_euler + 0.2]
	for y in -4:10
		plot!(p, x, slope .* (x .- a_euler) .+ y, label=nothing, color="purple", opacity=.6)
	end
	
	vline!(p, [a_euler], color="red", label="a", linestyle=:dash)
	
	plot!(p, xlim=(0,10), ylim=(-2, 8))
end |> as_svg

# ╔═╡ 82284d45-5872-4286-86e7-5017ae5cfe6b
md"""
Using only this information, we want to **reconstruct** ``f``.

By rearranging [the equation above](#theslopeequation), we get the _Euler method_:

$$f(a+h) \simeq hf'(a) + f(a)$$

Using this formula, we only need to know the _value_ ``f(a)`` and the _slope_ ``f'(a)`` of a function at ``a`` to get the value at ``a+h``. Doing this repeatedly can give us the value at ``a+2h``, at ``a+3h``, etc., all from one initial value ``f(a)``.

👉 Write a function `euler_integrate_step` that applies this formula to a known function ``f'`` at ``a``, with step size ``h`` and the initial value ``f(a)``. It returns the next value, ``f(a+h)``.
"""

# ╔═╡ 514dd856-5b4f-4c36-a424-afce2bcf5791
function euler_integrate_step(fprime::Function, fa::Number, 
		a::Number, h::Number)
	
	fa + h*fprime(a + h)
end

# ╔═╡ ec51239e-ca7e-48ef-801c-966ae719bd5a
# function euler_integrate_step(fprime::Function, fa::Number, 
# 		a::Number, h::Number)
	
# 	return missing
# end

# ╔═╡ d5b98d92-3ec4-44e3-8526-ee9f9c35bc3a
md"""
👉 Write a function `euler_integrate` that takes takes a known function ``f'``, the initial value ``f(a)`` and a range `T` with `a == first(T)` and `h == step(T)`. It applies the function `euler_integrate_step` repeatedly, once per entry in `T`, to produce the sequence of values ``f(a+h)``, ``f(a+2h)``, etc.
"""

# ╔═╡ 135d98b0-4002-4036-a849-e44009610196
function euler_integrate(fprime::Function, fa::Number, 
		T::AbstractRange)
	
	a0 = T[1]
	h = step(T)
	
	accumulate(T, init=fa) do prev, a
		euler_integrate_step(fprime, prev, a, h)
	end
end

# ╔═╡ 67169740-f7c7-4632-8a23-e469925d4876
# function euler_integrate(fprime::Function, fa::Number, 
# 		T::AbstractRange)
	
# 	a0 = T[1]
# 	h = step(T)
	
# 	return missing
# end

# ╔═╡ b8e86a96-4f0d-4f1e-9a9d-e1b9d8e121cb
md"""
Let's try it out on ``f'(x) = 3x^2`` and `T` ranging from ``0`` to ``10``.

We already know the analytical solution ``f(x) = x^3``, so the result should be an array going from (approximately) `0.0` to `1000.0`.
"""

# ╔═╡ 8d418d9c-250d-449a-b5b4-5e5b32509571
euler_test = let
	fprime(x) = 3x^2
	T = 0 : 0.1 : 10
	
	euler_integrate(fprime, 0, T)
end

# ╔═╡ d8f73780-4743-4726-ba6e-7ac2ba3b9a08
@bind N_euler Slider(2:40)

# ╔═╡ 933f2298-c276-48e5-a9e6-18b67618de71
let
	a = 1
	h = .3
	history = euler_integrate(wavy_deriv, wavy(a), range(a; step=h, length=N_euler))
	
	slope = wavy_deriv(a_euler)
	
	p = plot(zeroten, wavy, label="exact solution", lw=3, opacity=.1, color="gray")
	# p = plot()
	
	plot!(p, a .+ h .* (1:N_euler), history, 
		color="blue", label=nothing)
	scatter!(p, a .+ h .* (1:N_euler), history, 
		color="blue", label="appromixation", 
		markersize=2, markerstrokewidth=0)
	
	last_a = a + (N_euler-1)*h
	vline!(p, [last_a], color="red", label="a", linestyle=:dash)
	
	plot!(p, [0,10], ([0,10] .- (last_a+h)) .* wavy_deriv(last_a+h) .+ history[end],
		label="tangent",
		color="purple")
	
	plot!(p, xlim=(0,10), ylim=(-2, 8))
end |> as_svg

# ╔═╡ 4d0b4a42-c5de-4e21-9420-36a62a131abb
md"""
You see that our numerical antiderivate is not very accurate, but we can get a smaller error by choosing a smaller step size. Try it out!

There are also alternative integration methods that are more accurate with the same step size. Some methods also use the second derivative, other methods use multiple steps at once, etc.! This is the study of Numerical Methods.
"""

# ╔═╡ 7565ca8b-1fad-4225-99b4-1af80ebdda57
md"""
## Some cool things
"""

# ╔═╡ a2209202-68f4-4fba-afae-8e09ab941e66


# ╔═╡ e974c497-0935-44c1-a982-d5be2945fcfe
md"asdfasdf"

# ╔═╡ 4352d196-682d-4f68-b362-4072a1393a7d
md"## Function library

Just some helper functions used in the notebook."

# ╔═╡ 6a274121-d155-4639-80ed-e0557d5a86f7
hint(text) = Markdown.MD(Markdown.Admonition("hint", "Hint", [text]))

# ╔═╡ 2ddcc67b-9311-44b1-8250-72338fc804b4
hint(md"""
	Remember that [functions are objects](https://www.youtube.com/watch?v=_O-HBDZMLrM)! For example, here is a function that returns the square root function:
	```julia
	function the_square_root_function()
		f = x -> sqrt(x)
		return f
	end
	```
	""")

# ╔═╡ 515da366-7804-4ca2-ad10-4b986bc25b61
almost(text) = Markdown.MD(Markdown.Admonition("warning", "Almost there!", [text]))

# ╔═╡ e2ef82e0-1580-41ba-8eed-d4fae614fd45
still_missing(text=md"Replace `missing` with your answer.") = Markdown.MD(Markdown.Admonition("warning", "Here we go!", [text]))

# ╔═╡ f5892647-b2fb-4df8-9a15-321ec6661413
keep_working(text=md"The answer is not quite right.") = Markdown.MD(Markdown.Admonition("danger", "Keep working on it!", [text]))

# ╔═╡ 91b68a34-3710-4b75-a9f2-3699ae38fa46
yays = [md"Fantastic!", md"Splendid!", md"Great!", md"Yay ❤", md"Great! 🎉", md"Well done!", md"Keep it up!", md"Good job!", md"Awesome!", md"You got the right answer!", md"Let's move on to the next section."]

# ╔═╡ f6091361-091b-412b-889d-6c6d1561c145
correct(text=rand(yays)) = Markdown.MD(Markdown.Admonition("correct", "Got it!", [text]))

# ╔═╡ 4808a38b-1aca-4e6d-8ca1-52f25aafcf03
let
	result = euler_integrate_step(x -> x^2, 10, 11, 12)

	if result isa Missing
		still_missing()
	elseif !(result isa Number)
		keep_working(md"Make sure that you return a number.")
	else
		if result ≈ 6358
			correct()
		elseif result ≈ 1462
			almost(md"Use ``f'(a+h)``, not ``f'(a)``.")
		else
			keep_working()
		end
	end
end

# ╔═╡ 84957d7e-4dcd-4ac9-8aa1-43ee4c655451
if euler_test isa Missing
	still_missing()
elseif !(euler_test isa Vector) || (abs(length(euler_test) - 101) > 1)
	keep_working(md"Make sure that you return a vector of numbers, of the same size as `T`.")
else
	if abs(euler_test[1] - 0) > 1
		keep_working()
	elseif abs(euler_test[50] - 5^3) > 20
		keep_working()
	elseif abs(euler_test[end] - 10^3) > 100
		keep_working()
	else
		correct()
	end
end

# ╔═╡ 6b548b1f-7b31-4c2e-b934-9f28427a4eac
not_defined(variable_name) = Markdown.MD(Markdown.Admonition("danger", "Oopsie!", [md"Make sure that you define a variable called **$(Markdown.Code(string(variable_name)))**"]))

# ╔═╡ 17f0ebbb-20ef-43af-b4ff-060bf9ca7690
if !@isdefined(finite_difference_slope)
	not_defined(:finite_difference_slope)
else
	let
		result = finite_difference_slope(sqrt, 4.0, 5.0)
		
		if result isa Missing
			still_missing()
		elseif !(result isa Real)
			keep_working(md"Make sure that you return a number.")
		else
			if result ≈ 0.2
				correct()
			else
				keep_working()
			end
		end
	end
end

# ╔═╡ 03353eca-326c-43b8-873d-ceadf9417558
if !@isdefined(tangent_line)
	not_defined(:tangent_line)
else
	let
		result = tangent_line(sqrt, 4.0, 5.0)
		
		if result isa Missing
			still_missing()
		elseif !(result isa Function)
			keep_working(md"Make sure that you return a function.")
		else
			if finite_difference_slope(result, 14.0, 15.0) ≈ 0.2
				if result(4.0) ≈ 2.0
					correct()
				else
					almost(md"The tangent line should pass through $(a, f(a))$.")
				end
			else
				keep_working()
			end
		end
	end
end

# ╔═╡ Cell order:
# ╟─5939ffe6-5f2b-11eb-16b0-37c3cbfabe7a
# ╟─00d81ec5-c9e1-459d-8de7-f193e05241c0
# ╠═141efa5d-e66a-4212-b3ad-040f253b1e78
# ╟─e545a33e-3c48-48ac-9c9f-660bd61132ad
# ╠═d2b09aa9-bc70-4a20-bf42-24495a07445f
# ╠═a6495f5c-f91a-4655-b4c5-ce68f6bdf9f2
# ╟─f2e1c626-ae31-4e33-9409-e9f696d38142
# ╟─e2cd7b2d-c09f-4dc8-85a0-94cf9409b2cd
# ╟─a741afd6-61e7-43b6-b242-acad152284d4
# ╠═b88bf072-604f-4d70-985b-b413a41614ee
# ╠═b672d26a-cafd-4332-9a31-70a32ea46d96
# ╠═8035c639-4f78-4df0-b6be-1db2a1a0ba2a
# ╠═82b64095-60f3-413e-940a-f4358077d67a
# ╠═a58cd747-4f7e-4277-a3a8-7ad60f21aa35
# ╟─4909a6ad-cc17-4233-8056-8b2b2b12116a
# ╟─c7064213-e778-4fab-91a9-c05cd35005a1
# ╟─c06f344b-47d4-43de-ac3b-c498375f3ba8
# ╟─630a149e-e89a-44d9-89b5-6bef1c7e66d0
# ╟─0bdc3d8d-8bf2-4f18-8e40-3a30eca09133
# ╟─98cef02d-6384-48d9-b0bc-8bc52cb80747
# ╟─f3d215c0-fbb6-4598-bd99-69edb135f05a
# ╟─17f0ebbb-20ef-43af-b4ff-060bf9ca7690
# ╟─f876cc6c-7eeb-4fef-bf2b-03c583c8b421
# ╟─2ddcc67b-9311-44b1-8250-72338fc804b4
# ╟─7ec17a1a-30f8-46b1-8be1-5f489fb99db8
# ╟─534b80d7-0928-4614-b51d-de59ee9bc531
# ╟─03353eca-326c-43b8-873d-ceadf9417558
# ╟─5198981a-e29d-4d04-a859-d6a4b9b1c947
# ╟─b8ca714c-d383-4712-92db-305e0080e62f
# ╟─6aab5dc7-0976-4db4-9673-610d7a0651e5
# ╟─84b7c809-cc1f-445c-b50c-9ba48b443f40
# ╟─238b7126-c316-489e-8982-8e08ebd6c34f
# ╟─ceb46944-56cb-43aa-a3dc-d89564664fdb
# ╟─d4c863e4-2ac4-4f20-9c61-a25b0ada3d2e
# ╟─eb43af8d-fb70-4ed6-b5a7-957e29513556
# ╟─ebba6c76-ef1c-461d-9d69-b8886871ccfb
# ╟─c9cc9ac6-f88a-4dcf-90ac-c1a0673cdc6c
# ╟─6a21ac53-24eb-4aa5-b41c-4f5ae993b4f7
# ╟─82284d45-5872-4286-86e7-5017ae5cfe6b
# ╟─514dd856-5b4f-4c36-a424-afce2bcf5791
# ╟─ec51239e-ca7e-48ef-801c-966ae719bd5a
# ╟─4808a38b-1aca-4e6d-8ca1-52f25aafcf03
# ╟─d5b98d92-3ec4-44e3-8526-ee9f9c35bc3a
# ╟─135d98b0-4002-4036-a849-e44009610196
# ╟─67169740-f7c7-4632-8a23-e469925d4876
# ╟─b8e86a96-4f0d-4f1e-9a9d-e1b9d8e121cb
# ╟─8d418d9c-250d-449a-b5b4-5e5b32509571
# ╟─84957d7e-4dcd-4ac9-8aa1-43ee4c655451
# ╟─d8f73780-4743-4726-ba6e-7ac2ba3b9a08
# ╟─933f2298-c276-48e5-a9e6-18b67618de71
# ╟─4d0b4a42-c5de-4e21-9420-36a62a131abb
# ╟─7565ca8b-1fad-4225-99b4-1af80ebdda57
# ╠═a2209202-68f4-4fba-afae-8e09ab941e66
# ╠═e974c497-0935-44c1-a982-d5be2945fcfe
# ╟─4352d196-682d-4f68-b362-4072a1393a7d
# ╟─6a274121-d155-4639-80ed-e0557d5a86f7
# ╟─515da366-7804-4ca2-ad10-4b986bc25b61
# ╟─e2ef82e0-1580-41ba-8eed-d4fae614fd45
# ╟─f5892647-b2fb-4df8-9a15-321ec6661413
# ╟─91b68a34-3710-4b75-a9f2-3699ae38fa46
# ╟─f6091361-091b-412b-889d-6c6d1561c145
# ╟─6b548b1f-7b31-4c2e-b934-9f28427a4eac
