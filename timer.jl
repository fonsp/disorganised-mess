### A Pluto.jl notebook ###
# v0.7.6

using Markdown
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.peek, el) ? Base.peek(el) : missing
        el
    end
end
# ╔═╡ b61aaff4-89fd-11ea-1b7d-bbf9d10c8327
0b0100111011

# ╔═╡ db24490e-7eac-11ea-094e-9d3fc8f22784
md"# Introducing _bound_ variables

With the new `@bind` macro, Pluto.jl can listen to real-time events from HTML objects!"

# ╔═╡ bd24d02c-7eac-11ea-14ab-95021678e71e
@bind x html"<input type='range'>"

# ╔═╡ cf72c8a2-7ead-11ea-32b7-d31d5b2dacc2
md"This syntax displays the HTML object as the cell's output, and uses its latest value as the definition of `x`. Of course, the variable `x` is _reactive_, and all references to `x` come to life ✨

_Try it out!_ 👆" 

# ╔═╡ cb1fd532-7eac-11ea-307c-ab16b1977819
x

# ╔═╡ d746a468-8a04-11ea-2a1f-d5eef9dd0b23
@__MODULE__

# ╔═╡ 89192fc0-89a5-11ea-0672-6f869a5951ea
sleep(1)

# ╔═╡ 63621118-89a8-11ea-08e2-27f0ec350305
ts = []

# ╔═╡ 9e497290-8986-11ea-0b02-17e42d1970fb
push!(ts, t1); length(ts)

# ╔═╡ 29b41e06-8a0c-11ea-1ff9-3fd09f53d808
t

# ╔═╡ aceb3ec4-8a05-11ea-0df9-890ddc329557
struct Timer
	interval::Real
	fixed::Bool
	Timer(interval=1.0, fixed=false) = interval >= 0 ? new(interval, fixed) : error("interval must be non-negative")
end

# ╔═╡ afdde47c-89a5-11ea-0d5a-e741eaabff79
@bind t Timer()

# ╔═╡ bc22de9a-89a5-11ea-140b-8b8f9d69a1dd
@bind t2 Timer(0.5, true)

# ╔═╡ c4ffcbea-89a5-11ea-1c6f-7558a8060ff6
t2

# ╔═╡ 350de788-8a06-11ea-24d5-d786fc362fc3
Timer(1.2)

# ╔═╡ 80cff3d0-8989-11ea-064b-2b1c4b045c22
Base.show(io::IO, ::MIME"text/html", timer::Timer) = begin
	tb = read("/mnt/c/dev/julia/timer_back.svg", String)
	tf = read("/mnt/c/dev/julia/timer_front.svg", String)
	tz = read("/mnt/c/dev/julia/timer_zoof.svg", String)
	
	
	write(io, """
	<timer$(timer.fixed ? " class='fixed'" : "")>
		<clock>
			<back>$(tb)</back>
			<front>$(tf)</front>
			<zoof style="opacity: 0">$(tz)</zoof>
		</clock>
		<button></button>
		<span>speed: </span>
		<input type="number" value="$(timer.interval)"  min=0 step=any lang="en-001">
		<span id="unit" title="Click to invert"></span>
	</timer>
	<script>
		const timer = this.querySelector("timer")
		const tpsInput = timer.querySelector("input")
		const clockfront = timer.querySelector("clock front")
		const clockzoof = timer.querySelector("clock zoof")
		const unit = timer.querySelector("span#unit")
		const button = timer.querySelector("button")
		var t = 1
		tpsInput.oninput = (e) => {
			
			var dt = tpsInput.valueAsNumber
			if(timer.classList.contains("inverted")){
				dt = 1.0 / dt
			}
			dt = (dt == Infinity || dt == 0) ? 1e9 : dt
			clockzoof.style.opacity = 0.8 - Math.pow(dt,.2)
			clockfront.style.animationDuration = dt + "s"
			e && e.stopPropagation()
		}
		tpsInput.oninput()
	
		clockfront.onanimationiteration = (e) => {
			t++
			timer.value = t
			timer.dispatchEvent(new CustomEvent("input"))
		}
		unit.onclick = (e) => {
			timer.classList.toggle("inverted")
			//tpsInput.value = 1.0 / tpsInput.valueAsNumber
			tpsInput.oninput()
		}
		button.onclick = (e) => {
			timer.classList.toggle("stopped")
			if(!timer.classList.contains("stopped")) {
				t = 1 - 1
			}
		}
		
	</script>
	<style>
		timer {
			display: flex;
			flex-direction: row;
		}
		timer > * {
			align-self: center;
			margin-right: .3rem;
		}
		clock {
			display: block;
			position: relative;
			overflow: hidden;
			width: 20px;
			height: 20px;
		}
		clock > * {
			display: block;
			width: 100%;
			height: 100%;
		}
		clock > * > svg { 
			width: 100%;
			height: 100%;
		}
		timer clock front, timer clock zoof {
			position: absolute;
			left: 0;
			top: 0;
			animation: 1s linear 🔁 infinite;
		}
		timer.stopped clock front {
			animation-play-state: paused;
		}
		timer.stopped clock zoof {
			display: none;
		}
		timer input {
			width: 3rem;
		}
		timer span {
			font-family: "Roboto Mono", monospace;
			font-size: .75rem;
    		word-spacing: -.2rem;
		}
		timer span#unit {
			font-style: italic;
			cursor: pointer;
		}
		timer span#unit::after {
			content: "secs / tick";
		}
		timer.inverted span#unit::after {
			content: "ticks / sec";
		}
		timer button {
			margin-left: 1rem;
			margin-right: 1rem;
		}
		timer button::after {
			content: "Stop";
		}
		timer.stopped button::after {
			content: "Start";
		}
		timer.fixed span,
		timer.fixed input {
			display: none;
		}
		@keyframes 🔁 {
			0% {
				transform: rotate(0deg);
			}
			100% {
				transform: rotate(360deg);
			}
		}
		</style>
	""")
