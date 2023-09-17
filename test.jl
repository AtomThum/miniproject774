function map(n, x, y)
    gridsize = 2*n + 1
    transformed_x = x + (n + 1)
    transformed_y = y - (n + 1)
    mapped = transformed_x + gridsize*(transformed_y + 1)*(-1)
    return mapped
end

function vectorize(n, setpoints)
    gridsize = 2*n + 1
    vect = zeros(gridsize^2, 1)
    for i in setpoints
        x, y = i[1], i[2]
        if abs(x) > gridsize || abs(y) > gridsize
        else
            vect[map(n, x, y)] = 1
        end
    end
    return vect
end

setpoints = [(-2, 2), (2, -2)]
vectorize(2, setpoints)
