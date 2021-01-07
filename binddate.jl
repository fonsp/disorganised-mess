### A Pluto.jl notebook ###
# v0.11.14

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

# ╔═╡ 41a359a6-fa11-11ea-0294-bf32db6f7eaf
using Revise

# ╔═╡ 4722d5a0-fa11-11ea-37b9-19ef171e5a0e
using PlutoUI

# ╔═╡ 78c032a8-fa0a-11ea-186a-af2bdc276ead
using Dates

# ╔═╡ 80526804-fa11-11ea-06ab-713378dac806
@bind x PlutoUI.PasswordField()

# ╔═╡ 87fb8e14-fa11-11ea-2cbb-7544da359918
x

# ╔═╡ 0a5170ca-fa05-11ea-0f0b-0d488f112ca4
@bind date html"<input type='datetime-local'>"

# ╔═╡ 29f161b0-fa14-11ea-15a3-ebf395b1a512
@bind ddd PlutoUI.TimeField()

# ╔═╡ 50bb30c8-fa14-11ea-130f-49263f5155a9
ddd

# ╔═╡ 3bda74d4-fa05-11ea-2482-f3e288aedb77
date

# ╔═╡ 8e7bc97c-fa05-11ea-2a72-8d43af5d5761
@bind alsodate html"""
<div id="asdf"></div>
<script>

const d = this.querySelector("#asdf")
d.value = new Date()
d.dispatchEvent(new CustomEvent("input"))
</script>
"""

# ╔═╡ dfa424ee-fa13-11ea-1668-9fa78d76708e
Dates.format(alsodate, "Y-m-d")

# ╔═╡ 60bbf45a-fa0d-11ea-205e-c1f4bf609f1e
alsodate

# ╔═╡ ac32fc4c-fa05-11ea-28de-2d6b57df08aa
alsodate

# ╔═╡ 42905006-fa09-11ea-3d72-d7633d429c7b
ttt = reinterpret(Int64, alsodate)[1]

# ╔═╡ 7db3e05c-fa0a-11ea-00de-21349ec175cb
Dates.DateTime(ttt)

# ╔═╡ 60c9eabe-fa09-11ea-381c-b13b0fddba9a
Dates.DateTime(1970) + Dates.Millisecond(ttt)

# ╔═╡ f1d2a8bc-fa08-11ea-0cf1-85d5d5861866
v = 1600472743808.0

# ╔═╡ 1ba8298c-fa09-11ea-33c2-5f07df63e315
reinterpret(UInt8, [v])

# ╔═╡ Cell order:
# ╠═41a359a6-fa11-11ea-0294-bf32db6f7eaf
# ╠═4722d5a0-fa11-11ea-37b9-19ef171e5a0e
# ╠═80526804-fa11-11ea-06ab-713378dac806
# ╠═87fb8e14-fa11-11ea-2cbb-7544da359918
# ╠═0a5170ca-fa05-11ea-0f0b-0d488f112ca4
# ╠═29f161b0-fa14-11ea-15a3-ebf395b1a512
# ╠═50bb30c8-fa14-11ea-130f-49263f5155a9
# ╠═dfa424ee-fa13-11ea-1668-9fa78d76708e
# ╠═3bda74d4-fa05-11ea-2482-f3e288aedb77
# ╠═60bbf45a-fa0d-11ea-205e-c1f4bf609f1e
# ╠═8e7bc97c-fa05-11ea-2a72-8d43af5d5761
# ╠═ac32fc4c-fa05-11ea-28de-2d6b57df08aa
# ╠═42905006-fa09-11ea-3d72-d7633d429c7b
# ╠═78c032a8-fa0a-11ea-186a-af2bdc276ead
# ╠═7db3e05c-fa0a-11ea-00de-21349ec175cb
# ╠═60c9eabe-fa09-11ea-381c-b13b0fddba9a
# ╠═f1d2a8bc-fa08-11ea-0cf1-85d5d5861866
# ╠═1ba8298c-fa09-11ea-33c2-5f07df63e315
