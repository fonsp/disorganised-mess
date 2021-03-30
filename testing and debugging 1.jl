### A Pluto.jl notebook ###
# v0.14.0

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

# ╔═╡ a5fca87d-3041-4c8a-9cfb-2dbf203da7a5
using PlutoUI

# ╔═╡ e55d1cea-2de1-11eb-0d0e-c95009eedc34
md"## Testing"

# ╔═╡ e598832a-2de1-11eb-3831-371aa2e54828
abstract type TestResult end

# ╔═╡ e5b46afe-2de1-11eb-0de5-6d571c0fbbcf
const Code = Any

# ╔═╡ e5dbaf38-2de1-11eb-13a9-a994ac40bf9f
struct Pass <: TestResult
	expr::Code
end

# ╔═╡ e616c708-2de1-11eb-2e66-f972030a7ec5
abstract type Fail <: TestResult end

# ╔═╡ e6501fda-2de1-11eb-33ba-4bb34dc13d00
struct Wrong <: Fail
	expr::Code
	result
	arg_results
end

# ╔═╡ e66c8454-2de1-11eb-1d79-499e6873d0d2
struct Error <: Fail
	expr::Code
	error
end

# ╔═╡ e699ae9a-2de1-11eb-3ff0-c31222ac399e
function Base.show(io::IO, mime::MIME"text/html", value::Pass)
	show(io, mime, HTML("""
		<div
			style="
				display: flex;
				flex-direction: row;
				align-items: center;
				/*background-color: rgb(208, 255, 209)*/
			"
		>
			<div
				style="
					width: 12px;
					height: 12px;
					border-radius: 50%;
					background-color: green;
				"
			></div>
			<div style="min-width: 12px"></div>
			<code
				class="language-julia"
				style="
					flex: 1;
					background-color: transparent;
					filter: grayscale(1) brightness(0.8);
				"
			>$(value.expr)</code>
		</div>
	"""))
end

# ╔═╡ e6c17fae-2de1-11eb-1397-1b1cdfcc387c
function Base.show(io::IO, mime::MIME"text/html", value::Wrong)
	show(io, mime, HTML("""
		<div
			style="
				display: flex;
				flex-direction: row;
				align-items: center;
				/*background-color: rgb(208, 255, 209)*/
			"
		>
			<div
				style="
					width: 12px;
					height: 12px;
					border-radius: 50%;
					background-color: red;
				"
			></div>
			<div style="min-width: 12px"></div>
			<code
				class="language-julia"
				style="
					flex: 1;
					background-color: transparent;
					filter: grayscale(1) brightness(0.8);
				"
			>$(value.expr)</code>
				<div style="
					font-family: monospace;
					font-size: 12px;
					color: red;
					padding-left: 8px;
				">Evaluated: $(string(Expr(value.expr.head, value.arg_results...)))</div>
		</div>
	"""))
end

# ╔═╡ e705bd90-2de1-11eb-3759-3d59a90e6e44
function Base.show(io::IO, mime::MIME"text/html", value::Error)
	show(io, mime, HTML("""
		<div
			style="
				display: flex;
				flex-direction: row;
				align-items: center;
				/*background-color: rgb(208, 255, 209)*/
			"
		>
			<div
				style="
					width: 12px;
					height: 12px;
					border-radius: 50%;
					background-color: red;
				"
			></div>
			<div style="width: 12px"></div>
			<div>
				<code
					class="language-julia"
					style="
						background-color: transparent;
						filter: grayscale(1) brightness(0.8);
					"
				>$(value.expr)</code>
				<div style="
					font-family: monospace;
					font-size: 12px;
					color: red;
					padding-left: 8px;
				">Error: $(sprint(showerror, value.error))</div>
			</div>
			
		</div>
	"""))
end

# ╔═╡ 7c35f88d-7740-4bc3-9ab6-855cc78223e2
quote
	a == :a
