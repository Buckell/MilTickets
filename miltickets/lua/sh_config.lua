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

MilTickets.Factions = {
    ["us"] = {
        name = "United States"
    },
    ["ru"] = {
        name = "Russia"
    }
}

-- Starting values for tickets and command points.
MilTickets.DefaultValues = {
    command_points = 100,
    tickets = 150
}

-- Faction tickets and command points will reset to default values after this many days pass.
MilTickets.AutoResetDays = 7

local AdminGroups = {
    ["owner"] = true,
    ["developer"] = true,
    ["superadmin"] = true
}

-- Configuration function. Return true if user is an admin or false if not.
MilTickets.IsPlayerAdmin = function (ply)
    return AdminGroups[ply:GetUserGroup()] or false
end

-- Configuration function. Return faction "id" or nil (for no faction).
MilTickets.GetPlayerFaction = function (ply)
    return ply:getJobTable().faction 
end

