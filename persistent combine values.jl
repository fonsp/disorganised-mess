### A Pluto.jl notebook ###
# v0.17.5

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 32ab1f69-9e16-45ad-b44d-895a564178f4
import Pkg

# ╔═╡ 87796357-5df1-4a7a-928a-5df3527b956f
Pkg.activate()

# ╔═╡ 5922807c-6e49-11ec-3c79-87e011cbf088
using PlutoUI

# ╔═╡ a0ae55eb-5c18-451a-896d-325f09dba6cd
using HypertextLiteral

# ╔═╡ 76b5f036-6b70-4605-9063-f405b6b701fd
md"""
# TODO
- get secret_id from last Combine
- get last Combine, ideally during constructor
- get last bond value, during constructor or intial_value


Maybe

```julia
Bonds.incorporate_last_bond(
	just_created::T, 
	previous::T, 
	previous_value_from_js::Any
)::T

```
with default `(a,b)->a`
"""

# ╔═╡ d71251ee-ceaf-46e5-b93d-82472ee08b00
@bind x Slider(1:10)

# ╔═╡ aa01652d-7690-4462-8bae-2d77656abc8b
just_created_bond = Slider(1:10)

bond = APD.Bonds.incorporate_last_bond(just_created_bond, old_bond)


x = Bonds.initial_value(bond)

# let Pluto server know that :x is bound to `bond`

HTML("<pluto-bond for=x>$(bond)</pluto-bond>")

# ╔═╡ ebedad7d-764b-4eb1-9e6d-559a3c033cd0
all_names = [:fons, :hannes, :asdf_dsfsdf]

# ╔═╡ 8d1f6bd1-2d69-4685-8590-c5f93ef9b669
@bind chosen_names MultiCheckBox(all_names; default=all_names[1:2])

# ╔═╡ bfcf8d85-cc38-4346-ab9b-4ac99aac4d91
function skip_as_script(m::Module)
	if isdefined(m, :PlutoForceDisplay)
		return m.PlutoForceDisplay
	else
		isdefined(m, :PlutoRunner) && parentmodule(m) == Main
	end
end

# ╔═╡ d4a52691-6c69-4726-a119-499d6fb77fc1
"""
	@skip_as_script expression

Marks a expression as Pluto-only, which means that it won't be executed when running outside Pluto. Do not use this for your own projects.
"""
macro skip_as_script(ex) skip_as_script(__module__) ? esc(ex) : nothing end

# ╔═╡ 0605a0c5-1329-4e9b-916d-c74a132598e0
macro only_as_script(ex) skip_as_script(__module__) ? nothing : esc(ex) end

# ╔═╡ 8d1c2e47-3252-4e7b-9940-3c843e520cc6
struct A
	x
	y
end

# ╔═╡ 0691aa89-eac7-426e-a5c5-3cbd131f929b
A([1],2) == A([1],2)

# ╔═╡ a10d59e8-8dae-4796-a88b-4907437164f5
begin
	struct Parameters
		names::Vector{Symbol}
	end

	function Base.show(io::IO, m::MIME"text/html", ps::Parameters)
		
	end

end

# ╔═╡ 8335ad24-3ff8-4a74-862f-13a710d4acf8
Scrubbable(1:100) == Scrubbable(1:100)

# ╔═╡ afc4a320-575a-4660-977b-51804160d334
NumberField(1:100) == NumberField(1:100)

# ╔═╡ ec0eb9eb-6716-4648-b7c7-203bd71fa64f
Slider(1:100) == Slider(1:100)

# ╔═╡ 5ac241dc-7d04-46a5-943e-6830f745e798
Scrubbable(1) == Scrubbable(1)

# ╔═╡ 3c46ef54-0260-4269-b917-d14ce98a83f7
ha = @htl("""ab $(@htl("<em style=$((a=123, b=234))>asdf</em>")) c
<script>
let z = $(1+1)
</script>

""")

# ╔═╡ 68197884-858c-4f0c-b858-4f7f3b081ddc
hb = @htl("""ab $(@htl("<em style=$((a=123, b=234))>asdf</em>")) c
<script>
let z = $(1+1)
</script>

""")

