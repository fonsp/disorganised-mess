### A Pluto.jl notebook ###
# v0.11.14

using Markdown
using InteractiveUtils

# ╔═╡ 12cc2940-0403-11eb-19a7-bb570de58f6f
begin
	using Pkg
	Pkg.activate(mktempdir())
end

# ╔═╡ 15187690-0403-11eb-2dfd-fd924faa3513
begin
	Pkg.add([
			"Plots",
			"PlutoUI",
			])

	using Plots
	using PlutoUI
end

# ╔═╡ 01341648-0403-11eb-2212-db450c299f35
md"_homework 4, version 0_"

# ╔═╡ 06f30b2a-0403-11eb-0f05-8badebe1011d
md"""

# **Homework 4**: _Epidemic modeling I_
`18.S191`, fall 2020

This notebook contains _built-in, live answer checks_! In some exercises you will see a coloured box, which runs a test case on your code, and provides feedback based on the result. Simply edit the code, run it, and the check runs again.

_For MIT students:_ there will also be some additional (secret) test cases that will be run as part of the grading process, and we will look at your notebook and write comments.

Feel free to ask questions!
"""

# ╔═╡ 095cbf46-0403-11eb-0c37-35de9562cebc
# edit the code below to set your name and kerberos ID (i.e. email without @mit.edu)

student = (name = "Jazzy Doe", kerberos_id = "jazz")

# you might need to wait until all other cells in this notebook have completed running. 
# scroll around the page to see what's up

# ╔═╡ 03a85970-0403-11eb-334a-812b59c0905b
md"""

Submission by: **_$(student.name)_** ($(student.kerberos_id)@mit.edu)
"""

# ╔═╡ 107e65a4-0403-11eb-0c14-37d8d828b469
md"_Let's create a package environment:_"

# ╔═╡ 1d3356c4-0403-11eb-0f48-01b5eb14a585
html"""
<iframe width="100%" height="450px" src="https://www.youtube.com/embed/ConoBmjlivs?rel=0" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
""";

# ╔═╡ df8547b4-0400-11eb-07c6-fb370b61c2b6
md"""
## **Exercise 1:** _Modelling recovery_

In this exercise we will investigate a simple stochastic (probabilistic) model of recovery from an infection and
the time $\tau$ needed to recover. Although this model can be easily studied analytically using probability theory, we will instead use computational methods. [If you know about this distribution already, try to ignore what you know about it!]

In this model, an individual who is infected has a constant probability $p$ to recover each day. If they recover on day $n$ then $\tau$ takes the value $n$. Each time we run a new experiment $\tau$ will take on different values, so $\tau$ is a (discrete) random variable. We thus need to study statistical properties of $\tau$, such as its mean and its probability distribution.

#### Exercise 1.1 - _Probability distributions_

👉 Define the function `bernoulli(p)` from lectures. Recall that this generates `true` with probability $p$ and `false` with probability $(1 - p)$.

"""

# ╔═╡ d8797684-0414-11eb-1869-5b1e2c469011
function bernoulli(p::Number)
	rand() < p
end

# ╔═╡ 02b0c2fc-0415-11eb-2b40-7bca8ea4eef9
# function bernoulli(p::Number)
	
	
# 	return missing
# end

# ╔═╡ 76d117d4-0403-11eb-05d2-c5ea47d06f43
md"""
👉 Write a function `recovery_time(p)` that returns the time taken until the person recovers. 
"""

# ╔═╡ 6d5c6a84-0415-11eb-3fdf-9355200cb520
function recovery_time(p)
	if p ≤ 0
		throw(ArgumentError("p must be positive: p = 0 cannot result in a recovery"))
	end
	
	recovered = bernoulli(p)
	if recovered
		0
	else
		1 + recovery_time(p)
	end
end

# ╔═╡ d57c6a5a-041b-11eb-3ab4-774a2d45a891
# function recovery_time(p)
# 	if p ≤ 0
# 		throw(ArgumentError("p must be positive: p = 0 cannot result in a recovery"))
# 	end
# 	
# 	# Your code here. See the comment below about the p ≤ 0 case.
# 	return missing
# end

# ╔═╡ 6db6c894-0415-11eb-305a-c75b119d89e9
md"""
We should always be aware of special cases (sometimes called "boundary conditions"). Make sure *not* to run the code with $p=0$! What would happen in that case? Your code should check for this and throw an `ArgumentError` as follows:

```julia
throw(ArgumentError("..."))  
```

with a suitable error message.
    
"""

