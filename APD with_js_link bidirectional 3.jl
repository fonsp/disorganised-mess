### A Pluto.jl notebook ###
# v0.19.40

using Markdown
using InteractiveUtils

# ╔═╡ 49786782-88c7-11ee-361d-9578fba566f6
using Pkg

# ╔═╡ 4b9adb89-a54b-4cba-9091-79c81168560d
Pkg.activate()

# ╔═╡ 3813b59a-0ca1-41c0-8d5d-559a5b7b1290
using AbstractPlutoDingetjes

# ╔═╡ 78a32b95-d502-4e96-b074-a1d07e5a51a5
using HypertextLiteral

# ╔═╡ 31c03827-9c7a-45ba-aec4-d45794f3e93f
import AbstractPlutoDingetjes.Display.with_js_link

# ╔═╡ 3b5f9c8b-200b-4f26-a48e-faf28a6bf80a
# let
# 	messages_to_js = Channel()
# 	send_to_js(msg) = put!(messages_to_js, msg)


# 	function get_next_message(_ignore)
# 		take!(messages_to_js)
# 	end


# 	@async begin
# 		sleep(5)
# 		for i in 1:10
# 			send_to_js(i)
# 			sleep(.3)
# 		end
# 	end
	


# 	@htl("""
# 	<script>
# 	const get_next_msg_from_julia = $(AbstractPlutoDingetjes.Display.with_js_link(get_next_message))

# 		let running = true
# 		let messages = async function* () {
# 			while(running) {
# 				yield await get_next_msg_from_julia()
# 			}
# 		}
# 		invalidation.then(() => {
# 			running = false
# 		})

# 		for await (const msg of messages()) {
# 			console.log(msg)
# 		}

# </script>
# """)

# end

# ╔═╡ 7db59ac0-2c7f-4be7-bdb7-19af83fe82eb
begin
	struct JSGeneratorFinish end
	
	struct JSGenerator
		APDlink
		channel::Dict{String,Channel}
	end

	function Base.put!(jsg::JSGenerator, msg)
		for c in values(jsg.channel)
			put!(c, msg)
		end
	end

	function Base.show(io::IO, m::MIME"text/javascript", wjl::JSGenerator)
		write(io, """(() => {
		let myname = `\${Math.random()}`
		let messages = async function* () {
			while(true) {
				let next = await """)
		show(io, m, wjl.APDlink)
		write(io, """(myname);
				if(next === `__jsgen_stop`) return;
				yield next;
			}
		};
		let gen = messages();
		
		invalidation.then(async () => {
			console.log("stopping! 1")
			gen.return()
			console.log("stopping! 2")
		});
		return gen;
		})()""")
	end

	function link_from_julia()
		messages_to_js = Dict{String,Channel}()
		running_ref = Ref{Bool}(true)
	
		function get_next_message(connection_id)
			if running_ref[]
				channel = get!(() -> Channel(1), messages_to_js, connection_id)
				
				# state[] *= "\nwaiting"
				# @debug "waiting"
				next = take!(channel)
				# @info "done!" next
				# state[] *= "\ndone $(next)"
				
				if next === JSGeneratorFinish()
					"__jsgen_stop"
				else
					next
				end
			else
				"__jsgen_stop"
			end
		end
	
		function stop_generator()
			# @debug "stopping"
			# state[] *= "\nstopping"
			if running_ref[]
				running_ref[] = false
	
				for c in values(messages_to_js)
					if !isready(c)
						put!(c, JSGeneratorFinish())
					end
				end
				# state[] *= "\nstopped"
			end
			
		end
	
		js_generator = JSGenerator(
			AbstractPlutoDingetjes.Display.with_js_link(get_next_message, stop_generator),
			messages_to_js,
		)
		
		return js_generator
	end
end

# ╔═╡ 4d1057f7-c033-4bcb-9b81-a93d96c1a1f8
let
	c = Channel(1)
	@info "a" isready(c)
	put!(c, 1)
	@info "a" isready(c)
	take!(c)
	@info "a" isready(c)
end