# ╔═╡ aed9e41b-8e9c-41b5-83f0-7cabb7feaab0
ha == hb

# ╔═╡ dcb4786a-930a-4e8a-860a-a12c7e8726c6
ha === hb

# ╔═╡ 4b4f5148-4bb5-4c91-811b-f822f7d403c4
@htl("ab$(123)c").contents .== @htl("ab$(123)c").contents

# ╔═╡ e2234e7f-dbe1-4f95-9b51-04d20487f46a
"a" == "a"

# ╔═╡ 45986edf-1a65-4712-91b9-b79a408e0782


# ╔═╡ 7e9e418a-399e-4122-aab3-5f9d96e66301
@bind asdfsdf html"<input>"

# ╔═╡ 321969fb-ff25-4a74-a23e-0b2a761050e7
sleep(1); asdfsdf

# ╔═╡ dd5f2f46-f2f4-441b-b855-f6814a5b5b98
md"""
# Combine
"""

# ╔═╡ 172e4393-8b3e-434e-a20a-d7748214fc23
import AbstractPlutoDingetjes.Bonds

# ╔═╡ 25d15bbe-e29b-4383-ae47-d3ee744f80ed
import AbstractPlutoDingetjes

# ╔═╡ 8fb86e46-9b31-46a9-9bde-ad263f1bae8e
md"""
# Combining bonds
"""

# ╔═╡ 5590c2db-b49f-4116-a8a9-4ebab576e79c
md"""
## The magic
"""

# ╔═╡ 34cfe0dc-7bca-4c6f-99ce-96758ccbd3af
const set_input_value_compat = HypertextLiteral.JavaScript("""
(() => {
	let result = null
	try {
	result = setBoundElementValueLikePluto
} catch (e) {
	result = ((input, new_value) => {
	// fallback in case https://github.com/fonsp/Pluto.jl/pull/1755 is not available
    if (new_value == null) {
        //@ts-ignore
        input.value = new_value
        return
    }
    if (input instanceof HTMLInputElement) {
        switch (input.type) {
            case "range":
            case "number": {
                if (input.valueAsNumber !== new_value) {
                    input.valueAsNumber = new_value
                }
                return
            }
            case "date": {
                if (input.valueAsDate == null || Number(input.valueAsDate) !== Number(new_value)) {
                    input.valueAsDate = new_value
                }
                return
            }
            case "checkbox": {
                if (input.checked !== new_value) {
                    input.checked = new_value
                }
                return
            }
            case "file": {
                // Can't set files :(
                return
            }
        }
    } else if (input instanceof HTMLSelectElement && input.multiple) {
        for (let option of Array.from(input.options)) {
            option.selected = new_value.includes(option.value)
        }
        return
    }
    //@ts-ignore
    if (input.value !== new_value) {
        //@ts-ignore
        input.value = new_value
    }
})
}
return result
})()
""")

