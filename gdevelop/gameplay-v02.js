const p = runtimeScene.getObjects("Player")[0];
if (!p) return;
const G = globalThis;

if (!G.__distaccoGame) {
  const s = G.__distaccoGame = {
    moveX:0, moveY:0, run:false, dodge:false, interact:false,
    lookX:0, lookY:0, stage:0, messageUntil:0
  };
  const old=document.getElementById("distacco-ui"); if(old) old.remove();
  const oldStyle=document.getElementById("distacco-style"); if(oldStyle) oldStyle.remove();
  const style=document.createElement("style");
  style.id="distacco-style";
  style.textContent=`
    @keyframes d-rain{from{transform:translate3d(0,-8%,0)}to{transform:translate3d(-3%,8%,0)}}
    #distacco-ui *{box-sizing:border-box}
    .d-glass{background:linear-gradient(180deg,rgba(9,12,11,.58),rgba(9,12,11,.30));backdrop-filter:blur(5px);-webkit-backdrop-filter:blur(5px)}
  `;
  document.head.appendChild(style);
  const root=document.createElement("div");
  root.id="distacco-ui";
  root.style.cssText="position:fixed;inset:0;z-index:2147483000;pointer-events:none;user-select:none;-webkit-user-select:none;touch-action:none;font-family:system-ui,-apple-system,sans-serif;color:white;overflow:hidden";

  const rain=document.createElement("div");
  rain.style.cssText="position:absolute;inset:-15%;opacity:.18;background:repeating-linear-gradient(104deg,transparent 0 15px,rgba(220,235,230,.34) 16px 17px,transparent 18px 35px);animation:d-rain .55s linear infinite;pointer-events:none";
  root.appendChild(rain);
  const vig=document.createElement("div");
  vig.style.cssText="position:absolute;inset:0;box-shadow:inset 0 0 150px 55px rgba(0,0,0,.48);pointer-events:none";
  root.appendChild(vig);

  const title=document.createElement("div");
  title.innerHTML="<div style='font-size:12px;letter-spacing:.38em;opacity:.7'>REGIONE 01</div><div style='font-size:30px;font-weight:800;letter-spacing:.08em;margin-top:4px'>BOSCO OCCIDENTALE</div>";
  title.style.cssText="position:absolute;left:50%;top:17%;transform:translateX(-50%);text-align:center;text-shadow:0 2px 18px #000;opacity:0;transition:opacity 1s";
  root.appendChild(title);
  setTimeout(()=>title.style.opacity="1",350);
  setTimeout(()=>title.style.opacity="0",3300);

  const objective=document.createElement("div");
  objective.className="d-glass";
  objective.style.cssText="position:absolute;left:18px;top:18px;max-width:min(450px,60vw);padding:12px 15px;border-left:3px solid rgba(189,207,200,.78);border-radius:3px 10px 10px 3px;box-shadow:0 8px 28px rgba(0,0,0,.18)";
  objective.innerHTML="<div style='font-size:10px;letter-spacing:.24em;opacity:.62'>OBIETTIVO</div><div id='d-objective-text' style='font-size:14px;font-weight:650;margin-top:4px'>Raggiungi il campo abbandonato.</div>";
  root.appendChild(objective);

  const sub=document.createElement("div");
  sub.id="d-sub";
  sub.style.cssText="position:absolute;left:50%;bottom:150px;transform:translateX(-50%);width:min(760px,82vw);text-align:center;font-size:15px;font-weight:600;text-shadow:0 2px 8px #000,0 0 18px #000;opacity:0;transition:opacity .25s";
  root.appendChild(sub);

  const look=document.createElement("div");
  look.style.cssText="position:absolute;right:0;top:0;width:58%;height:100%;pointer-events:auto;touch-action:none;z-index:1";
  let lookId=null,lastX=0,lastY=0;
  look.addEventListener("pointerdown",e=>{lookId=e.pointerId;lastX=e.clientX;lastY=e.clientY;try{look.setPointerCapture(e.pointerId)}catch(_){}e.preventDefault()},{passive:false});
  look.addEventListener("pointermove",e=>{if(e.pointerId!==lookId)return;s.lookX+=(e.clientX-lastX)*.085;s.lookY+=(e.clientY-lastY)*.025;lastX=e.clientX;lastY=e.clientY;e.preventDefault()},{passive:false});
  const endLook=e=>{if(e.pointerId===lookId)lookId=null};look.addEventListener("pointerup",endLook);look.addEventListener("pointercancel",endLook);
  root.appendChild(look);

  const base=document.createElement("div");
  base.style.cssText="position:absolute;left:max(22px,4vw);bottom:max(30px,5vh);width:134px;height:134px;border-radius:50%;background:rgba(255,255,255,.06);border:2px solid rgba(255,255,255,.18);box-shadow:0 8px 28px rgba(0,0,0,.24);pointer-events:auto;touch-action:none;z-index:6";
  const knob=document.createElement("div");
  knob.style.cssText="position:absolute;width:58px;height:58px;left:38px;top:38px;border-radius:50%;background:rgba(210,225,219,.24);border:1px solid rgba(255,255,255,.30);box-shadow:inset 0 0 16px rgba(255,255,255,.08)";
  base.appendChild(knob); let joyId=null; const R=49;
  const setJoy=e=>{const r=base.getBoundingClientRect();let dx=e.clientX-(r.left+r.width/2),dy=e.clientY-(r.top+r.height/2),l=Math.hypot(dx,dy);if(l>R){dx=dx/l*R;dy=dy/l*R}s.moveX=dx/R;s.moveY=dy/R;knob.style.transform=`translate(${dx}px,${dy}px)`};
  base.addEventListener("pointerdown",e=>{joyId=e.pointerId;try{base.setPointerCapture(e.pointerId)}catch(_){}setJoy(e);e.preventDefault()},{passive:false});
  base.addEventListener("pointermove",e=>{if(e.pointerId!==joyId)return;setJoy(e);e.preventDefault()},{passive:false});
  const endJoy=e=>{if(e.pointerId!==joyId)return;joyId=null;s.moveX=s.moveY=0;knob.style.transform="translate(0,0)"};
  base.addEventListener("pointerup",endJoy);base.addEventListener("pointercancel",endJoy);root.appendChild(base);

  const mkButton=(id,label,right,bottom,size,down,up)=>{
    const b=document.createElement("div");b.id=id;b.textContent=label;
    b.style.cssText=`position:absolute;right:${right}px;bottom:${bottom}px;width:${size}px;height:${size}px;border-radius:50%;display:flex;align-items:center;justify-content:center;background:rgba(230,238,235,.11);border:2px solid rgba(255,255,255,.25);color:white;font-size:11px;font-weight:800;letter-spacing:.04em;pointer-events:auto;touch-action:none;z-index:8;box-shadow:0 8px 25px rgba(0,0,0,.25);text-shadow:0 1px 6px #000`;
    b.addEventListener("pointerdown",e=>{try{b.setPointerCapture(e.pointerId)}catch(_){}b.style.transform="scale(.92)";down();e.preventDefault();e.stopPropagation()},{passive:false});
    const end=e=>{b.style.transform="scale(1)";if(up)up();e.preventDefault();e.stopPropagation()};
    b.addEventListener("pointerup",end,{passive:false});b.addEventListener("pointercancel",end,{passive:false});root.appendChild(b);return b
  };
  mkButton("d-run","RUN",26,35,76,()=>s.run=true,()=>s.run=false);
  mkButton("d-dodge","DODGE",115,88,66,()=>s.dodge=true,null);
  const ib=mkButton("d-interact","E",31,132,58,()=>s.interact=true,null); ib.style.display="none";

  document.body.appendChild(root);
  s.setObjective=t=>{const el=document.getElementById("d-objective-text");if(el)el.textContent=t};
  s.say=(who,text,ms=3900)=>{const el=document.getElementById("d-sub");if(!el)return;el.innerHTML=`<span style="opacity:.72">${who}</span> ${text}`;el.style.opacity="1";s.messageUntil=performance.now()+ms};
  s.interactBtn=(show,label="E")=>{const b=document.getElementById("d-interact");if(!b)return;b.style.display=show?"flex":"none";b.textContent=label};
}

