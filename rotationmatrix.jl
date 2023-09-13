using Plots
using LinearAlgebra

# Points used for testing
init = [(1, 1), (2, 3), (5, -4)]
display(init)

# Rotation matrix = [(cosθ, -sinθ), (sinθ, cosθ)]
rotate(θ) = [cos(θ) -sin(θ); sin(θ) cos(θ)]

points = Tuple{Int, Int}[]
for i in init
    global rotate
    a = rotate(1/3*π) * collect(i)
    push!(points, (round(a[1]), round(a[2])))
end

display(points)

scatter(init)
scatter!(points)