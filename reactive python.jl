### A Pluto.jl notebook ###
# v0.16.1

using Markdown
using InteractiveUtils

# ╔═╡ 8e0722dc-6a3d-4cb3-ac8e-c527f123d0a7
import Pkg

# ╔═╡ 6a35c5b8-2ce0-11ec-3a8c-b5a25bab9f9b
using PyCall

# ╔═╡ b59d932b-6425-47c2-a67d-208113bc8b7b
using PlutoUI

# ╔═╡ e07e4a47-a3cc-4ca4-a946-29e7df33ec6d
md"""
# Reactive Python

The `pyr"` macro is just like the `py"` macro from `PyCall.jl`, except it is reactive! This means:
- If you define a Python variable, then other cells that use that python variable are also evaluated.
- The scope of Python variables is cleaned up automatically.
- Multiple definitions are not allowed.

This is using the Python port of Pluto.ExpressionExplorer by Mikołaj Bochenski: [https://github.com/lightning-notebook/engine](https://github.com/lightning-notebook/engine) and some Julia macro magic.
"""

# ╔═╡ 12814f02-7e90-401a-9573-5c6b2f8067ae
# Pkg.build("PyCall")

# ╔═╡ e8873c23-139d-41bc-be35-ebd636e48aee
begin
	py"""
	import math
	math.sin
	"""
	py"math.sin"(2)
end

# ╔═╡ 005b40d9-bd89-4491-9807-d33a6c674b75
begin
	py"""
	import math
	math.sin"""(2)
end

# ╔═╡ 6449e96f-19ce-4100-8b35-56113bc24b7d
Dump(:(py"[1+1]"))

# ╔═╡ d9bc5dc1-67b6-47c6-9592-3b474ec451a0
Dump(:(py"""
[1+1]
"""))

# ╔═╡ 56fcc0c2-0ce0-445b-b602-6525bab173b3
begin
	rand(), try
		var"#py_var_x"
	catch end
end

# ╔═╡ a1ada27d-8a1a-453a-ace7-ae07b68ad42a
123

# ╔═╡ 56a3a022-6ed3-47d8-8d62-ce4ead5ca026
Base.remove_linenums!(Meta.macroexpand(@__MODULE__, :(pyr"""
x = 123
y = b
"""); recursive=false))

# ╔═╡ 7576c6f6-3fc8-453a-b4c8-fe0c53b9ed7e
# string(Expr(:symbol, Symbol("#a")))

# ╔═╡ d3fe9870-ac9d-4871-b8cc-1361a446b0a5
import PyCall: interpolate_pycode, Py_file_input, make_fname, Py_eval_input, pynamespace, pyeval_

# ╔═╡ b9903477-5070-43eb-82a9-8b750f79c8fa
macro custom_py_str(code, options...)
    T = length(options) == 1 && 'o' in options[1] ? PyObject : PyAny
    code, locals = interpolate_pycode(code)
    input_type = '\n' in code ? Py_file_input : Py_eval_input
    fname = make_fname(@__FILE__)
    assignlocals = Expr(:block, [(isa(v,String) ?
                                  :(m[$v] = PyObject($(esc(ex)))) :
                                  nothing) for (v,ex) in locals]...)
    code_expr = Expr(:call, esc(:(Base.string)))
    i0 = firstindex(code)
    for i in sort!(collect(filter(k -> isa(k,Integer), keys(locals))))
        push!(code_expr.args, code[i0:prevind(code,i)], esc(locals[i]))
        i0 = i
    end
    push!(code_expr.args, code[i0:lastindex(code)])
    if input_type == Py_eval_input
        removelocals = Expr(:block, [:(delete!(m, $v)) for v in keys(locals)]...)
    else
        # if we are evaluating multi-line input, then it is not
        # safe to remove the local variables, because they might be referred
        # to in Python function definitions etc. that will be called later.
        removelocals = nothing
    end
    quote
        m = pynamespace(Main)
        $assignlocals
        ret = $T(pyeval_($code_expr, m, m, $input_type, $fname))
        $removelocals
        ret
    end
end

# ╔═╡ fdd2e0ae-7ac9-4da7-9bfb-41d7cf76296b
begin
	custom_py"""
	x = 3
	"""

	custom_py"x"
end

# ╔═╡ 688c93e7-b50f-4bb7-ab23-5686fd8ffb18
custom_py"""
1 + 1"""

