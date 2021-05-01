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

# ╔═╡ 00145d19-9a62-4343-89c8-c623688c5af6
using PlutoUI

# ╔═╡ a3c20927-9bc7-44b1-a970-e381d7466378
using JSON

# ╔═╡ 83652fde-9873-44a0-b10f-3db63d62e76f
using HypertextLiteral

# ╔═╡ 4c559bae-7bb8-4d90-9a17-4ad72a82a28c
using Plots

# ╔═╡ 1843f036-f003-4da8-8c91-4a8d25fab6ad
embed_display(@htl("""
		<script id=$(rand(UInt))>console.log(1233)</script>
		
		$(embed_display([1,2]))
		
		"""))

# ╔═╡ ca713dbc-29f6-498f-bd82-d0655a0fdc79
md"""
## Number 4 -- final attempt
"""

# ╔═╡ 4ae394de-098a-40ef-a01e-3d1b444e3d6d
begin
	
	struct EmbeddableDisplay4
	    x
	    script_id
	end
	
	function Base.show(io::IO, m::MIME"text/html", e::EmbeddableDisplay4)
	    body, mime = PlutoRunner.format_output_default(e.x, io)
		
		write(io, """
			<pluto-display></pluto-display>
	<script id=$(e.script_id)>
			
			const body = $(PlutoRunner.publish_to_js(body, e.script_id))
			const mime = "$(string(mime))"
			
			const create_new = this == null || this._mime !== mime
			
			// console.log(mime, this?._mime, this?._body, body, this?._body === body, create_new)


			const display = create_new ? currentScript.previousElementSibling : this //document.createElement("pluto-display") : this
			
			display.persist_js_state = true
			display.body = body
			display._body = body
			if(create_new) {
				display.mime = mime
				display._mime = mime
			}
			return display
	
	</script>
	
	""")
	end
end

# ╔═╡ 05392caf-a7a8-4d13-ba60-4d3abc3f45fb
aasdff = rand(50)

# ╔═╡ d568b1ef-61c4-40f6-be0b-7b07c5fcf27f

embed_display4(x) = EmbeddableDisplay4(x, rand('a':'z',16) |> join)

# ╔═╡ e93308d3-d1c9-4df1-b796-1bf6bc0ad0c2
embed_display4(aasdff) |> embed_display4 |> embed_display4 |> embed_display4

# ╔═╡ 0b8f60e4-06f3-4e44-8a1c-d1dc3a6765ec
md"""
# Number 3 -- preact
"""

# ╔═╡ c6d13e4e-f79c-4e26-9700-c64959ceb977
lkjasdfklj = 1233

# ╔═╡ 6718392f-42b5-4cad-ac3f-0eb78aaeabd4
begin
	
	struct EmbeddableDisplay3
	    x
	    script_id
	end
	
	function Base.show(io::IO, m::MIME"text/html", e::EmbeddableDisplay3)
	    body, mime = PlutoRunner.format_output_default(e.x, io)
		
		write(io, """
	<script type=module id=$(e.script_id)>
			
			const { html, render, Component, useEffect, useLayoutEffect, useState, useRef, useMemo, createContext, useContext, } = await import("../imports/Preact.js")
			
			const { OutputBody } = await import("./CellOutput.js")

			
	const node = this ?? document.createElement("span")
	
	const new_state = {
			body: $(PlutoRunner.publish_to_js(body, e.script_id)),
			mime: "$(string(mime))",
		}
			
	
	if(this == null){
			
        const App = () => {

            const [state, set_state] = useState(new_state)
            node.set_app_state = set_state
			
			const run_count = useRef(0)
			const persist_js_state = run_count.current > 0
			run_count.current++;

			return html`<\${OutputBody} mime=\${state.mime} body=\${state.body} persist_js_state=\${persist_js_state} />`
            
        }

        render(html`<\${App}/>`, node);
	
	} else {
			
		node.set_app_state(new_state)
	}
	return node
	
	</script>
	
	""")
	end
end

# ╔═╡ 9e898116-9a1b-4e2f-8918-da644cd093d7
zzz3 = 123

# ╔═╡ 6d836dbb-ff7e-47d2-9776-0c7d29232ff3

embed_display3(x) = EmbeddableDisplay3(x, rand('a':'z',16) |> join)

