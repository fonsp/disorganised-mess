### A Pluto.jl notebook ###
# v0.14.4

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

# ╔═╡ 285809d3-9a72-4eb6-9ebc-ddefd459ab6a
using HypertextLiteral

# ╔═╡ b16145b1-66da-4d96-a648-9e083c407e9a
using PlutoUI

# ╔═╡ 5c2cae00-cfad-43b8-9c36-3380809bb6bc
using Plots

# ╔═╡ ab02837b-79ec-40d7-bff1-c1d2dd7362ef
md"""
# PlutoTest.jl
"""

# ╔═╡ 5b801f8b-1320-4208-8819-571d0a6c8c36
md"""
This notebook introduces **visual testing**:
"""

# ╔═╡ c19b881b-24de-4628-8adc-4b1635dba543


# ╔═╡ 779a7207-c508-4764-89b0-bfae44d0765c


# ╔═╡ e46cf3e0-aa15-4c17-a925-3e9fc5109d54
Hannes = let
	url = "https://user-images.githubusercontent.com/6933510/116753174-fa40ab80-aa06-11eb-94d7-88f4171970b2.jpeg"
	data = read(download(url))
	PlutoUI.Show(MIME"image/jpg"(), data)
end;

# ╔═╡ 5b70aaf1-9623-4f55-b055-4263ed8be31d
Floep = let
	url = "https://user-images.githubusercontent.com/6933510/116753861-142ebe00-aa08-11eb-8ce8-684af1098935.jpeg"
	data = read(download(url))
	PlutoUI.Show(MIME"image/jpg"(), data)
end;

# ╔═╡ bf2abe01-6ae0-4066-8704-12f64e04511b
friends = Any[Hannes, Floep];

# ╔═╡ fd8428a3-9fa3-471a-8b2d-5bbb8fdb3137
is_good_boy(x) = true

# ╔═╡ 56347b7e-5007-45f8-8f6d-8ac8cc719637
md"""
Tests have _time-travel_ functionality built in! **Click on the tests above.**
"""

# ╔═╡ e5782dab-711b-4386-bc6a-8b2853b3f868
md"""
### Time travel
"""

# ╔═╡ 85c4575f-8466-4a42-a7b5-1b3346f60e38
md"""
This notebook contains **visual debugging**:
"""

# ╔═╡ ec1fd70a-d92a-4688-98b2-135879f07141
md"""
### (You need `Pluto#main` to run this notebook)
"""

# ╔═╡ c763ed72-82c9-445c-a8f7-a0c40982e4d9
TableOfContents()

# ╔═╡ 80b2fb3f-94b2-4024-94ff-d111a249c8b0
import Test

# ╔═╡ 05f42764-acfe-4370-b85b-ce0e7c4270d0
begin
	export test_nowarn, test_warn, test_logs, test_skip, test_broken, test_throws, test_deprecated
	
	var"@test_warn" = Test.var"@test_warn"
	var"@test_nowarn" = Test.var"@test_nowarn"
	var"@test_logs" = Test.var"@test_logs"
	var"@test_skip" = Test.var"@test_skip"
	var"@test_broken" = Test.var"@test_broken"
	var"@test_throws" = Test.var"@test_throws"
	var"@test_deprecated" = Test.var"@test_deprecated"
end

# ╔═╡ 0d70962a-3880-4dee-a439-35068d019f5a
md"""
# Type definitions
"""

# ╔═╡ 113cc425-e224-4f77-bfbd-ef4eb1d1ed70
abstract type TestResult end

# ╔═╡ 6188f559-bcab-4da6-84b2-a3fe522a5c3c
abstract type Fail <: TestResult end

# ╔═╡ c24b46ce-bcbb-4dc9-8a59-b5b1bd2cd617
abstract type Pass <: TestResult end

# ╔═╡ 5041085e-a406-4ed4-ab82-84d8f126cf0f
const Code = Any

# ╔═╡ 8c92bad9-234e-47dd-a599-b75dc6d5db89
# struct Correct <: Pass
# 	expr::Code
# end

# ╔═╡ 03ccd498-83c3-41bb-84d7-625adabd7aee
struct CorrectCall <: Pass
	expr::Code
	steps::Vector
end

# ╔═╡ 1bcf8bd1-c8a3-49a1-9791-d813aa856399
# struct Error <: Fail
# 	expr::Code
# 	error
# end

# ╔═╡ 656c4190-b49e-4225-869d-eeb7e8e41e72
# struct Wrong <: Fail
# 	expr::Code
# 	step
# end

# ╔═╡ 14c525a1-eca1-466b-8e63-3a90d7d7111c
struct WrongCall <: Fail
	expr::Code
	steps::Vector
end

# ╔═╡ a2efc968-246c-40c2-b285-2ec94b185a44
md"""
# Test macro
"""

# ╔═╡ bfe4dc61-9160-4c7e-8897-9c723b309adc
# function test(expr)
# 	if Meta.isexpr(expr, :call, 3) && expr.args[1] === :(==)
# 	quote
# 		expr_raw = $(QuoteNode(expr))
# 		try
# 			left = $(expr.args[2] |> esc)
# 			right = $(expr.args[3] |> esc)
			