# ╔═╡ 600344b6-ff43-431b-b858-2bf30e93d938
md"""
Following code is from [https://github.com/lightning-notebook/engine/blob/master/tests/test_variable_access.py](https://github.com/lightning-notebook/engine/blob/master/tests/test_variable_access.py)
"""

# ╔═╡ d74aed51-9542-47aa-8c3d-fb634c1a0212
py_reads_writes = begin
	py"""
	import ast
	import functools
	
	
	
	class VariableAccess:
	    def __init__(self, reads, writes):
	        self.reads = frozenset(reads)
	        self.writes = frozenset(writes)
	    
	
	    @classmethod
	    def from_code(cls, code):
	        return cls.from_ast(ast.parse(code))
	    
	
	    @classmethod
	    def from_ast(cls, ast_node):
	        if isinstance(ast_node, ast.Name):
	            return cls(reads=[ast_node.id], writes=[])
	
	        if isinstance(ast_node, ast.Assign):
	            targets = cls.from_ast(ast_node.targets)
	            value = cls.from_ast(ast_node.value)
	            return cls(reads=value.reads, writes=targets.reads | targets.writes | value.writes)
	        if isinstance(ast_node, ast.AugAssign): # x += 3, for example
	            target = cls.from_ast(ast_node.target)
	            value = cls.from_ast(ast_node.value)
	            return cls(reads=value.reads, writes=target.reads | target.writes | value.writes)
	        
	        if isinstance(ast_node, ast.ImportFrom):
	            if ast_node.names[0].name == '*':
	                raise NotImplementedError('"import *" is not supported yet!')
	            return cls.from_ast(ast_node.names)
	        if isinstance(ast_node, ast.alias):
	            return cls(reads=[], writes=[ast_node.asname or ast_node.name])
	        
	        if isinstance(ast_node, ast.ClassDef):
	            bases = cls.from_ast(ast_node.bases)
	            keywords = cls.from_ast(ast_node.keywords)
	            decorators = cls.from_ast(ast_node.decorator_list)
	            body = cls.from_ast(ast_node.body) # no name shadowing because of "if x: y = 10"
	            return cls(
	                reads=bases.reads | keywords.reads | decorators.reads | body.reads,
	                writes=[ast_node.name]
	            )
	        
	        if isinstance(ast_node, ast.Lambda):
	            arguments = cls.from_ast(ast_node.args)
	            body = cls.from_ast(ast_node.body)
	            return cls(reads=arguments.reads | (body.reads - arguments.writes), writes=[])
	        if isinstance(ast_node, ast.FunctionDef):
	            decorators = cls.from_ast(ast_node.decorator_list)
	            arguments = cls.from_ast(ast_node.args)
	            body = cls.from_ast(ast_node.body)
	            return cls(reads=decorators.reads | arguments.reads | (body.reads - arguments.writes), writes=[ast_node.name])
	        if isinstance(ast_node, ast.arg):
	            return cls(reads=[], writes=[ast_node.arg])
	
	        if isinstance(ast_node, ast.For):
	            target = cls.from_ast(ast_node.target) # no name shadowing - target is actually written to
	            iterable = cls.from_ast(ast_node.iter)
	            body = cls.from_ast(ast_node.body)
	            else_body = cls.from_ast(ast_node.orelse)
	            return cls(
	                reads=iterable.reads | body.reads | else_body.reads,
	                writes=target.reads | target.writes | iterable.writes | body.writes | else_body.writes
	            )
	        
	        if isinstance(ast_node, ast.ListComp):
	            element = cls.from_ast(ast_node.elt)
	            generators = cls.from_ast(ast_node.generators)
	            return element | generators # TODO: name shadowing
	        if isinstance(ast_node, ast.SetComp):
	            element = cls.from_ast(ast_node.elt)
	            generators = cls.from_ast(ast_node.generators)
	            return element | generators # TODO: name shadowing
	        if isinstance(ast_node, ast.DictComp):
	            key = cls.from_ast(ast_node.key)
	            value = cls.from_ast(ast_node.value)
	            generators = cls.from_ast(ast_node.generators)
	            return key | value | generators # TODO: name shadowing
	        if isinstance(ast_node, ast.comprehension):
	            target = cls.from_ast(ast_node.target)
	            iterable = cls.from_ast(ast_node.iter)
	            conditions = cls.from_ast(ast_node.ifs)
	            return target | iterable | conditions # TODO: name shadowing
	        
	        if isinstance(ast_node, list):
	            return functools.reduce(
	                cls.__or__,
	                [cls.from_ast(sub_ast) for sub_ast in ast_node],
	                cls(reads=[], writes=[])
	            )
	        
	        for node_type, children in node_children.items():
	            if isinstance(ast_node, node_type):
	                return cls.from_ast([getattr(ast_node, child) for child in children])
	        
	        raise NotImplementedError(f'Cannot parse {type(ast_node)} yet!')
	
	
	    def __eq__(self, other):
	        return self.reads == other.reads and self.writes == other.writes
	
	
	    def __or__(self, other):
	        return type(self)(reads=self.reads | other.reads, writes=self.writes | other.writes)
	    
	
	    def __repr__(self):
	        return f'{type(self).__name__}(reads={list(self.reads)}, writes={list(self.writes)})'
	
	
	node_children = {
	    ast.Constant: [],
	    ast.Pass: [],
	    type(None): [],
	    ast.Expression: ['body'],
	    ast.Expr: ['value'],
	    ast.Module: ['body'],
	    ast.Import: ['names'],
	    ast.Attribute: ['value'],
	    ast.arguments: ['posonlyargs', 'args', 'vararg', 'kwonlyargs', 'kwarg', 'defaults', 'kw_defaults'],
	    ast.Return: ['value'],
	    ast.Call: ['func', 'args', 'keywords'],
	    ast.keyword: ['value'],
	    ast.If: ['test', 'body', 'orelse'],
	    ast.IfExp: ['test', 'body', 'orelse'],
	    ast.While: ['test', 'body', 'orelse'],
	    ast.Tuple: ['elts'],
	    ast.List: ['elts'],
	    ast.Set: ['elts'],
	    ast.Dict: ['keys', 'values'],
	    ast.JoinedStr: ['values'],
	    ast.FormattedValue: ['value'],
	    ast.Subscript: ['value', 'slice'],
	    ast.Index: ['value'],
	    ast.Slice: ['lower', 'upper', 'step'],
	    ast.UnaryOp: ['operand'],
	    ast.BinOp: ['left', 'right'],
	    ast.BoolOp: ['values'],
	    ast.Compare: ['left', 'comparators']
	}

	def reads_writes(code):
		va = VariableAccess.from_code(code)
		return [va.reads, va.writes]
	"""
	
	py"reads_writes"
