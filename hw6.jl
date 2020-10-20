### A Pluto.jl notebook ###
# v0.12.4

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

# ╔═╡ 05b01f6e-106a-11eb-2a88-5f523fafe433
begin
	using Pkg
	Pkg.activate(mktempdir())
	Pkg.add([
			Pkg.PackageSpec(name="PlutoUI", version="0.6.7-0.6"), 
			Pkg.PackageSpec(name="Plots", version="1.6-1"),
			Pkg.PackageSpec(name="JSON"),
			])

	using Plots
	gr()
	using PlutoUI
	import JSON
end

# ╔═╡ 048890ee-106a-11eb-1a81-5744150543e8
md"_homework 6, version 0_"

# ╔═╡ 056ed7f2-106a-11eb-3543-31a5cb560e80
# WARNING FOR OLD PLUTO VERSIONS, DONT DELETE ME

html"""
<script>
const warning = html`
<h2 style="color: #800">Oopsie! You need to update Pluto to the latest version</h2>
<p>Close Pluto, go to the REPL, and type:
<pre><code>julia> import Pkg
julia> Pkg.update("Pluto")
</code></pre>
`

const super_old = window.version_info == null || window.version_info.pluto == null
if(super_old) {
	return warning
}
const version_str = window.version_info.pluto.substring(1)
const numbers = version_str.split(".").map(Number)
console.log(numbers)

if(numbers[0] > 0 || numbers[1] > 12 || numbers[2] > 1) {
	
} else {
	return warning
}

</script>

"""

# ╔═╡ 0579e962-106a-11eb-26b5-2160f461f4cc
md"""

# **Homework 6**: _Epidemic modeling III_
`18.S191`, fall 2020

This notebook contains _built-in, live answer checks_! In some exercises you will see a coloured box, which runs a test case on your code, and provides feedback based on the result. Simply edit the code, run it, and the check runs again.

_For MIT students:_ there will also be some additional (secret) test cases that will be run as part of the grading process, and we will look at your notebook and write comments.

Feel free to ask questions!
"""

# ╔═╡ 0587db1c-106a-11eb-0560-c3d53c516805
# edit the code below to set your name and kerberos ID (i.e. email without @mit.edu)

student = (name = "Jazzy Doe", kerberos_id = "jazz")

# you might need to wait until all other cells in this notebook have completed running. 
# scroll around the page to see what's up

# ╔═╡ 0565af4c-106a-11eb-0d38-2fb84493d86f
md"""

Submission by: **_$(student.name)_** ($(student.kerberos_id)@mit.edu)
"""

# ╔═╡ 05976f0c-106a-11eb-03a4-0febbc18fae8
md"_Let's create a package environment:_"

# ╔═╡ 0d191540-106e-11eb-1f20-bf72a75fb650
md"""
We began this module with **data** on the COVID-19 epidemic, but then looked at mathematical **models**. 
How can we make the connection between data and models?

Models have *parameters*, such as the rate of recovery from infection. 
Where do the parameter values come from? Ideally we would like to extract them from data. 
The goal of this homework is to do this by *fitting* a model to data.

For simplicity we will use data that generated from the spatial model in Homework 5, rather than real-world data, 
and we will fit the simplest SIR model. But the same ideas apply more generally.

There are many ways to fit a function to data, but all must involve some form of **optimization**, 
usually **minimization** of a particular function, a **loss function**; this is the basis of the vast field of **machine learning**.

The loss function is a function of the model parameters; it measures *how far* the model *output* is from the data,
for the given values of the parameters. 

We emphasise that this material is pedagogical; there is no suggestion that these specific techniques should be used actual calculations; rather, it is the underlying ideas that are important.
"""

# ╔═╡ 3cd69418-10bb-11eb-2fb5-e93bac9e54a9
md"""
## **Exercise 1**: _Calculus without calculus_
"""

# ╔═╡ 17af6a00-112b-11eb-1c9c-bfd12931491d
md"""
Before we jump in to simulating the SIR equations, let's experiment with a simple 1D function. In calculus, we learn techniques for differentiating and integrating _symbolic_ equations, e.g. ``\frac{d}{dx} x^n = nx^{n-1}``. But in real applications, it is often impossible to apply these techniques, either because the problem is too complicated to solve symbolically, or because our problem has no symbolic expression, like when working with experimental results.

Instead, we use ✨ _computers_ ✨ to approximate derivatives and integrals. Instead of applying rules to symbolic expressions, we use much simpler strategies that _only use the output values of our function_.

As a first example, we will approximate the _derivative_ of a function. Our method is inspired by the analytical definition of the derivative!

$$f'(a) := \lim_{h \rightarrow 0} \frac{f(a + h) - f(a)}{h}.$$

The finite difference method simply fixes a small value for $h$, say $h = 10^{-3}$, and then approximates the derivative as:

$$f'(a) \simeq \frac{f(a + h) - f(a)}{h}.$$
"""

# ╔═╡ 2a4050f6-112b-11eb-368a-f91d7a023c9d
md"""
#### Exercise 1.1 - _tangent line_

👉 Write a function `finite_difference_slope` that takes a function `f` and numbers `a` and `h`. It returns the slope ``f'(a)``, approximated using the finite difference formula above.
"""

# ╔═╡ 910d30b2-112b-11eb-2d9b-0f509a5d28fb
function finite_difference_slope(f::Function, a, h=1e-3)
	(f(a+h) - f(a)) / h
end

# ╔═╡ f0576e48-1261-11eb-0579-0b1372565ca7
finite_difference_slope(sqrt, 4.0, 5.0)

# ╔═╡ bf8a4556-112b-11eb-042e-d705a2ca922a
md"""
👉 Write a function `tangent_line` that takes the same arguments `f`, `a` and `g`, but it **returns a function**. This function (``\mathbb{R} \rightarrow \mathbb{R}``) is the _tangent line_ with slope ``f'(a)`` (computed using `finite_difference_slope`) that passes through ``(a, f(a))``.
"""

# ╔═╡ 01571b20-10ba-11eb-1c4a-292e427109b7
function tangent_line(f, a, h)
	slope = finite_difference_slope(f, a, h)
	value = f(a)
	
	x -> (x - a)*slope + value
end

# ╔═╡ 2b79b698-10b9-11eb-3bde-53fc1c48d5f7
# this is our test function
wavy(x) = .1x^3 - 1.6x^2 + 7x - 3;