# ╔═╡ dbae3ed0-3e25-4878-bbc2-b11d480689bc
begin
	Base.@kwdef struct CombinedBonds
		display_content::Any
		captured_names::Union{Nothing,NTuple{N,Symbol} where N}
		captured_bonds::Vector{Any}
		secret_key::String
		try_persist_values::Bool
	end

	function Base.show(io::IO, m::MIME"text/html", cb::CombinedBonds)
		if !AbstractPlutoDingetjes.is_supported_by_display(io, Bonds.transform_value)
			return Base.show(io, m, HTML("<span>❌ You need to update Pluto to use this PlutoUI element.</span>"))
		end
		output = @htl(
			"""<span style='display: contents;'>$(
				cb.display_content
			)<script id=$("plutoui-combine")>

		let set_input_value = $(set_input_value_compat)
		
		const div = currentScript.parentElement
		let key = $(cb.secret_key)
		const inputs = div.querySelectorAll(`pl-combined-child[key='\${key}'] > *:first-child`)

		const names = $(cb.captured_names === nothing ? nothing : string.(cb.captured_names))
		const values = Array(inputs.length)
		const old_names = this?.names
		const old_values = this?.values
		const try_persist_values = $(cb.try_persist_values)

		console.info("this ", {old_names, names, old_values, values})

		try_persist_values && old_names != null && old_values != null && old_names.length === old_values.length && inputs.forEach((el,i) => {
			let old_index = old_names.indexOf(names[i])

			if(old_index !== -1){
				set_input_value(el, old_values[old_index])
			}
		})
		
		inputs.forEach(async (el,i) => {
			el.oninput = (e) => {
				e.stopPropagation()
			}
			const gen = Generators.input(el)
			while(true) {
				values[i] = await gen.next().value
				div.dispatchEvent(new CustomEvent("input", {}))
			}
		})
	
		Object.defineProperty(div, 'value', {
			get: () => values,
			set: (newvals) => {
				if(!newvals) {
					return
				}
				inputs.forEach((el, i) => {
					values[i] = newvals[i]
					set_input_value(el, newvals[i])
				})
		},
			configurable: true,
		});

		const return_dummy = document.createElement("span")
		return_dummy.names = names
		return_dummy.values = values
		return return_dummy

		</script></span>""")
		Base.show(io, m, output)
	end

	function Bonds.initial_value(cb::CombinedBonds)
		vals = tuple((Bonds.initial_value(b) for b in cb.captured_bonds)...)

		if cb.captured_names === nothing
			vals
		else
			NamedTuple{cb.captured_names}(vals)
		end
	end
	function Bonds.validate_value(cb::CombinedBonds, from_js)
		if from_js isa Vector && length(from_js) == length(cb.captured_bonds)
			all((
				Bonds.validate_value(bond, val_js)
				for (bond, val_js) in zip(cb.captured_bonds, from_js)
			))
		else
			false
		end
	end
	function Bonds.transform_value(cb::CombinedBonds, from_js)
		@assert from_js isa Vector
		@assert length(from_js) == length(cb.captured_bonds)

		vals = tuple((
			Bonds.transform_value(bond, val_js)
			for (bond, val_js) in zip(cb.captured_bonds, from_js)
		)...)

		if cb.captured_names === nothing
			vals
		else
			NamedTuple{cb.captured_names}(vals)
		end
		
		# [
		# 	Bonds.transform_value(bond, val_js)
		# 	for (bond, val_js) in zip(cb.captured_bonds, from_js)
		# ]
	end
	
	# TODO:
	# function Bonds.possible_values (cb::CombinedBonds, from_js)
	# end
	
end

# ╔═╡ f712f428-6da4-497d-85fe-a52069c8e294
begin
	local output = begin
	"""
	```julia
	RenderCallback(callback::Function, x::Any)
	```
	An HTML display passthrough of `x` (displays the same content), but when it is displayed, a callback function is invoked. `disable_callback!` can remove a callback.
	"""
	struct RenderCallback
		callback_ref::Ref{Union{Function,Nothing}}
		content::Any
	end
	end
			
	function disable_callback!(rc::RenderCallback)
		rc.callback_ref[] = nothing
	end
	function Base.show(io::IO, m::MIME"text/html", rc::RenderCallback)
		if rc.callback_ref[] !== nothing
			rc.callback_ref[]()
		end
		Base.show(io, m, rc.content)
	end
	output
end

# ╔═╡ 29b034d1-d1bf-4ddc-97fe-b5b9c7f6146a
"""
Same as `repr(MIME"text/html"(), x)` but the `IOContext` is set up to match the one used by Pluto to render. This means that if the object being rendered wants to use `AbstractPlutoDingetjes.is_supported_by_display`, they can.
"""
render_hmtl_with_pluto_display_features(x) = sprint() do io
	Base.show(
		IOContext(io, 
			:pluto_supported_integration_features => [
				AbstractPlutoDingetjes,
				AbstractPlutoDingetjes.Bonds,
				AbstractPlutoDingetjes.Bonds.initial_value,
				AbstractPlutoDingetjes.Bonds.transform_value,
				AbstractPlutoDingetjes.Bonds.possible_values,
			],
			:color => false, :limit => true, 
			:displaysize => (18, 88), :is_pluto => true, 
		),
		MIME"text/html"(),
		x
	)
end

