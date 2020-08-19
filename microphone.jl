### A Pluto.jl notebook ###
# v0.11.6

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

# ╔═╡ fd61e5d6-e170-11ea-1456-952e2daf2181
using Plots

# ╔═╡ f4ce418a-e170-11ea-1252-f9298faada63
@bind audio HTML("""
<z id="player"></z>
<button class="button" id="stopButton">Stop</button>
<script>
const player = document.getElementById('player')
const stop = document.getElementById('stopButton')
	
const handleSuccess = function(stream) {
	const context = new AudioContext()
	const source = context.createMediaStreamSource(stream)
	const processor = context.createScriptProcessor(1024, 1, 1);


	source.connect(processor)
	processor.connect(context.destination)
	
	processor.onaudioprocess = function(e) {
		const data = e.inputBuffer.getChannelData(0)
	
		player.value = data
		player.dispatchEvent(new CustomEvent("input"))
		if(!document.body.contains(player)){
			processor.onaudioprocess = undefined
		}
    }
	
	stop.onclick = () => {processor.onaudioprocess = undefined}
}

navigator.mediaDevices.getUserMedia({ audio: true, video: false })
  .then(handleSuccess)
</script>
<style>
.button {
  background-color: darkred;
  border: none;
  border-radius: 12px;
  color: white;
  padding: 15px 32px;
  text-align: center;
  text-decoration: none;
  display: inline-block;
  font-size: 16px;
  font-family: "Alegreya Sans", sans-serif;
  margin: 4px 2px;
  cursor: pointer;
}
</style>
""")

# ╔═╡ 0b6110fa-e171-11ea-0193-d75ae3f1e14a
plot(audio*10, ylim=(-1,1))

# ╔═╡ Cell order:
# ╠═f4ce418a-e170-11ea-1252-f9298faada63
# ╠═fd61e5d6-e170-11ea-1456-952e2daf2181
# ╠═0b6110fa-e171-11ea-0193-d75ae3f1e14a