# ╔═╡ 6de37d6c-0415-11eb-1b05-85ac820016c7
md"""
👉 What happens for $p=1$? 
"""

# ╔═╡ 73047bba-0416-11eb-1047-23e9c3dbde05
interpretation_of_p_equals_one = md"""
blablabla
"""

# ╔═╡ 76f62d64-0403-11eb-27e2-3de58366b619
md"""
👉 Write a function `do_experiment(p, N)` that runs the function `recovery_time` `N` times and collects the results into a vector.
"""

# ╔═╡ cdaade9c-0416-11eb-0550-7b5b3d33e240
function do_experiment(p, N)
	map(1:N) do _
		recovery_time(p)
	end
end

# ╔═╡ c5c7cb86-041b-11eb-3360-45463105f3c9
# function do_experiment(p, N)
	
# 	return missing
# end

# ╔═╡ d8abd2f6-0416-11eb-1c2a-f9157d9760a7
small_experiment = do_experiment(0.5, 20)

# ╔═╡ 771c8f0c-0403-11eb-097e-ab24d0714ad5
md"""
👉 Write a function `frequencies(data)` that calculates and returns the frequencies (i.e. probability distribution) of input data.

The input will be an array of integers, **with duplicates**, and the result will be a dictionary that maps each occured value to its frequency in the data.

For example,
```julia
frequencies([7, 8, 9, 7])
```
should give
```julia
Dict(
	7 => 0.5, 
	8 => 0.25, 
	9 => 0.25
)
```

As with any probability distribution, it should be normalised to $1$, in the sense that the *total* probability should be $1$.
"""

# ╔═╡ aa6673d4-0417-11eb-32cc-79560896c195
function frequencies(values)
	result = Dict()
	for x in values
		result[x] = get(result, x, 0) + 1/length(values)
	end
	result
end

# ╔═╡ 105d347e-041c-11eb-2fc8-1d9e5eda2be0
# function frequencies(values)
	
# 	return missing
# end

# ╔═╡ 1ca7a8c2-041a-11eb-146a-15b8cdeaea72
frequencies(small_experiment)

# ╔═╡ 77428072-0403-11eb-0068-81e3728f2ebe
md"""
Let's run an experiment with $p=0.25$ and $N=10,000$.
"""

# ╔═╡ 4b3ec86c-0419-11eb-26fd-cbbfdf19afa8
large_experiment = do_experiment(0.25, 10_000) 
# (10_000 is just 10000 but easier to read)

# ╔═╡ 6c7891f2-0419-11eb-1137-e7ec60266b26
frequencies(large_experiment)

# ╔═╡ dc784864-0430-11eb-1478-d1153e017310
md"""
The frequencies dictionary is difficult to interpret on its own, so instead, we will **plot** it, i.e. plot $P(\tau = n)$ against $n$, where $n$ is the recovery time.


"""

# ╔═╡ 45caf17c-041a-11eb-1e14-a98b934da463
"""
	frequencies_plot(data::Vector)

Compute the frequencies of the given data, and return a _bar plot_ of those.
"""
function frequencies_plot(data::Vector)
	freqs = frequencies(data)
	
	# we turn the dictionary into a vector of pairs (same data, different structure)
	pairs = collect(freqs)
	# we create the bar plot
	p = bar(first.(pairs), last.(pairs), label=nothing)
	# and return the plot
	return p
end

# ╔═╡ 2a6ab940-0430-11eb-204b-c58dc521ae36
frequencies_plot(large_experiment)

# ╔═╡ f3f81172-041c-11eb-2b9b-e99b7b9400ed
md"""
> ### Note about plotting
> 
> Plots.jl has an interesting property: a plot is an object, not an action. Functions like `plot`, `bar`, `histogram` don't draw anything on your screen - they just return a `Plots.Plot`. This is a struct that contains the _description_ of a plot (what data should be plotted in what way?), not the _picture_.
> 
> So a Pluto cell with a single line, `plot(1:10)`, will show a plot, because the _result_ of the function `plot` is a `Plot` object, and Pluto always shows the result of a cell.
>
> ##### Modifying plots
> Nice plots are often formed by overlaying multiple plots. In Plots.jl, this is done using the **modifying functions**: `plot!`, `bar!`, `vline!`, etc. These take an extra (first) argument: a previous plot to modify.
> 
> For example, to plot the `sin` and `cos` functions in the same view, we do:
> ```julia
> function sin_cos_plot()
>     T = 0.0:0.01:5.0
>     
>     original = plot(T, sin.(T))
>     plot!(original, T, cos.(T))
>
>     return original
> end
> ```
"""

