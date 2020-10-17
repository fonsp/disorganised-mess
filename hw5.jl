### A Pluto.jl notebook ###
# v0.12.4

using Markdown
using InteractiveUtils

# ╔═╡ 2b37ca3a-0970-11eb-3c3d-4f788b411d1a
begin
	using Pkg
	Pkg.activate(mktempdir())
end

# ╔═╡ 2dcb18d0-0970-11eb-048a-c1734c6db842
begin
	Pkg.add(["PlutoUI", "Plots"])

	using Plots
	gr()
	using PlutoUI
end

# ╔═╡ 19fe1ee8-0970-11eb-2a0d-7d25e7d773c6
md"_homework 5, version 0_"

# ╔═╡ 49567f8e-09a2-11eb-34c1-bb5c0b642fe8
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

# ╔═╡ 181e156c-0970-11eb-0b77-49b143cc0fc0
md"""

# **Homework 5**: _Epidemic modeling II_
`18.S191`, fall 2020

This notebook contains _built-in, live answer checks_! In some exercises you will see a coloured box, which runs a test case on your code, and provides feedback based on the result. Simply edit the code, run it, and the check runs again.

_For MIT students:_ there will also be some additional (secret) test cases that will be run as part of the grading process, and we will look at your notebook and write comments.

Feel free to ask questions!
"""

# ╔═╡ 1f299cc6-0970-11eb-195b-3f951f92ceeb
# edit the code below to set your name and kerberos ID (i.e. email without @mit.edu)

student = (name = "Jazzy Doe", kerberos_id = "jazz")

# you might need to wait until all other cells in this notebook have completed running. 
# scroll around the page to see what's up

# ╔═╡ 1bba5552-0970-11eb-1b9a-87eeee0ecc36
md"""

Submission by: **_$(student.name)_** ($(student.kerberos_id)@mit.edu)
"""

# ╔═╡ 2848996c-0970-11eb-19eb-c719d797c322
md"_Let's create a package environment:_"

# ╔═╡ 98cd16fe-0952-11eb-33c6-99237bddd572
TODO = html"<h1 style='display: inline'>TODO</h1>"

# ╔═╡ 69d12414-0952-11eb-213d-2f9e13e4b418
md"""
In this problem set, we will look at a simple **spatial** agent-based epidemic model: agents can interact only with other agents that are *nearby*.  (In the previous homework any agent could interact with any other, which is not realistic.)

A simple approach is to use **discrete space**: each agent lives
in one cell of a square grid. For simplicity we will allow no more than
one agent in each cell, but this requires some care to
design the rules of the model to respect this.

We will adapt some functionality from the previous homework. $TODO You should copy and paste your code from that homework into this notebook.
"""

# ╔═╡ 3e54848a-0954-11eb-3948-f9d7f07f5e23
md"""
## **Exercise 1:** _Wandering at random in 2D_

In this exercise we will implement a **random walk** on a 2D lattice (grid). At each time step, a walker jumps to a neighbouring position at random (i.e. chosen with uniform probability from the available adjacent positions).

👉 Define an abstract type `AbstractWalker`.
"""

# ╔═╡ 0af0c67e-0972-11eb-1709-7dcbfc4503ef
abstract type AbstractWalker end

# ╔═╡ 3e58a58a-0954-11eb-016a-2ff5af051e6d
md"""
👉 Define an abstract type `Abstract2DWalker` that is a subtype of `AbstractWalker` (using  `<:`).

"""

# ╔═╡ 0c74501c-0972-11eb-0348-175e41289c28
abstract type Abstract2DWalker <: AbstractWalker end

# ╔═╡ 3e623454-0954-11eb-03f9-79c873d069a0
md"""
👉 Define an struct type `Location` that contains integers `x` and `y`.

"""

# ╔═╡ 0ebd35c8-0972-11eb-2e67-698fd2d311d2
struct Location
	x::Int
	y::Int
end

# ╔═╡ 3e6be242-0954-11eb-370a-af8cc0363274
md"""
👉 Define a struct type `Wanderer` that is a subtype of `AbstractWalker2D`. It contains a field called `position` that is a `Location` object.

"""

# ╔═╡ 11ad4714-0972-11eb-2c9b-4fd73110f84d
begin
	struct Wanderer <: Abstract2DWalker
		position::Location
	end
	Wanderer(x,y) = Wanderer(Location(x,y))
end

