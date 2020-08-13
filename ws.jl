### A Pluto.jl notebook ###
# v0.7.8

using Markdown
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.peek, el) ? Base.peek(el) : missing
        el
    end
end

# ╔═╡ 000b22f6-8b2d-11ea-1685-a37d47885c63
 [ 0x4e
        0x61
        0x61
        0x6d
        0x20
        0x69
        0x6e
        0x69
        0x74
        0x69
        0xeb
        0x72
        0x65
        0x6e
        0x64
        0x65
        0x20
        0x70
        0x61
        0x72
        0x74
        0x69
        0x6a] |> String |> HTML

# ╔═╡ 741a47ea-8b34-11ea-0448-bdb5e0a5e9a5
2*256*512

# ╔═╡ 29402e84-8b30-11ea-24be-bfa691f9eb8f
@bind dims html"""
<wow></wow>
<input type='number' value='262144'>

<script>
const wow = this.querySelector("wow")
const canvas = this.querySelector("input")

canvas.oninput = e => {
	wow.value = new Uint8Array(canvas.valueAsNumber).join("")
	wow.dispatchEvent(new CustomEvent("input"))
}
canvas.oninput()

</script>
"""

# ╔═╡ b0652e98-8b33-11ea-284c-a37cda11ed1a
dims

# ╔═╡ Cell order:
# ╠═000b22f6-8b2d-11ea-1685-a37d47885c63
# ╠═741a47ea-8b34-11ea-0448-bdb5e0a5e9a5
# ╠═29402e84-8b30-11ea-24be-bfa691f9eb8f
# ╠═b0652e98-8b33-11ea-284c-a37cda11ed1a
