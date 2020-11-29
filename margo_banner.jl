### A Pluto.jl notebook ###
# v0.12.14

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

# ╔═╡ 1e7e9d60-3241-11eb-3f49-8db89d2d40b0
begin
	
ENV["JULIA_MARGO_LOAD_PYPLOT"] = "no thank you"
import ClimateMARGO
using ClimateMARGO.Models
using ClimateMARGO.Optimization
using ClimateMARGO.Diagnostics
	
Base.range(d::Domain) = d.initial_year:d.dt:d.final_year
end

# ╔═╡ 15e02cc2-3242-11eb-3b71-0316d9afac82
using Plots

# ╔═╡ 1efc8f56-3244-11eb-3416-6b851923b623
using PlutoUI

# ╔═╡ 067f65a0-3241-11eb-35e9-f9abe962ba80
begin
	import Pkg
	Pkg.activate("/home/fons/MargoAPI.jl/")
end

# ╔═╡ 1020c652-3242-11eb-20df-494a2df49209
dt = 12

# ╔═╡ 2efeadce-3241-11eb-2bf7-8be78bdde4fd

function setfieldconvert!(value, name::Symbol, x)
    setfield!(value, name, convert(typeof(getfield(value, name)), x))
end

# ╔═╡ 36038a36-3241-11eb-2797-d1ebee92c01d
model_parameters = let
	mp = deepcopy(ClimateMARGO.IO.included_configurations["default"])
    mp.domain = Domain(Float64(dt), 2020.0, 2200.0)
    mp.economics.baseline_emissions = ramp_emissions(mp.domain)
    mp.economics.extra_CO₂ = zeros(size(mp.economics.baseline_emissions))
	mp
end

# ╔═╡ 2f780fa0-3243-11eb-000b-d9dffbead2b8
[1:2, LinRange(3.0,4.0,6)]

# ╔═╡ 1664dbd8-3243-11eb-07dd-e39c3b2a7361
t = model_parameters.domain |> range

# ╔═╡ 87585022-3243-11eb-2394-4901c981f9a4


# ╔═╡ 22236880-3244-11eb-351c-d1ff7c6f3a29
@bind M_val Slider(LinRange(0,1,1000))

# ╔═╡ f1d8742c-3246-11eb-2214-eb3760b7872b
@bind R_val Slider(LinRange(0,1,1000))

# ╔═╡ 5e186932-324a-11eb-243e-7d1fff8cf2e8


# ╔═╡ 0d2cdd58-3244-11eb-3770-c50db8c038e2
begin
	M = fill(0.0, size(t))
	M[6] = M_val
	M
end

# ╔═╡ 183b2650-3244-11eb-2576-9952e3588034
begin
	R = fill(0.0, size(t))
	R[9] = R_val
	R
end

# ╔═╡ ee85d59e-3243-11eb-25cb-a18ede72dcd8
controls = Controls(M, R, zeros(size(t)), zeros(size(t)))

# ╔═╡ 0a450efa-3242-11eb-0ab4-5792f1dcce6a
model = ClimateModel(model_parameters, controls)

# ╔═╡ 4113ef64-3242-11eb-3f6b-61a5504cc64a
function costs_dict(costs, model)
    Dict(
        :discounted => costs,
        :total_discounted => sum(costs .* model.domain.dt),
    )
end

# ╔═╡ 3992c788-3242-11eb-19c2-ed1b4c34a0db
model_results(model::ClimateModel) = Dict(
    :controls => model.controls,
    :computed => Dict(
        :temperatures => Dict(
            :baseline => T(model),
            :M => T(model; M=true),
            :MR => T(model; M=true, R=true),
            :MRG => T(model; M=true, R=true, G=true),
            :MRGA => T(model; M=true, R=true, G=true, A=true),
        ),
        :emissions => Dict(
            :baseline => effective_emissions(model),
            :M => effective_emissions(model; M=true),
            :MRGA => effective_emissions(model; M=true, R=true),
        ),
        :concentrations => Dict(
            :baseline => c(model),
            :M => c(model; M=true),
            :MRGA => c(model; M=true, R=true),
        ),
        :damages => Dict(
            :baseline => costs_dict(damage(model; discounting=true), model),
            :MRGA => costs_dict(damage(model; M=true, R=true, G=true, A=true, discounting=true), model),
        ),
        :costs => Dict(
            :M => costs_dict(cost(model; M=true, discounting=true), model),
            :R => costs_dict(cost(model; R=true, discounting=true), model),
            :G => costs_dict(cost(model; G=true, discounting=true), model),
            :A => costs_dict(cost(model; A=true, discounting=true), model),
            :MRGA => costs_dict(cost(model; M=true, R=true, G=true, A=true, discounting=true), model),
        ),
    ),
)