# ╔═╡ a732bbcc-112c-11eb-1d65-110c049e226c
md"""
The slider below controls ``h`` using a _log scale_. In the (mathematical) definition of the derivative, we take ``\lim_{h \rightarrow 0}``. This corresponds to moving the slider to the left. 

Notice that, as you decrease ``h``, the tangent line gets more accurate, but what happens if you make ``h`` too small?
"""

# ╔═╡ c9535ad6-10b9-11eb-0537-45f13931cd71
@bind log_h Slider(-16:0.01:.5, default=-.5)

# ╔═╡ 7495af52-10ba-11eb-245f-a98781ba123c
h_finite_diff = 10.0^log_h

# ╔═╡ 327de976-10b9-11eb-1916-69ad75fc8dc4
zeroten = LinRange(0.0, 10.0, 300);

# ╔═╡ abc54b82-10b9-11eb-1641-817e2f043d26
@bind a_finite_diff Slider(zeroten, default=4)

# ╔═╡ 43df67bc-10bb-11eb-1cbd-cd962a01e3ee
md"""
$(html"<span id=theslopeequation></span>")
#### Exercise 1.2 - _antiderivative_

In the finite differences method, we approximated the derivative of a function:

$$f'(a) \simeq \frac{f(a + h) - f(a)}{h}$$

We can do something very similar to approximate the 'antiderivate' of a function. Finding the antiderivative means that we use the _slope_ ``f'`` to compute ``f`` numerically!

This antiderivative problem is illustrated below. The only information that we have is the **slope** at any point ``a \in \mathbb{R}``, and we have one **initial value**, ``f(1)``.
"""

# ╔═╡ d5a8bd48-10bf-11eb-2291-fdaaff56e4e6
# in this exercise, only the derivative is given
wavy_deriv(x) = .3x^2 - 3.2x + 7;

# ╔═╡ 0b4e8cdc-10bd-11eb-296c-d51dc242a372
@bind a_euler Slider(zeroten, default=1)

# ╔═╡ 1d8ce3d6-112f-11eb-1343-079c18cdc89c
md"""
Using only this information, we want to **reconstruct** ``f``.

By rearranging [the equation above](#theslopeequation), we get:

$$f(a+h) \simeq hf'(a) + f(a)$$

Using this formula, we only need to know the _value_ ``f(a)`` and the _slope_ ``f'(a)`` of a function at ``a`` to get the value at ``a+h``. Doing this repeatedly can give us the value at ``a+2h``, at ``a+3h``, etc., all from one initial value ``f(a)``.
"""

# ╔═╡ 2335cae6-112f-11eb-3c2c-254e82014567
md"""
👉 Write a function `euler_integrate` that takes the known function ``f'``, the initial value ``f(a)``, ``a``, ``h`` and the number of steps.
"""

# ╔═╡ 24037812-10bf-11eb-2653-e5c6cdfe95d9
function euler_integrate(fprime::Function, fa::Number, 
		a::Number, h::Number, N_steps::Integer)
	
	accumulate(0:(N_steps-1), init=fa) do prev, i
		prev + h*fprime(a + i*h)
	end
end

# ╔═╡ b74d94b8-10bf-11eb-38c1-9f39dfcb1096
euler_integrate(sqrt, 0, 1, .1, 100)

# ╔═╡ ab72fdbe-10be-11eb-3b33-eb4ab41730d6
@bind N_euler Slider(2:40)

# ╔═╡ d21fad2a-1253-11eb-304a-2bacf9064d0d
md"""
You see that our numerical antiderivate is not very accurate, but we can get a smaller error by choosing a smaller step size. Try it out!

There are also alternative integration methods that are more accurate with the same step size. Some methods also use the second derivative, other methods use multiple steps at once, etc.! This is the study of Numerical Methods.
"""

# ╔═╡ 517ab0c2-1244-11eb-049d-ffdc054e030d
function euler_SIR_step(β, γ, sir_0::Vector, h::Number)
	s, i, r = sir_0
	
	return missing
end

# ╔═╡ 517efa24-1244-11eb-1f81-b7f95b87ce3b
md"""
👉 Implement a function `euler_SIR(β, γ, sir_0, T)` that applies the previously defined function over a time range $T$.

You should return a vector of vectors: a 3-element vector for each point in time.
"""

# ╔═╡ 51a0138a-1244-11eb-239f-a7413e2e44e4
function euler_SIR(β, γ, sir_0::Vector, T::AbstractRange)
	# T is a range, you get the step size and number of steps like so:
	h = step(T)
	
	num_steps = length(T)
	
	return missing
end

# ╔═╡ 0a095a94-1245-11eb-001a-b908128532aa
euler_SIR(0.1, 0.05, 
	[0.99, 0.01, 0.00], 
	0 : 0.1 : 30.0)

# ╔═╡ 51c9a25e-1244-11eb-014f-0bcce2273cee
md"""
👉 Plot $s$, $i$ and $r$ as a function of time $t$.
"""

# ╔═╡ 58675b3c-1245-11eb-3548-c9cb8a6b3188


# ╔═╡ 586d0352-1245-11eb-2504-05d0aa2352c6
md"""
👉 Do you see an epidemic outbreak (i.e. a rapid growth in number of infected individuals, followed by a decline)? What happens after a long time? Does everybody get infected?
"""

# ╔═╡ 589b2b4c-1245-11eb-1ec7-693c6bda97c4
default_SIR_parameters_observation = md"""
blabla
"""

# ╔═╡ 58b45a0e-1245-11eb-04d1-23a1f3a0f242
md"""
👉 Make an interactive visualization in which you vary $\beta$ and $\gamma$. What relation should $\beta$ and $\gamma$ have for an epidemic outbreak to occur?
"""

# ╔═╡ 68274534-1103-11eb-0d62-f1acb57721bc


# ╔═╡ 82539bbe-106e-11eb-0e9e-170dfa6a7dad
md"""

## **Exercise 3:** _Numerical gradient_

For fitting we need optimization, and for optimization we will use *derivatives* (rates of change). In Exercise 1, we wrote a function `finite_difference_slope(f, a)` to approximate ``f'(a)``. In this exercise we will write a function to compute _partial derivatives_.
"""