end |> Dump

# ╔═╡ c672db23-a0bc-46af-ad1e-51114ed2bf98


# ╔═╡ 173161a6-f6ee-4515-b9e5-3a775cde6e5d
let
	e = :(sqrt.([5]))
	
	arg_results = [eval(a) for a in e.args]
	
	eval(Expr(e.head, arg_results...))
end

# ╔═╡ 8ae5aaad-d164-48f4-bff9-c81ec0e03422
staged_eval(e) = eval(e)

# ╔═╡ a92f7b4e-dde2-4c26-84e0-18c31a5b59f3
function staged_eval(e::Expr)
	if e.head == :call
		arg_results = Any[
			if a isa QuoteNode
				QuoteNode(a)
			elseif i == 1
				a
			else
				eval(a)
			end 
				for (i,a) in enumerate(e.args)]
		
		arg_results[1] = e.args[1]
		
		printable_arg_results = [
			if a isa QuoteNode
				a.value
			else
				a
			end 
				for a in arg_results]
		
		eval(Expr(e.head, arg_results...)), arg_results, Expr(e.head, printable_arg_results...)
	else
		eval(e), nothing
	end
end

# ╔═╡ f0ba5c43-91e5-42d7-b904-72921acd356e
eval_args(x) = x

# ╔═╡ fabb85e3-aee1-4765-b6a5-1b5dd4e63325
quote_again(x) = x

# ╔═╡ 27e557d5-6ecb-412b-a675-98fc9ba271d4
quote_again(x::QuoteNode) = QuoteNode(x)

# ╔═╡ 91356a1a-4230-4608-9d19-f18f9cb8f72b
function eval_args(e::Expr)
	if e.head == :call
		arg_results = Any[
			if a isa QuoteNode
				QuoteNode(a)
			elseif i == 1
				a
			else
				eval(a)
			end 
				for (i,a) in enumerate(e.args)]
		
		arg_results[1] = e.args[1]
		
		printable_arg_results = [
			if a isa QuoteNode
				a.value
			else
				a
			end 
				for a in arg_results]
		
		Expr(e.head, printable_arg_results...)
	else
		eval(e)
	end
end

# ╔═╡ e1378f25-9191-4732-bb58-f1656211ea3a
onestep(x; m) = []

# ╔═╡ a291172a-82da-4bdc-92ed-b4ac1e91c497
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

# ╔═╡ 7b258650-babf-4eb8-9167-4aec7ad98a44
function expr_debug(x)
	e = Base.remove_linenums!(deepcopy(x))
	
	Any[e, onestep(e)...]
end

# ╔═╡ 86163fc5-563a-4663-a087-6fdff099b4d5
expr_debug(quote
		let
			
		end
	end)

# ╔═╡ 61df7ab9-a983-4756-8bc4-a80382908d19
eval(Expr(:let, Expr(:block), nothing))

# ╔═╡ fdbf2a78-07de-4d09-9b31-d79e4c19e211
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

# ╔═╡ c8e16361-662d-49fc-b4ae-534b15cc0b9d
@bind step Slider(1:length(debug_result))

# ╔═╡ f696bf5e-9717-498e-8435-bb7f47e3e3f0
html"""
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
"""

# ╔═╡ 7671aecb-95d1-4326-8b39-67d301aeb137
prettycolors(e) = Markdown.MD([Markdown.Code("julia", string(e))])

# ╔═╡ 1fdb32dc-638f-42cd-a71d-5436dbca1d99
debug_result[step] |> prettycolors

# ╔═╡ 63f6bfd6-c654-4050-9557-8db41bbffe8c
Dump(debug_result[step]; maxdepth=999)

# ╔═╡ f23fe2ff-c462-42d9-935d-1dab08149697
staged_eval(:(a == :a))

# ╔═╡ 230b7fce-fba7-4299-80b3-1deaec026348
staged_eval(:(a == a))

