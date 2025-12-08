pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- labyrinth descent
-- a roguelike dungeon crawler

function _init()
 init_game()
end

function init_game()
 -- game state
 state="title"
 floor=1
 lvluptimer=0
 
 -- player
 p={
  x=0,y=0,
  hp=20,maxhp=20,
  atk=3,def=1,
  lvl=1,exp=0,
  gold=0,pots=2
 }
 
 -- dungeon grid (16x16)
 dng={}
 for i=0,15 do
  dng[i]={}
  for j=0,15 do
   dng[i][j]=0 -- 0=wall
  end
 end
 
 -- entities
 enemies={}
 items={}
 
 -- rooms for generation
 rooms={}
 
 -- generate first level
 gen_level()
end

function gen_level()
 -- clear dungeon
 for i=0,15 do
  for j=0,15 do
   dng[i][j]=0
  end
 end
 
 rooms={}
 enemies={}
 items={}
 
 -- generate 5-7 rooms
 local nrooms=5+flr(rnd(3))
 
 for r=1,nrooms do
  local rx,ry,rw,rh
  local tries=0
  local valid=false
  
  -- find valid room position
  repeat
   rx=1+flr(rnd(13))
   ry=1+flr(rnd(13))
   rw=3+flr(rnd(5))
   rh=3+flr(rnd(5))
   
   if rx+rw<15 and ry+rh<15 then
    valid=true
    -- check overlap
    for _,room in pairs(rooms) do
     if not(rx+rw<room.x or rx>room.x+room.w or
            ry+rh<room.y or ry>room.y+room.h) then
      valid=false
      break
     end
    end
   end
   
   tries+=1
  until valid or tries>50
  
  if valid then
   -- carve room
   for i=rx,rx+rw-1 do
    for j=ry,ry+rh-1 do
     dng[i][j]=1 -- floor
    end
   end
   
   add(rooms,{x=rx,y=ry,w=rw,h=rh,
              cx=rx+flr(rw/2),
              cy=ry+flr(rh/2)})
   
   -- connect to previous room
   if #rooms>1 then
    local prev=rooms[#rooms-1]
    local curr=rooms[#rooms]
    
    -- horizontal corridor
    local x1=min(prev.cx,curr.cx)
    local x2=max(prev.cx,curr.cx)
    for i=x1,x2 do
     dng[i][prev.cy]=1
    end
    
    -- vertical corridor
    local y1=min(prev.cy,curr.cy)
    local y2=max(prev.cy,curr.cy)
    for j=y1,y2 do
     dng[curr.cx][j]=1
    end
   end
  end
 end
 
 -- place player in first room
 if #rooms>0 then
  p.x=rooms[1].cx
  p.y=rooms[1].cy
 end
 
 -- place exit in last room
 if #rooms>1 then
  local lastroom=rooms[#rooms]
  dng[lastroom.cx][lastroom.cy]=2 -- exit
 end
 
 -- spawn enemies
 spawn_enemies()
 
 -- spawn items
 spawn_items()
end

function spawn_enemies()
 local etypes={
  {n="rat",s=16,hp=3,atk=1,def=0,exp=2,gold={1,3},ch=0.4},
  {n="skeleton",s=17,hp=6,atk=2,def=1,exp=5,gold={3,7},ch=0.3},
  {n="orc",s=18,hp=10,atk=4,def=2,exp=10,gold={5,12},ch=0.2},
  {n="dragon",s=19,hp=20,atk=6,def=3,exp=25,gold={15,30},ch=0.1}
 }
 
 -- scale with floor
 local floorscale=1+(floor-1)*0.2
 
 -- spawn in rooms (skip first room)
 for i=2,#rooms do
  local room=rooms[i]
  local nemies=1+flr(rnd(3))
  
  for e=1,nemies do
   -- pick enemy type
   local etype=nil
   local r=rnd()
   for _,et in pairs(etypes) do
    if r<et.ch then
     etype=et
     break
    end
   end
   etype=etype or etypes[1]
   
   -- spawn enemy
   local ex=room.x+flr(rnd(room.w))
   local ey=room.y+flr(rnd(room.h))
   
   if dng[ex][ey]==1 then
    add(enemies,{
     x=ex,y=ey,
     name=etype.n,
     s=etype.s,
     hp=flr(etype.hp*floorscale),
     maxhp=flr(etype.hp*floorscale),
     atk=flr(etype.atk*floorscale),
     def=etype.def,
     exp=etype.exp,
     goldmin=etype.gold[1],
     goldmax=etype.gold[2]
    })
   end
  end
 end
end

function spawn_items()
 -- spawn gold piles
 for i=1,2+flr(rnd(3)) do
  local room=rooms[1+flr(rnd(#rooms))]
  local ix=room.x+flr(rnd(room.w))
  local iy=room.y+flr(rnd(room.h))
  
  if dng[ix][iy]==1 then
   add(items,{
    x=ix,y=iy,
    t="gold",
    s=33,
    v=5+flr(rnd(11))
   })
  end
 end
 
 -- spawn potions
 for i=1,1+flr(rnd(2)) do
  local room=rooms[1+flr(rnd(#rooms))]
  local ix=room.x+flr(rnd(room.w))
  local iy=room.y+flr(rnd(room.h))
  
  if dng[ix][iy]==1 then
   add(items,{
    x=ix,y=iy,
    t="potion",
    s=32,
    v=10
   })
  end
 end
 
 -- spawn chest
 if rnd()<0.3 then
  local room=rooms[1+flr(rnd(#rooms))]
  local ix=room.x+flr(rnd(room.w))
  local iy=room.y+flr(rnd(room.h))
  
  if dng[ix][iy]==1 then
   add(items,{
    x=ix,y=iy,
    t="chest",
    s=34,
    gold=10+flr(rnd(21)),
    pot=rnd()<0.5
   })
  end
 end
end

function _update()
 if state=="title" then
  if btnp(5) then
   state="playing"
  end
 elseif state=="playing" then
  update_playing()
 elseif state=="levelup" then
  lvluptimer-=1
  if lvluptimer<=0 then
   state="playing"
  end
 elseif state=="gameover" or state=="victory" then
  if btnp(5) then
   init_game()
  end
 end
end

function update_playing()
 local moved=false
 local dx,dy=0,0
 
 -- movement
 if btnp(2) then dy=-1 moved=true end
 if btnp(3) then dy=1 moved=true end
 if btnp(0) then dx=-1 moved=true end
 if btnp(1) then dx=1 moved=true end
 
 -- use potion
 if btnp(5) then
  if p.pots>0 and p.hp<p.maxhp then
   p.pots-=1
   p.hp=min(p.maxhp,p.hp+10)
   sfx(0)
  end
 end
 
 if moved then
  local nx,ny=p.x+dx,p.y+dy
  
  -- check bounds
  if nx>=0 and nx<=15 and ny>=0 and ny<=15 then
   -- check wall
   if dng[nx][ny]!=0 then
    -- check enemy collision
    local enemy=get_enemy_at(nx,ny)
    if enemy then
     -- attack enemy
     do_combat(p,enemy)
     enemy_turn()
    else
     -- move player
     p.x=nx
     p.y=ny
     
     -- check exit
     if dng[nx][ny]==2 then
      next_floor()
     end
     
     -- check items
     check_items()
     
     enemy_turn()
    end
   end
  end
 end
 
 -- check game over
 if p.hp<=0 then
  state="gameover"
 end
end

function get_enemy_at(x,y)
 for e in all(enemies) do
  if e.x==x and e.y==y then
   return e
  end
 end
 return nil
end

function do_combat(attacker,defender)
 local dmg=max(1,attacker.atk-defender.def)
 defender.hp-=dmg
 
 if defender.hp<=0 then
  if defender==p then
   -- player died
   state="gameover"
  else
   -- enemy died
   del(enemies,defender)
   
   -- grant exp
   p.exp+=defender.exp
   
   -- drop gold
   p.gold+=defender.goldmin+flr(rnd(defender.goldmax-defender.goldmin+1))
   
   -- check level up
   check_levelup()
   
   sfx(1)
  end
 end
end

function check_levelup()
 local expneeded=p.lvl*10
 
 if p.exp>=expneeded then
  p.exp-=expneeded
  p.lvl+=1
  p.maxhp+=5
  p.hp=p.maxhp
  p.atk+=1
  p.def+=1
  
  state="levelup"
  lvluptimer=60
  
  sfx(2)
 end
end

function enemy_turn()
 for e in all(enemies) do
  -- simple ai: move toward player if close
  local dist=abs(e.x-p.x)+abs(e.y-p.y)
  
  if dist<=6 then
   local dx=sgn(p.x-e.x)
   local dy=sgn(p.y-e.y)
   
   -- try to move
   local moved=false
   if abs(p.x-e.x)>abs(p.y-e.y) then
    if try_enemy_move(e,dx,0) then
     moved=true
    elseif try_enemy_move(e,0,dy) then
     moved=true
    end
   else
    if try_enemy_move(e,0,dy) then
     moved=true
    elseif try_enemy_move(e,dx,0) then
     moved=true
    end
   end
  end
 end
end

function try_enemy_move(e,dx,dy)
 local nx,ny=e.x+dx,e.y+dy
 
 if nx>=0 and nx<=15 and ny>=0 and ny<=15 then
  if dng[nx][ny]!=0 then
   -- check if player is there
   if nx==p.x and ny==p.y then
    do_combat(e,p)
    return true
   end
   
   -- check if another enemy is there
   if not get_enemy_at(nx,ny) then
    e.x=nx
    e.y=ny
    return true
   end
  end
 end
 
 return false
end

function check_items()
 for item in all(items) do
  if item.x==p.x and item.y==p.y then
   if item.t=="gold" then
    p.gold+=item.v
    sfx(3)
   elseif item.t=="potion" then
    p.pots+=1
    sfx(0)
   elseif item.t=="chest" then
    p.gold+=item.gold
    if item.pot then
     p.pots+=1
    end
    sfx(3)
   end
   
   del(items,item)
  end
 end
end

function next_floor()
 floor+=1
 
 if floor>10 then
  state="victory"
 else
  gen_level()
  sfx(4)
 end
end

function _draw()
 cls()
 
 if state=="title" then
  draw_title()
 elseif state=="playing" or state=="levelup" then
  draw_game()
  if state=="levelup" then
   draw_levelup()
  end
 elseif state=="gameover" then
  draw_gameover()
 elseif state=="victory" then
  draw_victory()
 end
end

function draw_title()
 cls(0)
 print("labyrinth descent",22,40,12)
 print("press x to start",24,70,7)
 print("arrows: move",30,90,6)
 print("x: use potion",30,98,6)
end

function draw_game()
 -- draw hud
 rectfill(0,0,127,10,1)
 print("hp:"..p.hp.."/"..p.maxhp,2,2,8)
 print("lv:"..p.lvl,40,2,11)
 print("fl:"..floor,70,2,12)
 print("$"..p.gold,95,2,10)
 print("!"..p.pots,115,2,11)
 
 -- draw dungeon (offset for hud)
 local dy=14
 
 for i=0,15 do
  for j=0,15 do
   local x=i*8
   local y=j*8+dy
   
   local tile=dng[i][j]
   
   if tile==0 then
    -- wall
    rectfill(x,y,x+7,y+7,5)
   elseif tile==1 then
    -- floor
    rectfill(x,y,x+7,y+7,6)
   elseif tile==2 then
    -- exit
    rectfill(x,y,x+7,y+7,6)
    spr(48,x,y)
   end
  end
 end
 
 -- draw items
 for item in all(items) do
  local x=item.x*8
  local y=item.y*8+dy
  spr(item.s,x,y)
 end
 
 -- draw enemies
 for e in all(enemies) do
  local x=e.x*8
  local y=e.y*8+dy
  spr(e.s,x,y)
 end
 
 -- draw player
 local px=p.x*8
 local py=p.y*8+dy
 spr(1,px,py)
end

function draw_levelup()
 rectfill(20,50,108,78,1)
 rect(20,50,108,78,7)
 print("level up!",44,56,10)
 print("lv "..p.lvl,52,64,11)
end

function draw_gameover()
 cls(0)
 print("game over",44,50,8)
 print("floor: "..floor,46,65,7)
 print("press x to restart",22,85,7)
end

function draw_victory()
 cls(0)
 print("victory!",46,50,11)
 print("you escaped the",28,65,7)
 print("labyrinth!",42,73,7)
 print("press x to play again",18,95,6)
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00cccc00007770000ffff000088880000ddddd000000000000bbb00000aaa0000000000000000000000000000000000000000000000000000000000000000000
0cccccc00777777009999900888888800ddddd000000000000bbb000aaaaa0000000000000000000000000000000000000000000000000000000000000000000
0cccccc077c7cc7009fff900888888000ddddd00077700000bbb000aaaaa00000000000000000000000000000000000000000000000000000000000000000000
0cc77cc077ccccc09ffffff0888008800dd5dd00777770000bbbbb0aaaaa00000000000000000000000000000000000000000000000000000000000000000000
0cc77cc077ccccc09ffffff088800888055555007777770000bbb000aaa000000000000000000000000000000000000000000000000000000000000000000000
0cccccc07777777009fff900888888800555550077777700000b0000aaa000000000000000000000000000000000000000000000000000000000000000000000
00cccc000077770000999000088880000555550007777000000b00000a0000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100000c0500c0500c0500c05000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100001c0501c0501c0501c05000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100000c3500c3500c3500c35000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00010000157501575015750157500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00010000246502465024650246500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
