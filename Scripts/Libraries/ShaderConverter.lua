local converter = {}

converter.result = ""
converter.configs = {
    mainImage = {
        leftBracket = true,
        returnFragColor = true,
    }
}
converter.commonFunctions =
[[
float tanh(float x) {
    float e = exp(2.0 * x);
    return (e - 1.0) / (e + 1.0);
}
vec2 tanh(vec2 x) { return vec2(tanh(x.x), tanh(x.y)); }
vec3 tanh(vec3 x) { return vec3(tanh(x.x), tanh(x.y), tanh(x.z)); }
vec4 tanh(vec4 x) { return vec4(tanh(x.x), tanh(x.y), tanh(x.z), tanh(x.w)); }
float hash(float n) { return fract(sin(n) * 1e4); }
float hash(vec2 p) { 
    return fract(1e4 * sin(17.0 * p.x + p.y * 0.1) * 
        (0.1 + abs(sin(p.y * 13.0 + p.x))));
}
float hash(vec3 p) { return hash(vec2(hash(p.xy), p.z)); }
vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}
vec3 rgb2hsv(vec3 c) {
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}
float noise(vec2 p) { 
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}
float noise(vec3 p) { 
    return noise(vec2(noise(p.xy), p.z));
}
float smoothstep5(float edge0, float edge1, float x) {
    float t = clamp((x - edge0) / (edge1 - edge0), 0.0, 1.0);
    return t * t * t * (t * (t * 6.0 - 15.0) + 10.0);
}
float sdCircle(vec2 p, float r) { 
    return length(p) - r; 
}
float sdBox(vec2 p, vec2 b) {
    vec2 d = abs(p) - b;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}
mat2 rot(float a) {
    float c = cos(a), s = sin(a);
    return mat2(c, -s, s, c);
}
]]

converter.commonUniforms =
[[

uniform float iTime;
uniform vec2 iResolution;
uniform sampler2D iChannel0;
uniform sampler2D iChannel1;
uniform sampler2D iChannel2;
uniform vec4 iMouse;
]]

function converter.setConfigs(config_table)
    for k, v in pairs(config_table) do
        if converter.configs[k] then
            for param, value in pairs(v) do
                converter.configs[k][param] = value
            end
        end
    end
end

--[[

current target shader:

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;

    // Time varying pixel color
    vec3 col = 0.5 + 0.5*cos(iTime+uv.xyx+vec3(0,2,4));

    // Output to screen
    fragColor = vec4(col,1.0);
}

]]

function converter.ConvertShader(code)
    local result = ""

    local flipY = [[
    // Flip y-coordinate to match LOVE2D's coordinate system
    vec2 flipY(vec2 coord) {
        return vec2(coord.x, love_ScreenSize.y - coord.y);
    }
    ]]

    code = code:gsub("void%s+mainImage%s*%(%s*out%s+vec4%s+([%w_]+)%s*,%s*in%s+vec2%s+([%w_]+)%s*%)",
        "vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)\n"
    )
    code = code:gsub("fragCoord", "screen_coords")
    code = code:gsub("fragColor", "color")
    code = code:gsub("iResolution", "love_ScreenSize")

    code = code:gsub("texelFetch%s*%(%s*([%w_]+)%s*,%s*ivec2%s*%(%s*([^%)]+)%s*%)%s*,%s*(%d+)%s*%)",
        function(texture, coord, lod)
            return "texture("..texture..", (vec2("..coord..")+0.5)/textureSize("..texture..","..lod.."))"
        end)

    code = code:gsub("textureLod%s*%(%s*([%w_]+)%s*,%s*vec2%s*%(%s*([^%)]+)%s*%)%s*,%s*(%d+)%s*%)",
        function(texture, coord, lod)
            return "texture("..texture..", (vec2("..coord..")+0.5)/textureSize("..texture..","..lod.."))"
        end)

    code = code:gsub("textureSize%s*%(%s*([%w_]+)%s*,%s*0%s*%)",
        "vec2(textureSize(%1))")

    code = code:gsub("textureSize%s*%(%s*([%w_]+)%s*,%s*(%d+)%s*%)",
        "vec2(textureSize(%1))/pow(2.0, %2)")

    -- Configs
    local tab = converter.configs
    if (not tab.convertNoise2D) then

    end

    code = converter.commonUniforms .. flipY .. converter.commonFunctions .. code

    converter.result = code
end

function converter.printResult()
    local lines = {}
    for line in converter.result:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end
    for i, line in ipairs(lines) do
        if (i < 10) then
            print(i .. "  ->|  " .. line)
        elseif (i < 100) then
            print(i .. " ->|  " .. line)
        elseif (i < 1000) then
            print(i .. "->|  " .. line)
        end
    end
    print("Total lines: " .. #lines)
    for _ = 1, 5 do
        print(" ")
    end
end

return converter