end

# ╔═╡ 9dcece7c-89a5-11ea-1c0e-59c4203b52a7


# ╔═╡ 816ea402-7eae-11ea-2134-fb595cca3068
md""

# ╔═╡ ce7bec8c-7eae-11ea-0edb-ad27d2df059d
md"### Combining bonds

The `@bind` macro returns a `Bond` object, which can be used inside Markdown and HTML literals:"

# ╔═╡ fc99521c-7eae-11ea-269b-0d124b8cbe48
begin
	🐶slider = @bind 🐶 html"<input type='range'>"
	🐱slider = @bind 🐱 html"<input type='range'>"
	
	md"""**How many pets do you have?**
	
	Dogs: $(🐶slider)

	Cats: $(🐱slider)"""
end

# ╔═╡ 1cf27d7c-7eaf-11ea-3ee3-456ed1e930ea
md"You have $(🐶) dogs and $(🐱) cats!"

# ╔═╡ e3204b38-7eae-11ea-32be-39db6cc9faba
md""

# ╔═╡ 5301eb68-7f14-11ea-3ff6-1f075bf73955
md"### Input types

You can use _any_ DOM element that fires an `input` event. For example:"

# ╔═╡ c7203996-7f14-11ea-00a3-8192ccc54bd6
md"""
`a = ` $(@bind a html"<input type='range' >")

`b = ` $(@bind b html"<input type='text' >")

`c = ` $(@bind c html"<input type='button' value='Click'>")

`d = ` $(@bind d html"<input type='checkbox' >")

`e = ` $(@bind e html"<select><option value='one'>First</option><option value='two'>Second</option></select>")

`f = ` $(@bind f html"<input type='color' >")

"""

# ╔═╡ ede8009e-7f15-11ea-192a-a5c6135a9dcf
(a,b,c,d,e,f)

# ╔═╡ e2168b4c-7f32-11ea-355c-cf5932419a70
md"""**You can also use JavaScript to write more complicated input objects.** The `input` event can be triggered on any object using

```js
obj.dispatchEvent(new CustomEvent("input"))
```

Try drawing a rectangle in the canvas below 👇 and notice that the `area` variable updates."""

# ╔═╡ 7f4b0e1e-7f16-11ea-02d3-7955921a70bd
@bind dims html"""
<canvas id="drawboard" width="200" height="200"></canvas>

<script>
const canvas = document.querySelector("canvas#drawboard")
const ctx = canvas.getContext("2d")

var startX = 80
var startY = 40

function onmove(e){
	// 🐸 This is how we send the value back to Julia 🐸 //
	canvas.value = [e.layerX - startX, e.layerY - startY]
	canvas.dispatchEvent(new CustomEvent("input"))

	ctx.fillStyle = '#ffecec'
	ctx.fillRect(0, 0, 200, 200)
	ctx.fillStyle = '#3f3d6d'
	ctx.fillRect(startX, startY, ...canvas.value)
}

canvas.onmousedown = e => {
	startX = e.layerX
	startY = e.layerY
	canvas.onmousemove = onmove
}

canvas.onmouseup = e => {
	canvas.onmousemove = null
}

// To prevent this code block from showing and hiding
canvas.onclick = e => e.stopPropagation()

// Fire a fake mousemoveevent to show something
onmove({layerX: 130, layerY: 160})

</script>
"""

