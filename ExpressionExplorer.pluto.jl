### A Pluto.jl notebook ###
# v0.14.1

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

# ╔═╡ 51f62e10-9b66-48a9-bd8a-5f7ca47bea12
md"""
# ExpressionExplorer

This notebook is part of Pluto's source code.
"""

# ╔═╡ a35eeaec-6b73-4200-8fe9-e069e0b8dea8
begin
	if !@isdefined(PlutoRunner)
		import ..PlutoRunner
	end
	import Markdown
end

# ╔═╡ eb228e68-8bb9-404a-803f-d2cf5622fca3
md"""
## Two state objects
"""

# ╔═╡ 559d35f5-981a-444e-b212-ab32405df12c


# TODO: use GlobalRef instead
FunctionName = Array{Symbol,1}

# ╔═╡ 2391cfeb-311a-461e-8d3c-80cd5f9b599e
struct FunctionNameSignaturePair
    name::FunctionName
    canonicalized_head::Any
end

# ╔═╡ afe6f8a2-cf1c-48f7-9c9c-23046fd5a33c
Base.:(==)(a::FunctionNameSignaturePair, b::FunctionNameSignaturePair) = a.name == b.name && a.canonicalized_head == b.canonicalized_head

# ╔═╡ 13819d9d-88ca-44d1-bd1d-74a67cfb0d3b
Base.hash(a::FunctionNameSignaturePair, h::UInt) = hash(a.name, hash(a.canonicalized_head, h))

# ╔═╡ e6b7134d-cb5f-49b5-b069-a38ac5645085
"SymbolsState trickles _down_ the ASTree: it carries referenced and defined variables from endpoints down to the root."
Base.@kwdef mutable struct SymbolsState
    references::Set{Symbol} = Set{Symbol}()
    assignments::Set{Symbol} = Set{Symbol}()
    funccalls::Set{FunctionName} = Set{FunctionName}()
    funcdefs::Dict{FunctionNameSignaturePair,SymbolsState} = Dict{FunctionNameSignaturePair,SymbolsState}()
end

# ╔═╡ c5ed1623-a68f-4acb-b423-a6d9ade0a7a5
begin
	"ScopeState moves _up_ the ASTree: it carries scope information up towards the endpoints."
	mutable struct ScopeState
	    inglobalscope::Bool
	    exposedglobals::Set{Symbol}
	    hiddenglobals::Set{Symbol}
	    definedfuncs::Set{Symbol}
	end
	
	ScopeState() = ScopeState(true, Set{Symbol}(), Set{Symbol}(), Set{Symbol}())
end

# ╔═╡ f5fee1ad-bc07-419a-a118-fc552009799a
# The `union` and `union!` overloads define how two `SymbolsState`s or two `ScopeState`s are combined.

function Base.union(a::Dict{FunctionNameSignaturePair,SymbolsState}, bs::Dict{FunctionNameSignaturePair,SymbolsState}...)
    union!(Dict{FunctionNameSignaturePair,SymbolsState}(), a, bs...)
end

# ╔═╡ 06e6414d-180a-4088-8d07-9a8e18461969
function Base.union!(a::Dict{FunctionNameSignaturePair,SymbolsState}, bs::Dict{FunctionNameSignaturePair,SymbolsState}...)
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

# ╔═╡ b8b8c77c-0981-41dc-ac0b-6aaf8f03db47
function Base.union(a::SymbolsState, b::SymbolsState)
    SymbolsState(a.references ∪ b.references, a.assignments ∪ b.assignments, a.funccalls ∪ b.funccalls, a.funcdefs ∪ b.funcdefs)
end

# ╔═╡ 90da4e3a-1c25-4ad6-904b-4d895786790e
function Base.union!(a::SymbolsState, bs::SymbolsState...)
    union!(a.references, (b.references for b in bs)...)
    union!(a.assignments, (b.assignments for b in bs)...)
    union!(a.funccalls, (b.funccalls for b in bs)...)
    union!(a.funcdefs, (b.funcdefs for b in bs)...)
    return a
end

# ╔═╡ d703d634-8956-4bda-b0fa-ef011c830459
function Base.union!(a::Tuple{FunctionName,SymbolsState}, bs::Tuple{FunctionName,SymbolsState}...)
    a[1], union!(a[2], (b[2] for b in bs)...)
end

# ╔═╡ afdedd6e-7f07-42da-9f36-c45a7ae0210f
function Base.union(a::ScopeState, b::ScopeState)
    SymbolsState(a.inglobalscope && b.inglobalscope, a.exposedglobals ∪ b.exposedglobals, a.hiddenglobals ∪ b.hiddenglobals)
end

# ╔═╡ cb3aa97e-2f0b-4b08-be92-3f9350687fdc
function Base.union!(a::ScopeState, bs::ScopeState...)
    a.inglobalscope &= all((b.inglobalscope for b in bs)...)
    union!(a.exposedglobals, (b.exposedglobals for b in bs)...)
    union!(a.hiddenglobals, (b.hiddenglobals for b in bs)...)
    union!(a.definedfuncs, (b.definedfuncs for b in bs)...)
    return a
end

# ╔═╡ 23b5071f-834a-4c67-bd31-ad46ac710d48
function Base.:(==)(a::SymbolsState, b::SymbolsState)
    a.references == b.references && a.assignments == b.assignments && a.funccalls == b.funccalls && a.funcdefs == b.funcdefs 
end

# ╔═╡ 10ee2230-f91c-4479-9f2a-d3459a7a5499
Base.push!(x::Set) = x

# ╔═╡ 3c93ed99-6014-48c0-9ed1-79675aedcfe0
md"""
## Helper functions
"""