# ╔═╡ 3e74a0f8-0954-11eb-1903-035990bd1c92
md"""
👉 (i) Check that Julia automatically provides a constructor function `Walker2D(position)` that accepts an object of type `Location`.

(ii) Construct a `Wanderer` located at the origin.

"""

# ╔═╡ 1408f93e-0972-11eb-34b7-fdbac820be10
Wanderer(Location(0,0))

# ╔═╡ 3e7d3338-0954-11eb-3b7a-452d67e2a1f5
md"""
👉 Write a new method `Wanderer(x, y)` that takes two integers, $x$ and $y$ and creates a `Wanderer` at the corresponding position.

"""

# ╔═╡ 164bee4c-0972-11eb-0abf-49dc392d356f
accumulate

# ╔═╡ 3e858990-0954-11eb-3d10-d10175d8ca1c
md"""
👉 Write a function `make_tuple` that takes an object of type `Location` and returns the corresponding tuple
`(x, y)`.


"""

# ╔═╡ 189bafac-0972-11eb-1893-094691b2073c
make_tuple(w::Wanderer) = w.location.x, w.location.y

# ╔═╡ 3e8e6bbe-0954-11eb-166e-e54498cc8fb4
md"""
In the following questions, the functions should take an object of type `AbstractWalker2D`
(or you can just leave them untyped).

8. Write a "getter" function `position` that returns the position as a `Location` object.

"""

# ╔═╡ 1fc612a4-0972-11eb-2a6c-7f615851bceb
position(w::Wanderer) = w.position

# ╔═╡ 3e97310e-0954-11eb-21b9-216d029380c1
md"""
9. Write a "setter" function `set_position` that walker and a location `l` and creates a new Walker whose location is `l`

"""

# ╔═╡ 212339f6-0972-11eb-04a1-6b4f8e7dbb79
setposition(w::Wanderer, l::Location) = Wanderer(l)

# ╔═╡ 3ea0e8c0-0954-11eb-2f98-6d108339a870
md"""
10.
  (i) Write a function `jump` that returns a possible new position for a walker after a 2D jump as a `Location` object. 

 Jumps are equally likely in the directions right, up, left and down. Diagonal jumps are *not* allowed.

 A nice way to implement this is to write a tuple `moves` of possible
 moves, and call `rand` on that tuple to get a random move. Then add the move to the current location.
"""

# ╔═╡ 2d1a9ac4-0972-11eb-2eb2-7d94fa5eef39


# ╔═╡ 2dcb71b4-0972-11eb-11a0-df571588d97f
md"""
 (ii) Check that your `jump` function works and that the jumps are not diagonal.
"""

# ╔═╡ 32630e6a-0972-11eb-0adf-4130c4d387c0
Base.:+(a::Location, b::Location) = Location(a.x+b.x, a.y+b.y)

# ╔═╡ 3eaa72ac-0954-11eb-108f-2b05adf41895
md"""
11. Write a function `jump` that moves a walker to a new position (it should return a new Walker -- the walker at the next time step). What arguments does the function need?

"""

# ╔═╡ 5278e232-0972-11eb-19ff-a1a195127297
moves = [Location(1,0), Location(0,1), Location(-1,0), Location(0,-1)]

# ╔═╡ 8f2c0e4e-0974-11eb-05e5-b9f18136e60f
move_walker(origin::Wanderer, move) = Wanderer(position(origin) + move)

# ╔═╡ 3eb46664-0954-11eb-31d8-d9c0b74cf62b
md"""
12. Write a function `trajectory` that calculates a trajectory of a 2D walker of length $N$.

Functional programming pro-tip: Rather than using a `for` loop to do this, use `accumulate` with `move_walker` and `n` random moves (created using `rand(moves, n)`). Pass `init=Wanderer(0,0)` to start accumulate from the origin.
"""

# ╔═╡ 548b9c16-0972-11eb-3ce9-838a63d3524b
trajectory(w::Wanderer, n::Int) = accumulate(move_walker, rand(moves, n), init=w)

# ╔═╡ 3ebd436c-0954-11eb-170d-1d468e2c7a37
md"""
13. Plot 10 trajectories of length 10,000 on a single figure, all starting at the origin.

    Use the `Plots.jl` package. `plot` can accept a `Vector` of `Tuple`s, i.e. $(x, y)$ pairs, as the coordinates to plot. Use `ratio=1` so that distances in the $x$ and $y$ directions are the same.

So for example, you can compose the plot like this:


```julia
let p = plot(ratio=1)                   # Create a new plot with aspect ratio 1:1
	plot!(p, [(0,0), (0,1), (1,1), (0,1)])      # plot one trajectory
	plot!(p, [(0,0), (0,-1), (-1,-1), (0,-1)])  # plot the second one
	p
end
```
"""