# ╔═╡ accefce9-8508-495f-bb5e-6d3446e0c9a6
function _combine(f::Function; try_persist_values::Bool=false)
	key = String(rand('a':'z', 10))

	captured_names = Symbol[]
	captured_bonds = []

	function combined_child_element(x)
		@htl("""<pl-combined-child key=$(key) style='display: contents;'>$(x)</pl-combined-child>""")
	end

	
	created_callbacks = RenderCallback[]

	#=
	
	This is the function that will wrap around contained input elements.
	
	Besides wrapping the input inside a special HTML element 
	(with `combined_child_element`), it also secretly adds the element to 
	`captured_bonds`. 
	
	This allows us to know exactly which elements are contained in the combine,
	which we use for `Bonds.initial_value`, `Bonds.transform_value`, etc.
	
	This function could be a lot simpler:

	```
	function Child(x)
		push!(captured_bonds, x)
		combined_child_element(x)
	end
	```
	
	But instead, it's complicated!
	
	The reason is that we want to capture the combined bonds not in the order
	that they are wrapped (i.e. when `Child` is called), but in the order that they
	are **displayed** in, because this matches the order that our JavaScript code
	will find the special elements in.
	
	=#
	function Child(x)
		rc = RenderCallback(combined_child_element(x)) do
			# @info "Rendering" x stacktrace()
			push!(captured_bonds, x)
		end
		push!(created_callbacks, rc)
		rc
	end
	# the same, but with `name`
	function Child(name::Union{String,Symbol}, x)
		rc = RenderCallback(combined_child_element(x)) do
			push!(captured_bonds, x)
			push!(captured_names, Symbol(name))
		end
		push!(created_callbacks, rc)
		rc
	end

	# call the user's render function
	result = f(Child)

	# Trigger HTML display, which will also render the Child elements, and fire our callbacks.
	# We store the result because we don't want to re-render the contents every time the combine is rendered: if the displayed content contains lazy generators, then blablablalbl difficult but fixed now -fons
	display_html = render_hmtl_with_pluto_display_features(result)

	# @info "Captured" captured_bonds length(created_callbacks)
	
	# disable callbacks
	disable_callback!.(created_callbacks)
	
	# lets see what we got
	@assert isempty(captured_names) || length(captured_names) == length(captured_bonds) "Some children do not have a name. Make sure that all calls of `Child` provide two arguments."
	
	CombinedBonds(;
		secret_key = key,
		try_persist_values = try_persist_values,
		captured_names = isempty(captured_names) ? nothing : tuple(captured_names...),
		captured_bonds = captured_bonds,
		display_content = HTML(display_html),
	)
end