# ╔═╡ 3e638dc9-11ec-4907-90a8-d92b348c6f4e
# from the source code: https://github.com/JuliaLang/julia/blob/master/src/julia-parser.scm#L9
const modifiers = [:(+=), :(-=), :(*=), :(/=), :(//=), :(^=), :(÷=), :(%=), :(<<=), :(>>=), :(>>>=), :(&=), :(⊻=), :(≔), :(⩴), :(≕)]

# ╔═╡ b4cec831-9704-492b-9766-419e01b09d6e
const modifiers_dotprefixed = [Symbol('.' * String(m)) for m in modifiers]

# ╔═╡ 7d40bfbc-c655-4782-8471-2007a48dc0bf
function will_assign_global(assignee::Symbol, scopestate::ScopeState)::Bool
    (scopestate.inglobalscope || assignee ∈ scopestate.exposedglobals) && (assignee ∉ scopestate.hiddenglobals || assignee ∈ scopestate.definedfuncs)
end

# ╔═╡ db24e50c-5e4d-471e-9fbe-8831d707696f
function will_assign_global(assignee::Array{Symbol,1}, scopestate::ScopeState)::Bool
    if length(assignee) == 0
        false
    elseif length(assignee) > 1
        scopestate.inglobalscope
    else
        will_assign_global(assignee[1], scopestate)
    end
end

# ╔═╡ 2a508120-4687-4697-a039-d4faa7872f52
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

# ╔═╡ 45283cd1-c459-4e62-b819-a63aa590c363
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
        @warn "unknown use of `=`. Assignee is unrecognised." ex
        Symbol[]
    end
end

# ╔═╡ ddf5e84d-bc01-41e3-90fa-5faef4c3b7fc
# When you assign to a datatype like Int, String, or anything bad like that
# e.g. 1 = 2
# This is parsable code, so we have to treat it
get_assignees(::Any) = Symbol[]

# ╔═╡ 026d7dca-6c97-45c2-bfba-c9437f6771ab
all_underscores(s::Symbol) = all(isequal('_'), string(s))

# ╔═╡ 79e948c7-2512-4c34-8598-ad5f10e98d88
# e.g. x = 123, but ignore _ = 456
get_assignees(ex::Symbol) = all_underscores(ex) ? Symbol[] : Symbol[ex]

# ╔═╡ 5f03ef73-eecf-4777-8fe9-9692a255df88
# TODO: this should return a FunctionName, and use `split_funcname`.
"Turn :(A{T}) into :A."
function uncurly!(ex::Expr, scopestate::ScopeState)::Symbol
    @assert ex.head == :curly
    push!(scopestate.hiddenglobals, (a for a in ex.args[2:end] if a isa Symbol)...)
    Symbol(ex.args[1])
end

# ╔═╡ bb2059a3-e789-4101-87a4-37ad6af65d2d
uncurly!(ex::Expr)::Symbol = ex.args[1]

# ╔═╡ a6356c5e-4e44-4376-956f-5f86f4563951
uncurly!(s::Symbol, scopestate=nothing)::Symbol = s

# ╔═╡ 96388cd0-081a-4038-8a70-81a6742a5d8c
"Turn `:(Base.Submodule.f)` into `[:Base, :Submodule, :f]` and `:f` into `[:f]`."
function split_funcname(funcname_ex::Expr)::FunctionName
    if funcname_ex.head == :(.)
        vcat(split_funcname.(funcname_ex.args)...)
    else
        # a call to a function that's not a global, like calling an array element: `funcs[12]()`
        # TODO: explore symstate!
        Symbol[]
    end
end

# ╔═╡ 3f1fe13b-d583-48c9-93a9-1b72e4f018eb
function split_funcname(funcname_ex::QuoteNode)::FunctionName
    split_funcname(funcname_ex.value)
end

# ╔═╡ faa4068e-f707-4dda-894e-9d555adb5986
function split_funcname(funcname_ex::GlobalRef)::FunctionName
    split_funcname(funcname_ex.name)
end

# ╔═╡ c5acddda-d175-4251-816a-8eff1b87eb29
function is_just_dots(ex::Expr)
    ex.head == :(.) && all(is_just_dots, ex.args)
end

# ╔═╡ 1fa7e39c-b71f-4c5b-86c2-6ce7c03abe98
is_just_dots(::Union{QuoteNode,Symbol,GlobalRef}) = true

# ╔═╡ e2b0b177-9f46-4a4a-be7b-c209392e2a43
is_just_dots(::Any) = false

# ╔═╡ 8d18d185-2952-463d-864d-f9daeddd6f8f
# this includes GlobalRef - it's fine that we don't recognise it, because you can't assign to a globalref?
function split_funcname(::Any)::FunctionName
    Symbol[]
end

# ╔═╡ 671afd70-9c18-413d-9671-875994f0ee5b
"""Turn `Symbol(".+")` into `:(+)`"""
function without_dotprefix(funcname::Symbol)::Symbol
    fn_str = String(funcname)
    if length(fn_str) > 0 && fn_str[1] == '.'
        Symbol(fn_str[2:end])
    else
        funcname
    end
end

# ╔═╡ e2893867-faf9-4246-b5a0-139c5c9713cd
"""Turn `Symbol("sqrt.")` into `:sqrt`"""
function without_dotsuffix(funcname::Symbol)::Symbol
    fn_str = String(funcname)
    if length(fn_str) > 0 && fn_str[end] == '.'
        Symbol(fn_str[1:end - 1])
    else
        funcname
    end
end

# ╔═╡ 7564fc25-b0a4-4e85-880b-0fc5eace7cec
function split_funcname(funcname_ex::Symbol)::FunctionName
    Symbol[funcname_ex |> without_dotprefix |> without_dotsuffix]
end

# ╔═╡ a4bbef4f-caad-46e9-80fd-15e0848ed0c4
"""Turn `Symbol[:Module, :func]` into Symbol("Module.func").

This is **not** the same as the expression `:(Module.func)`, but is used to identify the function name using a single `Symbol` (like normal variables).
This means that it is only the inverse of `ExpressionExplorer.split_funcname` iff `length(parts) ≤ 1`."""
function join_funcname_parts(parts::FunctionName)::Symbol
	join(parts .|> String, ".") |> Symbol
end

# ╔═╡ 659305a9-92ab-4092-b960-e97b4c14051e
# this is stupid -- désolé
function is_joined_funcname(joined::Symbol)
    occursin('.', String(joined))
end

# ╔═╡ f11d9e65-f5ea-4558-9053-49531ca249a2
assign_to_kw(e::Expr) = e.head == :(=) ? Expr(:kw, e.args...) : e

# ╔═╡ 9d79fda8-edc2-4f8e-ae29-44a46fb0004c
assign_to_kw(x::Any) = x

# ╔═╡ 4b6d3266-f0e7-4b98-b43b-3f3c24fdd797
"Turn `A[i] * B[j,K[l+m]]` into `A[0] * B[0,K[0+0]]` to hide loop indices"
function strip_indexing(x, inside::Bool=false)
    if Meta.isexpr(x, :ref)
        Expr(:ref, strip_indexing(x.args[1]), strip_indexing.(x.args[2:end], true)...)
    elseif Meta.isexpr(x, :call)
        Expr(x.head, x.args[1], strip_indexing.(x.args[2:end], inside)...)
    elseif x isa Symbol && inside
        0
    else
        x
    end
end

# ╔═╡ 76c10921-d08e-4878-816d-f222f4068c2c
md"""
## Main recursive function

Spaghetti code for a spaghetti problem 🍝
"""

# ╔═╡ d88e0e06-3943-4a3c-8ac6-d2c4211f1994

# Possible leaf: value
# Like: a = 1
# 1 is a value (Int64)
function explore!(value, scopestate::ScopeState)::SymbolsState
    # includes: LineNumberNode, Int64, String, 
    return SymbolsState()
end

# ╔═╡ 90dfe536-9988-4083-a6c7-e2777ba19af6
# Possible leaf: symbol
# Like a = x
# x is a symbol
# We handle the assignment separately, and explore!(:a, ...) will not be called.
# Therefore, this method only handles _references_, which are added to the symbolstate, depending on the scopestate.
function explore!(sym::Symbol, scopestate::ScopeState)::SymbolsState
    if sym ∈ scopestate.hiddenglobals
        SymbolsState()
    else
        SymbolsState(references=Set([sym]))
    end
end

# ╔═╡ 47d7e206-7e23-4f98-b488-85d595819212
function explore_funcdef!(ex::QuoteNode, scopestate::ScopeState)::Tuple{FunctionName,SymbolsState}
    explore_funcdef!(ex.value, scopestate)
end

# ╔═╡ b7cf3a4d-dbe8-4058-bac1-702e16cef5e7
function explore_funcdef!(ex::Symbol, scopestate::ScopeState)::Tuple{FunctionName,SymbolsState}
    push!(scopestate.hiddenglobals, ex)
    Symbol[ex |> without_dotprefix |> without_dotsuffix], SymbolsState()
end

# ╔═╡ 8818219e-860a-4556-b5f5-df318dadd381
function explore_funcdef!(::Any, ::ScopeState)::Tuple{FunctionName,SymbolsState}
    Symbol[], SymbolsState()
end

# ╔═╡ ca38f86c-a603-47d5-9c97-17919035da9d
const can_macroexpand_no_bind = Set(Symbol.(["@md_str", "Markdown.@md_str", "@gensym", "Base.@gensym", "@kwdef", "Base.@kwdef", "@enum", "Base.@enum", "@cmd"]))

# ╔═╡ 5057dbf0-aca9-4791-9bff-87d080475a45
const can_macroexpand = can_macroexpand_no_bind ∪ Set(Symbol.(["@bind", "PlutoRunner.@bind"]))

# ╔═╡ 02bcbbd4-9e2b-440b-8c8f-d4ba18848197
macro_kwargs_as_kw(ex::Expr) = Expr(:macrocall, ex.args[1:3]..., assign_to_kw.(ex.args[4:end])...)

# ╔═╡ 3e360b8e-9cf0-4c46-bae1-401971e3e944
function symbolics_mockexpand(s::Any)
    # goofy implementation of the syntax described in https://symbolics.juliasymbolics.org/dev/manual/variables/
    if Meta.isexpr(s, :ref, 2)
        :($(s.args[1]) = $(s.args[2]))
    elseif Meta.isexpr(s, :call, 2)
        second = s.args[2] === Symbol("..") ? 123 : s.args[2]
        :($(symbolics_mockexpand(s.args[1])); $(second) = 123)
    elseif s isa Symbol
        :($(s) = 123)
    else
        nothing
    end
end

# ╔═╡ d4195845-f036-4a11-bc58-32f9b63b3fd8
is_symbolics_arg(s) = symbolics_mockexpand(s) !== nothing

# ╔═╡ 92d79fb3-0438-4e98-b94b-1eeb01046cd9
maybe_untuple(es) = if length(es) == 1 && Meta.isexpr(first(es), :tuple)
    first(es).args
else
    es
end

# ╔═╡ 8e4a667d-92aa-4ab8-95af-19d2e65aad5e
"""
If the macro is known to Pluto, expand or 'mock expand' it, if not, return the expression.

Macros can transform the expression into anything - the best way to treat them is to `macroexpand`. The problem is that the macro is only available on the worker process, see https://github.com/fonsp/Pluto.jl/issues/196
"""
function maybe_macroexpand(ex::Expr; recursive=false, expand_bind=true)
    result = if ex.head === :macrocall
        funcname = ex.args[1] |> split_funcname
        funcname_joined = join_funcname_parts(funcname)

        args = ex.args[3:end]
        
        if funcname_joined ∈ (expand_bind ? can_macroexpand : can_macroexpand_no_bind)
            expanded = macroexpand(PlutoRunner, ex; recursive=false)
            Expr(:call, ex.args[1], expanded)

        elseif !isempty(args) && Meta.isexpr(args[1], :(:=))
            ex = macro_kwargs_as_kw(ex)
            # macros like @einsum C[i] := A[i,j] are assignment to C, illegal syntax without macro
            ein = args[1]
            left = if Meta.isexpr(ein.args[1], :ref)
                # assign to the symbol, and save LHS indices as fake RHS argument
                ex = Expr(ex.head, ex.args..., Expr(:ref, :Float64, ein.args[1].args[2:end]...))
                ein.args[1].args[1]
            else
                ein.args[1]  # scalar case `c := A[i,j]`
            end
            ein_done = Expr(:(=), left, strip_indexing.(ein.args[2:end])...)  # i,j etc. are local
            Expr(:call, ex.args[1:2]..., ein_done, strip_indexing.(ex.args[4:end])...)
            
        elseif !isempty(args) && funcname_joined === Symbol("@ode_def")
            if args[1] isa Symbol
                :($(args[1]) = @ode_def 123)
            else
                :(@ode_def)
            end
        elseif !isempty(args) && (funcname_joined === Symbol("@functor") || funcname_joined === Symbol("Flux.@functor"))
            Expr(:macrocall, ex.args[1:2]..., :($(args[1]) = 123), ex.args[4:end]...)
        elseif !isempty(args) && (funcname_joined === Symbol("@variables") || funcname_joined === Symbol("Symbolics.@variables")) && all(is_symbolics_arg, maybe_untuple(args))
            Expr(:macrocall, ex.args[1:2]..., symbolics_mockexpand.(maybe_untuple(args))...)
        # elseif length(ex.args) >= 4 && (funcname_joined === Symbol("@variable") || funcname_joined === Symbol("JuMP.@variable"))
        #     if Meta.isexpr(ex.args[4], :comparison)
        #         parts = ex.args[4].args[1:2:end]
        #         if length(parts) == 2
        #         foldl(parts) do (e,next)
        #             :($(e) = $(next))
        #         end
        #     elseif Meta.isexpr(ex.args[4], :block)

        #     end


        #     Expr(:macrocall, ex.args[1:3]..., )
            # add more macros here
        elseif length(args) ≥ 2 && ex.args[1] != GlobalRef(Core, Symbol("@doc"))
            # for macros like @test a ≈ b atol=1e-6, read assignment in 2nd & later arg as keywords
            macro_kwargs_as_kw(ex)
        else
            ex
        end
    else
        ex
    end

    if recursive && (result isa Expr)
        Expr(result.head, maybe_macroexpand.(result.args; recursive=recursive, expand_bind=expand_bind)...)
    else
        result
    end
end

# ╔═╡ a221fc38-5a2d-40f3-8529-caf3dc919374
maybe_macroexpand(ex::Any; kwargs...) = ex

# ╔═╡ 28208774-b99c-479b-9e30-07c6dbc482a2
md"""
## Canonicalize function definitions
"""

# ╔═╡ a30532f6-4987-4e6e-b2ac-daffe9e56df3
# for `function g end`
canonalize(::Symbol) = nothing

# ╔═╡ 184b8cc0-414b-4ffa-a6fe-9a67bbfc3ce2
function hide_argument_name(ex::Expr)
    if ex.head == :(::) && length(ex.args) > 1
        Expr(:(::), nothing, ex.args[2:end]...)
    elseif ex.head == :(...)
        Expr(:(...), hide_argument_name(ex.args[1]))
    elseif ex.head == :kw
        Expr(:kw, hide_argument_name(ex.args[1]), nothing)
    else
        ex
    end
end

# ╔═╡ bad85f9a-6c19-4ca3-b7a5-8ef2b83d3b3a
hide_argument_name(::Symbol) = Expr(:(::), nothing, :Any)

# ╔═╡ 29bf7829-ce07-4c98-a9a4-6bcdbc6f5e41
hide_argument_name(x::Any) = x

# ╔═╡ 365f0095-1ee5-4eef-9693-bec0951b5ee4
"""
Turn a function definition expression (`Expr`) into a "canonical" form, in the sense that two methods that would evaluate to the same method signature have the same canonical form. Part of a solution to https://github.com/fonsp/Pluto.jl/issues/177. Such a canonical form cannot be achieved statically with 100% correctness (impossible), but we can make it good enough to be practical.


# Wait, "evaluate to the same method signature"?

In Pluto, you cannot do definitions of **the same global variable** in different cells. This is needed for reactivity to work, and it avoid ambiguous notebooks and stateful stuff. This rule used to also apply to functions: you had to place all methods of a function in one cell. (Go and read more about methods in Julia if you haven't already.) But this is quite annoying, especially because multiple dispatch is so important in Julia code. So we allow methods of the same function to be defined across multiple cells, but we still want to throw errors when you define **multiple methods with the same signature**, because one overrides the other. For example:
```julia
julia> f(x) = 1
f (generic function with 1 method)

julia> f(x) = 2
f (generic function with 1 method)
``

After adding the second method, the function still has only 1 method. This is because the second definition overrides the first one, instead of being added to the method table. This example should be illegal in Julia, for the same reason that `f = 1` and `f = 2` is illegal. So our problem is: how do we know that two cells will define overlapping methods? 

Ideally, we would just evaluate the user's code and **count methods** afterwards, letting Julia do the work. Unfortunately, we need to know this info _before_ we run cells, otherwise we don't know in which order to run a notebook! There are ways to break this circle, but it would complicate our process quite a bit.

Instead, we will do _static analysis_ on the function definition expressions to determine whether they overlap. This is non-trivial. For example, `f(x)` and `f(y::Any)` define the same method. Trickier examples are here: https://github.com/fonsp/Pluto.jl/issues/177#issuecomment-645039993

# Wait, "function definition expressions"?
For example:

```julia
e = :(function f(x::Int, y::String)
        x + y
    end)

dump(e, maxdepth=2)

#=
gives:

Expr
  head: Symbol function
  args: Array{Any}((2,))
    1: Expr
    2: Expr
=#
```

This first arg is the function head:

```julia
e.args[1] == :(f(x::Int, y::String))
```

# Mathematics
Our problem is to find a way to compute the equivalence relation ~ on `H × H`, with `H` the set of function head expressions, defined as:

`a ~ b` iff evaluating both expressions results in a function with exactly one method.

_(More precisely, evaluating `Expr(:function, x, Expr(:block))` with `x ∈ {a, b}`.)_

The equivalence sets are isomorphic to the set of possible Julia methods.

Instead of finding a closed form algorithm for `~`, we search for a _canonical form_: a function `canonical: H -> H` that chooses one canonical expression per equivalence class. It has the property 
    
`canonical(a) = canonical(b)` implies `a ~ b`.

We use this **canonical form** of the function's definition expression as its "signature". We compare these canonical forms when determining whether two function expressions will result in overlapping methods.

# Example
```julia
e1 = :(f(x, z::Any))
e2 = :(g(x, y))

canonalize(e1) == canonalize(e2)
```

```julia
e1 = :(f(x))
e2 = :(g(x, y))

canonalize(e1) != canonalize(e2)
```

```julia
e1 = :(f(a::X, b::wow(ie), c,      d...; e=f) where T)
e2 = :(g(z::X, z::wow(ie), z::Any, z...     ) where T)

canonalize(e1) == canonalize(e2)
```
"""
function canonalize(ex::Expr)
	if ex.head == :where
		Expr(:where, canonalize(ex.args[1]), ex.args[2:end]...)
	elseif ex.head == :call || ex.head == :tuple
		skip_index = ex.head == :call ? 2 : 1
		# ex.args[1], if ex.head == :call this is the function name, we dont want it

		interesting = filter(ex.args[skip_index:end]) do arg
			!(arg isa Expr && arg.head == :parameters)
		end
		
		hide_argument_name.(interesting)
    elseif ex.head == :(::)
        canonalize(ex.args[1])
    elseif ex.head == :curly || ex.head == :(<:)
        # for struct definitions, which we hackily treat as functions
        nothing
    else
		@error "Failed to canonalize this strange looking function" ex
		nothing
	end
end

# ╔═╡ ecff407d-8e0c-4a72-babd-46545860a547
begin
	# General recursive method. Is never a leaf.
	# Modifies the `scopestate`.
	function explore!(ex::Expr, scopestate::ScopeState)::SymbolsState
	    if ex.head == :(=)
	        # Does not create scope
	        
	        if ex.args[1] isa Expr && (ex.args[1].head == :call || ex.args[1].head == :where || (ex.args[1].head == :(::) && ex.args[1].args[1] isa Expr && ex.args[1].args[1].head == :call))
	            # f(x, y) = x + y
	            # Rewrite to:
	            # function f(x, y) x + y end
	            return explore!(Expr(:function, ex.args...), scopestate)
	        end
	
	        val = ex.args[2]
	        # Handle generic types assignments A{B} = C{B, Int}
	        if ex.args[1] isa Expr && ex.args[1].head == :curly
	            assignees, symstate = explore_funcdef!(ex.args[1], scopestate)
	            innersymstate = union!(symstate, explore!(val, scopestate))
	        else
	            assignees = get_assignees(ex.args[1])
	            symstate = innersymstate = explore!(val, scopestate)
	        end
	
	        global_assignees = get_global_assignees(assignees, scopestate)
	
	        # If we are _not_ assigning a global variable, then this symbol hides any global definition with that name
	        push!(scopestate.hiddenglobals, setdiff(assignees, global_assignees)...)
	        assigneesymstate = explore!(ex.args[1], scopestate)
	        
	        push!(scopestate.hiddenglobals, global_assignees...)
	        push!(symstate.assignments, global_assignees...)
	        push!(symstate.references, setdiff(assigneesymstate.references, global_assignees)...)
	        filter!(!all_underscores, symstate.references)  # Never record _ as a reference
	
	        return symstate
	    elseif ex.head in modifiers
	        # We change: a[1] += 123
	        # to:        a[1] = a[1] + 123
	        # We transform the modifier back to its operator
	        # for when users redefine the + function
	
	        operator = let
	            s = string(ex.head)
	            Symbol(s[1:prevind(s, lastindex(s))])
	        end
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
	        return explore_inner_scoped(ex, scopestate)
	    elseif ex.head == :filter
	        # In a filter, the assignment is the second expression, the condition the first
	        return mapfoldr(a -> explore!(a, scopestate), union!, ex.args, init=SymbolsState())
	    elseif ex.head == :generator
	        # Creates local scope
	
	        # In a `generator`, a single expression is followed by the iterator assignments.
	        # In a `for`, this expression comes at the end.
	
	        # This is not strictly the normal form of a `for` but that's okay
	        return explore!(Expr(:for, ex.args[2:end]..., ex.args[1]), scopestate)
	    elseif ex.head == :macrocall
	        # Does not create sccope
	        new_ex = maybe_macroexpand(ex)
	
	        newnew_ex = Meta.isexpr(new_ex, :macrocall) ? Expr(:call, new_ex.args...) : new_ex
	
	        return explore!(newnew_ex, scopestate)
	    elseif ex.head == :call
	        # Does not create scope
	
	        if is_just_dots(ex.args[1])
	            funcname = ex.args[1] |> split_funcname
	            symstate = if length(funcname) == 0
	                explore!(ex.args[1], scopestate)
	            elseif length(funcname) == 1
	                if funcname[1] ∈ scopestate.hiddenglobals
	                    SymbolsState()
	                else
	                    SymbolsState(funccalls=Set{FunctionName}([funcname]))
	                end
	            else
	                SymbolsState(references=Set{Symbol}([funcname[1]]), funccalls=Set{FunctionName}([funcname]))
	            end
	            # Explore code inside function arguments:
	            union!(symstate, explore!(Expr(:block, ex.args[2:end]...), scopestate))
	            return symstate
	        else
	            return explore!(Expr(:block, ex.args...), scopestate)
	        end
	    elseif ex.head == :kw
	        return explore!(ex.args[2], scopestate)
	    elseif ex.head == :struct
	        # Creates local scope
	
	        structnameexpr = ex.args[2]
	        structfields = ex.args[3].args
	
	        equiv_func = Expr(:function, Expr(:call, structnameexpr, structfields...), Expr(:block, nothing))
	
	        # struct should always be in Global state
	        globalscopestate = deepcopy(scopestate)
	        globalscopestate.inglobalscope = true
	
	        # we register struct definitions as both a variable and a function. This is because deleting a struct is trickier than just deleting its methods.
	        inner_symstate = explore!(equiv_func, globalscopestate)
	
	        structname = first(keys(inner_symstate.funcdefs)).name |> join_funcname_parts
	        push!(inner_symstate.assignments, structname)
	        return inner_symstate
	    elseif ex.head == :abstract
	        equiv_func = Expr(:function, ex.args...)
	        inner_symstate = explore!(equiv_func, scopestate)
	
	        abstracttypename = first(keys(inner_symstate.funcdefs)).name |> join_funcname_parts
	        push!(inner_symstate.assignments, abstracttypename)
	        return inner_symstate
	    elseif ex.head == :function || ex.head == :macro
	        symstate = SymbolsState()
	        # Creates local scope
	
	        funcroot = ex.args[1]
	
	        # Because we are entering a new scope, we create a copy of the current scope state, and run it through the expressions.
	        innerscopestate = deepcopy(scopestate)
	        innerscopestate.inglobalscope = false
	
	        funcname, innersymstate = explore_funcdef!(funcroot, innerscopestate)
	        # Macro are called using @funcname, but defined with funcname. We need to change that in our scopestate
	        # (The `!= 0` is for when the function named couldn't be parsed)
	        if ex.head == :macro && length(funcname) != 0
	            setdiff!(innerscopestate.hiddenglobals, funcname)
	            funcname = Symbol[Symbol("@$(funcname[1])")]
	            push!(innerscopestate.hiddenglobals, funcname...)
	        end
	
	        union!(innersymstate, explore!(Expr(:block, ex.args[2:end]...), innerscopestate))
	        
	        funcnamesig = FunctionNameSignaturePair(funcname, canonalize(funcroot))
	
	        if will_assign_global(funcname, scopestate)
	            symstate.funcdefs[funcnamesig] = innersymstate
	            if length(funcname) == 1
	                push!(scopestate.definedfuncs, funcname[end])
	                push!(scopestate.hiddenglobals, funcname[end])
	            elseif length(funcname) > 1
	                push!(symstate.references, funcname[end - 1]) # reference the module of the extended function
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
	    elseif ex.head == :try
	        symstate = SymbolsState()
	
	        # Handle catch first
	        if ex.args[3] != false
	            union!(symstate, explore_inner_scoped(ex.args[3], scopestate))
	            # If we catch a symbol, it could shadow a global reference, remove it
	            if ex.args[2] != false
	                setdiff!(symstate.references, Symbol[ex.args[2]])
	            end
	        end
	
	        # Handle the try block
	        union!(symstate, explore_inner_scoped(ex.args[1], scopestate))
	
	        # Finally, handle finally
	        if length(ex.args) == 4
	            union!(symstate, explore_inner_scoped(ex.args[4], scopestate))
	        end
	
	        return symstate
	    elseif ex.head == :(->)
	        # Creates local scope
	
	        tempname = Symbol("anon", rand(UInt64))
	
	        # We will rewrite this to a normal function definition, with a temporary name
	        funcroot = ex.args[1]
	        args_ex = if funcroot isa Symbol || (funcroot isa Expr && funcroot.head == :(::))
	            [funcroot]
	        elseif funcroot.head == :tuple || funcroot.head == :(...) || funcroot.head == :block
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
	            # temporarily set inglobalscope to true
	            old = scopestate.inglobalscope
	            scopestate.inglobalscope = true
	            result = explore!(globalisee, scopestate)
	            scopestate.inglobalscope = old
	            return result
	        else
	            @error "unknown global use" ex
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
	            @warn "unknown local use" ex
	            return explore!(localisee, scopestate)
	        end
	    elseif ex.head == :tuple
	        # Does not create scope
	        
	        # There are three (legal) cases:
	        # 1. Creating a tuple:
	        #   (a, b, c)
	        
	        # 2. Creating a named tuple:
	        #   (a=1, b=2, c=3)
	
	        # 3. Multiple assignments
	        # a,b,c = 1,2,3
	        # This parses to:
	        # head = :tuple
	        # args = [:a, :b, :(c=1), :2, :3]
	        # 
	        # 🤔
	        # we turn it into two expressions:
	        # 
	        # (a, b) = (2, 3)
	        # (c = 1)
	        # 
	        # and explore those :)
	
	        indexoffirstassignment = findfirst(a -> isa(a, Expr) && a.head == :(=), ex.args)
	        if indexoffirstassignment !== nothing
	            # we have one of two cases, see next `if`
	            indexofsecondassignment = findnext(a -> isa(a, Expr) && a.head == :(=), ex.args, indexoffirstassignment + 1)
	
	            if length(ex.args) == 1 || indexofsecondassignment !== nothing
	                # 2.
	                # we have a named tuple, e.g. (a=1, b=2)
	                new_args = map(ex.args) do a
	                    (a isa Expr && a.head == :(=)) ? a.args[2] : a
	                end
	                return explore!(Expr(:block, new_args...), scopestate)
	            else
	                # 3. 
	                # we have a tuple assignment, e.g. `a, (b, c) = [1, [2, 3]]`
	                before = ex.args[1:indexoffirstassignment - 1]
	                after = ex.args[indexoffirstassignment + 1:end]
	
	                symstate_middle = explore!(ex.args[indexoffirstassignment], scopestate)
	                symstate_outer = explore!(Expr(:(=), Expr(:tuple, before...), Expr(:block, after...)), scopestate)
	
	                return union!(symstate_middle, symstate_outer)
	            end
	        else
	            # 1.
	            # good ol' tuple
	            return explore!(Expr(:block, ex.args...), scopestate)
	        end
	    elseif ex.head == :(.) && ex.args[2] isa Expr && ex.args[2].head == :tuple
	        # pointwise function call, e.g. sqrt.(nums)
	        # we rewrite to a regular call
	
	        return explore!(Expr(:call, ex.args[1], ex.args[2].args...), scopestate)
	    elseif ex.head == :using || ex.head == :import
	        imports = if ex.args[1].head == :(:)
	            ex.args[1].args[2:end]
	        else
	            ex.args
	        end
	
	        packagenames = map(e -> e.args[end], imports)
	
	        return SymbolsState(assignments=Set{Symbol}(packagenames))
	    elseif ex.head == :quote
	        # We ignore contents
	
	        return SymbolsState()
	    elseif ex.head == :module
	        # We ignore contents; the module name is a definition
	
	        return SymbolsState(assignments=Set{Symbol}([ex.args[2]]))
	    else
	        # fallback, includes:
	        # begin, block, do, toplevel, const
	        # (and hopefully much more!)
	        
	        # Does not create scope (probably)
	
	        return mapfoldl(a -> explore!(a, scopestate), union!, ex.args, init=SymbolsState())
	    end
	end
	
	"Return the function name and the SymbolsState from argument defaults. Add arguments as hidden globals to the `scopestate`.
	
	Is also used for `struct` and `abstract`."
	function explore_funcdef!(ex::Expr, scopestate::ScopeState)::Tuple{FunctionName,SymbolsState}
	    if ex.head == :call
	        params_to_explore = ex.args[2:end]
	        # Using the keyword args syntax f(;y) the :parameters node is the first arg in the AST when it should
	        # be explored last. We change from (parameters, ...) to (..., parameters)
	        if length(params_to_explore) >= 2 && params_to_explore[1] isa Expr && params_to_explore[1].head == :parameters
	            params_to_explore = [params_to_explore[2:end]..., params_to_explore[1]]
	        end
	
	        # Handle struct as callables, `(obj::MyType)(a, b) = ...`
	        # or `function (obj::MyType)(a, b) ...; end` by rewriting it as:
	        # function MyType(obj, a, b) ...; end
	        funcroot = ex.args[1]
	        if funcroot isa Expr && funcroot.head == :(::)
	            return explore_funcdef!(Expr(:call, reverse(funcroot.args)..., params_to_explore...), scopestate)
	        end
	
	        # get the function name
	        name, symstate = explore_funcdef!(funcroot, scopestate)
	        # and explore the function arguments
	        return mapfoldl(a -> explore_funcdef!(a, scopestate), union!, params_to_explore, init=(name, symstate))
	    elseif ex.head == :(::) || ex.head == :kw || ex.head == :(=)
	        # account for unnamed params, like in f(::Example) = 1
	        if ex.head == :(::) && length(ex.args) == 1
	            symstate = explore!(ex.args[1], scopestate)
	
	            return Symbol[], symstate
	        end
	        
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
	        return split_funcname(ex), SymbolsState()
	
	    elseif ex.head == :(...)
	        return explore_funcdef!(ex.args[1], scopestate)
	    else
	        return Symbol[], explore!(ex, scopestate)
	    end
	end
	
	function explore_inner_scoped(ex::Expr, scopestate::ScopeState)::SymbolsState
		# Because we are entering a new scope, we create a copy of the current scope state, and run it through the expressions.
		innerscopestate = deepcopy(scopestate)
		innerscopestate.inglobalscope = false

		return mapfoldl(a -> explore!(a, innerscopestate), union!, ex.args, init=SymbolsState())
	end
end

# ╔═╡ 54f0b52b-7c8e-40fd-83e9-4d0658e16aa8
md"""
## Utility functions
"""

# ╔═╡ ae138a1f-02cc-4121-a9c4-e4bd4c883645
"Get the global references, assignment, function calls and function defintions inside an arbitrary expression."
function compute_symbolreferences(ex::Any)::SymbolsState
    symstate = explore!(ex, ScopeState())

    # We do something special to account for recursive functions:
    # If a function `f` calls a function `g`, and both are defined inside this cell, the reference to `g` inside the symstate of `f` will be deleted.
    # The motivitation is that normally, an assignment (or function definition) will add that symbol to a list of 'hidden globals' - any future references to that symbol will be ignored. i.e. the _local definition hides a global_.
    # In the case of functions, you can reference functions and variables that do not yet exist, and so they won't be in the list of hidden symbols when the function definition is analysed. 
    # Of course, our method will fail if a referenced function is defined both inside the cell **and** in another cell. However, this will lead to a MultipleDefinitionError before anything bad happens.
    for (func, inner_symstate) in symstate.funcdefs
        inner_symstate.references = setdiff(inner_symstate.references, keys(symstate.funcdefs))
        inner_symstate.funccalls = setdiff(inner_symstate.funccalls, keys(symstate.funcdefs))
    end
    symstate
end

# ╔═╡ 18119967-10db-4f99-b73c-63f140a650ae
function try_compute_symbolreferences(ex::Any)::SymbolsState
	try
		compute_symbolreferences(ex)
	catch e
		@error "Expression explorer failed on: " ex
		showerror(stderr, e, stacktrace(catch_backtrace()))
		SymbolsState(references=Set{Symbol}([:fake_reference_to_prevent_it_from_looking_like_a_text_only_cell]))
	end
end

# ╔═╡ 330c6c6c-dbac-4bb4-8838-6197dccf187a
Base.@kwdef struct UsingsImports
    usings::Set{Expr}=Set{Expr}()
    imports::Set{Expr}=Set{Expr}()
end

# ╔═╡ 92ac6349-238a-4a2e-a8a1-8e6d0c6e52b4
# Performance analysis: https://gist.github.com/fonsp/280f6e883f419fb3a59231b2b1b95cab
"Preallocated version of [`compute_usings_imports`](@ref)."
function compute_usings_imports!(out::UsingsImports, ex::Any)
    if isa(ex, Expr)
        if ex.head == :using
			push!(out.usings, ex)
		elseif ex.head == :import
			push!(out.imports, ex)
        elseif ex.head != :quote
			for a in ex.args
				compute_usings_imports!(out, a)
			end
        end
    end
	out
end

# ╔═╡ f4d83216-9bf0-4f7d-a1db-db2ce3dd85e2
"""
Given `:(using Plots, Something.Else, .LocalModule)`, return `Set([:Plots, :Something])`.
"""
function external_package_names(ex::Expr)::Set{Symbol}
	@assert ex.head == :import || ex.head == :using
	if Meta.isexpr(ex.args[1], :(:))
		external_package_names(Expr(ex.head, ex.args[1].args[1]))
	else
		out = Set{Symbol}()
		for a in ex.args
			if Meta.isexpr(a, :(.))
				if a.args[1] != :(.)
					push!(out, a.args[1])
				end
			end
		end
		out
	end
end

# ╔═╡ bafbb031-015a-40e6-82e1-4a8a9bafc683
function external_package_names(x::UsingsImports)::Set{Symbol}
    union!(Set{Symbol}(), external_package_names.(x.usings)..., external_package_names.(x.imports)...)
end

# ╔═╡ 30224555-0231-44fe-8d9b-0fbcfc3e5ed6
"Get the sets of `using Module` and `import Module` subexpressions that are contained in this expression."
compute_usings_imports(ex) = compute_usings_imports!(UsingsImports(), ex)

# ╔═╡ 0c92d67a-4c75-4911-a204-aa02e3ae5b50
"Return whether the expression is of the form `Expr(:toplevel, LineNumberNode(..), any)`."
function is_toplevel_expr(ex::Expr)::Bool
    (ex.head == :toplevel) && (length(ex.args) == 2) && (ex.args[1] isa LineNumberNode)
end

# ╔═╡ e58517e2-ace0-4c7d-ab6b-63eac43f04b4
is_toplevel_expr(::Any)::Bool = false

# ╔═╡ 71e3b2e0-c4c3-495d-8c4e-9422237acce0
"If the expression is a (simple) assignemnt at its root, return the assignee as `Symbol`, return `nothing` otherwise."
function get_rootassignee(ex::Expr, recurse::Bool=true)::Union{Symbol,Nothing}
    if is_toplevel_expr(ex) && recurse
        get_rootassignee(ex.args[2], false)
    elseif ex.head == :(=) && ex.args[1] isa Symbol
        ex.args[1]
    else
        nothing
    end
end

# ╔═╡ 2619bc65-91ef-494b-8e8b-2c0c46dab2eb
get_rootassignee(ex::Any, recuse::Bool=true)::Union{Symbol,Nothing} = nothing

# ╔═╡ 01e9c7c5-b1ae-43a2-ac48-e01f5dc1b121
"Is this code simple enough that we can wrap it inside a function to boost performance? Look for [`PlutoRunner.Computer`](@ref) to learn more."
function can_be_function_wrapped(x::Expr)
    if x.head === :global || # better safe than sorry
        x.head === :using ||
        x.head === :import ||
        x.head === :module ||
        x.head === :function ||
        x.head === :macro ||
        x.head === :macrocall || # we might want to get rid of this one, but that requires some work
        x.head === :struct ||
        x.head === :abstract ||
        (x.head === :(=) && x.args[1] isa Expr && x.args[1].head === :call) || # f(x) = ...
        (x.head === :call && (x.args[1] === :eval || x.args[1] === :include))
        false
    else
        all(can_be_function_wrapped, x.args)
    end

end

# ╔═╡ a27079be-edd0-4476-bc52-68718a41d4c4
can_be_function_wrapped(x::Any) = true

# ╔═╡ 328ce9d2-c40b-41db-837b-c7fe1dd7124c
md"""
# Tests
"""

# ╔═╡ d5063ce7-e087-4560-a384-0d698501652a
md"""
## Basics
"""

# ╔═╡ 3bc7bfae-0e93-4244-b574-a9a5aaf928ed
md"""
## Bad code
"""

# ╔═╡ 96f715d4-63f3-477f-a2d5-2c40e0d169b9
# @test_nowarn testee(:(begin end = 2), [:+], [], [:+], [], verbose=false)

# ╔═╡ 4123a087-5bb8-4800-8c35-06f1e2d228f3
md"""
## Lists and structs
"""

# ╔═╡ 6c86a680-fba4-4b12-8843-796a5f08908c
md"""
## Types
"""

# ╔═╡ 7e4cf861-f9f7-46b4-a7d2-36575386259c
e = :(struct a end) # needs to be on its own line to create LineNumberNode

# ╔═╡ eaed818a-db26-48b9-a67a-3d5c053c9042
# @test_broken testee(:(struct a; c; a(x=y) = new(x,z); end), [], [:a], [], [:a => ([:y, :z], [], [], [])], verbose=false)

# ╔═╡ ddc53446-47f9-44a0-90b2-b4dc78d05ea5
md"""
## Assignment operator & modifiers
"""

# ╔═╡ e2278c1e-08f5-464f-823c-005a11f89a67
md"""
## Tuples
"""

# ╔═╡ bc23ca49-9e27-4ac1-a69a-6e058ee6492e
md"""
## Broadcasting
"""

# ╔═╡ f7745551-43ff-4926-a46c-75dc4b245483
md"""
## `for` & `while`
"""

# ╔═╡ 23db8066-d160-4473-946a-b207b449c200
md"""
## `try` & `catch`
"""

# ╔═╡ a974f92d-ab1b-45e3-98dd-462411433c4a
md"""
## Comprehensions
"""

# ╔═╡ 9bff229a-d4cf-441d-8f41-da08705ac002
md"""
## Multiple expressions
"""

# ╔═╡ cc6186a4-d2d5-4685-9bc9-cab2756de84e
md"""
## Functions
"""

# ╔═╡ 722991a1-c795-492b-9d48-e844900df444
md"""
## Functions & types
"""

# ╔═╡ de9cb953-91c0-4721-8a3a-4dfb45fae751
md"""
## Scope modifiers
"""

# ╔═╡ 9a1d70b5-bd83-43f8-a1a6-77f87a3f842c
md"""
## `import` & `using`
"""

# ╔═╡ a850ac6c-db6a-4a47-ab56-34c73cdb17e9
md"""
## Foreign macros

#### parameterizedfunctions
"""

# ╔═╡ 74c75ffd-bac8-44cf-849b-731ac6ee709f
md"""
#### Flux
"""

# ╔═╡ 82e37385-3599-49a2-8045-b4e96a091e7a
md"""
#### Symbolics.jl
"""

# ╔═╡ d599b8d4-9830-48ae-bce7-4efc0a71b148
md"""
#### JuMP
"""

# ╔═╡ 74976495-edd2-4c11-ae80-e742aa9183c1
# @test testee(:(@variable(m, x)), [:m], [:x], [Symbol("@variable")], [])

# ╔═╡ e284a0d0-b14e-4694-8f06-a4555c30d9a8
# @test testee(:(@variable(m, 1<=x)), [:m], [:x], [Symbol("@variable")], [])

# ╔═╡ bf41bce3-4a14-400f-8998-a843e6e6c21e
# @test testee(:(@variable(m, 1<=x<=2)), [:m], [:x], [Symbol("@variable")], [])

# ╔═╡ 5fb54853-62a1-4835-be1e-c3850c6907da
# @test testee(:(@variable(m, r <= x[i=keys(asdf)] <= ub[i])), [:m, :r, :asdf, :ub], [:x], [:keys, Symbol("@variable")], [])

# ╔═╡ 7a4f1254-ec88-45a0-9c25-04747acc536e
# @test testee(:(@variable(m, x, lower_bound=0)), [:m], [:x], [Symbol("@variable")], [])

# ╔═╡ c24668f0-83b6-4908-bcb0-1a3316cd2329
# @test testee(:(@variable(m, base_name="x", lower_bound=0)), [:m], [], [Symbol("@variable")], [])

# ╔═╡ 5836e420-ef8d-41c3-8477-352b8f868171
# @test testee(:(@variables(m, begin
#         x
#         y[i=1:2] >= i, (start = i, base_name = "Y_$i")
#         z, Bin
#     end)), [:m, :Bin], [:x, :y, :z], [Symbol("@variables")], [])

# ╔═╡ fb51b596-2f8f-4efd-9b74-10ac0dc5a4ca
md"""
## Macros
"""

# ╔═╡ 7ecb3fcf-b780-4ee7-8d39-2308fd2b2543
md"""
## String interpolation & expressions
"""

# ╔═╡ 13a2accc-78f6-481b-bc66-67cda891e88e
# @test_broken testee(:(ex = :(yayo + $r)), [:r], [:ex], [], [], verbose=false)

# ╔═╡ b15af250-acce-4202-a1aa-56e7e06363b6
md"""
## Extracting `using` and `import`
"""

# ╔═╡ ea51ec5d-ae1a-41bd-934b-93b77b6c6e9b
using_test_expr = quote
            using A
            import B
            if x
                using .C: r
                import ..D.E: f, g
            else
                import H.I, J, K.L
            end
            
            quote
                using Nonono
            end
        end

# ╔═╡ 330ea4da-48f2-46f2-98a7-f7e83e8f13ad
using_test_result = compute_usings_imports(using_test_expr)

# ╔═╡ cd3bdb3a-f688-4b59-b9be-394369bec02c
md"""
# Appendix

"""

# ╔═╡ e8387d5d-ebaa-484f-9ca5-9fda1ace0f5d
function easy_symstate(expected_references, expected_definitions, expected_funccalls, expected_funcdefs)
    new_expected_funccalls = map(expected_funccalls) do k
        new_k = k isa Symbol ? [k] : k
        return new_k
    end |> Set
    
    new_expected_funcdefs = map(expected_funcdefs) do (k, v)
        new_k = k isa Symbol ? [k] : k
        new_v = v isa SymbolsState ? v : easy_symstate(v...)
        return FunctionNameSignaturePair(new_k, "hello") => new_v
    end |> Dict

    SymbolsState(Set(expected_references), Set(expected_definitions), new_expected_funccalls, new_expected_funcdefs)
end

# ╔═╡ 922ca93a-8f84-4eb3-a21f-bd343c5e9a60
"Calls `ExpressionExplorer.compute_symbolreferences` on the given `expr` and test the found SymbolsState against a given one, with convient syntax.

# Example

```jldoctest
julia> @test testee(:(
    begin
        a = b + 1
        f(x) = x / z
    end),
    [:b, :+], # 1st: expected references
    [:a, :f], # 2nd: expected definitions
    [:+],     # 3rd: expected function calls
    [
        :f => ([:z, :/], [], [:/], [])
    ])        # 4th: expected function definitions, with inner symstate using the same syntax
true
```
"
function testee(expr, expected_references, expected_definitions, expected_funccalls, expected_funcdefs; verbose::Bool=true)
    expected = easy_symstate(expected_references, expected_definitions, expected_funccalls, expected_funcdefs)

    original_hash = PlutoRunner.expr_hash(expr)
    result = compute_symbolreferences(expr)
    new_hash = PlutoRunner.expr_hash(expr)
    if original_hash != new_hash
        error("\n== The expression explorer modified the expression. Don't do that! ==\n")
    end

    # Anonymous function are given a random name, which looks like anon67387237861123
    # To make testing easier, we rename all such functions to anon
    new_name(sym) = startswith(string(sym), "anon") ? :anon : sym

    result.assignments = Set(new_name.(result.assignments))
    result.funcdefs = let
        newfuncdefs = Dict{FunctionNameSignaturePair,SymbolsState}()
        for (k, v) in result.funcdefs
            union!(newfuncdefs, Dict(FunctionNameSignaturePair(new_name.(k.name), "hello") => v))
        end
        newfuncdefs
    end

    if verbose && expected != result
        println()
        println("FAILED TEST")
        println(expr)
        println()
        dump(expr, maxdepth=20)
        println()
        @show expected
        resulted = result
        @show resulted
        println()
    end
    return expected == result
end

# ╔═╡ 91361cea-7403-45f8-a5ba-bbff1ffc72b2
@test_nowarn testee(:((a = b, c, d = 123,)), [:b], [], [], [], verbose=false)

# ╔═╡ 2bb9df64-f747-4301-a5ef-a86e17f23ac4
@test_nowarn testee(:((a = b, c[r] = 2, d = 123,)), [:b], [], [], [], verbose=false)

# ╔═╡ ef46a5a9-0d16-4b41-8208-fd35d1fb543a
@test_nowarn testee(:(function f(function g() end) end), [], [], [:+], [], verbose=false)

# ╔═╡ b7af6fc6-07e0-4fad-8ffb-47a991d4ec8e
@test_nowarn testee(:(function f() Base.sqrt(x::String) = 2; end), [], [], [:+], [], verbose=false)

# ╔═╡ 1d3fa553-bed2-4d92-9426-7f29429b7154
@test_nowarn testee(:(function f() global g(x) = x; end), [], [], [], [], verbose=false)

# ╔═╡ 5471eace-c292-4a24-878f-8ce98f66b9ff
@test_nowarn testee(macroexpand(Main, :(@enum a b c)), [], [], [], []; verbose=false)

# ╔═╡ 48d7d4dd-2897-43a9-8dad-a21c9ade412d
@test_broken testee(:(let global a = b = 1 end), [], [:a], [], []; verbose=false)

# ╔═╡ dcebeb3d-92ab-48bc-bb8d-f621a225013a
@test_broken testee(:(let global k = r end), [], [:k], [], []; verbose=false)

# ╔═╡ 7caeeeed-2298-439b-8f04-8548354bfae3
@test_broken testee(:(begin begin local a = 2 end; a end), [:a], [], [], []; verbose=false)

# ╔═╡ 29ef6810-7329-4d6e-915b-ebecd2c40c67
@test_nowarn testee(:(@variables(m, begin
	x
	y[i=1:2] >= i, (start = i, base_name = "Y_$i")
	z, Bin
end)), [:m, :Bin], [:x, :y, :z], [Symbol("@variables")], [], verbose=false)

# ╔═╡ e0a6fe33-0931-4605-9c00-b23948e7cf1e
@test_broken testee(:(Main.PlutoRunner.@bind a b), [:b, :PlutoRunner, :Base, :Core], [:a], [[:Base, :get], [:Core, :applicable], [:PlutoRunner, :Bond], [:PlutoRunner, Symbol("@bind")]], [], verbose=false)

# ╔═╡ 232d81a4-0d08-41cf-8107-32e5553651d5
md"""
## Visual testing
"""

# ╔═╡ c4d02f9d-15a1-4e6f-a479-c00309522f30
abstract type TestResult end

# ╔═╡ f53fec22-fc14-4ee9-812c-4943de4eb64d
const Code = Any

# ╔═╡ 881b506b-bffa-4e9c-94bd-97488ce8849a
struct Pass <: TestResult
	expr::Code
end

# ╔═╡ e28ead62-67c5-4836-b3b3-9a7b8bfc5d88
abstract type Fail <: TestResult end

# ╔═╡ 53e22b9a-58ae-4fec-ac52-aeff1ca86216
struct Wrong <: Fail
	expr::Code
	result
end

# ╔═╡ 2b317c60-0ae0-4184-af23-a5385841eed0
struct Error <: Fail
	expr::Code
	error
end

# ╔═╡ 3faca86e-1db7-4904-9a0f-cda972feaa07
macro test2(expr)
	quote nothing end
end

# ╔═╡ 566f65d4-d9b2-41db-8cb1-e28c0e0100a2
remove_linenums(e::Expr) = Expr(e.head, (remove_linenums(x) for x in e.args if !(x isa LineNumberNode))...)

# ╔═╡ de53af16-adfe-4309-b696-ab39e7a3cfa7
remove_linenums(x) = x

# ╔═╡ 87d7391f-7bb8-4e34-9f00-0dca594441b7
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
			>$(remove_linenums(value.expr))</code>
		</div>
	"""))
end

# ╔═╡ c4c57464-3143-4b0d-ac3f-6213540dc42f
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
			>$(remove_linenums(value.expr))</code>
		</div>
	"""))