# 			result = left == right
			
# 			if result === true
# 				Correct(expr_raw)
# 			elseif result === false
# 				WrongEquality(expr_raw, left, right)
# 			else
# 				Wrong(expr_raw, result)
# 			end
# 		catch e
# 			rethrow(e)
# 			# Error(expr_raw, e)
# 		end
# 	end
# 	end
# end

# ╔═╡ 7db7a1d5-a70b-4997-943e-963e6f5affc9
e = :(x == [1,2+2])

# ╔═╡ 9d49ea50-8158-4d8b-97af-edba1f7dc38b
x = [1,3]

# ╔═╡ a6f82260-3519-4254-a21e-abc7bb19ec4e
@bind howmuch Slider(0:100)

# ╔═╡ 1aa24b1c-e8ca-4de7-b614-7a3f02b4833d
always_false(args...; kwargs...) = false

# ╔═╡ c369b4b5-2fcf-4029-a1f6-352120b2fc4b
@bind n Slider(1:10)

# ╔═╡ 98992db9-4f14-4aa6-a7c5-477622266112
@bind k Slider(0:15)

# ╔═╡ 8a2e8348-49cf-4855-b5b3-cdee33e5ed67
html"""
<style>

pt-dot {
	flex: 0 0 auto;
	background: grey;
	width: 1em;
	height: 1em;
	bottom: -.1em;
	border-radius: 100%;
	margin-right: .7em;
	display: block;
	position: relative;
}


.fail > pt-dot {
	background: #f75d5d;

}
.pass > pt-dot {
	background: #56a038;

}


.pluto-test {
	font-family: "JuliaMono", monospace;
	font-size: 0.75rem;
padding: 4px;

min-height: 25px;
}


.pluto-test.pass {
	color: rgba(0,0,0,.5);
}

.pluto-test.fail {
background: linear-gradient(90deg, #ff2e2e14, transparent);
border-radius: 7px;
}


.pluto-test>.arg_result {
	flex: 0 0 auto;
}

.pluto-test>.arg_result>div,
.pluto-test>.arg_result>div>pluto-display>div {
	display: inline-flex;
}


.pluto-test>.comma {
	margin-right: .5em;
}

.pluto-test.call>code {
	padding: 0px;
}

.pluto-test.call.infix-operator>div {
	overflow-x: auto;
}

.pluto-test {
	display: flex;
	align-items: baseline;
}

.pluto-test.call.infix-operator>.fname {
	margin: 0px .6em;
	/*color: darkred;*/
}


/* expanding */


.pluto-test:not(.expanded) > p-frame-viewer > p-frame-controls {
	display: none;
	
}

.pluto-test.expanded > p-frame-viewer {
    max-width: 100%;
}
.pluto-test.expanded > p-frame-viewer > p-frames > slotted-code > line-like {
	flex-wrap: wrap;
}
.pluto-test.expanded > p-frame-viewer > p-frames > slotted-code > line-like > pluto-display[mime="application/vnd.pluto.tree+object"] {
	/*flex-basis: 100%;*/
}
"""

# ╔═╡ 4bc1b7a4-0a36-4a07-b7ee-3d5be50350e1
("asd"*"asd","asd","asd"*" asd","asd","asd"*"asd","asd","asd"*"asd","asd","asd"*"asd","asd","asd"*"asd","asd","asd"*"asd","asd")

# ╔═╡ 1ac164c8-88fc-4a87-a194-60ef616fb399
flatmap(args...) = vcat(map(args...)...)

# ╔═╡ e604cc80-5224-4579-a7b4-f194f1ac99b2
function commas(xs, comma=@htl("<span class='comma'>, </span>"))
	flatmap(enumerate(xs)) do (i,x)
		if i == length(xs)
			[x]
		else
			[x,comma]
		end
	end
end

# ╔═╡ 98ac4c36-49c7-4f65-982d-0b8bf6c372c0
emb = embed_display

# ╔═╡ 0fcc6cb0-2711-4609-9bf3-634cf9407840
div(x; class="", style="") = @htl("<div class=$(class) style=$(style)>$(x)</div>")

# ╔═╡ 69200d7c-b7bc-4c7e-a9a1-5e26979179a3
div(; class="", style="") = x -> @htl("<div class=$(class) style=$(style)>$(x)</div>")

# ╔═╡ a40800ef-2b1b-426e-8a1a-58dc5ba0f671


# ╔═╡ 4d5f44e4-85e9-4985-9b76-73be5e097186
remove_linenums(e::Expr) = if e.head === :macrocall
	Expr(e.head, (remove_linenums(x) for x in e.args)...)
else
	Expr(e.head, (remove_linenums(x) for x in e.args if !(x isa LineNumberNode))...)
end

# ╔═╡ dd495e00-d74d-47d4-a5d5-422fb147ec3b
remove_linenums(x) = x

# ╔═╡ ef6fc423-f1b1-4dcb-a059-276121391bc6
prettycolors(e) = Markdown.MD([Markdown.Code("julia", string(remove_linenums(e)))])

# ╔═╡ 9a7fbf1b-ade8-41dc-b4ff-c0df6cfd39d2
md"""
# DEbugging 1
"""