# ╔═╡ 37112cd7-4f1c-4d7b-8531-59a74db71451
"""
```julia
PlutoUI.combine(render_function::Function)
```

Combine multiple input elements into one. The combined values are sent to `@bind` as a single tuple.

`render_function` is a function that you write yourself, take a look at the examples below.

# Examples

## 🐶 & 🐱

We use the [`do` syntax](https://docs.julialang.org/en/v1/manual/functions/#Do-Block-Syntax-for-Function-Arguments) to write our `render_function`. The `Child` function is wrapped around each input, to let `combine` know which values to combine.

```julia
@bind values PlutoUI.combine() do Child
	md""\"
	# Hi there!

	I have \$(
		Child(Slider(1:10))
	) dogs and \$(
		Child(Slider(5:100))
	) cats.

	Would you like to see them? \$(Child(CheckBox(true)))
	""\"
end

values == (1, 5, true) # (initially)
```


> The output looks like:
> 
> ![screenshot of running the code above inside Pluto](https://user-images.githubusercontent.com/6933510/145589918-25a3c732-c02e-482b-831b-06131b283597.png)

## 🎏


The `combine` function is most useful when you want to generate your input elements _dynamically_. This example uses [HypertextLiteral.jl](https://github.com/MechanicalRabbit/HypertextLiteral.jl) for the `@htl` macro:

```julia
function wind_speeds(directions)
	PlutoUI.combine() do Child
		@htl(""\"
		<h6>Wind speeds</h6>
		<ul>
		\$([
			@htl("<li>\$(name): \$(Child(Slider(1:100)))</li>")
			for name in directions
		])
		</ul>
		""\")
	end
end

@bind speeds wind_speeds(["North", "East", "South", "West"])

speeds == (1, 1, 1, 1) # (initially)

# after moving the sliders:
speeds == (100, 36, 73, 60)
```

> The output looks like:
> 
> ![screenshot of running the code above inside Pluto](https://user-images.githubusercontent.com/6933510/145588612-14824654-5c73-45f8-983c-8913c7101a78.png)


# Named variant

In the last example, we used `Child` to wrap around contained inputs:
```julia
Child(Slider(1:100))
```
We can also use the **named variant**, which looks like:
```julia
Child("East", Slider(1:100))
```

When you use the *named variant* for all children, **the bound value will be `NamedTuple`, instead of a `Tuple`**.

Let's rewrite our example to use the *named variant*:

```julia
function wind_speeds(directions)
	PlutoUI.combine() do Child
		@htl(""\"
		<h6>Wind speeds</h6>
		<ul>
		\$([
			@htl("<li>\$(name): \$(Child(name, Slider(1:100)))</li>")
			for name in directions
		])
		</ul>
		""\")
	end
end

@bind speeds wind_speeds(["North", "East", "South", "West"])

speeds == (North=1, East=1, South=1, West=1) # (initially)

# after moving the sliders:
speeds == (North=100, East=36, South=73, West=60)

md"The Eastern wind speed is \$(speeds.East)."
```


> The output looks like:
> 
> ![screenshot of running the code above inside Pluto](https://user-images.githubusercontent.com/6933510/145615489-b3fb910d-0dc1-408b-882f-b05ca0129b18.gif)


# Why?
## You can make a new widget!
You can use `combine` to **create a brand new widget** yourself, by combining existing ones!

In the example above, we created a new widget called `wind_speeds`. You could **put this function in a package** (e.g. `WeatherUI.jl`) and people could use it like so:

```julia
import WeatherUI: wind_speeds

@bind speeds wind_speeds(["North", "East"])
```

In other words: you can use `combine` to create application-specific UI elements, and you can put those in your package!

## Difference with repeated `@bind`
The standard way to combine multiple inputs into one output is to use `@bind` multiple times. Our initial example could more easily be written as:
```julia
md""\"
# Hi there!

I have \$(@bind num_dogs Slider(1:10)) dogs and \$(@bind num_cats Slider(5:10)) cats.

Would you like to see them? \$(@bind want_to_see CheckBox(true))
""\"
```

The `combine` function is useful when you are generating inputs **dynamically**, like in our second example. This is useful when:
- The number of parameters is very large, and you don't want to write `@bind parameter1 ...`, `@bind parameter2 ...`, etc. 
- The number of parameters is dynamic! For example, you can load in a table in one cell, and then use `combine` in another cell to select which rows you want to use.

"""
combine(f::Function; kwargs...) = _combine(f; kwargs...)

# ╔═╡ c6f0b4b3-362c-4b61-8d3e-f7272e4a3f8e
function f(names)
	# Parameters(names)
	combine(try_persist_values=true) do Child
		@htl("""
		<table><caption><h3>Parameters</h3></caption>
	  <thead><tr><th>Name</th><th>value</th></thead>
		<tbody>
	  $((@htl("""
	  <tr><td>$(name)</td><td>$(Child(name, NumberField(0:.1:100)))</td></tr>
	""") for name in names))</tbody></table>
		""")
	end
end

# ╔═╡ 06d6f45a-3783-4b31-8926-ff0973bcc188
@bind vals f(chosen_names)

# ╔═╡ df2571b4-f42f-4609-be1f-0d5ae2dd0fb8
vals

# ╔═╡ 9919ed90-ba6d-48d6-8f73-b9b509e88843
ca = combine() do Child
	@htl("""
	Hello $(Child(Slider(1:100)))
	""")
end

# ╔═╡ c646e383-aebc-43ea-9c61-542166e5e455
Dump(ca)

# ╔═╡ 19a66a5a-fcd6-44dc-80de-c6c70674728b
cb = combine() do Child
	@htl("""
	Hello $(Child(Slider(1:100)))
	""")
end

# ╔═╡ 1f9e641c-e3d1-4c1c-9c8a-f25b2cf4106f
ca == cb

