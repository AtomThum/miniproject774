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

# Wil be corrected later if possible
# Rotation algorithm for any set of points. (Very Incomplete)
function rotate(θ, setpoints)
    if θ == 0
        return setpoints
    end
    newpoints = Tuple{Int,Int}[]
    rotationMatrix = [cos(θ) -sin(θ); sin(θ) cos(θ)]
    for i in setpoints
        a = rotationMatrix * collect(i)
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
function translate(xTransposed, yTransposed, setpoints)
    if xTransposed == 0 && yTransposed == 0
        return setpoints
    end
    newpoints = Tuple{Int,Int}[]
    for i in setpoints
        a = collect(i)
        x = a[1] + xTransposed
        y = a[2] + yTransposed
        push!(newpoints, (x, y))
    end
end

# Creating a column matrix for concatenation
map(n, gridsize, x, y) = x + n + 1 - gridsize * (y - n)
function vectorize(n, setpoints)
    gridsize = 2 * n + 1
    vect = zeros(gridsize^2, 1)
    for i in setpoints
        x, y = i[1], i[2]
        if map(n, gridsize, x, y) > gridsize
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
N = (2 * n + 1)^2
# Defining basis
majorAxisBasis = range(1, 5)
minorAxisBasis = range(1, 5)
anglesBasis = range(0, 180, 20)
transpositionBasis = [(0, 0), (3, 3), (-3, -3), (-3, 3), (3, -3)]
# Generating a matrix with the basis
basisMatrix = Array{Float64}(undef, N)
for major in majorAxisBasis
    for minor in minorAxisBasis
        for angles in anglesBasis
            for trans in transpositionBasis
                global n
                global basisMatrix
                translatedX = trans[1]
                translatedY = trans[2]
                tempEllipse = rotate(deg2rad(angles), rasterellipse(major, minor))
                translatedEllipse = translate(translatedX, translatedY, tempEllipse)
                tempVect = vectorize(n, tempEllipse)
                basisMatrix = hcat(basisMatrix, tempVect)
            end
        end
    end
end

display(basisMatrix)
pseudoInverseMatrix = pinv(basisMatrix) # Calculate pseudoinverse
display(pseudoInverseMatrix)

pictureVector = rand(Float64, (121, 1))
display(pictureVector)

lineThickness = normalize(pseudoInverseMatrix * pictureVector)
display(lineThickness)