end

# ╔═╡ 0a166ca9-4bc5-4a38-bbc5-20c6ff7ce325
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
				>$(remove_linenums(value.expr))</code>
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

# ╔═╡ 91f8c26c-b9fe-42fe-800e-5c039a12ac6c
md"## DisplayOnly"

# ╔═╡ 480643c6-6fc3-4ba6-8546-d3212c07ce7e
function skip_as_script(m::Module)
	if isdefined(m, :PlutoForceDisplay)
		return m.PlutoForceDisplay
	else
		isdefined(m, :PlutoRunner) && parentmodule(m) == Main
	end
end

# ╔═╡ 21b284e0-bf27-46ae-8bf6-ebef1da80181
"""
	@displayonly expression

Marks a expression as Pluto-only, which means that it won't be executed when running outside Pluto. Do not use this for your own projects.
"""
macro skip_as_script(ex) skip_as_script(__module__) ? esc(ex) : nothing end

# ╔═╡ c8b83bdb-e0e1-42c7-bd83-87c352f77d0b
"The opposite of `@skip_as_script`"
macro only_as_script(ex) skip_as_script(__module__) ? nothing : esc(ex) end

# ╔═╡ 1f344c37-9775-4f06-92cf-2ae8831a43bc
# Only define this in Pluto - assume we are `using Test` otherwise
begin
	@skip_as_script macro test(expr)
		quote				
			expr_raw = $(expr |> QuoteNode)
			try
				result = $(esc(expr))
				if result == true
					Pass(expr_raw)
    				else
					Wrong(expr_raw, result)
				end
			catch e
				Error(expr_raw, e)
			end
			
			# Base.@locals()
		end
	end
	# Do nothing inside pluto (so we don't need to have Test as dependency)
	# test/Diffing is `using Test` before including this file
	@only_as_script ((@isdefined Test) ? nothing : macro test(expr) quote nothing end end)