# ╔═╡ 04bbe79f-085e-401a-95bc-599b1df6acf5
function onestep(e::Expr; m=Module())
	results = Any[]
	# push!(results, e)
	
	arg_results = Any[a for a in e.args]
	
	for (i,a) in enumerate(e.args)
		arg_results[i] = if a isa QuoteNode
			a
		elseif (e.head === :call || e.head === :let) && i == 1
			a
		elseif a isa Expr
			inner_results = onestep(a; m=m)
			for ir in inner_results
				arg_results[i] = ir
				push!(results, Expr(e.head, arg_results...))
			end
			
			inner_results[end]
		else
			a
		end
		
		# push!(results, Expr(e.head, arg_results...))
	end
	
	push!(results, Core.eval(m, Expr(e.head, arg_results...)))
	results
end

# ╔═╡ 1611bbe7-aa3f-4bcf-ad82-c0907064ccc7
function expr_debug(x; )
	e = remove_linenums(x)
	
	Any[e, onestep(e)...]
end

# ╔═╡ a83a6a4c-664c-46fa-a07f-81088493dc35
const ObjectID = typeof(objectid("hello computer"))


# ╔═╡ 5cb03161-2cbc-4080-ba59-f94efd3b620c
expr_hash(e::Expr) = objectid(e.head) + mapreduce(p -> objectid((p[1], expr_hash(p[2]))), +, enumerate(e.args); init=zero(ObjectID))

# ╔═╡ 0611a36b-b4be-4b17-a485-7c4a8fa04927
expr_hash(x) = objectid(x)

# ╔═╡ 4aeb8c88-209a-4d00-b573-90d22501e97a
debug_result = expr_debug(:(
		
		let
			r = if rand(Bool)
				20
			else
				16
			end
		
			y = sqrt(4)
			
			y == sqrt(sqrt(r))
		end
		
	));

# ╔═╡ 43a86b76-35ca-42d4-a551-87890a4d3701
@bind step Slider(1:length(debug_result))

# ╔═╡ f6197004-c398-41a1-a560-75f22b267ab7
debug_result[step] |> prettycolors

# ╔═╡ dbfbcc16-c740-436c-bbf0-fee16b0a20c5
md"""
# Debugging 1.5
"""

# ╔═╡ a461f1fd-b5a5-4ae3-a47c-067a6081fb24
struct Computed
	x
end

# ╔═╡ 7783cb02-8887-4792-be68-f2fdb9c4b680
computed(x) = Computed(x)

# ╔═╡ a392d2d6-5a16-4383-b0ef-5003aa2de9fa
expand_computed(x) = x

# ╔═╡ ae95b691-f54b-4bf5-b17b-3e5bd1edf75e
expand_computed(c::Computed) = c.x

# ╔═╡ 12119016-fa61-4d38-8c58-821ea435df7d
expand_computed(e::Expr) = Expr(e.head, expand_computed.(e.args)...)

# ╔═╡ ef45af85-11f8-4505-9f1e-3ffb15a47142
onestep_light(x::Any; m=Module()) = [Computed(Core.eval(m,x))]

# ╔═╡ 450a36ea-2c43-4f01-a775-0b8c59bf6dca
function onestep_light(e::Expr; m=Module())
	results = Any[]
	
	# will be modified
	arg_results = Any[a for a in e.args]
	
	push_intermediate() = push!(results, Expr(e.head, arg_results...))

	if e.head === :call || e.head === :begin || e.head === :block

		for (i,a) in enumerate(e.args)
			
			if a isa QuoteNode
				a
				
			elseif (Meta.isexpr(e, :call) || Meta.isexpr(e, :let)) && i == 1
				a
				
			elseif a isa Symbol
				arg_results[i] = Computed(Core.eval(m,a))
				push_intermediate()
				
			elseif a isa Expr
				inner_results = onestep_light(a; m=m)
				for ir in inner_results
					arg_results[i] = ir
					push_intermediate()
				end

				arg_results[i] = inner_results[end]
			else
				a
			end
		end
	end
	
	push!(results, Computed(Core.eval(m, expand_computed(Expr(e.head, arg_results...)))))
	
	results
end

# ╔═╡ 8ef356ea-7d54-43e6-a936-7c8be04c595f
onestep_light(quote
		1+2
		2+3
		4+5
		sqrt(sqrt(sqrt(5)))
	end |> remove_linenums)

# ╔═╡ 88f6a040-07cf-47e0-a8be-2478ea350aa7
can_interpret(x) = true

# ╔═╡ d36a8a72-eced-4e63-9130-7fcb6c86df76
can_interpret_call_arg(e::Expr) = !(e.head === :(...) || e.head === :kw || e.head === :parameters)

# ╔═╡ e9659020-d433-4357-9099-71a65b66a091
can_interpret_call_arg(x) = true

# ╔═╡ c3fc3292-b7eb-4b01-8fba-159c86228de9
Meta.isbinaryoperator(:(==))

# ╔═╡ 89578bff-16b9-4eb2-b8ee-b2839ff2d74c
can_interpret(e::Expr) = if false
	false
elseif e.head === :call && !all(can_interpret_call_arg, e.args)
	false
