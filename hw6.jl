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

# ╔═╡ 46caa70a-107c-11eb-1cd8-d5f432203eac
[sqrt(1)]

# ╔═╡ 3cd69418-10bb-11eb-2fb5-e93bac9e54a9
md"""
# 1D finite diff
"""

# ╔═╡ 2b79b698-10b9-11eb-3bde-53fc1c48d5f7
wavy(x) = .1x^3 - 1.6x^2 + 7x - 3

# ╔═╡ 327de976-10b9-11eb-1916-69ad75fc8dc4
zeroten = LinRange(0.0, 10.0, 300)

# ╔═╡ 01571b20-10ba-11eb-1c4a-292e427109b7
function tangent_line(f, a, h)
	slope = (f(a+h) - f(a)) / h
	value = f(a)
	
	x -> (x - a)*slope + value
end

# ╔═╡ abc54b82-10b9-11eb-1641-817e2f043d26
@bind a_finite_diff Slider(zeroten, default=4)

# ╔═╡ c9535ad6-10b9-11eb-0537-45f13931cd71
@bind log_h Slider(-16:0.01:.5, default=-.5)

# ╔═╡ 7495af52-10ba-11eb-245f-a98781ba123c
h_finite_diff = 10.0^log_h

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
end

# ╔═╡ 43df67bc-10bb-11eb-1cbd-cd962a01e3ee
md"""
# 1D "Euler"

By doing finite differences, we were able to approximate the derivative of a function:

$$f'(a) \simeq \frac{f(a + h) - f(a)}{h}$$

We can do something very similar to approximate the antiderivate of a function. Say that we only have a formula for the _slope_ ``f'``, then we can use this to compute ``f`` numerically!

By rearranging the equation above, we get:

$$f(a+h) \simeq hf'(a) + f(a)$$

Using this formula, we only need to know the _value_ ``f(a)`` and the _slope_ ``f'(a)`` of a function at ``a`` to get the value at ``a+h``. Doing this repeatedly can give us the value at ``a+2h``, at ``a+3h``, etc., all from one initial value ``f(a)``.
"""

# ╔═╡ d5a8bd48-10bf-11eb-2291-fdaaff56e4e6
wavy_deriv(x) = .3x^2 - 3.2x + 7

# ╔═╡ 0b4e8cdc-10bd-11eb-296c-d51dc242a372
@bind a_euler Slider(zeroten, default=4)

# ╔═╡ 70df9a48-10bb-11eb-0b95-95a224b45921
let
	slope = wavy_deriv(a_euler)
	
	p = plot(LinRange(a_euler - 0.2, a_euler + 0.2, 2), wavy, label="f(x)", lw=3)
	# p = plot()
	for y in -10:20
		plot!(p, [0,10], slope .* ([0,10] .- a_euler) .+ y, label=nothing, color="purple", opacity=.3)
	end
	
	vline!(p, [a_euler], color="red", label="a", linestyle=:dash)
	
	plot!(p, xlim=(0,10), ylim=(-2, 8))
end

# ╔═╡ 24037812-10bf-11eb-2653-e5c6cdfe95d9
function euler_integrate(fprime::Function, fa, a, h, N_steps)
	accumulate(0:(N_steps-1), init=fa) do prev, i
		prev + h*fprime(a + i*h)
	end
end

# ╔═╡ b74d94b8-10bf-11eb-38c1-9f39dfcb1096
euler_integrate(sqrt, 0, 1, .1, 100)

# ╔═╡ ab72fdbe-10be-11eb-3b33-eb4ab41730d6
@bind N_euler Slider(2:40)

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
end