# ╔═╡ 823364ce-041c-11eb-2467-7ffa4f751527
let
	base = frequencies_plot(large_experiment)
	vline!(base, [maximum(large_experiment)], label="maximum")
end

# ╔═╡ c68ebd1e-0433-11eb-048b-4b6900f79970
md"""
_(`let` can group multiple expressions together into one, and variables defined inside of it are **local**: they don't affect code outside of the block. So like `begin`, it is just a block of code (like brackets in mathematics), but like `function`, it has a local variable scope.)_
"""

# ╔═╡ 7768a2dc-0403-11eb-39b7-fd660dc952fe
md"""
6. Calculate the mean recovery time and add it to the plot using the `vline!()` function and the `ls=:dash` argument to make a dashed line.

    [`vline!` takes a *vector* of values at which you want to draw vertical lines.]

"""

# ╔═╡ 778ec25c-0403-11eb-3146-1d11c294bb1f
md"""
7. What shape does the distribution seem to have? Can you verify that by using one or more log scales? Feel free to increase `N` (while being careful not to overstretch your computing power with these kinds of calculations!).

"""

# ╔═╡ 77b54c10-0403-11eb-16ad-65374d29a817
md"""
👉 Write an interactive visualization that draws the histogram and mean for $p$ between $0.01$ (not $0$!) and $1$, and $N$ between $1$ and $100,000$, say.
"""

# ╔═╡ bb63f3cc-042f-11eb-04ff-a128aec3c378


# ╔═╡ bb8aeb58-042f-11eb-18b8-f995631df619
md"""
As you separately vary $p$ and $N$, what do you observe about the **mean** in each case? Does that make sense?
"""

# ╔═╡ 77db111e-0403-11eb-2dea-4b42ceed65d6
md"""
👉 Use $N = 10,000$ to calculate the mean time $\langle \tau(p) \rangle$ to recover as a function of $p$ between $0.001$ and $1$ (say). Plot this relationship.

"""

# ╔═╡ 7335de44-042f-11eb-2873-8bceef722432


# ╔═╡ 78013f76-0403-11eb-3855-dd4e8ba271c3
md"""
👉 By looking at the shape of the graph, guess the functional form $\langle \tau(p) \rangle = f(p)$. Use this guess to plot the data in a different way to obtain a straight line, and hence verify your guess. (If you didn't quite get it right, record your different attempts and try again!)
"""

# ╔═╡ 97804ff0-042f-11eb-262f-5d9072a80337


# ╔═╡ 61789646-0403-11eb-0042-f3b8308f11ba
md"""
## **Exercise 2:** _Agent-based model for an epidemic outbreak -- types_

In this and the following exercises we will develop a simple stochastic model for combined infection and recovery in a population, which may exhibit an **epidemic outbreak** (i.e. a large spike in the number of infectious people).
The population is **well mixed**, i.e. everyone is in contact with everyone else.
[An example of this would be a small school or university in which people are
constantly moving around and interacting with each other.]

The model is an **individual-based** or **agent-based** model: 
we explicitly keep track of each individual, or **agent**, in the population and their
infection status. For the moment we will not keep track of their position in space;
we will just assume that there is some mechanism, not included in the model, by which they interact with other individuals.

Each agent will have its own **internal state**, modelling its infection status, namely "susceptible", "infectious" or "recovered". We would like to code these as values `S`, `I` and `R`, respectively. One way to do this is using an [**enumerated type**](https://en.wikipedia.org/wiki/Enumerated_type) or **enum**. Variables of this type can take only a pre-defined set of values; the Julia syntax is as follows:
"""

# ╔═╡ 26f84600-041d-11eb-1856-b12a3e5c1dc7
@enum InfectionStatus S I R

# ╔═╡ 271ec5f0-041d-11eb-041b-db46ec1465e0
md"""
We have just defined a new type `InfectionStatus`, as well as names `S`, `I` and `R` that are the (only) possible values that a variable of this type can take.

👉 Define a variable `test_status` whose value is `S`. 
"""

# ╔═╡ 7f4e121c-041d-11eb-0dff-cd0cbfdfd606
test_status = missing

# ╔═╡ 7f744644-041d-11eb-08a0-3719cc0adeb7
md"""
👉 Use the `typeof` function to find the type of `test_status`.
"""

# ╔═╡ 88c53208-041d-11eb-3b1e-31b57ba99f05


