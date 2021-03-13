--[[

MilTickets - Garry's Mod addon for adding a resource "ticket" system to the MilitaryRP gamemode.
Copyright (C) 2021 Max Goddard

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License along
with this program; if not, write to the Free Software Foundation, Inc.,
51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

<max@altis.gg>

]]--

MilTickets.Commands = {}

function MilTickets.AddCommand(identifier, admin_only, func)
    MilTickets[identifier] = {
        admin_only,
        call = func
    }
end

function MilTickets.DispatchCommand(identifier, ply, ...)
    local command = MilTickets[identifier]

    if command then
        if command.admin_only and not MilTickets.IsPlayerAdmin(ply) then
            ply:ChatPrint("This command is restricted to administrators only.")
            return
        end

        command.call(ply, arg)

        return true
    else
        return false
    end
end

hook.Add("PlayerSay", "MilTickets.CommandDispatch", function (ply, text, team)
    if string.StartWith(text, "/") then
        local line = string.sub(text, 2)

        local args = string.Split(line, " ")
        local identifier = table.remove(args, 1)
        
        if MilTickets.DispatchCommand(identifier, ply, unpack(args)) then
            return ""
        end
    end
end)

MilTickets.AddCommand("tickets", false, function (ply, args)
    if #args > 0 then
        local faction = args[1]
        local table = MilTickets.Factions[faction]

        if table then
            local tickets, command_points = MilTickets.GetFactionNumbers(faction)
            ply:ChatPrint(table.name .. ": " .. tickets .. " (Tickets), " .. command_points .. " (Command Points)")
        else
            ply:ChatPrint("The specified faction \"" .. faction .. "\" does not exist. Use /factionlist for a list of factions.")
        end
    else
        local faction = MilTickets.GetPlayerFaction(ply)

        if faction then
            local tickets, command_points = MilTickets.GetFactionNumbers(faction)
            ply:ChatPrint(MilTickets.Factions[faction].name .. ": " .. tickets .. " (Tickets), " .. command_points .. " (Command Points)")
        else
            ply:ChatPrint("You do not belong to a faction. Use /tickets <faction> to get a certain faction's tickets and command points.")
        end
    end
end)

MilTickets.AddCommand("factionlist", false, function (ply, args)
    for k,v in pairs(MilTickets.Factions) do
        ply:ChatPrint("[" .. k .. "] " .. v)
    end
end)

MilTickets.AddCommand("force_reset_factions", true, function (ply, args)
    MilTickets.ResetFactions()
    ply:ChatPrint("Factions have been reset.")
end)

MilTickets.AddCommand("set_tickets", true, function (ply, args)
    local faction = args[1]
    local amount = args[2]

    if MilTickets.Factions[faction] and isnumber(amount) then
        MilTickets.SetFactionTickets(faction, amount)
        ply:ChatPrint("Set the " .. faction .. " faction's tickets to " .. amount .. ".")
    else
        ply:ChatPrint("The specified faction \"" .. faction .. "\" does not exist or an invalid amount was specified. Use /factionlist for a list of factions.")
    end
end)

MilTickets.AddCommand("add_tickets", true, function (ply, args)
    local faction = args[1]
    local amount = args[2]

    if MilTickets.Factions[faction] and isnumber(amount) then
        MilTickets.AddFactionTickets(faction, amount)
        ply:ChatPrint("Added " .. amount .. " tickets to " .. faction .. " faction.")
    else
        ply:ChatPrint("The specified faction \"" .. faction .. "\" does not exist or an invalid amount was specified. Use /factionlist for a list of factions.")
    end
end)

MilTickets.AddCommand("deduct_tickets", true, function (ply, args)
    local faction = args[1]
    local amount = args[2]

    if MilTickets.Factions[faction] and isnumber(amount) then
        MilTickets.DeductFactionTickets(faction, amount)
        ply:ChatPrint("Deducted " .. amount .. " tickets from " .. faction .. " faction.")
    else
        ply:ChatPrint("The specified faction \"" .. faction .. "\" does not exist or an invalid amount was specified. Use /factionlist for a list of factions.")
    end
end)

MilTickets.AddCommand("set_command_points", true, function (ply, args)
    local faction = args[1]
    local amount = args[2]

    if MilTickets.Factions[faction] and isnumber(amount) then
        MilTickets.SetFactionCommandPoints(faction, amount)
        ply:ChatPrint("Set the " .. faction .. " faction's command points to " .. amount .. ".")
    else
        ply:ChatPrint("The specified faction \"" .. faction .. "\" does not exist or an invalid amount was specified. Use /factionlist for a list of factions.")
    end
end)

MilTickets.AddCommand("add_command_points", true, function (ply, args)
    local faction = args[1]
    local amount = args[2]

    if MilTickets.Factions[faction] and isnumber(amount) then
        MilTickets.AddFactionCommandPoints(faction, amount)
        ply:ChatPrint("Added " .. amount .. " command points to " .. faction .. " faction.")
    else
        ply:ChatPrint("The specified faction \"" .. faction .. "\" does not exist or an invalid amount was specified. Use /factionlist for a list of factions.")
    end
end)

MilTickets.AddCommand("deduct_command_points", true, function (ply, args)
    local faction = args[1]
    local amount = args[2]

    if MilTickets.Factions[faction] and isnumber(amount) then
        MilTickets.DeductFactionCommandPoints(faction, amount)
        ply:ChatPrint("Deducted " .. amount .. " command points from " .. faction .. " faction.")
    else
        ply:ChatPrint("The specified faction \"" .. faction .. "\" does not exist or an invalid amount was specified. Use /factionlist for a list of factions.")
    end
end)