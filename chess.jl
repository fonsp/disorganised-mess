### A Pluto.jl notebook ###
# v0.15.0

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

# ╔═╡ c1c40fba-9988-11eb-2e8d-e35c53434bc5
using Chess

# ╔═╡ 0d8805a6-52b7-4805-a516-131aad17e9ad
using PlutoUI

# ╔═╡ 3782cae1-e142-4812-9570-ec30298d70d2
using HypertextLiteral

# ╔═╡ 740b374f-5ec8-45ae-8281-67cfa0f941c9
html"""
<video src="https://user-images.githubusercontent.com/6933510/114252768-43bd4e00-99a7-11eb-85a5-7734695f8fdb.mov" data-canonical-src="https://user-images.githubusercontent.com/6933510/114252768-43bd4e00-99a7-11eb-85a5-7734695f8fdb.mov" controls="controls" muted="muted" class="d-block rounded-bottom-2 width-fit" style="max-height:640px;">

  </video>
"""

# ╔═╡ a069a217-a136-424a-8445-7a1a30d051d2
startboard()

# ╔═╡ 1a2f66a5-2ec5-408b-9d4f-c71483e029f6
domove(startboard(), "e4") |> moves

# ╔═╡ 2ea956e4-be0c-4acb-9f7c-d5e0dbf32899
Base.:(!)(p::PieceColor) = p === BLACK ? WHITE : BLACK

# ╔═╡ 71ccaeeb-628a-4e35-9890-4813f00eabba
function random_result()
	board = startboard()
	while (next_moves = moves(board); !isempty(next_moves))
		choice = rand(next_moves)
		board = domove(board, choice)
	end
	board
end

# ╔═╡ 03f21ea2-e224-461d-b602-479e6e644dca
function random_game()
	result = []
	board = startboard()
	while (next_moves = moves(board); !isempty(next_moves))
		choice = rand(next_moves)
		board = domove(board, choice)
		push!(result, board)
	end
	result
end

# ╔═╡ 60391e7f-d78b-4040-b94e-1b92691ed81b
function try_until_result(f::Function, args...)
	try
		f(args...)
	catch
		try_until_result(f, args...)
	end
end

# ╔═╡ d3b54370-fd6e-4acb-85ed-32f806965b82
xs = try_until_result(random_game)

# ╔═╡ 8425b1bd-a281-42ba-80b8-30d0d1707793
@bind tick Slider(1:length(xs); show_value=true)

# ╔═╡ 12683363-3b9d-44c4-b573-f3798abd4835
b = xs[tick]

# ╔═╡ e2200f0e-050b-4f66-93f8-e357f0907f1b
if ischeckmate(b)
	md" $(!sidetomove(b)) wins"
elseif isstalemate(b)
	"stalemate"
end

# ╔═╡ 416ab2a6-12b6-456f-9565-cce9f8fb8cef
pieces(xs[tick], BLACK) |> squarecount

# ╔═╡ fb499ce6-0df2-48ca-90e6-f269b92735f9
pieces(xs[tick], WHITE) |> squarecount

# ╔═╡ 55a9aea3-3897-409d-99fd-d4ff9e967179
x = try_until_result(random_result)

# ╔═╡ 27bb80a7-4a5b-4071-98d8-6df642adc29b
ischeckmate(x)

# ╔═╡ 441e2468-8ea9-4d71-a2f1-0496754df7e1
isstalemate(x)

# ╔═╡ 2f2c770b-d32f-48df-92fa-74efd64a0f4a
md"""
# Chess move input
"""

# ╔═╡ c3c48796-b88e-47d3-beda-ac1ef65629f2
islegal(b::Board, m::Move) = m ∈ moves(b)

# ╔═╡ cfbc94d5-cd64-4816-8166-f66d499087a1
your_move_board = try_until_result(random_game)[end-20]

# ╔═╡ 3f7d5116-3ab4-4f83-8079-84d1173297b0
md"""
### Make a move!
"""

