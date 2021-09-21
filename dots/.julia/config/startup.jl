try
    using Revise
catch e
    @warn "Error initializing Revise" exception=(e, catch_backtrace())
end

atreplinit() do repl
    try
        @eval using OhMyREPL
    catch e
        @warn "Error initializing OhMyREPL" e
    end
end