# ╔═╡ 847d0fc2-041d-11eb-2864-79066e223b45
md"""
👉 Convert `x` to an integer using the `Integer` function. What value does it have? What values do `I` and `R` have?
"""

# ╔═╡ 860790fc-0403-11eb-2f2e-355f77dcc7af
md"""
2. For each agent we want to keep track of its infection status and the number of *other* agents that it infects during the simulation. A good solution for this is to define a *new type* `Agent` to hold all of the information for one agent, as follows:
"""

# ╔═╡ ae4ac4b4-041f-11eb-14f5-1bcde35d18f2
mutable struct Agent
	status::InfectionStatus
	num_infected::Int64
end

# ╔═╡ ae70625a-041f-11eb-3082-0753419d6d57
md"""
When you define a new type like this, Julia automatically defines one or more **constructors**, which are methods of a generic function with the *same name* as the type. These are used to create objects of that type. 

👉 Use the `methods` function to check how many constructors are pre-defined for the `Agent` type.
"""

# ╔═╡ 18758408-0424-11eb-17fc-2bb4088b03ba
methods(Agent)

# ╔═╡ 189cae1e-0424-11eb-2666-65bf297d8bdd
md"""
👉 Create an agent `test_agent` with status `S` and `num_infected` equal to 0.
"""

# ╔═╡ 18d308c4-0424-11eb-176d-49feec6889cf
test_agent = missing

# ╔═╡ 190deebc-0424-11eb-19fe-615997093e14
md"""
The `Agent` struct currently has TODODODO

👉 Define a new constructor (i.e. a new method for the function) that takes no arguments and creates an `Agent` with status `S` and number infected 0, by calling one of the default constructors that Julia creates. This new method lives *outside* (not inside) the definition of the `struct`. [It is called an **outer constructor**.]. Check that the new method works correctly.

(iv) How many methods does the constructor have now?

"""

# ╔═╡ 8631a536-0403-11eb-0379-bb2e56927727
md"""
👉 Write functions `set_status!(a)` and `set_num_infected!(a)` which modify the respective fields of an `Agent`. Check that they work. [Note the bang ("`!`") at the end of the function names to signify that these functions *modify* their argument.]

"""

# ╔═╡ 98beb336-0425-11eb-3886-4f8cfd210288
function set_status!(a::Agent)
	
end

# ╔═╡ 866299e8-0403-11eb-085d-2b93459cc141
md"""
👉 We will also need functions `is_susceptible` and `is_infected` that check if a given agent is in those respective states.

"""

# ╔═╡ 9a837b52-0425-11eb-231f-a74405ff6e23
function is_susceptible(agent::Agent)
	
	return missing
end

# ╔═╡ a8dd5cae-0425-11eb-119c-bfcbf832d695
function is_infected(agent::Agent)
	
	return missing
end

# ╔═╡ 8692bf42-0403-11eb-191f-b7d08895274f
md"""
👉 Write a function `generate_agents(N)` that returns a vector of `N` freshly created `Agent`s. They should all be initially susceptible, except one, chosen at random (i.e. uniformly), who is infectious.

"""

# ╔═╡ 6d480cf0-0425-11eb-18a9-1737455371d7
function generate_agents(N::Integer)
	
	return missing
end

# ╔═╡ 86d98d0a-0403-11eb-215b-c58ad721a90b
md"""
We will also need types representing different infections. 

👉 Define an (immutable) `struct` called `InfectionRecovery` with parameters `p_infection` and `p_recovery`. You may make it a subtype of an abstract `AbstractInfection` type if you wish (but this is not strictly necessary). TODO

"""

# ╔═╡ 223933a4-042c-11eb-10d3-852229f25a35
abstract type AbstractInfection end

# ╔═╡ 1a654bdc-0421-11eb-2c38-7d35060e2565
struct InfectionRecovery <: AbstractInfection
	p_infection
	p_recovery
end

# ╔═╡ 619c8a10-0403-11eb-2e89-8b0974fb01d0
md"""
## **Exercise 3:** _Agent-based model for an epidemic outbreak --  Monte Carlo simulation_

In this exercise we will build on Exercise 2 to write a Monte Carlo simulation of how an infection propagates in a population.

Make sure to re-use the functions that we have already written, and introduce new ones if they are helpful! Short functions make it easier to understand what the function does and build up new functionality piece by piece.

You may not use any global variables inside the functions: Each function must accept as arguments all the information it requires to carry out its task. You need to think carefully about what the information each function requires.

👉 Write a function `step!` that takes a vector `agents` of `Agent`s and an `infection` of type `InfectionRecovery`.  It implements a single step of the infection dynamics by modifying `agents` as follows: 

- Choose a random agent. Each of the following steps deals with that agent.
- If it is not infectious then nothing happens.
- If it is infectious then a function `infect!` is called with this agent, another random agent, and the `infection` object; it infects the other agent with the given infection probability if the other agent is susceptible. If it successfully infects the other agent, its `num_infected` record must be updated.
- It recovers with the relevant probability. This should be in a function `recover!`.

$(html"<span id=stepfunction></span>")
"""