# ╔═╡ 3aeecfd7-b06b-408d-86b7-4719340f1e1e
staged_eval(:(a .== a))

# ╔═╡ b638beed-1c9d-4804-a91a-05f3e97d8bcc
staged_eval(:(sqrt(sqrt(4))))

# ╔═╡ b6b1ef79-c802-49b5-8458-8d2b4ee3a7c0
staged_eval(:(sqrt.(5)))

# ╔═╡ c18d6786-a164-4a59-b766-ee5e7edc996c
e = :(sqrt.(5))

# ╔═╡ 6820f187-5c12-406a-b797-b9a449dca9eb
Dump(e)

# ╔═╡ 4b5c355c-6b17-48e2-8436-3d0397d590e0
.==

# ╔═╡ a9625447-da72-4ce4-890a-518635a1b6ef
eval(Meta.parse(".=="))

# ╔═╡ bf7ba6ca-5e57-42f7-8ae3-2a5add69e740
eval(Symbol(".=="))

# ╔═╡ 6f852f7c-3594-435f-b579-c92c8c2fc09b
eval(e)

# ╔═╡ e5692365-b1d9-4213-ae27-f5b4246ed31d
eval(Expr(:call, Symbol(".=="), :a, :a))

# ╔═╡ d3f11641-87d5-4c3d-8263-7cd8b8540448
eval(Expr(:call, QuoteNode(.<), 1, 2))

# ╔═╡ 5a98c4c3-914c-49fd-a80c-55b5daacd2dd
quote_if_needed(x) = x

# ╔═╡ 8d27a063-2dde-4235-9b6f-4c42fc4da26d
quote_if_needed(x::Union{Expr,Symbol}) = QuoteNode(x)

# ╔═╡ 5f1f04f6-5f54-4a35-bc9b-6d88931221ee
a = [1,2,3]

# ╔═╡ 9c57ced9-f8bd-4e9c-aee3-eae1bee422d3


# ╔═╡ e4b63acc-01aa-455b-9b89-2e9ea7e81c96


# ╔═╡ b05fcb88-3781-45d0-9f24-e88c339a72e5
macro test2(expr)
	quote nothing end
end

# ╔═╡ e8d0c98a-2de1-11eb-37b9-e1df3f5cfa25
md"## DisplayOnly"

# ╔═╡ e907d862-2de1-11eb-11a9-4b3ac37cb0f3
function skip_as_script(m::Module)
	if isdefined(m, :PlutoForceDisplay)
		return m.PlutoForceDisplay
	else
		isdefined(m, :PlutoRunner) && parentmodule(m) == Main
	end
end

# ╔═╡ e924a0be-2de1-11eb-2170-71d56e117af2
"""
	@displayonly expression

Marks a expression as Pluto-only, which means that it won't be executed when running outside Pluto. Do not use this for your own projects.
"""
macro skip_as_script(ex) skip_as_script(__module__) ? esc(ex) : nothing end

# ╔═╡ 7bde6345-e8a2-4e41-8f93-00edaf25f5cb
@skip_as_script macro test3(expr)
	quote				
		expr_raw = $(expr |> QuoteNode)
		try
			result, arg_results = staged_eval(expr_raw)
			
			if result === true
				Pass(expr_raw)
			else
				Wrong(expr_raw, result, to_eval)
			end
		catch e
			rethrow(e)
			Error(expr_raw, e)
		end

		# Base.@locals()
	end
end


# ╔═╡ 23ab2f3b-59e3-411e-97dd-5947af1f939e
@test3 sqrt.([1])

# ╔═╡ f2c599e5-86fc-4f03-a1fb-ffc1df7c741f
@test3 a .== a

# ╔═╡ bb60d833-410e-4b84-b4cb-2b3a0ce832eb
@test3 a == [1,2,3]

# ╔═╡ feae46a8-202d-4762-8305-79280fd681ca
@test3 a == :a

