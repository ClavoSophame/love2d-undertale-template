-- Documentation: https://gamejolt.com/game-api/doc

local gamejolt = {}

local md5 = require("Scripts.Libraries.Utils.MD5")
local json = require("Scripts.Libraries.Utils.dkjson")
local http = require("socket.http")
local ltn12 = require("ltn12")

-- Generates a signature for the GameJolt API request by hashing the input with MD5.
local function generate_signature(request_path)
    local input = gamejolt.base_url .. request_path .. gamejolt.private_key
    return md5.sumhexa(input)
end

-- Sends an HTTP request to the GameJolt API and returns the response or error message.
local function api_request(url)
    local response_body = {}
    local res, code, headers = http.request{
        url = url,
        sink = ltn12.sink.table(response_body)
    }

    if (code ~= 200) then
        return false, "HTTP error: "..tostring(code)
    end

    local response = table.concat(response_body)
    local data, pos, err = json.decode(response)
    if (not data) then
        return false, "JSON decode error: "..tostring(err).."\nResponse: "..tostring(response)
    end

    if (data.response and data.response.success == "false") then
        return false, data.response.message or "API error"
    end

    return data.response
end

-- Initializes the GameJolt API with the provided app ID and private key.
function gamejolt.init(app_id, private_key)
    gamejolt.app_id = app_id
    gamejolt.private_key = private_key
    gamejolt.base_url = "https://api.gamejolt.com/api/game/v1_2"
    return (gamejolt.app_id ~= nil and gamejolt.private_key ~= nil)
end

--------------------------------------------USERS--------------------------------------------
-- Fetches user data from the GameJolt API using either user ID or username.
-- Syntax: /users/?game_id=xxxxx&user_id=12345
function gamejolt.fetch_user(user_id, username)
    local url = gamejolt.base_url .. "/users/?game_id=" .. gamejolt.app_id ..
                (user_id and "&user_id=" .. user_id or "") ..
                (username and "&username=" .. username or "") ..
                "&signature=" .. generate_signature("/users/?game_id=" .. gamejolt.app_id ..
                                                  (user_id and "&user_id=" .. user_id or "") ..
                                                  (username and "&username=" .. username or ""))

    return api_request(url)
end

-- Authenticates a user with their username and token against the GameJolt API.
-- Syntax: /users/?game_id=xxxxx&username=test&user_token=test
function gamejolt.auth_user(username, user_token)
    gamejolt.username = username
    gamejolt.user_token = user_token
    local url = gamejolt.base_url .. "/users/auth/?game_id=" .. gamejolt.app_id ..
                "&username=" .. username .. "&user_token=" .. user_token ..
                "&signature=" .. generate_signature("/users/auth/?game_id=" .. gamejolt.app_id ..
                                                  "&username=" .. username .. "&user_token=" .. user_token)

    local success, err = api_request(url)
    return success ~= false, err
end

------------------------------------------------ACHIEVEMENTS (TROPHIES)---------------------------------------------
-- Fetches achievements (trophies) from the GameJolt API. If achieved_only is true, only achieved trophies are returned.
-- Syntax: /trophies/?game_id=xxxxx&username=test&user_token=test&achieved=true
function gamejolt.fetch_achievements(achieved_only)
    local url = gamejolt.base_url .. "/trophies/?game_id=" .. gamejolt.app_id ..
                "&username=" .. gamejolt.username .. "&user_token=" .. gamejolt.user_token ..
                (achieved_only and "&achieved=true" or "") ..
                "&signature=" .. generate_signature("/trophies/?game_id=" .. gamejolt.app_id ..
                                                  "&username=" .. gamejolt.username ..
                                                  "&user_token=" .. gamejolt.user_token ..
                                                  (achieved_only and "&achieved=true" or ""))

    return api_request(url)
end

-- Unlocks an achievement (trophy) in the GameJolt API using the trophy ID.
-- Syntax: /trophies/add-achieved/?game_id=xxxxx&username=myusername&user_token=mytoken&trophy_id=1047
function gamejolt.unlock_achievement(trophy_id)
    local endpoint = "/trophies/add-achieved/"
    local base_params = "?game_id=" .. gamejolt.app_id ..
                       "&username=" .. gamejolt.username ..
                       "&user_token=" .. gamejolt.user_token ..
                       "&trophy_id=" .. trophy_id

    local url = gamejolt.base_url .. endpoint .. base_params ..
                "&signature=" .. generate_signature(endpoint .. base_params)

    local result, err = api_request(url)
    if (result) then
        return true
    else
        local browser_url = "https://gamejolt.com/api/game/v1_2" .. endpoint .. base_params ..
                           "&signature=" .. generate_signature(endpoint .. base_params)
        print(browser_url)
        love.system.openURL(browser_url)
        return false, "Falling back to browser: " .. tostring(err)
    end
