### A Pluto.jl notebook ###
# v0.11.14

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

# ╔═╡ 93136964-93c0-11ea-3da9-4d6e11b49b1e
using Distributed

# ╔═╡ 321f9e52-b193-11ea-09d3-0fcf6af1e472
md"asdfasdf"

# ╔═╡ 18c9914e-b173-11ea-342e-01c4e2097b8c
a1 = a2 = a3 = a4 = a5 = a6 = a7 = a8 = a9 = a10 = a11 = a12 = a13 = a14 = a15 = a16 = a17 = a18 = a19 = a20 = a21 = a22 = a23 = a24 = a25 = a26 = a27 = a28 = a29 = a30 = a31 = a32 = a33 = a34 = a35 = a36 = a37 = a38 = a39 = a40 = a41 = a42 = a43 = a44 = a45 = a46 = a47 = a48 = a49 = a50 = a51 = a52 = a53 = a54 = a55 = a56 = a57 = a58 = a59 = a60 = a61 = a62 = a63 = a64 = a65 = a66 = a67 = a68 = a69 = a70 = a71 = a72 = a73 = a74 = a75 = a76 = a77 = a78 = a79 = a80 = a81 = a82 = a83 = a84 = a85 = a86 = a87 = a88 = a89 = a90 = a91 = a92 = a93 = a94 = a95 = a96 = a97 = a98 = a99 = a100 = a101 = a102 = a103 = a104 = a105 = a106 = a107 = a108 = a109 = a110 = a111 = a112 = a113 = a114 = a115 = a116 = a117 = a118 = a119 = a120 = a121 = a122 = a123 = a124 = a125 = a126 = a127 = a128 = a129 = a130 = a131 = a132 = a133 = a134 = a135 = a136 = a137 = a138 = a139 = a140 = a141 = a142 = a143 = a144 = a145 = a146 = a147 = a148 = a149 = a150 = a151 = a152 = a153 = a154 = a155 = a156 = a157 = a158 = a159 = a160 = a161 = a162 = a163 = a164 = a165 = a166 = a167 = a168 = a169 = a170 = a171 = a172 = a173 = a174 = a175 = a176 = a177 = a178 = a179 = a180 = a181 = a182 = a183 = a184 = a185 = a186 = a187 = a188 = a189 = a190 = a191 = a192 = a193 = a194 = a195 = a196 = a197 = a198 = a199 = a200 = 0

# ╔═╡ 2c0e8b60-b173-11ea-1db9-b7ae66e03dc1
a1 + a2 + a3 + a4 + a5 + a6 + a7 + a8 + a9 + a10 + a11 + a12 + a13 + a14 + a15 + a16 + a17 + a18 + a19 + a20 + a21 + a22 + a23 + a24 + a25 + a26 + a27 + a28 + a29 + a30 + a31 + a32 + a33 + a34 + a35 + a36 + a37 + a38 + a39 + a40 + a41 + a42 + a43 + a44 + a45 + a46 + a47 + a48 + a49 + a50 + a51 + a52 + a53 + a54 + a55 + a56 + a57 + a58 + a59 + a60 + a61 + a62 + a63 + a64 + a65 + a66 + a67 + a68 + a69 + a70 + a71 + a72 + a73 + a74 + a75 + a76 + a77 + a78 + a79 + a80 + a81 + a82 + a83 + a84 + a85 + a86 + a87 + a88 + a89 + a90 + a91 + a92 + a93 + a94 + a95 + a96 + a97 + a98 + a99 + a100 + a101 + a102 + a103 + a104 + a105 + a106 + a107 + a108 + a109 + a110 + a111 + a112 + a113 + a114 + a115 + a116 + a117 + a118 + a119 + a120 + a121 + a122 + a123 + a124 + a125 + a126 + a127 + a128 + a129 + a130 + a131 + a132 + a133 + a134 + a135 + a136 + a137 + a138 + a139 + a140 + a141 + a142 + a143 + a144 + a145 + a146 + a147 + a148 + a149 + a150 + a151 + a152 + a153 + a154 + a155 + a156 + a157 + a158 + a159 + a160 + a161 + a162 + a163 + a164 + a165 + a166 + a167 + a168 + a169 + a170 + a171 + a172 + a173 + a174 + a175 + a176 + a177 + a178 + a179 + a180 + a181 + a182 + a183 + a184 + a185 + a186 + a187 + a188 + a189 + a190 + a191 + a192 + a193 + a194 + a195 + a196 + a197 + a198 + a199 + a200 + 0

# ╔═╡ ff545550-b172-11ea-33ed-eb222597f035
join(["a$i = " for i in 1:200]) * "0"

# ╔═╡ 2464da5e-b173-11ea-2532-13c06602328d
join(["a$i + " for i in 1:200]) * "0"

# ╔═╡ 5edd43d4-b172-11ea-1dc4-79c3e07941ed
FunctionName = Array{Symbol,1}

# ╔═╡ 881ed6f4-b172-11ea-237a-6d64da160f42
begin
	"SymbolsState trickles _down_ the ASTree: it carries referenced and defined variables from endpoints down to the root."
mutable struct SymbolsState
    references::Set{Symbol}
    assignments::Set{Symbol}
    function_calls::Set{FunctionName}
    function_definitions::Dict{FunctionName,SymbolsState}
end
	SymbolsState(references, assignments, function_calls) = SymbolsState(references, assignments, function_calls, Dict{FunctionName,SymbolsState}())
	SymbolsState(references, assignments) = SymbolsState(references, assignments, Set{Symbol}())
	SymbolsState() = SymbolsState(Set{Symbol}(), Set{Symbol}())
end

# ╔═╡ 8843f164-b172-11ea-0d5c-67fbbd97d6ee
"ScopeState moves _up_ the ASTree: it carries scope information up towards the endpoints."
mutable struct ScopeState
    inglobalscope::Bool
    exposedglobals::Set{Symbol}
    hiddenglobals::Set{Symbol}
    definedfuncs::Set{Symbol}
end

# ╔═╡ 9be01bf8-b172-11ea-04fe-13c44256cf50
begin
	import Base: union, union!, ==, push!
	
	function union(a::Dict{FunctionName,SymbolsState}, bs::Dict{FunctionName,SymbolsState}...)
	    union!(Dict{FunctionName,SymbolsState}(), a, bs...)
	end
	
	function union!(a::Dict{FunctionName,SymbolsState}, bs::Dict{FunctionName,SymbolsState}...)
	    for b in bs
	        for (k, v) in b
	            if haskey(a, k)
	                a[k] = union!(a[k], v)
	            else
	                a[k] = v
	            end
	        end
	        a
	    end
	    return a
	end
	
	function union(a::SymbolsState, b::SymbolsState)
	    SymbolsState(a.references ∪ b.references, a.assignments ∪ b.assignments, a.function_calls ∪ b.function_calls, a.function_definitions ∪ b.function_definitions)
	end
	
	function union!(a::SymbolsState, bs::SymbolsState...)
	    union!(a.references, (b.references for b in bs)...)
	    union!(a.assignments, (b.assignments for b in bs)...)
	    union!(a.function_calls, (b.function_calls for b in bs)...)
	    union!(a.function_definitions, (b.function_definitions for b in bs)...)
	    return a
	end
	
	function union!(a::Tuple{FunctionName,SymbolsState}, bs::Tuple{FunctionName,SymbolsState}...)
	    a[1], union!(a[2], (b[2] for b in bs)...)
	end
	
	function union(a::ScopeState, b::ScopeState)
	    SymbolsState(a.inglobalscope && b.inglobalscope, a.exposedglobals ∪ b.exposedglobals, a.hiddenglobals ∪ b.hiddenglobals)
	end
	
	function union!(a::ScopeState, bs::ScopeState...)
	    a.inglobalscope &= all((b.inglobalscope for b in bs)...)
	    union!(a.exposedglobals, (b.exposedglobals for b in bs)...)
	    union!(a.hiddenglobals, (b.hiddenglobals for b in bs)...)
	    union!(a.definedfuncs, (b.definedfuncs for b in bs)...)
	    return a
	end
	
	function ==(a::SymbolsState, b::SymbolsState)
	    a.references == b.references && a.assignments == b.assignments && a.function_calls == b.function_calls && a.function_definitions == b.function_definitions 
	end
	
	Base.push!(x::Set) = x
	