# ╔═╡ 7ce330a9-dd1b-40ad-b546-aea66cafb1bf
@test3 iseven(234)

# ╔═╡ cee644b7-d197-45bd-b882-1dbaaca5b89b
(@macroexpand @test3 a .== :a) |> Base.remove_linenums!

# ╔═╡ c2c2b057-a88f-4cc6-ada4-fc55ac29931e
"The opposite of `@skip_as_script`"
macro only_as_script(ex) skip_as_script(__module__) ? nothing : esc(ex) end

# ╔═╡ e748600a-2de1-11eb-24be-d5f0ecab8fa4
# Only define this in Pluto - assume we are `using Test` otherwise
begin
	@skip_as_script macro test(expr)
		quote				
			expr_raw = $(expr |> QuoteNode)
			try
				arg_results = $([esc(a) for a in expr.args])
				
				# result = eval(Expr($(expr.head |> QuoteNode), arg_results...))
				# if result == true
				# 	Pass(expr_raw)
				# else
				# 	Wrong(expr_raw, result)
				# end
			catch e
				Error(expr_raw, e)
			end
			
			# Base.@locals()
		end
	end
	# Do nothing inside pluto (so we don't need to have Test as dependency)
	# test/Firebasey is `using Test` before including this file
	@only_as_script ((@isdefined Test) ? nothing : macro test(expr) quote nothing end end)
end

# ╔═╡ e7e8d076-2de1-11eb-0214-8160bb81370a
@skip_as_script @test notebook1 == deepcopy(notebook1)

# ╔═╡ e9d2eba8-2de1-11eb-16bf-bd2a16537a97
@skip_as_script x = 2

# ╔═╡ ea45104e-2de1-11eb-3248-5dd833d350e4
@skip_as_script @test 1 + 1 == x

# ╔═╡ ea6650bc-2de1-11eb-3016-4542c5c333a5
@skip_as_script @test 1 + 1 + 1 == x

# ╔═╡ ea934d9c-2de1-11eb-3f1d-3b60465decde
@skip_as_script @test error("Oh my god") == x

# ╔═╡ ee70e282-36d5-4772-8585-f50b9a67ca54
md"## Track"

# ╔═╡ a3e8fe70-cbf5-4758-a0f2-d329d138728c
function prettytime(time_ns::Number)
    suffices = ["ns", "μs", "ms", "s"]
	
	current_amount = time_ns
	suffix = ""
	for current_suffix in suffices
    	if current_amount >= 1000.0
        	current_amount = current_amount / 1000.0
		else
			suffix = current_suffix
			break
		end
	end
    
    # const roundedtime = time_ns.toFixed(time_ns >= 100.0 ? 0 : 1)
	roundedtime = if current_amount >= 100.0
		round(current_amount; digits=0)
	else
		round(current_amount; digits=1)
	end
    return "$(roundedtime) $(suffix)"
end

# ╔═╡ 0e1c6442-9040-49d9-b754-173583db7ba2
begin
    Base.@kwdef struct Tracked
		expr
		value
		time
		bytes
		times_ran = 1
		which = nothing
		code_info = nothing
    end
    function Base.show(io::IO, mime::MIME"text/html", value::Tracked)
	times_ran = if value.times_ran === 1
		""
	else
		"""<span style="opacity: 0.5"> ($(value.times_ran)×)</span>"""
	end
	# method = sprint(show, MIME("text/plain"), value.which)
	code_info = if value.code_info ≠ nothing
		codelength = length(value.code_info.first.code)
		"$(codelength) frames in @code_typed"
	else
		""
	end
	color = if value.time > 1
		"red"
	elseif value.time > 0.001
		"orange"
	elseif value.time > 0.0001
		"blue"
	else
		"green"
	end
		
	
	show(io, mime, HTML("""
		<div
			style="
				display: flex;
				flex-direction: row;
				align-items: center;
			"
		>
			<div
				style="
					width: 12px;
					height: 12px;
					border-radius: 50%;
					background-color: $(color);
				"
			></div>
			<div style="width: 12px"></div>
			<div>
				<code
					class="language-julia"
					style="
						background-color: transparent;
						filter: grayscale(1) brightness(0.8);
					"
				>$(value.expr)</code>
				<div style="
					font-family: monospace;
					font-size: 12px;
					color: $(color);
				">
					$(prettytime(value.time * 1e9 / value.times_ran))
					$(times_ran)
				</div>
				<div style="
					font-family: monospace;
					font-size: 12px;
					color: gray;
				">$(code_info)</div>

			</div>
			
		</div>
	"""))
    end
	Tracked