end

---------------------------------------------SESSIONS--------------------------------------------
-- Opens a session for the authenticated user in the GameJolt API.
-- Syntax: /sessions/open/?game_id=xxxxx&username=myusername&user_token=mytoken
function gamejolt.session_open()
    local url = gamejolt.base_url .. "/sessions/open/?game_id=" .. gamejolt.app_id ..
                "&username=" .. gamejolt.username .. "&user_token=" .. gamejolt.user_token ..
                "&signature=" .. generate_signature("/sessions/open/?game_id=" .. gamejolt.app_id ..
                                                  "&username=" .. gamejolt.username ..
                                                  "&user_token=" .. gamejolt.user_token)
    return api_request(url)
end

-- Pings the current session to keep it active or update its status.
-- Syntax: /sessions/ping/?game_id=xxxxx&username=myusername&user_token=mytoken&status=active
function gamejolt.session_ping(status)
    local url = gamejolt.base_url .. "/sessions/ping/?game_id=" .. gamejolt.app_id ..
                "&username=" .. gamejolt.username .. "&user_token=" .. gamejolt.user_token ..
                "&status=" .. (status or "active") ..
                "&signature=" .. generate_signature("/sessions/ping/?game_id=" .. gamejolt.app_id ..
                                                  "&username=" .. gamejolt.username ..
                                                  "&user_token=" .. gamejolt.user_token ..
                                                  "&status=" .. (status or "active"))
    return api_request(url)
end

-- Closes the current session for the authenticated user in the GameJolt API.
-- Syntax: /sessions/close/?game_id=xxxxx&username=myusername&user_token=mytoken
function gamejolt.session_close()
    local url = gamejolt.base_url .. "/sessions/close/?game_id=" .. gamejolt.app_id ..
                "&username=" .. gamejolt.username .. "&user_token=" .. gamejolt.user_token ..
                "&signature=" .. generate_signature("/sessions/close/?game_id=" .. gamejolt.app_id ..
                                                  "&username=" .. gamejolt.username ..
                                                  "&user_token=" .. gamejolt.user_token)
    return api_request(url)
end

---------------------------------------------DATA STORE--------------------------------------------
-- Stores data in the GameJolt Data Store under the specified key.
-- Syntax: /data-store/set/?game_id=xxxxx&key=test&data=test&username=myusername&user_token=mytoken
function gamejolt.data_store(key, data, user_data)
    local url = gamejolt.base_url .. "/data-store/set/?game_id=" .. gamejolt.app_id ..
                "&key=" .. key .. "&data=" .. data ..
                (user_data and ("&username=" .. gamejolt.username .. "&user_token=" .. gamejolt.user_token) or "") ..
                "&signature=" .. generate_signature("/data-store/set/?game_id=" .. gamejolt.app_id ..
                                                  "&key=" .. key .. "&data=" .. data ..
                                                  (user_data and ("&username=" .. gamejolt.username ..
                                                   "&user_token=" .. gamejolt.user_token) or ""))
    return api_request(url)
end

-- Fetches data from the GameJolt Data Store using the specified key.
-- Syntax: /data-store/?game_id=xxxxx&key=test&username=myusername&user_token=mytoken
function gamejolt.data_fetch(key, user_data)
    local url = gamejolt.base_url .. "/data-store/?game_id=" .. gamejolt.app_id ..
                "&key=" .. key ..
                (user_data and ("&username=" .. gamejolt.username .. "&user_token=" .. gamejolt.user_token) or "") ..
                "&signature=" .. generate_signature("/data-store/?game_id=" .. gamejolt.app_id ..
                                                  "&key=" .. key ..
                                                  (user_data and ("&username=" .. gamejolt.username ..
                                                   "&user_token=" .. gamejolt.user_token) or ""))
    return api_request(url)
end

-- Fetches all data from the GameJolt Data Store for the authenticated user.
-- Syntax: /data-store/?game_id=xxxxx&username=myusername&user_token=mytoken
function gamejolt.data_fetch_all(user_data)
    local url = gamejolt.base_url .. "/data-store/?game_id=" .. gamejolt.app_id ..
                (user_data and ("&username=" .. gamejolt.username .. "&user_token=" .. gamejolt.user_token) or "") ..
                "&signature=" .. generate_signature("/data-store/?game_id=" .. gamejolt.app_id ..
                                                  (user_data and ("&username=" .. gamejolt.username ..
                                                   "&user_token=" .. gamejolt.user_token) or ""))
    return api_request(url)
end

