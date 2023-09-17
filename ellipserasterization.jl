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

# Translate a set of matrices
function translate(setpoints, xtransposed, ytransposed)
    newpoints = Tuple{Int, Int}[]
    for i in setpoints
        a = collect(i)
        x = a[1] + xtransposed
        y = a[2] + ytransposed
        push!(newpoints, (x, y))
    end
end

# Creating a column matrix for concatenation
map(n, gridsize, x, y) = x + n + 1 - gridsize*(y - n)
function vectorize(n, setpoints)
    gridsize = 2*n + 1
    vect = zeros(gridsize^2, 1)
    for i in setpoints
        x, y = i[1], i[2]
        if abs(x) > gridsize || abs(y) > gridsize
        else
            vect[map(n, gridsize, x, y)] = 1
        end
    end
    return vect
end

# ellipse = rasterellipse(majoraxis, minoraxis)

# scatter(ellipse, aspect_ratio=:equal)
# display(vectorize(10, ellipse))

n = 5 # 2n + 1 = gridsize
N = (2*n + 1)^2
# Defining basis
major_axis_basis = range(1, 5)

# Generating a matrix with the basis
minor_axis_basis = 3
basisMatrix = Array{Float64}(undef, N)
for i in major_axis_basis
    global n
    global basisMatrix
    tempEllipse = rasterellipse(i, minor_axis_basis)
    tempVect = vectorize(n, tempEllipse)
    basisMatrix = hcat(basisMatrix, tempVect)
end

display(basisMatrix)