end

# ╔═╡ 7618aef7-1884-4e32-992d-0fd988e1ab20
macro track(expr)
	times_ran_expr = :(1)
	expr_to_show = expr
	if expr.head == :for
		@assert expr.args[1].head == :(=)
		times_ran_expr = expr.args[1].args[2]
		expr_to_show = expr.args[2].args[2]
	end

	Tracked # reference so that baby Pluto understands
				
	quote
		local times_ran = length($(esc(times_ran_expr)))
		local value, time, bytes = @timed $(esc(expr))
		
		local method = nothing
		local code_info = nothing
		try
			# Uhhh
			method = @which $(expr_to_show)
			code_info = @code_typed $(expr_to_show)
		catch nothing end
		Tracked(
			expr=$(QuoteNode(expr_to_show)),
			value=value,
			time=time,
			bytes=bytes,
			times_ran=times_ran,
			which=method,
			code_info=code_info
		)
	end
end

# ╔═╡ 1a26eed8-670c-43bf-9726-2db84b1afdab
@skip_as_script @track sleep(0.1)

# ╔═╡ Cell order:
# ╟─e55d1cea-2de1-11eb-0d0e-c95009eedc34
# ╠═e598832a-2de1-11eb-3831-371aa2e54828
# ╠═e5b46afe-2de1-11eb-0de5-6d571c0fbbcf
# ╠═e5dbaf38-2de1-11eb-13a9-a994ac40bf9f
# ╠═e616c708-2de1-11eb-2e66-f972030a7ec5
# ╠═e6501fda-2de1-11eb-33ba-4bb34dc13d00
# ╠═e66c8454-2de1-11eb-1d79-499e6873d0d2
# ╠═e699ae9a-2de1-11eb-3ff0-c31222ac399e
# ╠═e6c17fae-2de1-11eb-1397-1b1cdfcc387c
# ╠═e705bd90-2de1-11eb-3759-3d59a90e6e44
# ╠═e748600a-2de1-11eb-24be-d5f0ecab8fa4
# ╠═7c35f88d-7740-4bc3-9ab6-855cc78223e2
# ╠═23ab2f3b-59e3-411e-97dd-5947af1f939e
# ╠═c672db23-a0bc-46af-ad1e-51114ed2bf98
# ╠═f2c599e5-86fc-4f03-a1fb-ffc1df7c741f
# ╠═bb60d833-410e-4b84-b4cb-2b3a0ce832eb
# ╠═feae46a8-202d-4762-8305-79280fd681ca
# ╠═7ce330a9-dd1b-40ad-b546-aea66cafb1bf
# ╠═173161a6-f6ee-4515-b9e5-3a775cde6e5d
# ╠═8ae5aaad-d164-48f4-bff9-c81ec0e03422
# ╠═a92f7b4e-dde2-4c26-84e0-18c31a5b59f3
# ╠═f0ba5c43-91e5-42d7-b904-72921acd356e
# ╠═fabb85e3-aee1-4765-b6a5-1b5dd4e63325
# ╠═27e557d5-6ecb-412b-a675-98fc9ba271d4
# ╠═91356a1a-4230-4608-9d19-f18f9cb8f72b
# ╠═e1378f25-9191-4732-bb58-f1656211ea3a
# ╠═a291172a-82da-4bdc-92ed-b4ac1e91c497
# ╠═7b258650-babf-4eb8-9167-4aec7ad98a44
# ╠═86163fc5-563a-4663-a087-6fdff099b4d5
# ╠═61df7ab9-a983-4756-8bc4-a80382908d19
# ╠═fdbf2a78-07de-4d09-9b31-d79e4c19e211
# ╟─c8e16361-662d-49fc-b4ae-534b15cc0b9d
# ╠═1fdb32dc-638f-42cd-a71d-5436dbca1d99
# ╟─f696bf5e-9717-498e-8435-bb7f47e3e3f0
# ╠═7671aecb-95d1-4326-8b39-67d301aeb137
# ╠═63f6bfd6-c654-4050-9557-8db41bbffe8c
# ╠═a5fca87d-3041-4c8a-9cfb-2dbf203da7a5
# ╠═f23fe2ff-c462-42d9-935d-1dab08149697
# ╠═230b7fce-fba7-4299-80b3-1deaec026348
# ╠═3aeecfd7-b06b-408d-86b7-4719340f1e1e
# ╠═b638beed-1c9d-4804-a91a-05f3e97d8bcc
# ╠═b6b1ef79-c802-49b5-8458-8d2b4ee3a7c0
# ╠═c18d6786-a164-4a59-b766-ee5e7edc996c
# ╠═6820f187-5c12-406a-b797-b9a449dca9eb
# ╠═4b5c355c-6b17-48e2-8436-3d0397d590e0
# ╠═a9625447-da72-4ce4-890a-518635a1b6ef
# ╠═bf7ba6ca-5e57-42f7-8ae3-2a5add69e740
# ╠═6f852f7c-3594-435f-b579-c92c8c2fc09b
# ╠═e5692365-b1d9-4213-ae27-f5b4246ed31d
# ╠═7bde6345-e8a2-4e41-8f93-00edaf25f5cb
# ╠═cee644b7-d197-45bd-b882-1dbaaca5b89b
# ╠═d3f11641-87d5-4c3d-8263-7cd8b8540448
# ╠═5a98c4c3-914c-49fd-a80c-55b5daacd2dd
# ╠═8d27a063-2dde-4235-9b6f-4c42fc4da26d
# ╠═5f1f04f6-5f54-4a35-bc9b-6d88931221ee
# ╠═9c57ced9-f8bd-4e9c-aee3-eae1bee422d3
# ╠═e4b63acc-01aa-455b-9b89-2e9ea7e81c96
# ╠═b05fcb88-3781-45d0-9f24-e88c339a72e5
# ╠═e7e8d076-2de1-11eb-0214-8160bb81370a
# ╟─e8d0c98a-2de1-11eb-37b9-e1df3f5cfa25
# ╠═e907d862-2de1-11eb-11a9-4b3ac37cb0f3
# ╠═e924a0be-2de1-11eb-2170-71d56e117af2
# ╠═c2c2b057-a88f-4cc6-ada4-fc55ac29931e
# ╠═e9d2eba8-2de1-11eb-16bf-bd2a16537a97
# ╠═ea45104e-2de1-11eb-3248-5dd833d350e4
# ╠═ea6650bc-2de1-11eb-3016-4542c5c333a5
# ╠═ea934d9c-2de1-11eb-3f1d-3b60465decde
# ╟─ee70e282-36d5-4772-8585-f50b9a67ca54
# ╠═1a26eed8-670c-43bf-9726-2db84b1afdab
# ╠═0e1c6442-9040-49d9-b754-173583db7ba2
# ╠═7618aef7-1884-4e32-992d-0fd988e1ab20
# ╠═a3e8fe70-cbf5-4758-a0f2-d329d138728c
