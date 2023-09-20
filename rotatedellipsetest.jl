using Plots
using LinearAlgebra

function rasteredrotatedellipse(a, b, θ)
    t = LinRange(0, 2π, 100)
    setpoints = Tuple{Int, Int}[]
    for i in t
        x(α) = a * cos(α) * sin(θ) - b * sin(α) * cos(θ)
        y(α) = a * cos(α) * sin(θ) + b * sin(α) * cos(θ)
        xRounded = round(Int, x(i))
        yRounded = round(Int, y(i))
        push!(setpoints, (xRounded, yRounded))
    end
    return setpoints
end

function rotatedellipse(a, b, θ)
    t = LinRange(0, 2π, 100)
    setpoints = Tuple{Float64, Float64}[]
    x(α) = a * cos(α) * sin(θ) - b * sin(α) * cos(θ)
    y(α) = a * cos(α) * sin(θ) + b * sin(α) * cos(θ)
    for i in t
        push!(setpoints, (x(i), y(i)))
    end
    return setpoints
end

a = 5
b = 5
θ = π/6

scatter(rasteredrotatedellipse(a, b, θ), aspect_ratio=:equal, gridlinewidth = 3)
plot!(rotatedellipse(a, b, θ))