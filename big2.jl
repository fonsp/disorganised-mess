### A Pluto.jl notebook ###
# v0.19.12

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

# ╔═╡ 93136964-93c0-11ea-3da9-4d6e11b49b1e
using Distributed

# ╔═╡ 7ed465f9-4a0c-492c-ae57-c1db60d943a0
using ProgressLogging

# ╔═╡ b91efb6a-5079-4eba-bf74-8d6ef53414cf
using PlutoUI

# ╔═╡ d5ec6bc6-02f1-4beb-a59e-320ff33cf704
using HypertextLiteral

# ╔═╡ 6741c74d-deae-4824-8aae-1be809ee658b
using Plots

# ╔═╡ d2853f19-d8d1-4a9b-8076-ab167cf2d539
5

# ╔═╡ 88725842-b172-11ea-004c-21fc8845bc9b
const modifiers = [:(+=), :(-=), :(*=), :(/=), :(//=), :(^=), :(÷=), :(%=), :(<<=), :(>>=), :(>>>=), :(&=), :(⊻=), :(≔), :(⩴), :(≕)]


# ╔═╡ 88cacaa4-b172-11ea-30eb-3bdf5cc1f1f8
const modifiers_dotprefixed = [Symbol('.' * String(m)) for m in modifiers]


# ╔═╡ f2d5e15e-5888-4d74-b8c5-b744603be7bc
dog_file = download("https://upload.wikimedia.org/wikipedia/commons/e/ef/Pluto_in_True_Color_-_High-Res.jpg")

# ╔═╡ a75e2cf6-1520-430c-abf1-83185d494dc5
md" $(filesize(dog_file) / 1000) kB"

# ╔═╡ e0a67ff3-376e-4bf8-b281-90486f31c80d
begin
	struct Dog end
	function Base.show(io::IO, ::MIME"image/jpg", ::Dog)
		write(io, read(dog_file))
	end
end

# ╔═╡ 615bd1d0-5037-41ed-88bf-a0df03b32e2e
[Dog(),Dog(),Dog(),Dog(),Dog()]

# ╔═╡ cbd533bd-0d15-44d5-bf29-aea13b572719
Dog()

# ╔═╡ 4343e495-afc5-47a4-9791-d3bc2ae7bf03
[Dog(),Dog(),Dog(),Dog(),Dog()]

# ╔═╡ e67b124c-f21a-47ca-aa8c-4a014b86320b
1+1

# ╔═╡ c74ac385-f88f-4cbe-a05d-bffceb1dd9e1


# ╔═╡ 8843f164-b172-11ea-0d5c-67fbbd97d6ee
"ScopeState moves _up_ the ASTree: it carries scope information up towards the endpoints."
mutable struct ScopeState
    inglobalscope::Bool
    exposedglobals::Set{Symbol}
    hiddenglobals::Set{Symbol}
    definedfuncs::Set{Symbol}
end

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

# ╔═╡ 4e0e992c-b172-11ea-35a3-9f7aef3592bd
md"""
<h1><img alt="Pluto.jl" src="https://raw.githubusercontent.com/fonsp/Pluto.jl/main/frontend/img/logo.svg" width=300 height=74 ></h1>

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

Your notebooks are **saved as pure Julia files** ([sample](https://github.com/fonsp/Pluto.jl/blob/main/sample/basic.jl)), which you can then import as if you had been programming in a regular editor all along. You can also export your notebook with cell outputs as attractive HTML and PDF documents. By reordering cells and hiding code, you have full control over how you tell your story.

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
Follow [these instructions](https://github.com/fonsp/Pluto.jl/blob/main/dev_instructions.md) to start working on the package.

<img src="https://raw.githubusercontent.com/gist/fonsp/9a36c183e2cad7c8fc30290ec95eb104/raw/ca3a38a61f95cd58d79d00b663a3c114d21e284e/cute.svg">

## License

Pluto.jl is open source! Specifically, it is [MIT Licensed](https://github.com/fonsp/Pluto.jl/blob/main/LICENSE). The included sample notebooks have a more permissive license: the [Unlicense](https://github.com/fonsp/Pluto.jl/blob/main/sample/LICENSE). This means that you can use sample notebook code however you like - you do not need to credit us!

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

# ╔═╡ d6bb60b0-8fc4-11ea-1a96-6dffb769ac8d
Base.show(io::IO, ::MIME"text/plain", w::Wow) = print(io, "wowie")

# ╔═╡ 6de2fdec-9075-11ea-3a39-176a725c1c38
which(show, (IO, MIME"text/plain", Wow))

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

# ╔═╡ a53ebb96-8ff3-11ea-3a49-cdce8c158c41
Dict(:a => 1, :b => ["hoi", "merlino"])

# ╔═╡ 8984fd16-8fe4-11ea-1ff9-d5cd8f6fe0b0
m = md"asasdf $x+1$ asdfasdf".content

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

# ╔═╡ c2dcc8bc-93d0-11ea-01e2-a9541b708ecd
[false for m in PlutoRunner.allmimes];

# ╔═╡ dc6e14b6-93d0-11ea-37a4-bded1ed8adea
map(m -> m, PlutoRunner.allmimes);

# ╔═╡ 8c66f200-9070-11ea-33b8-8fe4209ebbad
if false
	afsddfsadfsadfs
end

# ╔═╡ 9036c98e-906e-11ea-1424-bbe053ae281c
d = Derp(1, 2)

# ╔═╡ f4f81140-9076-11ea-3fc9-b9098fa5f8ab
md"asdf $(d) asdf"

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

# ╔═╡ af73d112-63ff-4a38-91cd-81eba93b867e
md"""
# Progress
"""

# ╔═╡ f0cf1d77-06fe-4718-9488-864810ab2ed8
begin
	@info "Let's start!"
	@progress for z in 1:1000
		# sleep(.003)
	end
	@info "Yayy"
	@info "Yayy"
end

# ╔═╡ 8895447e-99c5-4d47-b3a4-9862bfcc08bf
for i in 1:10
	
	@debug i
	@info i*100
	if isodd(i)
		@warn "Oh no!" i
		@error i
	end
	# sleep(.1)
end

# ╔═╡ 306c209c-fb30-49ee-8a75-8170d7a7fa6d
for z in 1:20
	@info z
	# sleep(.1)
end

# ╔═╡ b1c97e7e-dcac-444a-a05c-5e6c33b5ffd1
@warn "wow"

# ╔═╡ 13625f22-bef7-4417-9d49-99c51892d31e
md"""
# Positioning
"""

# ╔═╡ 508c53c1-3b6e-4dfa-9c53-d18169375e80
some_data = Dict([1,"asdf"] => (123, [1,[2,3,[4,5, md"# asdf"]]], md"## asdf", DomainError("asdf")))

# ╔═╡ 13f0c730-35a8-4dea-a8f0-165d3903dd5b
@info "23aaa" some_data

# ╔═╡ a5ffdc26-2dab-4aa0-afa4-8835293ba80b
collect(rand(1000))

# ╔═╡ 2fb860a9-c485-4349-9856-6fa48b918c99
:asdf  => 123

# ╔═╡ bb51f241-d9a3-4ae6-830e-d781571b1598
let
	@info "a asdf   as"
	123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123
	@info "b"
	@info "c"
end

# ╔═╡ cb18b686-8fd8-11ea-066c-bd467edfc009
x

# ╔═╡ e8d20214-8fe4-11ea-07cf-0970e4d1b8f0
sprint(Markdown.tohtml, x)

# ╔═╡ e8e983ae-870f-11ea-27b8-a7fbc1361d6b
x

# ╔═╡ eed501f8-9076-11ea-3002-a5ec32d6dccb
md"asdf $(x) asdf"

# ╔═╡ 88f424ee-8fcb-11ea-3204-03c943098a17
let
	enu = enumerate(x)
	enu[1], enu[1]
end

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

# ╔═╡ b9d933cc-93d3-11ea-1b5b-d577af02c052
fr()

# ╔═╡ eb61f3a8-93d2-11ea-33d9-25c299894e80
findnext(m -> showable(m, x), PlutoRunner.allmimes, 1)

# ╔═╡ 446407aa-93d0-11ea-27f9-ad9a8a3d9c2f
[showable(m, x) for m in PlutoRunner.allmimes]

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

# ╔═╡ 3f788374-9074-11ea-2e28-4330a2401862
x |> Tuple

# ╔═╡ 9465b147-a3c7-4e50-85c9-ff7707a8ad1b
b = @bind hello Slider(1:100)

# ╔═╡ 44edbbf8-0c16-4007-b1a3-6d5231e489ed
b

# ╔═╡ 6d25cb2b-f0e8-4f68-925c-544ed57b4518
hello

# ╔═╡ 59c0b08b-2a9d-465b-99b5-5cc8e10be358
@warn "Oh no!" 12

# ╔═╡ 8b8e18f0-2013-468c-afb3-ecfbe893755e
begin

	@info "aaabbbcccddd aaabbbcccddd aaabbbcccddd aaabbbcccddd aaabbbcccddd aaabbbcccddd aaabbbcccddd aaabbbcccddd aaabbbcccddd aaabbbcccddd aaabbbcccddd aaabbbcccddd "
	@info "aaabbbcccdddaaabbbcccdddaaabbbcccdddaaabbbcccdddaaabbbcccdddaaabbbcccdddaaabbbcccdddaaabbbcccdddaaabbbcccdddaaabbbcccdddaaabbbcccdddaaabbbcccdddaaabbbcccddd"

	@info "Remeber to use the function Base.alsjdhfkjashdf to also get akjshdfkjashdfkjhasdf."
	
	@warn md"""
	_Writing a notebook is not just about writing the final document — Pluto empowers the experiments and discoveries that are essential to getting there._

	**Explore models and share results** in a notebook that is

	-   **_reactive_** - when changing a function or variable, Pluto automatically updates all affected cells.
	-   **_lightweight_** - Pluto is written in pure Julia and is easy to install.
	-   **_simple_** - no hidden workspace state; friendly UI.
	"""

	println("Some long text asdflkj asldkjf aslkdfj alskjdf kj")
end

# ╔═╡ 16c33682-0c6b-48e3-b104-6f40c5c62be8
md"""
# Rich output in logs
"""

# ╔═╡ b972c046-13cc-4a52-bb08-0f0b3d6d00ee
svg_data = download("https://diffeq.sciml.ai/stable/assets/multiODEplot.png") |> read

# ╔═╡ 86806cd5-069f-4158-b672-c146382a33c1
cool_plot = Show(MIME"image/png"(), svg_data)

# ╔═╡ bb87c9fe-e37b-4aec-a83a-dbd9b8ef69bb
plot(args...; kwargs...) = Plots.plot(args...; kwargs..., size=(150,120)) |> as_svg

# ╔═╡ 79a0d9ab-8952-459c-b61a-4c6e53fe9d3c
begin
	
	simulation_data = [1,2,23,2,3]
	
	@info plot(simulation_data)


	
end

# ╔═╡ 3cb40a88-6886-44a2-8430-11e329e14cb4
md"""
# @bind in logs
"""

# ╔═╡ e02aed05-6cce-402a-a7b6-cd3c5bbd6624
begin
	
	b1 = @bind wowz1 Slider(50:60)
	b2 = @bind wowz1 TextField()

	@htl("$(b1)$(b2)")
end

# ╔═╡ c7ef3be8-9932-408b-a2e1-e3d5c33652b8
wowz1, wowz1

# ╔═╡ 4161b996-f4a2-46c7-a6e9-b0e667310e75
begin
	
	@info @bind wowz Slider(1:100)
	
end

# ╔═╡ 30b188b7-1681-4b21-b866-61825761ca0d
t2 = collect(1:wowz)

# ╔═╡ 63f7b3bd-bcd6-4af8-9c8f-a04397f12272
let
	result = sin.(t2)
	@info plot(t2, result)

	
	result
end

# ╔═╡ 3b0f4aff-81a2-4b09-a44f-a6bc5aa9c991
md"""
# External logs
"""

# ╔═╡ 105ff1f5-5fc8-4ccd-a854-d2e9535be9d7
md"""
### Function defined in another cell:
"""

# ╔═╡ f3857278-ea6b-47a8-b38e-eae6e82944f9
function flog(x)
	
	@warn "x might be too large!" x
end

# ╔═╡ a78824bc-a01c-4bd5-9e64-68eb97244c6b
flog(123)

# ╔═╡ 41d0d3ed-60ac-49ce-9d79-242c7e1cd3c6
md"""
### Function defined in another file:
"""

# ╔═╡ 3a5ed727-fc57-469e-8b25-42b9aadd4fe6
external_src = let
	f = tempname()
	code = """
	function g(x)

		@warn "x might be too large!" x
	end
	"""
	write(f, code)
	f
end

# ╔═╡ 3fa9f1bf-3062-4bf1-9b96-c49a0d5650e1
function ingredients(path::String)
	# this is from the Julia source code (evalfile in base/loading.jl)
	# but with the modification that it returns the module instead of the last object
	name = Symbol(basename(path))
	m = Module(name)
	Core.eval(m,
        Expr(:toplevel,
             :(eval(x) = $(Expr(:core, :eval))($name, x)),
             :(include(x) = $(Expr(:top, :include))($name, x)),
             :(include(mapexpr::Function, x) = $(Expr(:top, :include))(mapexpr, $name, x)),
             :(include($path))))
	m
end

# ╔═╡ 875dab69-2348-40e9-8494-fe488d813065
ex_m = ingredients(external_src)

# ╔═╡ 1c99806f-8c22-4a75-bafc-04aafd2422ee
ex_m.g(123)

# ╔═╡ 33d24aa8-c052-4f00-912e-3988665a021c
md"""

# Hello


I am a footnote $(@info("Inside text!")), how cool is that!

But im not working :(
"""

# ╔═╡ ae021b81-1f55-4740-bb0f-398a7d0fc460
with_terminal() do
	println(123)
end

# ╔═╡ 116fed02-c62f-447f-844f-9bb8264d25c1
@info md"# hello"

# ╔═╡ 5f897e37-32e5-4697-ad07-e8e7e03fc7b5
for p in readdir(first(DEPOT_PATH))
	print(p)
	print("/")
	print("\t\t")
	print("(", Base.format_bytes(rand(1:10_000_000)), ")")
	println()
	print("  ")
	print()
	println()
end

# ╔═╡ d795a01d-6136-4283-9eb7-e71a0b383f09
import Logging

# ╔═╡ aa3b9cb0-12cf-425f-bb80-d558946a244e
FileTrees.children(t)

# ╔═╡ b1a7c6bf-4ba1-4bd0-bbf2-9af4bfca64c3
Logging.@logmsg Logging.LogLevel(-100) "asdf"

# ╔═╡ 32f9051b-22d5-4388-a4ae-916acb9b36ec
begin
	print(123)
	@info 123
	@info 123
end

# ╔═╡ 0d624f84-85e3-4da2-b0bb-5c2293112fd5
for x in 1:200
	@info "This is too long."
end

# ╔═╡ d7f65532-a240-43c9-9652-4388370efda5
md"""
![](https://cdn.vox-cdn.com/thumbor/sgjCRJzWvyufDoVKCPKPrsyhZoA=/1400x0/filters:no_upscale()/cdn.vox-cdn.com/uploads/chorus_asset/file/10161377/iprimus_180205_2248_0003.jpg)
"""

# ╔═╡ f3fa9e68-2035-4c97-85d1-828eb62caa26
run(`ls -lha $(first(DEPOT_PATH))`)

# ╔═╡ a04c0a98-58ba-40d7-827a-1740c0d88ac3
Logging.@logmsg Logging.LogLevel(-10) "asdf"

# ╔═╡ b2dedd2f-0221-4a01-801a-a236490f7a2e
begin
	println("Here is some ascii art!")
	println()

	@time for y in LinRange(5,-5,21)
		for x in LinRange(-5,5,40)
			print(f(x,y) ? "X" : " ")
		end
		println()
	end
end

# ╔═╡ 568caeb7-1c7f-4096-8ffc-a25a42066e13
FileTrees.load(t) do z
	rand()
end

# ╔═╡ 87bb4ac5-2384-46b1-a3bc-d6f51eb14332
for i in 1:10
	@info i
	@debug i
	sleep(.05)
end

# ╔═╡ 4d3428a7-52b7-4bd3-89a4-e69fcaba7a58
@info collect(1:100)

# ╔═╡ ec35d8d6-80a3-43d3-ac2a-3dc655710081
Logging.@logmsg Logging.LogLevel(-555) "asdf"

# ╔═╡ d2483d92-0646-46e4-80e3-b05aae536471
@bind wow html"<input type=checkbox>"

# ╔═╡ 96a80caf-96ab-4038-b2b2-0ef164587032
begin
	
	wow && @info "a"
	wow && @info "b"
	wow && @info "c"
	wow && @info "d"
	
	try
		sqrt(-1)
	catch e
		@error "99" exception=(e, catch_backtrace())
	end
	nothing
end

# ╔═╡ c48c846b-92dd-4796-9b5b-725de07a5dcf
md"# Logging"

# ╔═╡ 96bc5806-c734-4dea-bdca-083949483fc8
# ╠═╡ disabled = true
#=╠═╡
x = 233564653
  ╠═╡ =#

# ╔═╡ e5a5561c-870c-11ea-27be-a51a15915e64
x = [1, [2,3,4], 620:800...]

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Distributed = "8ba89e20-285c-5b6f-9357-94700520ee1b"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
Logging = "56ddb016-857b-54e1-b83d-db4d58db5568"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
ProgressLogging = "33c8b6b6-d38a-422a-b730-caa89a2f386c"

[compat]
HypertextLiteral = "~0.9.4"
Plots = "~1.35.2"
PlutoUI = "~0.7.43"
ProgressLogging = "~0.1.4"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.0"
manifest_format = "2.0"
project_hash = "e1cd720322a414ec61165a8bfdbe5685fd215164"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BitFlags]]
git-tree-sha1 = "84259bb6172806304b9101094a7cc4bc6f56dbc6"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.5"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "e7ff6cadf743c098e08fca25c91103ee4303c9bb"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.15.6"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "38f7a08f19d8810338d4f5085211c7dfa5d5bdd8"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.4"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "ded953804d019afa9a3f98981d99b33e3db7b6da"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.0"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "1fd869cc3875b57347f7027521f561cf46d1fcd8"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.19.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "d08c20eef1f2cbc6e60fd3612ac4340b89fea322"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.9"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[deps.Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "5856d3031cdb1f3b2b6340dfdc66b6d9a149a374"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.2.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "0.5.2+0"

[[deps.Contour]]
git-tree-sha1 = "d05d9e7b7aedff4e5b51a029dced05cfb6125781"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.2"

[[deps.DataAPI]]
git-tree-sha1 = "46d2680e618f8abd007bce0c3026cb0c4a8f2032"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.12.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "d1fff3a548102f48987a52a2e0d114fa97d730f0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.13"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "5158c2b41018c5f7eb1470d558127ac274eca0c9"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.1"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bad72f730e9e91c08d9427d5e8db95478a3c323d"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.4.8+0"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Pkg", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "74faea50c1d007c85837327f6775bea60b5492dd"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.2+2"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "d972031d28c8c8d9d7b41a536ad7bb0c2579caca"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.8+0"

[[deps.GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Preferences", "Printf", "Random", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "a9ec6a35bc5ddc3aeb8938f800dc599e652d0029"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.69.3"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "bc9f7725571ddb4ab2c4bc74fa397c1c5ad08943"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.69.1+0"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "fb83fbe02fe57f2c068013aa94bcdf6760d3a7a7"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.74.0+1"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "Dates", "IniFile", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "4abede886fcba15cd5fd041fef776b230d004cee"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.4.0"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.IniFile]]
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "49510dfcb407e572524ba94aeae2fced1f3feb0f"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.8"

[[deps.IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[deps.JLFzf]]
deps = ["Pipe", "REPL", "Random", "fzf_jll"]
git-tree-sha1 = "f377670cda23b6b7c1c0b3893e37451c5c1a2185"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.5"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b53380851c6e6664204efb2e62cd24fa5c47e4ba"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.2+0"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "ab9aa169d2160129beb241cb2750ca499b4e90e9"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.17"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "7739f837d6447403596a75d19ed01fd08d6f56bf"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.3.0+3"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "3eb79b0ca5764d4799c06699573fd8f533259713"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.4.0+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "94d9c52ca447e23eac0c0f074effbcd38830deb5"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.18"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "5d4d2d9904227b8bd66386c1138cf4d5ffa826bf"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "0.4.9"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "42324d08725e200c23d4dfb549e0d5d89dede2d2"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.10"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "Random", "Sockets"]
git-tree-sha1 = "6872f9594ff273da6d13c7c1a1545d5a8c7d0c1c"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.6"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.0+0"

[[deps.Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.2.1"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "a7c3d1da1189a1c2fe843a3bfa04d18d20eb3211"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.1"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "ebe81469e9d7b471d7ddb611d9e147ea16de0add"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.2.1"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e60321e3f2616584ff98f0a4f18d98ae6f89bbb3"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.17+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.40.0+0"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "3d5bf43e3e8b412656404ed9466f1dcbf7c50269"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.4.0"

[[deps.Pipe]]
git-tree-sha1 = "6842804e7867b115ca9de748a0cf6b364523c16d"
uuid = "b98c9c47-44ae-5843-9183-064241ee97a0"
version = "1.3.0"

[[deps.Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "8162b2f8547bc23876edd0c5181b27702ae58dce"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.0.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "SnoopPrecompile", "Statistics"]
git-tree-sha1 = "21303256d239f6b484977314674aef4bb1fe4420"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.3.1"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SnoopPrecompile", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "65451f70d8d71bd9d06821c7a53adbed162454c9"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.35.2"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "2777a5c2c91b3145f5aa75b61bb4c2eb38797136"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.43"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.ProgressLogging]]
deps = ["Logging", "SHA", "UUIDs"]
git-tree-sha1 = "80d919dee55b9c50e8d9e2da5eeafff3fe58b539"
uuid = "33c8b6b6-d38a-422a-b730-caa89a2f386c"
version = "0.1.4"

[[deps.Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "c6c0f690d0cc7caddb74cef7aa847b824a16b256"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+1"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RecipesBase]]
deps = ["SnoopPrecompile"]
git-tree-sha1 = "612a4d76ad98e9722c8ba387614539155a59e30c"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.0"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase"]
git-tree-sha1 = "017f217e647cf20b0081b9be938b78c3443356a0"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.6"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "90bc7a7c96410424509e4263e277e43250c05691"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.0"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "f94f779c94e58bf9ea243e77a37e16d9de9126bd"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.1"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[deps.SnoopPrecompile]]
git-tree-sha1 = "f604441450a3c0569830946e5b33b78c928e1a85"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.1"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "d75bda01f8c31ebb72df80a46c88b25d1c79c56d"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.1.7"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f9af7f195fb13589dd2e2d57fdb401717d2eb1f6"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.5.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "d1bf48bfcc554a3761a133fe3a9bb01488e06916"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.21"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "8a75929dcd3c38611db2f8d08546decb514fcadf"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.9"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[deps.URIs]]
git-tree-sha1 = "e59ecc5a41b000fa94423a578d29290c7266fc10"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[deps.Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "58443b63fb7e465a8a7210828c91c08b92132dff"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.14+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.12+3"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e45044cd873ded54b6a5bac0eb5c971392cf1927"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.2+0"

[[deps.fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "868e669ccb12ba16eaf50cb2957ee2ff61261c56"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.29.0+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3a2ea60308f0996d26f1e5354e10c24e9ef905d4"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.4.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.1+0"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "9ebfc140cc56e8c2156a15ceac2f0302e327ac0a"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+0"
"""

# ╔═╡ Cell order:
# ╠═615bd1d0-5037-41ed-88bf-a0df03b32e2e
# ╠═d2853f19-d8d1-4a9b-8076-ab167cf2d539
# ╠═cbd533bd-0d15-44d5-bf29-aea13b572719
# ╠═881ed6f4-b172-11ea-237a-6d64da160f42
# ╠═88a66df8-b172-11ea-3221-a9ee7593773f
# ╠═a75e2cf6-1520-430c-abf1-83185d494dc5
# ╠═88725842-b172-11ea-004c-21fc8845bc9b
# ╠═88cacaa4-b172-11ea-30eb-3bdf5cc1f1f8
# ╠═e0a67ff3-376e-4bf8-b281-90486f31c80d
# ╠═4343e495-afc5-47a4-9791-d3bc2ae7bf03
# ╠═f2d5e15e-5888-4d74-b8c5-b744603be7bc
# ╠═e67b124c-f21a-47ca-aa8c-4a014b86320b
# ╠═c74ac385-f88f-4cbe-a05d-bffceb1dd9e1
# ╠═8843f164-b172-11ea-0d5c-67fbbd97d6ee
# ╠═9be01bf8-b172-11ea-04fe-13c44256cf50
# ╠═88a37164-b172-11ea-3db5-cba8006705b7
# ╠═bcc6f5ee-b172-11ea-1300-2f15d78621e8
# ╠═c0950f58-b172-11ea-1732-33d5e0b64bfa
# ╠═2c0e8b60-b173-11ea-1db9-b7ae66e03dc1
# ╠═321f9e52-b193-11ea-09d3-0fcf6af1e472
# ╠═18c9914e-b173-11ea-342e-01c4e2097b8c
# ╠═ff545550-b172-11ea-33ed-eb222597f035
# ╠═2464da5e-b173-11ea-2532-13c06602328d
# ╠═5edd43d4-b172-11ea-1dc4-79c3e07941ed
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
# ╟─af73d112-63ff-4a38-91cd-81eba93b867e
# ╠═7ed465f9-4a0c-492c-ae57-c1db60d943a0
# ╠═f0cf1d77-06fe-4718-9488-864810ab2ed8
# ╠═8895447e-99c5-4d47-b3a4-9862bfcc08bf
# ╠═b91efb6a-5079-4eba-bf74-8d6ef53414cf
# ╠═306c209c-fb30-49ee-8a75-8170d7a7fa6d
# ╠═b1c97e7e-dcac-444a-a05c-5e6c33b5ffd1
# ╟─13625f22-bef7-4417-9d49-99c51892d31e
# ╠═508c53c1-3b6e-4dfa-9c53-d18169375e80
# ╠═13f0c730-35a8-4dea-a8f0-165d3903dd5b
# ╠═a5ffdc26-2dab-4aa0-afa4-8835293ba80b
# ╠═2fb860a9-c485-4349-9856-6fa48b918c99
# ╠═bb51f241-d9a3-4ae6-830e-d781571b1598
# ╠═96bc5806-c734-4dea-bdca-083949483fc8
# ╠═96a80caf-96ab-4038-b2b2-0ef164587032
# ╠═9465b147-a3c7-4e50-85c9-ff7707a8ad1b
# ╠═44edbbf8-0c16-4007-b1a3-6d5231e489ed
# ╠═6d25cb2b-f0e8-4f68-925c-544ed57b4518
# ╠═59c0b08b-2a9d-465b-99b5-5cc8e10be358
# ╟─8b8e18f0-2013-468c-afb3-ecfbe893755e
# ╟─16c33682-0c6b-48e3-b104-6f40c5c62be8
# ╟─b972c046-13cc-4a52-bb08-0f0b3d6d00ee
# ╠═86806cd5-069f-4158-b672-c146382a33c1
# ╠═bb87c9fe-e37b-4aec-a83a-dbd9b8ef69bb
# ╠═79a0d9ab-8952-459c-b61a-4c6e53fe9d3c
# ╠═3cb40a88-6886-44a2-8430-11e329e14cb4
# ╠═d5ec6bc6-02f1-4beb-a59e-320ff33cf704
# ╠═e02aed05-6cce-402a-a7b6-cd3c5bbd6624
# ╠═c7ef3be8-9932-408b-a2e1-e3d5c33652b8
# ╟─4161b996-f4a2-46c7-a6e9-b0e667310e75
# ╠═63f7b3bd-bcd6-4af8-9c8f-a04397f12272
# ╠═6741c74d-deae-4824-8aae-1be809ee658b
# ╠═30b188b7-1681-4b21-b866-61825761ca0d
# ╟─3b0f4aff-81a2-4b09-a44f-a6bc5aa9c991
# ╟─105ff1f5-5fc8-4ccd-a854-d2e9535be9d7
# ╠═f3857278-ea6b-47a8-b38e-eae6e82944f9
# ╠═a78824bc-a01c-4bd5-9e64-68eb97244c6b
# ╟─41d0d3ed-60ac-49ce-9d79-242c7e1cd3c6
# ╠═3a5ed727-fc57-469e-8b25-42b9aadd4fe6
# ╟─3fa9f1bf-3062-4bf1-9b96-c49a0d5650e1
# ╠═875dab69-2348-40e9-8494-fe488d813065
# ╠═1c99806f-8c22-4a75-bafc-04aafd2422ee
# ╟─33d24aa8-c052-4f00-912e-3988665a021c
# ╠═ae021b81-1f55-4740-bb0f-398a7d0fc460
# ╠═116fed02-c62f-447f-844f-9bb8264d25c1
# ╠═5f897e37-32e5-4697-ad07-e8e7e03fc7b5
# ╠═d795a01d-6136-4283-9eb7-e71a0b383f09
# ╠═aa3b9cb0-12cf-425f-bb80-d558946a244e
# ╠═b1a7c6bf-4ba1-4bd0-bbf2-9af4bfca64c3
# ╠═32f9051b-22d5-4388-a4ae-916acb9b36ec
# ╠═0d624f84-85e3-4da2-b0bb-5c2293112fd5
# ╠═d7f65532-a240-43c9-9652-4388370efda5
# ╠═f3fa9e68-2035-4c97-85d1-828eb62caa26
# ╠═a04c0a98-58ba-40d7-827a-1740c0d88ac3
# ╠═b2dedd2f-0221-4a01-801a-a236490f7a2e
# ╠═568caeb7-1c7f-4096-8ffc-a25a42066e13
# ╠═87bb4ac5-2384-46b1-a3bc-d6f51eb14332
# ╠═4d3428a7-52b7-4bd3-89a4-e69fcaba7a58
# ╠═ec35d8d6-80a3-43d3-ac2a-3dc655710081
# ╠═d2483d92-0646-46e4-80e3-b05aae536471
# ╠═c48c846b-92dd-4796-9b5b-725de07a5dcf
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