# ╔═╡ ffcf5ada-2e68-4962-96e3-2e4392573bd4
s = squarefromstring

# ╔═╡ e6367dde-e7bc-4bff-87c5-e667afce9085
board_input(b=startboard()) = @htl("""
<div>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/cm-chessboard@3.10.6/styles/cm-chessboard.css"/>

<script id="this">
const div = currentScript.parentElement

const {INPUT_EVENT_TYPE, COLOR, Chessboard} = await import("https://cdn.jsdelivr.net/npm/cm-chessboard@3.10.6/src/cm-chessboard/Chessboard.js")

function inputHandler(event) {
    if (event.type === INPUT_EVENT_TYPE.moveDone) {
        const move = {from: event.squareFrom, to: event.squareTo}
    	div.value = move
		div.dispatchEvent(new CustomEvent("input"))
        
    } else {
        return true
    }
}
	
const board_div = html`<div id="board" style="max-width: 300px;">
</div>`
	
const board = new Chessboard(board_div, {
    position: $(repr(fen(b))),
    sprite: {url: "https://cdn.jsdelivr.net/npm/cm-chessboard@3.10.6/assets/images/chessboard-sprite-staunty.svg"},
    orientation: COLOR.white
})
board.enableMoveInput(inputHandler, COLOR.white)
	
	return board_div
</script>
</div>
""")

# ╔═╡ 9e9f1c92-2e47-4cf8-a7b9-2441c12f0cd5
@bind next_move_raw board_input(your_move_board)

# ╔═╡ 98dec590-430c-4c41-8f7f-c35b7f342f49
next_move_raw

# ╔═╡ 6df84438-40d5-43e4-bf8a-80fb58210b88
next_move = Move(s(next_move_raw["from"]), s(next_move_raw["to"]))

# ╔═╡ 941eb734-cc1b-464f-8b06-aae85383f060
islegal(your_move_board, next_move)

# ╔═╡ f88f071b-e37a-4cf7-bc7e-bc02975f04de
domove(your_move_board, next_move)

# ╔═╡ 3e9b22dc-d89b-4ea8-891a-7c938db8bc18
md"""
### Let's play a game
"""

# ╔═╡ 29763e41-b813-40c6-bee2-da9282c28db1
board = Ref(startboard())

# ╔═╡ 2616f39c-fd94-46d0-b57e-8c6bc068a362
function f(move_raw)
	
	if move_raw !== missing
		move = Move(s(move_raw["from"]), s(move_raw["to"]))
		if islegal(board[], move)
			# do your move for white
			board[] = domove(board[], move)
			
			# do random move for black
			board[] = domove(board[], rand(moves(board[])))
		end
	end
	
	
	board_input(board[])
end

# ╔═╡ 3458a4c8-f53d-417f-9260-b9ae8649eeae
begin
	default_usage_error = :(error("Example usage:\n\n@intially [1,2] @bind x f(x)\n"))
	
	macro initially(::Any)
		default_usage_error
	end
	
	macro initially(default, bind_expr::Expr)
		if bind_expr.head != :macrocall || bind_expr.args[1] != Symbol("@bind")
			return default_usage_error
		end
		
		# warn if the first argument is a @bind
		if default isa Expr && default.head == :macrocall && default.args[1] == Symbol("@bind")
			return default_usage_error
		end
			
		esc(intially_function(default, bind_expr))
	end
	
	
	function intially_function(default, bind_expr)
		sym = bind_expr.args[3]
		@gensym setval bond

		quote
			if !@isdefined($sym)
				$sym = $default
			end

			$setval = $sym


			$bond = @bind $sym $(bind_expr.args[4])
			PlutoRunner.Bond

			if $sym isa Missing
				$sym = $setval
			end

			$bond
		end
	end
end

