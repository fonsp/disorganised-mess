ccall(:jl_exit_on_sigint, Cvoid, (Cint,), 0)

try
    println("Press Ctrl+C to stop me")
    sleep(60)
catch e
    @info "Caught" e
    @show e isa InterruptException
end