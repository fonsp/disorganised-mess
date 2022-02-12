### A Pluto.jl notebook ###
# v0.17.3

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

# ╔═╡ 8b2c1584-5872-11ec-23c8-eba6200f8004
using PlutoTest

# ╔═╡ e37c7d81-544e-463d-a6f6-84577d9a9f49
using PlutoUI

# ╔═╡ 58e926a5-9b3a-45d3-95df-6af4655b29db
function ends_with_semicolon_original(line::AbstractString)
    match = findlast(isequal(';'), line)::Union{Nothing,Int}
    if match !== nothing
        # state for comment parser, assuming that the `;` isn't in a string or comment
        # so input like ";#" will still thwart this to give the wrong (anti-conservative) answer
        comment = false
        comment_start = false
        comment_close = false
        comment_multi = 0
        for c in line[(match + 1):end]
            if comment_multi > 0
                # handle nested multi-line comments
                if comment_close && c == '#'
                    comment_close = false
                    comment_multi -= 1
                elseif comment_start && c == '='
                    comment_start = false
                    comment_multi += 1
                else
                    comment_start = (c == '#')
                    comment_close = (c == '=')
                end
            elseif comment
                # handle line comments
                if c == '\r' || c == '\n'
                    comment = false
                end
            elseif comment_start
                # see what kind of comment this is
                comment_start = false
                if c == '='
                    comment_multi = 1
                else
                    comment = true
                end
            elseif c == '#'
                # start handling for a comment
                comment_start = true
            else
                # outside of a comment, encountering anything but whitespace
                # means the semi-colon was internal to the expression
                isspace(c) || return false
            end
        end
        return true
    end
    return false
end

# ╔═╡ 1e8406d0-f4a8-4269-ab37-60b87c3349dc
begin

let matchend = Dict("\"" => r"\"", "\"\"\"" => r"\"\"\"", "'" => r"'",
    "`" => r"`", "```" => r"```", "#" => r"$"m, "#=" => r"=#|#=")
    global _rm_strings_and_comments
    function _rm_strings_and_comments(code::Union{String,SubString{String}})
        buf = IOBuffer(sizehint = sizeof(code))
        pos = 1
        while true
            i = findnext(r"\"(?!\"\")|\"\"\"|'|`(?!``)|```|#(?!=)|#=", code, pos)
            isnothing(i) && break
            match = SubString(code, i)
            j = findnext(matchend[match]::Regex, code, nextind(code, last(i)))
            if match == "#=" # possibly nested
                nested = 1
                while j !== nothing
                    nested += SubString(code, j) == "#=" ? +1 : -1
                    iszero(nested) && break
                    j = findnext(r"=#|#=", code, nextind(code, last(j)))
                end
            elseif match[1] != '#' # quote match: check non-escaped
                while j !== nothing
                    notbackslash = findprev(!=('\\'), code, prevind(code, first(j)))::Int
                    isodd(first(j) - notbackslash) && break # not escaped
                    j = findnext(matchend[match]::Regex, code, nextind(code, first(j)))
                end
            end
            isnothing(j) && break
            if match[1] == '#'
                print(buf, SubString(code, pos, prevind(code, first(i))))
            else
                print(buf, SubString(code, pos, last(i)), ' ', SubString(code, j))
            end
            pos = nextind(code, last(j))
        end
        print(buf, SubString(code, pos, lastindex(code)))
        return String(take!(buf))
    end
end
ends_with_semicolon2(code::Union{String,SubString{String}}) =
    contains(_rm_strings_and_comments(code), r";\s*$")
ends_with_semicolon2(code::AbstractString) = ends_with_semicolon2(String(code))
end

# ╔═╡ 52684354-a517-47cf-8449-d401e0deae92
function _remove_strings_and_comments(s)
	# remove string literals
	# """hello"""
	s = replace(s, r"\"\"\".*?[^\\]\"\"\""s => "julia")
	# "hello"
	s = replace(s, r"\"(\\\\\"|[^\"])*\"" => "philip")
	# ```hello```
	s = replace(s, r"```.*?```"s => "the")
	# `hello`
	s = replace(s, r"`(\\`|[^`])*`" => "corgi")

	# remove multiline #= comments =#
	# s = replace(s, r"\#=(?:[^(\#=)(=\#)]+|(?R))*+=\#" => "")
	s = replace(s, r"\#=(?:([^\#\=]|\=(?!\#)|\#(?!\=))+|(?R))*+=\#" => "")

	# remove single line # comments
	s = replace(s, r"#.*" => "")
end

# ╔═╡ a314f148-9a68-4dee-8f81-9ad8fc79fc43
function ends_with_semicolon_new(line::AbstractString)
	stripped_line = _remove_strings_and_comments(line)
    match = findlast(isequal(';'), stripped_line)::Union{Nothing,Int}
    
	return match !== nothing && all(isspace, stripped_line[(match + 1):end])