end

# ╔═╡ 4316fc34-a5a3-403b-93ac-3bb1443f4bbf
@test testee(:(a), [:a], [], [], [])

# ╔═╡ fb137bb7-358d-4dce-85bd-36708a0934f7
@test testee(:(1 + 1), [], [], [:+], [])

# ╔═╡ 9130b418-f372-4374-827e-5c2d08df4228
@test testee(:(sqrt(1)), [], [], [:sqrt], [])

# ╔═╡ 73b6165d-d0da-4d59-9467-028a747cce56
@test testee(:(x = 3), [], [:x], [], [])

# ╔═╡ 1d29e7ed-2ea1-462e-9c55-835606e8b2b9
@test testee(:(x = x), [:x], [:x], [], [])

# ╔═╡ b6b72034-48ef-4a90-9a2b-c7b7359fdac2
@test testee(:(x = 1 + y), [:y], [:x], [:+], [])

# ╔═╡ 1251a926-b661-4b0b-994b-49eeecddd04e
@test testee(:(x = +(a...)), [:a], [:x], [:+], [])

# ╔═╡ fd810e7f-0f9b-4f25-b147-0e2bac7015b2
@test testee(:(1:3), [], [], [:(:)], [])

# ╔═╡ d579f690-c3a6-4e5e-9412-f89fdb9413ba
@test testee(:(123 = x), [:x], [], [], [])

# ╔═╡ 477e2052-7606-4994-b3e6-cab6ed0e2142
@test testee(:(1:3), [], [], [:(:)], [])

# ╔═╡ d86af429-7a8b-4f15-acef-13ff648ffe5b
@test testee(:(a[1:3,4]), [:a], [], [:(:)], [])

# ╔═╡ 0581fc79-666c-4949-b5f2-7b8c89a3c1f8
@test testee(:(a[b]), [:a, :b], [], [], [])

# ╔═╡ c09c054a-d1a1-4af0-a8d2-6f6e619bb961
@test testee(:([a[1:3,4]; b[5]]), [:b, :a], [], [:(:)], [])

# ╔═╡ 4d40297a-bf4e-4712-81d6-3fb2e3ef62ad
@test testee(:(a.someproperty), [:a], [], [], []) # `a` can also be a module

# ╔═╡ 320f6cb9-a69f-4e41-82a9-0d4864a202ef
@test testee(:([a..., b]), [:a, :b], [], [], [])

# ╔═╡ 280552a6-b3e2-4105-8f4d-acbb53c8f512
@test testee(:(struct a; b; c; end), [], [:a], [], [
            :a => ([], [], [], [])
            ])

# ╔═╡ 9f813396-c2a5-443e-973b-1afb2ae0b7f4
@test testee(:(let struct a; b; c; end end), [], [:a], [], [
            :a => ([], [], [], [])
            ])

# ╔═╡ 8e98c015-26f4-464c-a8a1-bb7f356387c8
@test testee(:(module a; f(x) = x; z = r end), [], [:a], [], [])

# ╔═╡ 6006218d-68b7-42d0-b6e0-970dec9b40ff
@test testee(:(x::Foo = 3), [:Foo], [:x], [], [])

# ╔═╡ 13d493fc-2be3-4020-9c04-e2907d35d1a4
@test testee(:(x::Foo), [:x, :Foo], [], [], [])

# ╔═╡ 642799e2-a7bb-4e50-b248-41236839c397
@test testee(:(a::Foo, b::String = 1, "2"), [:Foo, :String], [:a, :b], [], [])

# ╔═╡ 5549fb1d-35ae-4a03-a095-36b21d914ec3
@test testee(:(Foo[]), [:Foo], [], [], [])

# ╔═╡ 68897b77-b6c5-4430-be2a-13525b9376a8
@test testee(:(x isa Foo), [:x, :Foo], [], [:isa], [])

# ╔═╡ 639772ac-9d66-4f7a-9d67-d3e66d2573ef
@test testee(:(A{B} = B), [], [:A], [], [])

# ╔═╡ 76e05576-ff3c-40d2-9234-101a658782ab
@test testee(:(A{T} = Union{T,Int}), [:Int, :Union], [:A], [], [])

# ╔═╡ 01852ece-6948-4e53-9168-8fadc02487f0
@test testee(:(abstract type a end), [], [:a], [], [:a => ([], [], [], [])])

# ╔═╡ fb7800b8-4f19-4d64-a621-238b118d19ba
@test testee(:(abstract type a <: b end), [], [:a], [], [:a => ([:b], [], [], [])])

# ╔═╡ 734f3a1c-5810-45e8-a597-84727c4ae732
@test testee(:(abstract type a <: b{C} end), [], [:a], [], [:a => ([:b, :C], [], [], [])])

# ╔═╡ f886b93c-93fc-4fb2-9cc5-e19862c69282
@test testee(:(abstract type a{T} end), [], [:a], [], [:a => ([], [], [], [])])

# ╔═╡ 76c82263-b131-4a85-a0de-0813ae32395f
@test testee(:(abstract type a{T,S} end), [], [:a], [], [:a => ([], [], [], [])])

# ╔═╡ 782bca7f-ce5b-4897-a30a-cc12a414e20f
@test testee(:(abstract type a{T} <: b end), [], [:a], [], [:a => ([:b], [], [], [])])

# ╔═╡ 9d38c307-db99-4868-a06d-c4bdd8cab71c
@test testee(:(abstract type a{T} <: b{T} end), [], [:a], [], [:a => ([:b], [], [], [])])

# ╔═╡ 026f0d7f-0f27-4908-9fe6-24c283b1a563
@test testee(e, [], [:a], [], [:a => ([], [], [], [])])

# ╔═╡ 4553e5b9-37bd-48c3-b6b0-06f32213744e
@test testee(:(struct a <: b; c; d::Foo; end), [], [:a], [], [:a => ([:b, :Foo], [], [], [])])

# ╔═╡ febb907d-6154-4de9-90db-009d9ba4f844
@test testee(:(struct a{T,S}; c::T; d::Foo; end), [], [:a], [], [:a => ([:Foo], [], [], [])])

# ╔═╡ 5233a304-b113-4042-a4a7-25567e5e7dd9
@test testee(:(struct a{T} <: b; c; d::Foo; end), [], [:a], [], [:a => ([:b, :Foo], [], [], [])])

# ╔═╡ 634391d0-d796-435f-94d7-0b4a218ac63c
@test testee(:(struct a{T} <: b{T}; c; d::Foo; end), [], [:a], [], [:a => ([:b, :Foo], [], [], [])])

# ╔═╡ 2bd9bdd1-ac97-4b84-9b93-caf27199005b
@test testee(:(struct a; c; a(x=y) = new(x, z); end), [], [:a], [], [:a => ([:y, :z], [], [:new], [])])

# ╔═╡ 08dd1427-3fe2-4881-accb-63e74fc09d2a
# https://github.com/JuliaLang/julia/blob/f449765943ba414bd57c3d1a44a73e5a0bb27534/base/docs/basedocs.jl#L239-L244
@test testee(:(a = a), [:a], [:a], [], [])

# ╔═╡ 2da962f0-7d28-4c5c-a419-aa04a9a0aba8
@test testee(:(a = a + 1), [:a], [:a], [:+], [])

# ╔═╡ e79001db-350b-4b58-a258-6c2856407f80
@test testee(:(x = a = a + 1), [:a], [:a, :x], [:+], [])

# ╔═╡ f4a1b2f5-aae4-49a5-a074-f6da17208aef
@test testee(:(const a = b), [:b], [:a], [], [])

# ╔═╡ 80eed313-3a66-4307-8f7d-aee57f2101a2
@test testee(:(f(x) = x), [], [], [], [:f => ([], [], [], [])])

# ╔═╡ 231abb23-c4fb-4932-a53b-cc2ab8e67afe
@test testee(:(a[b,c,:] = d), [:a, :b, :c, :d, :(:)], [], [], [])

# ╔═╡ e38ede40-17bf-413a-a122-ce86be55e6c1
@test testee(:(a.b = c), [:a, :c], [], [], [])

# ╔═╡ 5616aca9-1753-413b-93da-85cd6744c48a
@test testee(:(f(a, b=c, d=e; f=g)), [:a, :c, :e, :g], [], [:f], [])

# ╔═╡ 64492814-c3e9-463b-9061-1b143563ad14
@test testee(:(a += 1), [:a], [:a], [:+], [])

# ╔═╡ 48235722-e548-42c3-8eaf-b8bf9e215cac
@test testee(:(a >>>= 1), [:a], [:a], [:>>>], [])

# ╔═╡ fffdc756-8fd6-4f66-a48d-c589f689c551
@test testee(:(a ⊻= 1), [:a], [:a], [:⊻], [])

# ╔═╡ 55a1e6bb-7b63-4f0f-b78b-fd3fada55135
@test testee(:(a[1] += 1), [:a], [], [:+], [])

# ╔═╡ c537a96a-9a10-45c2-97fc-1162850b4ee3
@test testee(:(x = let a = 1; a += b end), [:b], [:x], [:+], [])

# ╔═╡ 49fcd36f-dabb-45a7-9ef1-adab8c8f6fb6
@test testee(:(_ = a + 1), [:a], [], [:+], [])

# ╔═╡ 35dc09f2-8188-4a5e-82bb-45ac90c4f628
@test testee(:(a = _ + 1), [], [:a], [:+], [])

# ╔═╡ d6023a45-bda9-4313-955a-9d96463a4724
@test testee(:((a, b,)), [:a,:b], [], [], [])

# ╔═╡ 4eb571b9-6489-427d-b1e4-ab174d500f5a
@test testee(:((a = b, c = 2, d = 123,)), [:b], [], [], [])

# ╔═╡ 84c449f8-a65d-4fa6-956e-478ce53918bd
@test testee(:((a = b,)), [:b], [], [], [])

# ╔═╡ 19d2c818-2994-418b-af4f-cb990fc66b4e
@test testee(:(a, b = 1, 2), [], [:a, :b], [], [])

# ╔═╡ e10c290b-e2e2-4188-82e7-0b9b950fad38
@test testee(:(a, _, c, __ = 1, 2, 3, _d), [:_d], [:a, :c], [], [])

# ╔═╡ 0ec7933b-e890-47a4-aff6-cb96c31516b9
@test testee(:(const a, b = 1, 2), [], [:a, :b], [], [])

# ╔═╡ 88249399-b5e9-410d-ab05-6717fe49fc78
@test testee(:((a, b) = 1, 2), [], [:a, :b], [], [])

# ╔═╡ e8c3fa46-e098-4716-b53a-82b19857873d
@test testee(:(a = b, c), [:b, :c], [:a], [], [])

# ╔═╡ ec07820b-c701-4737-bcbe-2a7a0c3b6e10
@test testee(:(a, b = c), [:c], [:a, :b], [], [])

# ╔═╡ e88e292c-f837-4b0c-b7b1-667a0af52c30
@test testee(:(a = (b, c)), [:b, :c], [:a], [], [])

# ╔═╡ 04a865b1-d6b5-4439-90b9-21d374e568ea
@test testee(:(a, (b, c) = [e,[f,g]]), [:e, :f, :g], [:a, :b, :c], [], [])

# ╔═╡ 8b3dcc1e-7dec-4ede-b575-2236a8c65b26
@test testee(:((x, y), a, (b, c) = z, e, (f, g)), [:z, :e, :f, :g], [:x, :y, :a, :b, :c], [], [])

# ╔═╡ 2853b855-445f-4a19-80e1-171f22b9dfda
@test testee(:((x[i], y.r), a, (b, c) = z, e, (f, g)), [:x, :i, :y, :z, :e, :f, :g], [:a, :b, :c], [], [])

# ╔═╡ 673d9a02-5445-4c8d-93b2-f128914cf40c
@test testee(:((a[i], b.r) = (c.d, 2)), [:a, :b, :i, :c], [], [], [])

# ╔═╡ 2f4e89cd-df44-4430-bb69-e7ac203d0f93
@test testee(:(a .= b), [:b, :a], [], [], []) # modifies elements, doesn't set `a`

# ╔═╡ a1845caa-289a-44c8-a4e7-219e407c53a8
@test testee(:(a .+= b), [:b, :a], [], [:+], [])

