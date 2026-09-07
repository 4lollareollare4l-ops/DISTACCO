const p = runtimeScene.getObjects("Player")[0];
if (!p) return;
const G = globalThis;

if (!G.__distaccoTouch) {
  const s = G.__distaccoTouch = { moveX:0, moveY:0, run:false, dodge:false, look:0 };
  const old = document.getElementById("distacco-touch-ui"); if (old) old.remove();
  const root = document.createElement("div");
  root.id = "distacco-touch-ui";
  root.style.cssText = "position:fixed;inset:0;z-index:2147483000;pointer-events:none;user-select:none;-webkit-user-select:none;touch-action:none;font-family:system-ui,-apple-system,sans-serif";

  const hint = document.createElement("div");
  hint.textContent = "SINISTRA: movimento • DESTRA: trascina per la camera";
  hint.style.cssText = "position:absolute;left:50%;top:16px;transform:translateX(-50%);padding:8px 12px;border-radius:14px;background:rgba(0,0,0,.42);color:white;font-size:12px;white-space:nowrap;transition:opacity .6s";
  root.appendChild(hint); setTimeout(()=>hint.style.opacity="0",4500);

  const look = document.createElement("div");
  look.style.cssText = "position:absolute;right:0;top:0;width:55%;height:100%;pointer-events:auto;touch-action:none;z-index:1";
  let lookId=null,lastX=0;
  look.addEventListener("pointerdown",e=>{lookId=e.pointerId;lastX=e.clientX;try{look.setPointerCapture(e.pointerId)}catch(_){}e.preventDefault()},{passive:false});
  look.addEventListener("pointermove",e=>{if(e.pointerId!==lookId)return;s.look+=(e.clientX-lastX)*.09;lastX=e.clientX;e.preventDefault()},{passive:false});
  const endLook=e=>{if(e.pointerId===lookId)lookId=null}; look.addEventListener("pointerup",endLook); look.addEventListener("pointercancel",endLook); root.appendChild(look);

  const base=document.createElement("div");
  base.style.cssText="position:absolute;left:max(22px,4vw);bottom:max(28px,5vh);width:132px;height:132px;border-radius:50%;background:rgba(255,255,255,.08);border:2px solid rgba(255,255,255,.22);box-shadow:0 8px 28px rgba(0,0,0,.22);pointer-events:auto;touch-action:none;z-index:3";
  const knob=document.createElement("div");
  knob.style.cssText="position:absolute;width:58px;height:58px;left:37px;top:37px;border-radius:50%;background:rgba(255,255,255,.25);border:1px solid rgba(255,255,255,.38)"; base.appendChild(knob);
  let joyId=null; const R=48;
  const setJoy=e=>{const r=base.getBoundingClientRect();let dx=e.clientX-(r.left+r.width/2),dy=e.clientY-(r.top+r.height/2),l=Math.hypot(dx,dy);if(l>R){dx=dx/l*R;dy=dy/l*R}s.moveX=dx/R;s.moveY=dy/R;knob.style.transform=`translate(${dx}px,${dy}px)`};
  base.addEventListener("pointerdown",e=>{joyId=e.pointerId;try{base.setPointerCapture(e.pointerId)}catch(_){}setJoy(e);e.preventDefault()},{passive:false});
  base.addEventListener("pointermove",e=>{if(e.pointerId!==joyId)return;setJoy(e);e.preventDefault()},{passive:false});
  const endJoy=e=>{if(e.pointerId!==joyId)return;joyId=null;s.moveX=s.moveY=0;knob.style.transform="translate(0,0)"}; base.addEventListener("pointerup",endJoy); base.addEventListener("pointercancel",endJoy); root.appendChild(base);

  const button=(label,right,bottom,size,down,up)=>{const b=document.createElement("div");b.textContent=label;b.style.cssText=`position:absolute;right:${right}px;bottom:${bottom}px;width:${size}px;height:${size}px;border-radius:50%;display:flex;align-items:center;justify-content:center;background:rgba(255,255,255,.12);border:2px solid rgba(255,255,255,.28);color:white;font-size:12px;font-weight:700;pointer-events:auto;touch-action:none;z-index:5;box-shadow:0 8px 24px rgba(0,0,0,.25)`;b.addEventListener("pointerdown",e=>{try{b.setPointerCapture(e.pointerId)}catch(_){}b.style.transform="scale(.92)";down();e.preventDefault();e.stopPropagation()},{passive:false});const end=e=>{b.style.transform="scale(1)";if(up)up();e.preventDefault();e.stopPropagation()};b.addEventListener("pointerup",end,{passive:false});b.addEventListener("pointercancel",end,{passive:false});root.appendChild(b)};
  button("RUN",28,36,78,()=>s.run=true,()=>s.run=false);
  button("DODGE",120,86,68,()=>s.dodge=true,null);
  document.body.appendChild(root);
}

const s=G.__distaccoTouch;
const dt=Math.min(.05,gdjs.evtTools.runtimeScene.getElapsedTimeInSeconds(runtimeScene));
const k=n=>gdjs.evtTools.input.isKeyPressed(runtimeScene,n);
if(runtimeScene.__yaw===undefined)runtimeScene.__yaw=0;
if(runtimeScene.__dodgeCd===undefined)runtimeScene.__dodgeCd=0;
runtimeScene.__dodgeCd=Math.max(0,runtimeScene.__dodgeCd-dt);
runtimeScene.__yaw+=((k("e")?1:0)-(k("q")?1:0))*1.8+s.look; s.look=0;
const a=runtimeScene.__yaw*.035,fx=-Math.sin(a),fy=-Math.cos(a),rx=Math.cos(a),ry=-Math.sin(a);
let f=(k("w")||k("Up")?1:0)-(k("s")||k("Down")?1:0)-s.moveY;
let r=(k("d")||k("Right")?1:0)-(k("a")||k("Left")?1:0)+s.moveX;
let x=fx*f+rx*r,y=fy*f+ry*r,l=Math.hypot(x,y); if(l>1){x/=l;y/=l}
const sp=(k("LShift")||k("RShift")||s.run)?430:260,ox=p.getX(),oy=p.getY();
if(s.dodge&&runtimeScene.__dodgeCd<=0){if(l<.1){x=fx;y=fy}p.setX(p.getX()+x*220);p.setY(p.getY()+y*220);runtimeScene.__dodgeCd=.65}s.dodge=false;
p.setX(p.getX()+x*sp*dt);p.setY(p.getY()+y*sp*dt);
const hit=(u,v)=>u.getX()<v.getX()+v.getWidth()&&u.getX()+u.getWidth()>v.getX()&&u.getY()<v.getY()+v.getHeight()&&u.getY()+u.getHeight()>v.getY();
for(const o of runtimeScene.getObjects("Ruin"))if(hit(p,o)){p.setX(ox);p.setY(oy);break}
const cx=p.getX()+23,cy=p.getY()+23,d=690;
gdjs.evtTools.camera.setCameraX(runtimeScene,cx+Math.sin(a)*d,"",0);gdjs.evtTools.camera.setCameraY(runtimeScene,cy+Math.cos(a)*d,"",0);gdjs.scene3d.camera.setCameraZ(runtimeScene,350,"",0);gdjs.scene3d.camera.turnCameraTowardPosition(runtimeScene,cx,cy,82,"",0,false);