# elseif e.head === :(=) || e.head === :macrocall
# 	false
else
	all(can_interpret, e.args)
end

# ╔═╡ a661e172-6afb-42ff-bd43-bb5b787ee5ed
macro eval_step_by_step(e)
	Computed
	onestep_light
	if can_interpret(e)
		quote
			Any[$(QuoteNode(e)), $(onestep_light(e; m=__module__))...]
		end
	else
		quote
			[$(QuoteNode(e)), Computed($(esc(e)))]
		end
	end
end

# ╔═╡ b6e8a170-12cc-4d97-905d-274e2609bfd8
function test(expr, extra_args...)
	var"@eval_step_by_step"
	Test.test_expr!("", expr, extra_args...)
	quote
		expr_raw = $(QuoteNode(expr))
		try
			steps = @eval_step_by_step($(expr))
			
# 			arg_results = [$((expr.args[2:end] .|> esc)...)]
			
# 			result = $(esc(:eval))(Expr(:call, $(expr.args[1] |> QuoteNode), arg_results...))
			
			result = expand_computed(last(steps))
			
			if result === true
				CorrectCall(expr_raw, steps)
			# elseif result === false
			# 	WrongCall(expr_raw, steps)
			else
				WrongCall(expr_raw, steps)
			end
		catch e
			rethrow(e)
			# Error(expr_raw, e)
		end
	end
end

# ╔═╡ 930f8244-cf25-4c1a-95f6-5c8963559c62
@eval_step_by_step x == [1,2]

# ╔═╡ 13e463c6-4afd-474e-abe2-a6e0fd57dfe5
remove_linenums( @macroexpand @eval_step_by_step sqrt(sqrt(3)) )

# ╔═╡ 68ba60db-44ad-43e4-b33e-d27696babc99
@eval_step_by_step sqrt(sqrt(length([1,2])))

# ╔═╡ 807bcd72-26c3-44d3-a295-56874cb51a89
@eval_step_by_step xasdf = 123

# ╔═╡ 8a5a4c26-e36c-4061-b32f-4448625ce4a6
xasdf

# ╔═╡ 21d4560e-721f-4ed4-9db7-86a8151ab22c
md"""
## Displaying
"""

# ╔═╡ f7cb57ba-df21-43be-8827-cfe11ab02d51


# ╔═╡ 03a849a9-3728-4b2d-afec-d2387d73516b
find_computed!(found, c::Computed) = push!(found, c)

# ╔═╡ 064b1250-bc11-48f2-8845-88910cc1ff96
find_computed!(found, expr::Expr) = find_computed!.([found], expr.args)

# ╔═╡ 5dfefa01-d568-47bc-a3ec-093eeed3da36
find_computed!(found, x) = nothing

# ╔═╡ dcab2eea-c454-4a70-9a91-6ee1e3113dc6
find_computed(x) = let
	r = Any[]
	find_computed!(r, x)
	r
end

# ╔═╡ 560dbf2b-c648-49aa-b774-11d367ac331d
onestep_light(quote
		1+2
		2+3
		4+5
		sqrt(sqrt(sqrt(5)))
	end |> remove_linenums) .|> find_computed

# ╔═╡ 4956526a-daf9-43c9-bff3-ff2446016e2e
slot!(found, c::Computed) = let
	k = Symbol("__slot", join(rand('a':'z', 16)), "__")
	found[k] = c
	k
end

# ╔═╡ 84ff6a23-c134-4910-b630-a7ad45f3bf29
slot!(found, x) = x

# ╔═╡ 318363d0-6d9e-4144-b478-b775f437edaf
slot!(found, e::Expr) = Expr(e.head, slot!.([found], e.args)...)

# ╔═╡ 67fd07b7-340b-4e24-bc06-e4c85b186872
slot(e) = let
	d = Dict{Symbol,Any}()
	new_e = slot!(d, e)
	d, new_e
end

# ╔═╡ 4edf747b-3838-4315-a397-e452ac9b5465
onestep_light(quote
		(1+2) + (7-6)
		2+3
		4+5
		sqrt(sqrt(sqrt(5)))
	end |> remove_linenums) .|> slot

# ╔═╡ 872b4877-30dd-4a92-a3c8-69eb50675dcb
preish(x) = @htl("<pre-ish>$(x)</pre-ish>")

# ╔═╡ 181ea2d1-dde8-4404-8c1f-843b182ba09d
function display_slotted(expr)
	
	d, e = slot(expr)
	
	
	s = string(e |> remove_linenums)
	lines = split(s, "\n")
	
	r = r"\_\_slot[a-z]{16}\_\_"
	
	@htl("""<slotted-code>
		$(
	map(lines) do l
		keys = [Symbol(m.match) for m in eachmatch(r, l)]
		rest = split(l, r; keepempty=true)
		
		result = vcat((
			[(isempty(r) ? @htl("") : preish(r)), embed_display(d[k].x)]
			for (r,k) in zip(rest, keys)
			)...)
		
		push!(result, preish(last(rest)))
		
		@htl("<line-like>$(result)</line-like>")
	end
	)
		</slotted-code>""")
end

