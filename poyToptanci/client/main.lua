

QBCore = nil 
local coreindi = false
local usingreseller = false
Citizen.CreateThread(function()
    while QBCore == nil do 
        if Config.QBCoreVersion == 'events' then
            TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
            Citizen.Wait(200)
        elseif Config.QBCoreVersion == 'exports' then
            QBCore = exports['qb-core']:GetCoreObject()
        end
        coreindi = true


        while QBCore.Functions.GetPlayerData().job == nil do
            Citizen.Wait(10)
        end
    
        PlayerData = QBCore.Functions.GetPlayerData()
    end
end)

RegisterNetEvent('QBCore:Client:OnJobUptade')
AddEventHandler('QBCore:Client:OnJobUptade', function(job)
    PlayerData.job = job
end)




----- NPC SPAWNING
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if Config.EnableTarget == true then
            exports['qb-target']:AddTargetModel(Config.NPCModel, {
            options = {
                {
                    event = "poytarget:openbank",
                    icon = "fa-solid fa-building-columns",
                    label = "Toptantıcıya Eriş",
                },
                },
                distance = 2.5,
            })
        end
    end
end)

RegisterNetEvent('poyToptanci:openmainmenu')
AddEventHandler('poyToptanci:openmainmenu', function()
    openmainmenu()

end)


local resellers = {
    [1] = {x = 424.46, y = -2789.69, z = 6.53,}
}

Citizen.CreateThread(function()
    if Config.NPCEnabled == true then
        --print('shouldspawnnpc')
        --print(Config.NPCCoords.x)
        modelHash = GetHashKey(Config.NPCModel)
        RequestModel(modelHash)
        while not HasModelLoaded(modelHash) do
            Wait(1)
        end
        createNPC()
    end
end)

function createNPC()
	created_ped = CreatePed(5, modelHash, Config.NPCLoc.x, Config.NPCLoc.y, Config.NPCLoc.z - 1, Config.NPCLoc.h, false, true)
	FreezeEntityPosition(created_ped, true)
	SetEntityInvincible(created_ped, true)
	SetBlockingOfNonTemporaryEvents(created_ped, true)
    TaskStartScenarioInPlace(created_ped, "WORLD_HUMAN_DRINKING", 0, true)
end


-----------------Main Threads----------------





Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(10)
        local coords = GetEntityCoords(PlayerPedId())
        local distance = GetDistanceBetweenCoords(coords, Config.ResellerCoords)
        if distance <= 5 then
            if not Config.EnableTarget then
                QBCore.Functions.DrawText3D(-420.29, -2786.84, 6.0, '[ E Basarak Toptancıya Gir ]')
                if IsControlJustPressed(0, 38) then
                    print('opening menu....')
                    openmainmenu()
                end
            end
        end
    end
end)


RegisterCommand('toptancitest', function()
    openmainmenu()

end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(5)
        if IsControlJustPressed(0, 194) and usingreseller == true then
            QBCore.UI.Menu.CloseAll()
            usingreseller = false
        end
    end
end)


---------------Main Functions--------------

RegisterCommand("menufix", function()
    QBCore.UI.Menu.CloseAll()

end)


function openmainmenu()
    QBCore.UI.Menu.CloseAll()
    local elements = {}
    for k,v in pairs(Config.ShopItems) do
        print(v.SellItem.ItemShowName)
        print(k)
        table.insert(elements, {label = v.SellItem.ItemShowName, value = k})
    end

    QBCore.UI.Menu.Open('default', GetCurrentResourceName(), 'toptanci_default', {
		title = 'Toptancı',
		align = 'top-right',
        elements = elements
    },function(data, menu)
		if data.current.value then
            usingreseller = true
            QBCore.UI.Menu.Open('dialog', GetCurrentResourceName(), 'toptanci_dialog',
            {
                title = "Ne kadar satıcaksın?"
            },
            function(data3, menu3)
                local writtenamount = tonumber(data3.value)
                local item = data.current.value
                print(writtenamount)
                print(item)
                if Config.MaxSellLimit ~= 'infinite' then
                    if writtenamount < Config.MaxSellLimit + 1 then
                        TriggerServerEvent('poyraztoptanci:removeitem', item, writtenamount)
                        menu3.close()
                        usingreseller = false
                    else
                        QBCore.Functions.Notify("Hatalı Miktar! ", "error")
                    end
                else
                    TriggerServerEvent('poyraztoptanci:removeitem', item, writtenamount)
                    menu3.close()
                    usingreseller = false
                end
            end, function(data3, menu3)
                menu3.close()
                usingreseller = false
            end)
        else
            menu.close()
            usingreseller = false
		end
    end, function(data, menu)
        menu.close()
        usingreseller = false
	end)

end


