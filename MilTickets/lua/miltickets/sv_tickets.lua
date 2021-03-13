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

function MilTickets.PopulateCache()
    MilTickets.FactionCache = {}

    local query = sql.Query("SELECT * FROM MilTickets_Factions")

    for _,row in query do
        MilTickets.FactionCache[row["Faction"]] = {
            tickets = row["Tickets"],
            command_points = row["CommandPoints"]
        }
    end
end

function MilTickets.GetAutoResetStartTime()
    return sql.QueryValue("SELECT * FROM MilTickets_Timing")
end

function MilTickets.BroadcastCache()
    net.Start("MilTickets.UpdateCache")
    net.WriteTable(MilTickets.FactionCache)
    net.Broadcast()
end

function MilTickets.ResetFactions()
    sql.Query("UPDATE MilTickets_Factions SET Tickets=" .. (MilTickets.DefaultValues.tickets or 100) .. ", CommandPoints=" .. (MilTickets.DefaultValues.command_points or 100))

    MilTickets.FactionCache = {}

    for faction,_ in pairs(MilTickets.Factions) do
        MilTickets.FactionCache[faction] = {
            tickets = MilTickets.DefaultValues.tickets or 100,
            command_points = MilTickets.DefaultValues.command_points or 100
        }
    end

    MilTickets.BroadcastCache()
    
    hook.Run("MilTickets.FactionsReset")

    net.Start("MilTickets.FactionsReset")
    net.Broadcast()
end

util.AddNetworkString("MilTickets.FactionsReset")
util.AddNetworkString("MilTickets.UpdateCache")

if MilTickets.AutoResetDays and not sql.TableExists("MilTickets_Timing") then
    sql.Query("CREATE TABLE MilTickets_Timing (StartTime BIGINT)")
    sql.Query("INSERT INTO MilTickets_Timing VALUES (" .. os.time() .. ")")
end

if not sql.TableExists("MilTickets_Factions") then
    sql.Begin()
    sql.Query("CREATE TABLE MilTickets_Factions (Faction TINYTEXT, Tickets BIGINT, CommandPoints BIGINT)")

    for faction,_ in pairs(MilTickets.Factions) do
        sql.Query("INSERT INTO MilTickets_Factions VALUES ('" .. SQLStr(faction) .. "', " .. (MilTickets.DefaultValues.tickets or 100) .. ", " .. (MilTickets.DefaultValues.command_points or 100) .. ")")
    end

    sql.Commit()
end

MilTickets.PopulateCache()

if MilTickets.AutoResetDays then
    local cached_start_time = MilTickets.GetAutoResetStartTime()
    local delay_seconds = MilTickets.AutoResetDays * 86400

    timer.Create("MilTickets.AutoReset", 10, function ()
        if os.time() - delay_seconds >= cached_start_time then
            MilTickets.ResetFactions()
        end
    end)
end