# ╔═╡ b394b44e-1245-11eb-2f86-8d10113e8cfc
md"""
#### Exercise 3.1
👉 Write functions `∂x(f, a, b)` and `∂y(f, a, b)` that calculate the **partial derivatives** $\frac{\partial f}{\partial x}$ and $\frac{\partial f}{\partial y}$ at $(a, b)$ of a function $f : \mathbb{R}^2 \to \mathbb{R}$ (i.e. a function that takes two real numbers and returns one real).

Recall that $\frac{\partial f}{\partial x}$  is the derivative of the single-variable function $g(x) := f(x, b)$ obtained by fixing the value of $y$ to $b$.

You should use **anonymous functions** for this. These have the form `x -> x^2`, meaning "the function that sends $x$ to $x^2$".

"""

# ╔═╡ d101b79a-1245-11eb-3855-61e7b6088d68
function ∂x(f::Function, a, b)
	directional = h -> f(a + h, b)
	finite_difference_slope(directional, 0)
end

# ╔═╡ 321964ac-126d-11eb-0a04-0d3e3fb9b17c
∂x(
	(x, y) -> 7x^2 + y, 
	3, 7
)

# ╔═╡ 34318eee-1246-11eb-213f-455b632dba3a
function ∂y(f::Function, a, b)
	directional = h -> f(a, b + h)
	finite_difference_slope(directional, 0)
end

# ╔═╡ a15509ee-126c-11eb-1fa3-cdda55a47fcb
∂y(
	(x, y) -> 7x^2 + y, 
	3, 7
)

# ╔═╡ b398a29a-1245-11eb-1476-ab65e92d1bc8
md"""
#### Exercise 3.2
👉 Write a function `gradient(f, a, b)` that calculates the **gradient** of a function $f$ at the point $(a, b)$, given by the vector $\nabla f(a, b) := (\frac{\partial f}{\partial x}(a, b), \frac{\partial f}{\partial y}(a, b))$.
"""

# ╔═╡ 69ff577a-1103-11eb-15b7-536764063bc2
function gradient(f::Function, a, b)
	[∂x(f, a, b), ∂y(f, a, b)]
end

# ╔═╡ 4f65ced2-1246-11eb-1808-616baf4a677c
gradient(pi,1) do x, y
	sin(x) * y
end

# ╔═╡ 66b8e15e-126c-11eb-095e-39c2f6abc81d
gradient(
	(x, y) -> 7x^2 + y, 
	3, 7
)

# ╔═╡ 82579b90-106e-11eb-0018-4553c29e57a2
md"""
## **Exercise 4:** _Minimisation using gradient descent_

In this exercise we will use **gradient descent** to find local **minima** of (smooth enough) functions.

To do so we will think of a function as a hill. To find a minimum we should "roll down the hill".

#### Exercise 4.1

👉 Write a function `gradient_descent_1d(f, x0)` to minimize a 1D function, i.e. a function $f: \mathbb{R} \to \mathbb{R}$.

To do so we notice that the derivative tells us the direction in which the function *increases*. So we take steps in the *opposite* direction, of a small size $\eta$ (eta).

Use this to write the function starting from the point `x0` and using your function `deriv` to approximate the derivative.

Take a reasonably large number of steps, say 1000, with $\eta = 0.01$.

"""

# ╔═╡ eb1c0198-1246-11eb-1792-13d6458a0142
function gradient_descent_1d(f, x0, η=0.01)
	reduce(1:1000; init=x0) do old, _
		slope = finite_difference_slope(f, old)
		
		old - η*sign(slope)
	end
end

# ╔═╡ 34dc4b02-1248-11eb-26b2-5d2610cfeb41
let
	f = x -> (x - 5)^2 - 3
	# minimum should be at x = 5
	gradient_descent_1d(f, 0.0)
end

# ╔═╡ e3120c18-1246-11eb-3bf4-7f4ac45856e0
md"""
    What would be a better way to decide when to end the function?

Write an interactive visualization showing the progress of gradient descent on the function

    $$f(x) = x^{4} +3x^{3} - 3x + 5.$$

    Make sure that it does indeed get close to a local minimum.

    How can you find different local minima?
"""

# ╔═╡ 981af516-126d-11eb-2232-73d1423add70
From fonsi:

should we skip these exercises about "modify X to return the array of intermediate results"?

# ╔═╡ 9fd2956a-1248-11eb-266d-f558cda55702
md"""
#### Exericse 123
Multivariable calculus tells us that the gradient $\nabla f(a, b)$ at a point $(a, b)$ is the direction in which the function *increases* the fastest. So again we should take a small step in the *opposite* direction. Note that the gradient is a *vector* which tells us which direction to move in the plane $(a, b)$.

👉 Write a function `gradient_descent_2d(f, x0, y0)` that does the same for functions $f(x, y)$ of two variables.
"""

# ╔═╡ ae65421e-1248-11eb-12be-af01d58e6cbc
function gradient_descent_2d(f, x0, y0; η=0.01)
	reduce(1:1000; init=(x0, y0)) do old, _
		antidirection = gradient(f, old...)
		
		old .- η * antidirection
	end
end

# ╔═╡ a0045046-1248-11eb-13bd-8b8ad861b29a
himmelbau(x, y) = (x^2 + y - 11)^2 + (x + y^2 - 7)^2

# ╔═╡ 92854562-1249-11eb-0b81-156982df1284
gradient_descent_2d(himmelbau, 0, 0)

# ╔═╡ fbb4a9a4-1248-11eb-00e2-fd346f0056db
surface(-4:0.05:5, -4:0.05:4, himmelbau)

# ╔═╡ 6d1ee93e-1103-11eb-140f-63fca63f8b06


# ╔═╡ 8261eb92-106e-11eb-2ccc-1348f232f5c3
md"""
## **Exercise 5:** _Learning parameter values_

In this exercise we will apply gradient descent to fit a simple function $y = f_{\alpha, \beta}(x)$ to some data given as pairs $(x_i, y_i)$. Here $\alpha$ and $\beta$ are **parameters** that appear in the form of the function $f$. We want to find the parameters that provide the **best fit**, i.e. the version $f_{\alpha, \beta}$ of the function that is closest to the data when we vary $\alpha$ and $\beta$.

To do so we need to define what "best" means. We will define a measure of the distance between the function and the data, given by a **loss function**, which itself depends on the values of $\alpha$ and $\beta$. Then we will *minimize* the loss function over $\alpha$ and $\beta$ to find those values that minimize this distance, and hence are "best" in this precise sense.

The iterative procedure by which we gradually adjust the parameter values to improve the loss function is often called **machine learning** or just **learning**, since the computer is "discovering" information in a gradual way, which is supposed to remind us of how humans learn. [Hint: This is not how humans learn.]

#### Exercise 5.1 - _🎲 frequencies_
We generate a small dataset by throwing 10 dice, and counting the sum. We repeat this experiment many times, giving us a frequency distribution in a familiar shape.
"""