end

# ╔═╡ e969b154-1dc6-46c4-b5b2-a3ecfdc887f0
 rr = r"\"(\\\\\"|[^\"])*\""

# ╔═╡ 5ffcd562-e2ec-43ed-80d8-d7909012a33a
r"\"(\\\\\"|[^\"])*\"".pattern |> Text

# ╔═╡ ffc26038-eb37-49e5-805d-5a3b46c34a05
ss = """
 "asfd" ee " a\\"b " c
	
\"\"\"wow "asdf \"\"\"
(e"f()= 1; # a " + " no" eee)
    r"  \\" ff"f
    r` \\` `f e``e
	"""

# ╔═╡ f550da0a-c8ab-4f42-a4a1-464ecd5a0cef
eachmatch(rr, ss) |> collect

# ╔═╡ 04a7f6ed-000b-4dd4-952e-d369708ac84f
Text(ss)

# ╔═╡ 0cd9f900-d452-46e8-bbe4-9a98825bfd36
_remove_strings_and_comments(ss) |> Text

# ╔═╡ a29f0b77-49b4-486f-85a5-efd12129d93a
_remove_strings_and_comments("""
""\"
asdf
""\"
""") |> Text

# ╔═╡ 9a06b4e2-3b31-4b12-9859-4eca489dea61
_remove_strings_and_comments("""
#=#=  #
asdf
=#b=#
""") |> Text

# ╔═╡ 75a9ac0c-1e8c-4795-8d69-597cf3c532e0
_remove_strings_and_comments("""
a; #=#=#
=#b=#
# test
#=
foobar
=##bazbax
""") |> Text

# ╔═╡ 30c04220-d5dc-439d-8d3d-32be34ce919b
_remove_strings_and_comments("""

" # " dont remove me!

leave me # im gone

fons #= van #= der =# plas =# juju

""") |> Text

# ╔═╡ e56da636-f0d0-48cd-b7e7-9e6dcf8747ef
" asd ` " , ` ""\` `

# ╔═╡ 8203bc66-78ab-4db5-a39a-503e9d1495eb
md"""
## Before / after
Use function: $(@bind ends_with_semicolon Select([ends_with_semicolon_original, ends_with_semicolon_new, ends_with_semicolon2]))
"""

# ╔═╡ 092b4681-ae6f-4156-880d-58eb2f1abc3a
md"""
## New test cases
"""

# ╔═╡ 94f0530f-c9e5-4175-8c77-d89e6693ef23
begin
	ss # """
	ss; # """ 
end

# ╔═╡ 689172dd-9e26-4a2b-b362-e830691c9600
let
	"foo # \"\"\"\n bar; # \"\"\" " |> Text
end

# ╔═╡ cbd2e69c-a589-4a0d-b59e-ce292ac88dd6
@test ends_with_semicolon("""
	ss # ""\"
	ss; # ""\" 
""")

# ╔═╡ 94187d97-12c0-4cb4-8dcd-8494f0a99b27
@test ends_with_semicolon("f()= 1; # a ; 2")

# ╔═╡ 6e57de78-d9d3-45dd-a35f-fea65f5f9c78
@test !ends_with_semicolon("f()= 1; \"asdf\"")

# ╔═╡ 28b76529-02f2-4236-afa4-2bd395e116e8
@test !ends_with_semicolon("""
";"
""")

# ╔═╡ dbc0ec74-4cd9-4490-aace-a5190c417bed
@test !ends_with_semicolon("""
";" # asdf
""")

# ╔═╡ a542c1f0-e2ab-4894-ad0e-ca8ba5563d87
@test ends_with_semicolon(
	"f()= 1; # a"
)

# ╔═╡ 7b51546f-1b95-4f9f-ba6e-b054df5bcb85
@test !ends_with_semicolon(
	"""
	("f()= 1; # a")
	"""
)

# ╔═╡ 546bf639-efb0-4d7e-8e5c-dcf29b09de43
@test !ends_with_semicolon(
	"""
	"f()= 1; # a"
	"""
)

# ╔═╡ 630b07ca-13b8-42ac-b095-723fdf303703
@test ends_with_semicolon("f()= 1;")

# ╔═╡ c2facbc9-d5b0-4b43-9c22-6ebe70bc1bef
@test !ends_with_semicolon(
	"1;" * " #= =# 2"
)

# ╔═╡ a2201523-537f-4884-8b9a-396e3df3e94b
@test_nowarn ends_with_semicolon(
	"1;" * " #=# 2"
)