end

# ╔═╡ 88725842-b172-11ea-004c-21fc8845bc9b
const modifiers = [:(+=), :(-=), :(*=), :(/=), :(//=), :(^=), :(÷=), :(%=), :(<<=), :(>>=), :(>>>=), :(&=), :(⊻=), :(≔), :(⩴), :(≕)]


# ╔═╡ 88cacaa4-b172-11ea-30eb-3bdf5cc1f1f8
const modifiers_dotprefixed = [Symbol('.' * String(m)) for m in modifiers]


# ╔═╡ 88a66df8-b172-11ea-3221-a9ee7593773f
begin
	function will_assign_global(assignee::Symbol, scopestate::ScopeState)::Bool
	    (scopestate.inglobalscope || assignee ∈ scopestate.exposedglobals) && (assignee ∉ scopestate.hiddenglobals || assignee ∈ scopestate.definedfuncs)
	end
	
	function will_assign_global(assignee::Array{Symbol,1}, scopestate::ScopeState)::Bool
	    if length(assignee) == 0
	        false
	    elseif length(assignee) > 1
	        scopestate.inglobalscope
	    else
	        will_assign_global(assignee[1], scopestate)
	    end
	end
end

# ╔═╡ 88a37164-b172-11ea-3db5-cba8006705b7

function get_global_assignees(assignee_exprs, scopestate::ScopeState)::Set{Symbol}
    global_assignees = Set{Symbol}()
    for ae in assignee_exprs
        if isa(ae, Symbol)
            will_assign_global(ae, scopestate) && push!(global_assignees, ae)
        else
            if ae.head == :(::)
                will_assign_global(ae.args[1], scopestate) && push!(global_assignees, ae.args[1])
            else
                @warn "Unknown assignee expression" ae
            end
        end
    end
    return global_assignees
end

# ╔═╡ bcc6f5ee-b172-11ea-1300-2f15d78621e8
begin
	
	function get_assignees(ex::Expr)::FunctionName
	    if ex.head == :tuple
	        # e.g. (x, y) in the ex (x, y) = (1, 23)
	        union!(Symbol[], get_assignees.(ex.args)...)
	        # filter(s->s isa Symbol, ex.args)
	    elseif ex.head == :(::)
	        # TODO: type is referenced
	        Symbol[ex.args[1]]
	    elseif ex.head == :ref || ex.head == :(.)
	        Symbol[]
	    else
	        @warn "unknow use of `=`. Assignee is unrecognised." ex
	        Symbol[]
	    end
	end
	
	# e.g. x = 123
	get_assignees(ex::Symbol) = Symbol[ex]
	
	# When you assign to a datatype like Int, String, or anything bad like that
	# e.g. 1 = 2
	# This is parsable code, so we have to treat it
	get_assignees(::Any) = Symbol[]
	
end

# ╔═╡ c0950f58-b172-11ea-1732-33d5e0b64bfa
begin
	
	# TODO: this should return a FunctionName, and use `split_FunctionName`.
	"Turn :(A{T}) into :A."
	function uncurly!(ex::Expr, scopestate::ScopeState)::Symbol
	    @assert ex.head == :curly
	    push!(scopestate.hiddenglobals, (a for a in ex.args[2:end] if a isa Symbol)...)
	    ex.args[1]
	end
	
	uncurly!(ex::Expr)::Symbol = ex.args[1]
	
	uncurly!(s::Symbol, scopestate=nothing)::Symbol = s
end

# ╔═╡ cb9ef5c6-b172-11ea-1d46-a35df7f438c6
begin
	
	"Turn :(.+) into :(+)"
	function without_dotprefix(FunctionName::Symbol)::Symbol
	    fn_str = String(FunctionName)
	    if length(fn_str) > 0 && fn_str[1] == '.'
	        Symbol(fn_str[2:end])
	    else
	        FunctionName
	    end
	end
	
	"Turn :(sqrt.) into :(sqrt)"
	function without_dotsuffix(FunctionName::Symbol)::Symbol
	    fn_str = String(FunctionName)
	    if length(fn_str) > 0 && fn_str[end] == '.'
	        Symbol(fn_str[1:end - 1])
	    else
	        FunctionName
	    end
	end
end

# ╔═╡ c6be340e-b172-11ea-2333-bf81380f509b
begin
	
	"Turn `:(Base.Submodule.f)` into `[:Base, :Submodule, :f]` and `:f` into `[:f]`."
	function split_FunctionName(FunctionName_ex::Expr)::FunctionName
	    if FunctionName_ex.head == :(.)
	        vcat(split_FunctionName.(FunctionName_ex.args)...)
	    else
	        # a call to a function that's not a global, like calling an array element: `funcs[12]()`
	        # TODO: explore symstate!
	        Symbol[]
	    end
	end
	
	function split_FunctionName(FunctionName_ex::QuoteNode)::FunctionName
	    split_FunctionName(FunctionName_ex.value)
	end
	
	function split_FunctionName(FunctionName_ex::Symbol)::FunctionName
	    Symbol[FunctionName_ex |> without_dotprefix |> without_dotsuffix]
	end
	
	function split_FunctionName(::Any)::FunctionName
	    Symbol[]
	end
end

# ╔═╡ d8e0873e-b172-11ea-0409-d9c0d4eedb7d
"""Turn `Symbol[:Module, :func]` into Symbol("Module.func").

This is **not** the same as the expression `:(Module.func)`, but is used to identify the function name using a single `Symbol` (like normal variables).
This means that it is only the inverse of `ExploreExpression.split_FunctionName` iff `length(parts) ≤ 1`."""
function join_FunctionName_parts(parts::FunctionName)::Symbol
	join(parts .|> String, ".") |> Symbol
end

# ╔═╡ 4e0e992c-b172-11ea-35a3-9f7aef3592bd
md"""
<h1><img alt="Pluto.jl" src="https://raw.githubusercontent.com/fonsp/Pluto.jl/master/frontend/img/logo.svg" width=300 height=74 ></h1>

_Writing a notebook is not just about writing the final document — Pluto empowers the experiments and discoveries that are essential to getting there._

**Explore models and share results** in a notebook that is
- **_reactive_** - when changing a function or variable, Pluto automatically updates all affected cells.
- **_lightweight_** - Pluto is written in pure Julia and is easy to install
- **_simple_** - no hidden workspace state; intuitive UI.

<img alt="reactivity screencap" src="https://raw.githubusercontent.com/fonsp/Pluto.jl/580ab811f13d565cc81ebfa70ed36c84b125f55d/demo/plutodemo.gif" >


### Input

A Pluto notebook is made up of small blocks of Julia code (_cells_) and together they form a [***reactive*** notebook](https://medium.com/@mbostock/a-better-way-to-code-2b1d2876a3a0).
When you change a variable, Pluto automatically re-runs the cells that refer to it. Cells can even be placed in arbitrary order - intelligent syntax analysis figures out the dependencies between them and takes care of execution.

Cells can contain _arbitrary_ Julia code, and you can use external libraries. There are no code rewrites or wrappers, Pluto just looks at your code once before evaluation.

### Output

Your notebooks are **saved as pure Julia files** ([sample](https://github.com/fonsp/Pluto.jl/blob/master/sample/basic.jl)), which you can then import as if you had been programming in a regular editor all along. You can also export your notebook with cell outputs as attractive HTML and PDF documents. By reordering cells and hiding code, you have full control over how you tell your story.

<br >

## Dynamic environment

Pluto offers an environment where changed code takes effect instantly and where deleted code leaves no trace.
Unlike Jupyter or Matlab, there is **no mutable workspace**, but rather, an important guarantee:
<blockquote align="center"><em><b>At any instant</b>, the program state is <b>completely described</b> by the code you see.</em></blockquote>
No hidden state, no hidden bugs.

### Interactivity

Your programming environment becomes interactive by splitting your code into multiple cells! Changing one cell **instantly shows effects** on all other cells, giving you a fast and fun way to experiment with your model. 

In the example below, changing the parameter `A` and running the first cell will directly re-evaluate the second cell and display the new plot.

<img alt="plotting screencap" src="https://user-images.githubusercontent.com/6933510/80637344-24ac0180-8a5f-11ea-82dd-813dbceca9c9.gif" width="50%">

<br >

### HTML interaction
Lastly, here's _**one more feature**_: Pluto notebooks have a `@bind` macro to create a **live bond between an HTML object and a Julia variable**. Combined with reactivity, this is a very powerful tool!

<img alt="@bind macro screencap" src="https://user-images.githubusercontent.com/6933510/80617037-e2c09280-8a41-11ea-9fb3-18bb2921dd9e.gif" width="70%">

_notebook from [vdplasthijs/julia_sir](https://github.com/vdplasthijs/julia_sir)_

<br >

You don't need to know HTML to use it! The [PlutoUI package](https://github.com/fonsp/PlutoUI.jl) contains basic inputs like sliders and buttons.

But for those who want to dive deeper - you can use HTML, JavaScript and CSS to write your own widgets! Custom update events can be fired by dispatching a `new CustomEvent("input")`, making it compatible with the [`viewof` operator of observablehq](https://observablehq.com/@observablehq/a-brief-introduction-to-viewof). Have a look at the sample notebooks inside Pluto to learn more!

<br >
<hr >
<br >

# Let's do it!

### Ingredients
For one tasty notebook 🥞 you will need:
- **Julia** v1.0 or above
- **Linux**, **macOS** or **Windows**, _Linux and macOS will work best_
- Mozilla **Firefox** or Google **Chrome**, be sure to get the latest version

### Installation

Run Julia and add the package:
```julia
julia> ]
(v1.0) pkg> add Pluto
```

_Using the package manager for the first time can take up to 15 minutes - hang in there!_

To run the notebook server:
```julia
julia> import Pluto
julia> Pluto.run(1234)
```

Then go to [`http://localhost:1234/`](http://localhost:1234/) to start coding!

### To developers
Follow [these instructions](https://github.com/fonsp/Pluto.jl/blob/master/dev_instructions.md) to start working on the package.

<img src="https://raw.githubusercontent.com/gist/fonsp/9a36c183e2cad7c8fc30290ec95eb104/raw/ca3a38a61f95cd58d79d00b663a3c114d21e284e/cute.svg">

## License

Pluto.jl is open source! Specifically, it is [MIT Licensed](https://github.com/fonsp/Pluto.jl/blob/master/LICENSE). The included sample notebooks have a more permissive license: the [Unlicense](https://github.com/fonsp/Pluto.jl/blob/master/sample/LICENSE). This means that you can use sample notebook code however you like - you do not need to credit us!

Pluto.jl is built by gluing together open source software:

- `Julia` - [license](https://github.com/JuliaLang/julia/blob/master/LICENSE.md)
- `HTTP.jl` - [license](https://github.com/JuliaWeb/HTTP.jl/blob/master/LICENSE.md)
- `JSON.jl` - [license](https://github.com/JuliaWeb/HTTP.jl/blob/master/LICENSE.md)
- `CodeMirror` - [license](https://github.com/codemirror/CodeMirror/blob/master/LICENSE)
- `MathJax` - [license](https://github.com/mathjax/MathJax-src/blob/master/LICENSE)
- `observablehq/stdlib` - [license](https://github.com/observablehq/stdlib/blob/master/LICENSE)
- `preact` - [license](https://github.com/preactjs/preact/blob/master/LICENSE)
- `developit/htm` - [license](https://github.com/developit/htm/blob/master/LICENSE)

Your notebook files are _yours_, you do not need to credit us. Have fun!

## Note

We are happy to say that Pluto.jl runs smoothly for most users, and is **ready to be used in your next project**!

That being said, the Pluto project is an ambition to [_rethink what a programming environment should be_](http://worrydream.com/#!/LearnableProgramming). We believe that scientific programming can be a lot simpler. Not by adding more buttons to a text editor — by giving space to creative thought, and automating the rest. 

If you feel the same, give Pluto a try! We would love to hear what you think. 😊

<img alt="feedback screencap" src="https://user-images.githubusercontent.com/6933510/78135402-22d02d80-7422-11ea-900f-a8b01bdbd8d3.png" width="70%">

Questions? Have a look at the [FAQ](https://www.notion.so/3ce1c1cff62f4f97815891cdaa3daa7d?v=b5824fb6bc804d2c90d34c4d49a1c295).

_Created by [**Fons van der Plas**](https://github.com/fonsp) and [**Mikołaj Bochenski**](https://github.com/malyvsen). Inspired by [Observable](https://observablehq.com/)._


"""

# ╔═╡ a5e270ea-87c6-11ea-32e4-a5c92c2543e3
struct Wow
	x
	y
end

# ╔═╡ 6de2fdec-9075-11ea-3a39-176a725c1c38
which(show, (IO, MIME"text/plain", Wow))

# ╔═╡ d6bb60b0-8fc4-11ea-1a96-6dffb769ac8d
Base.show(io::IO, ::MIME"text/plain", w::Wow) = print(io, "wowie")

# ╔═╡ bc9b0846-8fe7-11ea-36be-95f4d5678d9f
ww = md"";

# ╔═╡ 5a786a52-8fca-11ea-16a1-f336e0d09343
s = randn((3, 3))

# ╔═╡ 610988be-87cb-11ea-1158-e926582f646e
w = Wow(1, 2)

# ╔═╡ 2397a42c-8fe9-11ea-3613-f95c0f69d22c
md"a"

# ╔═╡ b0dba8fc-87c6-11ea-3f48-03e3076f0cdf
w

# ╔═╡ b5941dcc-87c6-11ea-070d-2beb077404b4
w isa Base.AbstractDict

# ╔═╡ 8b8affe4-93c1-11ea-13e9-35f812ea2a24
include_dependency("potato")

# ╔═╡ 9749bdd8-93c0-11ea-218e-bb3c8aca84a6
Distributed.remotecall_eval(Main, 1, :(VersionNumber(Pluto.Pkg.TOML.parsefile(joinpath(Pluto.PKG_ROOT_DIR, "Project.toml"))["version"])))

# ╔═╡ e46bc5fe-93c0-11ea-3a28-a57866436552
Distributed.remotecall_eval(Main, 1, :(Pluto.PLUTO_VERSION))

# ╔═╡ 0f1736b8-87c7-11ea-2b9b-a7f8aad9800a
[1] |> Base.nfields, w |> Base.sizeof

# ╔═╡ e5a5561c-870c-11ea-27be-a51a15915e64
x = [1, [2,3,4], 620:800...]

# ╔═╡ cb18b686-8fd8-11ea-066c-bd467edfc009
x

# ╔═╡ a53ebb96-8ff3-11ea-3a49-cdce8c158c41
Dict(:a => 1, :b => ["hoi", "merlino"])

# ╔═╡ 8984fd16-8fe4-11ea-1ff9-d5cd8f6fe0b0
m = md"asasdf $x+1$ asdfasdf".content

# ╔═╡ e8d20214-8fe4-11ea-07cf-0970e4d1b8f0
sprint(Markdown.tohtml, x)

# ╔═╡ 8cbdafb6-8fe7-11ea-2e1b-cf6781de9987
md"A $([1,2,3]) D"

# ╔═╡ e69caef4-8fe4-11ea-33e7-2b8e7fe4ad38
#= begin
	import Markdown: html, htmlinline, Paragraph, withtag, tohtml
	function html(io::IO, md::Paragraph)
		withtag(io, :p) do
			for x in md.content
				htmlinline(io, x)
			end
		end
	end
	htmlinline(io::IO, content::Vector) = tohtml(io, content)
end =#

# ╔═╡ 45b18414-8fe5-11ea-379d-3714e2a5e571
begin
	1
	2
end

# ╔═╡ 2928da6e-8fee-11ea-1af2-81d68a8ed90a
#= begin
	import Markdown: html, tohtml, withtag
	function tohtml(io::IO, m::MIME"text/html", x)
		withtag(io, :DIV) do
			show(io, m, x)
		end
	end
end =#

# ╔═╡ 267a8fbe-8fef-11ea-0cea-5febb0c16422
occursin.(["a"], ["aa", "bb"])

# ╔═╡ d87f1c8e-8fef-11ea-3196-53ba5908144b
sqrt(1...)

# ╔═╡ b51971a8-8fe1-11ea-1b66-95a173a7c935
md"asdf "

# ╔═╡ e8e983ae-870f-11ea-27b8-a7fbc1361d6b
x

# ╔═╡ 044a825a-8fdb-11ea-29bb-1d0f0e028488
Dict([i => i for i in 1:100])

# ╔═╡ ad31516a-8fdf-11ea-0803-9f5b1a9fd9d8
Vector{UInt8}() isa String

# ╔═╡ 2457311c-870f-11ea-397e-3120cd3e0b74
r = Set([123,54,1,2,23,23,21,42,34234,4]) |> Base.axes1

# ╔═╡ 47715e08-8fba-11ea-1982-99fce343b41b
i = md"![asdf](https://fonsp.com/img/doggoSmall.jpg?raw=true)"

# ╔═╡ 503d8582-8fc3-11ea-3934-fb7a4f2a3473
doggos = [i,i,i, @bind p html"<input type='range' />"]

# ╔═╡ 6dd4dbb4-8fe8-11ea-0d3e-4d874391e9e1
p

# ╔═╡ b0d52d76-8721-11ea-0d79-d3cc67a891d5
good_boys = Dict(:title => md"# Hello world", :img => i) # :names => ["Hannes", "Floep"]

# ╔═╡ ad19ec44-8fe1-11ea-11a9-73b10aa46388
md"asdf $(good_boys) asd"

# ╔═╡ 69c2076a-8feb-11ea-143a-cfec10821e8e
repr(MIME"text/html"(), md"asdf $(good_boys) asd")

# ╔═╡ eed501f8-9076-11ea-3002-a5ec32d6dccb
md"asdf $(x) asdf"

# ╔═╡ 88f424ee-8fcb-11ea-3204-03c943098a17
let
	enu = enumerate(x)
	enu[1], enu[1]
end

# ╔═╡ cb62a20c-9074-11ea-3fb2-0d197fe87508
md"I like [_dogs_](dogs.org) **and** cats!".content

# ╔═╡ f8c7970c-9074-11ea-36b4-0927aaed5682
html"<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>"

# ╔═╡ c06927b6-8fd6-11ea-3da4-fd6080e71b37
ENV

# ╔═╡ 52a70206-8fd7-11ea-3c72-7d6154eae359
zip([1,2],[3,4]) |> collect

# ╔═╡ e0508e70-870c-11ea-15a0-2504ae18dad8
#= begin
	import Base: show
	
	function show_richest_textmime(io::IO, x::Any)
		if showable(MIME("text/html"), x)
			show(io, MIME("text/html"), x)
		else
			show(io, MIME("text/plain"), x)
		end
	end
	
	function show_array_row(io::IO, pair::Tuple)
		i, el = pair
		print(io, "<r><i>", i, "</i><e>")
		show_richest_textmime(io, el)
		print(io, "</e></r>")
	end
	
	function show_dict_row(io::IO, pair::Pair)
		k, el = pair
		print(io, "<r><k>")
		show_richest_textmime(io, k)
		print(io, "</k><e>")
		show_richest_textmime(io, el)
		print(io, "</e></r>")
	end
	
	function show(io::IO, ::MIME"text/html", x::Array{<:Any, 1})
		print(io, """<jltree class="collapsed" onclick="onjltreeclick(this, event)">""")
		print(io, eltype(x))
		print(io, "<jlarray>")
		if length(x) <= tree_display_limit
			show_array_row.([io], enumerate(x))
		else
			show_array_row.([io], enumerate(x[1:tree_display_limit]))
			
			print(io, "<r><more></more></r>")
			
			from_end = tree_display_limit > 20 ? 10 : 1
			indices = 1+length(x)-from_end:length(x)
			show_array_row.([io], zip(indices, x[indices]))
		end
		
		print(io, "</jlarray>")
		print(io, "</jltree>")
	end
	
	function show(io::IO, ::MIME"text/html", x::Dict{<:Any, <:Any})
		print(io, """<jltree class="collapsed" onclick="onjltreeclick(this, event)">""")
		print(io, "Dict")
		print(io, "<jldict>")
		row_index = 1
		for pair in x
			show_dict_row(io, pair)
			if row_index == tree_display_limit
				print(io, "<r><more></more></r>")
				break
			end
			row_index += 1
		end
		
		print(io, "</jldict>")
		print(io, "</jltree>")
	end
end =#

# ╔═╡ b5c7cfca-8fda-11ea-33e1-e9abe88e6b6b
good_boys[1:end]

# ╔═╡ d6121fd6-873a-11ea-23ca-ff0562499314
md"a"

# ╔═╡ c09b041e-870e-11ea-3f56-97bb48977c4e
rand(Float64, (3, 3))

# ╔═╡ b2d786ec-7f73-11ea-1a0c-f38d7b6bbc1e
md"# The Basel problem

_Leonard Euler_ proved in 1741 that the series

$$\frac{1}{1} + \frac{1}{4} + \frac{1}{9} + \cdots$$

converges to

$$\frac{\pi^2}{6}$$"

# ╔═╡ 8dfedde4-93c7-11ea-3526-11be3abfd339
md"# The Basel problem

_Leonard Euler_ proved in 1741 that the series

$$\frac{1}{1} + \frac{1}{4} + \frac{1}{9} + \cdots$$

converges to

$$\frac{\pi^2}{6}$$"

# ╔═╡ ee2eba46-906f-11ea-038c-99283e57b8bd
ctx = IOContext(stdout)

# ╔═╡ f2105a8c-906f-11ea-20f7-579104b25136
get(PlutoRunner.iocontext, :module, @__MODULE__)

# ╔═╡ ed22deae-906b-11ea-3c17-3b3a99dffc0f
mutable struct Derp
	left
	right
end

# ╔═╡ 2d57b6f6-93c6-11ea-1ab6-6582e884037c
ENV

# ╔═╡ 754a50e0-906f-11ea-1c75-b9d0f2a7354f
(a = 12, b = :a)

# ╔═╡ 4580323c-93ce-11ea-0cea-5339e499bfe5
PlutoRunner.sprint_withreturned(PlutoRunner.show_richest, "a")

# ╔═╡ 961d6f6c-93d7-11ea-39e0-8f4db8e068d7
PlutoRunner.sprint_withreturned(PlutoRunner.show_richest, "a")

# ╔═╡ aafb9178-93cf-11ea-1170-8b98c6afa32d
sprint(PlutoRunner.show_richest, "a")

# ╔═╡ 98a88b9a-93d7-11ea-0162-5f4df59775cb
sprint(PlutoRunner.show_richest, "a")

# ╔═╡ e37a69d4-93cf-11ea-033e-535261e4f160
PlutoRunner.sprint_withreturned(show, MIME"text/plain"(), "a")

# ╔═╡ a0152974-93d7-11ea-16cc-2bb976c74697
PlutoRunner.sprint_withreturned(show, MIME"text/plain"(), "a")

# ╔═╡ cfe781b8-93cf-11ea-2973-cfd841a16238
sprint(show, MIME"text/plain"(), "a")

# ╔═╡ 4c3e879e-93d4-11ea-2ad2-a93c2792c972
istextmime(MIME"text/plain"())

# ╔═╡ 7c8ef542-93ce-11ea-3dd7-f355bdc35e0a
"a"

# ╔═╡ ea9fc9f2-93d4-11ea-324b-b17587d5cdf6
mime = MIME"text/plain"()

# ╔═╡ ff8d461e-93d4-11ea-1ce2-0d493132ddfd
t = String

# ╔═╡ f5bcf8c8-93d4-11ea-3e62-2792206eda99
mime isa MIME"text/plain" && 
        t isa DataType &&
        which(show, (IO, MIME"text/plain", t)) === PlutoRunner.struct_showmethod_mime &&
        which(show, (IO, t)) === PlutoRunner.struct_showmethod

# ╔═╡ b4f70496-93d4-11ea-1794-5f0bc58de11c
which(show, (IO, MIME"text/plain", String))

# ╔═╡ 48414afe-93d5-11ea-1854-03945b3b6222
f = PlutoRunner.show_richest

# ╔═╡ 53738054-93d5-11ea-2f52-0b95249c7188
args = ["a"]

# ╔═╡ f0d20754-93cf-11ea-3272-a582b7a1a04f
first(filter(m -> Base.invokelatest(showable, m, x), PlutoRunner.allmimes))

# ╔═╡ fa4a4b16-93cf-11ea-000b-27c52abdcf7f
first(filter(m -> showable(m, x), PlutoRunner.allmimes))

# ╔═╡ 798eb62c-93d1-11ea-1e1a-ddc2f8091963
findfirst(m -> showable(m, x), PlutoRunner.allmimes)

# ╔═╡ 056b0be8-93d3-11ea-355b-0377246aafce
xshowable(m) = showable(m, x)

# ╔═╡ af434114-93d3-11ea-27b9-dff0493075f4
function fr()
	PlutoRunner.allmimes[findfirst(m -> showable(m, x), PlutoRunner.allmimes)]
end

# ╔═╡ eb61f3a8-93d2-11ea-33d9-25c299894e80
findnext(m -> showable(m, x), PlutoRunner.allmimes, 1)

# ╔═╡ b9d933cc-93d3-11ea-1b5b-d577af02c052
fr()

# ╔═╡ 2a72ea68-93d3-11ea-3b62-7f044a816ee2
[1 for i in 1:3]

# ╔═╡ 31f94494-93d3-11ea-085b-bdef957c19dd
collect(1:3)

# ╔═╡ 93d6134a-93d1-11ea-23b9-db2241f04dc0
let
	x = [1,2,3]
	findfirst(m -> showable(m, x), PlutoRunner.allmimes)
end

# ╔═╡ a4f59ea2-93d1-11ea-312f-b7d97f7f1d84
let
	x = [1,2,3]
	local mime
	for m in PlutoRunner.allmimes
		if showable(m, x)
			mime = m
		end
	end
	mime
end

# ╔═╡ b377c1a2-93d2-11ea-2c15-254419a4005d
mmmm

# ╔═╡ c38b08b0-93d2-11ea-3240-3d621e799d2e
methods(findnext)

# ╔═╡ 446407aa-93d0-11ea-27f9-ad9a8a3d9c2f
[showable(m, x) for m in PlutoRunner.allmimes]

# ╔═╡ c2dcc8bc-93d0-11ea-01e2-a9541b708ecd
[false for m in PlutoRunner.allmimes];

# ╔═╡ dc6e14b6-93d0-11ea-37a4-bded1ed8adea
map(m -> m, PlutoRunner.allmimes);

# ╔═╡ 75184d20-93d0-11ea-2fe4-479bcb30b0f4
showable(MIME"text/plain"(),x)

# ╔═╡ 81360872-93d0-11ea-1223-3ba250cc1b0b
showable(MIME"image/gif"(),x)

# ╔═╡ 812019ea-93d0-11ea-12b8-5b005f2f7560
showable(MIME"image/bmp"(),x)

# ╔═╡ 8108e1f8-93d0-11ea-1341-bf637b668e53
showable(MIME"image/jpg"(),x)

# ╔═╡ 80f1e93a-93d0-11ea-3480-c9eadce86083
showable(MIME"image/png"(),x)

# ╔═╡ 80d83a08-93d0-11ea-1553-f77bef2161ff
showable(MIME"image/svg+xml"(),x)

# ╔═╡ 80c223e4-93d0-11ea-3fcf-e5e2eadddb7a
showable(MIME"text/html"(),x)

# ╔═╡ 80816386-93d0-11ea-1766-434819edb637
showable(MIME"application/vnd.pluto.tree+xml"(),x)

# ╔═╡ 8c66f200-9070-11ea-33b8-8fe4209ebbad
if false
	afsddfsadfsadfs
end

# ╔═╡ 9036c98e-906e-11ea-1424-bbe053ae281c
d = Derp(1, 2)

# ╔═╡ f4f81140-9076-11ea-3fc9-b9098fa5f8ab
md"asdf $(d) asdf"

# ╔═╡ 3f788374-9074-11ea-2e28-4330a2401862
x |> Tuple

# ╔═╡ d945b32e-906e-11ea-18c0-d32060c3d502
tn = ((d |> typeof).name)

# ╔═╡ 209f8950-93d0-11ea-0966-097d134f8844
methods(show)

# ╔═╡ e89f2218-906b-11ea-26ae-4f246faad6ba
let
	a = Derp(nothing, nothing)
	b = Derp(a, nothing)
	a.left = b
	a, b
end

# ╔═╡ b2d79330-7f73-11ea-0d1c-a9aad1efaae1
n = 1:10

# ╔═╡ b2d79376-7f73-11ea-2dce-cb9c449eece6
seq = n.^-2

# ╔═╡ b2d792c2-7f73-11ea-0c65-a5042701e9f3
sqrt(sum(seq) * 6.0)

# ╔═╡ ee66048c-b172-11ea-03ca-b14977bb3e34
begin
	
	# Spaghetti code for a spaghetti problem 🍝
	
	# Possible leaf: value
	# Like: a = 1
	# 1 is a value (Int64)
	function explore!(value, scopestate::ScopeState)::SymbolsState
	    # includes: LineNumberNode, Int64, String, 
	    return SymbolsState()
	end
	
	# Possible leaf: symbol
	# Like a = x
	# x is a symbol
	# We handle the assignment separately, and explore!(:a, ...) will not be called.
	# Therefore, this method only handles _references_, which are added to the symbolstate, depending on the scopestate.
	function explore!(sym::Symbol, scopestate::ScopeState)::SymbolsState
	    if sym ∈ scopestate.hiddenglobals
	        SymbolsState(Set{Symbol}(), Set{Symbol}(), Set{Symbol}(), Dict{FunctionName,SymbolsState}())
	    else
	        SymbolsState(Set([sym]), Set{Symbol}(), Set{Symbol}(), Dict{FunctionName,SymbolsState}())
	    end
	end
	
	# General recursive method. Is never a leaf.
	# Modifies the `scopestate`.
	function explore!(ex::Expr, scopestate::ScopeState)::SymbolsState
	    if ex.head == :(=)
	        # Does not create scope
	
	        
	        if ex.args[1] isa Expr && (ex.args[1].head == :call || ex.args[1].head == :where)
	            # f(x, y) = x + y
	            # Rewrite to:
	            # function f(x, y) x + y end
	            return explore!(Expr(:function, ex.args...), scopestate)
	        end
	        assignees = get_assignees(ex.args[1])
	        val = ex.args[2]
	
	        global_assignees = get_global_assignees(assignees, scopestate)
	        
	        symstate = innersymstate = explore!(val, scopestate)
	        # If we are _not_ assigning a global variable, then this symbol hides any global definition with that name
	        push!(scopestate.hiddenglobals, setdiff(assignees, global_assignees)...)
	        assigneesymstate = explore!(ex.args[1], scopestate)
	        
	        push!(scopestate.hiddenglobals, global_assignees...)
	        push!(symstate.assignments, global_assignees...)
	        push!(symstate.references, setdiff(assigneesymstate.references, global_assignees)...)
	
	        return symstate
	    elseif ex.head in modifiers
	        # We change: a[1] += 123
	        # to:        a[1] = a[1] + 123
	        # We transform the modifier back to its operator
	        # for when users redefine the + function
	
	        operator = Symbol(string(ex.head)[1:end - 1])
	        expanded_expr = Expr(:(=), ex.args[1], Expr(:call, operator, ex.args[1], ex.args[2]))
	        return explore!(expanded_expr, scopestate)
	    elseif ex.head in modifiers_dotprefixed
	        # We change: a[1] .+= 123
	        # to:        a[1] .= a[1] + 123
	
	        operator = Symbol(string(ex.head)[2:end - 1])
	        expanded_expr = Expr(:(.=), ex.args[1], Expr(:call, operator, ex.args[1], ex.args[2]))
	        return explore!(expanded_expr, scopestate)
	    elseif ex.head == :let || ex.head == :for || ex.head == :while
	        # Creates local scope
	
	        # Because we are entering a new scope, we create a copy of the current scope state, and run it through the expressions.
	        innerscopestate = deepcopy(scopestate)
	        innerscopestate.inglobalscope = false
	
	        return mapfoldl(a -> explore!(a, innerscopestate), union!, ex.args, init=SymbolsState())
	    elseif ex.head == :call
	        # Does not create scope
	
	        FunctionName = ex.args[1] |> split_FunctionName
	        symstate = if length(FunctionName) == 0
	            explore!(ex.args[1], scopestate)
	        elseif length(FunctionName) == 1
	            if FunctionName[1] ∈ scopestate.hiddenglobals
	                SymbolsState()
	            else
	            SymbolsState(Set{Symbol}(), Set{Symbol}(), Set{FunctionName}([FunctionName]))
	            end
	        else
	            SymbolsState(Set{Symbol}([FunctionName[end - 1]]), Set{Symbol}(), Set{FunctionName}([FunctionName]))
	        end
	        # Explore code inside function arguments:
	        union!(symstate, explore!(Expr(:block, ex.args[2:end]...), scopestate))
	        return symstate
	    elseif ex.head == :kw
	        return explore!(ex.args[2], scopestate)
	    elseif ex.head == :struct
	        # Creates local scope
	
	        structname = ex.args[2]
	        structfields = ex.args[3].args
	
	        equiv_func = Expr(:function, Expr(:call, structname, structfields...), Expr(:block, nothing))
	
	        return explore!(equiv_func, scopestate)
	    elseif ex.head == :generator
	        # Creates local scope
	
	        # In a `generator`, a single expression is followed by the iterator assignments.
	        # In a `for`, this expression comes at the end.
	
	        # This is not strictly the normal form of a `for` but that's okay
	        return explore!(Expr(:for, ex.args[2:end]..., ex.args[1]), scopestate)
	    elseif ex.head == :function || ex.head == :abstract
	        symstate = SymbolsState()
	        # Creates local scope
	
	        funcroot = ex.args[1]
	
	        # Because we are entering a new scope, we create a copy of the current scope state, and run it through the expressions.
	        innerscopestate = deepcopy(scopestate)
	        innerscopestate.inglobalscope = false
	
	        FunctionName, innersymstate = explore_funcdef!(funcroot, innerscopestate)
	
	        union!(innersymstate, explore!(Expr(:block, ex.args[2:end]...), innerscopestate))
	        
	        if will_assign_global(FunctionName, scopestate)
	            symstate.function_definitions[FunctionName] = innersymstate
	            if length(FunctionName) == 1
	                push!(scopestate.definedfuncs, FunctionName[end])
	                push!(scopestate.hiddenglobals, FunctionName[end])
	            elseif length(FunctionName) > 1
	                push!(symstate.references, FunctionName[end - 1]) # reference the module of the extended function
	            end
	        else
	            # The function is not defined globally. However, the function can still modify the global scope or reference globals, e.g.
	            
	            # let
	            #     function f(x)
	            #         global z = x + a
	            #     end
	            #     f(2)
	            # end
	
	            # so we insert the function's inner symbol state here, as if it was a `let` block.
	            symstate = innersymstate
	        end
	
	        return symstate
	    elseif ex.head == :(->)
	        # Creates local scope
	
	        tempname = Symbol("anon", rand(UInt64))
	
	        # We will rewrite this to a normal function definition, with a temporary name
	        funcroot = ex.args[1]
	        args_ex = if funcroot isa Symbol || (funcroot isa Expr && funcroot.head == :(::))
	            [funcroot]
	        elseif funcroot.head == :tuple
	            funcroot.args
	        else
	            @error "Unknown lambda type"
	        end
	
	        equiv_func = Expr(:function, Expr(:call, tempname, args_ex...), ex.args[2])
	
	        return explore!(equiv_func, scopestate)
	    elseif ex.head == :global
	        # Does not create scope
	
	        # We have one of:
	        # global x;
	        # global x = 1;
	        # global x += 1;
	
	        # where x can also be a tuple:
	        # global a,b = 1,2
	
	        globalisee = ex.args[1]
	
	        if isa(globalisee, Symbol)
	            push!(scopestate.exposedglobals, globalisee)
	            return SymbolsState()
	        elseif isa(globalisee, Expr)
	            innerscopestate = deepcopy(scopestate)
	            innerscopestate.inglobalscope = true
	            return explore!(globalisee, innerscopestate)
	        else
	            @error "unknow global use" ex
	            return explore!(globalisee, scopestate)
	        end
	        
	        return symstate
	    elseif ex.head == :local
	        # Does not create scope
	
	        localisee = ex.args[1]
	
	        if isa(localisee, Symbol)
	            push!(scopestate.hiddenglobals, localisee)
	            return SymbolsState()
	        elseif isa(localisee, Expr) && (localisee.head == :(=) || localisee.head in modifiers)
	            push!(scopestate.hiddenglobals, get_assignees(localisee.args[1])...)
	            return explore!(localisee, scopestate)
	        else
	            @warn "unknow local use" ex
	            return explore!(localisee, scopestate)
	        end
	    elseif ex.head == :tuple
	        # Does not create scope
	        
	        # Is something like:
	        # a,b,c = 1,2,3
	        
	        # This parses to:
	        # head = :tuple
	        # args = [:a, :b, :(c=1), :2, :3]
	        
	        # 🤔
	        # we turn it into two expressions:
	
	        # (a, b) = (2, 3)
	        # (c = 1)
	
	        # and explore those :)
	
	        indexoffirstassignment = findfirst(a -> isa(a, Expr) && a.head == :(=), ex.args)
	        if indexoffirstassignment !== nothing
	            # we have one of two cases, see next `if`
	            indexofsecondassignment = findnext(a -> isa(a, Expr) && a.head == :(=), ex.args, indexoffirstassignment + 1)
	
	            if indexofsecondassignment !== nothing
	                # we have a named tuple, e.g. (a=1, b=2)
	                new_args = map(ex.args) do a
	                    (a isa Expr && a.head == :(=)) ? a.args[2] : a
	                end
	                return explore!(Expr(:block, new_args...), scopestate)
	            else
	            # we have a tuple assignment, e.g. `a, (b, c) = [1, [2, 3]]`
	                before = ex.args[1:indexoffirstassignment - 1]
	                after = ex.args[indexoffirstassignment + 1:end]
	
	                symstate_middle = explore!(ex.args[indexoffirstassignment], scopestate)
	                symstate_outer = explore!(Expr(:(=), Expr(:tuple, before...), Expr(:block, after...)), scopestate)
	
	                return union!(symstate_middle, symstate_outer)
	            end
	        else
	            return explore!(Expr(:block, ex.args...), scopestate)
	        end
	    elseif ex.head == :(.) && ex.args[2] isa Expr && ex.args[2].head == :tuple
	        # pointwise function call, e.g. sqrt.(nums)
	        # we rewrite to a regular call
	
	        return explore!(Expr(:call, ex.args[1], ex.args[2].args...), scopestate)
	    elseif ex.head == :using || ex.head == :import
	        if scopestate.inglobalscope
	            imports = if ex.args[1].head == :(:)
	                ex.args[1].args[2:end]
	            else
	            ex.args
	            end
	
	            packagenames = map(e -> e.args[end], imports)
	
	            return SymbolsState(Set{Symbol}(), Set{Symbol}(packagenames))
	        else
	            return SymbolsState(Set{Symbol}(), Set{Symbol}())
	        end
	    elseif ex.head == :macrocall && ex.args[1] isa Symbol && ex.args[1] == Symbol("@md_str")
	        # Does not create scope
	        # The Markdown macro treats things differently, so we must too
	
	        innersymstate = explore!(Markdown.toexpr(Markdown.parse(ex.args[3])), scopestate)
	        push!(innersymstate.references, Symbol("@md_str"))
	        
	        return innersymstate
	    elseif (ex.head == :macrocall && ex.args[1] isa Symbol && ex.args[1] == Symbol("@bind")
	        && length(ex.args) == 4 && ex.args[3] isa Symbol)
	        
	        innersymstate = explore!(ex.args[4], scopestate)
	        push!(innersymstate.assignments, ex.args[3])
	        
	        return innersymstate
	    elseif ex.head == :quote
	        # We ignore contents
	
	        return SymbolsState()
	    elseif ex.head == :module
	        # We ignore contents
	
	        return SymbolsState(Set{Symbol}(), Set{Symbol}([ex.args[2]]))
	    else
	        # fallback, includes:
	        # begin, block, do, toplevel
	        # (and hopefully much more!)
	        
	        # Does not create scope (probably)
	
	        return mapfoldl(a -> explore!(a, scopestate), union!, ex.args, init=SymbolsState())
	    end
	end
end

# ╔═╡ 886f52d2-b172-11ea-139b-f7def3fb542c
begin
	
	"Return the function name and the SymbolsState from argument defaults. Add arguments as hidden globals to the `scopestate`.
	
	Is also used for `struct` and `abstract`."
	function explore_funcdef!(ex::Expr, scopestate::ScopeState)::Tuple{FunctionName,SymbolsState}
	    if ex.head == :call
	        # get the function name
	        name, symstate = explore_funcdef!(ex.args[1], scopestate)
	        # and explore the function arguments
	        return mapfoldl(a -> explore_funcdef!(a, scopestate), union!, ex.args[2:end], init=(name, symstate))
	
	    elseif ex.head == :(::) || ex.head == :kw || ex.head == :(=)
	        # recurse
	        name, symstate = explore_funcdef!(ex.args[1], scopestate)
	        if length(ex.args) > 1
	            # use `explore!` (not `explore_funcdef!`) to explore the argument's default value - these can contain arbitrary expressions
	            union!(symstate, explore!(ex.args[2], scopestate))
	        end
	        return name, symstate
	
	    elseif ex.head == :where
	        # function(...) where {T, S <: R, U <: A.B}
	        # supertypes `R` and `A.B` are referenced
	        supertypes_symstate = SymbolsState()
	        for a in ex.args[2:end]
	            name, inner_symstate = explore_funcdef!(a, scopestate)
	            if length(name) == 1
	                push!(scopestate.hiddenglobals, name[1])
	            end
	            union!(supertypes_symstate, inner_symstate)
	        end
	        # recurse
	        name, symstate = explore_funcdef!(ex.args[1], scopestate)
	        union!(symstate, supertypes_symstate)
	        return name, symstate
	
	    elseif ex.head == :(<:)
	        # for use in `struct` and `abstract`
	        name = uncurly!(ex.args[1], scopestate)
	        symstate = if length(ex.args) == 1
	            SymbolsState()
	        else
	            explore!(ex.args[2], scopestate)
	        end
	        return Symbol[name], symstate
	
	    elseif ex.head == :curly
	        name = uncurly!(ex, scopestate)
	        return Symbol[name], SymbolsState()
	
	    elseif ex.head == :parameters || ex.head == :tuple
	        return mapfoldl(a -> explore_funcdef!(a, scopestate), union!, ex.args, init=(Symbol[], SymbolsState()))
	
	    elseif ex.head == :(.)
	        return split_FunctionName(ex), SymbolsState()
	
	    else
	        return Symbol[], explore!(ex, scopestate)
	    end
	end
	
	function explore_funcdef!(ex::QuoteNode, scopestate::ScopeState)::Tuple{FunctionName,SymbolsState}
	    explore_funcdef!(ex.value, scopestate)
	end
	
	function explore_funcdef!(ex::Symbol, scopestate::ScopeState)::Tuple{FunctionName,SymbolsState}
	    push!(scopestate.hiddenglobals, ex)
	    Symbol[ex |> without_dotprefix |> without_dotsuffix], SymbolsState()
	end
	
	function explore_funcdef!(::Any, ::ScopeState)::Tuple{FunctionName,SymbolsState}
	    Symbol[], SymbolsState()
	end
end

# ╔═╡ Cell order:
# ╠═2c0e8b60-b173-11ea-1db9-b7ae66e03dc1
# ╠═321f9e52-b193-11ea-09d3-0fcf6af1e472
# ╠═18c9914e-b173-11ea-342e-01c4e2097b8c
# ╠═ff545550-b172-11ea-33ed-eb222597f035
# ╠═2464da5e-b173-11ea-2532-13c06602328d
# ╠═5edd43d4-b172-11ea-1dc4-79c3e07941ed
# ╠═881ed6f4-b172-11ea-237a-6d64da160f42
# ╠═8843f164-b172-11ea-0d5c-67fbbd97d6ee
# ╠═9be01bf8-b172-11ea-04fe-13c44256cf50
# ╠═88725842-b172-11ea-004c-21fc8845bc9b
# ╠═88cacaa4-b172-11ea-30eb-3bdf5cc1f1f8
# ╠═88a66df8-b172-11ea-3221-a9ee7593773f
# ╠═88a37164-b172-11ea-3db5-cba8006705b7
# ╠═bcc6f5ee-b172-11ea-1300-2f15d78621e8
# ╠═c0950f58-b172-11ea-1732-33d5e0b64bfa
# ╠═c6be340e-b172-11ea-2333-bf81380f509b
# ╠═cb9ef5c6-b172-11ea-1d46-a35df7f438c6
# ╠═d8e0873e-b172-11ea-0409-d9c0d4eedb7d
# ╠═886f52d2-b172-11ea-139b-f7def3fb542c
# ╠═ee66048c-b172-11ea-03ca-b14977bb3e34
# ╠═4e0e992c-b172-11ea-35a3-9f7aef3592bd
# ╠═cb18b686-8fd8-11ea-066c-bd467edfc009
# ╠═a5e270ea-87c6-11ea-32e4-a5c92c2543e3
# ╠═6de2fdec-9075-11ea-3a39-176a725c1c38
# ╠═d6bb60b0-8fc4-11ea-1a96-6dffb769ac8d
# ╠═bc9b0846-8fe7-11ea-36be-95f4d5678d9f
# ╠═5a786a52-8fca-11ea-16a1-f336e0d09343
# ╠═610988be-87cb-11ea-1158-e926582f646e
# ╠═2397a42c-8fe9-11ea-3613-f95c0f69d22c
# ╠═b0dba8fc-87c6-11ea-3f48-03e3076f0cdf
# ╠═b5941dcc-87c6-11ea-070d-2beb077404b4
# ╠═93136964-93c0-11ea-3da9-4d6e11b49b1e
# ╠═8b8affe4-93c1-11ea-13e9-35f812ea2a24
# ╠═9749bdd8-93c0-11ea-218e-bb3c8aca84a6
# ╠═e46bc5fe-93c0-11ea-3a28-a57866436552
# ╠═0f1736b8-87c7-11ea-2b9b-a7f8aad9800a
# ╠═e5a5561c-870c-11ea-27be-a51a15915e64
# ╠═503d8582-8fc3-11ea-3934-fb7a4f2a3473
# ╠═6dd4dbb4-8fe8-11ea-0d3e-4d874391e9e1
# ╠═a53ebb96-8ff3-11ea-3a49-cdce8c158c41
# ╠═b0d52d76-8721-11ea-0d79-d3cc67a891d5
# ╠═8984fd16-8fe4-11ea-1ff9-d5cd8f6fe0b0
# ╠═e8d20214-8fe4-11ea-07cf-0970e4d1b8f0
# ╠═8cbdafb6-8fe7-11ea-2e1b-cf6781de9987
# ╠═e69caef4-8fe4-11ea-33e7-2b8e7fe4ad38
# ╠═45b18414-8fe5-11ea-379d-3714e2a5e571
# ╠═ad19ec44-8fe1-11ea-11a9-73b10aa46388
# ╠═69c2076a-8feb-11ea-143a-cfec10821e8e
# ╠═2928da6e-8fee-11ea-1af2-81d68a8ed90a
# ╠═267a8fbe-8fef-11ea-0cea-5febb0c16422
# ╠═d87f1c8e-8fef-11ea-3196-53ba5908144b
# ╠═b51971a8-8fe1-11ea-1b66-95a173a7c935
# ╠═e8e983ae-870f-11ea-27b8-a7fbc1361d6b
# ╠═044a825a-8fdb-11ea-29bb-1d0f0e028488
# ╠═ad31516a-8fdf-11ea-0803-9f5b1a9fd9d8
# ╠═2457311c-870f-11ea-397e-3120cd3e0b74
# ╠═47715e08-8fba-11ea-1982-99fce343b41b
# ╠═eed501f8-9076-11ea-3002-a5ec32d6dccb
# ╠═f4f81140-9076-11ea-3fc9-b9098fa5f8ab
# ╠═88f424ee-8fcb-11ea-3204-03c943098a17
# ╠═cb62a20c-9074-11ea-3fb2-0d197fe87508
# ╠═f8c7970c-9074-11ea-36b4-0927aaed5682
# ╠═c06927b6-8fd6-11ea-3da4-fd6080e71b37
# ╠═52a70206-8fd7-11ea-3c72-7d6154eae359
# ╠═e0508e70-870c-11ea-15a0-2504ae18dad8
# ╠═b5c7cfca-8fda-11ea-33e1-e9abe88e6b6b
# ╠═d6121fd6-873a-11ea-23ca-ff0562499314
# ╠═c09b041e-870e-11ea-3f56-97bb48977c4e
# ╠═b2d786ec-7f73-11ea-1a0c-f38d7b6bbc1e
# ╠═8dfedde4-93c7-11ea-3526-11be3abfd339
# ╠═b2d792c2-7f73-11ea-0c65-a5042701e9f3
# ╠═ee2eba46-906f-11ea-038c-99283e57b8bd
# ╠═f2105a8c-906f-11ea-20f7-579104b25136
# ╠═ed22deae-906b-11ea-3c17-3b3a99dffc0f
# ╠═2d57b6f6-93c6-11ea-1ab6-6582e884037c
# ╠═754a50e0-906f-11ea-1c75-b9d0f2a7354f
# ╠═4580323c-93ce-11ea-0cea-5339e499bfe5
# ╠═961d6f6c-93d7-11ea-39e0-8f4db8e068d7
# ╠═aafb9178-93cf-11ea-1170-8b98c6afa32d
# ╠═98a88b9a-93d7-11ea-0162-5f4df59775cb
# ╠═e37a69d4-93cf-11ea-033e-535261e4f160
# ╠═a0152974-93d7-11ea-16cc-2bb976c74697
# ╠═cfe781b8-93cf-11ea-2973-cfd841a16238
# ╠═4c3e879e-93d4-11ea-2ad2-a93c2792c972
# ╠═7c8ef542-93ce-11ea-3dd7-f355bdc35e0a
# ╠═ea9fc9f2-93d4-11ea-324b-b17587d5cdf6
# ╠═ff8d461e-93d4-11ea-1ce2-0d493132ddfd
# ╠═f5bcf8c8-93d4-11ea-3e62-2792206eda99
# ╠═b4f70496-93d4-11ea-1794-5f0bc58de11c
# ╠═48414afe-93d5-11ea-1854-03945b3b6222
# ╠═53738054-93d5-11ea-2f52-0b95249c7188
# ╠═f0d20754-93cf-11ea-3272-a582b7a1a04f
# ╠═fa4a4b16-93cf-11ea-000b-27c52abdcf7f
# ╠═798eb62c-93d1-11ea-1e1a-ddc2f8091963
# ╠═056b0be8-93d3-11ea-355b-0377246aafce
# ╠═af434114-93d3-11ea-27b9-dff0493075f4
# ╠═eb61f3a8-93d2-11ea-33d9-25c299894e80
# ╠═b9d933cc-93d3-11ea-1b5b-d577af02c052
# ╠═2a72ea68-93d3-11ea-3b62-7f044a816ee2
# ╠═31f94494-93d3-11ea-085b-bdef957c19dd
# ╠═93d6134a-93d1-11ea-23b9-db2241f04dc0
# ╠═a4f59ea2-93d1-11ea-312f-b7d97f7f1d84
# ╠═b377c1a2-93d2-11ea-2c15-254419a4005d
# ╠═c38b08b0-93d2-11ea-3240-3d621e799d2e
# ╠═446407aa-93d0-11ea-27f9-ad9a8a3d9c2f
# ╠═c2dcc8bc-93d0-11ea-01e2-a9541b708ecd
# ╠═dc6e14b6-93d0-11ea-37a4-bded1ed8adea
# ╠═75184d20-93d0-11ea-2fe4-479bcb30b0f4
# ╠═81360872-93d0-11ea-1223-3ba250cc1b0b
# ╠═812019ea-93d0-11ea-12b8-5b005f2f7560
# ╠═8108e1f8-93d0-11ea-1341-bf637b668e53
# ╠═80f1e93a-93d0-11ea-3480-c9eadce86083
# ╠═80d83a08-93d0-11ea-1553-f77bef2161ff
# ╠═80c223e4-93d0-11ea-3fcf-e5e2eadddb7a
# ╠═80816386-93d0-11ea-1766-434819edb637
# ╠═8c66f200-9070-11ea-33b8-8fe4209ebbad
# ╠═9036c98e-906e-11ea-1424-bbe053ae281c
# ╠═3f788374-9074-11ea-2e28-4330a2401862
# ╠═d945b32e-906e-11ea-18c0-d32060c3d502
# ╠═209f8950-93d0-11ea-0966-097d134f8844
# ╠═e89f2218-906b-11ea-26ae-4f246faad6ba
# ╠═b2d79330-7f73-11ea-0d1c-a9aad1efaae1
# ╠═b2d79376-7f73-11ea-2dce-cb9c449eece6