# ╔═╡ 5876b98e-7f32-11ea-1748-0bb47823cde1
area = abs(dims[1] * dims[2])

# ╔═╡ 72c7f60c-7f48-11ea-33d9-c5ea55a0ad1f
dims

# ╔═╡ d774fafa-7f34-11ea-290d-37805806e14b
md""

# ╔═╡ 8db857f8-7eae-11ea-3e53-058a953f2232
md"""## Can I use it?

The `@bind` macro is **built into Pluto.jl** — it works without having to install a package. 

You can use the (tiny) package [`PlutoUI`](https://github.com/fonsp/PlutoUI.jl) for some predefined `<input>` HTML codes. For example, you use `PlutoUI` to write

```julia
@bind x Slider(5:15)
```

instead of 

```julia
@bind x html"<input type='range' min='5' max'15'>"
```

_The `@bind` syntax in not limited to `html"..."` objects, but **can be used for any HTML-showable object!**_
"""

# ╔═╡ d5b3be4a-7f52-11ea-2fc7-a5835808207d
md"""#### More packages

In fact, **_any package_ can add bindable values to their objects**. For example, a geoplotting package could add a JS `input` event to their plot that contains the cursor coordinates when it is clicked. You can then use those coordinates inside Julia.

A package _does not need to add `Pluto.jl` as a dependency to so_: only the `Base.show(io, MIME("text/html"), obj)` function needs to be extended to contain a `<script>` that triggers the `input` event with a value. (It's up to the package creator _when_ and _what_.) This _does not affect_ how the object is displayed outside of Pluto.jl: uncaught events are ignored by your browser."""

# ╔═╡ 36ca3050-7f36-11ea-3caf-cb10e945ca99
md"""## Tips

#### Wrap large code blocks
If you have a large block of code that depends on a bound variable `t`, it will be faster to wrap that code inside a function `f(my_t)` (which depends on `my_t` instead of `t`), and then _call_ that function from another cell, with `t` as parameter.

This way, only the Julia code "`f(t)`" needs to be lowered and re-evaluated, instead of the entire code block."""

# ╔═╡ 03701e62-7f37-11ea-3b9a-d9d5ae2344e6
md"""#### Separate definition and reference

If you put a bond and a reference to the same variable together, it will keep evaluating in a loop.

So **do not** write
```julia
md""\"$(@bind r html"<input type='range'>")  $(r^2)""\"
```

Instead, create two cells:
```julia
md""\"$(@bind r html"<input type='range'>")""\"
```
```julia
r^2
```
"""

# ╔═╡ 55783466-7eb1-11ea-32d8-a97311229e93
md""

# ╔═╡ 582769e6-7eb1-11ea-077d-d9b4a3226aac
md"## Behind the scenes

#### What is x?

It's an **`Int64`**! Not an Observable, not a callback function, but simply _the latest value of the input element_.

The update mechanism is _lossy_ and _lazy_, which means that it will skip values if your code is still running - and **only send the latest value when your code is ready again**. This is important when changing a slider from `0` to `100`, for example. If it would send all intermediate values, it might take a while for your code to process everything, causing a noticable lag."

# ╔═╡ 8f829274-7eb1-11ea-3888-13c00b3ba70f
md"""#### What does the macro do?

The `@bind` macro turns an expression like

```julia
@bind x Slider(5:15)
```

into
```julia
begin
	local el = Slider(5:15)
	global x = if applicable(Base.peek, el)
		Base.peek(el)
	else
		missing
	end
	PlutoRunner.Bond(el, :x)
end
```

The `if` block in the middle assigns an initial value to `x`, which will be `missing`, unless an extension of `Base.peek` has been declared for the element. 

Declaring a default value using `Base.peek` is not necessary, as shown by the examples above, but the default value will be used for `x` if the `notebook.jl` file is _run as a plain julia file_, without Pluto's interactivity. The package `PlutoUI` defines default values.

"""

# ╔═╡ ced18648-7eb2-11ea-2052-07795685f0da
md"#### JavaScript?