# ╔═╡ 9b58eaa7-0cda-4e29-ab11-ed03f40a1c11
state = Ref("")

# ╔═╡ 7ece8b4f-d929-4629-b395-56c98bf14de9
let
	link = link_from_julia()

	@async try
		sleep(5)
		for i in 1:10
			put!(link, i)
			sleep(.3)
		end
	catch e
		@error "gvd" exception=e
	end

	@htl("""
	<script>
	for await (const msg of $(link)) {
		console.log(msg)
	}
	
	</script>
	""")
end

# ╔═╡ 9edfc363-c5a9-43b1-94fc-2cd63171ba34
state[] |> Text

# ╔═╡ 24d5cf8a-439c-4b99-a8d6-2f03aefb9658


# ╔═╡ cbf6498f-abcf-4d1e-9f03-364aad4d0db5
BUT THIS ONLY WORKS FOR ONE CLIENT

WHCIH it should

but right now the messages go "randomly" to one of the clients

# ╔═╡ 3ff49038-6945-4eb4-8ac7-81ac7531572b


# ╔═╡ 274f0781-26d5-49f6-8306-d81129b8afaf


# ╔═╡ 9985a237-33bd-441f-afda-26c23d351dd5


# ╔═╡ 964d0060-9ed0-4824-a92c-1ae20c25c288


# ╔═╡ e041300e-a263-4eca-976a-0a00c25ae318


# ╔═╡ 9542b8ab-c442-45c9-8f9e-6e710ed71bbb


# ╔═╡ 24aad28b-8f4e-484f-8301-0c9205a40d66


# ╔═╡ e9f1432c-2256-42ef-8a80-08d8b0f8b6a7


# ╔═╡ af870486-fd6c-40cb-861a-1cf50aaed29b


# ╔═╡ c30f2819-5c76-4ac7-b962-e7d465f652b9


# ╔═╡ fbd43578-2061-4bf0-a87c-e193a42998ca


# ╔═╡ 80d9b34a-a118-437d-954b-bec3be94273f


# ╔═╡ Cell order:
# ╠═49786782-88c7-11ee-361d-9578fba566f6
# ╠═4b9adb89-a54b-4cba-9091-79c81168560d
# ╠═3813b59a-0ca1-41c0-8d5d-559a5b7b1290
# ╠═31c03827-9c7a-45ba-aec4-d45794f3e93f
# ╠═78a32b95-d502-4e96-b074-a1d07e5a51a5
# ╠═3b5f9c8b-200b-4f26-a48e-faf28a6bf80a
# ╠═4d1057f7-c033-4bcb-9b81-a93d96c1a1f8
# ╠═7db59ac0-2c7f-4be7-bdb7-19af83fe82eb
# ╠═9b58eaa7-0cda-4e29-ab11-ed03f40a1c11
# ╠═7ece8b4f-d929-4629-b395-56c98bf14de9
# ╠═9edfc363-c5a9-43b1-94fc-2cd63171ba34
# ╠═24d5cf8a-439c-4b99-a8d6-2f03aefb9658
# ╠═cbf6498f-abcf-4d1e-9f03-364aad4d0db5
# ╠═3ff49038-6945-4eb4-8ac7-81ac7531572b
# ╠═274f0781-26d5-49f6-8306-d81129b8afaf
# ╠═9985a237-33bd-441f-afda-26c23d351dd5
# ╠═964d0060-9ed0-4824-a92c-1ae20c25c288
# ╠═e041300e-a263-4eca-976a-0a00c25ae318
# ╠═9542b8ab-c442-45c9-8f9e-6e710ed71bbb
# ╠═24aad28b-8f4e-484f-8301-0c9205a40d66
# ╠═e9f1432c-2256-42ef-8a80-08d8b0f8b6a7
# ╠═af870486-fd6c-40cb-861a-1cf50aaed29b
# ╠═c30f2819-5c76-4ac7-b962-e7d465f652b9
# ╠═fbd43578-2061-4bf0-a87c-e193a42998ca
# ╠═80d9b34a-a118-437d-954b-bec3be94273f
