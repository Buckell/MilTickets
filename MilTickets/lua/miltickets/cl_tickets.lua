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

MilTickets.FactionCache = {}

for faction,_ in MilTickets.Factions do
    MilTickets.FactionCache[faction] = {
        tickets = MilTickets.DefaultValues.tickets or 100,
        command_points = MilTickets.DefaultValues.command_points or 100
    }
end

net.Receive("MilTickets.UpdateCache", function ()
    MilTickets.FactionCache = net.ReadTable()
end)

net.Receive("MilTickets.FactionsReset", function ()
    hook.Run("MilTickets.FactionsReset")
end)