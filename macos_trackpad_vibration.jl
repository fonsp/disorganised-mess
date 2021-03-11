### A Pluto.jl notebook ###
# v0.12.20

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

# ╔═╡ 191d9d94-10d9-4548-b452-1d70d9a5ea5e
md"""
# Tap on every value
"""

# ╔═╡ ce323f26-6373-453d-bf0c-4296ac0b83de
@bind x html"<input style='width: 500px' type=range max=10>"

# ╔═╡ 1209a862-dcb3-4318-a4a4-6609a0ebcaa4
md"""
# Tap three times
"""

# ╔═╡ 7b2d44fc-2cc5-421d-a9c1-739233d4f858
md"""
# Tab on snap
"""

# ╔═╡ 666a7d32-a6f8-4856-b182-0268e6382ec8
@bind y html"<input style='width: 500px' type=range max=10 step=.01>"

# ╔═╡ d9b11d6f-a459-428f-a0ac-a2d2e5c0575d
last_yint = Ref(0)

# ╔═╡ 63644f60-eeaf-4301-983c-51b8d0abcd9f
yint = round(Int, y)

# ╔═╡ 840ca3ba-d72b-429b-b79e-7b599c698365
HTML("<input style='width: 500px' type=range max=10 step=.01 value=$(yint) disabled>")

# ╔═╡ 19f84b62-237d-4b74-a8cc-1eba1674d786
md"""
## Appendix
"""

# ╔═╡ 3d2b5c02-768d-11eb-35bc-8f69edf2755b
function tap(duration::Real=0.02)
	run(`$(vibrate_path) -t $(string(duration))`)
	nothing
end

# ╔═╡ 9845f3ac-1b4a-458f-9e1d-480d0e20666d
let
	x
	@async tap()
end;

# ╔═╡ 162f0925-1d17-4192-820d-19d49f35145f
triple() = for i in 1:3
	tap()
	sleep(.05)
end

# ╔═╡ 702fabe3-57fc-43e4-854b-cbea571a5144
triple()

# ╔═╡ e85d41da-b785-4c06-9f49-7b681bd97782
if last_yint[] != yint
	@async tap()

	last_yint[] = yint
end;

# ╔═╡ 153636df-1bd5-4b80-8b0e-4e990f4bbf4e
md"""
### Getting the binary
"""

# ╔═╡ 29629129-dd36-473f-b37f-04862a3baeca
dir = mktempdir()

# ╔═╡ 0333465f-03a3-4722-aa07-bde09e8cfba5
binary_zip_path = download("https://github.com/lapfelix/ForceTouchVibrationCLI/releases/download/1.0/ForceTouchVibrationCLI.zip", joinpath(dir, "bin.zip"))

# ╔═╡ 2857614e-3fad-4661-82d3-ac0603cecdb7
unzip_process = run(`unzip -o $(binary_zip_path) -d $(dir)`)

# ╔═╡ 52400a66-020a-412a-a544-ca25e4cb6624
vibrate_path = let
	unzip_process
	joinpath(dir, "vibrate")
end

# ╔═╡ Cell order:
# ╟─191d9d94-10d9-4548-b452-1d70d9a5ea5e
# ╠═ce323f26-6373-453d-bf0c-4296ac0b83de
# ╠═9845f3ac-1b4a-458f-9e1d-480d0e20666d
# ╟─1209a862-dcb3-4318-a4a4-6609a0ebcaa4
# ╠═162f0925-1d17-4192-820d-19d49f35145f
# ╠═702fabe3-57fc-43e4-854b-cbea571a5144
# ╟─7b2d44fc-2cc5-421d-a9c1-739233d4f858
# ╟─666a7d32-a6f8-4856-b182-0268e6382ec8
# ╟─840ca3ba-d72b-429b-b79e-7b599c698365
# ╠═e85d41da-b785-4c06-9f49-7b681bd97782
# ╠═d9b11d6f-a459-428f-a0ac-a2d2e5c0575d
# ╠═63644f60-eeaf-4301-983c-51b8d0abcd9f
# ╟─19f84b62-237d-4b74-a8cc-1eba1674d786
# ╠═3d2b5c02-768d-11eb-35bc-8f69edf2755b
# ╟─153636df-1bd5-4b80-8b0e-4e990f4bbf4e
# ╠═29629129-dd36-473f-b37f-04862a3baeca
# ╠═0333465f-03a3-4722-aa07-bde09e8cfba5
# ╠═2857614e-3fad-4661-82d3-ac0603cecdb7
# ╠═52400a66-020a-412a-a544-ca25e4cb6624
