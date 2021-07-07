### A Pluto.jl notebook ###
# v0.15.1

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

# ╔═╡ 4cddacfc-df19-11eb-1e4a-f358d91fa394
@bind a html"""
<script>
const base64_arraybuffer = async (/** @type {BufferSource} */ data) => {
    const base64url = await new Promise((r) => {
        const reader = new FileReader()
        reader.onload = () => r(reader.result)
        reader.readAsDataURL(new Blob([data]))
    })

    return base64url.split(",", 2)[1]
}

currentScript.value = await base64_arraybuffer(crypto.getRandomValues(new Uint32Array(6)).buffer)
</script>
"""

# ╔═╡ cc93a52f-f01b-4086-a323-235f34f11358
a

# ╔═╡ Cell order:
# ╠═4cddacfc-df19-11eb-1e4a-f358d91fa394
# ╠═cc93a52f-f01b-4086-a323-235f34f11358