end

# ╔═╡ 71ca495d-39ad-4d52-94a5-d4248679ce1e
rw = py_reads_writes("x=2")

# ╔═╡ ab92a31d-1ef4-427f-b1c7-fa2790278a14
rw[2] |> collect

# ╔═╡ 5c432b4e-60e0-4288-8d5a-42e364ce8d16
macro pyr_str(str)
	var"@custom_py_str"
	
	reads, writes = py_reads_writes(str)

	quote
		# if false
		$([let
			julia_s = Symbol("py#var_", py_s)
			import_code = """$(py_s) = \$(s)\n"""
			esc(quote
				let s = $(julia_s) # for pluto to recognise
				@custom_py_str($(import_code)) # load stored PyObject into python using that name
				end
			end)
		end for py_s in reads]...)
		# end
		
		output = @custom_py_str($(str))
		
		# if false

		$([let
			julia_s = Symbol("py#var_", py_s)
			import_code = "$(py_s)"
			esc(quote
				$(julia_s) = @custom_py_str($(import_code)) # store PyObject as julia object, so that it can use Pluto's reactivity
			end)
		end for py_s in writes]...)
		# end
		output
	end
end

# ╔═╡ f93f0eef-bb0c-45ee-a080-e8eeb6611176
pyr"""
x = 2
"""

# ╔═╡ 73c3f448-be7d-49b7-9e39-18c3a08feb01
pyr"""
y = x + x
"""

# ╔═╡ f4d3b313-1c8c-4de1-b5bd-592cb1112068
pyr"[x, y]"

# ╔═╡ dd20f208-0e39-4255-b35a-a8189986a165
pyr"""
def cool(x, y):
	return 123123
"""

# ╔═╡ 5dc1c311-1004-4056-b0a9-06622546486e
pyr"cool(x, x)"

# ╔═╡ 21199966-adc3-498e-87ae-62333810efb5
@macroexpand pyr"""
x = 123
y = b
"""

# ╔═╡ 216e88b3-82cb-4d74-aae4-c21791980ac2
pyr"""
def f(x):
	return x + 1123123
"""

# ╔═╡ fb3fb09d-1ba7-431e-aba2-f832d259075a
pyr"f(1)"

