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

        command.call(ply, unpack(arg))
    end
end

hook.Add("PlayerSay", "MilTickets.CommandDispatch", function (ply, text, team)
    if string.StartWith(text, "/") then
        local line = string.sub(text, 2)

        local args = string.Split(line, " ")
        local identifier = table.remove(args, 1)
        
        MilTickets.DispatchCommand(identifier, ply, unpack(args))
    end
end)

MilTickets.AddCommand("force_reset_factions", true, function (ply, args)
    MilTickets.ResetFactions()
end)