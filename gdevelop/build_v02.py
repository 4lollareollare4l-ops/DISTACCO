import json, uuid, random
from pathlib import Path

ROOT=Path(__file__).resolve().parent
BASE=ROOT/'game-touch.json'
OUT=ROOT/'game-v0.2.json'
JS=ROOT/'gameplay-v02.js'
random.seed(7)

def uid(): return str(uuid.uuid4())

def cube(name,tint,w,h,d,material='StandardWithoutMetalness',cast=True,receive=True):
    return {
      'assetStoreId':'','name':name,'persistentUuid':uid(),'type':'Scene3D::Cube3DObject','variables':[],'effects':[],'behaviors':[],
      'content':{'width':w,'height':h,'depth':d,'enableTextureTransparency':False,'facesOrientation':'Y','backFaceUpThroughWhichAxisRotation':'X','materialType':material,'tint':tint,'isCastingShadow':cast,'isReceivingShadow':receive,
      'frontFaceResourceName':'assets/white.png','frontFaceVisible':True,'frontFaceResourceRepeat':False,'backFaceResourceName':'assets/white.png','backFaceVisible':True,'backFaceResourceRepeat':False,
      'leftFaceResourceName':'assets/white.png','leftFaceVisible':True,'leftFaceResourceRepeat':False,'rightFaceResourceName':'assets/white.png','rightFaceVisible':True,'rightFaceResourceRepeat':False,
      'topFaceResourceName':'assets/white.png','topFaceVisible':True,'topFaceResourceRepeat':False,'bottomFaceResourceName':'assets/white.png','bottomFaceVisible':True,'bottomFaceResourceRepeat':False}}

def inst(name,x,y,z,w,h,d,angle=0,locked=False):
    return {'angle':angle,'rotationX':0,'rotationY':0,'customSize':True,'depth':d,'height':h,'keepRatio':True,'layer':'','locked':locked,'name':name,'persistentUuid':uid(),'width':w,'x':x,'y':y,'z':z,'zOrder':1,'numberProperties':[],'stringProperties':[],'initialVariables':[]}

p=json.loads(BASE.read_text())
p['firstLayout']='Bosco Occidentale'
p['properties']['version']='0.2.0'
p['properties']['name']='DISTACCO'
p['properties']['description']='Bosco Occidentale playable touch vertical slice.'
l=p['layouts'][0]
l['name']='Bosco Occidentale'; l['mangledName']='Bosco_32Occidentale'; l['title']='DISTACCO — Bosco Occidentale'; l['b']=39; l['r']=34; l['v']=41

objs=[
 cube('Ground','54;63;56',5200,6200,24,cast=False),cube('Road','45;48;46',680,5600,5,cast=False),cube('RoadMark','100;98;83',14,220,2,'Basic',False,False),
 cube('Player','47;53;55',54,42,78),cube('PlayerHead','194;171;151',42,42,42),cube('PlayerHair','38;29;26',44,44,17),cube('PlayerLeg','35;39;40',19,20,55),
 cube('TreeTrunk','70;58;48',42,42,310),cube('TreeCrown','39;58;44',180,180,165),cube('Bush','47;68;48',115,115,65),cube('Rock','69;73;69',100,80,55),
 cube('Crate','90;76;59',80,70,65),cube('Tent','77;83;72',250,190,120),cube('TowerPole','64;69;67',28,28,620),cube('TowerBeam','67;72;70',430,28,26),cube('TowerDish','98;104;101',150,26,150),
 cube('HouseWall','88;91;86',220,35,280),cube('HouseRoof','55;58;56',980,780,32),cube('Door','49;44;39',115,22,225),cube('Window','84;104;106',120,18,105,'Basic',False,False),
 cube('FlowerStem','40;69;48',7,7,34,cast=False),cube('FlowerHead','74;105;176',19,19,9,'Basic',False,False),cube('Anomaly','186;196;211',80,80,460,'Basic',False,False),
 cube('Saturnino','222;226;218',30,30,30,'Basic',False,False),cube('SaturninoRing','154;161;157',68,8,8,'Basic',False,False),
 cube('KenganTorso','57;63;62',50,38,78),cube('KenganHead','182;151;130',40,40,40),cube('KenganHair','40;31;27',42,42,16),cube('KenganLeg','39;43;43',18,19,57),
 cube('Barrier','96;91;75',220,40,70),cube('Sign','92;98;93',170,18,80)
]
ins=[]
ins += [inst('Ground',-2600,-3000,-26,5200,6200,24,locked=True),inst('Road',-340,-2700,-4,680,5600,5,locked=True)]
for y in range(-2350,2450,360): ins.append(inst('RoadMark',-7,y,-1,14,145,2,locked=True))
ins += [inst('Player',-27,2240,52,54,42,78),inst('PlayerHead',-21,2241,121,42,42,42),inst('PlayerHair',-22,2240,153,44,44,17),inst('PlayerLeg',-20,2243,0,19,20,55),inst('PlayerLeg',2,2243,0,19,20,55)]

# Forest walls, intentionally irregular so the road still feels traversable.
for y in range(-2450,2500,220):
    for side in (-1,1):
        for _ in range(2):
            x=side*random.randint(520,1750)+random.randint(-130,130); yy=y+random.randint(-90,90); s=random.uniform(.8,1.25)
            ins.append(inst('TreeTrunk',x-21*s,yy-21*s,0,42*s,42*s,310*s))
            ins.append(inst('TreeCrown',x-90*s,yy-90*s,260*s,180*s,180*s,165*s))
