--[[
Copyright (C) 2017 John Cole
This file is part of Chat Filter.

Chat Filter is free software: you can redistribute it and/or modify
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

local should_pass = {
	'spacky',        --
	'circumference', -- cum
	'coke',          -- cok
	'discomfort',    --
	'fake',          -- fak
	'principal',     -- cipa
	'racoon',        -- coon
	'saturday',      -- turd
	'scraps',        -- crap
	'scrap',         -- crap
}

local should_fail = {
	'cipa',
	'crap',
	'cum',
	'fak',
	'sartorius',
	'turd',
}

local bad_words = dofile('word_list.lua')

local not_pg = function(s)
	s = s:lower()
	local match = nil
	for _, word in pairs(bad_words) do
		match = string.match(s, word)
		if match then
			break
		end
	end
	return match
end

local count = 0
for _,s in pairs(should_pass) do
	local match = not_pg(s)
	if match then
		count = count + 1
		print(s..' was filtered but it should pass. Matched: "'..match..'"')
	end
end

for _,s in pairs(should_fail) do
	local match = not_pg(s)
	if not match then
		count = count + 1
		print(s..' passed but should have been filtered.')
	end
end

if count == 0 then
	print('All tests pass.')
else
	print('Test complete with '..count..' errors.')
end