const s=G.__distaccoGame;
const dt=Math.min(.05,gdjs.evtTools.runtimeScene.getElapsedTimeInSeconds(runtimeScene));
const k=n=>gdjs.evtTools.input.isKeyPressed(runtimeScene,n);
if(runtimeScene.__yaw===undefined){runtimeScene.__yaw=0;runtimeScene.__pitch=0;runtimeScene.__dodgeCd=0;runtimeScene.__clock=0}
runtimeScene.__clock+=dt;runtimeScene.__dodgeCd=Math.max(0,runtimeScene.__dodgeCd-dt);
runtimeScene.__yaw+=((k("e")?1:0)-(k("q")?1:0))*1.8+s.lookX;s.lookX=0;
runtimeScene.__pitch=Math.max(-60,Math.min(65,runtimeScene.__pitch+s.lookY));s.lookY=0;
const a=runtimeScene.__yaw*.035,fx=-Math.sin(a),fy=-Math.cos(a),rx=Math.cos(a),ry=-Math.sin(a);
let f=(k("w")||k("Up")?1:0)-(k("s")||k("Down")?1:0)-s.moveY;
let r=(k("d")||k("Right")?1:0)-(k("a")||k("Left")?1:0)+s.moveX;
let mx=fx*f+rx*r,my=fy*f+ry*r,len=Math.hypot(mx,my);if(len>1){mx/=len;my/=len;len=1}
const ox=p.getX(),oy=p.getY(),speed=(k("LShift")||k("RShift")||s.run)?395:245;
if(s.dodge&&runtimeScene.__dodgeCd<=0){if(len<.1){mx=fx;my=fy}p.setX(p.getX()+mx*190);p.setY(p.getY()+my*190);runtimeScene.__dodgeCd=.7}s.dodge=false;
p.setX(p.getX()+mx*speed*dt);p.setY(p.getY()+my*speed*dt);