# ╔═╡ d3b83bc1-cd48-4f35-9617-dc8fecd7e0f9
html"""
<style>
slotted-code {
	font-family: "JuliaMono", monospace;
	font-size: .75rem;
	display: flex;
	flex-direction: column;
}
pre-ish {
	white-space: pre;
}

line-like {
	display: flex;
	align-items: baseline;
}
"""

# ╔═╡ 3e1b28f1-6745-4deb-b88e-a11d3f8cbf58
# rs = @eval_step_by_step(begin
# 		(1+2) + (7-6)
# 		first(2000 .+ 30 .* rand(2+2))
# 		4+5
# 		sqrt(sqrt(sqrt(5)))
# 	end) .|> display_slotted

# ╔═╡ 6f5ba692-4b6a-405a-8cd3-1a8f9cc06611
plot(args...; kwargs...) = Plots.plot(args...; size=(100,100), kwargs...)

# ╔═╡ b4b317d7-bed1-489c-9650-8d336e330689
rs = @eval_step_by_step(begin
		(1+2) + (7-6)
		plot(2000 .+ 30 .* rand(2+2))
		4+5
		sqrt(sqrt(sqrt(5)))
	end) .|> display_slotted

# ╔═╡ 93ed973f-daf6-408b-9d4b-d53495418610
@bind rindex Slider(eachindex(rs))

# ╔═╡ dea898a0-1904-4d09-ad0b-6915008fe946
rs[rindex]

# ╔═╡ e968fc57-d850-4e2d-9410-8777d03b7b3c
function frames(fs)
	l = length(fs)
	
	startframe = l > 2 ? l - 1 : l
	
	@htl("""
		<p-frame-viewer>
		<p-frames>
		$(fs)
		</p-frames>
		
		<p-frame-controls>
		<img src="https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.0.0/src/svg/time-outline.svg" style="width: 1em; transform: scale(-1,1); opacity: .5; margin-left: 2em;">
		<input class="timescrub" style="filter: hue-rotate(149deg) grayscale(.9);" type=range min=1 max=$(l) value=$(startframe)>
		</p-frame-controls>
		
		
		<script>
		const div = currentScript.parentElement
		
		const input = div.querySelector("p-frame-controls > input.timescrub")
		const frames = div.querySelector("p-frames")
		
		const setviz = () => {
			Array.from(frames.children).forEach((f,i) => {
				f.style.display = i + 1 === input.valueAsNumber ? "inherit" : "none"
			})
		}
		
		setviz()
		
		input.addEventListener("input", setviz)
		
		</script>



		</p-frame-viewer>
		""")
	
	
	
end

# ╔═╡ 9c3f6eab-b1c3-4607-add8-d6d7e468c11a
begin
	macro test(expr...)
		test(expr...)
	end
	
	function Base.show(io::IO, m::MIME"text/html", call::Union{WrongCall,CorrectCall})
		

		infix = if Meta.isexpr(call.expr, :call)
			fname = call.expr.args[1]
			Meta.isbinaryoperator(fname)
		else
			false
		end
		
		classes = [
			"pluto-test", 
			"call",
			(isa(call,CorrectCall) ? "correct" : "wrong"),
			(isa(call,Pass) ? "pass" : "fail"),
			infix ? "infix-operator" : "prefix-operator",
			]
		
		result = @htl("""
		
		<div class=$(classes)>
			<script>
			
			const div = currentScript.parentElement
			div.addEventListener("click", (e) => {
				if(!div.classList.contains("expanded") || e.target.closest("pt-dot") != null){
					div.classList.toggle("expanded")
					e.stopPropagation()
				}
			})
			
			</script>
			<pt-dot></pt-dot>
		
			$(frames(display_slotted.( call.steps)))
		</div>
		
		
		
		""")
		Base.show(io, m, result)
	end
	
	
# 	function Base.show(io::IO, m::MIME"text/html", c::Correct)
		
		
# 		result = @htl("""
		
# 		<div class=$([
# 			"pluto-test", "pass", "correct",
# 			])>
# 			<pt-dot></pt-dot>
		
# 		<span>$((string(remove_linenums(c.expr))))</span>
# 		</div>
		
		
		
# 		""")
# 		Base.show(io, m, result)
# 	end
end

# ╔═╡ 73d74146-8f60-4388-aaba-0dfe4215cb5d
@test sqrt(20-11) == 3

# ╔═╡ 71b22e76-2b50-4d16-85f6-9dad0415630e
@test iseven(123 + 7^3)

# ╔═╡ 6762ed72-f422-43a9-a782-de78f739c0ae
@test 4+4 ∈ [1:7...]

# ╔═╡ f77275b9-90aa-4e07-a608-981b5df727af
@test is_good_boy(first(friends))

# ╔═╡ ac02b12a-3982-4526-a51c-0bf85198b81b
var"@test"; macroexpand(@__MODULE__, :(@test x == [1,2+2]); recursive=false) |> prettycolors

# ╔═╡ 26b0faf0-9016-48d7-8667-c1c1cfce655e
@test missing == 2

# ╔═╡ 26b4fb86-892f-415c-8046-6a5449052fd7
@test 2+2 == 2+2

