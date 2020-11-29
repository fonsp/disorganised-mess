include("/home/fons/Pluto.jl/src/runner/PlutoRunner.jl")

N = (a = 1, b = 2)

@info "Warmup"
PlutoRunner.format_output(1)

for m in ["Starting", "Second time"]
    @info m
    @time PlutoRunner.format_output([])
    @time PlutoRunner.format_output([1])
    @time PlutoRunner.format_output(["asdf"])
    @time PlutoRunner.format_output([[]])
    @time PlutoRunner.format_output([[[]]])
    # @time PlutoRunner.format_output([[[[]]]])
end
