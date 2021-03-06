### A Pluto.jl notebook ###
# v0.14.0

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

# ╔═╡ 1f749338-7d31-11eb-1f21-557dad92b247
using PlutoUI

# ╔═╡ 27635f66-207b-479b-beff-8781d2f993b8
@bind code TextField((40,10))

# ╔═╡ 7969e1bf-36c8-49e9-8099-ffacf03a3520
parsed = Meta.parse(code) |> Base.remove_linenums!

# ╔═╡ 72e8d78f-300b-4e4f-ab29-51b28f790e4c
sprint(dump, parsed) |> Text

# ╔═╡ 31235af3-cf8f-4a0c-8985-d5fe11889547


# ╔═╡ Cell order:
# ╠═1f749338-7d31-11eb-1f21-557dad92b247
# ╠═27635f66-207b-479b-beff-8781d2f993b8
# ╠═72e8d78f-300b-4e4f-ab29-51b28f790e4c
# ╠═7969e1bf-36c8-49e9-8099-ffacf03a3520
# ╠═31235af3-cf8f-4a0c-8985-d5fe11889547