# ╔═╡ 82c96c07-6ab5-4e51-9013-a60668278215
begin
	
	struct EmbeddableDisplay2
	    x
	    script_id
	end
	
	function Base.show(io::IO, m::MIME"text/html", e::EmbeddableDisplay2)
	    body, mime = PlutoRunner.format_output_default(e.x, io)
		
		write(io, """
	<script id=$(e.script_id)>
			
			const body = $(PlutoRunner.publish_to_js(body, e.script_id))
			const mime = "$(string(mime))"
			
			console.log(body)
			
			
			const create_new = this == null || this._mime !== mime
			console.log(mime, this?._mime, this?._body, body, this?._body === body, create_new)

			const display = create_new ? document.createElement("pluto-display") : this
			
			display.body = body
			//display.body = {...body}
			//display.body = body
			display._body = body
			if(create_new) {
				display.mime = mime
				display._mime = mime
			}
			return display
	
	</script>
	
	""")
	end
end

# ╔═╡ 284b0354-a769-4f4f-ba38-247948a56060

embed_display2(x) = EmbeddableDisplay2(x, rand('a':'z',16) |> join)

# ╔═╡ fcd0ab05-1a37-4081-a811-cb1d44cb06d6
f = 121

# ╔═╡ 42a99efc-f9a5-46ad-aa9e-c4e59b0eb82e
dd = [[1,2],3]

# ╔═╡ 9eb79408-8936-4479-8ae6-bbb0b33f7f14
zzz = 123

# ╔═╡ b52db500-d730-4817-a1a1-d1d07b66abae
demo1(p) = p(rand(50))

# ╔═╡ 54223278-8197-4d64-b17e-68b006aa989d
demo1(embed_display3) |> embed_display3 |> embed_display3 |> embed_display3

# ╔═╡ 0d724791-35c3-4cf9-9e6d-fe888581ee7e
k = demo1(embed_display2)

# ╔═╡ dfc4e5b9-ed62-4de6-9f85-e4e6f197ed27
zzz; k

# ╔═╡ b0e196e4-5352-4255-bd46-f1a7b96e4504
embed_display([1,2])

# ╔═╡ 0fe7980e-0942-4619-aee2-db8f0f7d8f19
showhtml(r) = repr(MIME"text/html"(), r) |> Text

# ╔═╡ d4aa5432-7fbe-4f1b-9680-1bd7690deba1
PlutoRunner.format_output_default(rand(10))

# ╔═╡ 93db76ce-52f9-4fa2-8012-d0526264934b


# ╔═╡ 795ab04a-e2cc-4c71-bff4-5c325e0929c1
@bind z Slider(1:100)

# ╔═╡ a3203314-f59f-424e-bbf2-56c9274e4dae
data = rand(z)

# ╔═╡ e51e8a03-dabd-464e-be6c-88b6ae8cafe0


# ╔═╡ eba09f23-b1af-4679-847f-d8da793dab09
p = embed_display2

# ╔═╡ 1becdf87-f457-4384-a712-7009e8c466b5
p([1,2])

# ╔═╡ 5c601fc3-9bf7-47a5-8b18-71e711b76bfb
p(rand(20))

# ╔═╡ 07695e8a-fdcc-4cc6-8d12-8e658a5d5180
rand(20)

# ╔═╡ b7944093-6eb1-41b3-8f6b-096bd83a9315
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

# ╔═╡ 75c5b6c7-2705-4151-a28b-92522db7b592
Layout = ingredients(download("https://fonsp-disorganised-mess.netlify.app/Layout.jl"))

# ╔═╡ c5db97ab-67a1-48cc-832e-69ef687ca1f6
Layout.flex(p(data), p(data .* 10))

# ╔═╡ abd620ef-fd30-4adb-8681-a26267d21f6b
equal_container(x) = Layout.Div(x, Dict(
			"flex" => "1 1 0px",
			"overflow-x" => "auto",
		))

# ╔═╡ 8139f5ef-1d87-406d-b26b-e0baac01d104
hbox_even(elements...) = Layout.flex(equal_container.(elements)...)

# ╔═╡ 82ef7f5b-b780-4909-8b82-2c9c4f9dadd8
demo2(p) = let
	x = rand(f)
	
	hbox_even(p(x), p(plot(x)))
end

# ╔═╡ 88473efc-518d-42c9-8ccf-584f602442f3
asdf22 = demo2(embed_display4);

# ╔═╡ 1515f66d-4b8e-4c2a-9621-ce3c5978206b
asdf22

# ╔═╡ a3bb5a21-56fd-4c2e-aa3a-a73ec35fbaf2
demo23 = demo2(embed_display3);

