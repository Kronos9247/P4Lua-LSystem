--[[
    A simple LSystem handler library written for processing4lua 
    
    Copyright (C) 2017  Rafael Orman

    The P4Lua-LSystem Library is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program. If not, see <http://www.gnu.org/licenses/>.
]]--

LSystem = {}
function LSystem.newRenderer( push, pop, plus, minus, forward, begin, fend )
  local renderer = {}
  renderer.renderer = true;
  renderer.push = push;
  renderer.pop = pop;
  renderer.plus = plus;
  renderer.minus = minus;
  renderer.forward = forward;

  renderer.begin = begin;
  renderer.fend = fend;

  return renderer;
end

local function charAt( str, index )
  return string.sub( str, index, index );
end

local function newSystem( system, interations, renderer )
  local lsystem = {}
  lsystem.degree = system.degree;
  lsystem.rules = system.rules;

  local localSys = system.axoim;

  for i=0, interations do
    local temp = "";

    for j=1, string.len(localSys) + 1 do
      local char = charAt( localSys, j );
      
      if system.rules[char] then
        temp = temp .. system.rules[char];
      else
        temp = temp .. char;
      end
    end

    localSys = temp;
  end

  lsystem.fsystem = localSys;

  if not renderer then
    lsystem.engine = LSystem.newRenderer( function()
        pushMatrix();
      end,
      function()
        popMatrix();
      end,

      function( degree )
        rotate( radians(degree) );
      end,
      function( degree )
        rotate( radians(degree) );
      end,

      function( len )
        line(0, 0, 0, -len);
        translate(0, -len);
      end,

      function()
        --beginShape();
      end,
      function()
        --endShape();
      end
    );
  else
    lsystem.engine = renderer;
  end

  function lsystem:draw()
    lsystem.engine.begin();
    
    for i=1, string.len(lsystem.fsystem) + 1 do
      local char = charAt( lsystem.fsystem, i );
      
      if char == "F" or lsystem.rules[char] then
        lsystem.engine.forward( 1.5 );
      elseif char == "[" then
        lsystem.engine.push();
      elseif char == "]" then
        lsystem.engine.pop();
      elseif char == "+" then
        lsystem.engine.plus( lsystem.degree );
      elseif char == "-" then
        lsystem.engine.minus( -lsystem.degree );
      end
    end
    
    lsystem.engine.fend();
  end

  return lsystem;
end

function LSystem.new( axoim, rules, degree, constants )
  local system = {}
  system.axoim = axoim;
  system.rules = rules;
  system.degree = degree;
  system.constants = constants;

  function system:parse( interations, renderer )
    local lsystem = newSystem( self, interations, renderer );

    return lsystem
  end
  
  return system
end
