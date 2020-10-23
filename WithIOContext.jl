### A Pluto.jl notebook ###
# v0.12.4

using Markdown
using InteractiveUtils

# ╔═╡ 215bc950-1517-11eb-3576-f9b6e8d16cac
begin
	using Revise
	using PlutoUI
end

# ╔═╡ 421f16b6-1516-11eb-2821-dda502c6487f
x = rand(100,100)

# ╔═╡ fdd66f6c-1516-11eb-06a9-6371e3e64ce3
struct WithIOContext
	x
	context_properties
end

# ╔═╡ cc8395ce-1517-11eb-1ab1-a5bcc9aac90c
function Base.show(io::IO, m::MIME"text/plain", w::WithIOContext)
	Base.show(IOContext(io, w.context_properties...), m, w.x)
end

# ╔═╡ 37dbe416-1518-11eb-348f-bfb890ad3276
WithIOContext(x, [:compact => true])

# ╔═╡ 57eb86c6-1518-11eb-040b-ed690d827003
WithIOContext(x, [:compact => false])

# ╔═╡ Cell order:
# ╠═421f16b6-1516-11eb-2821-dda502c6487f
# ╠═215bc950-1517-11eb-3576-f9b6e8d16cac
# ╠═fdd66f6c-1516-11eb-06a9-6371e3e64ce3
# ╠═cc8395ce-1517-11eb-1ab1-a5bcc9aac90c
# ╠═37dbe416-1518-11eb-348f-bfb890ad3276
# ╠═57eb86c6-1518-11eb-040b-ed690d827003
