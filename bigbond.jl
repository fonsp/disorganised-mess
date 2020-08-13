### A Pluto.jl notebook ###
# v0.7.2

using Markdown
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.peek, el) ? Base.peek(el) : missing
        el
    end
end
# ╔═╡ e0ce06f8-7fd6-11ea-2b59-ff9d69c47d42
@bind x html"""
<canvas id="drawboard" width="200" height="200"></canvas>

<script>
const canvas = document.querySelector("canvas#drawboard")
const ctx = canvas.getContext("2d")

var startX = 80
var startY = 40

function sendvalue() {
	// 🐸 This is how we send the value back to Julia 🐸 //
	const raw = ctx.getImageData(0,0,200,200).data
	canvas.value = btoa(raw)
	canvas.dispatchEvent(new CustomEvent("input"))
}

function onmove(e){
	ctx.fillStyle = '#ffecec'
	ctx.fillRect(0, 0, 200, 200)
	ctx.fillStyle = '#3f3d6d'
	ctx.fillRect(startX, startY, e.layerX - startX, e.layerY - startY)

	sendvalue()
}

canvas.onmousedown = e => {
	startX = e.layerX
	startY = e.layerY
	canvas.onmousemove = onmove
}

canvas.onmouseup = e => {
	canvas.onmousemove = null
}

// To prevent this code block from showing and hiding
canvas.onclick = e => e.stopPropagation()

// Fire a fake mousemoveevent to show something
onmove({layerX: 130, layerY: 160})

</script>
"""

# ╔═╡ efb50b94-7fd6-11ea-1d80-f7ddee184780
(x |> length, rand())

# ╔═╡ a8eb7240-7fe8-11ea-3379-e1f3cd6f4684
begin
	import Base: endswith
	
	function endswith(vec::Vector{T}, suffix::Vector{T}) where T
	    local liv = lastindex(vec)
	    local lis = lastindex(suffix)
	    liv >= lis && (view(vec, (liv-lis + 1):liv) == suffix)
	end
end

# ╔═╡ cd83f1a0-7fe7-11ea-1546-910dec41906e
endswith([1,2,3], [2,3, 4, 5])

# ╔═╡ 27d5bed6-7fe8-11ea-1a8a-af798742d71d
view([1,2,3], 2:end) == [2,3]

# ╔═╡ 61fb01fc-7fe8-11ea-04f6-c1a6fb545a0d


# ╔═╡ fed7690c-7fe8-11ea-221c-edefefcd4aef
begin
	str = "asdfasdfdfas"
	append!(str, "xx")
end

# ╔═╡ 0522a574-7fe9-11ea-2f03-a1a519041e62
codeunits(str)|> Vector{UInt8}

# ╔═╡ ff660100-7fd7-11ea-080f-d762a0764752
obj = Dict(:a => Dict(:b => str), :c => :d)

# ╔═╡ cccd3524-7fd7-11ea-241b-a35f2ca3e245
using JSON

# ╔═╡ deb4cf4a-7fd7-11ea-2a63-7b27570cd414
JSON.Parser.parse( codeunits(JSON.json(obj)) |> Vector{UInt8}) |> length

# ╔═╡ Cell order:
# ╠═efb50b94-7fd6-11ea-1d80-f7ddee184780
# ╠═e0ce06f8-7fd6-11ea-2b59-ff9d69c47d42
# ╠═a8eb7240-7fe8-11ea-3379-e1f3cd6f4684
# ╠═cd83f1a0-7fe7-11ea-1546-910dec41906e
# ╠═27d5bed6-7fe8-11ea-1a8a-af798742d71d
# ╠═61fb01fc-7fe8-11ea-04f6-c1a6fb545a0d
# ╠═fed7690c-7fe8-11ea-221c-edefefcd4aef
# ╠═0522a574-7fe9-11ea-2f03-a1a519041e62
# ╠═cccd3524-7fd7-11ea-241b-a35f2ca3e245
# ╠═ff660100-7fd7-11ea-080f-d762a0764752
# ╠═deb4cf4a-7fd7-11ea-2a63-7b27570cd414