# ╔═╡ adf3404a-c691-4a0a-8c42-25cab39da17a
@test !ends_with_semicolon("a # asdf ;")

# ╔═╡ d192bf86-bb28-42f9-970c-7b7bd634cd67
@test !ends_with_semicolon("a # asdf ;")

# ╔═╡ ea5c44d9-4945-4e8a-ae49-f54c57fd85f7
@test ends_with_semicolon("""a * "#" ;""")

# ╔═╡ a7734b0d-a86d-4254-a83e-e774dd097f93
@test !ends_with_semicolon("\"\\\";\"#\"")

# ╔═╡ c840f61e-0e11-4008-9f58-4769bf487461
"\";"#"

# ╔═╡ 55764fc5-f352-4505-998a-797eda800946
Text(
	"\"\\\";\"#\""
)

# ╔═╡ 08109975-4e0f-46b7-9b0c-d095cd1db015
@test ends_with_semicolon(
	"\"\\\\\";#\""
)

# ╔═╡ 164d3cb8-a04c-4f2d-bd0e-27c836be3677
@test ends_with_semicolon(
	"é; #é \"é\""
)

# ╔═╡ 292f5fff-7209-420d-9944-0a833ac56fbb


# ╔═╡ 5d4c0aae-f824-4d0b-a91c-d477c1aa9ee7
begin
	@test ends_with_semicolon("""1;\n#text\n""")
end

# ╔═╡ 4f6c6f25-2518-4dfc-8815-bf9858dd18d2
@test ends_with_semicolon("a; #=#=# =# =#\n")

# ╔═╡ a407626a-06e8-457a-a991-01f9bcc747bd
@test !ends_with_semicolon("begin\na;\nb;\nend")

# ╔═╡ 631ad34e-fa27-4b5c-a762-8da2189f008e
@test !ends_with_semicolon("begin\na; #=#=#\n=#b=#\nend")

# ╔═╡ b158788d-837a-4ccb-97e4-9d6011a691a0
@test ends_with_semicolon("\na; #=#=#\n=#b=#\n# test\n#=\nfoobar\n=##bazbax\n")

# ╔═╡ ca7a060f-24fd-4504-b3ee-f51f75e89f12
md"""
## Old test cases
"""

# ╔═╡ c1bac8e3-631b-48c7-80e8-413cf40e934b
@test !ends_with_semicolon("")

# ╔═╡ 07472814-6d8c-45f4-bf01-31c8ba3fe97e
@test ends_with_semicolon(";")

# ╔═╡ 90132005-b2f5-4a32-809a-407334b1f873
@test !ends_with_semicolon("a")

# ╔═╡ edb842c2-4697-4b40-ad66-14eaae1a99c7
@test ends_with_semicolon("1;")

# ╔═╡ cac00e8d-2271-44df-ba41-02325e861891
@test ends_with_semicolon("1;\n")

# ╔═╡ 1945cf49-a3a5-4d9a-8a32-654422f3b63f
@test ends_with_semicolon("1;\r")

# ╔═╡ 2a538b06-95db-4eb0-9568-4f388cae83b1
@test ends_with_semicolon("1;\r\n   \t\f")

# ╔═╡ 51212623-5939-40f0-a38b-9ea05b0e31d0
@test ends_with_semicolon("1;#text\n")

# ╔═╡ 2ed1c543-0822-42c2-9835-d42fb3bdb87d
@test ends_with_semicolon("a; #=#=# =# =#\n")

# ╔═╡ ed07c508-7749-4f44-86af-10a7614b7546
@test !ends_with_semicolon("begin\na;\nb;\nend")

# ╔═╡ 37b989c2-3189-4508-b27c-fb477865f883
@test !ends_with_semicolon("begin\na; #=#=#\n=#b=#\nend")

