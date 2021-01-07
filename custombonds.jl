### A Pluto.jl notebook ###
# v0.7.7

using Markdown
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.peek, el) ? Base.peek(el) : missing
        el
    end
end

# ╔═╡ db24490e-7eac-11ea-094e-9d3fc8f22784
md"# Creating custom _bond_ objects

This guide covers how to create custom objects to be used with the `@bind` macro in Pluto.

_While you can **use `@bind` without understanding JavaScript** (with the [PlutoUI](https://github.com/fonsp/PlutoUI.jl) package, for example), creating custom object requires familiarity with JavaScript. If you want to learn JS - have a look at [the tutorials by Mozilla](https://developer.mozilla.org/en-US/docs/Web/javascript)._"

# ╔═╡ e3c514ec-800c-11ea-3338-23797b02d1c1
md"## HTML output

Before diving into interactivity, let's have a look at **how Pluto.jl turns Julia objects into pretty pixels on your screen**. 

Every Julia object can be used as argument for the `repr` function:"

# ╔═╡ 3b2c87d8-800d-11ea-0fc9-df606c4d7d56
repr(123)

# ╔═╡ 532280ea-800d-11ea-09e0-bb4d88bf5785
repr(3 ./ (1:3))

# ╔═╡ 586159e6-800d-11ea-0a20-2d635936b2e7
repr(md"Hi **Nick!**")

# ╔═╡ 6b61bfc2-800d-11ea-3573-81916dd3af39
md"""The `repr` function **turns anything into a human-readable `String`**. It is used in the Julia REPL to show the result of a command.
This basic representation format is called **`MIME("text/plain")`** - and every object can be shown in this format.

_Some_ objects can also be displayed in the **`MIME("text/html")`** format, which is _prettier_ ✨. You can tell `repr` which MIME type you want:"""

# ╔═╡ 64d986e4-800d-11ea-178b-3bba6b4fe9d7
repr(MIME("text/html"), md"Hi **Nick!**")

# ╔═╡ bf827794-800e-11ea-0854-8f8028f053cb
md"""> 🙋 _But that's not pretty!_

What you see is the _HTML representation_ of the Markdown object, _in its raw form_. When Pluto.jl calls `repr` internally, it uses this HTML code as the cell's output in this page, and your browser turns it into nice-looking text.

Right-click on the words "Hi Nick!" below, and click on _Inspect_. You'll see that the `<celloutput>` element contains the HTML code given by `repr`."""

# ╔═╡ 24662b06-800f-11ea-360f-93d63eaa7b59
md"Hi **Nick!**"

# ╔═╡ 823a0478-800f-11ea-202a-3d7b9d33d0d4
md"""
### HTML objects

One object that can be represented in the `MIME("text/html")` format is the `HTML` object:
"""

# ╔═╡ 40e63d24-8010-11ea-33bf-45bc7fc634f0
message = HTML("Wow <i>cool</i>")

# ╔═╡ 5906ede0-8010-11ea-3232-7f1895a993c1
repr(MIME("text/html"), message)

# ╔═╡ 63833472-8010-11ea-36ff-393db1a32349
dogs = HTML("""
	<img src='https://fonsp.com/img/doggoSmall.jpg?raw=true' width='150'></img>
	
	<p><i>Hannes & Floep</i></p>
""")

# ╔═╡ e57d16f0-8010-11ea-0230-47cbc45d14eb
first_slider = HTML("""
	<input type='range'>
""")

# ╔═╡ 4c05f892-8011-11ea-3c56-cb02c17fb180
md"""## The `@bind` macro

You can use `@bind` on anything that can be represented as `MIME("text/html")`:
"""

# ╔═╡ a917a120-8011-11ea-2d5d-b763ce210480
@bind uhm dogs

# ╔═╡ ce30a588-8011-11ea-047b-85e97bd21444
@bind first_val first_slider

# ╔═╡ c2a8f4a6-8011-11ea-3073-41e7e349e9f6
uhm

# ╔═╡ d99ec31e-8011-11ea-3f5f-bb39098fef54
first_val

# ╔═╡ de1c87e4-8011-11ea-2288-ff08658965f3
md"This will tell the JS front-end to **attach an event listener** to the given element, which will listen for the `input` event. Objects that don't emit this event (like the `<img>`) simply won't set a value to the bound variable.

On the Julia side, the `@bind` macro sets the variable to the initial value `missing`. HTML objects with a `value` property will use this value as initializer."

# ╔═╡ 1efc9bf2-8012-11ea-1e2a-3998a6b7465d
md"The `@bind` macro creates a **`Bond`** object:"

# ╔═╡ 18bd2ae0-8012-11ea-10ea-a7ab6ccaacf7
name_bond = @bind name html"<input>"

# ╔═╡ c52b128e-8011-11ea-2c4f-e1c62b8f039a
typeof(name_bond), typeof(name)

# ╔═╡ 22e53462-8013-11ea-0526-3b010c602281
md"""The `MIME("text/html")` representation of the above `Bond` is:"""

# ╔═╡ 52102eb0-8013-11ea-001c-456319af115f
repr(MIME("text/html"), name_bond)

# ╔═╡ 63f6b732-8013-11ea-2a71-ef9860197012
md"""This `<bond>` tag (which is normally ignored by browsers) is used to tell the JS front-end that its inner HTML should be watched for input events, and the `def` attribute tracks which `Bond` it is."""

# ╔═╡ a5c821dc-8013-11ea-1cc9-f1f5cfaff9e3
md"""## Input events

"""

# ╔═╡ 17464c2c-8013-11ea-2a98-49a5699f9316


# ╔═╡ cf72c8a2-7ead-11ea-32b7-d31d5b2dacc2
md"This syntax displays the HTML object as the cell's output, and uses its latest value as the definition of `x`. Of course, the variable `x` is _reactive_, and all references to `x` come to life ✨

_Try it out!_ 👆" 

# ╔═╡ cb1fd532-7eac-11ea-307c-ab16b1977819


# ╔═╡ c1b3ad56-8006-11ea-318c-c945cd6c2aa1
@bind fo html"""
<form id="form">
  <label>Test field: <input type="text"></label>
  <br><br>
  <button type="submit">Submit form</button>
</form>
"""

# ╔═╡ ea5baff4-8006-11ea-085d-a71e399761bb
fo

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

# ╔═╡ 0446b624-7ffb-11ea-104d-65cf5b4850ec


# ╔═╡ 98e2c49e-7ffd-11ea-1a56-e91cc7185541
@bind t html"""<script>

const span = observablehq.DOM.element("span")
span.innerText = "😀"
return span

</script>"""

# ╔═╡ abb4cb6e-7ffe-11ea-0199-8188f752885f
t

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

# ╔═╡ Cell order:
# ╟─db24490e-7eac-11ea-094e-9d3fc8f22784
# ╟─e3c514ec-800c-11ea-3338-23797b02d1c1
# ╠═3b2c87d8-800d-11ea-0fc9-df606c4d7d56
# ╠═532280ea-800d-11ea-09e0-bb4d88bf5785
# ╠═586159e6-800d-11ea-0a20-2d635936b2e7
# ╟─6b61bfc2-800d-11ea-3573-81916dd3af39
# ╠═64d986e4-800d-11ea-178b-3bba6b4fe9d7
# ╟─bf827794-800e-11ea-0854-8f8028f053cb
# ╠═24662b06-800f-11ea-360f-93d63eaa7b59
# ╟─823a0478-800f-11ea-202a-3d7b9d33d0d4
# ╠═40e63d24-8010-11ea-33bf-45bc7fc634f0
# ╠═5906ede0-8010-11ea-3232-7f1895a993c1
# ╠═63833472-8010-11ea-36ff-393db1a32349
# ╠═e57d16f0-8010-11ea-0230-47cbc45d14eb
# ╟─4c05f892-8011-11ea-3c56-cb02c17fb180
# ╠═a917a120-8011-11ea-2d5d-b763ce210480
# ╠═ce30a588-8011-11ea-047b-85e97bd21444
# ╠═c2a8f4a6-8011-11ea-3073-41e7e349e9f6
# ╠═d99ec31e-8011-11ea-3f5f-bb39098fef54
# ╟─de1c87e4-8011-11ea-2288-ff08658965f3
# ╟─1efc9bf2-8012-11ea-1e2a-3998a6b7465d
# ╠═18bd2ae0-8012-11ea-10ea-a7ab6ccaacf7
# ╠═c52b128e-8011-11ea-2c4f-e1c62b8f039a
# ╟─22e53462-8013-11ea-0526-3b010c602281
# ╟─52102eb0-8013-11ea-001c-456319af115f
# ╟─63f6b732-8013-11ea-2a71-ef9860197012
# ╠═a5c821dc-8013-11ea-1cc9-f1f5cfaff9e3
# ╠═17464c2c-8013-11ea-2a98-49a5699f9316
# ╟─cf72c8a2-7ead-11ea-32b7-d31d5b2dacc2
# ╠═cb1fd532-7eac-11ea-307c-ab16b1977819
# ╟─c1b3ad56-8006-11ea-318c-c945cd6c2aa1
# ╠═ea5baff4-8006-11ea-085d-a71e399761bb
# ╟─816ea402-7eae-11ea-2134-fb595cca3068
# ╟─ce7bec8c-7eae-11ea-0edb-ad27d2df059d
# ╠═fc99521c-7eae-11ea-269b-0d124b8cbe48
# ╠═1cf27d7c-7eaf-11ea-3ee3-456ed1e930ea
# ╟─e3204b38-7eae-11ea-32be-39db6cc9faba
# ╟─5301eb68-7f14-11ea-3ff6-1f075bf73955
# ╟─c7203996-7f14-11ea-00a3-8192ccc54bd6
# ╠═ede8009e-7f15-11ea-192a-a5c6135a9dcf
# ╟─e2168b4c-7f32-11ea-355c-cf5932419a70
# ╠═0446b624-7ffb-11ea-104d-65cf5b4850ec
# ╠═98e2c49e-7ffd-11ea-1a56-e91cc7185541
# ╠═abb4cb6e-7ffe-11ea-0199-8188f752885f
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
