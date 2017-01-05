--[[
Copyright (C) 2017 John Cole
This file is part of Chat Filter.

Stats is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Chat Filter is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Chat Filter.  If not, see <http://www.gnu.org/licenses/>.
]]

local modpath = minetest.get_modpath('chat_filter')
local bad_words = dofile(modpath..'/word_list.lua')

local not_pg = function(s)
	s = s:lower()
	for _, word in pairs(bad_words) do
		if string.find(s, word, 1, false) then
			return true
		end
	end
end

local filter = function(name, message)
	if not_pg(message) then
		minetest.log('action', 'CHAT: filtered <'..name..'> '..message)
		minetest.chat_send_player(name, 'Please keep global chat rated PG.')
		minetest.sound_play('chat_filter_censor', {to_player = sendto, gain = 0.2})
		return true
	end
	if message:len() > 12 and message == message:upper() then
		minetest.log('action', 'CHAT: filtered <'..name..'> '..message)
		minetest.chat_send_player(name, 'Please don\'t use all caps.')
		minetest.sound_play('chat_filter_censor', {to_player = sendto, gain = 0.2})
		return true
	end
end

minetest.register_on_chat_message(function(name, message)
	return filter(name, message)
end)

if minetest.chatcommands['me'] then
	local org = minetest.chatcommands['me'].func
	minetest.chatcommands['me'].func = function(name, param)
		return filter(name, param) or org(name, param)
	end
end
