### A Pluto.jl notebook ###
# v0.11.14

using Markdown
using InteractiveUtils

# ╔═╡ 091d33fe-fffe-11ea-131f-01f4248b30ea
@info "23"

# ╔═╡ 2d01cdaa-fffe-11ea-09f5-63527a1b0f87
x = 233564653

# ╔═╡ 2883b3d8-fffe-11ea-0a0f-bbd85ec665ea
begin
	
	
	
	try
		sqrt(-1)
	catch e
		@error "99" exception=(e, catch_backtrace())
	end
end

# ╔═╡ 3599eb82-0003-11eb-3814-dfd0f5737846
for i in 1:10
	
	@debug i
	
	if isodd(i)
		@warn "Oh no!" i
	end
end

# ╔═╡ Cell order:
# ╠═091d33fe-fffe-11ea-131f-01f4248b30ea
# ╠═2d01cdaa-fffe-11ea-09f5-63527a1b0f87
# ╠═2883b3d8-fffe-11ea-0a0f-bbd85ec665ea
# ╠═3599eb82-0003-11eb-3814-dfd0f5737846
