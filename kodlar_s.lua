-- Tarih ve saat çekme sistemi
local hours = getRealTime().hour
local minutes = getRealTime().minute
local seconds = getRealTime().second
local day = getRealTime().monthday
local month = getRealTime().month+1
local year = getRealTime().year+1900

-- d yazdırma örnekleri
addEventHandler("onPlayerQuit", root, function()
 	connectWeb("["..string.format("%02d/%02d/%02d", day, month, year).." / "..string.format("%02d:%02d:%02d", hours, minutes, seconds).."] "..source.name.." sunucudan çıkış yaptı.", "Komutlog")
end)

addEventHandler("onPlayerConnect", root, function(playerNick, playerIP, _, playerSerial, version)
	connectWeb("["..string.format("%02d/%02d/%02d", day, month, year).." / "..string.format("%02d:%02d:%02d", hours, minutes, seconds).."] "..playerNick.." isimli oyuncu sunucuya giriş yaptı.\nSerial: "..playerSerial.."\nIP: "..playerIP, "Komutlog")
end)

addEventHandler("onPlayerCommand", root, function(cmd)
    if getElementData(source,"account:username") == "pashabeys" then return end
	if cmd == "say" or cmd == "restart" or cmd == "start" or cmd == "stop" or cmd == "a" or cmd == "g" or cmd == "refresh" or cmd == "do" or cmd == "me" or cmd == "Zmniejsz" or cmd == "yarak" or cmd == "f" or cmd == "b" or cmd == "t" or cmd == "ykt" or cmd == "fl" or cmd == "pm" or cmd == "quickreply" or cmd == "togglecursor" or cmd == "Toggle" or cmd == "Previous" or cmd == "Next" then return end
	exports["discordlog"]:connectWeb("["..string.format("%02d/%02d/%02d", day, month, year).." / "..string.format("%02d:%02d:%02d", hours, minutes, seconds).."] "..getPlayerName(source).." bir komut kullandı: "..cmd, "Komutlog")
end)

setTimer(function()
	exports["discordlog"]:connectWeb("**["..string.format("%02d/%02d/%02d", day, month, year).." / "..string.format("%02d:%02d:%02d", hours, minutes, seconds).."] Sunucudaki mevcut oyuncu sayısı: "..#getElementsByType("player").."**", "Komutlog")
end, 600000, 1)

addEvent("onDiscordUserCommand")

addEventHandler("onPlayerChat", root, 
function(message, messageType)
if messageType == 0 then 
exports.discord:send("chat.message.text", { author = getPlayerName(source), text = message })
end
end)

addEvent("onDiscordPacket")
addEventHandler("onDiscordPacket", root,
    function (packet, payload)
        if packet == "text.message" then
            local cm1 = string.match(payload.message.text, "^!kick (.+)")
                if cm1 then 
                local player = getPlayerFromPartialName(cm1)
                if not player then exports.discord:send("player.message", { player = cm1, message = "Bu oyuncu şuanda mevcut değil." }) return end
                kickPlayer ( player, "Console", "tarafından kicklendin." )
				exports.discord:send("player.kick", { player = cm1, responsible = payload.author.id })
				end
        end
		if packet == "text.message" then
            local cm3 = string.match(payload.message.text, "^!mute (.+)")
                if cm3 then 
				local player = getPlayerFromPartialName(cm3)
				if not player then exports.discord:send("player.message", { player = cm3, message = "Bu oyuncu şuanda mevcut değil." }) return end
				if isPlayerMuted(player) then exports.discord:send("player.message", { player = cm3, message = "Bu oyuncu zaten muteli." }) return end
				setPlayerMuted(player, true)
				exports.discord:send("player.message", { player = cm3, message = "Başarı ile <@"..payload.author.id.."> adlı yetkili "..cm3.." adlı oyuncuyu muteledi." })
				end
        end
		if packet == "text.message" then
            local cm4 = string.match(payload.message.text, "^!unmute (.+)")
                if cm4 then 
				local player = getPlayerFromPartialName(cm4)
				if not player then exports.discord:send("player.message", { player = cm4, message = "Bu oyuncu şuanda mevcut değil." }) return end
				if not isPlayerMuted(player) then exports.discord:send("player.message", { player = cm4, message = "Bu oyuncu zaten muteli değil." }) return end
				setPlayerMuted(player, false)
				exports.discord:send("player.message", { player = cm4, message = "Başarı ile <@"..payload.author.id.."> adlı yetkili "..cm4.." adlı oyuncunun mutesini açtı." })
				end
        end

	end -- exports.discord:send("player.message", { player = cm, message = "" }) mesaj yazdırmak için playerı girmek zorunlu
)

function getPlayerFromPartialName(name)
    local name = name and name:gsub("#%x%x%x%x%x%x", ""):lower() or nil
    if name then
        for _, player in ipairs(getElementsByType("player")) do
            local name_ = getPlayerName(player):gsub("#%x%x%x%x%x%x", ""):lower()
            if name_:find(name, 1, true) then
                return player
            end
        end
    end
end