# ╔═╡ 2ade2694-0425-11eb-2fb2-390da43d9695
function step!(agents::Vector{Agent}, infection::InfectionRecovery)
	
	
end

# ╔═╡ a336f36a-042c-11eb-3e1b-2df0ee60936d
let
	original = generate_agents(5)
	TODOTODO
end

# ╔═╡ 955321de-0403-11eb-04ce-fb1670dfbb9e
md"""
👉 Write a function `sweep!`. It runs `step!` $N$ times, where $N$ is the number of agents. Thus each agent acts, on average, once per sweep; a sweep is thus the unit of time in our Monte Carlo simulation.
"""

# ╔═╡ 32cea7ba-0429-11eb-06bc-a5f4ae3ffe37
function sweep!(agents::Vector{Agent}, infection::AbstractInfection)
	
end

# ╔═╡ 95771ce2-0403-11eb-3056-f1dc3a8b7ec3
md"""
👉 Write a function `simulation` that does the following:

1. Generate the $N$ agents.

2. Run `sweep!` a number $T$ of times. Calculate and store the total number of agents with each status at each step in variables `Ss`, `Is` and `Rs`.

3. Return the vectors `Ss`, `Is` and `Rs`, as well as the probability distribution of `num_infected` over the whole population as outputs of the function.
"""

# ╔═╡ 3d3b672c-0426-11eb-0a36-153ce3c276b9
function simulation(N::Integer, infection::AbstractInfection, T::Integer)
	
	return missing
end

# ╔═╡ 959ef526-0403-11eb-07d1-192e7e83c942
md"""
👉 Run your simulation 50 times with $N=100$ with $p_\text{infection} = 0.02$ and $T = 1000$. Store the data in vectors `all_Is` etc.; note that these will be vectors of vectors!

👉 Plot the evolution of the number of $I$ individuals as a function of time for each of the 50 graphs on the same plot using transparency [`alpha=0.5` inside the plot command].

👉 Calculate the mean trajectory using the `mean` function applied to `all_Is`. Add it to the plot using a heavier line [`lw=3` for "linewidth"].

"""

# ╔═╡ 95c598d4-0403-11eb-2328-0175ed564915
md"""
👉 Plot the means of $S$, $I$ and $R$ as a function of time on a single graph.
    Allow $p_\text{infection}$ and $T$ to be changed interactively and find parameter values for which you observe an epidemic outbreak.

"""

# ╔═╡ 2e21c38a-0435-11eb-1fa3-65acce73108d


# ╔═╡ 95eb9f88-0403-11eb-155b-7b2d3a07cff0
md"""
👉 Calculate the standard deviation $\sigma$ of $I$ at each step. (The result should thus be a *vector*.) Add this to the plot using **error bars**, using the option `yerr=σ` in the plot command; use transparency.

This should confirm that the distribution of $I$ at each step is pretty wide!
"""

# ╔═╡ 287ee7aa-0435-11eb-0ca3-951dbbe69404


# ╔═╡ 9611ca24-0403-11eb-3582-b7e3bb243e62
md"""
👉 Plot the probability distribution of `num_infected`. Does it have a recognisable shape? (Feel free to increase the number of agents in order to get better statistics.)

"""

# ╔═╡ 26e2978e-0435-11eb-0d61-25f552d2771e


# ╔═╡ 9635c944-0403-11eb-3982-4df509f6a556
md"""
👉 What are three *simple* ways in which you could characterise the magnitude (size) of the epidemic outbreak? Find approximate values of these quantities for one of the runs of your simulation.

"""

# ╔═╡ 4ad11052-042c-11eb-3643-8b2b3e1269bc


# ╔═╡ 61c00724-0403-11eb-228d-17c11670e5d1
md"""

## Exercise 4: Reinfection

In this exercise we will *re-use* our simulation infrastructure to study the dynamics of a different type of infection: there is no immunity, and hence no "recovery" rather, susceptible individuals may now be **re-infected** 

1. Make a new infection type `Reinfection`. This has the *same* two fields, `p_infection` and `p_recovery`. However, "recovery" now means "becomes susceptible again", instead of "moves to the `R` class. 

"""

