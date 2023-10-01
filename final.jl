using Plots
using LinearAlgebra
using Colors # For heatmapping
using DelimitedFiles

#### Functions

# Ellipse tracing algorithm
function rasterellipse(a, b)
    # Initial position of trace
    x = 0
    y = b

    points = Tuple{Int, Int}[] # Initialize a tuple to store the points in the ellipse
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
# Rotation algorithm for any set of points. Used to rotate ellipses to generate a rotated basis (Very Incomplete)
function rotate(θ, setpoints)
    if θ == 0
        return setpoints
    end
    newpoints = Tuple{Int,Int}[]
    rotationMatrix = [cos(θ) -sin(θ); sin(θ) cos(θ)]
    for i in setpoints
        a = rotationMatrix * collect(i)
        floorx = round(Int, a[1])
        floory = round(Int, a[2])
        push!(newpoints, (floorx, floory))
    end
    return newpoints
end

# A function to translate every points in a matrix by xTr
function translate(xTransposed, yTransposed, setpoints)
    if xTransposed == 0 && yTransposed == 0
        return setpoints
    else
        newpoints = Tuple{Int,Int}[]
        for i in setpoints
            a = collect(i)
            x = a[1] + xTransposed
            y = a[2] + yTransposed
            push!(newpoints, (x, y))
        end
    end
    return newpoints
end

# Mapping onto vector and invert it into matrix grid form
map(n, gridsize, x, y) = x + n + 1 - gridsize * (y - n)
function inverseMap(n, setpoints)
    gridsize = 2 * n + 1
    points = Array{Float64}(undef, gridsize, gridsize)
    counter = 1
    for i in setpoints
        if mod(counter, gridsize) == 0
            xIndex = gridsize
        else
            xIndex = mod(counter, gridsize)
        end
        yIndex = ceil(Int64, counter / gridsize)
        points[yIndex, xIndex] = i
        counter += 1
    end
    return points
end
# Creating a column matrix for concatenation
function vectorize(n, setpoints)
    gridsize = 2 * n + 1
    vect = zeros(gridsize^2, 1)
    for i in setpoints
        x, y = i[1], i[2]
        try
            vect[map(n, gridsize, x, y)] = 1
        catch
            0
        end
    end
    return vect
end

function myNormalizedVector(setpoints::Matrix{Float64}, a::Float64 = 0.0, b::Float64 = 1.0)
    minValue = minimum(setpoints)
    maxValue = maximum(setpoints)

    if minValue == maxValue
        return fill((a + b) / 2, size(setpoints))
    else
        return a .+ ((setpoints .- minValue) / (maxValue - minValue)) .* (b - a)
    end
end

function basisConstruction(n::Int)
    coordinates = Tuple{Int, Int}[]
    for row in -n:n
        for col in -n:n
            push!(coordinates, (row, col))
        end
    end
    return tuple(coordinates...)
end

#### Input arguments

n = 10 # n → amount of pixels from 0 to max(x)
N = (2 * n + 1)^2 # Amount of pixels
pictureVector = readdlm("img.txt")

#### Processing
majorAxisBasis = range(0, 10)
minorAxisBasis = range(0, 10)
anglesBasis = range(0, 90, 5)
transpositionBasis = [(0, 0), (-2, 1), (2, 2), (0, -3)]

basisMatrix = zeros(N, 1) # Initiate a matrix that will be filled with basis vectors
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
                tempVect = vectorize(n, translatedEllipse)
                basisMatrix = hcat(basisMatrix, tempVect)
            end
        end
    end
end

# Printing the basis matrix
println("Basis Matrix:")
display(basisMatrix)

# Printing the line thickness vector (skipped Pseudoinverse)
println("Line Thickness Vector:")
lineThickness = (basisMatrix \ pictureVector)

# Vector form of the final picture
pictureTransformed = basisMatrix * lineThickness

finalPixelsArray = myNormalizedVector(inverseMap(n, pictureTransformed)) # Invert it into an array form

originalImage = Gray.(inverseMap(n, pictureVector))
finalImage = Gray.(finalPixelsArray) # Creating a grayscaled image

plot1 = plot(heatmap(finalImage), size=(N, N), color=:grays) # Plotting the finalized image
plot2 = plot(heatmap(originalImage), size=(N, N), color=:grays)

println("Picture vector:")
display(pictureVector)

println("Line thickness:")
display(myNormalizedVector(lineThickness))

plot(plot1, plot2, layout=(1, 2), size=(500, 250))