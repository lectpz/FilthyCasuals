local modName = "SandboxSyncFix"
--Udderly Commands
print("["..modName.."] Initializing UdderlyCommands Client..")
local Daikon = require("daikon_WrapperToMakeTheSettingsIG")


function Daikon.FakeMessage(msg, isAlert)
	local chatMsg = 
	{
		getTextWithPrefix = function(self)
			return msg
		end,

		getText = function(self)
			return msg
		end,
		
		setText = function(self, newMsg)
			msg = newMsg
		end,
		
		isOverHeadSpeech = function() return not isAlert end,
		isServerAlert = function() return isAlert end,
		isShowAuthor = function() return false end,
		isServerAuthor = function() return true end,
		getAuthor = function() return false end,
		getRadioChannel = function() return -1 end
	}
	chatMsg.__index = chatMsg
	if not isAlert then
		msg = "[Server] "..msg
	end
	ISChat.addLineInChat(setmetatable({ msg = msg.."\t" }, chatMsg), 0)
end
	
function Daikon.Split(s, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={}
	for str in string.gmatch(s, "([^"..sep.."]+)") do
		table.insert(t, str)
	end
	return t
end

function Daikon.IsAdmin()
	return isAdmin() or getAccessLevel() == "admin" or getAccessLevel() == "Admin"
end

local original = ISChat["onCommandEntered"]
ISChat["onCommandEntered"] = function(self)
	--print("["..modName.."] onCommandEntered")
	local commandText = ISChat.instance.textEntry:getText()
	ISChat.instance:logChatCommand(commandText)
	if commandText and commandText ~= "" then
		local strings = Daikon.Split(commandText)
		local enteredCommand = nil
		local args = {}
		--print("["..modName.."] Parsing Input \""..commandText.."\"")
		if #strings == 1 then
			--print("["..modName.."] No arguments found.")
			enteredCommand = string.sub(strings[1], 2, #strings[1])
		else
			--print("["..modName.."] Arguments found.")
			for i,arg in ipairs(strings) do
				if i == 1 then
					enteredCommand = string.sub(arg, 2, #arg)
					--print("["..modName.."] Entered command \""..enteredCommand.."\".")
				else
					table.insert(args, arg)
				end
			end
		end
		local command = Daikon.SandboxOptionsSyncing.Commands[enteredCommand]
		if command ~= nil and command ~= false then --If it has a function defined for client-side execution, run that.
			--print("["..modName.."] Command \""..command.."\" has client side code, running that.")
			local result = command(args)
			if result and result ~= "" then
				Daikon.FakeMessage(result, false)
			end
			return
		elseif command == false then --No client-side code but is present..
			--Should add callback for return values.
			--print("["..modName.."] Sending command to server.")
			sendClientCommand(modName, enteredCommand, args) --Send it to the server.
			return
		end --Unknown command for this mod, let it fall through.
		--print("["..modName.."] Command fall-through.")
	end
	--If we get here, we didn't find a command to run from our module.
	--print("["..modName.."] Falling back to vanilla handler (or whatever overrode it before us.")
	original(self) --So fall back to the vanilla (or whatever overrode it before us) handler.
end

print("["..modName.."] Initializing UdderlyCommands Commands..")
Daikon.SandboxOptionsSyncing.Commands["ForceClientsToUpdate"] = function(args)
	if not Daikon.IsAdmin() then
		return "You do not have access to this command."
	else
		sendClientCommand(modName, "ForceClientsToUpdate", args)
	end
end

Daikon.SandboxOptionsSyncing.Commands["RefreshModData"] = function(args)
	if not Daikon.IsAdmin() then
		return "You do not have access to this command."
	else
		sendClientCommand(modName, "RefreshModData", args)
	end
end
Daikon.SandboxOptionsSyncing.Commands["RefreshAndUpdate"] = function(args)
	if not Daikon.IsAdmin() then
		return "You do not have access to this command."
	else
		sendClientCommand(modName, "RefreshAndUpdate", args)
	end
end

return Daikon