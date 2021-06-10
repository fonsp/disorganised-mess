### A Pluto.jl notebook ###
# v0.14.3

using Markdown
using InteractiveUtils

# ╔═╡ d1696d25-1f3c-4a4a-b287-7f0035c897c7
using HypertextLiteral

# ╔═╡ 1f9ffe73-8018-4e5e-ad47-8f3836bbddb0


# ╔═╡ 950faf39-8e9b-4cdd-afed-0f2aecfb4ef0
function EditMe(initial)
	
	@htl("""
		
		<script>
		
		const init = $(initial)
		
		const el = html`<input>`
		
		el.value = init
		
		const cm = currentScript.closest("pluto-cell").querySelector(".CodeMirror").CodeMirror
		
		el.addEventListener("input", () => {
			const old_value = cm.getValue()
		
			const new_command = `EditMe(\${JSON.stringify(el.value)})`
			
			
			cm.setValue(old_value.replace(/EditMe\\(\\".+\\"\\)/, new_command))
			
	})
		
		return el
		
		""")
	
	
end

# ╔═╡ e3654826-c3e0-4473-ac0a-e750cd2677c9
e = EditMe("asdfasdfasdfasdfasdfasdfasdfasdf")

# ╔═╡ 6bb4cefd-ff3e-4cf3-afac-b70c63a03766
begin
	# wow i spent a really long time writing this comment!!!
	
	
	EditMe("asdfasdfasdfasdfasdfasdfasdfasdfasdfasdffasdfasdf")
end

# ╔═╡ d357b372-ca0b-11eb-3ad6-35d924725b87
df = kjasdlkfjasdlkjf

# ╔═╡ b66eb5a1-a78f-4f21-aec4-a0cef9345972
[df; can_drink]

# ╔═╡ 368ed753-4d37-498a-abff-1bf5c3d55750
nb = 

# ╔═╡ 598b7498-0e19-41ad-9386-f11b67c11a93
nb(;x = 123)

# ╔═╡ 7c271a29-c53a-414c-bc5b-05e325403fc1
map(nb, df)

# ╔═╡ 2a4b192a-71ad-4a5a-8ccd-a16d1e4ec92c
can_drink = df["age"] .> 18

# ╔═╡ 0a4863b9-a753-4842-8216-a25ecf63ba1d
can_drink = map(zip(df["first name"], df["last name"])) do (first, last)
	first * ", " * last
end

# ╔═╡ Cell order:
# ╠═e3654826-c3e0-4473-ac0a-e750cd2677c9
# ╠═1f9ffe73-8018-4e5e-ad47-8f3836bbddb0
# ╠═6bb4cefd-ff3e-4cf3-afac-b70c63a03766
# ╠═d1696d25-1f3c-4a4a-b287-7f0035c897c7
# ╠═950faf39-8e9b-4cdd-afed-0f2aecfb4ef0
# ╠═d357b372-ca0b-11eb-3ad6-35d924725b87
# ╠═2a4b192a-71ad-4a5a-8ccd-a16d1e4ec92c
# ╠═0a4863b9-a753-4842-8216-a25ecf63ba1d
# ╠═b66eb5a1-a78f-4f21-aec4-a0cef9345972
# ╠═368ed753-4d37-498a-abff-1bf5c3d55750
# ╠═598b7498-0e19-41ad-9386-f11b67c11a93
# ╠═7c271a29-c53a-414c-bc5b-05e325403fc1
