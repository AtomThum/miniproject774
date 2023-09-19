using Plots
using LinearAlgebra

# Ellipse tracing algorithm
function rasterellipse(a, b)
    # Initial position of trace
    x = 0
    y = b

    points = Tuple{Int,Int}[] # Initialize a tuple to store the points in the ellipse
    aSqr = a * a # Precalc for saving computation time
    bSqr = b * b
    aSqr2 = 2 * aSqr
    bSqr2 = 2 * bSqr
    p1 = bSqr - b * aSqr + 1 / 4 * aSqr # Given by the properties of the ellipse, p of the first section
    dx = 0 # Initialize the step in the x direction
    dy = aSqr2 * b

    # Lower region mirror
    while dx < dy
        append!(points, [
            (x, y), (-x, y), (x, -y), (-x, -y)
        ])
        x += 1
        dx += bSqr2
        if p1 < 0
            p1 += dx + bSqr
        else
            y -= 1
            dy -= aSqr2
            p1 += dx + bSqr - dy
        end
    end

    # Upper region mirror
    p2 = bSqr * (x + 1 / 2)^2 + aSqr * (y - 1)^2 - aSqr * bSqr # p of the upper section
    while y >= 0
        append!(points, [
            (x, y), (-x, y), (x, -y), (-x, -y)
        ])
        y -= 1
        dy -= aSqr2

        if p2 > 0
            p2 += aSqr - dy
        else
            x += 1
            dx += bSqr2
            p2 += aSqr - dy + dx
        end
    end
    return points
end

function rotate(θ, setpoints)
    if θ == 0
        return setpoints
    end
    newpoints = Tuple{Int,Int}[]
    rotationMatrix = [cos(θ) -sin(θ); sin(θ) cos(θ)]
    for i in setpoints
        a = rotationMatrix * collect(i)
        truncx = round(Int64, a[1])
        truncy = round(Int64, a[2])
        push!(newpoints, (truncx, truncy))
    end
    return newpoints
end

scatter(rotate(π/12, rasterellipse(20, 10)))