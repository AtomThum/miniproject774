using Plots
using LinearAlgebra

# Ellipse tracing algorithm
function rasterellipse(a, b)
    # Initial position of trace
    x = 0
    y = b

    points = Tuple{Int, Int}[] # Initialize a tuple to store the points in the ellipse
    a_sqr = a*a # Precalc for saving computation time
    b_sqr = b*b
    a_sqr2 = 2*a_sqr 
    b_sqr2 = 2*b_sqr
    p1 = b_sqr - b*a_sqr + 1/4*a_sqr # Given by the properties of the ellipse, p of the first section
    dx = 0 # Initialize the step in the x direction
    dy = a_sqr2 * b

    # Lower region mirror
    while dx < dy
        append!(points, [
            (x, y), (-x, y), (x, -y), (-x, -y)
        ])
        x += 1
        dx += b_sqr2
        if p1 < 0
            p1 += dx + b_sqr
        else
            y -= 1
            dy -= a_sqr2
            p1 += dx + b_sqr - dy
        end
    end

    # Upper region mirror
    p2 = b_sqr*(x + 1/2)^2 + a_sqr*(y - 1)^2 - a_sqr*b_sqr # p of the upper section
    while y >= 0
        append!(points, [
            (x, y), (-x, y), (x, -y), (-x, -y)
        ])
        y -= 1
        dy -= a_sqr2

        if p2 > 0
            p2 += a_sqr - dy
        else
            x += 1
            dx += b_sqr2
            p2 += a_sqr - dy + dx
        end
    end
    return points
end

# Wil be corrected later if possible
# Rotation algorithm for any set of points. (Very Incomplete)
function rotate(θ, setpoints)
    newpoints = Tuple{Int, Int}[]
    R = [cos(θ) -sin(θ); sin(θ) cos(θ)]
    for i in setpoints
        a = R * collect(i)
        floorx = floor(a[1])
        floory = floor(a[2])
        # ceilx = ceil(a[1])
        # ceily = ceil(a[2])
        push!(newpoints, (floorx, floory))
        # push!(newpoints, (ceilx, ceily))
    end
    return newpoints
end

# N is the maximum size of the ellipes that can fit in the middle of the circle
function mapping(setpoints, N)
    countx = 2*N + 1
    setvector = zeros(countx)
    minimap(x, y) = x + halfN 
    for i in setpoints
    end
    return setvector

majoraxis = 10
minoraxis = 10

ellipse = rasterellipse(majoraxis, minoraxis)

scatter(ellipse, aspect_ratio=:equal)
# scatter(rotate(π/6, ellipse))

# Sets of basis