# ╔═╡ 65e691e4-124a-11eb-38b1-b1732403aa3d
import Statistics

# ╔═╡ 6f4aa432-1103-11eb-13da-fdd9eefc7c86
function dice_frequencies(N_dice, N_experiments)
	
	experiment() = let
		sum_of_rolls = sum(rand(1:6, N_dice))
	end
	
	results = [experiment() for _ in 1:N_experiments]
	
	x = N_dice : N_dice*6
	
	y = map(x) do total
		sum(isequal(total), results)
	end ./ N_experiments
	
	x, y
end

# ╔═╡ dbe9635a-124b-11eb-111d-fb611954db56
dice_x, dice_y = dice_frequencies(10, 20_000)

# ╔═╡ 57090426-124e-11eb-0a17-1566ae96b7c2
md"""
Let's try to fit a gaussian (normal) distribution. Its PDF with mean $\mu$ and standard deviation $\sigma$ is

$$f_{\mu, \sigma}(x) := \frac{1}{\sigma \sqrt{2 \pi}}\exp \left[- \frac{(x - \mu)^2}{2 \sigma^2} \right]$$

👉 Manually fit a Gaussian distribution to our data by adjusting ``\mu`` and ``\sigma`` until you find a good fit.
"""

# ╔═╡ 66192a74-124c-11eb-0c6a-d74aecb4c624
md"μ = $(@bind guess_μ Slider(1:0.1:last(dice_x); default = last(dice_x) * 0.4, show_value=true))"

# ╔═╡ 70f0fe9c-124c-11eb-3dc6-e102e68673d9
md"σ = $(@bind guess_σ Slider(0.1:0.1:last(dice_x)/2; default=12, show_value=true))"


# ╔═╡ 41b2262a-124e-11eb-2634-4385e2f3c6b6
md"Show manual fit: $(@bind show_manual_fit CheckBox())"

# ╔═╡ 0dea1f70-124c-11eb-1593-e535ab21976c
function gauss(x, μ, σ)
	(1 / (sqrt(2π) * σ)) * exp(-(x-μ)^2 / σ^2 / 2)
end

# ╔═╡ ac320522-124b-11eb-1552-51c2adaf2521
let
	p = plot(dice_x, dice_y, size=(400,200), label="data")
	if show_manual_fit
		plot!(p, dice_x, gauss.(dice_x, [guess_μ], [guess_σ]), label="manual fit")
	else
		p
	end
end

# ╔═╡ 471cbd84-124c-11eb-356e-371d23011af5
md"""
What we just did was adjusting the function parameters until we found the best possible fit. Let's automate this process! To do so, we need to quantify how _good or bad_ a fit is.

👉 Define a **loss function** to measure the "distance" between the actual data and the function. It will depend on the values of $\mu$ and $\sigma$ that you choose:

$$\mathcal{L}(\mu, \sigma) := \sum_i [f_{\mu, \sigma}(x_i) - y_i]^2$$
"""

# ╔═╡ cdb5de86-124f-11eb-09c8-bd28710d1d44
function loss_dice(μ, σ)
	fit = gauss.(dice_x, [μ], [σ])
	sum((fit - dice_y) .^ 2)
end

# ╔═╡ 2fc55daa-124f-11eb-399e-659e59148ef5
# function loss_dice(μ, σ)
	
# 	return missing
# end

# ╔═╡ 3a6ec2e4-124f-11eb-0f68-791475bab5cd
loss_dice(guess_μ + 3, guess_σ) >
loss_dice(guess_μ, guess_σ)

# ╔═╡ 2fcb93aa-124f-11eb-10de-55fced6f4b83
md"""
👉 Use your `gradient_descent_2d` function to find a local minimum of $\mathcal{L}$, starting with initial values $\mu = 30$ and $\sigma = 1$.
"""

# ╔═╡ b3045130-124f-11eb-3ae0-a96d6393257d
found_μ, found_σ = let
	
	gradient_descent_2d(loss_dice, 30, 1, η=20)
end

# ╔═╡ a150fd60-124f-11eb-35d6-85104bcfd0fe
# found_μ, found_σ = let
	
# 	# your code here
	
# 	missing, missing
# end

# ╔═╡ 65aa13fe-1266-11eb-03c2-5927dbeca36e
stats_μ = sum(dice_x .* dice_y)

# ╔═╡ c569a5d8-1267-11eb-392f-452de141161b
abs(stats_μ - found_μ)

# ╔═╡ 6faf4074-1266-11eb-1a0a-991fc2e991bb
stats_σ = sqrt(sum(dice_x.^2 .* dice_y) - stats_μ .^ 2)

# ╔═╡ e55d9c1e-1267-11eb-1b3c-5d772662518a
abs(stats_σ - found_σ)