# ╔═╡ 518fb3aa-106e-11eb-0fcd-31091a8f12db
md"""
## **Exercise 1:** _Simulating the SIR differential equations_

Recall from lectures that the ordinary differential equations (ODEs) for the SIR model are as follows:

$$\begin{align*}
\dot{s} &= - \beta s \, i \\
\dot{i} &= + \beta s \, i - \gamma i \\
\dot{r} &= +\gamma i
\end{align*}$$

where ``\dot{s} := \frac{ds}{dt}`` is the derivative of $s$ with respect to time. 
Recall that $s$ denotes the *proportion* (fraction) of the population that is susceptible.

We will use the simplest possible method to simulate these, namely the **Euler method**. The Euler method is *not* a good method to solve ODEs accurately. But for our purposes it is good enough.

For an ODE with a single variable, $\dot{x} = f(x)$, the Euler method takes steps of length $h$ in time. If we have an approximation $x_n$ at time $t_n$ it gives us an approximation for the value $x_{n+1}$ of $x$ at time $t_{n+1} = t_n + h$ as

$$x_{n+1} = x_n + h \, f(x_n)$$

In the case of several functions $s$, $i$ and $r$, we must use a rule like this for *each* of the differential equations within a *single* time step to get new values for *each* of $s$, $i$ and $r$ at the end of the time step in terms of the values at the start of the time step. In Julia we can write `s` for the old value and `s_new` for the new value.

1. Implement a function `euler_SIR(β, γ, s0, i0, r0, h, T)` that integrates these equations with the given parameter values and initial values, with a step size $h$ up to a final time $T$.

    It should return vectors of the trajectory of $s$, $i$ and $r$, as well as the collection of times at which they are calculated.

2. Run the SIR model with $\beta = 0.1$, $\gamma = 0.05$, and $s_0 = 0.99$, $i_0 = 0.01$ and $r_0 = 0$ for a time $T = 300$ with time step ("step size") $h=0.1$. 

3. Plot $s$, $i$ and $r$ as a function of time $t$.

3. Do you see an epidemic outbreak (i.e. a rapid growth in number of infected individuals, followed by a decline)? What happens after a long time? Does everybody get infected?

4. Make an interactive visualization in which vary $\beta$ and $\gamma$. What relation should $\beta$ and $\gamma$ have for an epidemic outbreak to occur?

"""

# ╔═╡ 82539bbe-106e-11eb-0e9e-170dfa6a7dad
md"""

## **Exercise 2:** _Numerical derivatives_

For fitting we need optimization, and for optimization we will use *derivatives* (rates of change). 
In this exercise we will see one method for calculating derivatives numerically.

1. Define a function `deriv` that takes a function `f`, representing a function $f: \mathbb{R} \to \mathbb{R}$, a number $a$ and an optional $h$ with default value 0.001, and calculates the **finite-difference approximation**

    $$f'(a) \simeq \frac{f(a + h) - f(a)}{h}$$

    of the derivative $f'(a)$.


FONSI: we do the 1D case as the first thing of this homework, it helps to introduce the euler method. In this exercise we do the directional derivative

$$f'_v(a) \simeq \frac{f(a + hv) - f(a)}{h}$$

with ``v = (1,0,0)`` etc

2. Write a function `tangent_line` that calculates the tangent line to $f$ at a point $a$. It should also accept a value of $x$ at which it will calculate the height of the tangent line. Use the function `deriv` to calculate $f'(a)$. FONSI : should return a **function** x -> slope(x-a) + value

3. Make an interactive visualization of the function $f(x) = x^3 - 2x$, showing the tangent line at a point $a$ and allowing you to vary $a$.
Make sure that the line is indeed visually tangent to the graph!

FONSI: we should make it ourselves

4. Write functions `∂x(f, a, b)` and `∂y(f, a, b)` that calculate the **partial derivatives** $\frac{\partial f}{\partial x}$ and $\frac{\partial f}{\partial y}$ at $(a, b)$ of a function $f : \mathbb{R}^2 \to \mathbb{R}$ (i.e. a function that takes two real numbers and returns one real).

    Recall that $\frac{\partial f}{\partial x}$  is the derivative of the single-variable function $g(x) := f(x, b)$ obtained by fixing the value of $y$ to $b$.

    You should use **anonymous functions** for this. These have the form `x -> x^2`, meaning "the function that sends $x$ to $x^2$".

5. Write a function `gradient(f, a, b)` that calculates the **gradient** of a function $f$ at the point $(a, b)$, given by the vector $\nabla f(a, b) := (\frac{\partial f}{\partial x}(a, b), \frac{\partial f}{\partial y}(a, b))$.


"""

