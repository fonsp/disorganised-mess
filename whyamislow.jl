# launch me like:
# julia --project=~/Documents/Pluto.jl whyamislow.jl

for i in 1:3
    println()
end

include(expanduser("~/Documents/Pluto.jl/src/runner/PlutoRunner.jl"))

N = (a = 1, b = 2)

@info "Warmup"
PlutoRunner.format_output(1)

# for m in ["Starting", "Second time"]
#     @info m
#     @time PlutoRunner.format_output([])
#     @time PlutoRunner.format_output([1])
#     @time PlutoRunner.format_output(["asdf"])
#     @time PlutoRunner.format_output([[]])
#     @time PlutoRunner.format_output([[[]]])
#     # @time PlutoRunner.format_output([[[[]]]])
# end


for m in ["Starting", "Second time"]
    @info m
    # @time PlutoRunner.show_richest(devnull, [[[Ref(123)]]])
    # @time PlutoRunner.format_output_default([[[Ref(123)]]])
    @time PlutoRunner.format_output([[[Ref(123)]]])

    if false
        asdfasdf(:(struct A end))
    end
end


for i in 1:3
    println()
end