# ╔═╡ 68751e22-0973-11eb-04d5-8798a4affee0
# Edit this to insert your plots! Use a for loop to draw 10 trajectories.
let p = plot(ratio=1)
	for _ in 1:10
		plot!(p, tuple.(cumsum(randn(100)), cumsum(randn(100))))
	end
	p
end

# ╔═╡ fb8eb390-096b-11eb-3fd9-41080c4c02a7
Location(-1,0)

# ╔═╡ e326a29c-096b-11eb-1bdd-73b1fad4d230
dirs = (left=(-1,0), right=(1,0))

# ╔═╡ 3ec71edc-0954-11eb-327b-cdb285914507
md"# Thoughts fonsi:

We might want to define these types ourselves if the rest of the ntoebook depends on them.

We don't use any other subtypes of `AbstractWanderer`, so let's not use `AbstractWanderer2D`?

`+` instead of `jump`?

we don't need all these types, maybe later? If we just use `Location` and `Movement` then the code is more charming. We can also use tuples instead of Location

`Movement` is also a x, y struct. `+(::Location, ::Movement)::Location`

`rand(moves)`

```julia
reduce(1:T, init=Location(0,0)) do prev_location, _
	prev_location + rand(moves)
end
```
and `accumulate`

"

# ╔═╡ 3ed06c80-0954-11eb-3aee-69e4ccdc4f9d
md"""
## **Exercise 2:** _Wandering agent_

In this exercise we will combine our `Agent` type from the previous homework with the 2D random walker that we just created, by adding a position to the `Agent` type.
"""

# ╔═╡ bab55612-099f-11eb-1ea0-2982fe6e5bde
md"""
👉 Define a type `Agent` that is a subtype of `AbstractWalker2D` from Exercise 1, since it will behave like a random walker and lives in 2D.

    `Agent` should contain a `Location`, as well as a `state` of type `InfectionStatus` (as in Homework 4).)

    [For simplicity we will not use a `num_infected` field, but feel free to do so!]
"""

# ╔═╡ cf2f3b98-09a0-11eb-032a-49cc8c15e89c


# ╔═╡ b4d5da4a-09a0-11eb-1949-a5807c11c76c
md"""

2. Agents live in a box of side length $2L$, centered at the origin. We need to decide (i.e. model) what happens when they reach the walls of the box (boundaries), in other words what kind of **boundary conditions** to use.

    One relatively simple boundary condition is a **reflecting boundary**:

    > Each wall of the box is a reflective mirror, modelled using "bounce-back": if the walker tries to jump beyond the wall, it bounces back to the *same* position that it started from (i.e. the wall is "springy"). That is, it **proposes** to take a step, but is blocked in that direction, so instead it remains where it is during that step.

    Use the method of the `jump` function from above (that proposes a new position) to define a new method for the `jump` function, which also accepts a size `S`
    and implements reflecting boundary conditions.
    It returns a `Location` object representing the new position (inside the grid).
"""

# ╔═╡ d07744dc-09a0-11eb-3f65-85fff408b7fb
function move_walker_bounded(boundary)
	function (walker, move)
	end
end

# ╔═╡ cd82c782-09a1-11eb-25ce-739fe88812bf


# ╔═╡ b4ed2362-09a0-11eb-0be9-99c91623b28f
md"""
3. Check that this is working by drawing a trajectory of an `Agent` inside a square box of side length 20,
using your function `trajectory` from Exercise 1.

 You should draw the boundaries of the box and also a trajectory that is sufficiently long to see what happens at the boundary, but not so long that it fills up the box.

"""

# ╔═╡ a4e93fe4-099f-11eb-0a29-d10c28a2d9af
trajectory(w::Wanderer, n::Int, boundary) = accumulate(move_walker_bounded(boundary), rand(moves, n), init=w)

# ╔═╡ 44107808-096c-11eb-013f-7b79a90aaac8
trajectory(Wanderer(Location(4,4)), 10)