# ╔═╡ d5faf98f-4451-415e-9641-04756d3b5146
lkjasdfklj; demo23

# ╔═╡ ce9dc208-bd02-4443-b3fc-d7e5cd5dd0d5
k3 = demo2(embed_display3)

# ╔═╡ c7d0bcb3-2446-435f-8d7e-7cd647184153
zzz3; k3

# ╔═╡ 15be5639-cb9b-4079-a849-f8c16ab77839
k3 |> embed_display3 |> embed_display3

# ╔═╡ 2cee8cb8-4418-4608-bf62-448d57d0b97e
r = demo2(embed_display2)

# ╔═╡ d255a558-d4ff-4382-a872-e4bd71e9f5a0
let
	x = rand(f)
	
	hbox_even(embed_display(x), embed_display(plot(x)))
end

# ╔═╡ 1ca695a7-04c7-4b40-b23d-0d4ef396fea2
let
	# id = "asdf"
	id = PlutoRunner.publish_object([1,2123,12,312323])
	
	@htl("""
	<script>
	
	const cell = currentScript.closest("pluto-cell")
	
	console.log(await cell.get_published_object($(JSON.json(id))))
	</script>
	""")
end

# ╔═╡ 12e2895c-b122-422d-a3f8-431765eacd5f
let
	# id = "asdf"
	id = PlutoRunner.publish_object([1,2,2,13,2,123,12,312323])
	
	@htl("""
	<script>
	
	const cell = currentScript.closest("pluto-cell")
	
	console.log(await cell.get_published_object($(JSON.json(id))))
	</script>
	""")
end

# ╔═╡ 3b0ee8e5-92c6-477a-bce8-f1c35b322c12
["asdf", "asdf"]

# ╔═╡ 0242daf4-90a8-428d-a763-55278a631131
"asdf"

# ╔═╡ 9eb7a189-596c-472a-88e5-9f446f75fb59
md"""

> asdf

asdf
"""

# ╔═╡ 916d5359-aa71-45be-a229-2df64a81396e
mm = md"""
hello

```
asdf
```

"""

# ╔═╡ 83a4079e-4880-4a0c-b11d-0368f89eaf7f
[mm, mm]

# ╔═╡ a8ac8fe2-9aa5-4602-8ccb-3a21d657750d
md"""
# Wow `code`

is `difficult` to **`typeset`**!
"""

# ╔═╡ e0763cbe-a683-11eb-08ee-45153d2d2144
html"""
<div>

<pluto-display></pluto-display>

<script>

const display = currentScript.parentElement.querySelector("pluto-display")

display.mime = "text/plain"
display.body = "alksjdlkjasdf"

const handle = setInterval(() => {
//display.body = Math.random()
}, 1000)

invalidation.then(() => clearInterval(handle))

</script>

</div>


"""

# ╔═╡ a420cdc0-d0d8-4ca8-be0e-a1abc61518db
html"""
<div>

asdfasdf

<pluto-display></pluto-display>

<script>

const display = currentScript.parentElement.querySelector("pluto-display")


const body = JSON.parse(atob("eyJwcmVmaXgiOiJBbnkiLCJlbGVtZW50cyI6W1sxLFsiOCIsInRleHQvcGxhaW4iXV0sWzIsWyIyIiwidGV4dC9wbGFpbiJdXSxbMyxbIjMiLCJ0ZXh0L3BsYWluIl1dLFs0LFt7InByZWZpeCI6IkludDY0IiwiZWxlbWVudHMiOltbMSxbIjQiLCJ0ZXh0L3BsYWluIl1dLFsyLFsiNSIsInRleHQvcGxhaW4iXV1dLCJ0eXBlIjoiQXJyYXkiLCJwcmVmaXhfc2hvcnQiOiIiLCJvYmplY3RpZCI6IjdkY2U4MDdkNWM3ZTg4M2QifSwiYXBwbGljYXRpb24vdm5kLnBsdXRvLnRyZWUrb2JqZWN0Il1dXSwidHlwZSI6IkFycmF5IiwicHJlZml4X3Nob3J0IjoiIiwib2JqZWN0aWQiOiJkZjRhYjNkYzdjNzJlZTJkIn0="))


display.body = body
display.mime = "application/vnd.pluto.tree+object"

</script>

</div>


"""

# ╔═╡ 17f109aa-72d3-4d1c-a5a4-b0baeb9cc162
bx = @bind x html"<input type=range>"

