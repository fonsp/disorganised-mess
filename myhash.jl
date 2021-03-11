### A Pluto.jl notebook ###
# v0.12.18

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

# ╔═╡ 29a6efac-4dfe-11eb-0121-dd92425f812e
using SHA

# ╔═╡ 8bc28c8e-5a73-4238-86c9-c90d11808559
using Base64

# ╔═╡ de93768e-e28b-4deb-91f3-c4f88f6947ab
myhash = base64encode ∘ sha256

# ╔═╡ 4a763ea2-7740-462b-87ff-40789c6cdae3
# @bind hello html"<input>"

# ╔═╡ dc430b48-cc16-4706-9e42-d93843e387cc
hello = read(download("https://mkhj.fra1.cdn.digitaloceanspaces.com/sample%20Tower%20of%20Hanoi%2016.jl"), String)

# ╔═╡ 48cf1678-a562-442b-9d5c-6c24bdbb9b5e
myhash(hello) |> Text

# ╔═╡ 25fa3f99-f299-47bc-ae27-4b9cebda7043
Dict(map(x -> x => x, 1:4)...)

# ╔═╡ eee41260-9b34-42fb-bfe2-152c560ee7d1
HTML("""

<script>

const hello = $(repr(hello))
	
const myhash = async (s) => {
	const data = new TextEncoder().encode(s)
	const hashed_buffer = await window.crypto.subtle.digest("SHA-256", data)

	const base64url = await new Promise((r) => {
		const reader = new FileReader()
		reader.onload = () => r(reader.result)
		reader.readAsDataURL(new Blob([hashed_buffer]))
	})

	return base64url.split(",", 2)[1]
}


return html`<code>\${await myhash(hello)}</code>`

</script>

""")

# ╔═╡ Cell order:
# ╠═29a6efac-4dfe-11eb-0121-dd92425f812e
# ╠═8bc28c8e-5a73-4238-86c9-c90d11808559
# ╠═de93768e-e28b-4deb-91f3-c4f88f6947ab
# ╠═4a763ea2-7740-462b-87ff-40789c6cdae3
# ╠═dc430b48-cc16-4706-9e42-d93843e387cc
# ╠═48cf1678-a562-442b-9d5c-6c24bdbb9b5e
# ╠═25fa3f99-f299-47bc-ae27-4b9cebda7043
# ╠═eee41260-9b34-42fb-bfe2-152c560ee7d1
