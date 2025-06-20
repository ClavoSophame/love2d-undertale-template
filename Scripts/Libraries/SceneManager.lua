local scenes = {}

scenes.current = nil
scenes.name_previous = ""
scenes.name_current  = ""

function scenes.switchTo(sceneName, ...)
    if (scenes.current) then
        if (scenes.current.clear) then
            scenes.current.clear()
            collectgarbage("collect")
        end
    end

    scenes.name_previous = scenes.name_current
    package.loaded["Scripts.Scenes." .. scenes.name_previous] = nil
    scenes.name_current = sceneName
    scenes.current = require("Scripts.Scenes." .. sceneName)
    if (scenes.current.load) then
        scenes.current.load(...)
    end

    print("scene loaded: " .. sceneName)
end

return scenes