# ╔═╡ 826bb0dc-106e-11eb-29eb-03e7ddf9e4b5
md"""

## **Exercise 6:** _Putting it all together — fitting an SIR model to data_

In this exercise we will fit the (non-spatial) SIR ODE model from Exercise 1 to some data generated from the spatial model in Problem Set 4. 
If we are able to find a good fit, that would suggest that the spatial aspect "does not matter" too much for the dynamics of these models. 
If the fit is not so good, perhaps there is an important effect of space. (As usual in statistics, and indeed in modelling in general, we should be very cautious of making claims of this nature.)

This fitting procedure will be different from that in Exercise 4, however: we no longer have an explicit form for the function that we are fitting -- rather, it is the output
of an ODE! So what should we do?

We will try to find the parameters $\beta$ and $\gamma$ for which *the output of the ODEs when we simulate it with those parameters* best matches the data!

1. Load the data from the file XXX. It is given as columns of $(t, s, i, r)$ values. Extract this into vectors `ts`, `Ss`, `Is` and `Rs`.

2. Make a loss function $\mathcal{L}(\beta, \gamma)$. This will compare *the solution of the SIR equations* with parameters $\beta$ and $\gamma$ with your data.

    To do this, once we have generated the solution of the SIR equations with parameters $\beta$ and $\gamma$, we must evaluate that solution at the times $t$ in the vector `ts`, so that we can compare with the data at that time.

    Normally we would do this by some kind of **interpolation** (fitting a function locally through nearby data points). As a cheap alternative, we will just use the results corresponding to the closest value $t'$ with $t' < t$ that does occur in the solution of the ODEs. Write a function to calculate this value.

    (You should be able to do it *without* searching through the whole vector. Hint: Use the fact that the times are equally spaced.)

    The loss function should take the form

    $$\mathcal{L} = \mathcal{L}_S + 2 \mathcal{L}_I + \mathcal{L}_R$$

    where e.g. $\mathcal{L}_S$ is the loss function for the $S$ data, defined as in the previous exercise. The factor 2 weights $I$ more heavily, since the behaviour of $I$ is what we particularly care about, so we want to fit that better. You should experiment with different weights to see what effect it has.

4. Minimize the loss function and make an interactive visualization of how the solution of the SIR model compares to the data, as the parameters change during the gradient descent procedure.

    If you made it this far, congratulations -- you have just taken your first step into the exciting world of scientific machine learning!

"""

# ╔═╡ e562be6e-126d-11eb-2b43-ff0580dc9588
this exercise still needs 👉 and we need to run hw5 and generate the dataset. Put it on github and URL address it

# ╔═╡ b94b7610-106d-11eb-2852-25337ce6ec3a
if student.name == "Jazzy Doe" || student.kerberos_id == "jazz"
	md"""
	!!! danger "Before you submit"
	    Remember to fill in your **name** and **Kerberos ID** at the top of this notebook.
	"""
end

# ╔═╡ 10853972-108f-11eb-36b5-57f656bc992e
T = LinRange(0.0, 60.0, 500)

# ╔═╡ 2187253c-108f-11eb-04a2-512ce3c17abf
ΔT = step(T)

# ╔═╡ e8ea71fc-108e-11eb-2f27-e984fde247d2
A = [0  -1
	1    -.5]

# ╔═╡ 0af07152-108f-11eb-2c0b-d96b54bfd3a5
f(t,x) = A*x

# ╔═╡ bcac8f60-1086-11eb-1756-bb2b19f7a25f
function compute_path(first)
	accumulate(T; init=first) do x_prev, t
		x_prev + ΔT * f(t,x_prev)
	end
end

# ╔═╡ a10aad32-109a-11eb-1f62-a148b945d4f7
x0_ref = Ref([0.5, 0.5])

# ╔═╡ 6ed4ebaa-109a-11eb-10d4-0f51dcacbd8b
# begin
# 	if !@isdefined(x0)
# 		x0 = [0.5, 0.5]
# 	end
# 	wow(x0, :x0)
# end

# ╔═╡ e926013a-1080-11eb-24b8-034df3032883
with_d3_libs(content) = HTML("""
<script src="https://cdn.jsdelivr.net/npm/d3@6.2.0/dist/d3.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/d3-scale@3.2.3/dist/d3-scale.min.js"></script>
	
$(repr(MIME"text/html"(), content))
""")

# ╔═╡ 53dc7e0a-1081-11eb-39a3-c981848c2b1d
begin
	struct BondDefault
		element
		default
	end
	Base.show(io::IO, m::MIME"text/html", bd::BondDefault) = Base.show(io, m, bd.element)
	Base.get(bd::BondDefault) = bd.default
end

# ╔═╡ 04b79b02-1086-11eb-322b-cd995fa4196e
function wow(previous)
	path = compute_path(previous)
	
	c = """
	<script id="aa">
	
	const path = $(JSON.json(path))

	const svg = this == null ? DOM.svg(600,400) : this
	const s = this == null ? d3.select(svg) : this.s
	
	svg.value = $(JSON.json(previous))
	
	
	const xscale = d3.scaleLinear()
		.domain([-3,3])
		.range([20, 580])
	
	const yscale = d3.scaleLinear()
		.domain([-2,2])
		.range([380, 20])
	
	if(this == null) {
		s.append("g")
    		.attr("transform", `translate(\${xscale(0)},0)`)
			.call(d3.axisLeft(yscale))
		s.append("g")
    		.attr("transform", `translate(0,\${yscale(0)})`)
			.call(d3.axisBottom(xscale))
		s.append("g").classed("thepath", true)
	}
	
	const down_handler =(e) => {
		svg.value = [xscale.invert(e.clientX - svg.getBoundingClientRect().left), yscale.invert(e.clientY - svg.getBoundingClientRect().top)]
		svg.dispatchEvent(new CustomEvent("input", {}))
	}
	
	svg.addEventListener("pointerdown", down_handler)
	invalidation.then(() => svg.removeEventListener("pointerdown", down_handler))
	
	s.select("g.thepath").selectAll("path")
		.data([path])
		.join("path")
		.transition()
		.duration(300)
		.attr("d", d => d3.line()
							.x(p => xscale(p[0]))
							.y(p => yscale(p[1]))(d))
		.attr("stroke", "gray")
    	.attr('stroke-width', 5)
		.attr("fill", "none")

	const output = svg
	output.s = s
	return output
	</script>

	"""
	BondDefault(HTML(c), previous)
end

# ╔═╡ 99a6a906-1086-11eb-3528-fb705460853e
begin
	# we need to reference x0 in this cell --before assigning to x0-- to
	# register as self-updating cell
	if !@isdefined(x0)
		# x0 not defined means that this is the first run
		# when the bond sets a value, the new value will be assigned to x0 __before__
		# this cell is run.
		# so x0 defined means that this cell is running as response to the bond update
		
		# assign to x0 to register as self-update
		# bound values will only be set if they are assigned somewhere.
		# Normally @bind asdf ... assigns to asdf, but we avoided that
		x0 = x0_ref[]
	end
	# update the ref
	x0_ref[] = x0
	
	@bind x0 wow(x0)
	
end |> with_d3_libs

