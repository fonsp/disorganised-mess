### A Pluto.jl notebook ###
# v0.12.3

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

# ╔═╡ cf4a9334-0c9b-11eb-29e7-55615b7e91be
begin
	ENV["JULIA_MARGO_LOAD_PYPLOT"] = "no thank you"
	import ClimateMARGO
	using ClimateMARGO.Models
	using ClimateMARGO.Optimization
	using ClimateMARGO.Diagnostics
end

# ╔═╡ 2c9f3654-0c9c-11eb-0c04-25f8b21c31a3
using Plots

# ╔═╡ 81a40932-0c9e-11eb-11fb-bd426c8b8f5c
using PlutoUI

# ╔═╡ 44b9adaa-0ca1-11eb-3f8a-3f0c89b8a434
Dict(1 => 2, Dict(3=>4)...)

# ╔═╡ 7f2e0f12-0c9c-11eb-165e-2dab4b00162e
dt = 10

# ╔═╡ 10b2d4de-0c9d-11eb-3b01-755a22baf34d
(1:.2:3) |> typeof

# ╔═╡ 1d37e7ee-0c9d-11eb-3539-a147e3280096
subtypes(AbstractRange)

# ╔═╡ 40377b80-0c9d-11eb-0f44-e71bb554de67
testy = 1:.2:3

# ╔═╡ 2a2a1244-0c9d-11eb-0121-734969b91fc1
torange(d::Domain) = d.initial_year:d.dt:d.final_year

# ╔═╡ 06183ec4-0c9d-11eb-2bde-8b7e96377140
Base.collect(d::Domain) = collect(torange(d))

# ╔═╡ 85d0cec6-0c9d-11eb-0360-4fa37823a93f


# ╔═╡ 3681d71e-0c9c-11eb-0cbe-57e065160c9a
model_parameters = let
	p = deepcopy(ClimateMARGO.IO.included_configurations["default"])
	p.domain = Domain(Float64(dt), 2020.0, 2200.0)
	p.economics.baseline_emissions = ramp_emissions(p.domain)
	p.economics.extra_CO₂ = zeros(size(p.economics.baseline_emissions))
	p
end

# ╔═╡ ee33868c-0c9c-11eb-29b9-a96afaee41db
t = collect(model_parameters.domain)

# ╔═╡ 86d5f72a-0c9c-11eb-2c1b-4d27ae33ef8b
# model = let
# 	m = ClimateModel(model_parameters)
# 	m.controls.mitigate = sqrt(1/2π) / M_std * exp.(-0.5 * ((t .- M_mean) / M_std).^2)
# 	m
# end

# ╔═╡ 3249d39a-0c9f-11eb-080b-33dc0ba5415a
# model = let
# 	m = ClimateModel(model_parameters)
# 	m.controls.mitigate = sqrt(1/2π) / M_std * exp.(-0.5 * ((t .- M_mean) / M_std).^2)
# 	m
# end

# ╔═╡ 3c5c891c-0ca0-11eb-2dec-f9edd826a087
function gauss_one(t, mean, std)
	exp.(-0.5 * ((t .- mean) / std).^2)
end

# ╔═╡ 7a18fb72-0c9e-11eb-3b2f-83c084d6d69d
@bind M_mean Slider(torange(model_parameters.domain))

# ╔═╡ a219464a-0c9e-11eb-2340-23e32a781374
@bind M_std Slider(1:100)

# ╔═╡ 8f3adf8a-0c9e-11eb-0bb3-0393c8f07bc1
@bind M_magnitude Slider(0.0:0.01:1.0)

# ╔═╡ 8af3bde4-0c9f-11eb-0787-1da90705b6a0
model = let
	m = ClimateModel(model_parameters)
	m.controls.mitigate = M_magnitude * gauss_one(t, M_mean, M_std)
	m
end

# ╔═╡ 8eb8885e-0c9c-11eb-32d5-73435fecad9d
model.controls

# ╔═╡ 28d8c1e2-0ca2-11eb-0422-c752a17b073d
ClimateMARGO.IO.JSON2.write(model.controls.mitigate)

# ╔═╡ a776f150-0c9c-11eb-3d4f-01a7f9af049d
let
	M = plot(t, model.controls.mitigate, ylim=(0,1))
	temp = plot(t, T(model; M=true, R=true, G=true, A=true), ylim=(0,5))
	plot(M, temp, layout=(2,1), link=:x)
end

# ╔═╡ e9fbf4da-0c9c-11eb-2af9-dbf299ae96e6


# ╔═╡ Cell order:
# ╠═cf4a9334-0c9b-11eb-29e7-55615b7e91be
# ╠═2c9f3654-0c9c-11eb-0c04-25f8b21c31a3
# ╠═81a40932-0c9e-11eb-11fb-bd426c8b8f5c
# ╠═44b9adaa-0ca1-11eb-3f8a-3f0c89b8a434
# ╠═7f2e0f12-0c9c-11eb-165e-2dab4b00162e
# ╠═10b2d4de-0c9d-11eb-3b01-755a22baf34d
# ╠═1d37e7ee-0c9d-11eb-3539-a147e3280096
# ╠═40377b80-0c9d-11eb-0f44-e71bb554de67
# ╠═2a2a1244-0c9d-11eb-0121-734969b91fc1
# ╠═06183ec4-0c9d-11eb-2bde-8b7e96377140
# ╠═85d0cec6-0c9d-11eb-0360-4fa37823a93f
# ╠═ee33868c-0c9c-11eb-29b9-a96afaee41db
# ╠═3681d71e-0c9c-11eb-0cbe-57e065160c9a
# ╠═86d5f72a-0c9c-11eb-2c1b-4d27ae33ef8b
# ╠═3249d39a-0c9f-11eb-080b-33dc0ba5415a
# ╠═8af3bde4-0c9f-11eb-0787-1da90705b6a0
# ╠═3c5c891c-0ca0-11eb-2dec-f9edd826a087
# ╠═8eb8885e-0c9c-11eb-32d5-73435fecad9d
# ╠═7a18fb72-0c9e-11eb-3b2f-83c084d6d69d
# ╠═a219464a-0c9e-11eb-2340-23e32a781374
# ╠═8f3adf8a-0c9e-11eb-0bb3-0393c8f07bc1
# ╠═28d8c1e2-0ca2-11eb-0422-c752a17b073d
# ╠═a776f150-0c9c-11eb-3d4f-01a7f9af049d
# ╠═e9fbf4da-0c9c-11eb-2af9-dbf299ae96e6
