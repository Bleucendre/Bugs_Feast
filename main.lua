-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution / allows to display traces in the console during the execution
io.stdout:setvbuf('no')

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées / Prevents Love from filtering the edges of images when they are resized
love.graphics.setDefaultFilter("nearest")

-- Cette ligne permet de déboguer pas à pas dans ZeroBraneStudio / This line allows to debug step by step in ZeroBraneStudio
if arg[#arg] == "-debug" then require("mobdebug").start() end

-- Initialisation de la randomisation / Initiating the randomisation
math.randomseed(os.time())
math.random(); math.random(); math.random(); math.random();

-- Variables
local mode = "Welcome"   -- or "GamePlaying", "GameOver", "TimeUp"
local listInsect = {}
local timerCreaInsect = 15
local timerCreaInsect2 = 40
local score = 0
local timerGame = 180
local fading = 0
local scoreUp = 0
local scoreFading = 1
local decreaseBckgMus = 0
local coordVar = 0
local coordBool = false
local diceDouble = math.random(1, 2)
local diceTriple = math.random(1, 3)
local gameoverOut = false

local imageSupport = {}   -- Liste des images des plateformes / List of platform images

-- Pour l'animation de la mouche / 
local frameFly = 1
local imgFly = {}

-- Pour l'animation de la libelule / fly animation
local frameDragonFly = 1
local imgDragonFly = {}

local support = {}  -- Propriétés des plateformes / Platform properties
support.scale = 0.8
-- 1ére ligne
support.x_1_1 = 130
support.x_1_2 = 512
support.x_1_3 = 890
support.y_1 = 100
-- 2éme ligne
support.x_2_1 = 320
support.x_2_2 = 700
support.y_2 = 246
-- 3éme ligne
support.x_3_1 = 130
support.x_3_2 = 512
support.x_3_3 = 890
support.y_3 = 384
-- 4éme ligne
support.x_4_1 = 320
support.x_4_2 = 700
support.y_4 = 535
-- 5éme ligne
support.x_5_1 = 130
support.x_5_2 = 512
support.x_5_3 = 890
support.y_5 = 668

-- Le HERO
local spider = {}
spider.life = 3
spider.lifeMax = false
spider.x = support.x_5_2
spider.y = support.y_5
spider.speedMove = 180
spider.angle = 212
spider.rotate = false
spider.speedRotate = 3
spider.move = false
spider.jump = false
spider.timerJump = 0
spider.swallow = false
spider.swallowFly = false
spider.swallowCater = false
spider.swallowDragon = false
spider.timerSwallow = 0
spider.speedJump = 300
spider.fall = false
spider.scale = 3
spider.appear = true
spider.display = false
spider.timerAppear = 0
spider.frame = 1
spider.imgMov = {}

-- La chenille / The caterpillar
local caterpillar = {}
caterpillar.x = support.x_3_2 - 115
caterpillar.y = support.y_3
caterpillar.speed = 20
caterpillar.timerAppear = 30
caterpillar.appear = false
caterpillar.scale = 1
caterpillar.frame = 1
caterpillar.img = {}

-- Le cameleon
local cameleon = {}
cameleon.x = 1180
cameleon.y = support.y_3
cameleon.speed = 30
cameleon.angle = 110
cameleon.speedRotate = 2
cameleon.timerAppear = 10
cameleon.timerChangeDir = 1000
cameleon.swalCater = false
cameleon.timerSwalCater = 0
cameleon.swalSpider = false
cameleon.timerSwalSpider = 0
cameleon.animSwall = false
cameleon.timerAnimSwall = 0
cameleon.frame = 1
cameleon.img = {}
cameleon.frameSwall = 1
cameleon.imgSwall= {}

-- Le sprite fantôme / The "ghost sprite"
local ghost = {}
ghost.x = 1180
ghost.y = support.y_3
ghost.center_x = -20
ghost.center_y = 50

-- La gestion du GameOver / Managing the GameOver
local gameOver = {}
gameOver.x = 335
gameOver.y = 350
gameOver.state = false
gameOver.fading = 0
gameOver.scale = 5

-- Les FONCTIONS / FUNCTIONS
function math.angle(x1, y1, x2,y2)    -- (Pour l'angle des ennemis)
  return math.atan2(y2-y1, x2-x1)
end

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
        x2 < x1+w1 and
        y1 < y2+h2 and
        y2 < y1+h1
end

function 
ResetAfterFail()
  spider.life = spider.life - 1
  spider.x = support.x_5_2
  spider.y = support.y_5
  spider.angle = 212
  spider.scale = 3
  spider.appear = true
  spider.display = false
  spider.speedMove = 180
  spider.rotate = false
  spider.speedRotate = 3
  spider.move = false
  spider.jump = false
  spider.timerJump = 0
  spider.swallow = false
  spider.swallowFly = false
  spider.swallowCater = false
  spider.timerSwallow = 0
  spider.speedJump = 300
  spider.fall = false
  cameleon.timerSwalSpider = 0
end

function AddInsect(pType)
  local Insect = {}
  local dirHazard = math.random(1, 2)
  local coordHazard_1 = math.random(60, 970) -- Abscisses
  local coordHazard_2 = math.random(75, 660)  -- Ordonnées
  local coordHazard_3 = math.random(1150, 1300)  -- Ordonnées
  local coordHazard_4 = math.random(200, 500) -- Abscisses
  diceDouble = math.random(1, 2)
  diceTriple = math.random(1, 3)
  Insect.type = pType
  Insect.coordVariation = diceDouble
  Insect.speedVariation = diceTriple
  if pType == "DragonFly" then
    Insect.speed2 = 130
    Insect.scale = 0.9
    if dirHazard == 1 then
      Insect.x = -coordHazard_4
      Insect.y = coordHazard_2
      Insect.angle2 = 106.83
      Insect.speed2 = Insect.speed2
    else
      Insect.x = coordHazard_3
      Insect.y = coordHazard_2
      Insect.angle2 = 109.95
      Insect.speed2 = -Insect.speed2
    end
  end
  if Insect.type == "Fly" then
    Insect.scale = 0.5
    if Insect.speedVariation == 1 then
      Insect.speed = 75
    elseif Insect.speedVariation == 2 then
      Insect.speed = 90
    elseif Insect.speedVariation == 3 then
      Insect.speed = 105
    end
    if dirHazard == 1 then
      Insect.x = coordHazard_1
      Insect.y = - coordHazard_2
      Insect.speed = Insect.speed
      Insect.angle = -212
    else
      Insect.x = coordHazard_1
      Insect.y = coordHazard_3
      Insect.speed = Insect.speed * (-1)
      Insect.angle = 212
    end
  end
  table.insert(listInsect, Insect)
end

function SoundJump(pBool)
  if pBool == true then
    sndJump:setPitch(0.9)
    sndJump:setVolume(0.8)
    sndJump:play()
  else
    sndJump:stop()
  end
end

function SoundFall(pBool)
  if pBool == true then
    sndFall:setPitch(1.1)
    sndFall:setVolume(0.2)
    sndFall:play()
  else
    sndFall:stop()
  end
end

function SoundSwallow(pBool)
  if pBool == true then
    sndSwallow:setPitch(1.1)
    sndSwallow:setVolume(0.1)
    sndSwallow:play()
  else
    sndSwallow:stop()
  end
end

function SoundSwallowHard(pBool)
  if pBool == true then
    sndHeavySwallow:setPitch(0.9)
    sndHeavySwallow:setVolume(0.7)
    sndHeavySwallow:play()
  else
    sndHeavySwallow:stop()
  end
end

function SoundCamSwalCrowler(pBool)
  if pBool == true then
    sndCamSwalCrowler:setPitch(0.9)
    sndCamSwalCrowler:setVolume(0.8)
    sndCamSwalCrowler:play()
  else
    sndCamSwalCrowler:stop()
  end
end

function SoundCamSwalSpider(pBool)
  if pBool == true then
    sndCamSwalSpider:setPitch(0.9)
    sndCamSwalSpider:setVolume(0.9)
    sndCamSwalSpider:play()
  else
    sndCamSwalSpider:stop()
  end
end

function AmbJungStrange(pBool)
  if pBool == true then
    AmbianceJungleStrange:setVolume(0.1)
    AmbianceJungleStrange:setLooping(true)
    AmbianceJungleStrange:play()
  else
    AmbianceJungleStrange:stop()
  end
end

function Reset()
  spider.life = 3
  spider.x = support.x_5_2
  spider.y = support.y_5
  spider.angle = 212
  spider.jump = false
  spider.fall = false
  spider.scale = 3
  spider.appear = true
  spider.display = false
  -----------------
  listInsect = {}
  stage = 1
  fading = 0
  listInsect = {}
  timerCreaInsect = 15
  score = 0
  timerGame = 180
  gameOver.fading = 0
  gameoverOut = false
  decreaseBckgMus = 0
  AmbianceJungleStrange:stop()
  -----------------
  CaterCoord()
  caterpillar.timerAppear = 30
  caterpillar.appear = false
  caterpillar.scale = 1
  caterpillar.frame = 1
  -----------------
  cameleon.x = 1180
  cameleon.y = support.y_3
  cameleon.speed = 30
  cameleon.angle = 110
  cameleon.timerAppear = 10
  cameleon.timerChangeDir = 1000
  cameleon.swalCater = false
  cameleon.timerSwalCater = 0
  cameleon.swalSpider = false
  cameleon.timerSwalSpider = 0
  ------------------
  ghost.x = 1180
  ghost.y = support.y_3
  ghost.center_x = -20
  ghost.center_y = 50
end

function CaterCoord()
  local hazard = math.random(1, 7)
  if hazard == 1 then
    caterpillar.x = support.x_2_2 - 115
    caterpillar.y = support.y_2
  end
  if hazard == 2 then
    caterpillar.x = support.x_3_3 - 115
    caterpillar.y = support.y_3
  end
  if hazard == 3 then
    caterpillar.x = support.x_4_2 - 115
    caterpillar.y = support.y_4
  end
  if hazard == 4 then
    caterpillar.x = support.x_1_1 - 115
    caterpillar.y = support.y_1
  end
  if hazard == 5 then
    caterpillar.x = support.x_3_2 - 115
    caterpillar.y = support.y_3
  end
  if hazard == 6 then
    caterpillar.x = support.x_4_1 - 115
    caterpillar.y = support.y_4
  end
  if hazard == 7 then
    caterpillar.x = support.x_5_1 - 115
    caterpillar.y = support.y_5
  end
end
CaterCoord()

function CameleoMove(dt)
  local cameleon_vx = cameleon.speed * math.cos(cameleon.angle)
  local cameleon_vy = cameleon.speed * math.sin(cameleon.angle)
  cameleon.x = cameleon.x + cameleon_vx*dt
  cameleon.y = cameleon.y + cameleon_vy*dt
  ghost.x = ghost.x + cameleon_vx*dt
  ghost.y = ghost.y + cameleon_vy*dt
  if cameleon.timerChangeDir <= 940 and cameleon.timerChangeDir > 937 then
      cameleon.angle = cameleon.angle + (1*dt) -- Change 1
    elseif cameleon.timerChangeDir <= 910 and cameleon.timerChangeDir > 904 then
      cameleon.angle = cameleon.angle - (1*dt) -- Change 2
    elseif cameleon.timerChangeDir <= 870 and cameleon.timerChangeDir > 864 then
      cameleon.angle = cameleon.angle + (1*dt) -- Change 3
    elseif cameleon.timerChangeDir <= 835 and cameleon.timerChangeDir > 829 then
      cameleon.angle = cameleon.angle - (1*dt) -- Change 4
    elseif cameleon.timerChangeDir <= 795 and cameleon.timerChangeDir > 787 then 
      cameleon.angle = cameleon.angle - (1.2*dt) -- Change 5
    elseif cameleon.timerChangeDir <= 755 and cameleon.timerChangeDir > 748 then
      cameleon.angle = cameleon.angle - (1*dt) -- Change 6
    elseif cameleon.timerChangeDir <= 710 and cameleon.timerChangeDir > 703 then
      cameleon.angle = cameleon.angle + (1.1*dt) -- Change 7
    elseif cameleon.timerChangeDir <= 675 and cameleon.timerChangeDir > 668 then
      cameleon.angle = cameleon.angle - (1*dt) -- Change 8
    elseif cameleon.timerChangeDir <= 625 and cameleon.timerChangeDir > 622 then
      cameleon.angle = cameleon.angle + (1*dt) -- Change 9
    end
end

-- L O A D --------------------------------------------------------------------------------
function love.load()
  
  love.window.setMode(1024,768)
  largeur_ecran = love.graphics.getWidth()
  hauteur_ecran = love.graphics.getHeight()

  -- IMAGES
  imgFeuilleVerte = love.graphics.newImage("images/FeuilleVerte.png")
  imgFeuilleVerte2 = love.graphics.newImage("images/FeuilleVerte2.png")
  imgSol = love.graphics.newImage("images/Sol.jpg")
  imgMoucheSilhouette = love.graphics.newImage("images/MoucheSilhouette.png")
  imgPhotoSpider = love.graphics.newImage("images/SPIDER_PHOTO.png")
  imgBckgPhotoWelcom = love.graphics.newImage("images/AccueilFOND.jpg")
  imgScreenWelcom = love.graphics.newImage("images/EcranAccueil.png")
  imgGhostSprite = love.graphics.newImage("images/Sprite_Fantome.png")
  imgCadran = love.graphics.newImage("images/Cadran2.png")
  -- Le HERO
  imgSpiderCrouched = love.graphics.newImage("images/SpiderCrouched.png")
  imgSpiderJump = love.graphics.newImage("images/SpiderJump2.png")
  -- L'animation générale du HERO / General animation of the HERO
  spider.imgMov[1] = love.graphics.newImage("images/Spider.png")
  spider.imgMov[2] = love.graphics.newImage("images/Spider2.png")
  spider.imgMov[3] = love.graphics.newImage("images/Spider3.png")
  spider.imgMov[4] = love.graphics.newImage("images/Spider4.png")
  spider.imgMov[5] = love.graphics.newImage("images/Spider5.png")
  -- La mouche / The fly
  imgFly[1] = love.graphics.newImage("images/Fly.png")
  imgFly[2] = love.graphics.newImage("images/Fly2.png")
  imgFly[3] = love.graphics.newImage("images/Fly3.png")
  imgFly[4] = love.graphics.newImage("images/Fly4.png")
  imgFly[5] = love.graphics.newImage("images/Fly5.png")
  imgFly[6] = love.graphics.newImage("images/Fly6.png")
  imgFly[7] = love.graphics.newImage("images/Fly7.png")
  imgFly[8] = love.graphics.newImage("images/Fly8.png")
  imgFly[9] = love.graphics.newImage("images/Fly9.png")
  imgFly[10] = love.graphics.newImage("images/Fly10.png")
  -- La chenille / The crowler
  caterpillar.img[1] = love.graphics.newImage("images/Chenille.png")
  caterpillar.img[2] = love.graphics.newImage("images/Chenille2.png")
  caterpillar.img[3] = love.graphics.newImage("images/Chenille3.png")
  caterpillar.img[4] = love.graphics.newImage("images/Chenille4.png")
  caterpillar.img[5] = love.graphics.newImage("images/Chenille5.png")
  caterpillar.img[6] = love.graphics.newImage("images/Chenille6.png")
  caterpillar.img[7] = love.graphics.newImage("images/Chenille7.png")
  caterpillar.img[8] = love.graphics.newImage("images/Chenille8.png")
  caterpillar.img[9] = love.graphics.newImage("images/Chenille9.png")
  caterpillar.img[10] = love.graphics.newImage("images/Chenille10.png")
  caterpillar.img[11] = love.graphics.newImage("images/Chenille11.png")
  caterpillar.img[12] = love.graphics.newImage("images/Chenille12.png")
  caterpillar.img[13] = love.graphics.newImage("images/Chenille13.png")
  caterpillar.img[14] = love.graphics.newImage("images/Chenille14.png")
  caterpillar.img[15] = love.graphics.newImage("images/Chenille15.png")
  caterpillar.img[16] = love.graphics.newImage("images/Chenille16.png")
  caterpillar.img[17] = love.graphics.newImage("images/Chenille17.png")
  caterpillar.img[18] = love.graphics.newImage("images/Chenille18.png")
  caterpillar.img[19] = love.graphics.newImage("images/Chenille19.png")
  caterpillar.img[20] = love.graphics.newImage("images/Chenille20.png")
  caterpillar.img[21] = love.graphics.newImage("images/Chenille21.png")
  caterpillar.img[22] = love.graphics.newImage("images/Chenille22.png")
  -- Le cameleon
  cameleon.img[1] = love.graphics.newImage("images/Cameleon.png")
  cameleon.img[2] = love.graphics.newImage("images/Cameleon2.png")
  cameleon.img[3] = love.graphics.newImage("images/Cameleon3.png")
  cameleon.img[4] = love.graphics.newImage("images/Cameleon4.png")
  cameleon.img[5] = love.graphics.newImage("images/Cameleon5.png")
  cameleon.img[6] = love.graphics.newImage("images/Cameleon6.png")
  cameleon.img[7] = love.graphics.newImage("images/Cameleon7.png")
  cameleon.img[8] = love.graphics.newImage("images/Cameleon8.png")
  cameleon.img[9] = love.graphics.newImage("images/Cameleon9.png")
  cameleon.img[10] = love.graphics.newImage("images/Cameleon10.png")
  cameleon.img[11] = love.graphics.newImage("images/Cameleon11.png")
  cameleon.img[12] = love.graphics.newImage("images/Cameleon12.png")
  cameleon.imgSwall[1] = love.graphics.newImage("images/CameleonAvale.png")
  cameleon.imgSwall[2] = love.graphics.newImage("images/CameleonAvale2.png")
  cameleon.imgSwall[3] = love.graphics.newImage("images/CameleonAvale3.png")
  cameleon.imgSwall[4] = love.graphics.newImage("images/CameleonAvale4.png")
  cameleon.imgSwall[5] = love.graphics.newImage("images/CameleonAvale5.png")
  cameleon.imgSwall[6] = love.graphics.newImage("images/CameleonAvale6.png")
  cameleon.imgSwall[7] = love.graphics.newImage("images/CameleonAvale7.png")
  -- La libelule / The dragonfly
  imgDragonFly[1] = love.graphics.newImage("images/Libellule.png")
  imgDragonFly[2] = love.graphics.newImage("images/Libellule2.png")
  imgDragonFly[3] = love.graphics.newImage("images/Libellule3.png")
  imgDragonFly[4] = love.graphics.newImage("images/Libellule4.png")
  imgDragonFly[5] = love.graphics.newImage("images/Libellule5.png")
  imgDragonFly[6] = love.graphics.newImage("images/Libellule6.png")
  imgDragonFly[7] = love.graphics.newImage("images/Libellule7.png")
  imgDragonFly[8] = love.graphics.newImage("images/Libellule8.png")
  imgDragonFly[9] = love.graphics.newImage("images/Libellule9.png")
  imgDragonFly[10] = love.graphics.newImage("images/Libellule10.png")
  imgDragonFly[11] = love.graphics.newImage("images/Libellule11.png")
  imgDragonFly[12] = love.graphics.newImage("images/Libellule12.png")
  imgDragonFly[13] = love.graphics.newImage("images/Libellule13.png")
  imgDragonFly[14] = love.graphics.newImage("images/Libellule14.png")
  imgDragonFly[15] = love.graphics.newImage("images/Libellule15.png")
  imgDragonFly[16] = love.graphics.newImage("images/Libellule16.png")
  imgDragonFly[17] = love.graphics.newImage("images/Libellule17.png")
  imgDragonFly[18] = love.graphics.newImage("images/Libellule18.png")
  imgDragonFly[19] = love.graphics.newImage("images/Libellule19.png")
  imgDragonFly[20] = love.graphics.newImage("images/Libellule20.png")
  imgDragonFly[21] = love.graphics.newImage("images/Libellule21.png")
  imgDragonFly[22] = love.graphics.newImage("images/Libellule22.png")
  
  -- Images des supports / the platforms
  imageSupport[1] = imgFeuilleVerte2
  imageSupport[2] = imgFeuilleVerte2
  imageSupport[3] = imgFeuilleVerte2
  
  -- Sons et musiques / Sounds and musics
  sndJump = love.audio.newSource("sons/Jump_Ressort_3.wav","static")
  sndFall = love.audio.newSource("sons/Fall.wav","static")
  sndSwallow = love.audio.newSource("sons/Swallow_Child.mp3","static")
  sndHeavySwallow = love.audio.newSource("sons/Heavy-swallow.wav", "static")
  sndCamSwalCrowler = love.audio.newSource("sons/Swallow_Little.wav", "static")
  sndCamSwalSpider = love.audio.newSource("sons/Swallow_Monster.mp3", "static")
  AmbianceJungleStrange = love.audio.newSource("sons/Jungle_Strange_Amb.wav","stream")
  
end -- of love.load() ---------------------------------------------------------------------

-- U P D A T E ----------------------------------------------------------------------------
function love.update(dt)
  
  if mode == "GamePlaying" then
    
    -- Affichage du HERO au début / Display of the HERO at the beginning
    if spider.appear == true then
      spider.timerAppear = spider.timerAppear + (1.5*dt)
      if spider.timerAppear >= 1.5 then
        spider.display = true
        spider.scale = spider.scale - (2.2*dt)
        if spider.scale <= 0.7 then
          spider.scale = 0.7
          spider.appear = false
          spider.timerAppear = 0
        end
      end
    end
    
    -- Pour les fluctuations des trajectoires des insectes / fluctuations in insect trajectories
    if coordBool == false then
      coordVar = coordVar + (2*dt)
    end
    if coordVar >= 2 then
      coordVar = 2
      coordBool = true
    end
    if coordBool == true then
      coordVar = coordVar - (2*dt)
    end
    if coordVar <= -2 then
      coordVar = -2
      coordBool = false
    end
    
    -- Affichage progressif de l'écran en début de partie / Progressive display of the screen at the beginning
    if timerGame > 2 and gameoverOut == false then
      fading = fading + (0.7*dt)
      if fading >= 1 then
        fading = 1
      end
    end
    
    -- Durée de la partie et sortie d'écran / Game duration and screen exit
    timerGame = timerGame - (1*dt)
    if timerGame <= 2 and gameOver.state == false then
      --fading = fading - (0.4*dt)
      fading = fading - (0.6*dt)
      if fading <= 0 then
        mode = "TimeUp"
      end
    end
    if timerGame <= 0 and gameOver.state == true then
      timerGame = 0
    end
    
    -- Musique de fond / Background music
    AmbJungStrange(true)
    
    -- Création des insectes / Creation of bugs
    -- Les mouches / Flies
    timerCreaInsect = timerCreaInsect - (9*dt)
    if timerCreaInsect <= 0 then
      AddInsect("Fly")
      timerCreaInsect = 20
    end
    -- Les libélules / Dragonflies
    timerCreaInsect2 = timerCreaInsect2 - (5*dt)
    if timerCreaInsect2 <= 0 then
      AddInsect("DragonFly")
      timerCreaInsect2 = 50
    end
    -- Gestion des insectes / Management of the bugs
    for n = #listInsect, 1, -1 do
      myInsect = listInsect[n]
      if myInsect.type == "Fly" then
        if myInsect.coordVariation == 1 then
          myInsect.x = myInsect.x + coordVar
        else
          myInsect.x = myInsect.x - coordVar
        end
        
      myInsect.y = myInsect.y + myInsect.speed*dt
        if myInsect.y >= 1250 or myInsect.y <= -1250 then
          table.remove(listInsect, n)
        end
        -- Collision entre le HERO et les mouches / HERO and flies collision
        if CheckCollision(spider.x, spider.y, 40, 40, myInsect.x, myInsect.y, 40, 40) and (spider.scale >= 1) then
          if myInsect.type == "Fly" then
            SoundSwallow(true)
            score = score + 30
            table.remove(listInsect, n)
            spider_old_x = spider.x
            spider_old_y = spider.y
            spider.swallowFly = true
            spider.swallow = true
          end
        end
      end
      if myInsect.type == "DragonFly" then
      myInsect.x = myInsect.x + myInsect.speed2*dt
      myInsect.y = myInsect.y + (coordVar/2)
        if myInsect.x >= 1350 or myInsect.x <= -900 then
        table.remove(listInsect, n)
      end
        -- Collision entre le HERO et les libélules / HERO and dragonflies collision
        if CheckCollision(spider.x, spider.y, 100, 50, myInsect.x, myInsect.y, -20, 70) and spider.scale >= 1 and myInsect.angle2 == 109.95 then   -- Libélule de Droite à Gauche / Dragonfly move from Right to Left
          SoundSwallow(true)
          score = score + 100
          table.remove(listInsect, n)
          spider_old_x = spider.x
          spider_old_y = spider.y
          spider.swallowDragon = true
          spider.swallow = true
        end
        if CheckCollision(spider.x, spider.y, 60, 50, myInsect.x, myInsect.y, 90, 70) and spider.scale >= 1 and myInsect.angle2 == 106.83 then   -- Libélule de Gauche à Droite / Dragonfly from Left to Right
          SoundSwallow(true)
          score = score + 100
          table.remove(listInsect, n)
          spider_old_x = spider.x
          spider_old_y = spider.y
          spider.swallowDragon = true
          spider.swallow = true
        end
      end
    end
    -- Animation de la mouche / Fly animation
    frameFly = frameFly + (70*dt)
    if frameFly >= #imgFly + 1 then
      frameFly = 1
    end
    -- Animation de la libélule / Dragonfly animation
    frameDragonFly = frameDragonFly + (130*dt)
    if frameDragonFly >= #imgDragonFly + 1 then
      frameDragonFly = 1
    end
    
    -- Animation et déplacement du caméléon / Cameleon animation and motion
    cameleon.frame = cameleon.frame + (4*dt)
    if cameleon.frame >= #cameleon.img + 1 then
      cameleon.frame = 1
    end
    -- Quand le caméléon avale / Cameleon swallowing
    if cameleon.animSwall == true then
      cameleon.frameSwall = cameleon.frameSwall + (10*dt)
      if cameleon.frameSwall >= #cameleon.imgSwall + 1 then
        cameleon.frameSwall = 1
      end
    end
    if cameleon.animSwall == true then
      cameleon.timerAnimSwall = cameleon.timerAnimSwall + (2*dt)
    end
    if cameleon.timerAnimSwall >= 1 then
      cameleon.animSwall = false
      cameleon.frameSwall = 1
      cameleon.timerAnimSwall = 0
    end
    
    cameleon.timerAppear = cameleon.timerAppear - (4*dt)
    cameleon.timerChangeDir = cameleon.timerChangeDir - (5*dt)
    if cameleon.timerAppear <= 0 and cameleon.timerAppear >= -325 then
      CameleoMove(dt)
    end
    if cameleon.timerAppear <= -326 then  -- Réinitialisation du caméléon / Cameleon update
      cameleon.x = 1180
      cameleon.y = support.y_3
      cameleon.speed = 30
      cameleon.angle = 110
      cameleon.timerAppear = 10
      cameleon.timerChangeDir = 1000
    end
    -- Collision entre le "caméléon"(Sprite Fantôme) et la chenille / Cameleon and caterpillar collision
    if (CheckCollision(ghost.x, ghost.y, -10, 80, caterpillar.x, caterpillar.y, 80, 80) or CheckCollision(ghost.x, ghost.y, 40, 80, caterpillar.x, caterpillar.y, 30, 80)) and caterpillar.appear == true then
      cameleon.swalCater = true
      cameleon.animSwall = true
    else
      cameleon.swalCater = false
    end
    if cameleon.swalCater == true then
      cameleon.timerSwalCater = cameleon.timerSwalCater + (0.3*dt)
      if cameleon.timerSwalCater > 0 and cameleon.timerSwalCater <= 0.2 then
        SoundCamSwalCrowler(true)
        caterpillar.speed = 0
      else
        SoundCamSwalCrowler(false)
        CaterCoord()
        caterpillar.speed = 20
        caterpillar.timerAppear = 30
        caterpillar.appear = false
        caterpillar.scale = 1
        caterpillar.frame = 1
      end
    end
    if cameleon.timerSwalCater > 0.2 then
      cameleon.timerSwalCater = 0
    end
    
    -- Collision entre le "caméléon"(Sprite Fantôme) et le HERO / Cameleon and HERO collision
    if (CheckCollision(ghost.x, ghost.y, -30, 80, spider.x, spider.y, 130, 80) and spider.jump == false and (cameleon.angle >= 109 and cameleon.angle <= 111)) or (CheckCollision(ghost.x, ghost.y, 100, 80, spider.x, spider.y, 0, 80) and spider.jump == false and (cameleon.angle >= 106 and cameleon.angle <= 108)) then
      cameleon.swalSpider = true
      cameleon.animSwall = true
    else
      cameleon.swalSpider = false
    end
    if cameleon.swalSpider == true then
      cameleon.timerSwalSpider = cameleon.timerSwalSpider + (0.3*dt)
      if cameleon.timerSwalSpider >= 0 then
        SoundCamSwalSpider(true)
        ResetAfterFail()
      else
        SoundCamSwalSpider(false)
      end
    end
    
    -- Affichage dynamique du score / Dynamic score display
    if spider.swallow == true then
      spider.timerSwallow = spider.timerSwallow + (0.3*dt)
      scoreUp = scoreUp + (11*dt)
      scoreFading = scoreFading - (0.5*dt)
      if spider.timerSwallow >= 0.5 then
        spider.swallow = false
        spider.swallowCater = false
        spider.swallowFly = false
        spider.swallowDragon = false
        spider.timerSwallow = 0
        scoreUp = 0
        scoreFading = 1
      end
    end
    
    -- Apparition, Animation et déplacement de la chenille / Appearance, animation and movement caterpillar
    caterpillar.timerAppear = caterpillar.timerAppear - (2*dt)
    if caterpillar.timerAppear <= 0 and caterpillar.timerAppear >= -22 then
      caterpillar.appear = true
      caterpillar.speed = 20
      caterpillar.x = caterpillar.x + caterpillar.speed * dt
      caterpillar.frame = caterpillar.frame + (5*dt)
      if caterpillar.frame >= #caterpillar.img + 1 then
        caterpillar.frame = 9
      end
      if caterpillar.timerAppear <= -20 then
        caterpillar.scale = caterpillar.scale - (1*dt)
        if caterpillar.scale <= 0 then
          caterpillar.scale = 0
        end
      end
    elseif caterpillar.timerAppear <= -23 then
      caterpillar.appear = false
      CaterCoord()
      caterpillar.timerAppear = 50
      caterpillar.scale = 1
      caterpillar.frame = 1
    end
    
    -- Collision entre la chenille et le HERO / Caterpillar and HERO collision
    if CheckCollision(spider.x, spider.y, 40, 50, caterpillar.x, caterpillar.y, 40, 50) and caterpillar.appear == true and spider.scale <= 0.8 then
      spider.swallow = true
      spider_old_x = spider.x
      spider_old_y = spider.y
      if spider.life <= 4 then
        spider.life = spider.life + 1
      end
      SoundSwallowHard(true)
      spider.swallowCater = true
      caterpillar.appear = false
      CaterCoord()
      caterpillar.timerAppear = 50
      caterpillar.scale = 1
      caterpillar.frame = 1
    end
    
    if spider.life > 0 and spider.appear == false then
      -- Déplacements du HERO / HERO motion
      local dirAntiClock = love.keyboard.isDown("j")
      local dirAntiClock2 = love.keyboard.isDown("kp1")
      local dirClock = love.keyboard.isDown("l")
      local dirClock2 = love.keyboard.isDown("kp3")
      local dirUp = love.keyboard.isDown("i")
      local dirUp2 = love.keyboard.isDown("kp5")
      if dirAntiClock == false and dirAntiClock2 == false and dirClock == false and dirClock2 == false then
        spider.rotate = false
      end
      if dirUp == false and dirUp2 == false then
        spider.move = false
      end
      -- Rotation
      if spider.jump == false then
        if dirAntiClock or dirAntiClock2 then
          spider.rotate = true
          spider.angle = spider.angle - spider.speedRotate*dt
        elseif dirClock or dirClock2 then
          spider.rotate = true
          spider.angle = spider.angle + spider.speedRotate*dt
        end
      end
      -- Linéaire
      if (dirUp or dirUp2) and spider.fall == false then
        if spider.jump == false then
          spider.move = true
        end
      end
      if spider.move == true then
        if spider.jump == false and spider.fall == false then
          local spider_vx = spider.speedMove * math.cos(spider.angle)
          local spider_vy = spider.speedMove * math.sin(spider.angle)
          spider.x = spider.x + spider_vx*dt
          spider.y = spider.y + spider_vy*dt
        end
      end
      -- Gestion du saut du HERO / HERO jump
      if spider.jump == true then
        if dirAntiClock == true or dirAntiClock2 == true or dirClock == true or dirClock2 == true or dirUp == true or dirUp2 == true then
          local spider_vx = spider.speedJump * math.cos(spider.angle)
          local spider_vy = spider.speedJump * math.sin(spider.angle)
          spider.x = spider.x + spider_vx*dt
          spider.y = spider.y + spider_vy*dt
        end
        spider.timerJump = spider.timerJump + (2*dt)
        if spider.timerJump > 0 and spider.timerJump <= 0.7 then
          spider.scale = spider.scale + (2*dt)
        end
        if spider.timerJump > 0.7 and spider.timerJump <= 1.4 then
          spider.scale = spider.scale - (2*dt)
        end
        if spider.timerJump > 1.4 then
          spider.scale = 0.7
          spider.jump = false
          spider.timerJump = 0
        end
        if spider.timerJump > 0 and spider.timerJump <= 0.7 then
          SoundJump(true)
        else
          SoundJump(false)
        end
      end
      
      -- Animation du HERO en rotation / Rotating HERO animation
      spider.frame = spider.frame + (10*dt)
      if spider.frame >= #spider.imgMov + 1 then
        spider.frame = 1
      end
      
      -- Collision entre le HERO et les supports / HERO and platforms collision
      if (CheckCollision(spider.x, spider.y, 100, 70, support.x_1_1, support.y_1, 100, 80) or -- 1ère ligne
        CheckCollision(spider.x, spider.y, 100, 70, support.x_1_2, support.y_1, 100, 80) or
        CheckCollision(spider.x, spider.y, 100, 70, support.x_1_3, support.y_1, 100, 80) or 
        CheckCollision(spider.x, spider.y, 100, 70, support.x_2_1, support.y_2, 100, 80) or -- 2ème ligne
        CheckCollision(spider.x, spider.y, 100, 70, support.x_2_2, support.y_2, 100, 80) or
        CheckCollision(spider.x, spider.y, 100, 70, support.x_3_1, support.y_3, 100, 80) or -- 3ème ligne
        CheckCollision(spider.x, spider.y, 100, 70, support.x_3_2, support.y_3, 100, 80) or
        CheckCollision(spider.x, spider.y, 100, 70, support.x_3_3, support.y_3, 100, 80) or
        CheckCollision(spider.x, spider.y, 100, 70, support.x_4_1, support.y_4, 100, 80) or -- 4ème ligne
        CheckCollision(spider.x, spider.y, 100, 70, support.x_4_2, support.y_4, 100, 80) or
        CheckCollision(spider.x, spider.y, 100, 70, support.x_5_1, support.y_5, 100, 80) or -- 5ème ligne
        CheckCollision(spider.x, spider.y, 100, 70, support.x_5_2, support.y_5, 100, 80) or
        CheckCollision(spider.x, spider.y, 100, 70, support.x_5_3, support.y_5, 100, 80)) then
        spider.fall = false
      else
        spider.fall = true
      end
      
      -- Chute du HERO / HERO fall
      if spider.fall == true and spider.jump == false then
        SoundFall(true)
        spider.scale = spider.scale - (1*dt)
        if spider.scale < 0 then
          SoundFall(false)
          spider.scale = 0
          spider.fall = false
          ResetAfterFail()
        end
      end
      
      if spider.x < 0 then
        spider.x = 1024
      end
      if spider.x > 1024 then
        spider.x = 0
      end
      if spider.y < 0 then
        spider.y = 768
      end
      if spider.y > 768 then
        spider.y = 0
      end
      
    end   -- Fin de if spider.life > 0 and spider.display == true / End of ...
    
    if spider.life <= 0 then
      gameOver.state = true
      decreaseBckgMus = decreaseBckgMus + (0.04*dt)
      AmbianceJungleStrange:setVolume(0.1 - decreaseBckgMus)
      if decreaseBckgMus >= 0.1 then
        AmbJungStrange(false)
      end
      gameOver.fading = gameOver.fading + (0.3*dt)
      if gameOver.fading >= 1 then
        gameOver.fading = 1
      end
    end
    
    if gameoverOut == true then
      fading = fading - (0.7*dt)
      if fading <= 0 then
        gameOver.state = false
        Reset()
        mode = "Welcome"
      end
    end
    
    if spider.life == 5 then
      spider.lifeMax = true
    else
      spider.lifeMax = false
    end
    
  end -- Fin de if mode == "GamePlaying" /  End of ...
  
  if mode == "TimeUp" then
  decreaseBckgMus = decreaseBckgMus + (0.06*dt)
    AmbianceJungleStrange:setVolume(0.1 - decreaseBckgMus)
    if decreaseBckgMus >= 0.1 then
      AmbJungStrange(false)
    end
  end
  
end -- of love.update() -------------------------------------------------------------------

-- D R A W --------------------------------------------------------------------------------
function love.draw()
  
  if mode == "Welcome" then
    love.graphics.setColor(1, 1, 1, 0.7)
    love.graphics.draw(imgBckgPhotoWelcom, 0, 0)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setColor(1, 1, 1, 0.8)
    love.graphics.draw(imgPhotoSpider, 795, 580, 0, 0.6, 0.6)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(imgScreenWelcom, 0, 0)
  end
  
  if mode == "GamePlaying" then
    
    -- Affichage du décor / Display scenery
    love.graphics.setColor(1, 1, 1, fading/2)
    love.graphics.draw (imgSol, 0, 0)
    love.graphics.setColor(1, 1, 1, 1)
    
    love.graphics.setColor(1, 1, 1, fading)
    -- Affichage des supports / Platforms display
    -- 1ére ligne / 1rst line
    love.graphics.draw(imageSupport[stage], support.x_1_1, support.y_1, 0, support.scale, support.scale, imageSupport[stage]:getWidth()/2, imageSupport[stage]:getHeight()/2)
    love.graphics.draw(imageSupport[stage], support.x_1_2, support.y_1, 0, support.scale, support.scale, imageSupport[stage]:getWidth()/2, imageSupport[stage]:getHeight()/2)
    love.graphics.draw(imageSupport[stage], support.x_1_3, support.y_1, 0, support.scale, support.scale, imageSupport[stage]:getWidth()/2, imageSupport[stage]:getHeight()/2)
    -- 2éme ligne
    love.graphics.draw(imageSupport[stage], support.x_2_1, support.y_2, 0, support.scale, support.scale, imageSupport[stage]:getWidth()/2, imageSupport[stage]:getHeight()/2)
    love.graphics.draw(imageSupport[stage], support.x_2_2, support.y_2, 0, support.scale, support.scale, imageSupport[stage]:getWidth()/2, imageSupport[stage]:getHeight()/2)
    -- 3éme ligne
    love.graphics.draw(imageSupport[stage], support.x_3_1, support.y_3, 0, support.scale, support.scale, imageSupport[stage]:getWidth()/2, imageSupport[stage]:getHeight()/2)
    love.graphics.draw(imageSupport[stage], support.x_3_2, support.y_3, 0, support.scale, support.scale, imageSupport[stage]:getWidth()/2, imageSupport[stage]:getHeight()/2)
    love.graphics.draw(imageSupport[stage], support.x_3_3, support.y_3, 0, support.scale, support.scale, imageSupport[stage]:getWidth()/2, imageSupport[stage]:getHeight()/2)
    -- 4éme ligne
    love.graphics.draw(imageSupport[stage], support.x_4_1, support.y_4, 0, support.scale, support.scale, imageSupport[stage]:getWidth()/2, imageSupport[stage]:getHeight()/2)
    love.graphics.draw(imageSupport[stage], support.x_4_2, support.y_4, 0, support.scale, support.scale, imageSupport[stage]:getWidth()/2, imageSupport[stage]:getHeight()/2)
    -- 5éme ligne
    love.graphics.draw(imageSupport[stage], support.x_5_1, support.y_5, 0, support.scale, support.scale, imageSupport[stage]:getWidth()/2, imageSupport[stage]:getHeight()/2)
    love.graphics.draw(imageSupport[stage], support.x_5_2, support.y_5, 0, support.scale, support.scale, imageSupport[stage]:getWidth()/2, imageSupport[stage]:getHeight()/2)
    love.graphics.draw(imageSupport[stage], support.x_5_3, support.y_5, 0, support.scale, support.scale, imageSupport[stage]:getWidth()/2, imageSupport[stage]:getHeight()/2)
    
    if caterpillar.appear == true then
      local frameCrowlerArrond = math.floor(caterpillar.frame)
      love.graphics.draw(caterpillar.img[frameCrowlerArrond], caterpillar.x, caterpillar.y, 0, caterpillar.scale, caterpillar.scale, 50, 50)
    end
    
    -- Affichage du caméléon / Cameleon display
    local cameleFrameArrond = math.floor(cameleon.frame)
    if cameleon.animSwall == false then
      love.graphics.draw(cameleon.img[cameleFrameArrond], cameleon.x, cameleon.y, cameleon.angle, 1, 1, 100, 75)
    end
    if cameleon.animSwall == true then
      local cameleFrameArrond2 = math.floor(cameleon.frameSwall)
      love.graphics.draw(cameleon.imgSwall[cameleFrameArrond2], cameleon.x, cameleon.y, cameleon.angle, 1, 1, 100, 75)
    end
    
    -- Affichage du HERO / HERO display
    if spider.life > 0 and spider.display == true and spider.appear == false then
      if spider.rotate == false and spider.move == false and spider.jump == false then
        love.graphics.draw(imgSpiderCrouched, spider.x, spider.y, spider.angle, spider.scale, spider.scale, 50, 50)
      elseif spider.rotate == true or spider.move == true and spider.jump == false then
        local frameSpiderArrond = math.floor(spider.frame)
        love.graphics.draw(spider.imgMov[frameSpiderArrond], spider.x, spider.y, spider.angle, spider.scale, spider.scale, 50, 50)
      end
      if spider.jump == true then
        love.graphics.draw(imgSpiderJump, spider.x, spider.y, spider.angle, spider.scale, spider.scale, 50, 50)
      end
      if spider.swallow == true and spider.swallowCater == true then   -- Affichage dynamique du score
        love.graphics.setColor(1, 1, 1, scoreFading)
        if spider.lifeMax == false then
          love.graphics.print("1 x Life", spider_old_x, spider_old_y - 25 - (scoreUp), 0, 2, 2)
        elseif spider.lifeMax == true then
          love.graphics.print("Life Max", spider_old_x, spider_old_y - 25 - (scoreUp), 0, 2, 2)
        end
        love.graphics.setColor(1, 1, 1, 1)
        
      end
      if spider.swallow == true and spider.swallowFly == true then   -- Affichage dynamique du score
        love.graphics.setColor(1, 1, 1, scoreFading)
        love.graphics.print("+ 30", spider_old_x, spider_old_y - (scoreUp), 0, 2, 2)
        love.graphics.setColor(1, 1, 1, 1)
      end
      if spider.swallow == true and spider.swallowDragon == true then   -- Affichage dynamique du score
        love.graphics.setColor(1, 1, 1, scoreFading)
        love.graphics.print("+ 100", spider_old_x, spider_old_y + 15 - (scoreUp), 0, 2, 2)
        love.graphics.setColor(1, 1, 1, 1)
      end
    end
    -- En début de partie / At the start of a game
    if spider.life > 0 and spider.appear == true and spider.display == true then
      love.graphics.draw(imgSpiderJump, spider.x, spider.y, spider.angle, spider.scale, spider.scale, 50, 50)
    end
    
    -- Affichage des insectes / Insect display
    for m = #listInsect, 1, -1 do
      local myInsect = listInsect[m]
      if myInsect.type == "Fly" then
        local frameFlyArrond = math.floor(frameFly)
        love.graphics.draw(imgFly[frameFlyArrond], myInsect.x, myInsect.y, myInsect.angle, myInsect.scale, myInsect.scale, 50, 50)
      end
      if myInsect.type == "DragonFly" then
        local frameFlyArrond2 = math.floor(frameDragonFly)
        love.graphics.draw(imgDragonFly[frameFlyArrond2], myInsect.x, myInsect.y, myInsect.angle2, myInsect.scale, myInsect.scale, 50, 50)
      end
    end
  
    -- Affichage des infos du jeu / Game info display
    love.graphics.print("Timer = "..tostring(math.floor(timerGame)), 560, 10, 0, 2, 2)
    love.graphics.print("Life = "..tostring(spider.life), 725, 10, 0, 2, 2)
    love.graphics.print("Score = "..tostring(score), 830, 10, 0, 2, 2)
    love.graphics.draw(imgCadran, 788, 25, 0, 1, 1, imgCadran:getWidth()/2, imgCadran:getHeight()/2)
    
    if gameOver.state == true then
      love.graphics.setColor(1, 1, 1, gameOver.fading)
      love.graphics.print("GAME OVER", gameOver.x, gameOver.y, 0, gameOver.scale, gameOver.scale)
      love.graphics.setColor(1, 1, 1, 1)
    end
  
  end -- Fin de if mode == "GamePlaying" / End of "if mode == 'GamePlaying'"

  if mode == "TimeUp" then
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Time's Up!", 430, 350, 0, 2, 2)
    love.graphics.print("Your SCORE :", 420, 390, 0, 2, 2)
    if score < 100 then
      love.graphics.print(" "..tostring(score), 470, 430, 0, 2, 2)
    end
    if score >= 100 and score < 1000 then
      love.graphics.print(" "..tostring(score), 465, 430, 0, 2, 2)
    end
    if score >= 1000 then
      love.graphics.print(" "..tostring(score), 460, 430, 0, 2, 2)
    end
  end
  
end -- of love.draw() ------------------------------------------------------------------------

-- K E Y P R E S S E D -----------------------------------------------------------------------
function love.keypressed(key)
  
  if mode == "Welcome" and (key == "kpenter" or key == "return") then
    Reset()
    mode = "GamePlaying"
  end
  if mode == "TimeUp" and (key == "space" or key == "kpenter" or key == "return") then
    Reset()
    mode = "Welcome"
  end
  if gameOver.state == true and (key == "space" or key == "kpenter" or key == "return") then
    gameoverOut = true
  end
  if mode == "GamePlaying" and key == "space" and spider.jump == false then
    spider.jump = true
  end
  if mode == "GamePlaying" and key == "space" and spider.fall == true then
    spider.jump = false
  end
  
  print(key)
  
end