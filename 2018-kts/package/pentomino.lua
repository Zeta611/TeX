
-- pentomino.lua

luatexbase.provides_module({
  name        = 'pentomino',
  date        = '2018/01/10',
  version     = 0.1,
  description = 'Pentomino tiling',
  author      = 'Soojin Nam',
  license     = 'public domain',
})

pentomino = pentomino or {}
local pentomino = pentomino


local dlx = require "dlx"

local ipairs = ipairs
local sprint = tex.sprint
local tonumber = tonumber
local str_sub = string.sub
local find_file = kpse.find_file


local function draw (side, nr, nc, num)
   local fname = find_file(nr.."x"..nc..".dlx")
   local lines = {}
   for line in io.lines(fname) do
      lines[#lines+1] = line
   end
   
   local xc, err = dlx:new(lines)
   if not xc then
      sprint("setup error:", err)
      return
   end
   
   local box = {}
   for i=0,nr do box[i] = {} end

   local cnt=0
   for sol in xc:dance() do
      cnt = cnt+1
      if cnt > num then break end
      for _, opt in ipairs(sol) do
         local c = opt[1]
         for j=2,#opt do
            local x = tonumber(str_sub(opt[j],1,1), 36)
            local y = tonumber(str_sub(opt[j],2,2), 36)
            box[x][y] = c
         end
      end


      local nr, nc = nr-1, nc-1
      sprint("\\begin{Pentomino}["..side.."]\n")
      for j=0,nr do
         sprint("\\Row{")
         for k=0,nc-1 do
            sprint(box[j][k] or "B", ",")
         end
         sprint(box[j][nc] or "B", "}\n")
      end
      sprint("\\end{Pentomino}\n")
   end
end


pentomino.draw = draw