# ╔═╡ c17f4e0c-74ec-412b-aed2-32b6b326c5c0
@test testee(:(a[i] .+= b), [:b, :a, :i], [], [:+], [])

# ╔═╡ e5896b3b-d3c4-4234-9bf7-15c483e01b04
@test testee(:(a .+ b ./ sqrt.(c, d)), [:a, :b, :c, :d], [], [:+, :/, :sqrt], [])

# ╔═╡ c5db1553-63b2-4d2b-ac26-1bb054eb23cd
@test testee(:(for k in 1:n; k + s; end), [:n, :s], [], [:+, :(:)], [])

# ╔═╡ f72c18b2-0289-4045-a482-78a27612f7e0
@test testee(:(for k in 1:2, r in 3:4; global z = k + r; end), [], [:z], [:+, :(:)], [])

# ╔═╡ 5dd308e3-5019-4c33-9138-7fad2a8d6f0d
@test testee(:(while k < 2; r = w; global z = k + r; end), [:k, :w], [:z], [:+, :(<)], [])

# ╔═╡ abefc3bd-0572-49ee-814f-3ec1fe9ff61e
@test testee(:(try a = b + 1 catch; end), [:b], [], [:+], [])

# ╔═╡ 4d04958c-7bb2-4e07-832b-248ecf64523e
@test testee(:(try a() catch e; e end), [], [], [:a], [])

# ╔═╡ b49abfea-db9a-48ca-aa75-6a53768b4716
@test testee(:(try a() catch; e end), [:e], [], [:a], [])

# ╔═╡ a4c19d0f-7eb2-4173-b9cd-1d93900af0d3
@test testee(:(try a + 1 catch a; a end), [:a], [], [:+], [])

# ╔═╡ 110ab6ae-0153-4c6c-8ca7-1c93c7584af3
@test testee(:(try 1 catch e; e finally a end), [:a], [], [], [])

# ╔═╡ 2e41540a-d36c-4163-94b3-aa2c22b5c6f2
@test testee(:(try 1 finally a end), [:a], [], [], [])

# ╔═╡ 6fe3f79e-ec9c-4ab6-80ed-ef57bb1ce677
@test testee(:([sqrt(s) for s in 1:n]), [:n], [], [:sqrt, :(:)], [])

# ╔═╡ f92efb92-a8fe-4e5b-9b6f-a80e96c4a64a
@test testee(:([sqrt(s + r) for s in 1:n, r in k]), [:n, :k], [], [:sqrt, :(:), :+], [])

# ╔═╡ 4dba10c8-0c48-44fc-98c0-48bb291dd43e
@test testee(:([s + j + r + m for s in 1:3 for j in 4:5 for (r, l) in [(1, 2)]]), [:m], [], [:+, :(:)], [])

# ╔═╡ ad6570b6-b77d-4bdd-96db-00c8fd83865f
@test testee(:([a for a in b if a != 2]), [:b], [], [:(!=)], [])

# ╔═╡ fa3e3651-4a5b-48f3-8c25-c1caa84936b2
@test testee(:([a for a in f() if g(a)]), [], [], [:f, :g], [])

# ╔═╡ 4992fc86-f7be-4e5c-8391-a00b3e2badb3
@test testee(:([c(a) for a in f() if g(a)]), [], [], [:c, :f, :g], [])

# ╔═╡ 359fbb75-ef34-4eb6-972d-87c56b420eaf
@test testee(:([a for a in a]), [:a], [], [], [])

# ╔═╡ 08c24d09-71e8-47d1-a934-5620eb2a1a7e
@test testee(:(for a in a; a; end), [:a], [], [], [])

# ╔═╡ 89b68ad6-92e9-4e21-91e5-712b555dcb96
@test testee(:(let a = a; a; end), [:a], [], [], [])

# ╔═╡ bf5279b2-43c9-47ec-813d-dc7618f43b90
@test testee(:(let a = a end), [:a], [], [], [])

# ╔═╡ 46505628-9d10-401c-a9c5-404dafefb5b1
@test testee(:(let a = b end), [:b], [], [], [])

# ╔═╡ 74164ea4-9249-449c-9e68-a395acf0fdb5
@test testee(:(a = a), [:a], [:a], [], [])

# ╔═╡ 3c4fe183-9ffa-4fd0-a11c-db5472aa652c
@test testee(:(a = [a for a in a]), [:a], [:a], [], [])

# ╔═╡ 3dd306a2-b1d2-44a4-877e-78b599d293e9
@test testee(:(x = let r = 1; r + r end), [], [:x], [:+], [])

# ╔═╡ c84d7141-5d4c-48b2-9f95-417c0529a97d
@test testee(:(begin let r = 1; r + r end; r = 2 end), [], [:r], [:+], [])

# ╔═╡ 742ea57b-b6c9-4e92-a810-848f56b66bc0
@test testee(:((k = 2; 123)), [], [:k], [], [])

# ╔═╡ 431a7926-1891-4882-86a0-5167d1b1585d
@test testee(:((a = 1; b = a + 1)), [], [:a, :b], [:+], [])

# ╔═╡ f64f7532-5531-4ae8-83de-a96938bb73c7
@test testee(Meta.parse("a = 1; b = a + 1"), [], [:a, :b], [:+], [])

# ╔═╡ c34a0e2b-4838-40b9-b44e-6e9b33caeebc
@test testee(:((a = b = 1)), [], [:a, :b], [], [])

# ╔═╡ b569c514-2a5f-4785-b110-2ee6aa6a3ffb
@test testee(:(let k = 2; 123 end), [], [], [], [])

# ╔═╡ 225d17e6-5ed5-470f-8c23-cbc6b2c2a380
@test testee(:(let k() = 2 end), [], [], [], [])

# ╔═╡ 251cb88e-8f85-4fe3-80a5-5540b45d3c34
@test testee(:(function g() r = 2; r end), [], [], [], [
            :g => ([], [], [], [])
        ])

# ╔═╡ 62f5e3ee-44e1-49eb-a63f-5aa8d3ffbe8f
@test testee(:(function g end), [], [], [], [
            :g => ([], [], [], [])
        ])

# ╔═╡ a7902947-0a4d-492c-9826-3072624ae299
@test testee(:(function f() g(x) = x; end), [], [], [], [
            :f => ([], [], [], []) # g is not a global def
        ])

# ╔═╡ 7f144f6e-4b7b-4059-aeb0-545f42ca0420
@test testee(:(function f(x, y=1; r, s=3 + 3) r + s + x * y * z end), [], [], [], [
            :f => ([:z], [], [:+, :*], [])
        ])

# ╔═╡ 9f198164-f46c-4e8b-be57-bf3412495f2c
@test testee(:(function f(x) x * y * z end), [], [], [], [
            :f => ([:y, :z], [], [:*], [])
        ])

# ╔═╡ fcbe0db0-dc7c-4284-ab59-d0134520be05
@test testee(:(function f(x) x = x / 3; x end), [], [], [], [
            :f => ([], [], [:/], [])
        ])

# ╔═╡ 8e483239-9df2-4012-b0bb-99a96bdac825
@test testee(:(function f(x) a end; function f(x, y) b end), [], [], [], [
            :f => ([:a, :b], [], [], [])
        ])

# ╔═╡ 11e4becc-bcd8-4792-a227-12e9898c248c
@test testee(:(function f(x, args...; kwargs...) return [x, y, args..., kwargs...] end), [], [], [], [
            :f => ([:y], [], [], [])
        ])

# ╔═╡ 0e1cecd3-dc65-4db5-aee0-e6d32d510afc
@test testee(:(function f(x; y=x) y + x end), [], [], [], [
            :f => ([], [], [:+], [])
        ])

# ╔═╡ e8fcdcb3-e4de-4aeb-b88e-1b734164ca06
@test testee(:(function (A::MyType)(x; y=x) y + x end), [], [], [], [
            :MyType => ([], [], [:+], [])
        ])

# ╔═╡ fbd65695-d325-47da-8e6d-4cf59092690b
@test testee(:(f(x, y=a + 1) = x * y * z), [], [], [], [
            :f => ([:z, :a], [], [:*, :+], [])
        ])

# ╔═╡ 9339bfde-4187-475e-8bae-5021d3b19f38
@test testee(:(begin f() = 1; f end), [], [], [], [
            :f => ([], [], [], [])
        ])

# ╔═╡ 74642edc-6cfb-414a-875d-b7c6d54027bb
@test testee(:(begin f() = 1; f() end), [], [], [], [
            :f => ([], [], [], [])
        ])

# ╔═╡ d09edfbb-893f-4273-a252-8fbc75abec5d
@test testee(:(begin
                f(x) = (global a = √b)
                f(x, y) = (global c = -d)
            end), [], [], [], [
            :f => ([:b, :d], [:a, :c], [:√, :-], [])
        ])

# ╔═╡ 2fd1c324-ae62-4227-bea8-74da3f83cca5
@test testee(:(Base.show() = 0), [:Base], [], [], [
            [:Base, :show] => ([], [], [], [])
        ])

# ╔═╡ 1cc47456-a783-43c1-b17d-67296a4e868f
@test testee(:((x;p) -> f(x+p)), [], [], [], [
            :anon => ([], [], [:f, :+], [])
        ])

# ╔═╡ 530c0d15-0e64-4cb3-a002-a0600e43cf17
@test testee(:(begin x; p end -> f(x+p)), [], [], [], [
            :anon => ([], [], [:f, :+], [])
        ])

# ╔═╡ 8208dc01-643e-49a8-9f40-718b670015a4
@test testee(:(minimum(x) do (a, b); a + b end), [:x], [], [:minimum], [
            :anon => ([], [], [:+], [])
        ])

# ╔═╡ bbe0c333-4540-4d0e-8efd-34a7ec89a9a8
@test testee(:(f = x -> x * y), [], [:f], [], [
            :anon => ([:y], [], [:*], [])
        ])

# ╔═╡ 24ba3980-c43b-4e4b-8e5f-dec1d04cac25
@test testee(:(f = (x, y) -> x * y), [], [:f], [], [
            :anon => ([], [], [:*], [])
        ])

# ╔═╡ 60723c62-2c18-4395-95a0-e9089ab1c100
@test testee(:(f = (x, y = a + 1) -> x * y), [], [:f], [], [
            :anon => ([:a], [], [:*, :+], [])
        ])

# ╔═╡ 1359b139-5567-42b3-9816-867a9b16690b
@test testee(:((((a, b), c), (d, e)) -> a * b * c * d * e * f), [], [], [], [
            :anon => ([:f], [], [:*], [])
        ])

# ╔═╡ 3403ad5d-cdf5-4850-a198-2cc9dc093e5b
@test testee(:((a...) -> f(a...)), [], [], [], [
            :anon => ([], [], [:f], [])
        ])

# ╔═╡ c916c7e0-e02c-438a-af0d-7f8e11de4315
@test testee(:(f = (args...) -> [args..., y]), [], [:f], [], [
            :anon => ([:y], [], [], [])
        ])

# ╔═╡ f4b07b7e-a6d7-4f8c-a7be-19589535df35
@test testee(:(f = (x, args...; kwargs...) -> [x, y, args..., kwargs...]), [], [:f], [], [
            :anon => ([:y], [], [], [])
        ])

# ╔═╡ d3caf6fe-fcb3-4033-a3e9-4df5228da5d9
@test testee(:(f = function (a, b) a + b * n end), [:n], [:f], [:+, :*], [])

# ╔═╡ 7e6c7092-427b-40a6-8ede-0813a527cf90
@test testee(:(f = function () a + b end), [:a, :b], [:f], [:+], [])

# ╔═╡ 10ced374-4e40-436c-a0fc-29810181cd04
@test testee(:(func(a)), [:a], [], [:func], [])

# ╔═╡ f39c48ad-1e42-438c-bb95-01896cfa6b13
@test testee(:(func(a; b=c)), [:a, :c], [], [:func], [])

# ╔═╡ 57e6d6a4-a3d1-44b3-8317-1f20263feb38
@test testee(:(func(a, b=c)), [:a, :c], [], [:func], [])

# ╔═╡ bfb0ceda-ea57-41c0-a9d6-b94685e0dda8
@test testee(:(√ b), [:b], [], [:√], [])

# ╔═╡ 729a9558-2cdc-4e85-b774-1a0abad74cf9
@test testee(:(funcs[i](b)), [:funcs, :i, :b], [], [], [])

# ╔═╡ 18f22479-0e1e-4f34-a220-0488deb86acc
@test testee(:(f(a)(b)), [:a, :b], [], [:f], [])

# ╔═╡ 0c9bc225-1c9c-45dc-ac2f-696a84001371
@test testee(:(f(a).b()), [:a], [], [:f], [])

# ╔═╡ e12580a7-5b8f-49f4-86c5-e5a670421945
@test testee(:(a.b(c)), [:a, :c], [], [[:a,:b]], [])

# ╔═╡ 8b12de6e-6c12-46e9-8bd0-3416bd687207
@test testee(:(a.b.c(d)), [:a, :d], [], [[:a,:b,:c]], [])

# ╔═╡ 3ab6ffc7-c89c-4dad-aa50-1287ad166f93
@test testee(:(a.b(c)(d)), [:a, :c, :d], [], [[:a,:b]], [])

# ╔═╡ edc2bcf1-7838-40c2-aa6a-ecc6e2bd380a
@test testee(:(a.b(c).d(e)), [:a, :c, :e], [], [[:a,:b]], [])

# ╔═╡ 076ae77e-827a-4a41-8a7e-3ad8aeca2c1f
@test testee(:(a.b[c].d(e)), [:a, :c, :e], [], [], [])

# ╔═╡ 90a51d32-9861-4320-b917-b8a595986686
@test testee(:(function f(y::Int64=a)::String string(y) end), [], [], [], [
            :f => ([:String, :Int64, :a], [], [:string], [])
        ])

# ╔═╡ 9308b57d-ff89-4639-9c8a-7543dfee8ab6
@test testee(:(f(a::A)::C = a.a;), [], [], [], [
            :f => ([:A, :C], [], [], [])
        ])

# ╔═╡ eb831c83-b36a-4c79-8bae-ee6545764ab4
@test testee(:(function f(x::T; k=1) where T return x + 1 end), [], [], [], [
            :f => ([], [], [:+], [])
        ])

# ╔═╡ 3f60009e-5730-4a1d-97a5-d840e1924294
@test testee(:(function f(x::T; k=1) where {T,S <: R} return x + 1 end), [], [], [], [
            :f => ([:R], [], [:+], [])
        ])

# ╔═╡ 2b580482-b2c9-4794-b1a7-ab1ee0ec36bc
@test testee(:(f(x)::String = x), [], [], [], [
            :f => ([:String], [], [], [])
        ])

# ╔═╡ 60b92acc-3c05-47dc-b3c9-e2fd68a382f9
@test testee(:(MIME"text/html"), [], [], [Symbol("@MIME_str")], [])

# ╔═╡ e84b7dd8-26fc-4e76-a197-b3f2bba0387b
@test testee(:(function f(::MIME"text/html") 1 end), [], [], [], [
            :f => ([], [], [Symbol("@MIME_str")], [])
        ])

# ╔═╡ c8eabaf5-c84e-47dd-b26b-1b0dbcb8c5dc
@test testee(:(a(a::AbstractArray{T}) where T = 5), [], [], [], [
            :a => ([:AbstractArray], [], [], [])
        ])

# ╔═╡ 9124988c-b7db-4944-a0f8-f1ce676e4ec6
@test testee(:(a(a::AbstractArray{T,R}) where {T,S} = a + b), [], [], [], [
            :a => ([:AbstractArray, :b, :R], [], [:+], [])
        ])

# ╔═╡ baacadbc-e36f-4bc8-b78b-9f70e6d63486
@test testee(:(f(::A) = 1), [], [], [], [
            :f => ([:A], [], [], [])
        ])

# ╔═╡ 82c69244-9b65-4bf4-8094-cd29b940d51d
@test testee(:(f(::A, ::B) = 1), [], [], [], [
            :f => ([:A, :B], [], [], [])
        ])

# ╔═╡ 5f8aba79-f134-4ec8-a48f-8a5ad4418c82
@test testee(:(f(a::A, ::B, c::C...) = a + c), [], [], [], [
            :f => ([:A, :B, :C], [], [:+], [])
        ])

# ╔═╡ 4784e686-2379-4cc3-892e-53c3c6ad3af0
@test testee(:((obj::MyType)(x,y) = x + z), [], [], [], [
            :MyType => ([:z], [], [:+], [])
        ])

# ╔═╡ 93fc1c0c-db62-4558-9b39-19a32a4d65bb
@test testee(:((obj::MyType)() = 1), [], [], [], [
            :MyType => ([], [], [], [])
        ])

# ╔═╡ d46a20b7-8c4c-404c-9b1c-b2224ba47633
@test testee(:((obj::MyType)(x, args...; kwargs...) = [x, y, args..., kwargs...]), [], [], [], [
            :MyType => ([:y], [], [], [])
        ])

# ╔═╡ 1997721a-8fe3-403a-a730-75345fee0248
@test testee(:(function (obj::MyType)(x, y) x + z end), [], [], [], [
            :MyType => ([:z], [], [:+], [])
        ])

# ╔═╡ 231e0a31-21a6-4210-b0ef-5411dad75d2f
@test testee(:(begin struct MyType x::String end; (obj::MyType)(y) = obj.x + y; end), [], [:MyType], [], [
            :MyType => ([:String], [], [:+], [])
        ])

# ╔═╡ 31755ce8-74e4-44b6-a0ad-344501f3dd60
@test testee(:(begin struct MyType x::String end; function(obj::MyType)(y) obj.x + y; end; end), [], [:MyType], [], [
            :MyType => ([:String], [], [:+], [])
        ])