# ╔═╡ 419e5f92-c80b-45af-81c6-caed1dbffacf
x

# ╔═╡ 2afe2875-aedc-498f-936a-fb6ec494869d
pluto_display1(pluto_display1(bx))

# ╔═╡ 822b5158-7071-4948-9a75-10b0ba4f8dee
pluto_display1([1,2])

# ╔═╡ c2dba11c-abf7-4dd7-af51-f8e68096cb57
md"""
# asdf

$(pluto_display1([8,9]))

WOW
"""

# ╔═╡ 177c8658-7064-4f7f-8675-2d0a7abb2615
[
	pluto_display1([1,2]),
	123,
	"asdf",
	md"""
	# asdf
	
	$(pluto_display1([8,9]))
	
	1
	
	WOW
	""",
	p
	]

# ╔═╡ 98960733-cc37-42fe-87fa-a8a32b6bc731
[1,2] |> p |> p |> p

# ╔═╡ 3f69c74b-1653-4c2e-9cd1-498e94cefdca
function pluto_display2(x)
	body, mime = PlutoRunner.format_output_default(x)
	
	HTML("""
<pluto-display></pluto-display>

<script>

const display = currentScript.previousElementSibling

display.body = $(PlutoRunner.publish_to_js(body))
display.mime = "$(string(mime))"

</script>

""")
end

# ╔═╡ ad47001a-f0b9-433d-819c-e4f52c412a35
coolplot = plot(1:10, 1:10)

# ╔═╡ a63add35-065b-4c8d-ac62-5f7fbbc587fe
[
	pluto_display2([1,2]),
	123,
	"asdf",
	md"""
	# asdf
	
	$(pluto_display2([8,9]))
	
	WOW
	""",
	coolplot
	]

# ╔═╡ 067dc2b9-76e0-44e0-b953-b4e0e121a00b


# ╔═╡ 5a587936-8189-4bad-8c69-62b5d5299958
pluto_display2([1,2,3])

# ╔═╡ 68389ed1-4d45-4af3-9fc1-7dbf4cda063a


# ╔═╡ e4c3539c-116c-4f96-930a-ffab18a87d37
JSON.lower(m::MIME) = JSON.lower(string(m))

# ╔═╡ fd5efe36-d78d-4279-8d9d-3d45c1f82bee
md"""

# Hello!

$(pluto_display([1,2,3]))

cool

"""

# ╔═╡ 7211e075-43e9-45a8-9dbf-aa57cf932c59
html"""
<pluto-display mime="text/plain" body="hello!!" ></pluto-display>
"""

# ╔═╡ 830ad154-6d6f-4f4b-9e46-9a316605140a
[8,2,3,[4,5]]