# ╔═╡ 99ef7b2a-0403-11eb-08ef-e1023cd151ae
md"""
👉 Make a *new method* for the `step!` function that accepts the new infection type as argument, reusing as much functionality as possible from the previous version. 

Write it in the same cell as [our previous `step!` method](#stepfunction), and use a `begin` block to group the two definitions together.

"""

# ╔═╡ 9a13b17c-0403-11eb-024f-9b37e95e211b
md"""
👉 Run the simulation 50 times and plot $I$ as a function of time for each one, together with the mean over the 50 simulations (as you did in Exercise 2).

Note that you should be able to re-use the `sweep!` and `simulation` functions , since those should be sufficiently **generic** to work with the new `step!` function! (Modify them if they are not.)

"""

# ╔═╡ 1ac4b33a-0435-11eb-36f8-8f3f81ae7844


# ╔═╡ 9a377b32-0403-11eb-2799-e7e59caa6a45
md"""
👉 Run the new simulation and draw $I$ (averaged over runs) as a function of time. Is the behaviour qualitatively the same or different? Describe what you see.


"""

# ╔═╡ 21c50840-0435-11eb-1307-7138ecde0691


# ╔═╡ da49710e-0420-11eb-092e-4f1173868738
md"""
## **Exercise 5** - _Lecture transcript_
(MIT students only)
Please see the link for hw 4 transcript document on [Canvas](https://canvas.mit.edu/courses/5637).
We want each of you to correct about 400 lines, but don’t spend more than 15 minutes on it.
See the the beginning of the document for more instructions.
:point_right: Please mention the name of the video(s) and the line ranges you edited:
"""

# ╔═╡ e6219c7c-0420-11eb-3faa-13126f7c8007
lines_i_edited = md"""
Abstraction, lines 1-219

Array Basics, lines 1-137

Course Intro, lines 1-44 

(_for example_)
"""

# ╔═╡ 531d13c2-0414-11eb-0acd-4905a684869d
if student.name == "Jazzy Doe"
	md"""
	!!! danger "Before you submit"
	    Remember to fill in your **name** and **Kerberos ID** at the top of this notebook.
	"""
end

# ╔═╡ 4f19e872-0414-11eb-0dfd-e53d2aecc4dc
md"## Function library

Just some helper functions used in the notebook."

# ╔═╡ 48a16c42-0414-11eb-0e0c-bf52bbb0f618
hint(text) = Markdown.MD(Markdown.Admonition("hint", "Hint", [text]))

# ╔═╡ 6d906d0c-0415-11eb-0c1c-b5c0aca841db
hint(md"Remember to always re-use work you have done previously: in this case you should re-use the function `bernoulli`.")

# ╔═╡ 08e2bc64-0417-11eb-1457-21c0d18e8c51
hint(md"""
Do you remember how we worked with dictionaries in Homework 3? You can create an empty dictionary using `Dict()`. You may want to use either the function `haskey` or the function `get` on your dictionary -- check the documentation for how to use these functions.
""")

# ╔═╡ 5c6efd5c-0426-11eb-13cf-bd838f48bd71
hint(md"""
We can return more than one output using the syntax
	
`return (a, b)`
""")

# ╔═╡ 461586dc-0414-11eb-00f3-4984b57bfac5
almost(text) = Markdown.MD(Markdown.Admonition("warning", "Almost there!", [text]))

# ╔═╡ 43e6e856-0414-11eb-19ca-07358aa8b667
still_missing(text=md"Replace `missing` with your answer.") = Markdown.MD(Markdown.Admonition("warning", "Here we go!", [text]))

# ╔═╡ 41cefa68-0414-11eb-3bad-6530360d6f68
keep_working(text=md"The answer is not quite right.") = Markdown.MD(Markdown.Admonition("danger", "Keep working on it!", [text]))

# ╔═╡ 3f5e0af8-0414-11eb-34a7-a71e7aaf6443
yays = [md"Fantastic!", md"Splendid!", md"Great!", md"Yay ❤", md"Great! 🎉", md"Well done!", md"Keep it up!", md"Good job!", md"Awesome!", md"You got the right answer!", md"Let's move on to the next section."]

