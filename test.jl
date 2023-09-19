using Plots
using LinearAlgebra

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

map(n, gridsize, x, y) = x + n + 1 - gridsize * (y - n)
reversemap(n, gridsize, num)
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

# Old vectorize
# function vectorize(n, setpoints)
#     gridsize = 2 * n + 1
#     vect = zeros(gridsize^2, 1)
#     for i in setpoints
#         x, y = i[1], i[2]
#         if map(n, gridsize, x, y) <= gridsize
#             vect[map(n, gridsize, x, y)] = 1
#         else
#         end
#     end
#     return vect
# end

ellipse = rasterellipse(5, 5)
ellipseVector = vectorize(5, ellipse)
print(ellipseVector)
scatter(ellipse)