# ╔═╡ df42aa9e-10c9-11eb-2c19-2d7ce40a1c6c
as_mime(m::MIME) = x -> PlutoUI.Show(m, repr(m, x))

# ╔═╡ 15b60272-10ca-11eb-0a28-599ed78cf98a
"""
Return the argument, but force it to be shown as SVG.

This is an optimization for Plots.jl GR plots: it makes them less jittery and keeps the page DOM small.
"""
as_svg = as_mime(MIME"image/svg+xml"())

# ╔═╡ 3d44c264-10b9-11eb-0895-dbfc22ba0c37
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

# ╔═╡ 70df9a48-10bb-11eb-0b95-95a224b45921
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

# ╔═╡ 990236e0-10be-11eb-333a-d3080a224d34
let
	a = 1
	h = .3
	history = euler_integrate(wavy_deriv, wavy(a), a, h, N_euler)
	
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
	
	plot!(p, [0,10], ([0,10] .- last_a) .* wavy_deriv(last_a) .+ history[end-1],
		label="tangent",
		color="purple")
	
	plot!(p, xlim=(0,10), ylim=(-2, 8))
end |> as_svg

# ╔═╡ b94f9df8-106d-11eb-3be8-c5a1bb79d0d4
md"## Function library

Just some helper functions used in the notebook."

# ╔═╡ b9586d66-106d-11eb-0204-a91c8f8355f7
hint(text) = Markdown.MD(Markdown.Admonition("hint", "Hint", [text]))

# ╔═╡ 0f0b7ec4-112c-11eb-3399-59e22df07355
hint(md"""
	Remember that [functions are objects](https://www.youtube.com/watch?v=_O-HBDZMLrM)! For example, here is a function that returns the square root function:
	```julia
	function the_square_root_function()
		f = x -> sqrt(x)
		return f
	end
	```
	""")

# ╔═╡ b9616f92-106d-11eb-1bd1-ede92a617fdb
almost(text) = Markdown.MD(Markdown.Admonition("warning", "Almost there!", [text]))

# ╔═╡ b969dbaa-106d-11eb-3e5a-81766a333c49
still_missing(text=md"Replace `missing` with your answer.") = Markdown.MD(Markdown.Admonition("warning", "Here we go!", [text]))

# ╔═╡ b9728c20-106d-11eb-2286-4f670c229f3e
keep_working(text=md"The answer is not quite right.") = Markdown.MD(Markdown.Admonition("danger", "Keep working on it!", [text]))

# ╔═╡ b97afa48-106d-11eb-3c2c-cdee1d1cc6d7
yays = [md"Fantastic!", md"Splendid!", md"Great!", md"Yay ❤", md"Great! 🎉", md"Well done!", md"Keep it up!", md"Good job!", md"Awesome!", md"You got the right answer!", md"Let's move on to the next section."]

# ╔═╡ b98238ce-106d-11eb-1e39-f9eda5df76af
correct(text=rand(yays)) = Markdown.MD(Markdown.Admonition("correct", "Got it!", [text]))

# ╔═╡ f46aeaf0-1246-11eb-17aa-2580fdbcfa5a
let
	result = gradient_descent_1d(10) do x
		(x - 5pi) ^ 2 + 10
	end
	
	if result isa Missing
		still_missing()
	elseif !(result isa Real)
		keep_working(md"You need to return a number.")
	else
		error = abs(result - 5pi)
		if error > 5.0
			almost(md"It's not accurate enough yet. Maybe you need to increase the number of steps?")
		elseif error > 0.01
			keep_working()
		else
			correct()
		end
	end
end

# ╔═╡ b989e544-106d-11eb-3c53-3906c5c922fb
not_defined(variable_name) = Markdown.MD(Markdown.Admonition("danger", "Oopsie!", [md"Make sure that you define a variable called **$(Markdown.Code(string(variable_name)))**"]))

# ╔═╡ cd7583b0-1261-11eb-2a98-537bfab2463e
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

# ╔═╡ 66198242-1262-11eb-1b0f-37c58199c754
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

# ╔═╡ 5ea6c1f0-126c-11eb-3963-c98548f0b36e
if !@isdefined(∂x)
	not_defined(:∂x)
else
	let
		result = ∂x((x, y) -> 2x^2 + 3y^2, 6, 7)
		
		if result isa Missing
			still_missing()
		elseif !(result isa Number)
			keep_working(md"Make sure that you return a number.")
		else
			if abs(result - 24) < 1.0
				correct()
			else
				keep_working()
			end
		end
	end
end

# ╔═╡ c82b2148-126c-11eb-1c03-c157c9bd7eba
if !@isdefined(∂y)
	not_defined(:∂y)
else
	let
		result = ∂y((x, y) -> 2x^2 + 3y^2, 6, 7)
		
		if result isa Missing
			still_missing()
		elseif !(result isa Number)
			keep_working(md"Make sure that you return a number.")
		else
			if abs(result - 42) < 1.0
				correct()
			else
				keep_working()
			end
		end
	end
end

# ╔═╡ 46b07b1c-126d-11eb-0966-6ff5ab87ac9d
if !@isdefined(gradient)
	not_defined(:gradient)
else
	let
		result = gradient((x, y) -> 2x^2 + 3y^2, 6, 7)
		
		if result isa Missing
			still_missing()
		elseif !(result isa Vector)
			keep_working(md"Make sure that you return a 2-element vector.")
		else
			if abs(result[1] - 24) < 1 && abs(result[2] - 42) < 1
				correct()
			else
				keep_working()
			end
		end
	end
end

# ╔═╡ 05bfc716-106a-11eb-36cb-e7c488050d54
TODO = html"<span style='display: inline; font-size: 2em; color: purple; font-weight: 900;'>TODO</span>"

# ╔═╡ 15b50428-1264-11eb-163e-23e2f3590502
md" $TODO test?"

