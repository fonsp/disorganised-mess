### A Pluto.jl notebook ###
# v0.14.4

using Markdown
using InteractiveUtils

# ╔═╡ f1b15c4b-10c9-4798-80b2-4f56dcff9949
using HypertextLiteral

# ╔═╡ 7615e137-c11a-404d-a1c2-1b296adbef97


# ╔═╡ 0ca4d927-8b0c-48fa-b7ac-a2f302a0bb24
wowie = html"""
	
	<h5>Wowie!</h5>
	"""

# ╔═╡ ac1ddc8b-94f1-4fbb-ada4-35bfa12e0d15
function scoped_css2(x, style)
	
	
	
	# html_code = repr(MIME"text/html"(), x)
	
	
	
	@htl("""
		
		
<pl-css-scoper>
	<template shadowroot="open">
		<style>
		$(style)
		</style>
		$(x)
	</template>
</pl-css-scoper>

		
		
		
		""")
	
	
	
	
end

# ╔═╡ c393f945-8169-452b-bd5c-fc35bf239a86
scoped_css2(wowie,
	"""
	h5 {
		color: pink;
	}
	"""
	)

# ╔═╡ 93e0b3da-558a-42fe-acf0-d19ba47b9f3c
scoped_css2(embed_display([1,2]),
	"""
	h5 {
		color: pink;
	}
	"""
	)

# ╔═╡ db1220d3-457c-4226-843d-5d1e82e593fd
function scoped_css2()
	
	
	html"""



"""

# ╔═╡ ba80b397-c526-4add-9e09-552509ed3a2f
#= html"""

<host-element>
    <template shadowroot="open">
        <style>
			::slotted {
            background:green !important;
          }
        </style>
        <h2>Shadow Content (visible if in shadow root)</h2>
        <slot></slot>
    </template>
    <style>
      h2 {
        background: red;
      }
    </style>
    <h2>Light DOM content (green if slotted)</h2>
</host-element>



""" =#

# ╔═╡ b641ffba-e935-4bc8-8d1c-e9465f68f581
html"""
<h2>asdf</h2>

"""

# ╔═╡ b432fee5-883a-432b-b6b6-2d7bda85c087
#= html"""

<host-element>
    <template shadowroot="open">
        <style>
          ::slotted(h2), h2 {
            background:green !important;
          }
        </style>
        <h2>Shadow Content (visible if in shadow root)</h2>
        <slot></slot>
    </template>
    <style>
      h2 {
        background: red;
      }
    </style>
    <h2>Light DOM content (green if slotted)</h2>
</host-element>



""" =#

# ╔═╡ 32c754be-452f-470f-ac47-b8f6aaa74b37
html"""
<html>
<h1>Hello Shadow DOM</h1>
</html>
"""

# ╔═╡ 22ff47b6-fe4c-49bc-85be-3bdc55832645
html"""
<h1>Hello Shadow DOM</h1>
"""

# ╔═╡ b2b4626e-ab78-11eb-0f1f-0df76aeed71b
function scoped_css(x, style)
	
	
	
	html_code = repr(MIME"text/html"(), x)
	
	
	
	@htl("""
		
		
		<script>
		
		const css_code = $(PlutoRunner.publish_to_js(style))
		const html_code = $(PlutoRunner.publish_to_js(html_code))
		
		const host = document.createElement("span")
		const shadowRoot = host.attachShadow({mode: 'open'});
		shadowRoot.innerHTML = `<style>\${css_code}</style><pluto-output>\${html_code}</pluto-output>`;
		
		
		
		return host
		
		
		</script>
		
		
		
		
		""")
	
	
	
	
end

# ╔═╡ d2d83f97-fe6b-4cae-a2e6-a8c7079ea14d
isolated_css = scoped_css

# ╔═╡ 817934b7-288c-4fea-b2d2-6abc4713dabd
isolated_css(@htl("""
		
		<script>alert("123")</script>
		
		<h1>Hello Shadow DOM</h1>
		
		$(embed_display([1,2,3]))
		
		"""),"""

	h1 {
		color: pink;
	}

""")

# ╔═╡ 7ce0ba7d-e04e-4492-b56f-825921039c5e
scoped_css(html"<h1>Hello Shadow DOM</h1>","""

	h1 {
		color: pink;
	}

""")

# ╔═╡ 096450a8-f73a-4a4a-9573-fe45fc342247


# ╔═╡ Cell order:
# ╠═7615e137-c11a-404d-a1c2-1b296adbef97
# ╠═0ca4d927-8b0c-48fa-b7ac-a2f302a0bb24
# ╠═c393f945-8169-452b-bd5c-fc35bf239a86
# ╠═93e0b3da-558a-42fe-acf0-d19ba47b9f3c
# ╠═ac1ddc8b-94f1-4fbb-ada4-35bfa12e0d15
# ╠═db1220d3-457c-4226-843d-5d1e82e593fd
# ╠═ba80b397-c526-4add-9e09-552509ed3a2f
# ╠═b641ffba-e935-4bc8-8d1c-e9465f68f581
# ╠═b432fee5-883a-432b-b6b6-2d7bda85c087
# ╠═f1b15c4b-10c9-4798-80b2-4f56dcff9949
# ╠═32c754be-452f-470f-ac47-b8f6aaa74b37
# ╠═22ff47b6-fe4c-49bc-85be-3bdc55832645
# ╠═d2d83f97-fe6b-4cae-a2e6-a8c7079ea14d
# ╠═817934b7-288c-4fea-b2d2-6abc4713dabd
# ╠═7ce0ba7d-e04e-4492-b56f-825921039c5e
# ╠═b2b4626e-ab78-11eb-0f1f-0df76aeed71b
# ╠═096450a8-f73a-4a4a-9573-fe45fc342247