const hit=(u,v)=>u.getX()<v.getX()+v.getWidth()&&u.getX()+u.getWidth()>v.getX()&&u.getY()<v.getY()+v.getHeight()&&u.getY()+u.getHeight()>v.getY();
for(const n of ["TreeTrunk","HouseWall","Barrier","TowerPole"]){for(const o of runtimeScene.getObjects(n))if(hit(p,o)){p.setX(ox);p.setY(oy)}}

const cx=p.getX()+p.getWidth()/2,cy=p.getY()+p.getHeight()/2;
const heads=runtimeScene.getObjects("PlayerHead"), hairs=runtimeScene.getObjects("PlayerHair"), legs=runtimeScene.getObjects("PlayerLeg");
if(heads[0]){heads[0].setX(cx-heads[0].getWidth()/2);heads[0].setY(cy-heads[0].getHeight()/2);heads[0].setZ(122)}
if(hairs[0]){hairs[0].setX(cx-hairs[0].getWidth()/2);hairs[0].setY(cy-hairs[0].getHeight()/2);hairs[0].setZ(153)}
if(legs[0]){legs[0].setX(cx-16);legs[0].setY(cy-10);legs[0].setZ(0)}
if(legs[1]){legs[1].setX(cx+1);legs[1].setY(cy-10);legs[1].setZ(0)}
p.setZ(52);

const sat=runtimeScene.getObjects("Saturnino")[0],rings=runtimeScene.getObjects("SaturninoRing");
const sx=cx+rx*100-fx*35,sy=cy+ry*100-fy*35,sz=156+Math.sin(runtimeScene.__clock*2.1)*9;
if(sat){sat.setX(sx-15);sat.setY(sy-15);sat.setZ(sz)}
if(rings[0]){rings[0].setX(sx-34);rings[0].setY(sy-4);rings[0].setZ(sz+10)}
if(rings[1]){rings[1].setX(sx-4);rings[1].setY(sy-34);rings[1].setZ(sz+10)}

const camD=610,camZ=285+runtimeScene.__pitch*1.8;
gdjs.evtTools.camera.setCameraX(runtimeScene,cx+Math.sin(a)*camD,"",0);
gdjs.evtTools.camera.setCameraY(runtimeScene,cy+Math.cos(a)*camD,"",0);
gdjs.scene3d.camera.setCameraZ(runtimeScene,camZ,"",0);
gdjs.scene3d.camera.turnCameraTowardPosition(runtimeScene,cx,cy,92+runtimeScene.__pitch*.35,"",0,false);

const dist=(x,y)=>Math.hypot(cx-x,cy-y);
let showInteract=false,ilabel="E";
if(s.stage===0 && dist(-520,1050)<260){s.stage=1;s.setObjective("Controlla la torre di segnale.");s.say("SATURNINO","Qualcuno è passato di qui. Non molto tempo fa.")}
if(s.stage===1 && dist(580,390)<215){showInteract=true;ilabel="ESAMINA";if(s.interact||k("f")){s.stage=2;s.setObjective("Segui i fiori blu oltre il checkpoint.");s.say("TU","Il cavo è stato tagliato. Da poco.");}}
if(s.stage===2 && dist(0,-610)<350){s.stage=3;s.setObjective("Avvicinati all'anomalia.");s.say("SATURNINO","Questi fiori non appartengono a questo posto.")}
const an=runtimeScene.getObjects("Anomaly")[0];
if(an){const pulse=1+Math.sin(runtimeScene.__clock*3.4)*.07;an.setWidth(80*pulse);an.setHeight(80*pulse)}
if(s.stage===3 && dist(0,-960)<190){showInteract=true;ilabel="TOCCA";if(s.interact||k("f")){s.stage=4;s.setObjective("Raggiungi Casa 14.");s.say("","Per un secondo il bosco diventa completamente muto.",4300)}}
if(s.stage===4 && dist(800,-1880)<260){showInteract=true;ilabel="ENTRA";if(s.interact||k("f")){s.stage=5;s.setObjective("Casa 14 — ingresso raggiunto.");s.say("KENGAN","Finalmente. Pensavo ti fossi persa.",4500)}}
if(s.stage===5 && dist(800,-1880)<260){showInteract=true;ilabel="PARLA";if(s.interact||k("f")){s.say("KENGAN","Dentro c'è qualcosa che devi vedere. E no, non è una bella sorpresa.",5000)}}
s.interact=false;s.interactBtn(showInteract,ilabel);
const sub=document.getElementById("d-sub");if(sub&&performance.now()>s.messageUntil)sub.style.opacity="0";
