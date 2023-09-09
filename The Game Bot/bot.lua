local discordia = require('discordia')
local client = discordia.Client()

local botUsername
local botdiscrim
local botfullname

local config = require("token")

function sendMessage(msg,channel)
    channel:send(msg)
end

client:on('ready', function()
    botUsername = client.user.username
    botdiscrim = client.user.discriminator
    botfullname = botUsername..botdiscrim
    print('Logged in as '.. botUsername)
    client:setStatus("idle")
    client:setActivity{
        name = "The Roblox OST",
        type = 2
    }
end)

function CreateEmbed(objects)
    local embed = {
        title = "The Game Bot Credits",
        description = "These are cool people!",
        fields = objects,
        color = discordia.Color.fromRGB(0,0,0).value,
        timestamp = discordia.Date():toISO('T', 'Z'),
    }
    return embed
end

function GetCmdName(str)
    local s = ""
    for i = 1,#str do
        local subbed = string.sub(str,i,i)
        if subbed == " " then
            break
        else
            s = s..subbed
        end
    end
    return s
end

function GetArgs(str)
    local s = ""
    local l = {}
    for i = 1,#str do
        local subbed = string.sub(str,i,i)
        if subbed == " " then
            l[#l+1] = s
            s = ""
        else
            s = s..subbed
        end
    end
    l[#l+1] = s
    table.remove(l,1)
    return l
end

function processCMD(msg,channel,message)
    if #msg > 1 then
        local ActualMessage = GetCmdName(string.sub(msg,2,#msg))
        local args = GetArgs(string.sub(msg,2,#msg))
        local msgprefix = string.sub(msg,1,1)

        if msgprefix == "!" then
            if ActualMessage == "ip" then
                sendMessage("The IP is;\nJava: gttporigins.my.pebble.host\nBedrock: 54.39.13.158 port: 8048",channel)
            end
            if ActualMessage == "ipalt" then
                sendMessage("The alt IP is;\nJava: GamingTTppl.minehut.gg\nBedrock: GamingTTppl.bedrock.minehut.gg",channel)
            end
            if ActualMessage == "flip" then
                local flip = math.random(1,2)
                local choice = "math.random(1,2)"
                if flip == 1 then
                    choice = "Tails"
                else
                    choice = "Heads"
                end
                sendMessage("The coin landed on "..choice.."!",channel)
            end
            if ActualMessage == "credits" then
                local emb = CreateEmbed({})
                emb.fields[#emb.fields+1] =
                {name = "@Blaze276", value = "for creating the original The Game Bot", inline = false}
                emb.fields[#emb.fields+1] =
                {name = "@RACSpeedster", value = "for rewriting the bot in Lua", inline = false}
                channel:send{embed = emb}
            end
            if ActualMessage == "kick" then
                --local member = message.guild:getMember(message.)
                sendMessage("Your first argument is "..args[1],channel)
            end
            if ActualMessage == "sigma" then
                sendMessage("Happy birthday, <@".."960887298533244928"..">",channel)
                message:delete()
            end
            if ActualMessage == "purge" then
                local it = 0
                message.channel:getMessages(tonumber(args[1])+1):forEach(function(msg)
                    it = it + 1
                    if it ~= 1 then
                        msg:delete()
                    end
                end)
            end
        end
    end
end

client:on('messageCreate', function(message)
    local username = message.author.username
    local discriminator = message.author.discriminator
    if username..discriminator ~= botfullname then
        print("Message",username..discriminator,botfullname)
        processCMD(message.content,message.channel,message)
    end
end)

client:run('Bot '..config[1])