# ╔═╡ ece23f0a-f3b3-4c78-a6ef-9c74425c5c3e
@test testee(:((::MyType)(x,y) = x + y), [], [], [], [
            :MyType => ([], [], [:+], [])
        ])

# ╔═╡ ac6f1ffd-0b21-405b-9ba1-ca00ace19660
@test testee(:(let global a, b = 1, 2 end), [], [:a, :b], [], [])

# ╔═╡ e6895984-736a-4fdb-adc8-9343fcd5ac92
@test testee(:(let global k = 3 end), [], [:k], [], [])

# ╔═╡ e2791093-bdee-4609-be74-dc9256173cbb
@test testee(:(let global k = 3; k end), [], [:k], [], [])

# ╔═╡ e1e6f9dc-7f6c-440d-b34d-2737acfa61ea
@test testee(:(let global k += 3 end), [:k], [:k], [:+], [])

# ╔═╡ 83a46ea2-6c7d-4c08-9f61-3bacf50198e4
@test testee(:(let global k; k = 4 end), [], [:k], [], [])

# ╔═╡ 4a843338-193f-4032-bd5a-b53863bda34e
@test testee(:(let global k; b = 5 end), [], [], [], [])

# ╔═╡ 6cd4a04f-9560-4d12-81b1-965bd1deab90
@test testee(:(let a = 1, b = 2; show(a + b) end), [], [], [:show, :+], [])

# ╔═╡ f56b9f1a-b970-448b-ac45-1d48ef07118a
@test testee(:(begin local a, b = 1, 2 end), [], [], [], [])

# ╔═╡ 4163a188-e45c-48f3-9766-5dd356b2d655
@test testee(:(begin local a = b = 1 end), [], [:b], [], [])

# ╔═╡ 6d9916ef-9ac2-4f38-a2d2-6ee7518d1a4e
@test testee(:(begin local k = 3 end), [], [], [], [])

# ╔═╡ 1363b6f1-5822-416c-aa8d-3bc4adfea462
@test testee(:(begin local k = r end), [:r], [], [], [])

# ╔═╡ 60a08b85-04c4-46db-bcbc-a3554256b3b5
@test testee(:(begin local k = 3; k; b = 4 end), [], [:b], [], [])

# ╔═╡ 1413b345-cdd6-4e51-ba91-657aa1c6451c
@test testee(:(begin local k += 3 end), [], [], [:+], []) # does not reference global k

# ╔═╡ ac68d607-2445-465a-9ff2-a885c98bb6ef
@test testee(:(begin local k; k = 4 end), [], [], [], [])

# ╔═╡ 9c3374ff-569e-4510-ae46-bec6f023c5a5
@test testee(:(begin local k; b = 5 end), [], [:b], [], [])

# ╔═╡ 85397c59-d1a1-480c-bd26-6eb95e8a9d51
@test testee(:(begin local r[1] = 5 end), [:r], [], [], [])

# ╔═╡ 7cfb7dd9-2085-4ade-8de7-6bc483f3803a
@test testee(:(function f(x) global k = x end), [], [], [], [
            :f => ([], [:k], [], [])
        ])

# ╔═╡ da8d039f-147b-4f8d-adfa-c84c13a15041
@test testee(:((begin x = 1 end, y)), [:y], [:x], [], [])

# ╔═╡ b85fd87a-4788-4a3f-9aa6-d2b9249a29b7
@test testee(:(x = let global a += 1 end), [:a], [:x, :a], [:+], [])

# ╔═╡ c64a8b62-1af5-4b93-8fac-f44d7f70b036
@test testee(:(using Plots), [], [:Plots], [], [])

# ╔═╡ 8fe6bab4-b7b9-4193-b85f-dcec59e6ed22
@test testee(:(using Plots.ExpressionExplorer), [], [:ExpressionExplorer], [], [])

# ╔═╡ 80826147-d26c-4ed4-af02-7aae0076048a
@test testee(:(using JSON, UUIDs), [], [:JSON, :UUIDs], [], [])

# ╔═╡ 965bf8f3-bb9c-4efb-ae43-4d94c3d30639
@test testee(:(import Pluto), [], [:Pluto], [], [])

# ╔═╡ a47861e7-1058-4990-9bf9-cd8586379c51
@test testee(:(import Pluto: wow, wowie), [], [:wow, :wowie], [], [])

# ╔═╡ 3939b296-97b1-42ab-8809-2f61abaf5daa
@test testee(:(import Pluto.ExpressionExplorer.wow, Plutowie), [], [:wow, :Plutowie], [], [])

# ╔═╡ fbbcce7f-526c-476f-b589-d705884bbcc6
@test testee(:(import .Pluto: wow), [], [:wow], [], [])

# ╔═╡ cfea647e-3de7-424e-957d-87fe1b105002
@test testee(:(import ..Pluto: wow), [], [:wow], [], [])

# ╔═╡ 6cf30393-cecd-4ebb-90d6-38e47f56a499
@test testee(:(let; import Pluto.wow, Dates; end), [], [:wow, :Dates], [], [])

# ╔═╡ 581dc595-5b5b-4063-a94a-43cc704f4370
@test testee(:(while false; import Pluto.wow, Dates; end), [], [:wow, :Dates], [], [])

# ╔═╡ 834aa4b3-ff40-4789-a10f-0177dfcaca0a
@test testee(:(try; using Pluto.wow, Dates; catch; end), [], [:wow, :Dates], [], [])

# ╔═╡ c7cdd3a4-bd7a-4fb6-b32f-8fbf8f329b8f
@test testee(:(module A; import B end), [], [:A], [], [])

# ╔═╡ 6661b9ce-0454-44a5-8844-c851b0d1bb32
@test testee(quote
        f = @ode_def LotkaVolterra begin
            dx = a*x - b*x*y
            dy = -c*y + d*x*y
          end a b c d
        end, [], [:f, :LotkaVolterra], [Symbol("@ode_def")], [])

# ╔═╡ ce065ea1-f0c8-4d17-9b6e-0df7f0cdba09
@test testee(quote
        f = @ode_def begin
            dx = a*x - b*x*y
            dy = -c*y + d*x*y
          end a b c d
        end, [], [:f], [Symbol("@ode_def")], [])

# ╔═╡ 36c9965d-3d5e-4ca4-acba-a528e84a8404
@test testee(:(@functor Asdf), [], [:Asdf], [Symbol("@functor")], [])

# ╔═╡ c1254cff-3530-4466-b1f0-dcfbfd596eb3
@test testee(:(@variables a b c), [], [:a, :b, :c], [Symbol("@variables")], [])

# ╔═╡ c5edcd76-f3d0-4d08-839a-d5d7137af37a
@test testee(:(@variables a, b, c), [], [:a, :b, :c], [Symbol("@variables")], [])

# ╔═╡ 86d35811-8ae3-4101-ad57-4a608b49447e
@test testee(:(@variables a b[1:2] c(t) d(..)), [], [:a, :b, :c, :d, :t], [:(:), Symbol("@variables")], [])

# ╔═╡ 8314ea52-c6bf-47a5-a086-f9013d4ff020
@test testee(:(@variables a b[1:x] c[1:10](t) d(..)), [:x], [:a, :b, :c, :d, :t], [:(:), Symbol("@variables")], [])

# ╔═╡ f4e5943e-11fa-4f8b-a218-379514b1795d
@test testee(:(@variables a, b[1:x], c[1:10](t), d(..)), [:x], [:a, :b, :c, :d, :t], [:(:), Symbol("@variables")], [])

# ╔═╡ c674b08f-f85f-493a-9380-0839b9a838c4
@test testee(:(@time a = 2), [], [:a], [Symbol("@time")], [])

# ╔═╡ 21696591-c4ae-4c0a-b855-e092b6632227
@test testee(:(@f(x; y=z)), [:x, :z], [], [Symbol("@f")], [])

# ╔═╡ 6b0b8537-0355-48db-9060-52298a036ff5
@test testee(:(@f(x, y = z)), [:x, :z], [], [Symbol("@f")], []) # https://github.com/fonsp/Pluto.jl/issues/252

# ╔═╡ eeefaf2d-e99b-42f2-9eaa-c4bb6f8096dc
@test testee(:(Base.@time a = 2), [:Base], [:a], [[:Base, Symbol("@time")]], [])

# ╔═╡ 62c384e8-4c7f-4dc0-b2bd-efe3189ee4d2
# @test_nowarn testee(:(@enum a b = d c), [:d], [:a, :b, :c], [Symbol("@enum")], [])
        # @enum is tested in test/React.jl instead
        @test testee(:(@gensym a b c), [], [:a, :b, :c], [:gensym, Symbol("@gensym")], [])

# ╔═╡ a44d526d-ed34-46f3-bc39-f8d25b150e38
@test testee(:(Base.@gensym a b c), [:Base], [:a, :b, :c], [:gensym, [:Base, Symbol("@gensym")]], [])

# ╔═╡ d9752358-239c-474e-91a6-e6cbc3af594e
@test testee(:(Base.@kwdef struct A; x = 1; y::Int = two; z end), [:Base], [:A], [[:Base, Symbol("@kwdef")], [:Base, Symbol("@__doc__")]], [
            :A => ([:Int, :two], [], [], [])
        ])

# ╔═╡ 3b2808f3-b20d-4c06-9871-40eaca391088
@test testee(quote "asdf" f(x) = x end, [], [], [Symbol("@doc")], [:f => ([], [], [], [])])

# ╔═╡ a0a1dc6e-81ff-419e-a650-3d37c0c2891b
@test testee(:(@bind a b), [:b, :PlutoRunner, :Base, :Core], [:a], [[:Base, :get], [:Core, :applicable], [:PlutoRunner, :Bond], Symbol("@bind")], [])

# ╔═╡ 8a4269da-65e9-442d-affe-113fa2d33924
@test testee(:(PlutoRunner.@bind a b), [:b, :PlutoRunner, :Base, :Core], [:a], [[:Base, :get], [:Core, :applicable], [:PlutoRunner, :Bond], [:PlutoRunner, Symbol("@bind")]], [])

# ╔═╡ 89d6f27e-5ec9-4a32-9351-dec8e614e704
@test testee(:(let @bind a b end), [:b, :PlutoRunner, :Base, :Core], [:a], [[:Base, :get], [:Core, :applicable], [:PlutoRunner, :Bond], Symbol("@bind")], [])

# ╔═╡ 87ad8807-44c7-41c7-8836-ea6fe0c5f1dc
@test testee(:(@asdf a = x1 b = x2 c = x3), [:x1, :x2, :x3], [:a], [Symbol("@asdf")], []) # https://github.com/fonsp/Pluto.jl/issues/670

# ╔═╡ 850d26ab-9b70-4c94-830d-8a9770ccba73
@test testee(:(@einsum a[i,j] := x[i]*y[j]), [:x, :y, :Float64], [:a], [[Symbol("@einsum")], [:*]], [])

# ╔═╡ f22c5535-8850-43a8-9e33-974f1148379d
@test testee(:(@tullio a := f(x)[i+2j, k[j]] init=z), [:x, :k, :z], [:a], [[Symbol("@tullio")], [:f], [:*], [:+]], [])

# ╔═╡ d5f940cb-db51-49c5-ad0b-a5c4d67edaa9
@test testee(:(Pack.@asdf a[1,k[j]] := log(x[i]/y[j])), [:x, :y, :k, :Pack, :Float64], [:a], [[:Pack, Symbol("@asdf")], [:/], [:log]], [])

# ╔═╡ 8bb36956-139a-4334-8a5b-924988134e80
@test testee(:(`hey $(a = 1) $(b)`), [:b], [], [:cmd_gen, Symbol("@cmd")], [])

# ╔═╡ 8526af13-50da-4830-9631-827a2fad8ce3
@test testee(:(md"hey $(@bind a b) $(a)"), [:b, :PlutoRunner, :Base, :Core], [:a], [:getindex, [:Base, :get], [:Core, :applicable], [:PlutoRunner, :Bond], Symbol("@md_str"), Symbol("@bind")], [])

# ╔═╡ f9ea1f06-75a9-4cfa-b12d-ead56b94cb20
@test testee(:(md"hey $(a) $(@bind a b)"), [:b, :a, :PlutoRunner, :Base, :Core], [:a], [:getindex, [:Base, :get], [:Core, :applicable], [:PlutoRunner, :Bond], Symbol("@md_str"), Symbol("@bind")], [])

# ╔═╡ 82fc5e9b-6b80-4d93-898b-04ed74682b13
@test testee(:(html"a $(b = c)"), [], [], [Symbol("@html_str")], [])

# ╔═╡ a82da546-bc19-4601-af27-525aca217a92
@test testee(:(md"a $(b = c) $(b)"), [:c], [:b], [:getindex, Symbol("@md_str")], [])

# ╔═╡ 54bd66fa-1cee-4b10-9b13-53ef47dc08af
@test testee(:(md"\* $r"), [:r], [], [:getindex, Symbol("@md_str")], [])

# ╔═╡ 02e05511-dcd5-46c8-9a96-002aa45bef9d
@test testee(:(md"a \$(b = c)"), [], [], [:getindex, Symbol("@md_str")], [])

# ╔═╡ 81e3d167-4dfd-4fd4-abc3-5f1dd8f3ef70
@test testee(:(macro a() end), [], [], [], [
            Symbol("@a") => ([], [], [], [])
        ])

# ╔═╡ 9419cdbf-0c36-4ff7-83a0-938dd97dd93e
@test testee(:(macro a(b::Int); b end), [], [], [], [
            Symbol("@a") => ([:Int], [], [], [])
        ])

# ╔═╡ 1a76b952-39c5-4e5f-a7fb-02a95d6b3b77
@test testee(:(macro a(b::Int=c) end), [], [], [], [
            Symbol("@a") => ([:Int, :c], [], [], [])
        ])

# ╔═╡ fdd6d379-36fa-43b8-9c75-9b23b4e31104
@test testee(:(macro a(); b = c; return b end), [], [], [], [
            Symbol("@a") => ([:c], [], [], [])
        ])

# ╔═╡ 58c7788e-0d89-41f0-bc93-37ce61eb7561
@test testee(:("a $b"), [:b], [], [], [])

# ╔═╡ af697702-87d8-437b-8253-3b53a441cfa0
@test testee(:("a $(b = c)"), [:c], [:b], [], [])

# ╔═╡ dbefb9a7-e8d8-4921-a01b-ea6ee4c46625
# @test_broken testee(:(`a $b`), [:b], [], [], [])
        # @test_broken testee(:(`a $(b = c)`), [:c], [:b], [], [])
        @test testee(:(ex = :(yayo)), [], [:ex], [], [])

# ╔═╡ dcf64be3-e8bc-40d5-86bf-016abba432f2
@test testee(:(ex = :(yayo + $r)), [], [:ex], [], [])

# ╔═╡ b1eb7b73-aa74-4383-b7f1-b7a5dfeff24f
@test using_test_result.usings == Set{Expr}([
            :(using A),
            :(using .C: r),
        ])

# ╔═╡ db20a81a-70e0-46ab-8e63-407b74236767
@test using_test_result.imports == Set{Expr}([
            :(import B),
            :(import ..D.E: f, g),
            :(import H.I, J, K.L),
        ])

# ╔═╡ 7452012b-3ea5-4d4e-9ae4-229d5662ec39
@test external_package_names(using_test_result) == Set{Symbol}([
            :A, :B, :H, :J, :K
        ])

# ╔═╡ b8be0b59-6d0b-402f-ba58-afef4cd38ef4
@test external_package_names(:(using Plots, Something.Else, .LocalModule)) == Set([:Plots, :Something])

# ╔═╡ 616bc87c-d0bc-4a54-ad5e-2a0a7d78e42c
@test external_package_names(:(import Plots.A: b, c)) == Set([:Plots])

# ╔═╡ dcd75e41-25da-44b6-9444-e56e77b63d78
@skip_as_script @test notebook1 == deepcopy(notebook1)

# ╔═╡ b8c94043-afe1-4b1c-bab4-edf940d7b6aa
@skip_as_script x = 2

# ╔═╡ 3cb09d75-a93d-4f88-8f83-35bd9fc6b53a
@skip_as_script @test 1 + 1 == x

# ╔═╡ 3c8e0741-9df0-4988-9a29-18528d65c15d
@skip_as_script @test 1 + 1 + 1 == x

# ╔═╡ 9d2c5a91-756c-4444-869e-9f570a67a5da
@skip_as_script @test throw("Oh my god") == x

# ╔═╡ be8ec93c-4a7f-4e7e-918d-08d7b6d4d89a
md"## Track"

# ╔═╡ c7363e9b-20d7-4be4-a220-986bb3938bdf
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

# ╔═╡ c9f176ac-4c8e-49a8-b892-bfbd3c287c03
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

# ╔═╡ d2908f33-df93-48b7-89d2-bb910af05d6a
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

# ╔═╡ 1683e0be-8b6b-4f69-8359-7802ce4f1d03
@skip_as_script @track sleep(0.1)

# ╔═╡ ef80a22a-d36e-40b9-b297-c217f0f068cd
md"""
## Table of contents
"""

