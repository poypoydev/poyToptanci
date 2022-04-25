QBCore = nil
local coreindi = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if not coreindi then
            if Config.QBCoreVersion == 'events' then
                TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
                coreind = true
            elseif Config.QBCoreVersion == 'exports' then
                QBCore = exports['qb-core']:GetCoreObject()
                coreindi = true
            end
        end
    end
end)


RegisterNetEvent('poyraztoptanci:removeitem')
AddEventHandler('poyraztoptanci:removeitem', function(item, amount)
    local Player = QBCore.Functions.GetPlayer(source)
    --local amount = Player.Functions.GetItemByName(item)
    local notification = 'Tebrikler! '..amount..' Tane '..item..' Sattınız!'
    local fiyat = Config.ShopItems[item].SellItem.itemprice
    local paramiktar = fiyat * amount
    print(paramiktar)
    print(fiyat)
    if Player then
        if Player.Functions.GetItemByName(item).amount >= amount then
            Player.Functions.RemoveItem(item, amount)
            TriggerClientEvent('QBCore:Notify', source, notification, "inform")
            if Config.MoneyType == 'bank' then
                Player.Functions.addMoney('bank', paramiktar)
                QBCore.Functions.Notify('Paranız Bankaya Yatırıldı!')
                
            elseif Config.MoneyType == 'cash' then
                Player.Functions.addMoney('cash', paramiktar)
                TriggerClientEvent('QBCore:Notify', source, 'Toptancı Paranızı Verdi!', "inform")

            end
            poylog(Player, 'Toptancıya eşya sattı.')
        else
            TriggerClientEvent('QBCore:Notify', source, 'Yetersiz Tutar!', "error")
        end
    else
        TriggerClientEvent('QBCore:Notify', source, 'Oyuncu Bulunamadı!', "error")
    end
end)


function poylog(xPlayer, text)
    local armudul = xPlayer.PlayerData.charinfo.firstname..''..xPlayer.PlayerData.charinfo.lastname
    local playerName = Sanitize(armudul)
   
    local discord_webhook = Config.WebhookLink
    if discord_webhook == '' then
      return
    end
    local headers = {
      ['Content-Type'] = 'application/json'
    }
    local data = {
      ["username"] = Config.WebhookName,
      ["avatar_url"] = "https://cdn.discordapp.com/attachments/707305833871966360/769400563442909214/Visual_Studio_code_logo.png",
      ["embeds"] = {{
        ["author"] = {
          ["name"] = playerName
        },
        ["color"] = 1942002,
        ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
      }}
    }
    data['embeds'][1]['description'] = text
    PerformHttpRequest(discord_webhook, function(err, text, headers) end, 'POST', json.encode(data), headers)
end

function Sanitize(str)
    local replacements = {
        ['&' ] = '&amp;',
        ['<' ] = '&lt;',
        ['>' ] = '&gt;',
        ['\n'] = '<br/>'
    }

    return str
        :gsub('[&<>\n]', replacements)
        :gsub(' +', function(s)
            return ' '..('&nbsp;'):rep(#s-1)
        end)
end


AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    print('poyToptanci, made with love by poyraz#8455')
end)