# ╔═╡ 518fb3aa-106e-11eb-0fcd-31091a8f12db
md"""
## **Exercise 2:** _Simulating the SIR differential equations_

Recall from the lectures that the ordinary differential equations (ODEs) for the SIR model are as follows:

$$\begin{align*}
\dot{s} &= - \beta s \, i \\
\dot{i} &= + \beta s \, i - \gamma i \\
\dot{r} &= +\gamma i
\end{align*}$$

where ``\dot{s} := \frac{ds}{dt}`` is the derivative of $s$ with respect to time. 
Recall that $s$ denotes the *proportion* (fraction) of the population that is susceptible, a number between $0$ and $1$.

We will use the simplest possible method to simulate these, namely the **Euler method**. The Euler method is not always a good method to solve ODEs accurately, but for our purposes it is good enough.

 $TODO maybe explain this without _f_. Go straight to discretised equations

For an ODE with a single variable, $\dot{x} = f(x)$, the Euler method takes steps of length $h$ in time. If we have an approximation $x_n$ at time $t_n$ it gives us an approximation for the value $x_{n+1}$ of $x$ at time $t_{n+1} = t_n + h$ as

$$x_{n+1} = x_n + h \, f(x_n)$$

In the case of several functions $s$, $i$ and $r$, we must use a rule like this for *each* of the differential equations within a *single* time step to get new values for *each* of $s$, $i$ and $r$ at the end of the time step in terms of the values at the start of the time step. In Julia we can write `s` for the old value and `s_new` for the new value.

👉 Implement a function `euler_SIR_step(β, γ, sir_0, h)` that performs a single Euler step for these equations with the given parameter values and initial values, with a step size $h$.

`sir_0` is a 3-element vector, and you should return a new 3-element vector with the values after the timestep.
"""

# ╔═╡ 84daf7c4-1244-11eb-0382-d1da633a63e2
TODO

# ╔═╡ 902dd1b4-1244-11eb-390b-3dc935d458a2
TODO

# ╔═╡ 9fcc46d8-1248-11eb-3954-f5047790ef8d
TODO

# ╔═╡ a03890d6-1248-11eb-37ee-85b0a5273e0c
md"""
 $TODO hmmm what to do here
4. Apply this to the **Himmelblau function** $f(x, y) := (x^2 + y - 11)^2 + (x + y^2 - 7)^2$. Visualize the trajectory using both contours (`contour` function) and a 2D surface (`surface` function). [Use e.g. `surface(-2:0.01:2, -2:0.01:2, f)`]

    Can you find different minima?
"""

# ╔═╡ a737990a-1251-11eb-1114-c57ceee75181
TODO

# ╔═╡ a1575cb6-124f-11eb-1ecb-c33fd953b553
md"""
 $TODO

6. Modify the gradient descent function to store the whole history of the values of $\mu$ and $\sigma$ that it went through.

    Make an interactive visualization showing how the resulting curve $f_{\mu, \sigma}$ evolves over time, compared to the original data.

    ("Time" here corresponds to the iterations in the gradient descent function.)

"""

# ╔═╡ 721079da-1103-11eb-2720-99754ea64c95
TODO

# ╔═╡ 10f67064-126e-11eb-3849-05cedcb340e6
md" $TODO everything below this can be deleted"