# ╔═╡ 203bf6d8-09ee-4feb-ac1b-75df91db9a8e
const toc_css = """
@media screen and (min-width: 1081px) {
	.plutoui-toc.aside {
		position:fixed; 
		right: 1rem;
		top: 5rem; 
		width:25%; 
		padding: 10px;
		border: 3px solid rgba(0, 0, 0, 0.15);
		border-radius: 10px;
		box-shadow: 0 0 11px 0px #00000010;
		/* That is, viewport minus top minus Live Docs */
		max-height: calc(100vh - 5rem - 56px);
		overflow: auto;
		z-index: 5;
		background: white;
	}
}

.plutoui-toc header {
	display: block;
	font-size: 1.5em;
	margin-top: 0.67em;
	margin-bottom: 0.67em;
	margin-left: 0;
	margin-right: 0;
	font-weight: bold;
	border-bottom: 2px solid rgba(0, 0, 0, 0.15);
}

.plutoui-toc section .toc-row {
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
	padding-bottom: 2px;
}

.highlight-pluto-cell-shoulder {
	background: rgba(0, 0, 0, 0.05);
	background-clip: padding-box;
}

.plutoui-toc section a {
	text-decoration: none;
	font-weight: normal;
	color: gray;
}
.plutoui-toc section a:hover {
	color: black;
}

.plutoui-toc.indent section a.H1 {
	font-weight: 700;
	line-height: 1em;
}

.plutoui-toc.indent section a.H1 {
	padding-left: 0px;
}
.plutoui-toc.indent section a.H2 {
	padding-left: 10px;
}
.plutoui-toc.indent section a.H3 {
	padding-left: 20px;
}
.plutoui-toc.indent section a.H4 {
	padding-left: 30px;
}
.plutoui-toc.indent section a.H5 {
	padding-left: 40px;
}
.plutoui-toc.indent section a.H6 {
	padding-left: 50px;
}
"""

# ╔═╡ 2e72a203-7233-41ab-a50b-8eb358690a81
const toc_js = toc -> """
const getParentCell = el => el.closest("pluto-cell")

const getHeaders = () => {
	const depth = Math.max(1, Math.min(6, $(toc.depth))) // should be in range 1:6
	const range = Array.from({length: depth}, (x, i) => i+1) // [1, ..., depth]
	
	const selector = range.map(i => `pluto-notebook pluto-cell h\${i}`).join(",")
	return Array.from(document.querySelectorAll(selector))
}

const indent = $(repr(toc.indent))
const aside = $(repr(toc.aside))

const render = (el) => html`\${el.map(h => {
	const parent_cell = getParentCell(h)

	const a = html`<a 
		class="\${h.nodeName}" 
		href="#\${parent_cell.id}"
	>\${h.innerText}</a>`
	/* a.onmouseover=()=>{
		parent_cell.firstElementChild.classList.add(
			'highlight-pluto-cell-shoulder'
		)
	}
	a.onmouseout=() => {
		parent_cell.firstElementChild.classList.remove(
			'highlight-pluto-cell-shoulder'
		)
	} */
	a.onclick=(e) => {
		e.preventDefault();
		h.scrollIntoView({
			behavior: 'smooth', 
			block: 'center'
		})
	}

	return html`<div class="toc-row">\${a}</div>`
})}`

const tocNode = html`<nav class="plutoui-toc">
	<header>$(toc.title)</header>
	<section></section>
</nav>`
tocNode.classList.toggle("aside", aside)
tocNode.classList.toggle("indent", aside)

const updateCallback = () => {
	tocNode.querySelector("section").replaceWith(
		html`<section>\${render(getHeaders())}</section>`
	)
}
updateCallback()


const notebook = document.querySelector("pluto-notebook")


// We have a mutationobserver for each cell:
const observers = {
	current: [],
}

const createCellObservers = () => {
	observers.current.forEach((o) => o.disconnect())
	observers.current = Array.from(notebook.querySelectorAll("pluto-cell")).map(el => {
		const o = new MutationObserver(updateCallback)
		o.observe(el, {attributeFilter: ["class"]})
		return o
	})
}
createCellObservers()

// And one for the notebook's child list, which updates our cell observers:
const notebookObserver = new MutationObserver(() => {
	updateCallback()
	createCellObservers()
})
notebookObserver.observe(notebook, {childList: true})

// And finally, an observer for the document.body classList, to make sure that the toc also works when if is loaded during notebook initialization
const bodyClassObserver = new MutationObserver(updateCallback)
bodyClassObserver.observe(document.body, {attributeFilter: ["class"]})

invalidation.then(() => {
	notebookObserver.disconnect()
	bodyClassObserver.disconnect()
	observers.current.forEach((o) => o.disconnect())
})

return tocNode
"""

# ╔═╡ 1d8aac12-4dcd-49e3-9971-fb2751ba1dc9
HTML("""
	<script>
	$(toc_js((;title="Table of Contents", indent=true, depth=3, aside=true)))
	</script>
	<style>
	$(toc_css)
	</style>
	""")

