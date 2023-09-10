local discordia = require('discordia')
local client = discordia.Client()

local botUsername
local botdiscrim
local botfullname

local config = require("token")

local StartupTime = os.time()

local globaldata = {}

function sendMessage(msg,channel)
    local MESSAGE = channel:send(msg)
    return MESSAGE
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

function CreateEmbed(fields, title, description)
    local embed = {
        title = title,
        description = description,
        fields = fields,
        color = discordia.Color.fromRGB(0,0,0).value,
        timestamp = discordia.Date():toISO('T', 'Z'),
        image = {
            url = nil
        },
        footer = {
            text = 'The Game Bot',
            icon_url = 'https://cdn.discordapp.com/avatars/1145327542723686451/aa8e209b03194832e7b3704eef3fd297.png?size=4096'
        },
        url = nil,
        author = {
            name = nil,
            url = nil,
            icon_url = nil
        },
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

        if msgprefix == "$" then
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
                local emb = CreateEmbed({},"The Game Bot Credits","These are cool people!")
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
               -- sendMessage("Happy birthday, <@".."960887298533244928"..">",channel)
                sendMessage("Command disabled",channel)
                --message:delete()
            end
            if ActualMessage == "purge" then
                local member = message.member -- Get the member who sent the message

                -- Check if the member has the required permission
                if member:hasPermission(discordia.enums.permission.manageMessages) then
                    local it = 0
                    message.channel:getMessages(tonumber(args[1])+1):forEach(function(msg)
                        it = it + 1
                        msg:delete()
                    end)
                    local msg = sendMessage("Success, purged "..args[1].." messages",channel)
                    os.execute('powershell -Command "Start-Sleep -Seconds 3"')
                    msg:delete()
                else
                    message.channel:send('You do not have the required permission.')
                end
            end
            if ActualMessage == "uptime" then
                sendMessage(os.time()-StartupTime,channel)
            end
            if ActualMessage == "g" then
                globaldata[#globaldata+1] = #globaldata+1
                local emb = CreateEmbed({},"This is a test text.", "Global data list")
                for _,i in pairs(globaldata) do
                    emb.fields[#emb.fields+1] =
                    {name = i, value = "A value in the global data", inline = false}
                end
                channel:send{embed = emb}
            end
            if ActualMessage == "f" then
                local emb = CreateEmbed({},"This is a test text.","Global data list")
                for _,i in pairs(globaldata) do
                    emb.fields[#emb.fields+1] =
                    {name = i, value = "A value in the global data", inline = false}
                end
                channel:send{embed = emb}
            end
            if ActualMessage == "kofi" then
                sendMessage("https://ko-fi.com/gamingtothepeople",channel)
            end
            if ActualMessage == "patreon" then
                local emb = CreateEmbed({},"Subscribe to us on Patreon!","Thank you so much for considering to subscribe to us! It really means the world to our team!")
                emb.image.url = "https://cdn.discordapp.com/attachments/1138942994683269261/1141135170628485120/asset-preview.png"
                emb.url = "https://www.patreon.com/GamingToThePeople"
                channel:send{embed = emb}
            end
        end
    end
end

client:on('messageCreate', function(message)
    local username = message.author.username
    local discriminator = message.author.discriminator
    if username..discriminator ~= botfullname then
        processCMD(message.content,message.channel,message)
    end
end)

client:run('Bot '..config[1])
