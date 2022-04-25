
-------- Shop Items ------
Config = {
    ShopItems = {
        ['phone'] = {
            SellItem = {Item = 'cash', ItemShowName = 'Telefon (tane) - 70$', itemprice = 70}
        }
    }
}


---------------------------


----  NPC CONFIG -----

Config.EnableTarget = false   -------- QB Target Entegration, if false 3D text will be written. 
Config.ResellerCoords = vector3(-424.46, -2789.69, 6.53) ----- A vector3 location of the reseller.
Config.NPCEnabled = true   --- If a npc should be spawned as the reseller, note: must be on if using Config.EnableTarget!
Config.NPCModel = 'a_m_m_rurmeth_01' ---- Model of the spawned NPC, for more info go to: https://docs.fivem.net/docs/game-references/ped-models/
Config.NPCCoords = {x = 424.46, y = -2789.69, z = 6.53, h = 318.27} ---- Needed for Spawning NPC, vector3's cant be used.
Config.EnableBlip = false ----- If a Blip Should Be Shown On the Map, options: 'true' or 'false'.

--- QBCORE CONFIG ------

Config.QBCoreVersion = 'exports'  --- TriggerEvent or exports['qb-core']:GetCoreObject(), if using triggerevents replace with: 'events' :)'.

Config.MaxSellLimit = 'infinite' ----- Number or 'infinite', this only works per time, so after they reopen the menu the sell limit willl reset.

Config.MoneyType = 'cash'  ----- options: " cash, bank "
------- Discord Config ----

Config.WebhookLink = 'insert_webhook'
Config.WebhookName = 'Poy Toptanci LOG'
------------------------------

