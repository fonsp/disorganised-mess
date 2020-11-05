try
    println("Press Ctrl+C to stop me")
    while true end
catch e
    @info "Caught" e
    @show e isa InterruptException
end