# ╔═╡ Cell order:
# ╠═1843f036-f003-4da8-8c91-4a8d25fab6ad
# ╠═ca713dbc-29f6-498f-bd82-d0655a0fdc79
# ╠═4ae394de-098a-40ef-a01e-3d1b444e3d6d
# ╠═88473efc-518d-42c9-8ccf-584f602442f3
# ╠═1515f66d-4b8e-4c2a-9621-ce3c5978206b
# ╠═05392caf-a7a8-4d13-ba60-4d3abc3f45fb
# ╠═e93308d3-d1c9-4df1-b796-1bf6bc0ad0c2
# ╠═d568b1ef-61c4-40f6-be0b-7b07c5fcf27f
# ╟─0b8f60e4-06f3-4e44-8a1c-d1dc3a6765ec
# ╠═a3bb5a21-56fd-4c2e-aa3a-a73ec35fbaf2
# ╠═54223278-8197-4d64-b17e-68b006aa989d
# ╠═d5faf98f-4451-415e-9641-04756d3b5146
# ╠═c6d13e4e-f79c-4e26-9700-c64959ceb977
# ╠═6718392f-42b5-4cad-ac3f-0eb78aaeabd4
# ╠═ce9dc208-bd02-4443-b3fc-d7e5cd5dd0d5
# ╠═c7d0bcb3-2446-435f-8d7e-7cd647184153
# ╠═15be5639-cb9b-4079-a849-f8c16ab77839
# ╠═9e898116-9a1b-4e2f-8918-da644cd093d7
# ╠═6d836dbb-ff7e-47d2-9776-0c7d29232ff3
# ╠═284b0354-a769-4f4f-ba38-247948a56060
# ╠═82c96c07-6ab5-4e51-9013-a60668278215
# ╠═fcd0ab05-1a37-4081-a811-cb1d44cb06d6
# ╠═42a99efc-f9a5-46ad-aa9e-c4e59b0eb82e
# ╠═0d724791-35c3-4cf9-9e6d-fe888581ee7e
# ╠═dfc4e5b9-ed62-4de6-9f85-e4e6f197ed27
# ╠═9eb79408-8936-4479-8ae6-bbb0b33f7f14
# ╠═b52db500-d730-4817-a1a1-d1d07b66abae
# ╠═2cee8cb8-4418-4608-bf62-448d57d0b97e
# ╠═82ef7f5b-b780-4909-8b82-2c9c4f9dadd8
# ╠═b0e196e4-5352-4255-bd46-f1a7b96e4504
# ╠═d255a558-d4ff-4382-a872-e4bd71e9f5a0
# ╠═0fe7980e-0942-4619-aee2-db8f0f7d8f19
# ╠═1becdf87-f457-4384-a712-7009e8c466b5
# ╠═d4aa5432-7fbe-4f1b-9680-1bd7690deba1
# ╠═93db76ce-52f9-4fa2-8012-d0526264934b
# ╠═795ab04a-e2cc-4c71-bff4-5c325e0929c1
# ╠═a3203314-f59f-424e-bbf2-56c9274e4dae
# ╠═e51e8a03-dabd-464e-be6c-88b6ae8cafe0
# ╠═c5db97ab-67a1-48cc-832e-69ef687ca1f6
# ╠═eba09f23-b1af-4679-847f-d8da793dab09
# ╠═00145d19-9a62-4343-89c8-c623688c5af6
# ╠═abd620ef-fd30-4adb-8681-a26267d21f6b
# ╠═8139f5ef-1d87-406d-b26b-e0baac01d104
# ╠═5c601fc3-9bf7-47a5-8b18-71e711b76bfb
# ╠═07695e8a-fdcc-4cc6-8d12-8e658a5d5180
# ╠═75c5b6c7-2705-4151-a28b-92522db7b592
# ╟─b7944093-6eb1-41b3-8f6b-096bd83a9315
# ╠═1ca695a7-04c7-4b40-b23d-0d4ef396fea2
# ╠═12e2895c-b122-422d-a3f8-431765eacd5f
# ╠═3b0ee8e5-92c6-477a-bce8-f1c35b322c12
# ╠═0242daf4-90a8-428d-a763-55278a631131
# ╠═9eb7a189-596c-472a-88e5-9f446f75fb59
# ╠═916d5359-aa71-45be-a229-2df64a81396e
# ╠═83a4079e-4880-4a0c-b11d-0368f89eaf7f
# ╠═a8ac8fe2-9aa5-4602-8ccb-3a21d657750d
# ╠═e0763cbe-a683-11eb-08ee-45153d2d2144
# ╠═a420cdc0-d0d8-4ca8-be0e-a1abc61518db
# ╠═a3c20927-9bc7-44b1-a970-e381d7466378
# ╠═83652fde-9873-44a0-b10f-3db63d62e76f
# ╠═17f109aa-72d3-4d1c-a5a4-b0baeb9cc162
# ╠═419e5f92-c80b-45af-81c6-caed1dbffacf
# ╠═2afe2875-aedc-498f-936a-fb6ec494869d
# ╠═822b5158-7071-4948-9a75-10b0ba4f8dee
# ╠═c2dba11c-abf7-4dd7-af51-f8e68096cb57
# ╠═177c8658-7064-4f7f-8675-2d0a7abb2615
# ╠═98960733-cc37-42fe-87fa-a8a32b6bc731
# ╠═3f69c74b-1653-4c2e-9cd1-498e94cefdca
# ╠═a63add35-065b-4c8d-ac62-5f7fbbc587fe
# ╠═4c559bae-7bb8-4d90-9a17-4ad72a82a28c
# ╠═ad47001a-f0b9-433d-819c-e4f52c412a35
# ╠═067dc2b9-76e0-44e0-b953-b4e0e121a00b
# ╠═5a587936-8189-4bad-8c69-62b5d5299958
# ╠═68389ed1-4d45-4af3-9fc1-7dbf4cda063a
# ╠═e4c3539c-116c-4f96-930a-ffab18a87d37
# ╠═fd5efe36-d78d-4279-8d9d-3d45c1f82bee
# ╠═7211e075-43e9-45a8-9dbf-aa57cf932c59
# ╠═830ad154-6d6f-4f4b-9e46-9a316605140a
