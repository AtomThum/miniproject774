using Plots

# Initialize an ellipse
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

# Test
scatter(rasterellipse(20, 15), aspect_ratio=:equal)