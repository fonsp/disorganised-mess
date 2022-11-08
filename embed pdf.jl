### A Pluto.jl notebook ###
# v0.19.14

using Markdown
using InteractiveUtils

# ╔═╡ fc9927e1-1c00-40a7-bc5f-69224559690a
using HypertextLiteral

# ╔═╡ de938bba-1287-4ef5-b40d-fa4a5ffef6fc
url = "https://github.com/mitmath/JuliaComputation/raw/main/notebooks/Broadening.pdf"

# ╔═╡ 25e7deb4-5f70-11ed-2cd8-75a333a33419
path = download(url)

# ╔═╡ 55ba2268-bee2-4ee4-9440-b22d3a09be37
data = read(path)

# ╔═╡ 2febdf14-4937-440f-be4e-14c25706ffa3
@htl("""


""")

# ╔═╡ efb427b6-be8a-45a9-a97a-ca2e1109d50e
@htl("""

<script src="https://cdn.jsdelivr.net/npm/pdfjs-dist@3.0.279/build/pdf.min.js" integrity="sha256-DTvuEzaEnHA+06bgzETjueIC6ZR7VSrcVwHOGRY62Yg=" crossorigin="anonymous"></script>
<script id="asdf">

	const div = this ?? document.createElement("div")

	const data = $(PlutoRunner.publish_to_js(data))

	const url = URL.createObjectURL(new Blob([data]))
	
pdfjsLib.getDocument(url).promise.then((pdf) => {
	const page_promises = [...Array(pdf.numPages)].map((_,i) => pdf.getPage(i+1).then((page) => {

		let scale = 1.5;
		let viewport = page.getViewport({ scale: scale, });
		let outputScale = window.devicePixelRatio || 1;
		
		let canvas = document.createElement('canvas');
		let context = canvas.getContext('2d');
		
		canvas.width = Math.floor(viewport.width * outputScale);
		canvas.height = Math.floor(viewport.height * outputScale);
		
		canvas.style.width = `min(\${Math.floor(viewport.width)}px, 100%)`;

		
		let transform = outputScale !== 1
		  ? [outputScale, 0, 0, outputScale, 0, 0]
		  : null;
		
		page.render({
		  canvasContext: context,
		  transform: transform,
		  viewport: viewport
		});

		return canvas
	}))

	Promise.all(page_promises).then((canvasses) => {
		div.innerHTML = ""
		canvasses.forEach(c => div.appendChild(c))
	})
})


	return div
	
</script>

""")

# ╔═╡ e794b6d0-fcdb-4c43-98d1-b7a7271c9aac
import URIs

# ╔═╡ 7846da99-bff7-4ae1-93ac-73a4e435d648
@htl("""
<iframe style="width: 100%; height: 400px" src=$("https://mozilla.github.io/pdf.js/web/viewer.html?file=$(URIs.escapeuri(url))")></iframe>

""")

# ╔═╡ 03368ed8-9b22-4bfa-b47a-147c19cb5be8
# @htl("""

# <script id="asdf">

# 	const iframe = this ?? document.createElement("iframe")
# 	iframe.style = "width: 100%; height: 400px"
# 	iframe.allow = "accelerometer; ambient-light-sensor; autoplay; battery; camera; display-capture; document-domain; encrypted-media; execution-while-not-rendered; execution-while-out-of-viewport; fullscreen; geolocation; gyroscope; layout-animations; legacy-image-formats; magnetometer; microphone; midi; navigation-override; oversized-images; payment; picture-in-picture; publickey-credentials-get; sync-xhr; usb; wake-lock; screen-wake-lock; vr; web-share; xr-spatial-tracking"
	
# 	const data = $(PlutoRunner.publish_to_js(data))

# 	const url = URL.createObjectURL(new Blob([data]), { type: "text/html" })

# 	iframe.src = `https://mozilla.github.io/pdf.js/web/viewer.html?file=\${encodeURIComponent(url)}`
# 	return iframe
	
# </script>

# """)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
URIs = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"

[compat]
HypertextLiteral = "~0.9.4"
URIs = "~1.4.0"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.0"
manifest_format = "2.0"
project_hash = "1094c8a4ed9cc3665d63d5cdad1002a32045642e"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[deps.URIs]]
git-tree-sha1 = "e59ecc5a41b000fa94423a578d29290c7266fc10"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.0"
"""

# ╔═╡ Cell order:
# ╠═de938bba-1287-4ef5-b40d-fa4a5ffef6fc
# ╠═25e7deb4-5f70-11ed-2cd8-75a333a33419
# ╠═55ba2268-bee2-4ee4-9440-b22d3a09be37
# ╠═2febdf14-4937-440f-be4e-14c25706ffa3
# ╠═fc9927e1-1c00-40a7-bc5f-69224559690a
# ╠═efb427b6-be8a-45a9-a97a-ca2e1109d50e
# ╠═e794b6d0-fcdb-4c43-98d1-b7a7271c9aac
# ╠═7846da99-bff7-4ae1-93ac-73a4e435d648
# ╠═03368ed8-9b22-4bfa-b47a-147c19cb5be8
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