for _ in range(28):
    side=random.choice([-1,1]); x=side*random.randint(430,1850); y=random.randint(-2400,2350); w=random.randint(80,140)
    ins.append(inst('Bush',x-w/2,y-w/2,0,w,w,random.randint(45,80)))
for _ in range(18):
    side=random.choice([-1,1]); x=side*random.randint(430,1600); y=random.randint(-2350,2350); w=random.randint(55,120); h=random.randint(45,100); d=random.randint(30,70)
    ins.append(inst('Rock',x-w/2,y-h/2,0,w,h,d,random.randint(0,359)))

# Abandoned camp.
ins += [inst('Tent',-700,920,0,300,210,130,-12),inst('Crate',-420,1020,0,85,75,70,18),inst('Crate',-515,1080,0,75,70,60,-8),inst('Crate',-620,1120,0,60,60,55,27),inst('Sign',-345,1200,85,180,20,90,2)]
# Signal tower.
ins += [inst('TowerPole',480,290,0,28,28,620),inst('TowerPole',675,290,0,28,28,620),inst('TowerPole',480,475,0,28,28,620),inst('TowerPole',675,475,0,28,28,620),inst('TowerBeam',368,370,240,430,28,26),inst('TowerBeam',470,277,350,28,230,24),inst('TowerBeam',665,277,350,28,230,24),inst('TowerDish',535,345,510,150,26,150,-18)]
# Direttorato checkpoint.
ins += [inst('Barrier',-340,-145,0,220,40,70,-8),inst('Barrier',120,-60,0,220,40,70,10),inst('Sign',-260,-80,78,170,18,80)]
# Blue flowers lead to the anomaly.
for _ in range(42):
    y=-390-random.random()*470; x=random.choice([-1,1])*random.randint(250,560)+random.randint(-50,50)
    ins.append(inst('FlowerStem',x,y,0,7,7,34)); ins.append(inst('FlowerHead',x-6,y-6,31,19,19,9))
ins.append(inst('Anomaly',-40,-980,0,80,80,460))

# Casa 14 exterior and Kengan at the entrance.
ins += [
 inst('HouseWall',390,-1980,0,230,35,280),inst('HouseWall',950,-1980,0,230,35,280),inst('HouseWall',620,-1980,0,230,35,280),inst('Door',750,-1992,0,115,22,225),
 inst('Window',475,-1994,100,120,18,105),inst('Window',1005,-1994,100,120,18,105),inst('HouseWall',390,-2620,0,790,35,280),inst('HouseWall',370,-2600,0,35,640,280),inst('HouseWall',1175,-2600,0,35,640,280),inst('HouseRoof',350,-2630,285,900,700,32),inst('Sign',735,-1965,240,170,18,80),
 inst('KenganTorso',650,-1880,45,50,38,78),inst('KenganHead',655,-1878,121,40,40,40),inst('KenganHair',654,-1879,152,42,42,16),inst('KenganLeg',656,-1878,0,18,19,57),inst('KenganLeg',680,-1878,0,18,19,57)
]
# Saturnino starts beside the player and is then moved every frame by JS.
ins += [inst('Saturnino',85,2170,145,30,30,30),inst('SaturninoRing',66,2181,155,68,8,8),inst('SaturninoRing',96,2151,155,8,68,8)]
for x,y,a in [(-560,1650,13),(420,1500,-22),(-470,600,8),(500,-700,-12),(-520,-1300,21)]:
    ins.append(inst('Crate',x,y,0,70,65,58,a))

l['objects']=objs; l['instances']=ins; l['objectsGroups']=[]; l['variables']=[]
l['events']=[{'type':'BuiltinCommonInstructions::JsCode','inlineCode':JS.read_text().splitlines(),'parameterObjects':'','useStrict':True,'eventsSheetExpanded':False}]
l['layers'][0]['ambientLightColorB']=78; l['layers'][0]['ambientLightColorG']=83; l['layers'][0]['ambientLightColorR']=76
l['layers'][0]['camera3DFarPlaneDistance']=9000; l['layers'][0]['camera3DFieldOfView']=57
l['layers'][0]['effects']=[
 {'effectType':'Scene3D::HemisphereLight','name':'Wet sky','doubleParameters':{'elevation':42,'intensity':0.4,'rotation':315},'stringParameters':{'groundColor':'24;30;27','skyColor':'111;124;119','top':'Z+'},'booleanParameters':{}},
 {'effectType':'Scene3D::DirectionalLight','name':'Overcast light','doubleParameters':{'distanceFromCamera':2400,'elevation':32,'frustumSize':5200,'intensity':0.45,'minimumShadowBias':0,'rotation':326},'stringParameters':{'color':'195;204;201','shadowQuality':'medium','top':'Z+'},'booleanParameters':{'isCastingShadow':True}},
 {'effectType':'Scene3D::ExponentialFog','name':'Cold rain fog','doubleParameters':{'density':0.00048},'stringParameters':{'color':'69;80;76'},'booleanParameters':{}}
]
OUT.write_text(json.dumps(p,separators=(',',':'),ensure_ascii=False))
print(f'Built {OUT.name}: {len(objs)} objects, {len(ins)} instances')