# ╔═╡ 82579b90-106e-11eb-0018-4553c29e57a2
md"""
## **Exercise 3:** _Minimisation using gradient descent_

In this exercise we will use **gradient descent** to find local **minima** of (smooth enough) functions.

To do so we will think of a function as a hill. To find a minimum we should "roll down the hill".



1. Write a function `gradient_descent_1d(f, x0)` to minimize a 1D function, i.e. a function $f: \mathbb{R} \to \mathbb{R}$.

    To do so we notice that the derivative tells us the direction in which the function *increases*. So we take steps in the *opposite* direction, of a small size $\eta$ (eta).

    Use this to write the function starting from the point `x0` and using your function `deriv` to approximate the derivative.

    Take a reasonably large number of steps, say 100, with $\eta = 0.01$.

    What would be a better way to decide when to end the function?

2. Write an interactive visualization showing the progress of gradient descent on the function

    $$f(x) = x^{4} +3x^{3} - 3x + 5.$$

    Make sure that it does indeed get close to a local minimum.

    How can you find different local minima?

3.  Write a function `gradient_descent_2d(f, x0, y0)` that does the same for functions $f(x, y)$ of two variables.

    Multivariable calculus tells us that the gradient $\nabla f(a, b)$ at a point $(a, b)$ is the direction in which the function *increases* the fastest. So again we should take a small step in the *opposite* direction. Note that the gradient is a *vector* which tells us which direction to move in the plane $(a, b)$.

4. Apply this to the **Himmelblau function** $f(x, y) := (x^2 + y - 11)^2 + (x + y^2 - 7)^2$. Visualize the trajectory using both contours (`contour` function) and a 2D surface (`surface` function). [Use e.g. `surface(-2:0.01:2, -2:0.01:2, f)`]

    Can you find different minima?

    You can try to install the `PlotlyJS` package and activate it with `using Plots; plotlyjs()`. This will / should give an *interactive* 3D plot. (But don't spend time on this if it doesn't immediately work.) (FONS: this wont work i think. WGLMakie is an alternative) But experimenting with plotting packages shouldnt be part of the homework

"""

# ╔═╡ 8261eb92-106e-11eb-2ccc-1348f232f5c3
md"""
## **Exercise 4:** _Learning parameter values_

In this exercise we will apply gradient descent to fit a simple function $y = f_{a, b}(x)$ to some data given as pairs $(x_i, y_i)$. Here $a$ and $b$ are **parameters** that appear in the form of the function $f$. We want to find the parameters that provide the **best fit**, i.e. the version $f_{a, b}$ of the function that is closest to the data when we vary $a$ and $b$.

To do so we need to define what "best" means. We will define a measure of the distance between the function and the data, given by a **loss function**, which itself depends on the values of $a$ and $b$. Then we will *minimize* the loss function over $a$ and $b$ to find those values that minimize this distance, and hence are "best" in this precise sense.

The iterative procedure by which we gradually adjust the parameter values to improve the loss function is often called **machine learning** or just **learning**, since the computer is "discovering" information in a gradual way, which is supposed to remind us of how humans learn. [Hint: This is not how humans learn.]


1. Load the data from the file `some_data.csv` into vectors `xs` and `ys`.

2. Plot the data. What does it remind you of?

3. Let's try to fit a gaussian (normal) distribution. Its PDF with mean $\mu$ and standard deviation $\sigma$ is

    $$f_{\mu, \sigma}(x) := \frac{1}{\sigma \sqrt{2 \pi}}\exp \left[- \frac{(x - \mu)^2}{2 \sigma^2} \right]$$

    Define this function as `f(x, μ, σ)`.


4. Define a **loss function** to measure the "distance" between the actual data and the function. It will depend on the values of $\mu$ and $\sigma$ that you choose:

    $$\mathcal{L}(\mu, \sigma) := \sum_i [f_{\mu, \sigma}(x_i) - y_i]^2$$

5. Use your `gradient_descent` function to find a local minimum of $\mathcal{L}$, starting with initial values $\mu = 0$ and $\sigma = 1$.

    What are the final values for $\mu$ and $\sigma$ that you find?

6. Modify the gradient descent function to store the whole history of the values of $\mu$ and $\sigma$ that it went through.

    Make an interactive visualization showing how the resulting curve $f_{\mu, \sigma}$ evolves over time, compared to the original data.

    ("Time" here corresponds to the iterations in the gradient descent function.)

"""