# ╔═╡ Cell order:
# ╟─048890ee-106a-11eb-1a81-5744150543e8
# ╟─0565af4c-106a-11eb-0d38-2fb84493d86f
# ╟─056ed7f2-106a-11eb-3543-31a5cb560e80
# ╟─0579e962-106a-11eb-26b5-2160f461f4cc
# ╠═0587db1c-106a-11eb-0560-c3d53c516805
# ╟─05976f0c-106a-11eb-03a4-0febbc18fae8
# ╠═05b01f6e-106a-11eb-2a88-5f523fafe433
# ╟─0d191540-106e-11eb-1f20-bf72a75fb650
# ╟─3cd69418-10bb-11eb-2fb5-e93bac9e54a9
# ╟─17af6a00-112b-11eb-1c9c-bfd12931491d
# ╟─2a4050f6-112b-11eb-368a-f91d7a023c9d
# ╠═910d30b2-112b-11eb-2d9b-0f509a5d28fb
# ╠═f0576e48-1261-11eb-0579-0b1372565ca7
# ╟─cd7583b0-1261-11eb-2a98-537bfab2463e
# ╟─bf8a4556-112b-11eb-042e-d705a2ca922a
# ╟─0f0b7ec4-112c-11eb-3399-59e22df07355
# ╠═01571b20-10ba-11eb-1c4a-292e427109b7
# ╟─66198242-1262-11eb-1b0f-37c58199c754
# ╟─abc54b82-10b9-11eb-1641-817e2f043d26
# ╟─3d44c264-10b9-11eb-0895-dbfc22ba0c37
# ╠═2b79b698-10b9-11eb-3bde-53fc1c48d5f7
# ╟─a732bbcc-112c-11eb-1d65-110c049e226c
# ╟─c9535ad6-10b9-11eb-0537-45f13931cd71
# ╟─7495af52-10ba-11eb-245f-a98781ba123c
# ╟─327de976-10b9-11eb-1916-69ad75fc8dc4
# ╟─43df67bc-10bb-11eb-1cbd-cd962a01e3ee
# ╠═d5a8bd48-10bf-11eb-2291-fdaaff56e4e6
# ╟─0b4e8cdc-10bd-11eb-296c-d51dc242a372
# ╟─70df9a48-10bb-11eb-0b95-95a224b45921
# ╟─1d8ce3d6-112f-11eb-1343-079c18cdc89c
# ╟─2335cae6-112f-11eb-3c2c-254e82014567
# ╠═24037812-10bf-11eb-2653-e5c6cdfe95d9
# ╠═b74d94b8-10bf-11eb-38c1-9f39dfcb1096
# ╠═15b50428-1264-11eb-163e-23e2f3590502
# ╟─ab72fdbe-10be-11eb-3b33-eb4ab41730d6
# ╟─990236e0-10be-11eb-333a-d3080a224d34
# ╟─d21fad2a-1253-11eb-304a-2bacf9064d0d
# ╟─518fb3aa-106e-11eb-0fcd-31091a8f12db
# ╠═517ab0c2-1244-11eb-049d-ffdc054e030d
# ╠═84daf7c4-1244-11eb-0382-d1da633a63e2
# ╟─517efa24-1244-11eb-1f81-b7f95b87ce3b
# ╠═51a0138a-1244-11eb-239f-a7413e2e44e4
# ╠═902dd1b4-1244-11eb-390b-3dc935d458a2
# ╠═0a095a94-1245-11eb-001a-b908128532aa
# ╟─51c9a25e-1244-11eb-014f-0bcce2273cee
# ╠═58675b3c-1245-11eb-3548-c9cb8a6b3188
# ╟─586d0352-1245-11eb-2504-05d0aa2352c6
# ╠═589b2b4c-1245-11eb-1ec7-693c6bda97c4
# ╟─58b45a0e-1245-11eb-04d1-23a1f3a0f242
# ╠═68274534-1103-11eb-0d62-f1acb57721bc
# ╟─82539bbe-106e-11eb-0e9e-170dfa6a7dad
# ╟─b394b44e-1245-11eb-2f86-8d10113e8cfc
# ╠═d101b79a-1245-11eb-3855-61e7b6088d68
# ╠═321964ac-126d-11eb-0a04-0d3e3fb9b17c
# ╟─5ea6c1f0-126c-11eb-3963-c98548f0b36e
# ╠═34318eee-1246-11eb-213f-455b632dba3a
# ╠═a15509ee-126c-11eb-1fa3-cdda55a47fcb
# ╟─c82b2148-126c-11eb-1c03-c157c9bd7eba
# ╟─b398a29a-1245-11eb-1476-ab65e92d1bc8
# ╠═69ff577a-1103-11eb-15b7-536764063bc2
# ╠═4f65ced2-1246-11eb-1808-616baf4a677c
# ╠═66b8e15e-126c-11eb-095e-39c2f6abc81d
# ╟─46b07b1c-126d-11eb-0966-6ff5ab87ac9d
# ╟─82579b90-106e-11eb-0018-4553c29e57a2
# ╠═eb1c0198-1246-11eb-1792-13d6458a0142
# ╠═34dc4b02-1248-11eb-26b2-5d2610cfeb41
# ╟─f46aeaf0-1246-11eb-17aa-2580fdbcfa5a
# ╠═e3120c18-1246-11eb-3bf4-7f4ac45856e0
# ╠═981af516-126d-11eb-2232-73d1423add70
# ╠═9fcc46d8-1248-11eb-3954-f5047790ef8d
# ╟─9fd2956a-1248-11eb-266d-f558cda55702
# ╠═ae65421e-1248-11eb-12be-af01d58e6cbc
# ╠═92854562-1249-11eb-0b81-156982df1284
# ╠═fbb4a9a4-1248-11eb-00e2-fd346f0056db
# ╠═a0045046-1248-11eb-13bd-8b8ad861b29a
# ╠═a03890d6-1248-11eb-37ee-85b0a5273e0c
# ╠═6d1ee93e-1103-11eb-140f-63fca63f8b06
# ╟─8261eb92-106e-11eb-2ccc-1348f232f5c3
# ╠═65e691e4-124a-11eb-38b1-b1732403aa3d
# ╟─6f4aa432-1103-11eb-13da-fdd9eefc7c86
# ╠═dbe9635a-124b-11eb-111d-fb611954db56
# ╟─ac320522-124b-11eb-1552-51c2adaf2521
# ╟─57090426-124e-11eb-0a17-1566ae96b7c2
# ╟─66192a74-124c-11eb-0c6a-d74aecb4c624
# ╟─70f0fe9c-124c-11eb-3dc6-e102e68673d9
# ╟─41b2262a-124e-11eb-2634-4385e2f3c6b6
# ╠═0dea1f70-124c-11eb-1593-e535ab21976c
# ╟─471cbd84-124c-11eb-356e-371d23011af5
# ╠═cdb5de86-124f-11eb-09c8-bd28710d1d44
# ╠═2fc55daa-124f-11eb-399e-659e59148ef5
# ╠═3a6ec2e4-124f-11eb-0f68-791475bab5cd
# ╟─2fcb93aa-124f-11eb-10de-55fced6f4b83
# ╠═b3045130-124f-11eb-3ae0-a96d6393257d
# ╠═a150fd60-124f-11eb-35d6-85104bcfd0fe
# ╠═c569a5d8-1267-11eb-392f-452de141161b
# ╠═e55d9c1e-1267-11eb-1b3c-5d772662518a
# ╠═a737990a-1251-11eb-1114-c57ceee75181
# ╠═65aa13fe-1266-11eb-03c2-5927dbeca36e
# ╠═6faf4074-1266-11eb-1a0a-991fc2e991bb
# ╠═a1575cb6-124f-11eb-1ecb-c33fd953b553
# ╠═826bb0dc-106e-11eb-29eb-03e7ddf9e4b5
# ╠═721079da-1103-11eb-2720-99754ea64c95
# ╠═e562be6e-126d-11eb-2b43-ff0580dc9588
# ╠═b94b7610-106d-11eb-2852-25337ce6ec3a
# ╟─10f67064-126e-11eb-3849-05cedcb340e6
# ╠═10853972-108f-11eb-36b5-57f656bc992e
# ╠═2187253c-108f-11eb-04a2-512ce3c17abf
# ╠═bcac8f60-1086-11eb-1756-bb2b19f7a25f
# ╠═e8ea71fc-108e-11eb-2f27-e984fde247d2
# ╠═0af07152-108f-11eb-2c0b-d96b54bfd3a5
# ╠═99a6a906-1086-11eb-3528-fb705460853e
# ╠═a10aad32-109a-11eb-1f62-a148b945d4f7
# ╠═6ed4ebaa-109a-11eb-10d4-0f51dcacbd8b
# ╠═04b79b02-1086-11eb-322b-cd995fa4196e
# ╠═e926013a-1080-11eb-24b8-034df3032883
# ╠═53dc7e0a-1081-11eb-39a3-c981848c2b1d
# ╠═15b60272-10ca-11eb-0a28-599ed78cf98a
# ╟─df42aa9e-10c9-11eb-2c19-2d7ce40a1c6c
# ╟─b94f9df8-106d-11eb-3be8-c5a1bb79d0d4
# ╟─b9586d66-106d-11eb-0204-a91c8f8355f7
# ╟─b9616f92-106d-11eb-1bd1-ede92a617fdb
# ╟─b969dbaa-106d-11eb-3e5a-81766a333c49
# ╟─b9728c20-106d-11eb-2286-4f670c229f3e
# ╟─b97afa48-106d-11eb-3c2c-cdee1d1cc6d7
# ╟─b98238ce-106d-11eb-1e39-f9eda5df76af
# ╟─b989e544-106d-11eb-3c53-3906c5c922fb
# ╟─05bfc716-106a-11eb-36cb-e7c488050d54