# ╔═╡ 814e888a-0954-11eb-02e5-0964c7410d30
md"""
## **Exercise 3:** _Spatial epidemic model -- Initialization and visualization_

We now have all of the technology in place to simulate an agent-based model in space!

We will impose that at most one agent can be on a given site at all times, modelling the fact that two people cannot be in the same place as one other.

👉 Write a function `initialize` that takes parameters $L$ and $N$, where $2L$ is the side length of the square box where the agents live and $N$ is the number of agents.

    It builds, one by one, a collection of agents, by proposing a position for each one and checking if that position is occupied. If the position is occupied, it should generate another one until it finds a free spot.

    Create additional functions that you find useful so that each function is short and self-contained,.

    The agents are all susceptible, except one, chosen at random, which is infectious.
    
    `initialize` returns a `Vector` of `Agent`s.

2. Run your initialization function for $L=10$ and $N=20$ and store the result in a variable `agents`.

3. Write a function `visualize` that takes in a collection of agents as argument. It should plot a point for each agent at its location, coloured according to its status.

    You can use the keyword argument `c=cs` inside your call to the plotting function to set the colours of points to a vector of integers called `cs`. Don't forget to use `ratio=1`.

4. Visualize the initial condition you created.
"""

# ╔═╡ f953e06e-099f-11eb-3549-73f59fed8132
md"""

### Exercise 4: Spatial epidemic model -- Dynamics

1. Write a function `step!` that does one step of the dynamics:

    - Choose an agent at random, say $i$.

    - Propose a new neighbouring position for that agent, as above.

    - If that new position is *un*occupied, the agent moves there.

    - If the new position *is* occupied, no motion occurs, but there is **contact** and the infection may be transmitted from agent $i$ to the neighbour that it contacts, with the corresponding probability.

    - Agent $i$ recovers with the corresponding probability.

2. Write a function `dynamics!` that takes the same parameters as `step!`, together with a number of sweeps.

    Run the dynamics for the given number of sweeps. (Re-use your `sweep!` function from the previous homework.)

    Save the state of the whole system, together with the total numbers of $S$, $I$ and $R$ individuals, after each sweep, for later use.

    You may need the function `deepcopy` to copy the state of the whole system.

3. Given one simulation run, write an interactive visualization that shows both the state at time $n$ (using `visualize`) and the history of $S$, $I$ and $R$ from time $0$ up to time $n$. 

    [You can make two separate plot objects $p_1 = plot(...)$ and $p_2 = plot(...)$ or similar, and use `plot(p1, p2)` to display them together.]

4. Using $L=20$ and $N=100$, experiment with the infection and recovery probabilities until you find an epidemic outbreak. (Take the recovery probability quite small.)

5. For the values that you found in the previous part,
run 50 simulations. Plot $S$, $I$ and $R$ as a function of time for each of them (with transparency!).

6. Plot their means with error bars. This should look qualitatively similar to what you saw in the previous homework.
"""

# ╔═╡ 05c80a0c-09a0-11eb-04dc-f97e306f1603
md"""
## **Exercise 5:** _Effect of socialization_

In this exercise we'll modify the simple mixing model. Instead of a constant mixing probability, i.e. a constant probability that any pair of people interact on a given day, we will have a variable probability associated with each agent, modelling the fact that some people are more or less social than others.

👉 Create a new agent type `SocialAgent` with fields `infection_status`, `num_infected`, and `social_score`. The attribute `social_score` represents an agent's probability of interacting with any other agent in the population.

👉 Create a population of 500 agents, with `social_score`s chosen from 10 equally-spaced between 0.1 and 0.5.

👉 Write a new function that can be used in our simulation code to model interactions between these agents.  When two agents interact, their social scores are added together and the result is the probability that they interact. Only if they interact is the infection then transmitted with the usual probability.

👉 Plot the SIR curves of the resulting simulation.

👉 Make a scatter plot showing each agent's mixing rate on one axis, and the `num_infected` from the simulation in the other axis. How does the mean  Run this simulation several times and comment on the results.



Run a simulation for 100 steps, and then apply a "lockdown" where every agent's social score gets multiplied by 0.25, and then run a second simulation which runs on that same population from there.  What do you notice?  How does changing this factor form 0.25 to other numbers affect things?
"""

