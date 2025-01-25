local HttpService = game:GetService("HttpService")

-- Service configuration
local SERVICE_IDENTIFIER = "txtsendnpdk" -- Your service identifier
local API_URL = "https://pandadevelopment.net/v2_validation" -- API URL to validate the key
local SCRIPT_URL = "https://raw.githubusercontent.com/npdk1/Ktools-Hub-Script/refs/heads/main/MacroV4.lua" -- Main script URL

-- Function to validate the key via API
local function ValidateKey(userKey)
    local hwid = game:GetService("Players").LocalPlayer.UserId -- Use User ID as HWID
    local url = API_URL .. "?key=" .. userKey .. "&service=" .. SERVICE_IDENTIFIER .. "&hwid=" .. hwid

    local success, response = pcall(function()
        return game:HttpGet(url)
    end)

    if not success then
        print("[Error] Unable to connect to the server: " .. response)
        return false
    end

    local jsonData = HttpService:JSONDecode(response)
    if jsonData["V2_Authentication"] == "success" then
        return true
    else
        return false, jsonData["message"] or "Invalid key!"
    end
end

-- Main process
local function Main()
    if not getgenv().Key then
        print("[Error] No key found in getgenv(). Please set your key using getgenv().Key")
        return
    end

    local userKey = getgenv().Key
    print("Validating key: " .. userKey)

    -- Validate the key
    local isValid, errorMsg = ValidateKey(userKey)
    if isValid then
        print("Key is valid! Welcome To KTools | Community.") -- Add the welcome message here
        print("Loading the script...")
        -- Load and run the main script from the raw URL
        local success, scriptError = pcall(function()
            loadstring(game:HttpGet(SCRIPT_URL))()
        end)

        if not success then
            print("[Error] Error running the main script: " .. scriptError)
        end
    else
        print("Invalid key: " .. (errorMsg or "Unknown error"))
    end
end

-- Run the main process
Main()