# ╔═╡ eab4ba31-c787-46dd-8024-693eca7fd1a0
@test x == [1,2+2]

# ╔═╡ 96dc7b01-3766-4206-88ba-eca1665bc5cb
@test rand(50) == [rand(50),2]

# ╔═╡ 7c6ce205-053d-434c-b5b1-500babb8ec02
@test always_false(rand(howmuch), rand(howmuch),123)

# ╔═╡ fe7f8cce-a706-476d-8680-a2fe793b474f
@test !always_false(rand(2), rand(2),123)

# ╔═╡ 1872f785-1ae5-43ea-bce1-6c5cd893f3a8
@test !!always_false(rand(2), rand(2),123; r=123)

# ╔═╡ 5570972e-9309-4458-99a6-ea718ec2c3ab
@test always_false([1,2,3]...)

# ╔═╡ 8d340983-ea07-4038-872f-22a165003ed2
@test isless(2+2,1)

# ╔═╡ ea5a4fc0-db62-41dd-9600-a21d4eabf822
@test isless(1,2+2)

# ╔═╡ 4509cdbf-8b8b-4f70-9e63-bb972eb88c93
@test iseven(n^2)

# ╔═╡ 8360d1bc-b1f4-4263-a042-724cbd120227
@test 4+4 ∈ [1:k...]

# ╔═╡ 064e28de-0c22-48b5-b427-6eb343880287
@test isempty((1:k) .^ 2)

# ╔═╡ be93a6f4-b626-43db-a2fe-4e754e79c030
@test isempty([1,sqrt(2)])

# ╔═╡ 17bd5cd9-212f-4656-ab79-590dd6c64ff8
@test 1 ∈ [sqrt(20), 5:9...]

# ╔═╡ 539e2c38-993b-4b3b-8aa0-f02d46d79839
@test 1 ∈ rand(60)

# ╔═╡ 3d3f3592-e056-4e7b-8896-a75e5b5dcad6
@test rand(60) ∋ 1

# ╔═╡ bb770f3f-72dd-4a71-8d71-9e773224df05
t = @test always_false(rand(20), rand(20),123)

# ╔═╡ 22a33c8c-e07f-445e-9d8d-a676f704ec45
@test begin
	(1+2) - (3+4)
	false
end

# ╔═╡ 176f39f1-fa36-4ce1-86ba-76248848a834
@test (@test always_false(rand(3),rand(3),123)) isa Fail

# ╔═╡ 716bba60-bfbb-48a4-8924-8bf4e8958cb1
@test always_false("asd"*"asd","asd","asd"*" asd","asd","asd"*"asd","asd","asd"*"asd","asd","asd"*"asd","asd","asd"*"asd","asd","asd"*"asd","asd")

# ╔═╡ 3b2e8f55-1d4b-4a36-83f6-26becbd79e4b
@test (@test t isa Pass) isa Pass

# ╔═╡ 7c1aa057-dff2-48cd-aad5-1bbc1c0a729b
@test π ≈ 3.14 atol=0.01 rtol=1

# ╔═╡ fb34eed2-d428-43e8-8ee6-4d441115fde4
frames(rs)

# ╔═╡ 326f7661-3482-4bf2-a97b-57cc7ac60ee2
macro visual_debug(expr)
	frames
	display_slotted
	var"@eval_step_by_step"
	quote
		@eval_step_by_step($(expr)) .|> display_slotted |> frames
	end
end

# ╔═╡ d6c53f95-ea61-4aed-a469-76d0319d29de
@visual_debug begin
	(1+2) + (7-6)
	plot(2000 .+ 30 .* rand(2+2))
	4+5
	sqrt(sqrt(sqrt(5)))
	md"# Wow"
end

# ╔═╡ a2cbb0c3-23b9-4091-9ca7-5ba96e85e3a3
@visual_debug begin
	(1+2) + (7-6)
	plot(2000 .+ 30 .* rand(2+2))
	4+5
	sqrt(sqrt(sqrt(5)))
end

# ╔═╡ f9ed2487-a7f6-4ce9-b673-f8a298cd5fc3


# ╔═╡ 218504da-29d1-40b3-b3f6-534813efae7a


# ╔═╡ 3de910db-584c-4867-83c2-59390623eafb


# ╔═╡ 54ed587c-5526-46c0-a9cf-2110f5fc9a29


# ╔═╡ d1381f83-2165-4121-bae3-ed28241f90ef


# ╔═╡ aebe40a7-c0e4-412d-be4c-960ef173d394


