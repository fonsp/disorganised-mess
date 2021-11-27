### A Pluto.jl notebook ###
# v0.17.2

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

# ╔═╡ a170b892-31c9-11ec-0e14-c1a422b936e2
using HypertextLiteral

# ╔═╡ 098d9b92-2c94-4b1f-97bb-ab2b97064583
using JSON

# ╔═╡ 2cd3ec25-c7d3-4bc0-9712-04b89153ce1c
material_header = @htl """
  <link href="https://unpkg.com/material-components-web@13.0.0/dist/material-components-web.min.css" rel="stylesheet">
  <script src="https://unpkg.com/material-components-web@13.0.0/dist/material-components-web.min.js"></script>
<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
"""

# ╔═╡ f6f6021e-627f-4588-a48c-472dc2b95be3
@htl """
<span>
<button class="mdc-button foo-button">
  <div class="mdc-button__ripple"></div>
  <span class="mdc-button__label">Button</span>
</button>
<script>
mdc.ripple.MDCRipple.attachTo(currentScript.parentElement.querySelector('button'));
</script>
</span>
"""

# ╔═╡ 222f24e3-3973-4e32-a5cd-92bdadf4011a
content = @htl """
<h3 class="mdc-typography--headline3">Hello!</h3>
<p>Wowwaeiofdsi fjklas djflkasj dflkasjd flkasd fklzsjd fkja sdf </p>
"""

# ╔═╡ ed9046c4-6f20-41c1-b98b-5410b2f4c316
@htl """<div class="mdc-card mdc-typography ">

  $(content)
</div>"""

# ╔═╡ 37f01988-6b55-438f-99bb-64f0997d6e81
yayo = @bind xo @htl """
<span>
<div class="mdc-slider mdc-slider--range">
  <input class="mdc-slider__input" type="range" min="0" max="70" value="30" name="rangeStart" aria-label="Continuous range slider demo">
  <input class="mdc-slider__input" type="range" min="30" max="100" value="70" name="rangeEnd" aria-label="Continuous range slider demo">
  <div class="mdc-slider__track">
    <div class="mdc-slider__track--inactive"></div>
    <div class="mdc-slider__track--active">
      <div class="mdc-slider__track--active_fill"></div>
    </div>
  </div>
  <div class="mdc-slider__thumb">
    <div class="mdc-slider__thumb-knob"></div>
  </div>
  <div class="mdc-slider__thumb">
    <div class="mdc-slider__thumb-knob"></div>
  </div>
</div>
<script>
let root = currentScript.parentElement

let coolslider = mdc.slider.MDCSlider.attachTo(root.querySelector('.mdc-slider'));

let value = [30,70]

Object.defineProperty(root, 'value', {
get: () => value,
set: (newval) => {
	value = newval;
	coolslider.setValue(newval[1])
	coolslider.setValueStart(newval[0])
}
})

coolslider.root.addEventListener('MDCSlider:input', (e)=>{
	value = [coolslider.getValueStart(), coolslider.getValue(), ]
	root.dispatchEvent(new CustomEvent("input"))
});
</script>
</span>
"""

# ╔═╡ 0978542a-e1d4-432d-bf58-f17d60bfa325
xo

# ╔═╡ 94e4958f-a4dc-4751-9762-2d5946ec3a6c
yayo

# ╔═╡ db4d0049-26bb-4f5f-a539-a5e44dce2f86


# ╔═╡ 6ff77256-6b1d-4291-99cd-aca95a925217
f(;kwargs...) = kwargs

# ╔═╡ 3c12bf4d-24a0-4c1a-a104-31c98a34e437
a = (x = 123,)

# ╔═╡ 619cb5d7-a295-46cb-8619-60bf3a0471ef
 b = JSON.parse("{\"a\": 1}")

# ╔═╡ 03f8d431-2fd8-431e-a957-4613cc4666b2
c = (Symbol(k) => v for (k,v) in b)

# ╔═╡ d06676ae-6f54-426e-828f-16c16f8defdc
f(; x = 1, a..., c...)

# ╔═╡ 59a84455-0635-4ef7-8403-6b1ef8685b3d
f(; a..., x = 1)

# ╔═╡ cd8eba06-721b-4b30-8022-0d8c9ec5fa78
# @htl """
#  <style>
#       .cards {
#         display: flex;
#         flex-wrap: wrap;
#       }

#       .element-card {
#         width: 20em;
#         margin: 16px;
#       }

#       .element-card > .mdc-card__media {
#         height: 9em;
#       }