# ╔═╡ 05fc5634-09a0-11eb-038e-53d63c3edaf2
md"""
### Exercise 6 (Extra credit): Effect of distancing

We can use a variant of the above model to investigate the effect of the
mis-named "social distancing"  
(we want people to be *socially* close, but *physically* distant).

In this variant, we separate out the two effects "infection" and
"movement": an infected agent chooses a
neighbouring site, and if it finds a susceptible there then it infects it
with probability $p_I$. For simplicity we can ignore recovery.

Separately, an agent chooses a neighbouring site to move to,
and moves there with probability $p_M$ if the site is vacant. (Otherwise it
stays where it is.)

When $p_M = 0$, the agents cannot move, and hence are
completely quarantined in their original locations.
👉 How does the disease spread in this case?

👉 Run the dynamics repeatedly, and plot the sites which become infected.

👉 How does this change as you increase the *density*
    $\rho = N / (L^2)$ of agents?  Start with a small density.

This is basically the [**site percolation**](https://en.wikipedia.org/wiki/Percolation_theory) model.

When we increase $p_M$, we allow some local motion via random walks.
👉 Investigate how this leaky quarantine affects the infection dynamics with
different densities.

"""

# ╔═╡ 0e6b60f6-0970-11eb-0485-636624a0f9d7
if student.name == "Jazzy Doe"
	md"""
	!!! danger "Before you submit"
	    Remember to fill in your **name** and **Kerberos ID** at the top of this notebook.
	"""
end

# ╔═╡ 0a82a274-0970-11eb-20a2-1f590be0e576
md"## Function library

Just some helper functions used in the notebook."

# ╔═╡ 0aa666dc-0970-11eb-2568-99a6340c5ebd
hint(text) = Markdown.MD(Markdown.Admonition("hint", "Hint", [text]))

# ╔═╡ 0acaf3b2-0970-11eb-1d98-bf9a718deaee
almost(text) = Markdown.MD(Markdown.Admonition("warning", "Almost there!", [text]))

# ╔═╡ 0afab53c-0970-11eb-3e43-834513e4632e
still_missing(text=md"Replace `missing` with your answer.") = Markdown.MD(Markdown.Admonition("warning", "Here we go!", [text]))

# ╔═╡ 0b21c93a-0970-11eb-33b0-550a39ba0843
keep_working(text=md"The answer is not quite right.") = Markdown.MD(Markdown.Admonition("danger", "Keep working on it!", [text]))

# ╔═╡ 0b470eb6-0970-11eb-182f-7dfb4662f827
yays = [md"Fantastic!", md"Splendid!", md"Great!", md"Yay ❤", md"Great! 🎉", md"Well done!", md"Keep it up!", md"Good job!", md"Awesome!", md"You got the right answer!", md"Let's move on to the next section."]

# ╔═╡ 0b6b27ec-0970-11eb-20c2-89515ee3ab88
correct(text=rand(yays)) = Markdown.MD(Markdown.Admonition("correct", "Got it!", [text]))

# ╔═╡ 0b901714-0970-11eb-0b6a-ebe739db8037
not_defined(variable_name) = Markdown.MD(Markdown.Admonition("danger", "Oopsie!", [md"Make sure that you define a variable called **$(Markdown.Code(string(variable_name)))**"]))

# ╔═╡ c84733d8-0970-11eb-1923-0dd2a5175cf5
md"# Multiplayer"

# ╔═╡ 67a5b05e-0970-11eb-3d50-cf48e1905490
html"""<script>
let firebase = await require.alias({
  "@firebase/app": "https://www.gstatic.com/firebasejs/6.3.1/firebase-app.js",
  "@firebase/firestore":
	"https://www.gstatic.com/firebasejs/6.3.1/firebase-auth.js",
  "@firebase/database":
	"https://www.gstatic.com/firebasejs/6.3.1/firebase-database.js"
})("@firebase/app", "@firebase/firestore", "@firebase/database")
var firebaseConfig = {
	apiKey: "AIzaSyDjOnfUxXqV3mcunbn6z8bdztGXOMxTH3M",
	authDomain: "plutojl.firebaseapp.com",
	databaseURL: "https://plutojl.firebaseio.com",
	projectId: "plutojl",
	storageBucket: "plutojl.appspot.com",
	messagingSenderId: "1096981201955",
	appId: "1:1096981201955:web:187dfe8dc4f22602e2dd96",
	measurementId: "G-0MQBLBDYX5"
};
let app = firebase.initializeApp(firebaseConfig);
await app.auth().signInAnonymously()
window.app = app;
console.log('Logged in');
"""