# ╔═╡ 602f4fcc-0360-4e65-8c1e-26901c6fa172
@test ends_with_semicolon("\na; #=#=#\n=#b=#\n# test\n#=\nfoobar\n=##bazbax\n")

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoTest = "cb4044da-4d16-4ffa-a6a3-8cad7f73ebdc"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoTest = "~0.2.0"
PlutoUI = "~0.7.21"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.0"
manifest_format = "2.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "abb72771fd8895a7ebd83d5632dc4b989b022b5b"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.2"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "ae4bbcadb2906ccc085cf52ac286dc1377dceccc"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.1.2"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlutoTest]]
deps = ["HypertextLiteral", "InteractiveUtils", "Markdown", "Test"]
git-tree-sha1 = "92b8ae1eee37c1b8f70d3a8fb6c3f2d81809a1c5"
uuid = "cb4044da-4d16-4ffa-a6a3-8cad7f73ebdc"
version = "0.2.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "b68904528fd538f1cb6a3fbc44d2abdc498f9e8e"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.21"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╠═8b2c1584-5872-11ec-23c8-eba6200f8004
# ╠═e37c7d81-544e-463d-a6f6-84577d9a9f49
# ╟─58e926a5-9b3a-45d3-95df-6af4655b29db
# ╠═1e8406d0-f4a8-4269-ab37-60b87c3349dc
# ╠═a314f148-9a68-4dee-8f81-9ad8fc79fc43
# ╠═52684354-a517-47cf-8449-d401e0deae92
# ╠═e969b154-1dc6-46c4-b5b2-a3ecfdc887f0
# ╠═5ffcd562-e2ec-43ed-80d8-d7909012a33a
# ╠═f550da0a-c8ab-4f42-a4a1-464ecd5a0cef
# ╠═04a7f6ed-000b-4dd4-952e-d369708ac84f
# ╠═ffc26038-eb37-49e5-805d-5a3b46c34a05
# ╟─0cd9f900-d452-46e8-bbe4-9a98825bfd36
# ╠═a29f0b77-49b4-486f-85a5-efd12129d93a
# ╠═9a06b4e2-3b31-4b12-9859-4eca489dea61
# ╠═75a9ac0c-1e8c-4795-8d69-597cf3c532e0
# ╠═30c04220-d5dc-439d-8d3d-32be34ce919b
# ╠═e56da636-f0d0-48cd-b7e7-9e6dcf8747ef
# ╟─8203bc66-78ab-4db5-a39a-503e9d1495eb
# ╟─092b4681-ae6f-4156-880d-58eb2f1abc3a
# ╠═94f0530f-c9e5-4175-8c77-d89e6693ef23
# ╠═689172dd-9e26-4a2b-b362-e830691c9600
# ╠═cbd2e69c-a589-4a0d-b59e-ce292ac88dd6
# ╠═94187d97-12c0-4cb4-8dcd-8494f0a99b27
# ╠═6e57de78-d9d3-45dd-a35f-fea65f5f9c78
# ╠═28b76529-02f2-4236-afa4-2bd395e116e8
# ╠═dbc0ec74-4cd9-4490-aace-a5190c417bed
# ╠═a542c1f0-e2ab-4894-ad0e-ca8ba5563d87
# ╠═7b51546f-1b95-4f9f-ba6e-b054df5bcb85
# ╠═546bf639-efb0-4d7e-8e5c-dcf29b09de43
# ╠═630b07ca-13b8-42ac-b095-723fdf303703
# ╠═c2facbc9-d5b0-4b43-9c22-6ebe70bc1bef
# ╠═a2201523-537f-4884-8b9a-396e3df3e94b
# ╠═adf3404a-c691-4a0a-8c42-25cab39da17a
# ╠═d192bf86-bb28-42f9-970c-7b7bd634cd67
# ╠═ea5c44d9-4945-4e8a-ae49-f54c57fd85f7
# ╠═a7734b0d-a86d-4254-a83e-e774dd097f93
# ╠═c840f61e-0e11-4008-9f58-4769bf487461
# ╠═55764fc5-f352-4505-998a-797eda800946
# ╠═08109975-4e0f-46b7-9b0c-d095cd1db015
# ╠═164d3cb8-a04c-4f2d-bd0e-27c836be3677
# ╠═292f5fff-7209-420d-9944-0a833ac56fbb
# ╠═5d4c0aae-f824-4d0b-a91c-d477c1aa9ee7
# ╠═4f6c6f25-2518-4dfc-8815-bf9858dd18d2
# ╠═a407626a-06e8-457a-a991-01f9bcc747bd
# ╠═631ad34e-fa27-4b5c-a762-8da2189f008e
# ╠═b158788d-837a-4ccb-97e4-9d6011a691a0
# ╟─ca7a060f-24fd-4504-b3ee-f51f75e89f12
# ╠═c1bac8e3-631b-48c7-80e8-413cf40e934b
# ╠═07472814-6d8c-45f4-bf01-31c8ba3fe97e
# ╠═90132005-b2f5-4a32-809a-407334b1f873
# ╠═edb842c2-4697-4b40-ad66-14eaae1a99c7
# ╠═cac00e8d-2271-44df-ba41-02325e861891
# ╠═1945cf49-a3a5-4d9a-8a32-654422f3b63f
# ╠═2a538b06-95db-4eb0-9568-4f388cae83b1
# ╠═51212623-5939-40f0-a38b-9ea05b0e31d0
# ╠═2ed1c543-0822-42c2-9835-d42fb3bdb87d
# ╠═ed07c508-7749-4f44-86af-10a7614b7546
# ╠═37b989c2-3189-4508-b27c-fb477865f883
# ╠═602f4fcc-0360-4e65-8c1e-26901c6fa172
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
