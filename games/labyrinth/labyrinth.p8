pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
-- labyrinth descent
-- roguelike dungeon crawler

-- game constants
gw,gh=16,14
tw=8
mapw,maph=16,16

-- game state
state="title"
floor=1
maxfloor=10

-- player
p={
 x=0,y=0,
 hp=20,maxhp=20,
 atk=3,def=1,
 lvl=1,xp=0,xpnext=10,
 gold=0,potions=2
}

-- dungeon
dng={}
rooms={}

-- entities
enemies={}
items={}

-- fog of war
visible={}
explored={}

function _init()
 init_game()
end

function init_game()
 state="title"
 floor=1
 p={
  x=0,y=0,
  hp=20,maxhp=20,
  atk=3,def=1,
  lvl=1,xp=0,xpnext=10,
  gold=0,potions=2
 }
end

function start_game()
 state="playing"
 floor=1
 gen_dungeon()
end

function next_floor()
 floor+=1
 if floor>maxfloor then
  state="victory"
  return
 end
 gen_dungeon()
end

-- dungeon generation
function gen_dungeon()
 -- init dungeon (0=wall,1=floor,2=exit)
 dng={}
 for y=0,maph-1 do
  dng[y]={}
  for x=0,mapw-1 do
   dng[y][x]=0
  end
 end
 
 -- generate rooms
 rooms={}
 local rcount=5+flr(rnd(3))
 for i=1,rcount do
  local tries=50
  while tries>0 do
   local rw=3+flr(rnd(5))
   local rh=3+flr(rnd(5))
   local rx=1+flr(rnd(mapw-rw-2))
   local ry=1+flr(rnd(maph-rh-2))
   
   -- check overlap
   local ok=true
   for _,r in pairs(rooms) do
    if not (rx+rw+1<r.x or rx>r.x+r.w+1 or
            ry+rh+1<r.y or ry>r.y+r.h+1) then
     ok=false
     break
    end
   end
   
   if ok then
    add(rooms,{x=rx,y=ry,w=rw,h=rh})
    break
   end
   tries-=1
  end
 end
 
 -- carve rooms
 for _,r in pairs(rooms) do
  for y=r.y,r.y+r.h-1 do
   for x=r.x,r.x+r.w-1 do
    dng[y][x]=1
   end
  end
 end
 
 -- connect rooms
 for i=1,#rooms-1 do
  local r1=rooms[i]
  local r2=rooms[i+1]
  local cx1=r1.x+flr(r1.w/2)
  local cy1=r1.y+flr(r1.h/2)
  local cx2=r2.x+flr(r2.w/2)
  local cy2=r2.y+flr(r2.h/2)
  
  -- horizontal corridor
  local x1,x2=min(cx1,cx2),max(cx1,cx2)
  for x=x1,x2 do
   dng[cy1][x]=1
  end
  
  -- vertical corridor
  local y1,y2=min(cy1,cy2),max(cy1,cy2)
  for y=y1,y2 do
   dng[y][cx2]=1
  end
 end
 
 -- place player in first room
 local r1=rooms[1]
 p.x=r1.x+flr(r1.w/2)
 p.y=r1.y+flr(r1.h/2)
 
 -- place exit in last room
 local rlast=rooms[#rooms]
 local ex=rlast.x+flr(rlast.w/2)
 local ey=rlast.y+flr(rlast.h/2)
 dng[ey][ex]=2
 
 -- spawn enemies
 enemies={}
 for i=2,#rooms do
  local r=rooms[i]
  local ecount=1+flr(rnd(3))
  for j=1,ecount do
   local ex,ey
   local tries=20
   while tries>0 do
    ex=r.x+flr(rnd(r.w))
    ey=r.y+flr(rnd(r.h))
    if dng[ey][ex]==1 and not enemy_at(ex,ey) then
     break
    end
    tries-=1
   end
   
   -- select enemy type
   local roll=rnd(1)
   local etype="rat"
   if roll<0.1 then
    etype="dragon"
   elseif roll<0.2 then
    etype="orc"
   elseif roll<0.5 then
    etype="skeleton"
   end
   
   add(enemies,make_enemy(etype,ex,ey))
  end
 end
 
 -- spawn items
 items={}
 local icount=3+flr(rnd(4))
 for i=1,icount do
  local tries=30
  while tries>0 do
   local ix=1+flr(rnd(mapw-2))
   local iy=1+flr(rnd(maph-2))
   if dng[iy][ix]==1 and not item_at(ix,iy) and not enemy_at(ix,iy) and not (ix==p.x and iy==p.y) then
    local roll=rnd(1)
    local itype="gold"
    if roll<0.2 then
     itype="chest"
    elseif roll<0.4 then
     itype="potion"
    end
    add(items,{x=ix,y=iy,type=itype})
    break
   end
   tries-=1
  end
 end
 
 -- init fog of war
 visible={}
 explored={}
 for y=0,maph-1 do
  visible[y]={}
  explored[y]={}
  for x=0,mapw-1 do
   visible[y][x]=false
   explored[y][x]=false
  end
 end
 
 update_visibility()
end

function make_enemy(etype,x,y)
 local e={x=x,y=y,type=etype,cd=0}
 
 if etype=="rat" then
  e.hp=3+floor*0.5
  e.atk=1+flr(floor*0.3)
  e.def=0
  e.xpval=2
  e.gold={1,3}
  e.range=40
  e.spr=16
  e.col=8
 elseif etype=="skeleton" then
  e.hp=6+floor
  e.atk=2+flr(floor*0.4)
  e.def=1
  e.xpval=5
  e.gold={3,7}
  e.range=50
  e.spr=17
  e.col=6
 elseif etype=="orc" then
  e.hp=10+floor*1.5
  e.atk=4+flr(floor*0.5)
  e.def=2
  e.xpval=10
  e.gold={5,12}
  e.range=60
  e.spr=18
  e.col=3
 elseif etype=="dragon" then
  e.hp=20+floor*2
  e.atk=6+floor
  e.def=3
  e.xpval=25
  e.gold={15,30}
  e.range=70
  e.spr=19
  e.col=8
 end
 
 return e
end

function enemy_at(x,y)
 for e in all(enemies) do
  if e.x==x and e.y==y then
   return e
  end
 end
 return nil
end

function item_at(x,y)
 for i in all(items) do
  if i.x==x and i.y==y then
   return i
  end
 end
 return nil
end

-- visibility
function update_visibility()
 for y=0,maph-1 do
  for x=0,mapw-1 do
   visible[y][x]=false
  end
 end
 
 local vrange=6
 for dy=-vrange,vrange do
  for dx=-vrange,vrange do
   local tx=p.x+dx
   local ty=p.y+dy
   if tx>=0 and tx<mapw and ty>=0 and ty<maph then
    local dist=sqrt(dx*dx+dy*dy)
    if dist<=vrange and has_los(p.x,p.y,tx,ty) then
     visible[ty][tx]=true
     explored[ty][tx]=true
    end
   end
  end
 end
end

function has_los(x0,y0,x1,y1)
 local dx=abs(x1-x0)
 local dy=abs(y1-y0)
 local sx=x0<x1 and 1 or -1
 local sy=y0<y1 and 1 or -1
 local err=dx-dy
 
 while true do
  if x0==x1 and y0==y1 then
   return true
  end
  
  if dng[y0] and dng[y0][x0]==0 then
   return false
  end
  
  local e2=2*err
  if e2>-dy then
   err-=dy
   x0+=sx
  end
  if e2<dx then
   err+=dx
   y0+=sy
  end
 end
end

-- update
function _update()
 if state=="title" then
  if btnp(5) then
   start_game()
  end
 elseif state=="playing" then
  update_playing()
 elseif state=="levelup" then
  update_levelup()
 elseif state=="gameover" then
  if btnp(5) then
   init_game()
   start_game()
  end
 elseif state=="victory" then
  if btnp(5) then
   init_game()
  end
 end
end

lvlupt=0
function update_levelup()
 lvlupt+=1
 if lvlupt>=60 then
  state="playing"
  lvlupt=0
 end
end

function update_playing()
 -- player input
 local moved=false
 if btnp(0) then moved=try_move(-1,0) end
 if btnp(1) then moved=try_move(1,0) end
 if btnp(2) then moved=try_move(0,-1) end
 if btnp(3) then moved=try_move(0,1) end
 
 -- use potion
 if btnp(5) and p.potions>0 and p.hp<p.maxhp then
  p.hp=min(p.hp+10,p.maxhp)
  p.potions-=1
  moved=true
 end
 
 -- enemy turn
 if moved then
  enemy_turn()
  update_visibility()
 end
end

function try_move(dx,dy)
 local nx=p.x+dx
 local ny=p.y+dy
 
 -- bounds check
 if nx<0 or nx>=mapw or ny<0 or ny>=maph then
  return false
 end
 
 -- wall check
 if dng[ny][nx]==0 then
  return false
 end
 
 -- enemy check
 local e=enemy_at(nx,ny)
 if e then
  do_combat(p,e)
  return true
 end
 
 -- move
 p.x=nx
 p.y=ny
 
 -- check exit
 if dng[ny][nx]==2 then
  next_floor()
  return true
 end
 
 -- pick up items
 local itm=item_at(nx,ny)
 if itm then
  pickup_item(itm)
  del(items,itm)
 end
 
 return true
end

function pickup_item(itm)
 if itm.type=="gold" then
  p.gold+=5+flr(rnd(11))
 elseif itm.type=="potion" then
  p.potions+=1
 elseif itm.type=="chest" then
  p.gold+=10+flr(rnd(21))
  if rnd(1)<0.5 then
   p.potions+=1
  end
 end
end

function do_combat(attacker,defender)
 local dmg=max(1,attacker.atk-defender.def)
 defender.hp-=dmg
 
 if defender.hp<=0 then
  if defender==p then
   state="gameover"
  else
   -- enemy died
   p.xp+=defender.xpval
   p.gold+=defender.gold[1]+flr(rnd(defender.gold[2]-defender.gold[1]+1))
   del(enemies,defender)
   check_levelup()
  end
 end
end

function check_levelup()
 while p.xp>=p.xpnext do
  p.lvl+=1
  p.xp-=p.xpnext
  p.xpnext=10*p.lvl
  p.maxhp+=5
  p.hp=p.maxhp
  p.atk+=1
  p.def+=1
  state="levelup"
  lvlupt=0
 end
end

function enemy_turn()
 for e in all(enemies) do
  if e.cd>0 then
   e.cd-=1
  end
  
  -- check if visible
  if not visible[e.y] or not visible[e.y][e.x] then
   goto continue
  end
  
  local dx=p.x-e.x
  local dy=p.y-e.y
  local dist=sqrt(dx*dx+dy*dy)*8
  
  -- in range?
  if dist>e.range then
   goto continue
  end
  
  -- adjacent? attack!
  if abs(dx)<=1 and abs(dy)<=1 and (dx!=0 or dy!=0) then
   if e.cd==0 then
    do_combat(e,p)
    e.cd=20
   end
   goto continue
  end
  
  -- move toward player
  local mx=0
  local my=0
  if abs(dx)>abs(dy) then
   mx=dx>0 and 1 or -1
  else
   my=dy>0 and 1 or -1
  end
  
  local nx=e.x+mx
  local ny=e.y+my
  
  if nx>=0 and nx<mapw and ny>=0 and ny<maph and dng[ny][nx]>0 and not enemy_at(nx,ny) then
   e.x=nx
   e.y=ny
  end
  
  ::continue::
 end
end

-- draw
function _draw()
 cls(0)
 
 if state=="title" then
  draw_title()
 elseif state=="playing" then
  draw_playing()
 elseif state=="levelup" then
  draw_playing()
  draw_levelup()
 elseif state=="gameover" then
  draw_gameover()
 elseif state=="victory" then
  draw_victory()
 end
end

function draw_title()
 cls(0)
 print("labyrinth descent",20,40,12)
 print("press ❎ to start",20,70,7)
 print("",0,80,6)
 print("arrows: move",32,90,6)
 print("❎: use potion",32,98,6)
end

function draw_playing()
 -- draw hud
 rectfill(0,0,127,10,1)
 print("hp:"..p.hp.."/"..p.maxhp,2,2,8)
 print("lv:"..p.lvl,48,2,12)
 print("f:"..floor,76,2,11)
 print("$"..p.gold,98,2,10)
 
 -- draw dungeon
 for y=0,gh-1 do
  for x=0,gw-1 do
   local sx=x*tw
   local sy=y*tw+12
   local dx=x
   local dy=y
   
   if not explored[dy] or not explored[dy][dx] then
    rectfill(sx,sy,sx+tw-1,sy+tw-1,0)
   elseif not visible[dy] or not visible[dy][dx] then
    -- explored but not visible
    local t=dng[dy][dx]
    if t==0 then
     rectfill(sx,sy,sx+tw-1,sy+tw-1,1)
    else
     rectfill(sx,sy,sx+tw-1,sy+tw-1,2)
    end
   else
    -- visible
    local t=dng[dy][dx]
    if t==0 then
     rectfill(sx,sy,sx+tw-1,sy+tw-1,5)
    elseif t==2 then
     rectfill(sx,sy,sx+tw-1,sy+tw-1,6)
     spr(35,sx,sy)
    else
     rectfill(sx,sy,sx+tw-1,sy+tw-1,6)
    end
    
    -- draw items
    local itm=item_at(dx,dy)
    if itm then
     if itm.type=="gold" then
      spr(32,sx,sy)
     elseif itm.type=="potion" then
      spr(33,sx,sy)
     elseif itm.type=="chest" then
      spr(34,sx,sy)
     end
    end
    
    -- draw enemies
    local e=enemy_at(dx,dy)
    if e then
     spr(e.spr,sx,sy)
    end
    
    -- draw player
    if dx==p.x and dy==p.y then
     spr(1,sx,sy)
    end
   end
  end
 end
 
 -- draw potion count
 print("pot:"..p.potions,2,120,12)
end

function draw_levelup()
 rectfill(20,50,108,70,0)
 rect(20,50,108,70,7)
 print("level up!",40,56,10)
 print("lv "..p.lvl,50,63,7)
end

function draw_gameover()
 cls(0)
 print("game over",42,50,8)
 print("floor: "..floor,46,65,7)
 print("gold: "..p.gold,46,73,7)
 print("press ❎ to restart",20,90,7)
end

function draw_victory()
 cls(0)
 print("victory!",44,50,11)
 print("you escaped the",28,65,7)
 print("labyrinth!",38,73,7)
 print("gold: "..p.gold,46,85,10)
 print("press ❎ for menu",24,100,7)
end

__gfx__
00000000000660000077770000333300008888000000000000aaa00000aaa00000999000000000000000000000000000000000000000000000000000000000
00000000006776000777777003333330088888800000000000aaa0000aaaa000099a990000000000000000000000000000000000000000000000000000000000
00700700067777607777777733333333888888880000000000aaa000aaaaaa0099aaa900000000000000000000000000000000000000000000000000000000000
00077000077777707777777733333333888888880000000000aaa000aaaaaa009aaaaaa000000000000000000000000000000000000000000000000000000000
00077000007777000777770003333300088888000000000000aaa0000aaaa00009aaa90000000000000000000000000000000000000000000000000000000000
00700700000770000077700000333000008880000000000000aaa00000aa000009999000000000000000000000000000000000000000000000000000000000000
00000000000660000066600000033000000880000000000000aaa00000aa0000009900000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00088000000ddd00000ccc00000bbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00888800000ddd000cccccc000bbb0b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08888880000ddd00cc6cc6cc00bbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08888880000d0d00ccc66ccc0bbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08888880000ddd00cccccccc00bbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00888800000d0d000cccccc000bb0b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00088000000ddd00000cc00000bbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000aa000000cc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00aaaa0000ccc0c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a9aa9a000ccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0aaaaaa000cc0cc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0aaaaaa0000ccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00aaaa00000c0c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000aa0000000c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