-- Deletes data from the GameJolt Data Store using the specified key.
-- Syntax: /data-store/delete/?game_id=xxxxx&key=test&username=myusername&user_token=mytoken
function gamejolt.data_delete(key, user_data)
    local url = gamejolt.base_url .. "/data-store/delete/?game_id=" .. gamejolt.app_id ..
                "&key=" .. key ..
                (user_data and ("&username=" .. gamejolt.username .. "&user_token=" .. gamejolt.user_token) or "") ..
                "&signature=" .. generate_signature("/data-store/delete/?game_id=" .. gamejolt.app_id ..
                                                  "&key=" .. key ..
                                                  (user_data and ("&username=" .. gamejolt.username ..
                                                   "&user_token=" .. gamejolt.user_token) or ""))
    return api_request(url)
end

-- Fetches the keys from the GameJolt Data Store for the authenticated user.
-- Syntax: /data-store/get-keys/?game_id=xxxxx&username=myusername&user_token=mytoken
function gamejolt.data_get_keys(user_data)
    local url = gamejolt.base_url .. "/data-store/get-keys/?game_id=" .. gamejolt.app_id ..
                (user_data and ("&username=" .. gamejolt.username .. "&user_token=" .. gamejolt.user_token) or "") ..
                "&signature=" .. generate_signature("/data-store/get-keys/?game_id=" .. gamejolt.app_id ..
                                                  (user_data and ("&username=" .. gamejolt.username ..
                                                   "&user_token=" .. gamejolt.user_token) or ""))
    return api_request(url)
end

------------------------------------------SCORES--------------------------------------------
-- Fetches scores from the GameJolt API using the specified table ID.
-- Syntax: /scores/?game_id=xxxxx&table_id=12345
function gamejolt.fetch_scores_local(table_id)
    local url = gamejolt.base_url .. "/scores/?game_id=" .. gamejolt.app_id ..
                (table_id and "&table_id=" .. table_id or "") ..
                "&signature=" .. generate_signature("/scores/?game_id=" .. gamejolt.app_id ..
                                                  (table_id and "&table_id=" .. table_id or ""))
    return api_request(url)
end

-- Fetches scores from the GameJolt API using the specified table ID and user data.
-- Syntax: /scores/?game_id=xxxxx&table_id=12345&username=myusername&user_token=mytoken
function gamejolt.fetch_scores_global(table_id)
    local url = gamejolt.base_url .. "/scores/?game_id=" .. gamejolt.app_id ..
                (table_id and "&table_id=" .. table_id or "") ..
                "&username=" .. gamejolt.username .. "&user_token=" .. gamejolt.user_token ..
                "&signature=" .. generate_signature("/scores/?game_id=" .. gamejolt.app_id ..
                                                  (table_id and "&table_id=" .. table_id or "") ..
                                                  "&username=" .. gamejolt.username ..
                                                  "&user_token=" .. gamejolt.user_token)
    return api_request(url)
end

-- Submits a score to the GameJolt API using the specified table ID and score value.
-- Syntax: /scores/add/?game_id=xxxxx&score=12345&table_id=12345
function gamejolt.submit_score(score, table_id, sort, extra_data)
    local url = gamejolt.base_url .. "/scores/add/?game_id=" .. gamejolt.app_id ..
                "&score=" .. score ..
                (table_id and "&table_id=" .. table_id or "") ..
                (sort and "&sort=" .. sort or "") ..
                (extra_data and "&extra_data=" .. extra_data or "") ..
                "&signature=" .. generate_signature("/scores/add/?game_id=" .. gamejolt.app_id ..
                                                  "&score=" .. score ..
                                                  (table_id and "&table_id=" .. table_id or "") ..
                                                  (sort and "&sort=" .. sort or "") ..
                                                  (extra_data and "&extra_data=" .. extra_data or ""))
    local result, err = api_request(url)
    if (result) then
        return true
    else
        local browser_url = "https://gamejolt.com/api/game/v1_2" .. "/scores/add/?game_id=" .. gamejolt.app_id ..
                           "&score=" .. score ..
                           (table_id and "&table_id=" .. table_id or "") ..
                           (sort and "&sort=" .. sort or "") ..
                           (extra_data and "&extra_data=" .. extra_data or "") ..
                           "&signature=" .. generate_signature("/scores/add/?game_id=" .. gamejolt.app_id ..
                                                             "&score=" .. score ..
                                                             (table_id and "&table_id=" .. table_id or "") ..
                                                             (sort and "&sort=" .. sort or "") ..
                                                             (extra_data and "&extra_data=" .. extra_data or ""))
        love.system.openURL(browser_url)
        return false, "Falling back to browser: " .. tostring(err)
    end
end

return gamejolt