# ╔═╡ 9b705730-a68a-450f-99a8-11b7d302ebe0
ca === cb

# ╔═╡ a570d7ef-72e5-49dd-92bd-e3925c896a23
hash(ca), hash(cb)

# ╔═╡ ef6358be-4d53-42f0-8501-f7d7d3838781
export combine

# ╔═╡ 5366270a-4f63-4d8a-bc4f-de36c0895a8b
RenderCallback(@htl("hello")) do
	nothing
end

# ╔═╡ 24aa7b61-1c22-4d84-b19c-4ead65ae4615
let
	values = []
	rc = RenderCallback(@htl("asdf")) do
		push!(values, 123)
	end
	repr(MIME"text/html"(), rc)
	disable_callback!(rc)
	repr(MIME"text/html"(), rc)
	repr(MIME"text/html"(), rc)
	values
end

# ╔═╡ 0a47600f-62a6-4f75-bf30-7c9f45426ce1
md"""
## Examples
"""

# ╔═╡ 1fb3f5f0-6baf-418c-84bf-507579adb8be
@skip_as_script @bind values combine() do Child
	md"""
	# Hi there!

	I have $(Child(Slider(1:10))) dogs and $(Child(Slider(5:10))) cats.

	Would you like to see them? $(Child(CheckBox(true)))
	"""
end

# ╔═╡ 2c2036bd-2cea-4fe0-9f44-a6522826fdc3
@skip_as_script values

# ╔═╡ 33abfc8f-1590-45cd-9d3d-6a4cf211988d
@skip_as_script @bind speeds combine() do Child
	@htl("""
	<h3>Wind speeds</h3>
	<ul>
	$([
		@htl("<li>$(name): $(Child(Slider(1:100)))")
		for name in ["North", "East", "South", "West"]
	])
	</ul>
	""")
end

# ╔═╡ 845513d0-eb02-4c6a-bee9-56054d212d71
@skip_as_script speeds

# ╔═╡ c527b5f8-de42-4b96-9542-3bcc0a13372d
@skip_as_script @bind speeds_named combine() do Child
	@htl("""
	<h3>Wind speeds</h3>
	<ul>
	$([
		@htl("<li>$(name): $(Child(name, Slider(1:100)))")
		for name in ["North", "East", "South", "West"]
	])
	</ul>
	""")
end

# ╔═╡ 814502c7-e9e7-4401-8465-fd11c2807e07
@skip_as_script speeds_named

# ╔═╡ 28e73db2-6c80-44c5-94cd-d5a2cc7cd935
@skip_as_script rb = @bind together combine() do Child
	@htl("""
	<p>Hello world!</p>
	$(Child(TextField()))
	$(Child(Slider([sin, cos, tan])))
	$([
		Child(Scrubbable(7))
		for _ in 1:3
	])
	
	""")
end

# ╔═╡ 290974ad-8c0a-48b6-a691-74ba7dc2b0f8
@skip_as_script let
	sleep(.5)
	together
end

# ╔═╡ 4650374e-dae2-46cb-ba91-50200621bf08
@skip_as_script rb

# ╔═╡ 9bbe9030-86ae-490f-ae97-317ee3f05f47
md"""
## Tests
"""

# ╔═╡ 7a4716c5-07e3-49bc-bbcb-1cc38f58a053
md"""
### Initial value & transform
"""

# ╔═╡ b4409bf0-75fd-4745-b686-079193900c27
@skip_as_script begin
	it2vs = []
	it2b = @bind it2v combine() do Child

		z = Child(Slider(1:10))
		
		@htl("""
		<p>Hello world!</p>
		$(z)
		$(Child(Slider([sin, cos, tan])))
		$(z)
		
		""")
	end
end

# ╔═╡ 231442e3-a1bc-4285-8c23-045a9bb60d67
@skip_as_script push!(it2vs, it2v)

# ╔═╡ 4ada86e7-e310-471d-af45-f99310b6e223
@skip_as_script begin
	itvs = []
	itb = @bind itv combine() do Child
		@htl("""
		<p>Hello world!</p>
		$(Child(@htl("<input type=range>")))
		$(Child(Slider([sin, cos, tan])))
		
		""")
	end
