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

# ╔═╡ a6139adc-e619-458b-8e53-02d89f482d28
using HypertextLiteral

# ╔═╡ 22fafdef-9765-427c-816d-04440a613307
md"""
# Julia WASM as a JS package

The Julia WASM build can be used to execute Julia code from JavaScript! This notebook shows off two use cases!

For more info, see the [Julia WASM project](https://github.com/Keno/julia-wasm) and a demo of [Pluto running inside WASM](https://pluto-wasm-backend.netlify.app/editor.html).

> If you are interested in helping us with WASM development, please get in touch with [me](https://github.com/fonsp) or [Keno Fischer](https://github.com/Keno). If you find WASM interesting and useful, please spread the word!
"""

# ╔═╡ 5f82e865-213b-472d-a7a2-6dab4fc4caae
md"""
## Julia REPL inside your browser
"""

# ╔═╡ 49ed99c9-3d68-4e64-b292-45d8140fdd0d
md"""
## Autograde simple exercises
Without a Julia process!
"""

# ╔═╡ bddc7a13-d524-42f6-b3c1-24bf63188cc5
md"""
#### Exercise 5.2
👉 Write an expression that returns `true`. Given is `x = 100`
"""

# ╔═╡ c350fc7c-e519-4e3d-802f-4cbdd6d6b9f5


# ╔═╡ 1bbc3534-1a99-421e-b947-7ff4e7e6e0a2
wasm_setup = @htl("""


 <script type="text/javascript" src="https://cdn.jsdelivr.net/gh/fonsp/Pluto.jl@1a004af05111894b5ff8916fe82dca320ddb0a1e/frontend/jl_wasm.js"></script>
    <!-- <script src="https://fonsp-julia-wasm-build.netlify.app/hello-no-bysyncify.js"></script> -->
    <script src="https://keno.github.io/julia-wasm-build/hello-no-bysyncify.js"></script>

""")


# ╔═╡ 6b5ff8b1-ec53-4b46-9980-44c4847d9eac
function mini_repl(;
	default::String = "1 + 1",
	setup_code::String = "",
	dramatic_timeout::Real = 0,
	post_process_function_code::Union{Expr,String} = "identity",
)
	
	
	
	@htl("""
	<div>
	$(wasm_setup)
	
	<textarea style='width: 100%' rows=5></textarea>
	<button>Run!</button>
	
	<div class='jl-wasm-output'><marquee>Loading WASM...</marquee></div>
	
	<script>
	
	let div = currentScript.parentElement
	
	let text = div.querySelector("textarea")
	let button = div.querySelector("button")
	let output_div = div.querySelector(".jl-wasm-output")
	
	text.value = div.value ?? $(default)
	
	let currentValue = text.value
	
	
	Object.defineProperty(div, 'value', {
	  get() { return currentValue; },
	  set(newValue) { 
		text.value = newValue; 
		currentValue = newValue
		button.click()
	},
	});
	
	
	
	
	text.addEventListener("input", (e) => {
	
		e.stopPropagation()
	})
	
	text.addEventListener("keydown", e => {
		let is_mac_keyboard = /Mac/.test(navigator.platform)
		let ctrldown = e.ctrlKey || (is_mac_keyboard && e.metaKey)
		if(e.key === "Enter" && (e.shiftKey || ctrldown)) {
			e.preventDefault()
			button.click()
		}
	
	});
	
	
	const pre = (x) => html`<pre><code>\${x}</code></pre>`
	
	
	let set_output_element = (el) => {
		button.disabled = false
		button.innerText = "Run!"
		output_div.style.opacity = 1
		Array.from(output_div.children).forEach(x => x.remove())
		output_div.append(el)
	}
	
	
	button.addEventListener("click", async (e) => {
	
		button.disabled = true
		button.innerText = "Loading..."
		output_div.style.opacity = .5
	
		currentValue = text.value
		e.stopPropagation()
		div.dispatchEvent(new CustomEvent("input"))

		await new Promise(r => setTimeout(r, $(dramatic_timeout) * 1000)) // for dramatic effect
	
		await window.jl_wasm.ready
		
		let ran_code = false
		
		try {
			const result_ptr = window.jl_wasm.eval_jl(`

	\${$(setup_code)}
	___post_process = \${$(string(post_process_function_code))}

	___result = begin
	\${currentValue}
	end
	
	___post_process(___result)
	`)
		
			ran_code = true
		
			const html_showable = window.jl_wasm.std.html_showable(result_ptr)
		
			const repred = html_showable ? window.jl_wasm.std.repr_html(result_ptr) : window.jl_wasm.std.repr(result_ptr)
		
			let el = html_showable ? 
				(new DOMParser()).parseFromString(repred, "text/html")
					.body.firstElementChild :
				pre(repred)
			set_output_element(el)
			
		} catch (e) {
		
		set_output_element(pre(
				(ran_code ? "Failed to show object" : "Failed to run code") + e))
		}
		
	})
	
	button.click()
	
	</script>
	</div>
	""")
end

# ╔═╡ d78c56f5-4b9d-4451-8fc0-bd0f6dd0cbf2
mini_repl(;
	default = "sqrt.(1:3)"
)

# ╔═╡ 20209643-23ea-4f0c-bdf8-53c83d169ee9
mini_repl(;
	default = "sqrt(x) == 10",
	
	setup_code = "x = 100",

	dramatic_timeout = 0.5,
	
	post_process_function_code = quote
		
		result -> if !isa(result, Bool)
			"You should return true or false"
			
		elseif result == true
			HTML("<div style='padding: 1em; margin: 1em; font-family: system-ui; border-radius: 5px; background: lightgreen;'>
				Correct!
			</div>")
			
		else
			HTML("<div style='padding: 1em; margin: 1em; font-family: system-ui; border-radius: 5px; background: #ffbbbb;'>
				Keep working on it!
			</div>")
		end
	end
)

# ╔═╡ a074dec9-e8ab-4956-bfa3-24654d5c5274
mini_repl(;
	setup_code = "x = 999",
	default = "x / 99",
)

# ╔═╡ 64bfadea-6390-413e-8f5a-f29a8b36e58f
mybond = @bind code mini_repl()

# ╔═╡ 22770ba8-7bcc-484e-bec5-85629e340930
code

# ╔═╡ 256272d4-1ea3-40d5-953b-cffd2d4b1ba8
mybond

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"

[compat]
HypertextLiteral = "~0.9.3"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.0"
manifest_format = "2.0"

[[deps.HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"
"""

# ╔═╡ Cell order:
# ╟─22fafdef-9765-427c-816d-04440a613307
# ╟─5f82e865-213b-472d-a7a2-6dab4fc4caae
# ╠═d78c56f5-4b9d-4451-8fc0-bd0f6dd0cbf2
# ╟─49ed99c9-3d68-4e64-b292-45d8140fdd0d
# ╟─bddc7a13-d524-42f6-b3c1-24bf63188cc5
# ╠═20209643-23ea-4f0c-bdf8-53c83d169ee9
# ╠═c350fc7c-e519-4e3d-802f-4cbdd6d6b9f5
# ╠═a6139adc-e619-458b-8e53-02d89f482d28
# ╠═22770ba8-7bcc-484e-bec5-85629e340930
# ╠═6b5ff8b1-ec53-4b46-9980-44c4847d9eac
# ╠═a074dec9-e8ab-4956-bfa3-24654d5c5274
# ╠═64bfadea-6390-413e-8f5a-f29a8b36e58f
# ╠═256272d4-1ea3-40d5-953b-cffd2d4b1ba8
# ╠═1bbc3534-1a99-421e-b947-7ff4e7e6e0a2
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