# ╔═╡ 826bb0dc-106e-11eb-29eb-03e7ddf9e4b5
md"""

## **Exercise 5:** _Putting it all together — fitting an SIR model to data_

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
	1    -.2]

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

# ╔═╡ 34cae8c6-109a-11eb-381c-f74fe8f52e21
# x0_ref = Ref([0.5, 0.5])

# ╔═╡ 4a40557c-1083-11eb-3a82-31cfed3de047
old = []

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

# ╔═╡ ad5b94c6-1071-11eb-25f6-bf800b21b265
let
	previous = if @isdefined(pos)
		pos
	else
		100
	end
	
	x = previous * (1:10)
	
	c = """
	<script id="helloaza">
	
	const x = $(JSON.json(x))

	const svg = this == null ? DOM.svg(600,200) : this
	const s = this == null ? d3.select(svg) : this.s
	
	svg.value = $(previous)
	
	const down_handler =(e) => {
		svg.value = e.clientX - svg.getBoundingClientRect().left
		svg.dispatchEvent(new CustomEvent("input", {}))
		console.log(svg.value)
	}
	
	svg.addEventListener("pointerdown", down_handler)
	invalidation.then(() => svg.removeEventListener("pointerdown", down_handler))
	
	s.selectAll("circle")
		.data(x)
		.join("circle")
		.transition()
		.duration(300)
		.attr("cx", d => d)
		.attr("cy", 100)
		.attr("r", 10)
		.attr("fill", "gray")

	const output = svg
	output.s = s
	return output
	</script>

	"""
	with_d3_libs(@bind pos BondDefault(HTML(c), previous))
end

# ╔═╡ 4ce12694-1083-11eb-2aa1-17ad10bbe366
push!(old, pos)

# ╔═╡ 847b089a-1083-11eb-04d6-e12a4385a8fa
pos

# ╔═╡ b94f9df8-106d-11eb-3be8-c5a1bb79d0d4
md"## Function library

Just some helper functions used in the notebook."

# ╔═╡ b9586d66-106d-11eb-0204-a91c8f8355f7
hint(text) = Markdown.MD(Markdown.Admonition("hint", "Hint", [text]))

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

# ╔═╡ b989e544-106d-11eb-3c53-3906c5c922fb
not_defined(variable_name) = Markdown.MD(Markdown.Admonition("danger", "Oopsie!", [md"Make sure that you define a variable called **$(Markdown.Code(string(variable_name)))**"]))

# ╔═╡ 05bfc716-106a-11eb-36cb-e7c488050d54
TODO = html"<h1 style='display: inline; color: purple;'>TODO</h1>"

# ╔═╡ acbb9a56-106d-11eb-115b-7d067adb302c


# ╔═╡ Cell order:
# ╟─048890ee-106a-11eb-1a81-5744150543e8
# ╟─0565af4c-106a-11eb-0d38-2fb84493d86f
# ╟─056ed7f2-106a-11eb-3543-31a5cb560e80
# ╟─0579e962-106a-11eb-26b5-2160f461f4cc
# ╠═0587db1c-106a-11eb-0560-c3d53c516805
# ╟─05976f0c-106a-11eb-03a4-0febbc18fae8
# ╠═05b01f6e-106a-11eb-2a88-5f523fafe433
# ╠═0d191540-106e-11eb-1f20-bf72a75fb650
# ╠═46caa70a-107c-11eb-1cd8-d5f432203eac
# ╟─3cd69418-10bb-11eb-2fb5-e93bac9e54a9
# ╠═2b79b698-10b9-11eb-3bde-53fc1c48d5f7
# ╠═327de976-10b9-11eb-1916-69ad75fc8dc4
# ╠═01571b20-10ba-11eb-1c4a-292e427109b7
# ╠═abc54b82-10b9-11eb-1641-817e2f043d26
# ╠═3d44c264-10b9-11eb-0895-dbfc22ba0c37
# ╟─c9535ad6-10b9-11eb-0537-45f13931cd71
# ╟─7495af52-10ba-11eb-245f-a98781ba123c
# ╟─43df67bc-10bb-11eb-1cbd-cd962a01e3ee
# ╠═d5a8bd48-10bf-11eb-2291-fdaaff56e4e6
# ╠═0b4e8cdc-10bd-11eb-296c-d51dc242a372
# ╠═70df9a48-10bb-11eb-0b95-95a224b45921
# ╠═24037812-10bf-11eb-2653-e5c6cdfe95d9
# ╠═b74d94b8-10bf-11eb-38c1-9f39dfcb1096
# ╠═ab72fdbe-10be-11eb-3b33-eb4ab41730d6
# ╟─990236e0-10be-11eb-333a-d3080a224d34
# ╟─518fb3aa-106e-11eb-0fcd-31091a8f12db
# ╟─82539bbe-106e-11eb-0e9e-170dfa6a7dad
# ╟─82579b90-106e-11eb-0018-4553c29e57a2
# ╟─8261eb92-106e-11eb-2ccc-1348f232f5c3
# ╟─826bb0dc-106e-11eb-29eb-03e7ddf9e4b5
# ╟─b94b7610-106d-11eb-2852-25337ce6ec3a
# ╠═10853972-108f-11eb-36b5-57f656bc992e
# ╠═2187253c-108f-11eb-04a2-512ce3c17abf
# ╠═bcac8f60-1086-11eb-1756-bb2b19f7a25f
# ╠═e8ea71fc-108e-11eb-2f27-e984fde247d2
# ╠═0af07152-108f-11eb-2c0b-d96b54bfd3a5
# ╠═99a6a906-1086-11eb-3528-fb705460853e
# ╠═a10aad32-109a-11eb-1f62-a148b945d4f7
# ╠═6ed4ebaa-109a-11eb-10d4-0f51dcacbd8b
# ╠═34cae8c6-109a-11eb-381c-f74fe8f52e21
# ╠═04b79b02-1086-11eb-322b-cd995fa4196e
# ╟─ad5b94c6-1071-11eb-25f6-bf800b21b265
# ╠═4ce12694-1083-11eb-2aa1-17ad10bbe366
# ╠═847b089a-1083-11eb-04d6-e12a4385a8fa
# ╠═4a40557c-1083-11eb-3a82-31cfed3de047
# ╠═e926013a-1080-11eb-24b8-034df3032883
# ╠═53dc7e0a-1081-11eb-39a3-c981848c2b1d
# ╟─b94f9df8-106d-11eb-3be8-c5a1bb79d0d4
# ╟─b9586d66-106d-11eb-0204-a91c8f8355f7
# ╟─b9616f92-106d-11eb-1bd1-ede92a617fdb
# ╟─b969dbaa-106d-11eb-3e5a-81766a333c49
# ╟─b9728c20-106d-11eb-2286-4f670c229f3e
# ╟─b97afa48-106d-11eb-3c2c-cdee1d1cc6d7
# ╟─b98238ce-106d-11eb-1e39-f9eda5df76af
# ╟─b989e544-106d-11eb-3c53-3906c5c922fb
# ╠═05bfc716-106a-11eb-36cb-e7c488050d54
# ╠═acbb9a56-106d-11eb-115b-7d067adb302c
