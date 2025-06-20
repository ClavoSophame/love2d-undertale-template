local layers = {
    objects = {}
}

function layers.sort()
    table.sort(layers.objects, function(a, b)
        return a.layer < b.layer
    end)

    for _, object in ipairs(layers.objects)
    do
        if (object.isactive) then
            object:Draw()
        end
    end
end

function layers.clear()
    for k, object in ipairs(layers.objects)
    do
        object:Destroy()
    end
    sprites.images = {}
    typers.instances = {}
    layers.objects = {}
end

return layers