# ╔═╡ 67ca0b48-0970-11eb-0ba0-9f414e8239c8
html"""
<script src="https://cdn.jsdelivr.net/npm/lodash@4.17.20/lodash.min.js"></script>
<script>
if (window.app == null) return html`
	<pre>You have to reload this cell</pre>
`
let notebook_id = currentScript.closest('pluto-notebook').id;
let user_id = app.auth().currentUser.uid;
app.database().ref(`notebooks/${notebook_id}/users/${user_id}`).onDisconnect().remove()
invalidation.then(() => {
	return;
	let ref = app.database().ref(`notebooks/${notebook_id}/users/${user_id}`)
	ref.remove()
	ref.onDisconnect().cancel()
}) 
let addEventListener = ({ target, event, handler, passive }) => {
	target.addEventListener(event, handler, { passive: passive })
  	invalidation.then(() => {
    	target.removeEventListener(event, handler)
  	})
}
addEventListener({
	target: document,
	event: "focusin",
	passive: true,
	handler: (e) => {
		let cell_node = e.target.closest('pluto-cell');
		let notebook_id = cell_node.closest('pluto-notebook').id;
		let cell_id = cell_node.id;
		let user_id = app.auth().currentUser.uid;
		app.database()
			.ref(`notebooks/${notebook_id}/users/${user_id}`)
			.update({ cell_in_focus: cell_id });
	},
})
addEventListener({
	target: window,
	event: "scroll",
	passive: true,
	handler: _.debounce((e) => {
		if (invalidation.isInvalidated) return
		let notebook_id = currentScript.closest('pluto-notebook')?.id;
		let user_id = app.auth().currentUser.uid;
		if (notebook_id == null) return;
		app.database()
			.ref(`notebooks/${notebook_id}/users/${user_id}`)
			.update({
				viewport: [
					document.documentElement.scrollTop,
					document.documentElement.scrollTop + document.documentElement.clientHeight
				]
			});
	}, 500),
})
let track_cell_state = _.debounce(() => {
	if (invalidation.isInvalidated) return
	let selection = document.getSelection();
	let cm_node = selection.anchorNode.closest('pluto-input > .CodeMirror')
	let code_mirror = cm_node.CodeMirror
	let start_cursor = code_mirror.getCursor(true)
	let end_cursor = code_mirror.getCursor(false)
	let cell_node = cm_node.closest('pluto-cell');
	let notebook_id = cell_node.closest('pluto-notebook').id;
	let cell_id = cell_node.id;
	let user_id = app.auth().currentUser.uid;
	let changed_cells = [...document.querySelectorAll('pluto-cell.code_differs')].map(x => x.id)
	console.log('changed_cells:', changed_cells)
	app.database()
		.ref(`notebooks/${notebook_id}/users/${user_id}`)
		.update({
			changed_cells: changed_cells,
			selection: {
				cell: cell_id,
				start: { line: start_cursor.line, column: start_cursor.ch },
				end: { line: end_cursor.line, column: end_cursor.ch },
			}
		});
}, 500)
addEventListener({
	target: document,
	event: 'selectionchange',
	passive: true,
	handler: track_cell_state,
})
addEventListener({
	target: document,
	event: 'keyup',
	passive: true,
	handler: track_cell_state,
})
addEventListener({
	target: document,
	event: 'mouseup',
	passive: true,
	handler: track_cell_state,
})
"""

