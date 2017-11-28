require "lsystem";

function settings()
  size(700, 600);
end

local lsys;
function setup()
  local System = LSystem.new( "FX", { X="X+YF+", Y="-FX-Y" }, 90 );
  lsys = System:parse( 12 );
  
  noLoop();
end

function draw()
  background(51);
  stroke(255);
  
  pushMatrix();
  translate(width/2, height/2);
  
  lsys:draw()
  popMatrix();
end