end

# ╔═╡ 6533a616-d778-4870-98b2-445a48f6d145
# @skip_as_script itb

# ╔═╡ b338de96-b108-4cf5-921c-4ec71c4ee498
md"""
Should be `[[missing, sin], [50, sin]]`
"""

# ╔═╡ f061b4d3-dc3d-444c-a4d7-9e1f6d32f281
@skip_as_script push!(itvs, itv)

# ╔═╡ fab701a7-7a70-4cc5-a1ad-a143b9125bec
@skip_as_script begin
	☎️s = []
	☎️c = combine() do Child
		@htl("""
		$((
			Child(Slider(LinRange(rand(), rand()+1, 10))) for x in 1:5
		))
		""")
	end
	☎️b = @bind ☎️ ☎️c
end

# ╔═╡ addf4a56-5d85-4b5c-b956-8acacad79e5e
@skip_as_script ☎️c.captured_bonds

# ╔═╡ 7f70715b-b13c-4b72-93c3-5c2c4334b809
@skip_as_script push!(☎️s, ☎️)

# ╔═╡ 8a1b06d4-29fa-443d-a7c2-f7705f770cac
md"""
### Combine inside combine
"""

# ╔═╡ 0ac40588-fd45-4eef-89f1-b3552d0246a2
@skip_as_script cb1 = combine() do Child
	md"""
	Left: $(Child(:left, Slider(1:10))), right: $(Child(:right, Scrubbable(5)))
	"""
end

# ╔═╡ 3b18aa3a-4521-4b4c-9500-a5f95003aed5
@skip_as_script cb2b = @bind wowz combine() do Child
	md"""
	Do a thing: $(Child(CheckBox()))
	
	#### Up
	$(Child(cb1))

	#### Down
	$(Child(cb1))
	
	"""
end

# ╔═╡ 8143e4f0-8d66-4c64-9b4c-68954167e803
@skip_as_script wowz

# ╔═╡ 54ad28fe-ce9b-4984-9cf7-a65c3e3fec9a
@skip_as_script cb2b