# ╔═╡ Cell order:
# ╟─51f62e10-9b66-48a9-bd8a-5f7ca47bea12
# ╠═a35eeaec-6b73-4200-8fe9-e069e0b8dea8
# ╟─eb228e68-8bb9-404a-803f-d2cf5622fca3
# ╠═559d35f5-981a-444e-b212-ab32405df12c
# ╠═2391cfeb-311a-461e-8d3c-80cd5f9b599e
# ╠═afe6f8a2-cf1c-48f7-9c9c-23046fd5a33c
# ╠═13819d9d-88ca-44d1-bd1d-74a67cfb0d3b
# ╠═e6b7134d-cb5f-49b5-b069-a38ac5645085
# ╠═c5ed1623-a68f-4acb-b423-a6d9ade0a7a5
# ╠═f5fee1ad-bc07-419a-a118-fc552009799a
# ╠═06e6414d-180a-4088-8d07-9a8e18461969
# ╠═b8b8c77c-0981-41dc-ac0b-6aaf8f03db47
# ╠═90da4e3a-1c25-4ad6-904b-4d895786790e
# ╠═d703d634-8956-4bda-b0fa-ef011c830459
# ╠═afdedd6e-7f07-42da-9f36-c45a7ae0210f
# ╠═cb3aa97e-2f0b-4b08-be92-3f9350687fdc
# ╠═23b5071f-834a-4c67-bd31-ad46ac710d48
# ╠═10ee2230-f91c-4479-9f2a-d3459a7a5499
# ╟─3c93ed99-6014-48c0-9ed1-79675aedcfe0
# ╠═3e638dc9-11ec-4907-90a8-d92b348c6f4e
# ╠═b4cec831-9704-492b-9766-419e01b09d6e
# ╠═7d40bfbc-c655-4782-8471-2007a48dc0bf
# ╠═db24e50c-5e4d-471e-9fbe-8831d707696f
# ╠═2a508120-4687-4697-a039-d4faa7872f52
# ╠═45283cd1-c459-4e62-b819-a63aa590c363
# ╠═79e948c7-2512-4c34-8598-ad5f10e98d88
# ╠═ddf5e84d-bc01-41e3-90fa-5faef4c3b7fc
# ╠═026d7dca-6c97-45c2-bfba-c9437f6771ab
# ╠═5f03ef73-eecf-4777-8fe9-9692a255df88
# ╠═bb2059a3-e789-4101-87a4-37ad6af65d2d
# ╠═a6356c5e-4e44-4376-956f-5f86f4563951
# ╠═96388cd0-081a-4038-8a70-81a6742a5d8c
# ╠═3f1fe13b-d583-48c9-93a9-1b72e4f018eb
# ╠═faa4068e-f707-4dda-894e-9d555adb5986
# ╠═7564fc25-b0a4-4e85-880b-0fc5eace7cec
# ╠═c5acddda-d175-4251-816a-8eff1b87eb29
# ╠═1fa7e39c-b71f-4c5b-86c2-6ce7c03abe98
# ╠═e2b0b177-9f46-4a4a-be7b-c209392e2a43
# ╠═8d18d185-2952-463d-864d-f9daeddd6f8f
# ╠═671afd70-9c18-413d-9671-875994f0ee5b
# ╠═e2893867-faf9-4246-b5a0-139c5c9713cd
# ╠═a4bbef4f-caad-46e9-80fd-15e0848ed0c4
# ╠═659305a9-92ab-4092-b960-e97b4c14051e
# ╠═f11d9e65-f5ea-4558-9053-49531ca249a2
# ╠═9d79fda8-edc2-4f8e-ae29-44a46fb0004c
# ╠═4b6d3266-f0e7-4b98-b43b-3f3c24fdd797
# ╟─76c10921-d08e-4878-816d-f222f4068c2c
# ╠═d88e0e06-3943-4a3c-8ac6-d2c4211f1994
# ╠═90dfe536-9988-4083-a6c7-e2777ba19af6
# ╠═ecff407d-8e0c-4a72-babd-46545860a547
# ╠═47d7e206-7e23-4f98-b488-85d595819212
# ╠═b7cf3a4d-dbe8-4058-bac1-702e16cef5e7
# ╠═8818219e-860a-4556-b5f5-df318dadd381
# ╠═ca38f86c-a603-47d5-9c97-17919035da9d
# ╠═5057dbf0-aca9-4791-9bff-87d080475a45
# ╠═02bcbbd4-9e2b-440b-8c8f-d4ba18848197
# ╠═3e360b8e-9cf0-4c46-bae1-401971e3e944
# ╠═d4195845-f036-4a11-bc58-32f9b63b3fd8
# ╠═92d79fb3-0438-4e98-b94b-1eeb01046cd9
# ╠═8e4a667d-92aa-4ab8-95af-19d2e65aad5e
# ╠═a221fc38-5a2d-40f3-8529-caf3dc919374
# ╟─28208774-b99c-479b-9e30-07c6dbc482a2
# ╠═365f0095-1ee5-4eef-9693-bec0951b5ee4
# ╠═a30532f6-4987-4e6e-b2ac-daffe9e56df3
# ╠═184b8cc0-414b-4ffa-a6fe-9a67bbfc3ce2
# ╠═bad85f9a-6c19-4ca3-b7a5-8ef2b83d3b3a
# ╠═29bf7829-ce07-4c98-a9a4-6bcdbc6f5e41
# ╟─54f0b52b-7c8e-40fd-83e9-4d0658e16aa8
# ╠═ae138a1f-02cc-4121-a9c4-e4bd4c883645
# ╠═18119967-10db-4f99-b73c-63f140a650ae
# ╠═330c6c6c-dbac-4bb4-8838-6197dccf187a
# ╠═92ac6349-238a-4a2e-a8a1-8e6d0c6e52b4
# ╠═f4d83216-9bf0-4f7d-a1db-db2ce3dd85e2
# ╠═bafbb031-015a-40e6-82e1-4a8a9bafc683
# ╠═30224555-0231-44fe-8d9b-0fbcfc3e5ed6
# ╠═0c92d67a-4c75-4911-a204-aa02e3ae5b50
# ╠═e58517e2-ace0-4c7d-ab6b-63eac43f04b4
# ╠═71e3b2e0-c4c3-495d-8c4e-9422237acce0
# ╠═2619bc65-91ef-494b-8e8b-2c0c46dab2eb
# ╠═01e9c7c5-b1ae-43a2-ac48-e01f5dc1b121
# ╠═a27079be-edd0-4476-bc52-68718a41d4c4
# ╟─328ce9d2-c40b-41db-837b-c7fe1dd7124c
# ╟─d5063ce7-e087-4560-a384-0d698501652a
# ╟─4316fc34-a5a3-403b-93ac-3bb1443f4bbf
# ╟─fb137bb7-358d-4dce-85bd-36708a0934f7
# ╟─9130b418-f372-4374-827e-5c2d08df4228
# ╟─73b6165d-d0da-4d59-9467-028a747cce56
# ╟─1d29e7ed-2ea1-462e-9c55-835606e8b2b9
# ╟─b6b72034-48ef-4a90-9a2b-c7b7359fdac2
# ╟─1251a926-b661-4b0b-994b-49eeecddd04e
# ╟─fd810e7f-0f9b-4f25-b147-0e2bac7015b2
# ╟─3bc7bfae-0e93-4244-b574-a9a5aaf928ed
# ╟─96f715d4-63f3-477f-a2d5-2c40e0d169b9
# ╟─d579f690-c3a6-4e5e-9412-f89fdb9413ba
# ╟─91361cea-7403-45f8-a5ba-bbff1ffc72b2
# ╟─2bb9df64-f747-4301-a5ef-a86e17f23ac4
# ╟─ef46a5a9-0d16-4b41-8208-fd35d1fb543a
# ╟─b7af6fc6-07e0-4fad-8ffb-47a991d4ec8e
# ╟─1d3fa553-bed2-4d92-9426-7f29429b7154
# ╟─4123a087-5bb8-4800-8c35-06f1e2d228f3
# ╟─477e2052-7606-4994-b3e6-cab6ed0e2142
# ╟─d86af429-7a8b-4f15-acef-13ff648ffe5b
# ╟─0581fc79-666c-4949-b5f2-7b8c89a3c1f8
# ╟─c09c054a-d1a1-4af0-a8d2-6f6e619bb961
# ╟─4d40297a-bf4e-4712-81d6-3fb2e3ef62ad
# ╟─320f6cb9-a69f-4e41-82a9-0d4864a202ef
# ╟─280552a6-b3e2-4105-8f4d-acbb53c8f512
# ╟─9f813396-c2a5-443e-973b-1afb2ae0b7f4
# ╟─8e98c015-26f4-464c-a8a1-bb7f356387c8
# ╟─6c86a680-fba4-4b12-8843-796a5f08908c
# ╟─6006218d-68b7-42d0-b6e0-970dec9b40ff
# ╟─13d493fc-2be3-4020-9c04-e2907d35d1a4
# ╟─642799e2-a7bb-4e50-b248-41236839c397
# ╟─5549fb1d-35ae-4a03-a095-36b21d914ec3
# ╟─68897b77-b6c5-4430-be2a-13525b9376a8
# ╟─639772ac-9d66-4f7a-9d67-d3e66d2573ef
# ╟─76e05576-ff3c-40d2-9234-101a658782ab
# ╟─01852ece-6948-4e53-9168-8fadc02487f0
# ╟─fb7800b8-4f19-4d64-a621-238b118d19ba
# ╟─734f3a1c-5810-45e8-a597-84727c4ae732
# ╟─f886b93c-93fc-4fb2-9cc5-e19862c69282
# ╟─76c82263-b131-4a85-a0de-0813ae32395f
# ╟─782bca7f-ce5b-4897-a30a-cc12a414e20f
# ╟─9d38c307-db99-4868-a06d-c4bdd8cab71c
# ╟─5471eace-c292-4a24-878f-8ce98f66b9ff
# ╟─7e4cf861-f9f7-46b4-a7d2-36575386259c
# ╟─026f0d7f-0f27-4908-9fe6-24c283b1a563
# ╟─4553e5b9-37bd-48c3-b6b0-06f32213744e
# ╟─febb907d-6154-4de9-90db-009d9ba4f844
# ╟─5233a304-b113-4042-a4a7-25567e5e7dd9
# ╟─634391d0-d796-435f-94d7-0b4a218ac63c
# ╟─2bd9bdd1-ac97-4b84-9b93-caf27199005b
# ╟─eaed818a-db26-48b9-a67a-3d5c053c9042
# ╟─ddc53446-47f9-44a0-90b2-b4dc78d05ea5
# ╟─08dd1427-3fe2-4881-accb-63e74fc09d2a
# ╟─2da962f0-7d28-4c5c-a419-aa04a9a0aba8
# ╟─e79001db-350b-4b58-a258-6c2856407f80
# ╟─f4a1b2f5-aae4-49a5-a074-f6da17208aef
# ╟─80eed313-3a66-4307-8f7d-aee57f2101a2
# ╟─231abb23-c4fb-4932-a53b-cc2ab8e67afe
# ╟─e38ede40-17bf-413a-a122-ce86be55e6c1
# ╟─5616aca9-1753-413b-93da-85cd6744c48a
# ╟─64492814-c3e9-463b-9061-1b143563ad14
# ╟─48235722-e548-42c3-8eaf-b8bf9e215cac
# ╟─fffdc756-8fd6-4f66-a48d-c589f689c551
# ╟─55a1e6bb-7b63-4f0f-b78b-fd3fada55135
# ╟─c537a96a-9a10-45c2-97fc-1162850b4ee3
# ╟─49fcd36f-dabb-45a7-9ef1-adab8c8f6fb6
# ╟─35dc09f2-8188-4a5e-82bb-45ac90c4f628
# ╟─e2278c1e-08f5-464f-823c-005a11f89a67
# ╟─d6023a45-bda9-4313-955a-9d96463a4724
# ╟─4eb571b9-6489-427d-b1e4-ab174d500f5a
# ╟─84c449f8-a65d-4fa6-956e-478ce53918bd
# ╟─19d2c818-2994-418b-af4f-cb990fc66b4e
# ╟─e10c290b-e2e2-4188-82e7-0b9b950fad38
# ╟─0ec7933b-e890-47a4-aff6-cb96c31516b9
# ╟─88249399-b5e9-410d-ab05-6717fe49fc78
# ╟─e8c3fa46-e098-4716-b53a-82b19857873d
# ╟─ec07820b-c701-4737-bcbe-2a7a0c3b6e10
# ╟─e88e292c-f837-4b0c-b7b1-667a0af52c30
# ╟─04a865b1-d6b5-4439-90b9-21d374e568ea
# ╟─8b3dcc1e-7dec-4ede-b575-2236a8c65b26
# ╟─2853b855-445f-4a19-80e1-171f22b9dfda
# ╟─673d9a02-5445-4c8d-93b2-f128914cf40c
# ╟─bc23ca49-9e27-4ac1-a69a-6e058ee6492e
# ╟─2f4e89cd-df44-4430-bb69-e7ac203d0f93
# ╟─a1845caa-289a-44c8-a4e7-219e407c53a8
# ╟─c17f4e0c-74ec-412b-aed2-32b6b326c5c0
# ╟─e5896b3b-d3c4-4234-9bf7-15c483e01b04
# ╟─f7745551-43ff-4926-a46c-75dc4b245483
# ╟─c5db1553-63b2-4d2b-ac26-1bb054eb23cd
# ╟─f72c18b2-0289-4045-a482-78a27612f7e0
# ╟─5dd308e3-5019-4c33-9138-7fad2a8d6f0d
# ╟─23db8066-d160-4473-946a-b207b449c200
# ╟─abefc3bd-0572-49ee-814f-3ec1fe9ff61e
# ╟─4d04958c-7bb2-4e07-832b-248ecf64523e
# ╟─b49abfea-db9a-48ca-aa75-6a53768b4716
# ╟─a4c19d0f-7eb2-4173-b9cd-1d93900af0d3
# ╟─110ab6ae-0153-4c6c-8ca7-1c93c7584af3
# ╟─2e41540a-d36c-4163-94b3-aa2c22b5c6f2
# ╟─a974f92d-ab1b-45e3-98dd-462411433c4a
# ╟─6fe3f79e-ec9c-4ab6-80ed-ef57bb1ce677
# ╟─f92efb92-a8fe-4e5b-9b6f-a80e96c4a64a
# ╟─4dba10c8-0c48-44fc-98c0-48bb291dd43e
# ╟─ad6570b6-b77d-4bdd-96db-00c8fd83865f
# ╟─fa3e3651-4a5b-48f3-8c25-c1caa84936b2
# ╟─4992fc86-f7be-4e5c-8391-a00b3e2badb3
# ╟─359fbb75-ef34-4eb6-972d-87c56b420eaf
# ╟─08c24d09-71e8-47d1-a934-5620eb2a1a7e
# ╟─89b68ad6-92e9-4e21-91e5-712b555dcb96
# ╟─bf5279b2-43c9-47ec-813d-dc7618f43b90
# ╟─46505628-9d10-401c-a9c5-404dafefb5b1
# ╟─74164ea4-9249-449c-9e68-a395acf0fdb5
# ╟─3c4fe183-9ffa-4fd0-a11c-db5472aa652c
# ╟─9bff229a-d4cf-441d-8f41-da08705ac002
# ╟─3dd306a2-b1d2-44a4-877e-78b599d293e9
# ╟─c84d7141-5d4c-48b2-9f95-417c0529a97d
# ╟─742ea57b-b6c9-4e92-a810-848f56b66bc0
# ╟─431a7926-1891-4882-86a0-5167d1b1585d
# ╟─f64f7532-5531-4ae8-83de-a96938bb73c7
# ╟─c34a0e2b-4838-40b9-b44e-6e9b33caeebc
# ╟─b569c514-2a5f-4785-b110-2ee6aa6a3ffb
# ╟─225d17e6-5ed5-470f-8c23-cbc6b2c2a380
# ╟─cc6186a4-d2d5-4685-9bc9-cab2756de84e
# ╟─251cb88e-8f85-4fe3-80a5-5540b45d3c34
# ╟─62f5e3ee-44e1-49eb-a63f-5aa8d3ffbe8f
# ╟─a7902947-0a4d-492c-9826-3072624ae299
# ╟─7f144f6e-4b7b-4059-aeb0-545f42ca0420
# ╟─9f198164-f46c-4e8b-be57-bf3412495f2c
# ╟─fcbe0db0-dc7c-4284-ab59-d0134520be05
# ╟─8e483239-9df2-4012-b0bb-99a96bdac825
# ╟─11e4becc-bcd8-4792-a227-12e9898c248c
# ╟─0e1cecd3-dc65-4db5-aee0-e6d32d510afc
# ╟─e8fcdcb3-e4de-4aeb-b88e-1b734164ca06
# ╟─fbd65695-d325-47da-8e6d-4cf59092690b
# ╟─9339bfde-4187-475e-8bae-5021d3b19f38
# ╟─74642edc-6cfb-414a-875d-b7c6d54027bb
# ╟─d09edfbb-893f-4273-a252-8fbc75abec5d
# ╟─2fd1c324-ae62-4227-bea8-74da3f83cca5
# ╟─1cc47456-a783-43c1-b17d-67296a4e868f
# ╟─530c0d15-0e64-4cb3-a002-a0600e43cf17
# ╟─8208dc01-643e-49a8-9f40-718b670015a4
# ╟─bbe0c333-4540-4d0e-8efd-34a7ec89a9a8
# ╟─24ba3980-c43b-4e4b-8e5f-dec1d04cac25
# ╟─60723c62-2c18-4395-95a0-e9089ab1c100
# ╟─1359b139-5567-42b3-9816-867a9b16690b
# ╟─3403ad5d-cdf5-4850-a198-2cc9dc093e5b
# ╟─c916c7e0-e02c-438a-af0d-7f8e11de4315
# ╟─f4b07b7e-a6d7-4f8c-a7be-19589535df35
# ╟─d3caf6fe-fcb3-4033-a3e9-4df5228da5d9
# ╟─7e6c7092-427b-40a6-8ede-0813a527cf90
# ╟─10ced374-4e40-436c-a0fc-29810181cd04
# ╟─f39c48ad-1e42-438c-bb95-01896cfa6b13
# ╟─57e6d6a4-a3d1-44b3-8317-1f20263feb38
# ╟─bfb0ceda-ea57-41c0-a9d6-b94685e0dda8
# ╟─729a9558-2cdc-4e85-b774-1a0abad74cf9
# ╟─18f22479-0e1e-4f34-a220-0488deb86acc
# ╟─0c9bc225-1c9c-45dc-ac2f-696a84001371
# ╟─e12580a7-5b8f-49f4-86c5-e5a670421945
# ╟─8b12de6e-6c12-46e9-8bd0-3416bd687207
# ╟─3ab6ffc7-c89c-4dad-aa50-1287ad166f93
# ╟─edc2bcf1-7838-40c2-aa6a-ecc6e2bd380a
# ╟─076ae77e-827a-4a41-8a7e-3ad8aeca2c1f
# ╟─722991a1-c795-492b-9d48-e844900df444
# ╟─90a51d32-9861-4320-b917-b8a595986686
# ╟─9308b57d-ff89-4639-9c8a-7543dfee8ab6
# ╟─eb831c83-b36a-4c79-8bae-ee6545764ab4
# ╟─3f60009e-5730-4a1d-97a5-d840e1924294
# ╟─2b580482-b2c9-4794-b1a7-ab1ee0ec36bc
# ╟─60b92acc-3c05-47dc-b3c9-e2fd68a382f9
# ╟─e84b7dd8-26fc-4e76-a197-b3f2bba0387b
# ╟─c8eabaf5-c84e-47dd-b26b-1b0dbcb8c5dc
# ╟─9124988c-b7db-4944-a0f8-f1ce676e4ec6
# ╟─baacadbc-e36f-4bc8-b78b-9f70e6d63486
# ╟─82c69244-9b65-4bf4-8094-cd29b940d51d
# ╟─5f8aba79-f134-4ec8-a48f-8a5ad4418c82
# ╟─4784e686-2379-4cc3-892e-53c3c6ad3af0
# ╟─93fc1c0c-db62-4558-9b39-19a32a4d65bb
# ╟─d46a20b7-8c4c-404c-9b1c-b2224ba47633
# ╟─1997721a-8fe3-403a-a730-75345fee0248
# ╟─231e0a31-21a6-4210-b0ef-5411dad75d2f
# ╟─31755ce8-74e4-44b6-a0ad-344501f3dd60
# ╟─ece23f0a-f3b3-4c78-a6ef-9c74425c5c3e
# ╟─de9cb953-91c0-4721-8a3a-4dfb45fae751
# ╟─ac6f1ffd-0b21-405b-9ba1-ca00ace19660
# ╟─48d7d4dd-2897-43a9-8dad-a21c9ade412d
# ╟─e6895984-736a-4fdb-adc8-9343fcd5ac92
# ╟─dcebeb3d-92ab-48bc-bb8d-f621a225013a
# ╟─e2791093-bdee-4609-be74-dc9256173cbb
# ╟─e1e6f9dc-7f6c-440d-b34d-2737acfa61ea
# ╟─83a46ea2-6c7d-4c08-9f61-3bacf50198e4
# ╟─4a843338-193f-4032-bd5a-b53863bda34e
# ╟─6cd4a04f-9560-4d12-81b1-965bd1deab90
# ╟─f56b9f1a-b970-448b-ac45-1d48ef07118a
# ╟─4163a188-e45c-48f3-9766-5dd356b2d655
# ╟─6d9916ef-9ac2-4f38-a2d2-6ee7518d1a4e
# ╟─1363b6f1-5822-416c-aa8d-3bc4adfea462
# ╟─60a08b85-04c4-46db-bcbc-a3554256b3b5
# ╟─1413b345-cdd6-4e51-ba91-657aa1c6451c
# ╟─ac68d607-2445-465a-9ff2-a885c98bb6ef
# ╟─9c3374ff-569e-4510-ae46-bec6f023c5a5
# ╟─85397c59-d1a1-480c-bd26-6eb95e8a9d51
# ╟─7caeeeed-2298-439b-8f04-8548354bfae3
# ╟─7cfb7dd9-2085-4ade-8de7-6bc483f3803a
# ╟─da8d039f-147b-4f8d-adfa-c84c13a15041
# ╟─b85fd87a-4788-4a3f-9aa6-d2b9249a29b7
# ╟─9a1d70b5-bd83-43f8-a1a6-77f87a3f842c
# ╟─c64a8b62-1af5-4b93-8fac-f44d7f70b036
# ╟─8fe6bab4-b7b9-4193-b85f-dcec59e6ed22
# ╟─80826147-d26c-4ed4-af02-7aae0076048a
# ╟─965bf8f3-bb9c-4efb-ae43-4d94c3d30639
# ╟─a47861e7-1058-4990-9bf9-cd8586379c51
# ╟─3939b296-97b1-42ab-8809-2f61abaf5daa
# ╟─fbbcce7f-526c-476f-b589-d705884bbcc6
# ╟─cfea647e-3de7-424e-957d-87fe1b105002
# ╟─6cf30393-cecd-4ebb-90d6-38e47f56a499
# ╟─581dc595-5b5b-4063-a94a-43cc704f4370
# ╟─834aa4b3-ff40-4789-a10f-0177dfcaca0a
# ╟─c7cdd3a4-bd7a-4fb6-b32f-8fbf8f329b8f
# ╟─a850ac6c-db6a-4a47-ab56-34c73cdb17e9
# ╟─6661b9ce-0454-44a5-8844-c851b0d1bb32
# ╟─ce065ea1-f0c8-4d17-9b6e-0df7f0cdba09
# ╟─74c75ffd-bac8-44cf-849b-731ac6ee709f
# ╟─36c9965d-3d5e-4ca4-acba-a528e84a8404
# ╟─82e37385-3599-49a2-8045-b4e96a091e7a
# ╟─c1254cff-3530-4466-b1f0-dcfbfd596eb3
# ╟─c5edcd76-f3d0-4d08-839a-d5d7137af37a
# ╟─86d35811-8ae3-4101-ad57-4a608b49447e
# ╟─8314ea52-c6bf-47a5-a086-f9013d4ff020
# ╟─f4e5943e-11fa-4f8b-a218-379514b1795d
# ╟─29ef6810-7329-4d6e-915b-ebecd2c40c67
# ╟─d599b8d4-9830-48ae-bce7-4efc0a71b148
# ╟─74976495-edd2-4c11-ae80-e742aa9183c1
# ╟─e284a0d0-b14e-4694-8f06-a4555c30d9a8
# ╟─bf41bce3-4a14-400f-8998-a843e6e6c21e
# ╟─5fb54853-62a1-4835-be1e-c3850c6907da
# ╟─7a4f1254-ec88-45a0-9c25-04747acc536e
# ╟─c24668f0-83b6-4908-bcb0-1a3316cd2329
# ╟─5836e420-ef8d-41c3-8477-352b8f868171
# ╟─fb51b596-2f8f-4efd-9b74-10ac0dc5a4ca
# ╟─c674b08f-f85f-493a-9380-0839b9a838c4
# ╟─21696591-c4ae-4c0a-b855-e092b6632227
# ╟─6b0b8537-0355-48db-9060-52298a036ff5
# ╟─eeefaf2d-e99b-42f2-9eaa-c4bb6f8096dc
# ╟─62c384e8-4c7f-4dc0-b2bd-efe3189ee4d2
# ╟─a44d526d-ed34-46f3-bc39-f8d25b150e38
# ╟─d9752358-239c-474e-91a6-e6cbc3af594e
# ╟─3b2808f3-b20d-4c06-9871-40eaca391088
# ╟─a0a1dc6e-81ff-419e-a650-3d37c0c2891b
# ╟─8a4269da-65e9-442d-affe-113fa2d33924
# ╟─e0a6fe33-0931-4605-9c00-b23948e7cf1e
# ╟─89d6f27e-5ec9-4a32-9351-dec8e614e704
# ╟─87ad8807-44c7-41c7-8836-ea6fe0c5f1dc
# ╟─850d26ab-9b70-4c94-830d-8a9770ccba73
# ╟─f22c5535-8850-43a8-9e33-974f1148379d
# ╟─d5f940cb-db51-49c5-ad0b-a5c4d67edaa9
# ╟─8bb36956-139a-4334-8a5b-924988134e80
# ╟─8526af13-50da-4830-9631-827a2fad8ce3
# ╟─f9ea1f06-75a9-4cfa-b12d-ead56b94cb20
# ╟─82fc5e9b-6b80-4d93-898b-04ed74682b13
# ╟─a82da546-bc19-4601-af27-525aca217a92
# ╟─54bd66fa-1cee-4b10-9b13-53ef47dc08af
# ╟─02e05511-dcd5-46c8-9a96-002aa45bef9d
# ╟─81e3d167-4dfd-4fd4-abc3-5f1dd8f3ef70
# ╟─9419cdbf-0c36-4ff7-83a0-938dd97dd93e
# ╟─1a76b952-39c5-4e5f-a7fb-02a95d6b3b77
# ╟─fdd6d379-36fa-43b8-9c75-9b23b4e31104
# ╟─7ecb3fcf-b780-4ee7-8d39-2308fd2b2543
# ╟─58c7788e-0d89-41f0-bc93-37ce61eb7561
# ╟─af697702-87d8-437b-8253-3b53a441cfa0
# ╟─dbefb9a7-e8d8-4921-a01b-ea6ee4c46625
# ╟─dcf64be3-e8bc-40d5-86bf-016abba432f2
# ╟─13a2accc-78f6-481b-bc66-67cda891e88e
# ╟─b15af250-acce-4202-a1aa-56e7e06363b6
# ╟─ea51ec5d-ae1a-41bd-934b-93b77b6c6e9b
# ╟─330ea4da-48f2-46f2-98a7-f7e83e8f13ad
# ╟─b1eb7b73-aa74-4383-b7f1-b7a5dfeff24f
# ╟─db20a81a-70e0-46ab-8e63-407b74236767
# ╟─7452012b-3ea5-4d4e-9ae4-229d5662ec39
# ╟─b8be0b59-6d0b-402f-ba58-afef4cd38ef4
# ╟─616bc87c-d0bc-4a54-ad5e-2a0a7d78e42c
# ╟─cd3bdb3a-f688-4b59-b9be-394369bec02c
# ╟─922ca93a-8f84-4eb3-a21f-bd343c5e9a60
# ╟─e8387d5d-ebaa-484f-9ca5-9fda1ace0f5d
# ╟─232d81a4-0d08-41cf-8107-32e5553651d5
# ╠═c4d02f9d-15a1-4e6f-a479-c00309522f30
# ╠═f53fec22-fc14-4ee9-812c-4943de4eb64d
# ╠═881b506b-bffa-4e9c-94bd-97488ce8849a
# ╠═e28ead62-67c5-4836-b3b3-9a7b8bfc5d88
# ╠═53e22b9a-58ae-4fec-ac52-aeff1ca86216
# ╠═2b317c60-0ae0-4184-af23-a5385841eed0
# ╠═87d7391f-7bb8-4e34-9f00-0dca594441b7
# ╠═c4c57464-3143-4b0d-ac3f-6213540dc42f
# ╠═0a166ca9-4bc5-4a38-bbc5-20c6ff7ce325
# ╠═1f344c37-9775-4f06-92cf-2ae8831a43bc
# ╠═3faca86e-1db7-4904-9a0f-cda972feaa07
# ╠═dcd75e41-25da-44b6-9444-e56e77b63d78
# ╠═566f65d4-d9b2-41db-8cb1-e28c0e0100a2
# ╠═de53af16-adfe-4309-b696-ab39e7a3cfa7
# ╠═91f8c26c-b9fe-42fe-800e-5c039a12ac6c
# ╠═480643c6-6fc3-4ba6-8546-d3212c07ce7e
# ╠═21b284e0-bf27-46ae-8bf6-ebef1da80181
# ╠═c8b83bdb-e0e1-42c7-bd83-87c352f77d0b
# ╠═b8c94043-afe1-4b1c-bab4-edf940d7b6aa
# ╠═3cb09d75-a93d-4f88-8f83-35bd9fc6b53a
# ╠═3c8e0741-9df0-4988-9a29-18528d65c15d
# ╠═9d2c5a91-756c-4444-869e-9f570a67a5da
# ╠═be8ec93c-4a7f-4e7e-918d-08d7b6d4d89a
# ╠═1683e0be-8b6b-4f69-8359-7802ce4f1d03
# ╠═c9f176ac-4c8e-49a8-b892-bfbd3c287c03
# ╠═d2908f33-df93-48b7-89d2-bb910af05d6a
# ╠═c7363e9b-20d7-4be4-a220-986bb3938bdf
# ╠═ef80a22a-d36e-40b9-b297-c217f0f068cd
# ╟─203bf6d8-09ee-4feb-ac1b-75df91db9a8e
# ╟─2e72a203-7233-41ab-a50b-8eb358690a81
# ╠═1d8aac12-4dcd-49e3-9971-fb2751ba1dc9