# ╔═╡ c83c4b22-ec6b-49f6-b9f4-d7bf09c00057
@initially missing @bind move_raw f(move_raw)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Chess = "717200cc-f167-4fd3-b4bf-b5e480529844"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
Chess = "^0.5.0"
HypertextLiteral = "^0.6.0"
PlutoUI = "^0.7.6"
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

[[BinaryProvider]]
deps = ["Libdl", "Logging", "SHA"]
git-tree-sha1 = "ecdec412a9abc8db54c0efc5548c64dfce072058"
uuid = "b99e7846-7c00-51b0-8f62-c81ae34c0232"
version = "0.5.10"

[[Chess]]
deps = ["Crayons", "Dates", "DefaultApplication", "Hiccup", "JSON", "Printf", "Random", "SQLite", "StaticArrays", "StatsBase", "UUIDs"]
git-tree-sha1 = "3349eeb4c18d104304aaf57ddd4d3d510949ee69"
uuid = "717200cc-f167-4fd3-b4bf-b5e480529844"
version = "0.5.0"

[[Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "ac4132ad78082518ec2037ae5770b6e796f7f956"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.27.0"

[[Crayons]]
git-tree-sha1 = "3f71217b538d7aaee0b69ab47d9b7724ca8afa0d"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.0.4"

[[DBInterface]]
git-tree-sha1 = "441a377eb7f994cd454b7c45f29f911ce0d42ce0"
uuid = "a10d1c49-ce27-4219-8d33-6db1a4562965"
version = "2.4.0"

[[DataAPI]]
git-tree-sha1 = "dfb3b7e89e395be1e25c2ad6d7690dc29cc53b1d"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.6.0"

[[DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "4437b64df1e0adccc3e5d1adbc3ac741095e4677"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.9"

[[DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[DefaultApplication]]
deps = ["InteractiveUtils"]
git-tree-sha1 = "fc2b7122761b22c87fec8bf2ea4dc4563d9f8c24"
uuid = "3f0dd361-4fe0-5fc6-8523-80b14ec94d85"
version = "1.0.0"

[[DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[Hiccup]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "6187bb2d5fcbb2007c39e7ac53308b0d371124bd"
uuid = "9fb69e20-1954-56bb-a84f-559cc56a8ff7"
version = "0.2.2"

[[HypertextLiteral]]
git-tree-sha1 = "bc09b8d183505e128545c2a3b00cae5e5ea89c52"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.6.0"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[JLLWrappers]]
git-tree-sha1 = "a431f5f2ca3f4feef3bd7a5e94b8b8d4f2f647a0"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.2.0"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "81690084b6198a2e1da36fcfda16eeca9f9f24e4"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.1"

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
git-tree-sha1 = "6a8a2a625ab0dea913aba95c11370589e0239ff0"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.6"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f8c673ccc215eb50fcadb285f522420e29e69e1c"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "0.4.5"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[OrderedCollections]]
git-tree-sha1 = "4fa2ba51070ec13fcc7517db714445b4ab986bdf"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.0"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "c8abc88faa3f7a3950832ac5d6e690881590d6dc"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "1.1.0"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PlutoUI]]
deps = ["Base64", "Dates", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "Suppressor"]
git-tree-sha1 = "dc373be1453f31adf02f461db61abcb6a347a1c0"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.6"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[Reexport]]
git-tree-sha1 = "57d8440b0c7d98fc4f889e478e80f268d534c9d5"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.0.0"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[SQLite]]
deps = ["BinaryProvider", "DBInterface", "Dates", "Libdl", "Random", "SQLite_jll", "Serialization", "Tables", "Test", "WeakRefStrings"]
git-tree-sha1 = "97261d38a26415048ce87f49a7a20902aa047836"
uuid = "0aa819cd-b072-5ff4-a722-6bc24af294d9"
version = "1.1.4"

[[SQLite_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "30c4dc94e2a00f4f02ea039df36067b32e187f3c"
uuid = "76ed43ae-9a5d-5a62-8c75-30186b810ce8"
version = "3.34.0+0"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SortingAlgorithms]]
deps = ["DataStructures", "Random", "Test"]
git-tree-sha1 = "03f5898c9959f8115e30bc7226ada7d0df554ddd"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "0.3.1"

[[SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "da4cf579416c81994afd6322365d00916c79b8ae"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "0.12.5"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics"]
git-tree-sha1 = "4bc58880426274277a066de306ef19ecc22a6863"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.5"

[[Suppressor]]
git-tree-sha1 = "a819d77f31f83e5792a76081eee1ea6342ab8787"
uuid = "fd094767-a336-5f1f-9728-57cf17d0bbfb"
version = "0.2.0"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "TableTraits", "Test"]
git-tree-sha1 = "a9ff3dfec713c6677af435d6a6d65f9744feef67"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.4.1"

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

[[WeakRefStrings]]
deps = ["DataAPI", "Random", "Test"]
git-tree-sha1 = "28807f85197eaad3cbd2330386fac1dcb9e7e11d"
uuid = "ea10d353-3f73-51f8-a26c-33c1cb351aa5"
version = "0.6.2"

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
# ╠═c1c40fba-9988-11eb-2e8d-e35c53434bc5
# ╟─740b374f-5ec8-45ae-8281-67cfa0f941c9
# ╠═a069a217-a136-424a-8445-7a1a30d051d2
# ╠═1a2f66a5-2ec5-408b-9d4f-c71483e029f6
# ╠═0d8805a6-52b7-4805-a516-131aad17e9ad
# ╠═8425b1bd-a281-42ba-80b8-30d0d1707793
# ╠═12683363-3b9d-44c4-b573-f3798abd4835
# ╠═416ab2a6-12b6-456f-9565-cce9f8fb8cef
# ╠═fb499ce6-0df2-48ca-90e6-f269b92735f9
# ╠═e2200f0e-050b-4f66-93f8-e357f0907f1b
# ╠═2ea956e4-be0c-4acb-9f7c-d5e0dbf32899
# ╠═d3b54370-fd6e-4acb-85ed-32f806965b82
# ╠═55a9aea3-3897-409d-99fd-d4ff9e967179
# ╠═27bb80a7-4a5b-4071-98d8-6df642adc29b
# ╠═441e2468-8ea9-4d71-a2f1-0496754df7e1
# ╠═71ccaeeb-628a-4e35-9890-4813f00eabba
# ╠═03f21ea2-e224-461d-b602-479e6e644dca
# ╠═60391e7f-d78b-4040-b94e-1b92691ed81b
# ╟─2f2c770b-d32f-48df-92fa-74efd64a0f4a
# ╠═c3c48796-b88e-47d3-beda-ac1ef65629f2
# ╠═cfbc94d5-cd64-4816-8166-f66d499087a1
# ╟─3f7d5116-3ab4-4f83-8079-84d1173297b0
# ╠═9e9f1c92-2e47-4cf8-a7b9-2441c12f0cd5
# ╠═98dec590-430c-4c41-8f7f-c35b7f342f49
# ╠═ffcf5ada-2e68-4962-96e3-2e4392573bd4
# ╠═6df84438-40d5-43e4-bf8a-80fb58210b88
# ╠═941eb734-cc1b-464f-8b06-aae85383f060
# ╠═f88f071b-e37a-4cf7-bc7e-bc02975f04de
# ╠═3782cae1-e142-4812-9570-ec30298d70d2
# ╠═e6367dde-e7bc-4bff-87c5-e667afce9085
# ╟─3e9b22dc-d89b-4ea8-891a-7c938db8bc18
# ╠═29763e41-b813-40c6-bee2-da9282c28db1
# ╠═c83c4b22-ec6b-49f6-b9f4-d7bf09c00057
# ╠═2616f39c-fd94-46d0-b57e-8c6bc068a362
# ╟─3458a4c8-f53d-417f-9260-b9ae8649eeae
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
