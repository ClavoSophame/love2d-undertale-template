local Math = {
    coordinates = {}
}

function Math.Distance(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return math.sqrt(dx * dx + dy * dy)
end

function Math.Direction(x1, y1, x2, y2, offset)
    local dx = x2 - x1
    local dy = y2 - y1
    return math.deg(math.atan2(dy, dx)) + offset
end

function Math.Clamp(value, min, max)
    return math.min(math.max(value, min), max)
end

function Math.Lerp(a, b, t)
    return a + (b - a) * t
end

function Math.NumberRound(number)
    return math.floor(number + 0.5)
end

function Math.Choose(...)
    local choices = {...}
    return choices[math.random(#choices)]
end

function Math.GCD(a, b)
    if b == 0 then
        return a
    else
        return Math.GCD(b, a % b)
    end
end

function Math.LCM(a, b)
    return a * b / Math.GCD(a, b)
end

local lanczos_coef = {
    0.99999999999980993,
    676.5203681218851,
    -1259.1392167224028,
    771.32342877765313,
    -176.61502916214059,
    12.507343278686905,
    -0.13857109526572012,
    9.9843695780195716e-6,
    1.5056327351493116e-7,
}

function Math.Gamma(x)
    if (x < 0.5) then
        return math.pi / (math.sin(math.pi * x) * Math.Gamma(1 - x))
    end

    x = x - 1
    local a = lanczos_coef[1]
    for i = 2, #lanczos_coef
    do
        a = a + lanczos_coef[i] / (x + i - 1)
    end

    local g = 7
    local t = x + g + 0.5
    return math.sqrt(2 * math.pi) * t^(x + 0.5) * math.exp(-t) * a
end

function Math.ToDecimal(number, base)
    if (base < 2 or base > 36) then
        error("Base must be between 2 and 36")
    end

    local digits = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local result = 0
    number = string.upper(number)

    for i = 1, #number
    do
        local char = string.sub(number, i, i)
        local digit = string.find(digits, char) - 1
        if (digit >= base) then
            error("Invalid digit '" .. char .. "' for base " .. base)
        end
        result = result * base + digit
    end

    return result
end

function Math.FromDecimal(number, base)
    if (base < 2 or base > 36) then
        error("Base must be between 2 and 36")
    end

    local digits = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local result = ""

    if (number == 0) then return "0" end

    local isNegative = (number < 0)
    number = math.abs(number)

    while (number > 0)
    do
        local remainder = number % base
        result = string.sub(digits, remainder + 1, remainder + 1) .. result
        number = math.floor(number / base)
    end

    if (isNegative) then
        result = "-" .. result
    end

    return result
end


--#region

    function Math.newVector2(x, y)
        return {x = x, y = y}
    end

    function Math.newVector3(x, y, z)
        return {x = x, y = y, z = z}
    end

    function Math.VectorLength(v)
        if (v.z) then
            return math.sqrt(v.x * v.x + v.y * v.y + v.z * v.z)
        else
            return math.sqrt(v.x * v.x + v.y * v.y)
        end
    end

    function Math.VectorNormalize(v)
        if (v.z) then
            local length = Math.VectorLength(v)
            return {x = v.x / length, y = v.y / length, z = v.z / length}
        else
            local length = Math.VectorLength(v)
            return {x = v.x / length, y = v.y / length}
        end
    end

    function Math.VectorDot(v1, v2)
        if (v1.z and v2.z) then
            return v1.x * v2.x + v1.y * v2.y + v1.z * v2.z
        else
            return v1.x * v2.x + v1.y * v2.y
        end
    end

    function Math.VectorCross(v1, v2)
        local z1, z2 = v1.z or 0, v2.z or 0
        return {x = v1.y * z2 - z1 * v2.y, y = z1 * v2.x - v1.x * z2, z = v1.x * v2.y - v1.y * v2.x}
    end

    function Math.VectorRotate(vector, angle, axis)
        if (vector.z) then
            local x, y, z = vector.x, vector.y, vector.z
            local cos, sin = math.cos(angle), math.sin(angle)
            if (axis == "x") then
                return {x = x, y = y * cos - z * sin, z = y * sin + z * cos}
            elseif (axis == "y") then
                return {x = x * cos + z * sin, y = y, z = -x * sin + z * cos}
            elseif (axis == "z") then
                return {x = x * cos - y * sin, y = x * sin + y * cos, z = z}
            end
        else
            local x, y = vector.x, vector.y
            local cos, sin = math.cos(angle), math.sin(angle)
            return {x = x * cos - y * sin, y = x * sin + y * cos}
        end
    end


--#endregion
--#region

    function Math.newMatrix(tables)
        local matrix = {}
        for i = 1, #tables do
            matrix[i] = {}
            for j = 1, #tables[i] do
                matrix[i][j] = tables[i][j]
            end
        end
        return matrix
    end
    -- example: local matrix = Math.newMatrix({{1, 2, 3}, {4, 5, 6}, {7, 8, 9}})

    function Math.matrixMultiply(matrix1, matrix2)
        local result = {}
        for i = 1, #matrix1 do
            result[i] = {}
            for j = 1, #matrix2[1] do
                result[i][j] = 0
                for k = 1, #matrix2 do
                    result[i][j] = result[i][j] + matrix1[i][k] * matrix2[k][j]
                end
            end
        end
        return result
    end

    function Math.matrixAdd(matrix1, matrix2)
        if #matrix1 ~= #matrix2 or #matrix1[1] ~= #matrix2[1] then
            error("Matrices must have the same dimensions for addition")
        end
        local result = {}
        for i = 1, #matrix1 do
            result[i] = {}
            for j = 1, #matrix1[i] do
                result[i][j] = matrix1[i][j] + matrix2[i][j]
            end
        end
        return result
    end

    function Math.matrixSubtract(matrix1, matrix2)
        if #matrix1 ~= #matrix2 or #matrix1[1] ~= #matrix2[1] then
            error("Matrices must have the same dimensions for subtraction")
        end
        local result = {}
        for i = 1, #matrix1 do
            result[i] = {}
            for j = 1, #matrix1[i] do
                result[i][j] = matrix1[i][j] - matrix2[i][j]
            end
        end
        return result
    end

    function Math.matrixTranspose(matrix)
        local result = {}
        for i = 1, #matrix[1] do
            result[i] = {}
            for j = 1, #matrix do
                result[i][j] = matrix[j][i]
            end
        end
        return result
    end

    function Math.matrixInverse(matrix)
        local n = #matrix
        if n ~= #matrix[1] then
            error("Matrix must be square to have an inverse")
        end

        -- Create an identity matrix of the same size
        local identity = {}
        for i = 1, n do
            identity[i] = {}
            for j = 1, n do
                identity[i][j] = (i == j) and 1 or 0
            end
        end

        -- Augment the matrix with the identity matrix
        local augmented = {}
        for i = 1, n do
            augmented[i] = {}
            for j = 1, 2 * n do
                augmented[i][j] = (j <= n) and matrix[i][j] or identity[i][j - n]
            end
        end

        -- Perform Gauss-Jordan elimination
        for i = 1, n do
            -- Find the pivot
            local maxRow = i
            for k = i + 1, n do
                if math.abs(augmented[k][i]) > math.abs(augmented[maxRow][i]) then
                    maxRow = k
                end
            end

            -- Swap rows
            if maxRow ~= i then
                for j = 1, 2 * n do
                    augmented[i][j], augmented[maxRow][j] = augmented[maxRow][j], augmented[i][j]
                end
            end

            -- Make the diagonal contain ones
            local pivot = augmented[i][i]
            if pivot == 0 then
                error("Matrix is singular and cannot be inverted")
            end
            for j = 1, 2 * n do
                augmented[i][j] = augmented[i][j] / pivot
            end

            -- Make the other rows contain zeros in the current column
            for k = 1, n do
                if k ~= i then
                    local factor = augmented[k][i]
                    for j = 1, 2 * n do
                        augmented[k][j] = augmented[k][j] - factor * augmented[i][j]
                    end
                end
            end
        end

        -- Extract the inverse matrix from the augmented matrix
        local inverse = {}
        for i = 1, n do
            inverse[i] = {}
            for j = 1, n do
                inverse[i][j] = augmented[i][j + n]
            end
        end

        return inverse
    end

--#endregion

return Math