# ╔═╡ 67eecfe6-0970-11eb-2412-d1258c62a2c9
html"""
<style>
.styled-background {
	background-color: red;
}
</style> 
<script id="main">
if (window.app == null) return html`
	<pre>You need to reload this cell</pre>
`
let Preact = await import("https://cdn.jsdelivr.net/npm/htm@3/preact/standalone.module.js")
let renderComponent = (element = DOM.element('div'), component) => {
	Preact.render(Preact.html`<${component} />`, element)
	invalidation.then(() => {
		Preact.render(null, element)
	})
	return element
}
let onValue = ({ ref, onValue }) => {
	let subscription = ref.on('value', snapshot => onValue(snapshot.val()))
	invalidation.then(() => {
		ref.off('value', subscription);
	})
}
let toRGB = (string) => {
    var hash = 0;
    for (let character of string) {
        hash = character.charCodeAt(0) + ((hash << 5) - hash);
        hash = hash & hash;
    }
    var rgb = [0, 0, 0];
    for (var i = 0; i < 3; i++) {
        var value = Math.abs(((hash * i) & 255));
        rgb[i] = value;
    }
    return `rgba(${rgb[0]}, ${rgb[1]}, ${rgb[2]}, 0.2)`;
}
let { html: jsx, useEffect, useState, useRef } = Preact;
let notebook_id = currentScript.closest('pluto-notebook').id;
let element = this?.gutter_element ?? DOM.element('div')
// let element = DOM.element('div')
document.body.appendChild(element)
let MarkText = ({ cell, start, end, color }) => {
	Preact.useEffect(() => { 
		let editor = document.getElementById(cell).querySelector(`.CodeMirror`).CodeMirror
		let x = editor.markText(
			{ line: start.line, ch: start.column },
			{ line: end.line, ch: end.column },
			{ css: `background-color: ${color}` }
		);
		return () => x.clear()
	}, [cell, start.line, start.character, end.line, end.character])
	return null
}
let LockCell = ({ cell_id, color }) => {
	Preact.useEffect(() => {
		let cell_node = document.getElementById(cell_id)
		let codemirror_node = cell_node.querySelector('.CodeMirror')
		let cm_instance = codemirror_node.CodeMirror;
		console.log('#10')
		cm_instance.setOption("readOnly", true)
		codemirror_node.style.backgroundColor = color
		cm_instance.readOnly_listeners = (cm_instance.readOnly_listeners ?? 0) + 1
		return () => {
			cm_instance.readOnly_listeners = cm_instance.readOnly_listeners - 1
			if (cm_instance.readOnly_listeners === 0) {
				cm_instance.setOption("readOnly", false);
				codemirror_node.style.backgroundColor = ""
			}
		}
	}, [cell_id, color])
	return null;
}
let GUTTER_VERTICAL_MARGIN = 40;
let ViewportGutter = ({ viewport, title, color }) => {
	return jsx`
		<div
			title=${title}
			style=${{
				transition: 'transform .5s',
				marginLeft: 5,
				transform: `translateY(${viewport[0] + GUTTER_VERTICAL_MARGIN}px)`,
				height: viewport[1] - viewport[0] - GUTTER_VERTICAL_MARGIN * 2,
				width: 5,
				backgroundColor: color,
			}}
		/>
	`
}
renderComponent(element, () => {
	let [notebook, set_notebook] = useState(null)
	
	useEffect(() => {
		onValue({
			ref: app.database().ref(`notebooks/${notebook_id}`),
			onValue: (value) => {
				window.requestAnimationFrame(() => {
					set_notebook(value)
				})
			},
		})
	}, []);
	console.log('notebook:', notebook)
	return jsx`
		<div
			style=${{
				position: 'absolute',
				top: 0, bottom: 0,
				left: 0,
				display: 'flex',
				flexDirection: 'row',
				overflowY: 'hidden',
			}}
		>
			${Object.entries(notebook?.users ?? {})
			.filter(([id, user]) => id !== app.auth().currentUser.uid)
			.map(([id, user]) => jsx`
				<${Preact.Fragment} key=${id}>
					${user.viewport && jsx`
						<${ViewportGutter}
							key={id}
							title={id}
							viewport=${user.viewport}
							color=${toRGB(id)}
						/>
					`}
					${(user.changed_cells ?? []).map(cell_id => jsx`
						<${LockCell}
							key=${cell_id}
							cell_id=${cell_id}
							color=${toRGB(id)}
						/>
					`)}
					${user.selection && jsx`
						<${MarkText}
							...${user.selection}
							color=${toRGB(id)}
						/>
					`}
				</${Preact.Fragment}>
			`)}
		</div>
	`
})
let return_element = html`
	<pre>Running UI</pre>
`
return_element.gutter_element = element
return return_element
"""