# ╔═╡ 3d88c056-0414-11eb-0025-05d3aff1588b
correct(text=rand(yays)) = Markdown.MD(Markdown.Admonition("correct", "Got it!", [text]))

# ╔═╡ 3c0528a0-0414-11eb-2f68-a5657ab9e73d
not_defined(variable_name) = Markdown.MD(Markdown.Admonition("danger", "Oopsie!", [md"Make sure that you define a variable called **$(Markdown.Code(string(variable_name)))**"]))

# ╔═╡ 39dffa3c-0414-11eb-0197-e72b299e9c63
bigbreak = html"<br><br><br><br><br>";

# ╔═╡ 2b26dc42-0403-11eb-205f-cd2c23d8cb03
bigbreak

# ╔═╡ 5689841e-0414-11eb-0492-63c77ddbd136
bigbreak

# ╔═╡ Cell order:
# ╟─01341648-0403-11eb-2212-db450c299f35
# ╟─03a85970-0403-11eb-334a-812b59c0905b
# ╟─06f30b2a-0403-11eb-0f05-8badebe1011d
# ╠═095cbf46-0403-11eb-0c37-35de9562cebc
# ╠═107e65a4-0403-11eb-0c14-37d8d828b469
# ╠═12cc2940-0403-11eb-19a7-bb570de58f6f
# ╠═15187690-0403-11eb-2dfd-fd924faa3513
# ╠═1d3356c4-0403-11eb-0f48-01b5eb14a585
# ╟─2b26dc42-0403-11eb-205f-cd2c23d8cb03
# ╟─df8547b4-0400-11eb-07c6-fb370b61c2b6
# ╠═d8797684-0414-11eb-1869-5b1e2c469011
# ╠═02b0c2fc-0415-11eb-2b40-7bca8ea4eef9
# ╠═76d117d4-0403-11eb-05d2-c5ea47d06f43
# ╠═6d5c6a84-0415-11eb-3fdf-9355200cb520
# ╠═d57c6a5a-041b-11eb-3ab4-774a2d45a891
# ╟─6d906d0c-0415-11eb-0c1c-b5c0aca841db
# ╠═6db6c894-0415-11eb-305a-c75b119d89e9
# ╠═6de37d6c-0415-11eb-1b05-85ac820016c7
# ╠═73047bba-0416-11eb-1047-23e9c3dbde05
# ╠═76f62d64-0403-11eb-27e2-3de58366b619
# ╠═cdaade9c-0416-11eb-0550-7b5b3d33e240
# ╠═c5c7cb86-041b-11eb-3360-45463105f3c9
# ╠═d8abd2f6-0416-11eb-1c2a-f9157d9760a7
# ╟─771c8f0c-0403-11eb-097e-ab24d0714ad5
# ╠═aa6673d4-0417-11eb-32cc-79560896c195
# ╠═105d347e-041c-11eb-2fc8-1d9e5eda2be0
# ╠═1ca7a8c2-041a-11eb-146a-15b8cdeaea72
# ╟─08e2bc64-0417-11eb-1457-21c0d18e8c51
# ╟─77428072-0403-11eb-0068-81e3728f2ebe
# ╠═4b3ec86c-0419-11eb-26fd-cbbfdf19afa8
# ╠═6c7891f2-0419-11eb-1137-e7ec60266b26
# ╠═dc784864-0430-11eb-1478-d1153e017310
# ╠═45caf17c-041a-11eb-1e14-a98b934da463
# ╠═2a6ab940-0430-11eb-204b-c58dc521ae36
# ╟─f3f81172-041c-11eb-2b9b-e99b7b9400ed
# ╠═823364ce-041c-11eb-2467-7ffa4f751527
# ╟─c68ebd1e-0433-11eb-048b-4b6900f79970
# ╠═7768a2dc-0403-11eb-39b7-fd660dc952fe
# ╠═778ec25c-0403-11eb-3146-1d11c294bb1f
# ╟─77b54c10-0403-11eb-16ad-65374d29a817
# ╠═bb63f3cc-042f-11eb-04ff-a128aec3c378
# ╟─bb8aeb58-042f-11eb-18b8-f995631df619
# ╟─77db111e-0403-11eb-2dea-4b42ceed65d6
# ╠═7335de44-042f-11eb-2873-8bceef722432
# ╟─78013f76-0403-11eb-3855-dd4e8ba271c3
# ╠═97804ff0-042f-11eb-262f-5d9072a80337
# ╟─61789646-0403-11eb-0042-f3b8308f11ba
# ╠═26f84600-041d-11eb-1856-b12a3e5c1dc7
# ╟─271ec5f0-041d-11eb-041b-db46ec1465e0
# ╠═7f4e121c-041d-11eb-0dff-cd0cbfdfd606
# ╟─7f744644-041d-11eb-08a0-3719cc0adeb7
# ╠═88c53208-041d-11eb-3b1e-31b57ba99f05
# ╠═847d0fc2-041d-11eb-2864-79066e223b45
# ╟─860790fc-0403-11eb-2f2e-355f77dcc7af
# ╠═ae4ac4b4-041f-11eb-14f5-1bcde35d18f2
# ╠═ae70625a-041f-11eb-3082-0753419d6d57
# ╠═18758408-0424-11eb-17fc-2bb4088b03ba
# ╠═189cae1e-0424-11eb-2666-65bf297d8bdd
# ╠═18d308c4-0424-11eb-176d-49feec6889cf
# ╠═190deebc-0424-11eb-19fe-615997093e14
# ╟─8631a536-0403-11eb-0379-bb2e56927727
# ╠═98beb336-0425-11eb-3886-4f8cfd210288
# ╟─866299e8-0403-11eb-085d-2b93459cc141
# ╠═9a837b52-0425-11eb-231f-a74405ff6e23
# ╠═a8dd5cae-0425-11eb-119c-bfcbf832d695
# ╟─8692bf42-0403-11eb-191f-b7d08895274f
# ╠═6d480cf0-0425-11eb-18a9-1737455371d7
# ╠═86d98d0a-0403-11eb-215b-c58ad721a90b
# ╠═223933a4-042c-11eb-10d3-852229f25a35
# ╠═1a654bdc-0421-11eb-2c38-7d35060e2565
# ╟─619c8a10-0403-11eb-2e89-8b0974fb01d0
# ╠═2ade2694-0425-11eb-2fb2-390da43d9695
# ╠═a336f36a-042c-11eb-3e1b-2df0ee60936d
# ╟─955321de-0403-11eb-04ce-fb1670dfbb9e
# ╠═32cea7ba-0429-11eb-06bc-a5f4ae3ffe37
# ╟─95771ce2-0403-11eb-3056-f1dc3a8b7ec3
# ╠═3d3b672c-0426-11eb-0a36-153ce3c276b9
# ╟─5c6efd5c-0426-11eb-13cf-bd838f48bd71
# ╟─959ef526-0403-11eb-07d1-192e7e83c942
# ╟─95c598d4-0403-11eb-2328-0175ed564915
# ╠═2e21c38a-0435-11eb-1fa3-65acce73108d
# ╟─95eb9f88-0403-11eb-155b-7b2d3a07cff0
# ╠═287ee7aa-0435-11eb-0ca3-951dbbe69404
# ╟─9611ca24-0403-11eb-3582-b7e3bb243e62
# ╠═26e2978e-0435-11eb-0d61-25f552d2771e
# ╟─9635c944-0403-11eb-3982-4df509f6a556
# ╠═4ad11052-042c-11eb-3643-8b2b3e1269bc
# ╠═61c00724-0403-11eb-228d-17c11670e5d1
# ╟─99ef7b2a-0403-11eb-08ef-e1023cd151ae
# ╟─9a13b17c-0403-11eb-024f-9b37e95e211b
# ╠═1ac4b33a-0435-11eb-36f8-8f3f81ae7844
# ╟─9a377b32-0403-11eb-2799-e7e59caa6a45
# ╠═21c50840-0435-11eb-1307-7138ecde0691
# ╟─da49710e-0420-11eb-092e-4f1173868738
# ╠═e6219c7c-0420-11eb-3faa-13126f7c8007
# ╟─5689841e-0414-11eb-0492-63c77ddbd136
# ╟─531d13c2-0414-11eb-0acd-4905a684869d
# ╟─4f19e872-0414-11eb-0dfd-e53d2aecc4dc
# ╟─48a16c42-0414-11eb-0e0c-bf52bbb0f618
# ╟─461586dc-0414-11eb-00f3-4984b57bfac5
# ╟─43e6e856-0414-11eb-19ca-07358aa8b667
# ╟─41cefa68-0414-11eb-3bad-6530360d6f68
# ╟─3f5e0af8-0414-11eb-34a7-a71e7aaf6443
# ╟─3d88c056-0414-11eb-0025-05d3aff1588b
# ╟─3c0528a0-0414-11eb-2f68-a5657ab9e73d
# ╟─39dffa3c-0414-11eb-0197-e72b299e9c63
