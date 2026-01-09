local showIDs = false
local playerPed = PlayerPedId()
local HEAD_BONE = 0x796e

local function DrawText3D(x, y, z, text)
    SetTextScale(0.5, 0.5)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    SetTextCentre(true)
    SetTextOutline()
    SetTextDropshadow(0, 0, 0, 0, 255)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

RegisterCommand('+showIDs', function()
    showIDs = true
end, false)

RegisterCommand('-showIDs', function()
    showIDs = false
end, false)

RegisterKeyMapping('+showIDs', 'Show Player IDs', 'keyboard', 'u')

CreateThread(function()
    while true do
        if showIDs then
            playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local myHeadPos = GetPedBoneCoords(playerPed, HEAD_BONE, 0.0, 0.0, 0.0)
            DrawText3D(myHeadPos.x, myHeadPos.y, myHeadPos.z + 0.5, GetPlayerServerId(PlayerId()))
            
            local activePlayers = GetActivePlayers()
            for i = 1, #activePlayers do
                local player = activePlayers[i]
                if player ~= PlayerId() then
                    local targetPed = GetPlayerPed(player)
                    local targetCoords = GetEntityCoords(targetPed)
                    local distance = #(playerCoords - targetCoords)
                    if distance < 30.0 and HasEntityClearLosToEntity(playerPed, targetPed, 17) then
                        local headPos = GetPedBoneCoords(targetPed, HEAD_BONE, 0.0, 0.0, 0.0)
                        DrawText3D(headPos.x, headPos.y, headPos.z + 0.5, GetPlayerServerId(player))
                    end
                end
            end
            Wait(0)
        else
            Wait(500)
        end
    end
end)