# ╔═╡ Cell order:
# ╟─19fe1ee8-0970-11eb-2a0d-7d25e7d773c6
# ╟─1bba5552-0970-11eb-1b9a-87eeee0ecc36
# ╠═49567f8e-09a2-11eb-34c1-bb5c0b642fe8
# ╟─181e156c-0970-11eb-0b77-49b143cc0fc0
# ╠═1f299cc6-0970-11eb-195b-3f951f92ceeb
# ╟─2848996c-0970-11eb-19eb-c719d797c322
# ╠═2b37ca3a-0970-11eb-3c3d-4f788b411d1a
# ╠═2dcb18d0-0970-11eb-048a-c1734c6db842
# ╟─98cd16fe-0952-11eb-33c6-99237bddd572
# ╠═69d12414-0952-11eb-213d-2f9e13e4b418
# ╠═3e54848a-0954-11eb-3948-f9d7f07f5e23
# ╠═0af0c67e-0972-11eb-1709-7dcbfc4503ef
# ╟─3e58a58a-0954-11eb-016a-2ff5af051e6d
# ╠═0c74501c-0972-11eb-0348-175e41289c28
# ╟─3e623454-0954-11eb-03f9-79c873d069a0
# ╠═0ebd35c8-0972-11eb-2e67-698fd2d311d2
# ╟─3e6be242-0954-11eb-370a-af8cc0363274
# ╠═11ad4714-0972-11eb-2c9b-4fd73110f84d
# ╟─3e74a0f8-0954-11eb-1903-035990bd1c92
# ╠═1408f93e-0972-11eb-34b7-fdbac820be10
# ╟─3e7d3338-0954-11eb-3b7a-452d67e2a1f5
# ╠═164bee4c-0972-11eb-0abf-49dc392d356f
# ╟─3e858990-0954-11eb-3d10-d10175d8ca1c
# ╠═189bafac-0972-11eb-1893-094691b2073c
# ╟─3e8e6bbe-0954-11eb-166e-e54498cc8fb4
# ╠═1fc612a4-0972-11eb-2a6c-7f615851bceb
# ╟─3e97310e-0954-11eb-21b9-216d029380c1
# ╠═212339f6-0972-11eb-04a1-6b4f8e7dbb79
# ╟─3ea0e8c0-0954-11eb-2f98-6d108339a870
# ╠═2d1a9ac4-0972-11eb-2eb2-7d94fa5eef39
# ╟─2dcb71b4-0972-11eb-11a0-df571588d97f
# ╠═32630e6a-0972-11eb-0adf-4130c4d387c0
# ╟─3eaa72ac-0954-11eb-108f-2b05adf41895
# ╠═5278e232-0972-11eb-19ff-a1a195127297
# ╠═8f2c0e4e-0974-11eb-05e5-b9f18136e60f
# ╟─3eb46664-0954-11eb-31d8-d9c0b74cf62b
# ╠═548b9c16-0972-11eb-3ce9-838a63d3524b
# ╠═44107808-096c-11eb-013f-7b79a90aaac8
# ╟─3ebd436c-0954-11eb-170d-1d468e2c7a37
# ╠═68751e22-0973-11eb-04d5-8798a4affee0
# ╠═fb8eb390-096b-11eb-3fd9-41080c4c02a7
# ╠═e326a29c-096b-11eb-1bdd-73b1fad4d230
# ╠═3ec71edc-0954-11eb-327b-cdb285914507
# ╟─3ed06c80-0954-11eb-3aee-69e4ccdc4f9d
# ╠═bab55612-099f-11eb-1ea0-2982fe6e5bde
# ╠═cf2f3b98-09a0-11eb-032a-49cc8c15e89c
# ╟─b4d5da4a-09a0-11eb-1949-a5807c11c76c
# ╠═d07744dc-09a0-11eb-3f65-85fff408b7fb
# ╠═cd82c782-09a1-11eb-25ce-739fe88812bf
# ╟─b4ed2362-09a0-11eb-0be9-99c91623b28f
# ╠═a4e93fe4-099f-11eb-0a29-d10c28a2d9af
# ╠═814e888a-0954-11eb-02e5-0964c7410d30
# ╟─f953e06e-099f-11eb-3549-73f59fed8132
# ╠═05c80a0c-09a0-11eb-04dc-f97e306f1603
# ╠═05fc5634-09a0-11eb-038e-53d63c3edaf2
# ╟─0e6b60f6-0970-11eb-0485-636624a0f9d7
# ╟─0a82a274-0970-11eb-20a2-1f590be0e576
# ╟─0aa666dc-0970-11eb-2568-99a6340c5ebd
# ╟─0acaf3b2-0970-11eb-1d98-bf9a718deaee
# ╟─0afab53c-0970-11eb-3e43-834513e4632e
# ╟─0b21c93a-0970-11eb-33b0-550a39ba0843
# ╟─0b470eb6-0970-11eb-182f-7dfb4662f827
# ╟─0b6b27ec-0970-11eb-20c2-89515ee3ab88
# ╟─0b901714-0970-11eb-0b6a-ebe739db8037
# ╠═c84733d8-0970-11eb-1923-0dd2a5175cf5
# ╟─67a5b05e-0970-11eb-3d50-cf48e1905490
# ╟─67ca0b48-0970-11eb-0ba0-9f414e8239c8
# ╟─67eecfe6-0970-11eb-2412-d1258c62a2c9