#       #demo-absolute-fab {
#         position: fixed;
#         bottom: 1rem;
#         right: 1rem;
#         z-index: 1;
#       }
#     </style>
#   <div class="mdc-typography">
#     <h1>Choose your element</h1>
#     <div class="cards">
#       <div class="mdc-card element-card earth">
#         <div class="mdc-card__media">
#           <div class="mdc-card__media-content">
#             <h1 class="mdc-typography--headline4">Earth</h1>
#             <h2 class="mdc-typography--headline6">A solid decision.</h2>
#           </div>
#         </div>
#         <p>
#           Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
#           Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
#         </p>
#       </div>
#       <div class="mdc-card element-card wind">
#         <div class="mdc-card__media">
#           <h1 class="mdc-typography--headline4">Wind</h1>
#           <h2 class="mdc-typography--headline6">Stormy weather ahead.</h2>
#         </div>
#         <p>
#           Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
#           Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
#         </p>
#       </div>
#       <div class="mdc-card element-card fire">
#         <div class="mdc-card__media">
#           <h1 class="mdc-typography--headline4">Fire</h1>
#           <h2 class="mdc-typography--headline6">Hot-headed much?</h2>
#         </div>
#         <p>
#           Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
#           Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
#         </p>
#       </div>
#       <div class="mdc-card element-card water">
#         <div class="mdc-card__media">
#           <h1 class="mdc-typography--headline4">Water</h1>
#           <h2 class="mdc-typography--headline6">Go with the flow.</h2>
#         </div>
#         <p>
#           Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
#           Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
#         </p>
#       </div>
#     </div>
#     <button class="mdc-fab" id="demo-absolute-fab" aria-label="Favorite">
#       <div class="mdc-fab__ripple"></div>
#       <span class="mdc-fab__icon material-icons">favorite</span>
#     </button>
#   </div>
# 	  """

# ╔═╡ 7c2a6e10-35fc-45d8-b689-c0f88cfdf7dd
import AbstractPlutoDingetjes

# ╔═╡ 7b4689c1-7eba-4939-8618-7525c82f57cf
function closest(range::AbstractRange, x::Real)
	rmin = minimum(range)
	rmax = maximum(range)

	if x <= rmin
		rmin
	elseif x >= rmax
		rmax
	else
		rstep = step(range)

		int_val = (x - rmin) / rstep
		range[round(Int, int_val) + 1]
	end
end

# ╔═╡ b6d3fba6-9a74-4146-81fc-1d9244428264
begin
	struct RangeSlider
		range::AbstractRange{<:Real}
		default::AbstractRange
	end

	RangeSlider(range; default=range) = RangeSlider(range, default)

	function Base.show(io, m::MIME"text/html", rs::RangeSlider)
		if !AbstractPlutoDingetjes.is_supported_by_display(io, AbstractPlutoDingetjes.Bonds.transform_value)
			write(io, "❌ Update Pluto to use this element.")
			return
		end
		show(io, m, @htl("""
		<div>
		<link href="https://cdn.jsdelivr.net/npm/nouislider@15.5.0/dist/nouislider.min.css" rel="stylesheet"/>
		
		<script>
		const {default: noUiSlider} = await import( "https://cdn.jsdelivr.net/npm/nouislider@15.5.0/dist/nouislider.min.mjs")
		const {default: throttle} = await import("https://cdn.jsdelivr.net/npm/lodash-es@4.17.21/throttle.js")
		
		const el = html`<div style='font-family: system-ui; font-size: .75rem; min-height: 1em; margin: 2.5em 1em .5em 1em'></div>`
		
		const step = $(Float64(step(rs.range)))
		let num_decimals = Math.max(0, -1 * Math.floor(Math.log(step)))
		const formatter = {
		to: x => x.toLocaleString("en-US", { maximumFractionDigits: num_decimals, minimumFractionDigits: num_decimals })
		
		}
		
		const slider = noUiSlider.create(el, {
			start: [$(Float64(minimum(rs.default))), $(Float64(maximum(rs.default)))],
			connect: true,
			range: {
				'min': $(Float64(minimum(rs.range))),
				'max': $(Float64(maximum(rs.range))),
			},
			tooltips: [formatter, formatter],
			step: step,
		});
		
		// console.log(slider)
		let root = currentScript.parentElement
		
		let busy = false
		slider.on("start", () => {busy = true})
		slider.on("end", () => {busy = false})
		
		let handler = (e) => {
			// console.warn(e, root.value, 123)
			root.dispatchEvent(new CustomEvent("input"))
		}
		
		slider.on("slide", handler)
		slider.on("drag", handler)
		invalidation.then(() => {
			slider.off("slide", handler)
			slider.off("drag", handler)
		})
		
		Object.defineProperty(root, 'value', {
		get: () => slider.get(true),
		set: (newval) => {
			if(!busy) {
				
				slider.set(newval)
			}
		}
		})
		
		
		return el
		</script>
		</div>
		"""))
	end

	AbstractPlutoDingetjes.Bonds.initial_value(rs::RangeSlider) = rs.default

	function AbstractPlutoDingetjes.Bonds.transform_value(rs::RangeSlider, js_val::Any)
		@assert js_val isa Vector && length(js_val) == 2
		
		rounded_range = closest.([rs.range], js_val)
		rounded_range[1] : step(rs.range) : rounded_range[2]
	end
	

