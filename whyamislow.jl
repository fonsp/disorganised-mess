# launch me like:
# julia --project=~/Documents/Pluto.jl whyamislow.jl

for i in 1:3
    println()
end

include(expanduser("~/Documents/Pluto.jl/src/runner/PlutoRunner.jl"))

N = (a = 1, b = 2)

@info "Warmup"
PlutoRunner.format_output(1)

struct A x end
struct B x end
struct C x end
struct D x end
struct E x end
struct F x end
struct G x end
struct H x end

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

    io = IOContext(IOBuffer())

    @time PlutoRunner.format_output([[[[A(123)]]]])
    @time PlutoRunner.format_output([[[[B(123)]]]])
    @time PlutoRunner.format_output(C(123))
    @time PlutoRunner.format_output(D(123))
    @time PlutoRunner.show_richest(io, G(123))
    @time PlutoRunner.show_richest(io, H(123))
    @time PlutoRunner.tree_data(E(123), io)
    @time PlutoRunner.tree_data(F(123), io)

    if false
        asdfasdf(:(struct A end))
    end
end


for i in 1:3
    println()
end