Yes! We are using `Generator.input` from [`observablehq/stdlib`](https://github.com/observablehq/stdlib#Generators_input) to create a JS _Generator_ (kind of like an Observable) that listens to `onchange`, `onclick` or `oninput` events, [depending on the element type](https://github.com/observablehq/stdlib#Generators_input).

This makes it super easy to create nice HTML/JS-based interaction elements - a package creator simply has to write a `show` method for MIME type `text/html` that creates a DOM object that triggers the `input` event. In other words, _Pluto's `@bind` will behave exactly like `viewof` in observablehq_.

_If you want to make a cool new UI, go to [observablehq.com/@observablehq/introduction-to-views](https://observablehq.com/@observablehq/introduction-to-views) to learn how._"

# ╔═╡ dddb9f34-7f37-11ea-0abb-272ef1123d6f
md""

# ╔═╡ 23db0e90-7f35-11ea-1c05-115773b44afa
md""

# ╔═╡ f7555734-7f34-11ea-069a-6bb67e201bdc
md"That's it for now! Let us know what you think using the feedback button below! 👇"

# ╔═╡ 3be156d4-8a0a-11ea-1a4f-c95a1fd2b4c1
using PlutoUI

# ╔═╡ 3f95df48-8a0a-11ea-2380-494bca1ccfc3
@bind t3 PlutoUI.Timer()

# ╔═╡ 49c2e088-8a0a-11ea-1a62-cd8fd12803ba
t3

# ╔═╡ Cell order:
# ╠═b61aaff4-89fd-11ea-1b7d-bbf9d10c8327
# ╟─db24490e-7eac-11ea-094e-9d3fc8f22784
# ╠═bd24d02c-7eac-11ea-14ab-95021678e71e
# ╟─cf72c8a2-7ead-11ea-32b7-d31d5b2dacc2
# ╠═cb1fd532-7eac-11ea-307c-ab16b1977819
# ╠═d746a468-8a04-11ea-2a1f-d5eef9dd0b23
# ╠═89192fc0-89a5-11ea-0672-6f869a5951ea
# ╠═63621118-89a8-11ea-08e2-27f0ec350305
# ╠═9e497290-8986-11ea-0b02-17e42d1970fb
# ╠═c4ffcbea-89a5-11ea-1c6f-7558a8060ff6
# ╠═3be156d4-8a0a-11ea-1a4f-c95a1fd2b4c1
# ╠═49c2e088-8a0a-11ea-1a62-cd8fd12803ba
# ╟─3f95df48-8a0a-11ea-2380-494bca1ccfc3
# ╠═bc22de9a-89a5-11ea-140b-8b8f9d69a1dd
# ╠═29b41e06-8a0c-11ea-1ff9-3fd09f53d808
# ╠═afdde47c-89a5-11ea-0d5a-e741eaabff79
# ╠═aceb3ec4-8a05-11ea-0df9-890ddc329557
# ╠═350de788-8a06-11ea-24d5-d786fc362fc3
# ╠═80cff3d0-8989-11ea-064b-2b1c4b045c22
# ╠═9dcece7c-89a5-11ea-1c0e-59c4203b52a7
# ╟─816ea402-7eae-11ea-2134-fb595cca3068
# ╟─ce7bec8c-7eae-11ea-0edb-ad27d2df059d
# ╠═fc99521c-7eae-11ea-269b-0d124b8cbe48
# ╠═1cf27d7c-7eaf-11ea-3ee3-456ed1e930ea
# ╟─e3204b38-7eae-11ea-32be-39db6cc9faba
# ╟─5301eb68-7f14-11ea-3ff6-1f075bf73955
# ╟─c7203996-7f14-11ea-00a3-8192ccc54bd6
# ╠═ede8009e-7f15-11ea-192a-a5c6135a9dcf
# ╟─e2168b4c-7f32-11ea-355c-cf5932419a70
# ╟─7f4b0e1e-7f16-11ea-02d3-7955921a70bd
# ╠═5876b98e-7f32-11ea-1748-0bb47823cde1
# ╠═72c7f60c-7f48-11ea-33d9-c5ea55a0ad1f
# ╟─d774fafa-7f34-11ea-290d-37805806e14b
# ╟─8db857f8-7eae-11ea-3e53-058a953f2232
# ╟─d5b3be4a-7f52-11ea-2fc7-a5835808207d
# ╟─36ca3050-7f36-11ea-3caf-cb10e945ca99
# ╟─03701e62-7f37-11ea-3b9a-d9d5ae2344e6
# ╟─55783466-7eb1-11ea-32d8-a97311229e93
# ╟─582769e6-7eb1-11ea-077d-d9b4a3226aac
# ╟─8f829274-7eb1-11ea-3888-13c00b3ba70f
# ╟─ced18648-7eb2-11ea-2052-07795685f0da
# ╟─dddb9f34-7f37-11ea-0abb-272ef1123d6f
# ╟─23db0e90-7f35-11ea-1c05-115773b44afa
# ╟─f7555734-7f34-11ea-069a-6bb67e201bdc