# ╔═╡ 5f5ab869-c551-42d3-9325-86ecdc424c9b
macro pyr_old_str(str)
	var"@custom_py_str"
	
	reads, writes = py_reads_writes(str)

	quote
		if false
		$([esc(:($(Symbol("#py", s)) = 1))  for s in writes]...)
		$([esc(:($(Symbol("#py", s))))  for s in reads]...)
		end
		@custom_py_str($(str))
	end
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Pkg = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PyCall = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"

[compat]
PlutoUI = "~0.7.16"
PyCall = "~1.92.3"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[Conda]]
deps = ["JSON", "VersionParsing"]
git-tree-sha1 = "299304989a5e6473d985212c28928899c74e9421"
uuid = "8f4d0f93-b110-5947-807f-2305c1781a2d"
version = "1.5.2"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[HypertextLiteral]]
git-tree-sha1 = "f6532909bf3d40b308a0f360b6a0e626c0e263a8"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.1"

[[IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[LinearAlgebra]]
deps = ["Libdl"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "5a5bc6bf062f0f95e62d0fe0a2d99699fed82dd9"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.8"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "98f59ff3639b3d9485a03a72f3ab35bab9465720"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.0.6"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PlutoUI]]
deps = ["Base64", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "4c8a7d080daca18545c56f1cac28710c362478f3"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.16"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[PyCall]]
deps = ["Conda", "Dates", "Libdl", "LinearAlgebra", "MacroTools", "Serialization", "VersionParsing"]
git-tree-sha1 = "169bb8ea6b1b143c5cf57df6d34d022a7b60c6db"
uuid = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"
version = "1.92.3"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[VersionParsing]]
git-tree-sha1 = "80229be1f670524750d905f8fc8148e5a8c4537f"
uuid = "81def892-9a0e-5fdd-b105-ffc91e053289"
version = "1.2.0"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╟─e07e4a47-a3cc-4ca4-a946-29e7df33ec6d
# ╠═73c3f448-be7d-49b7-9e39-18c3a08feb01
# ╠═f93f0eef-bb0c-45ee-a080-e8eeb6611176
# ╠═f4d3b313-1c8c-4de1-b5bd-592cb1112068
# ╠═dd20f208-0e39-4255-b35a-a8189986a165
# ╠═5dc1c311-1004-4056-b0a9-06622546486e
# ╠═6a35c5b8-2ce0-11ec-3a8c-b5a25bab9f9b
# ╠═8e0722dc-6a3d-4cb3-ac8e-c527f123d0a7
# ╠═12814f02-7e90-401a-9573-5c6b2f8067ae
# ╠═e8873c23-139d-41bc-be35-ebd636e48aee
# ╠═005b40d9-bd89-4491-9807-d33a6c674b75
# ╠═b59d932b-6425-47c2-a67d-208113bc8b7b
# ╠═6449e96f-19ce-4100-8b35-56113bc24b7d
# ╠═d9bc5dc1-67b6-47c6-9592-3b474ec451a0
# ╠═71ca495d-39ad-4d52-94a5-d4248679ce1e
# ╠═ab92a31d-1ef4-427f-b1c7-fa2790278a14
# ╠═21199966-adc3-498e-87ae-62333810efb5
# ╠═fdd2e0ae-7ac9-4da7-9bfb-41d7cf76296b
# ╠═56fcc0c2-0ce0-445b-b602-6525bab173b3
# ╠═a1ada27d-8a1a-453a-ace7-ae07b68ad42a
# ╠═fb3fb09d-1ba7-431e-aba2-f832d259075a
# ╠═216e88b3-82cb-4d74-aae4-c21791980ac2
# ╠═56a3a022-6ed3-47d8-8d62-ce4ead5ca026
# ╠═7576c6f6-3fc8-453a-b4c8-fe0c53b9ed7e
# ╠═5c432b4e-60e0-4288-8d5a-42e364ce8d16
# ╠═5f5ab869-c551-42d3-9325-86ecdc424c9b
# ╠═d3fe9870-ac9d-4871-b8cc-1361a446b0a5
# ╠═688c93e7-b50f-4bb7-ab23-5686fd8ffb18
# ╠═b9903477-5070-43eb-82a9-8b750f79c8fa
# ╟─600344b6-ff43-431b-b858-2bf30e93d938
# ╟─d74aed51-9542-47aa-8c3d-fb634c1a0212
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