end

# ╔═╡ 48e8968f-0279-4153-aa93-9e427ba5a02e
@bind closest_test html"<input type=range step=0.000001 max=5>"

# ╔═╡ 523ccdc8-df86-4ceb-8f21-ffa5ae3fbdc9
closest_test

# ╔═╡ e4b53627-01ff-4dee-9a5f-3bb0022918a0
closest(2:.3:4, closest_test)

# ╔═╡ 9d8a0085-1d52-4fa3-b9a6-21f0157e6fc8
zbond = @bind z RangeSlider(0.0:π:100)

# ╔═╡ 862d909a-7ad6-42d4-a06a-13d5d510c749
zbond

# ╔═╡ e2089b45-ca93-4f59-a7de-7a715b1834f0
z

# ╔═╡ 01609b2b-55f4-40da-b0f6-7922f2b079cc
@bind rational RangeSlider(1:1//300:10)

# ╔═╡ 83030231-057f-4df0-a09e-dc588af6c946
rational

# ╔═╡ df110b36-80ca-40d1-80c0-aac269034767
Float64.(rational)

# ╔═╡ e3f611d3-9af4-4f6f-a11b-af5f1f1b900d


# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
AbstractPlutoDingetjes = "6e696c72-6542-2067-7265-42206c756150"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
JSON = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"

[compat]
AbstractPlutoDingetjes = "~1.1.1"
HypertextLiteral = "~0.9.1"
JSON = "~0.21.2"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "0bc60e3006ad95b4bb7497698dd7c6d649b9bc06"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.1"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[HypertextLiteral]]
git-tree-sha1 = "f6532909bf3d40b308a0f360b6a0e626c0e263a8"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.1"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

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

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "98f59ff3639b3d9485a03a72f3ab35bab9465720"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.0.6"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

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
# ╠═a170b892-31c9-11ec-0e14-c1a422b936e2
# ╠═2cd3ec25-c7d3-4bc0-9712-04b89153ce1c
# ╠═f6f6021e-627f-4588-a48c-472dc2b95be3
# ╠═222f24e3-3973-4e32-a5cd-92bdadf4011a
# ╠═ed9046c4-6f20-41c1-b98b-5410b2f4c316
# ╠═0978542a-e1d4-432d-bf58-f17d60bfa325
# ╠═94e4958f-a4dc-4751-9762-2d5946ec3a6c
# ╠═37f01988-6b55-438f-99bb-64f0997d6e81
# ╠═db4d0049-26bb-4f5f-a539-a5e44dce2f86
# ╠═6ff77256-6b1d-4291-99cd-aca95a925217
# ╠═d06676ae-6f54-426e-828f-16c16f8defdc
# ╠═03f8d431-2fd8-431e-a957-4613cc4666b2
# ╠═3c12bf4d-24a0-4c1a-a104-31c98a34e437
# ╠═098d9b92-2c94-4b1f-97bb-ab2b97064583
# ╠═619cb5d7-a295-46cb-8619-60bf3a0471ef
# ╠═59a84455-0635-4ef7-8403-6b1ef8685b3d
# ╠═cd8eba06-721b-4b30-8022-0d8c9ec5fa78
# ╠═862d909a-7ad6-42d4-a06a-13d5d510c749
# ╠═e2089b45-ca93-4f59-a7de-7a715b1834f0
# ╠═7c2a6e10-35fc-45d8-b689-c0f88cfdf7dd
# ╠═b6d3fba6-9a74-4146-81fc-1d9244428264
# ╠═7b4689c1-7eba-4939-8618-7525c82f57cf
# ╠═48e8968f-0279-4153-aa93-9e427ba5a02e
# ╠═523ccdc8-df86-4ceb-8f21-ffa5ae3fbdc9
# ╠═e4b53627-01ff-4dee-9a5f-3bb0022918a0
# ╠═9d8a0085-1d52-4fa3-b9a6-21f0157e6fc8
# ╠═01609b2b-55f4-40da-b0f6-7922f2b079cc
# ╠═83030231-057f-4df0-a09e-dc588af6c946
# ╠═df110b36-80ca-40d1-80c0-aac269034767
# ╠═e3f611d3-9af4-4f6f-a11b-af5f1f1b900d
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