# ╔═╡ Cell order:
# ╠═76b5f036-6b70-4605-9063-f405b6b701fd
# ╠═d71251ee-ceaf-46e5-b93d-82472ee08b00
# ╠═aa01652d-7690-4462-8bae-2d77656abc8b
# ╠═ebedad7d-764b-4eb1-9e6d-559a3c033cd0
# ╠═8d1f6bd1-2d69-4685-8590-c5f93ef9b669
# ╠═06d6f45a-3783-4b31-8926-ff0973bcc188
# ╠═df2571b4-f42f-4609-be1f-0d5ae2dd0fb8
# ╟─bfcf8d85-cc38-4346-ab9b-4ac99aac4d91
# ╟─d4a52691-6c69-4726-a119-499d6fb77fc1
# ╠═0605a0c5-1329-4e9b-916d-c74a132598e0
# ╠═32ab1f69-9e16-45ad-b44d-895a564178f4
# ╠═87796357-5df1-4a7a-928a-5df3527b956f
# ╠═5922807c-6e49-11ec-3c79-87e011cbf088
# ╠═a0ae55eb-5c18-451a-896d-325f09dba6cd
# ╠═8d1c2e47-3252-4e7b-9940-3c843e520cc6
# ╠═0691aa89-eac7-426e-a5c5-3cbd131f929b
# ╠═a10d59e8-8dae-4796-a88b-4907437164f5
# ╠═c6f0b4b3-362c-4b61-8d3e-f7272e4a3f8e
# ╠═8335ad24-3ff8-4a74-862f-13a710d4acf8
# ╠═afc4a320-575a-4660-977b-51804160d334
# ╠═ec0eb9eb-6716-4648-b7c7-203bd71fa64f
# ╠═5ac241dc-7d04-46a5-943e-6830f745e798
# ╠═9919ed90-ba6d-48d6-8f73-b9b509e88843
# ╠═19a66a5a-fcd6-44dc-80de-c6c70674728b
# ╠═1f9e641c-e3d1-4c1c-9c8a-f25b2cf4106f
# ╠═9b705730-a68a-450f-99a8-11b7d302ebe0
# ╠═a570d7ef-72e5-49dd-92bd-e3925c896a23
# ╠═c646e383-aebc-43ea-9c61-542166e5e455
# ╠═3c46ef54-0260-4269-b917-d14ce98a83f7
# ╠═68197884-858c-4f0c-b858-4f7f3b081ddc
# ╠═aed9e41b-8e9c-41b5-83f0-7cabb7feaab0
# ╠═dcb4786a-930a-4e8a-860a-a12c7e8726c6
# ╠═4b4f5148-4bb5-4c91-811b-f822f7d403c4
# ╠═e2234e7f-dbe1-4f95-9b51-04d20487f46a
# ╟─45986edf-1a65-4712-91b9-b79a408e0782
# ╠═7e9e418a-399e-4122-aab3-5f9d96e66301
# ╠═321969fb-ff25-4a74-a23e-0b2a761050e7
# ╟─dd5f2f46-f2f4-441b-b855-f6814a5b5b98
# ╠═172e4393-8b3e-434e-a20a-d7748214fc23
# ╠═25d15bbe-e29b-4383-ae47-d3ee744f80ed
# ╟─8fb86e46-9b31-46a9-9bde-ad263f1bae8e
# ╟─5590c2db-b49f-4116-a8a9-4ebab576e79c
# ╟─34cfe0dc-7bca-4c6f-99ce-96758ccbd3af
# ╟─f712f428-6da4-497d-85fe-a52069c8e294
# ╠═dbae3ed0-3e25-4878-bbc2-b11d480689bc
# ╠═29b034d1-d1bf-4ddc-97fe-b5b9c7f6146a
# ╠═accefce9-8508-495f-bb5e-6d3446e0c9a6
# ╠═37112cd7-4f1c-4d7b-8531-59a74db71451
# ╠═ef6358be-4d53-42f0-8501-f7d7d3838781
# ╠═5366270a-4f63-4d8a-bc4f-de36c0895a8b
# ╠═24aa7b61-1c22-4d84-b19c-4ead65ae4615
# ╠═0a47600f-62a6-4f75-bf30-7c9f45426ce1
# ╠═1fb3f5f0-6baf-418c-84bf-507579adb8be
# ╠═2c2036bd-2cea-4fe0-9f44-a6522826fdc3
# ╠═33abfc8f-1590-45cd-9d3d-6a4cf211988d
# ╠═845513d0-eb02-4c6a-bee9-56054d212d71
# ╠═c527b5f8-de42-4b96-9542-3bcc0a13372d
# ╠═814502c7-e9e7-4401-8465-fd11c2807e07
# ╠═28e73db2-6c80-44c5-94cd-d5a2cc7cd935
# ╠═290974ad-8c0a-48b6-a691-74ba7dc2b0f8
# ╠═4650374e-dae2-46cb-ba91-50200621bf08
# ╟─9bbe9030-86ae-490f-ae97-317ee3f05f47
# ╟─7a4716c5-07e3-49bc-bbcb-1cc38f58a053
# ╠═b4409bf0-75fd-4745-b686-079193900c27
# ╠═231442e3-a1bc-4285-8c23-045a9bb60d67
# ╠═4ada86e7-e310-471d-af45-f99310b6e223
# ╠═6533a616-d778-4870-98b2-445a48f6d145
# ╟─b338de96-b108-4cf5-921c-4ec71c4ee498
# ╠═f061b4d3-dc3d-444c-a4d7-9e1f6d32f281
# ╠═fab701a7-7a70-4cc5-a1ad-a143b9125bec
# ╠═addf4a56-5d85-4b5c-b956-8acacad79e5e
# ╠═7f70715b-b13c-4b72-93c3-5c2c4334b809
# ╠═8a1b06d4-29fa-443d-a7c2-f7705f770cac
# ╠═0ac40588-fd45-4eef-89f1-b3552d0246a2
# ╠═3b18aa3a-4521-4b4c-9500-a5f95003aed5
# ╠═8143e4f0-8d66-4c64-9b4c-68954167e803
# ╠═54ad28fe-ce9b-4984-9cf7-a65c3e3fec9a