# ╔═╡ 4dec3f16-3242-11eb-13ac-0307174466c5
results = model_results(model)

# ╔═╡ f4950c9e-3242-11eb-16df-f1642dac8f9c
let
	p = plot(
		t, results[:computed][:emissions][:baseline], 
		lw=4, color=:gray,
		label="Baseline",
	)
	plot!(p, 
		t, results[:computed][:emissions][:MRGA], 
		lw=4, color=:red,
		label="Emissions",
	)
end

# ╔═╡ 609b469c-324a-11eb-02ba-418575075b41
same_expr_1(a::Any, b::Any) = a === b

# ╔═╡ 6804a9e4-324a-11eb-1cfb-954ebfe81aaf
same_expr_1(a::Expr, b::Expr) = 
	a.head === b.head && 
	length(a.args) == length(b.args) && 
	all(p -> same_expr_1(p[1],p[2]), zip(a.args,b.args))

# ╔═╡ d9fefbca-324b-11eb-1fde-1bb87979ed95
[2.0]

# ╔═╡ 7e445dea-324b-11eb-3c4e-cde9bc9ebf7e
expr_hash(e::Expr) = objectid(e.head) + mapreduce(expr_hash, +, e.args; init=UInt(0))

# ╔═╡ 8a2f7de0-324b-11eb-27f5-a529e94f9864
expr_hash(x) = objectid(x)

# ╔═╡ 85973cb0-324a-11eb-13d0-c1afba2d32b0
(:([4.0]), :([4])) .|> expr_hash

# ╔═╡ 91d13aac-324b-11eb-2c20-db7ffd1c3b90
same_expr_2(a,b) = expr_hash(a) === expr_hash(b)

# ╔═╡ 9e31101a-324b-11eb-39a2-71132d711272
same_expr = same_expr_2

# ╔═╡ 8140528c-324a-11eb-25e8-37c9bd76b58e
same_expr(:([0]), :([0]))

# ╔═╡ 7a62c256-324a-11eb-1105-0d538b82b613
same_expr_2(:([]), :([]))

# ╔═╡ Cell order:
# ╠═067f65a0-3241-11eb-35e9-f9abe962ba80
# ╠═1e7e9d60-3241-11eb-3f49-8db89d2d40b0
# ╠═15e02cc2-3242-11eb-3b71-0316d9afac82
# ╠═1020c652-3242-11eb-20df-494a2df49209
# ╠═2efeadce-3241-11eb-2bf7-8be78bdde4fd
# ╠═36038a36-3241-11eb-2797-d1ebee92c01d
# ╠═ee85d59e-3243-11eb-25cb-a18ede72dcd8
# ╠═0a450efa-3242-11eb-0ab4-5792f1dcce6a
# ╠═4dec3f16-3242-11eb-13ac-0307174466c5
# ╠═2f780fa0-3243-11eb-000b-d9dffbead2b8
# ╠═1664dbd8-3243-11eb-07dd-e39c3b2a7361
# ╠═87585022-3243-11eb-2394-4901c981f9a4
# ╠═22236880-3244-11eb-351c-d1ff7c6f3a29
# ╠═f1d8742c-3246-11eb-2214-eb3760b7872b
# ╠═f4950c9e-3242-11eb-16df-f1642dac8f9c
# ╠═5e186932-324a-11eb-243e-7d1fff8cf2e8
# ╠═0d2cdd58-3244-11eb-3770-c50db8c038e2
# ╠═183b2650-3244-11eb-2576-9952e3588034
# ╠═1efc8f56-3244-11eb-3416-6b851923b623
# ╠═3992c788-3242-11eb-19c2-ed1b4c34a0db
# ╠═4113ef64-3242-11eb-3f6b-61a5504cc64a
# ╠═609b469c-324a-11eb-02ba-418575075b41
# ╠═6804a9e4-324a-11eb-1cfb-954ebfe81aaf
# ╠═9e31101a-324b-11eb-39a2-71132d711272
# ╠═d9fefbca-324b-11eb-1fde-1bb87979ed95
# ╠═7a62c256-324a-11eb-1105-0d538b82b613
# ╠═8140528c-324a-11eb-25e8-37c9bd76b58e
# ╠═85973cb0-324a-11eb-13d0-c1afba2d32b0
# ╠═7e445dea-324b-11eb-3c4e-cde9bc9ebf7e
# ╠═8a2f7de0-324b-11eb-27f5-a529e94f9864
# ╠═91d13aac-324b-11eb-2c20-db7ffd1c3b90
