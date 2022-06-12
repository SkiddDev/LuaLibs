local SkidLib = {}

local BlockedRemotes = {}

local Events = {
    Fire = true, 
    Invoke = true, 
    FireServer = true, 
    InvokeServer = true,
}

local gameMeta = getrawmetatable(game)
local psuedoEnv = {
    ["__index"] = gameMeta.__index,
    ["__namecall"] = gameMeta.__namecall;
}
setreadonly(gameMeta, false)
gameMeta.__index, gameMeta.__namecall = newcclosure(function(self, index, ...)
    if Events[index] then
        for i,v in pairs(BlockedRemotes) do
            if v == self.Name and not checkcaller() then return nil end
        end
    end
    return psuedoEnv.__index(self, index, ...)
end)
setreadonly(gameMeta, true)


function SkidLib:BlockRemote(RemoteName)
    if not table.find(BlockedRemotes, RemoteName) then
        table.insert(BlockedRemotes, RemoteName);
    end
end

function SkidLib:UnBlockRemote(RemoteName)
    if table.find(BlockedRemotes, RemoteName) then
        table.remove(BlockedRemotes, table.find(BlockedRemotes, RemoteName));
    end
end

return SkidLib;