# ╔═╡ Cell order:
# ╟─ab02837b-79ec-40d7-bff1-c1d2dd7362ef
# ╟─5b801f8b-1320-4208-8819-571d0a6c8c36
# ╠═73d74146-8f60-4388-aaba-0dfe4215cb5d
# ╠═71b22e76-2b50-4d16-85f6-9dad0415630e
# ╠═6762ed72-f422-43a9-a782-de78f739c0ae
# ╟─c19b881b-24de-4628-8adc-4b1635dba543
# ╟─779a7207-c508-4764-89b0-bfae44d0765c
# ╠═f77275b9-90aa-4e07-a608-981b5df727af
# ╠═bf2abe01-6ae0-4066-8704-12f64e04511b
# ╠═e46cf3e0-aa15-4c17-a925-3e9fc5109d54
# ╠═5b70aaf1-9623-4f55-b055-4263ed8be31d
# ╠═fd8428a3-9fa3-471a-8b2d-5bbb8fdb3137
# ╟─56347b7e-5007-45f8-8f6d-8ac8cc719637
# ╟─e5782dab-711b-4386-bc6a-8b2853b3f868
# ╟─85c4575f-8466-4a42-a7b5-1b3346f60e38
# ╠═d6c53f95-ea61-4aed-a469-76d0319d29de
# ╟─ec1fd70a-d92a-4688-98b2-135879f07141
# ╠═c763ed72-82c9-445c-a8f7-a0c40982e4d9
# ╠═285809d3-9a72-4eb6-9ebc-ddefd459ab6a
# ╠═b16145b1-66da-4d96-a648-9e083c407e9a
# ╠═80b2fb3f-94b2-4024-94ff-d111a249c8b0
# ╠═05f42764-acfe-4370-b85b-ce0e7c4270d0
# ╟─0d70962a-3880-4dee-a439-35068d019f5a
# ╠═113cc425-e224-4f77-bfbd-ef4eb1d1ed70
# ╠═6188f559-bcab-4da6-84b2-a3fe522a5c3c
# ╠═c24b46ce-bcbb-4dc9-8a59-b5b1bd2cd617
# ╠═5041085e-a406-4ed4-ab82-84d8f126cf0f
# ╠═8c92bad9-234e-47dd-a599-b75dc6d5db89
# ╠═03ccd498-83c3-41bb-84d7-625adabd7aee
# ╠═1bcf8bd1-c8a3-49a1-9791-d813aa856399
# ╠═656c4190-b49e-4225-869d-eeb7e8e41e72
# ╠═14c525a1-eca1-466b-8e63-3a90d7d7111c
# ╟─a2efc968-246c-40c2-b285-2ec94b185a44
# ╠═b6e8a170-12cc-4d97-905d-274e2609bfd8
# ╟─bfe4dc61-9160-4c7e-8897-9c723b309adc
# ╠═ac02b12a-3982-4526-a51c-0bf85198b81b
# ╠═7db7a1d5-a70b-4997-943e-963e6f5affc9
# ╠═9d49ea50-8158-4d8b-97af-edba1f7dc38b
# ╠═26b0faf0-9016-48d7-8667-c1c1cfce655e
# ╠═26b4fb86-892f-415c-8046-6a5449052fd7
# ╟─eab4ba31-c787-46dd-8024-693eca7fd1a0
# ╠═96dc7b01-3766-4206-88ba-eca1665bc5cb
# ╠═7c6ce205-053d-434c-b5b1-500babb8ec02
# ╠═a6f82260-3519-4254-a21e-abc7bb19ec4e
# ╠═fe7f8cce-a706-476d-8680-a2fe793b474f
# ╠═1872f785-1ae5-43ea-bce1-6c5cd893f3a8
# ╠═5570972e-9309-4458-99a6-ea718ec2c3ab
# ╠═1aa24b1c-e8ca-4de7-b614-7a3f02b4833d
# ╠═8d340983-ea07-4038-872f-22a165003ed2
# ╠═ea5a4fc0-db62-41dd-9600-a21d4eabf822
# ╠═c369b4b5-2fcf-4029-a1f6-352120b2fc4b
# ╠═4509cdbf-8b8b-4f70-9e63-bb972eb88c93
# ╠═98992db9-4f14-4aa6-a7c5-477622266112
# ╠═8360d1bc-b1f4-4263-a042-724cbd120227
# ╠═064e28de-0c22-48b5-b427-6eb343880287
# ╠═be93a6f4-b626-43db-a2fe-4e754e79c030
# ╟─17bd5cd9-212f-4656-ab79-590dd6c64ff8
# ╟─539e2c38-993b-4b3b-8aa0-f02d46d79839
# ╟─3d3f3592-e056-4e7b-8896-a75e5b5dcad6
# ╠═8a2e8348-49cf-4855-b5b3-cdee33e5ed67
# ╠═bb770f3f-72dd-4a71-8d71-9e773224df05
# ╠═22a33c8c-e07f-445e-9d8d-a676f704ec45
# ╠═176f39f1-fa36-4ce1-86ba-76248848a834
# ╠═716bba60-bfbb-48a4-8924-8bf4e8958cb1
# ╠═4bc1b7a4-0a36-4a07-b7ee-3d5be50350e1
# ╠═3b2e8f55-1d4b-4a36-83f6-26becbd79e4b
# ╠═7c1aa057-dff2-48cd-aad5-1bbc1c0a729b
# ╠═9c3f6eab-b1c3-4607-add8-d6d7e468c11a
# ╠═1ac164c8-88fc-4a87-a194-60ef616fb399
# ╠═e604cc80-5224-4579-a7b4-f194f1ac99b2
# ╠═98ac4c36-49c7-4f65-982d-0b8bf6c372c0
# ╠═0fcc6cb0-2711-4609-9bf3-634cf9407840
# ╠═69200d7c-b7bc-4c7e-a9a1-5e26979179a3
# ╠═a40800ef-2b1b-426e-8a1a-58dc5ba0f671
# ╠═ef6fc423-f1b1-4dcb-a059-276121391bc6
# ╠═4d5f44e4-85e9-4985-9b76-73be5e097186
# ╠═dd495e00-d74d-47d4-a5d5-422fb147ec3b
# ╠═9a7fbf1b-ade8-41dc-b4ff-c0df6cfd39d2
# ╠═04bbe79f-085e-401a-95bc-599b1df6acf5
# ╠═1611bbe7-aa3f-4bcf-ad82-c0907064ccc7
# ╟─a83a6a4c-664c-46fa-a07f-81088493dc35
# ╟─5cb03161-2cbc-4080-ba59-f94efd3b620c
# ╟─0611a36b-b4be-4b17-a485-7c4a8fa04927
# ╠═4aeb8c88-209a-4d00-b573-90d22501e97a
# ╠═43a86b76-35ca-42d4-a551-87890a4d3701
# ╠═f6197004-c398-41a1-a560-75f22b267ab7
# ╠═dbfbcc16-c740-436c-bbf0-fee16b0a20c5
# ╠═a461f1fd-b5a5-4ae3-a47c-067a6081fb24
# ╠═7783cb02-8887-4792-be68-f2fdb9c4b680
# ╠═a392d2d6-5a16-4383-b0ef-5003aa2de9fa
# ╠═ae95b691-f54b-4bf5-b17b-3e5bd1edf75e
# ╠═12119016-fa61-4d38-8c58-821ea435df7d
# ╠═ef45af85-11f8-4505-9f1e-3ffb15a47142
# ╠═450a36ea-2c43-4f01-a775-0b8c59bf6dca
# ╠═a661e172-6afb-42ff-bd43-bb5b787ee5ed
# ╠═930f8244-cf25-4c1a-95f6-5c8963559c62
# ╠═13e463c6-4afd-474e-abe2-a6e0fd57dfe5
# ╠═68ba60db-44ad-43e4-b33e-d27696babc99
# ╠═807bcd72-26c3-44d3-a295-56874cb51a89
# ╠═8a5a4c26-e36c-4061-b32f-4448625ce4a6
# ╠═8ef356ea-7d54-43e6-a936-7c8be04c595f
# ╠═88f6a040-07cf-47e0-a8be-2478ea350aa7
# ╠═d36a8a72-eced-4e63-9130-7fcb6c86df76
# ╠═e9659020-d433-4357-9099-71a65b66a091
# ╠═c3fc3292-b7eb-4b01-8fba-159c86228de9
# ╠═89578bff-16b9-4eb2-b8ee-b2839ff2d74c
# ╟─21d4560e-721f-4ed4-9db7-86a8151ab22c
# ╠═f7cb57ba-df21-43be-8827-cfe11ab02d51
# ╠═03a849a9-3728-4b2d-afec-d2387d73516b
# ╠═064b1250-bc11-48f2-8845-88910cc1ff96
# ╠═5dfefa01-d568-47bc-a3ec-093eeed3da36
# ╠═dcab2eea-c454-4a70-9a91-6ee1e3113dc6
# ╠═560dbf2b-c648-49aa-b774-11d367ac331d
# ╠═4956526a-daf9-43c9-bff3-ff2446016e2e
# ╠═84ff6a23-c134-4910-b630-a7ad45f3bf29
# ╠═318363d0-6d9e-4144-b478-b775f437edaf
# ╠═67fd07b7-340b-4e24-bc06-e4c85b186872
# ╠═4edf747b-3838-4315-a397-e452ac9b5465
# ╠═872b4877-30dd-4a92-a3c8-69eb50675dcb
# ╠═181ea2d1-dde8-4404-8c1f-843b182ba09d
# ╠═d3b83bc1-cd48-4f35-9617-dc8fecd7e0f9
# ╠═3e1b28f1-6745-4deb-b88e-a11d3f8cbf58
# ╠═5c2cae00-cfad-43b8-9c36-3380809bb6bc
# ╠═6f5ba692-4b6a-405a-8cd3-1a8f9cc06611
# ╠═b4b317d7-bed1-489c-9650-8d336e330689
# ╠═93ed973f-daf6-408b-9d4b-d53495418610
# ╠═dea898a0-1904-4d09-ad0b-6915008fe946
# ╠═fb34eed2-d428-43e8-8ee6-4d441115fde4
# ╠═326f7661-3482-4bf2-a97b-57cc7ac60ee2
# ╠═a2cbb0c3-23b9-4091-9ca7-5ba96e85e3a3
# ╠═e968fc57-d850-4e2d-9410-8777d03b7b3c
# ╟─f9ed2487-a7f6-4ce9-b673-f8a298cd5fc3
# ╟─218504da-29d1-40b3-b3f6-534813efae7a
# ╟─3de910db-584c-4867-83c2-59390623eafb
# ╟─54ed587c-5526-46c0-a9cf-2110f5fc9a29
# ╟─d1381f83-2165-4121-bae3-ed28241f90ef
# ╟─aebe40a7-c0e4-412d-be4c-960ef173d394
