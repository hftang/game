// ORISHAS PATH - Full HTML5 RPG Game Engine
const GM = {
  playerName: "", className: "", classIndex: 0,
  level: 1, exp: 0, expToNext: 100,
  oriCoin: 0, hp: 100, maxHp: 100,
  mp: 50, maxMp: 50, atk: 15, def: 10,
  inventory: [], currentScene: null, selectedLevel: null,
};

const CLASSES = [
  { name: "Ogun Warrior", desc: "High HP, strong physical attacks. Tank.", hp: 130, mp: 30, atk: 20, def: 15, color: "#e67e22", icon: "\u2694\ufe0f" },
  { name: "Shango Mage", desc: "Powerful magic damage. Glass cannon.", hp: 80, mp: 80, atk: 25, def: 6, color: "#9b59b6", icon: "\u26a1" },
  { name: "Oshun Healer", desc: "Healing and support magic.", hp: 90, mp: 70, atk: 12, def: 10, color: "#f1c40f", icon: "\u2728" },
  { name: "Eshu Scout", desc: "Fast, tricky, debuff specialist.", hp: 85, mp: 60, atk: 18, def: 8, color: "#1abc9c", icon: "\ud83d\udc41\ufe0f" },
];

const SHOP_ITEMS = [
  { name: "Iron Sword", price: 100, atk: 5, icon: "\u2694\ufe0f", desc: "+5 ATK" },
  { name: "Bronze Axe", price: 150, atk: 8, icon: "\ud83e\ude93", desc: "+8 ATK" },
  { name: "Thunder Staff", price: 300, atk: 12, icon: "\u26a1", desc: "+12 ATK" },
  { name: "Leather Vest", price: 80, def: 3, icon: "\ud83e\udde5", desc: "+3 DEF" },
  { name: "Iron Plate", price: 200, def: 8, icon: "\ud83d\udee1\ufe0f", desc: "+8 DEF" },
  { name: "HP Potion", price: 30, heal: 50, icon: "\u2764\ufe0f", desc: "+50 HP" },
  { name: "MP Potion", price: 25, mp: 30, icon: "\ud83d\udca7", desc: "+30 MP" },
];

const LEVELS = [
  { id: 1, name: "Savanna Outskirts", desc: "Hyenas and scorpions roam the grasslands.", req: 1, enemy: "Wild Hyena", enemyHp: 60, enemyAtk: 8, bg: "#2d5016" },
  { id: 2, name: "Sahara Crossing", desc: "Desert bandits ambush travelers.", req: 3, enemy: "Sand Bandit", enemyHp: 90, enemyAtk: 12, bg: "#c2956b" },
  { id: 3, name: "Sacred Forest", desc: "Dark spirits guard ancient secrets.", req: 5, enemy: "Forest Spirit", enemyHp: 120, enemyAtk: 16, bg: "#1a3a1a" },
  { id: 4, name: "Olokun\u0027s Lair", desc: "The sea god awaits the worthy.", req: 7, enemy: "Olokun", enemyHp: 200, enemyAtk: 22, bg: "#0a2040" },
];

const QUESTS = [
  { name: "First Blood", desc: "Defeat your first enemy in battle.", reward: 50 },
  { name: "Savanna Guardian", desc: "Clear the Savanna Outskirts.", reward: 100 },
  { name: "Collector", desc: "Buy 3 items from the shop.", reward: 75 },
];

const CHAT_MESSAGES = ["Welcome to Orishas Path!", "May the Orishas guide you.", "Anyone want to trade?", "LFG Sacred Forest"];

const app = document.getElementById("app");
const particleCanvas = document.getElementById("particles");
const pctx = particleCanvas.getContext("2d");
let particles = [];

function resizeCanvas() { particleCanvas.width = window.innerWidth; particleCanvas.height = window.innerHeight; }
window.addEventListener("resize", resizeCanvas);
resizeCanvas();
function spawnParticles(x, y, count, color, speed, life) {
  for (let i = 0; i < count; i++) {
    const angle = Math.random() * Math.PI * 2;
    const spd = speed * (0.5 + Math.random());
    particles.push({ x, y, vx: Math.cos(angle)*spd, vy: Math.sin(angle)*spd, life, maxLife: life, color, size: 2+Math.random()*4 });
  }
}

function spawnFloatingText(x, y, text, color, size) {
  const el = document.createElement("div");
  el.textContent = text;
  el.style.cssText = "position:fixed;left:"+x+"px;top:"+y+"px;color:"+color+";font-size:"+size+"px;font-weight:900;text-shadow:0 0 10px "+color+",0 2px 4px rgba(0,0,0,0.8);pointer-events:none;z-index:10000;transition:all 0.8s ease-out;opacity:1;transform:translateY(0) scale(1);";
  document.body.appendChild(el);
  requestAnimationFrame(function(){ el.style.transform = "translateY(-80px) scale(1.3)"; el.style.opacity = "0"; });
  setTimeout(function(){ el.remove(); }, 900);
}

function animateParticles() {
  pctx.clearRect(0, 0, particleCanvas.width, particleCanvas.height);
  for (let i = particles.length-1; i >= 0; i--) {
    const p = particles[i];
    p.x += p.vx; p.y += p.vy; p.vy += 0.1; p.life--;
    const alpha = p.life / p.maxLife;
    pctx.globalAlpha = alpha;
    pctx.fillStyle = p.color;
    pctx.beginPath();
    pctx.arc(p.x, p.y, p.size * alpha, 0, Math.PI * 2);
    pctx.fill();
    if (p.life <= 0) particles.splice(i, 1);
  }
  pctx.globalAlpha = 1;
  requestAnimationFrame(animateParticles);
}
animateParticles();

function clearScene() { app.innerHTML = ""; }

function screenShake(intensity, duration) {
  const start = Date.now();
  const shake = function() {
    const elapsed = Date.now() - start;
    if (elapsed > duration) { app.style.transform = ""; return; }
    const decay = 1 - elapsed / duration;
    app.style.transform = "translate("+((Math.random()-0.5)*intensity*decay)+"px,"+((Math.random()-0.5)*intensity*decay)+"px)";
    requestAnimationFrame(shake);
  };
  shake();
}

function screenFlash(color, duration) {
  const flash = document.createElement("div");
  flash.style.cssText = "position:fixed;top:0;left:0;width:100%;height:100%;background:"+color+";z-index:9998;pointer-events:none;opacity:1;transition:opacity "+duration+"ms ease-out;";
  document.body.appendChild(flash);
  requestAnimationFrame(function(){ flash.style.opacity = "0"; });
  setTimeout(function(){ flash.remove(); }, duration + 50);
}

const STYLES = {
  scene: "position:absolute;top:0;left:0;width:100%;height:100%;display:flex;flex-direction:column;align-items:center;overflow-y:auto;overflow-x:hidden;",
  title: "font-size:2.5em;font-weight:900;letter-spacing:2px;text-transform:uppercase;text-align:center;",
  subtitle: "font-size:1em;opacity:0.7;text-align:center;margin-top:4px;",
  btn: "display:flex;align-items:center;justify-content:center;gap:8px;padding:14px 28px;border:none;border-radius:12px;font-size:1.1em;font-weight:700;cursor:pointer;transition:all 0.15s ease;min-width:220px;letter-spacing:0.5px;",
  btnPrimary: "background:linear-gradient(135deg,#f5af19,#f12711);color:#fff;box-shadow:0 4px 15px rgba(241,39,17,0.4),0 0 20px rgba(245,175,25,0.2);",
  btnSecondary: "background:linear-gradient(135deg,#667eea,#764ba2);color:#fff;box-shadow:0 4px 15px rgba(118,75,162,0.4);",
  btnGold: "background:linear-gradient(135deg,#f7971e,#ffd200);color:#1a0a00;box-shadow:0 4px 15px rgba(255,210,0,0.4),0 0 25px rgba(247,151,30,0.3);",
  btnDanger: "background:linear-gradient(135deg,#e74c3c,#c0392b);color:#fff;box-shadow:0 4px 15px rgba(231,76,60,0.4);",
  btnSuccess: "background:linear-gradient(135deg,#2ecc71,#27ae60);color:#fff;box-shadow:0 4px 15px rgba(46,204,113,0.4);",
  card: "background:rgba(255,255,255,0.08);backdrop-filter:blur(10px);border:1px solid rgba(255,255,255,0.12);border-radius:16px;padding:16px;margin:6px 0;",
  input: "padding:12px 18px;border:2px solid rgba(255,255,255,0.2);border-radius:10px;background:rgba(0,0,0,0.4);color:#fff;font-size:1.1em;outline:none;transition:border-color 0.2s;width:100%;",
};

function makeBtn(text, style, onClick, icon) {
  const btn = document.createElement("button");
  btn.innerHTML = (icon ? "<span>"+icon+"</span> " : "") + text;
  btn.style.cssText = STYLES.btn + style;
  btn.addEventListener("click", onClick);
  btn.addEventListener("mousedown", function(){ btn.style.transform = "scale(0.95)"; });
  btn.addEventListener("mouseup", function(){ btn.style.transform = "scale(1)"; });
  btn.addEventListener("mouseleave", function(){ btn.style.transform = "scale(1)"; });
  return btn;
}
// MAIN MENU
function showMainMenu() {
  clearScene();
  GM.currentScene = "main_menu";
  const s = document.createElement("div");
  s.style.cssText = STYLES.scene + "background:linear-gradient(180deg,#0a0600 0%,#1a0f00 30%,#2a1500 60%,#0a0600 100%);justify-content:center;";

  const stars = document.createElement("div");
  stars.style.cssText = "position:absolute;top:0;left:0;width:100%;height:100%;pointer-events:none;";
  for (let i = 0; i < 40; i++) {
    const star = document.createElement("div");
    const sz = 1+Math.random()*3;
    const op = 0.3+Math.random()*0.7;
    star.style.cssText = "position:absolute;width:"+sz+"px;height:"+sz+"px;background:rgba(255,220,150,"+op+");border-radius:50%;left:"+(Math.random()*100)+"%;top:"+(Math.random()*100)+"%;animation:pulse "+(1+Math.random()*2)+"s ease-in-out infinite alternate;";
    stars.appendChild(star);
  }
  s.appendChild(stars);

  const glowOrb = document.createElement("div");
  glowOrb.style.cssText = "position:absolute;width:300px;height:300px;border-radius:50%;background:radial-gradient(circle,rgba(245,175,25,0.15),transparent 70%);top:20%;left:50%;transform:translateX(-50%);pointer-events:none;animation:pulse 3s ease-in-out infinite alternate;";
  s.appendChild(glowOrb);

  const content = document.createElement("div");
  content.style.cssText = "display:flex;flex-direction:column;align-items:center;gap:20px;z-index:2;padding:20px;";

  const icon = document.createElement("div");
  icon.style.cssText = "font-size:5em;margin-bottom:10px;filter:drop-shadow(0 0 20px rgba(245,175,25,0.5));";
  icon.textContent = "\ud83c\udf0b";
  content.appendChild(icon);

  const title = document.createElement("h1");
  title.style.cssText = STYLES.title + "background:linear-gradient(135deg,#f5af19,#ffd200,#f5af19);-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text;filter:drop-shadow(0 2px 10px rgba(245,175,25,0.5));";
  title.textContent = "ORISHAS PATH";
  content.appendChild(title);

  const sub = document.createElement("p");
  sub.style.cssText = STYLES.subtitle + "color:#c8a86e;";
  sub.textContent = "African Mythology RPG";
  content.appendChild(sub);

  const vfx = document.createElement("p");
  vfx.style.cssText = "font-size:0.75em;color:#665533;margin-top:-10px;";
  vfx.textContent = "Battle the spirits. Claim your destiny.";
  content.appendChild(vfx);

  content.appendChild(makeBtn("START GAME", STYLES.btnPrimary, function(){ showCharSelect(); }, "\u25b6"));
  content.appendChild(makeBtn("SETTINGS", STYLES.btnSecondary, function(){}, "\u2699\ufe0f"));
  content.appendChild(makeBtn("QUIT", STYLES.btnDanger, function(){}, "\u2716"));

  const ver = document.createElement("p");
  ver.style.cssText = "font-size:0.7em;color:#443322;margin-top:20px;";
  ver.textContent = "v1.0 | Deployed for Africa";
  content.appendChild(ver);

  s.appendChild(content);

  const style = document.createElement("style");
  style.textContent = "@keyframes pulse { 0% { opacity:0.4; transform:scale(0.95); } 100% { opacity:1; transform:scale(1.05); } } @keyframes float { 0%,100% { transform:translateY(0); } 50% { transform:translateY(-10px); } } @keyframes slideUp { from { opacity:0; transform:translateY(30px); } to { opacity:1; transform:translateY(0); } } @keyframes shakeAnim { 0%,100% { transform:translateX(0); } 25% { transform:translateX(-5px); } 75% { transform:translateX(5px); } }";
  s.appendChild(style);
  app.appendChild(s);
}

// CHARACTER SELECT
function showCharSelect() {
  clearScene();
  GM.currentScene = "char_select";
  const s = document.createElement("div");
  s.style.cssText = STYLES.scene + "background:linear-gradient(180deg,#0d0800 0%,#1a1000 40%,#0d0800 100%);padding:20px;";

  const h = document.createElement("h2");
  h.style.cssText = STYLES.title + "font-size:1.8em;color:#ffd200;margin-top:15px;";
  h.textContent = "\u2694\ufe0f Create Your Hero";
  s.appendChild(h);

  const sub = document.createElement("p");
  sub.style.cssText = "color:#998866;font-size:0.9em;margin:5px 0 15px;text-align:center;";
  sub.textContent = "Choose your path among the Orishas";
  s.appendChild(sub);

  const nameInput = document.createElement("input");
  nameInput.type = "text";
  nameInput.placeholder = "Enter your name...";
  nameInput.maxLength = 16;
  nameInput.style.cssText = STYLES.input + "max-width:350px;margin-bottom:15px;text-align:center;";
  s.appendChild(nameInput);

  const classGrid = document.createElement("div");
  classGrid.style.cssText = "display:grid;grid-template-columns:1fr 1fr;gap:10px;max-width:400px;width:100%;margin-bottom:15px;";
  let selectedIdx = 0;
  const cards = [];
  const descText = document.createElement("p");
  descText.style.cssText = "color:#e67e22;font-size:0.9em;text-align:center;margin-bottom:15px;min-height:20px;";
  descText.textContent = CLASSES[0].desc;

  CLASSES.forEach(function(cls, i) {
    const card = document.createElement("div");
    card.style.cssText = STYLES.card + "cursor:pointer;text-align:center;padding:14px 10px;transition:all 0.2s;border-color:"+(i===0 ? cls.color : "rgba(255,255,255,0.12)")+";"+(i===0 ? "box-shadow:0 0 20px "+cls.color+"40;" : "");
    card.innerHTML = '<div style="font-size:2.2em;margin-bottom:4px;">'+cls.icon+'</div><div style="font-weight:700;color:'+cls.color+';font-size:0.95em;">'+cls.name+'</div><div style="font-size:0.7em;color:#998;margin-top:3px;">HP:'+cls.hp+' MP:'+cls.mp+' ATK:'+cls.atk+'</div>';
    card.addEventListener("click", function() {
      cards.forEach(function(c){ c.style.borderColor = "rgba(255,255,255,0.12)"; c.style.boxShadow = "none"; });
      card.style.borderColor = cls.color;
      card.style.boxShadow = "0 0 20px "+cls.color+"40";
      selectedIdx = i;
      descText.textContent = cls.desc;
      descText.style.color = cls.color;
    });
    cards.push(card);
    classGrid.appendChild(card);
  });
  s.appendChild(classGrid);
  s.appendChild(descText);

  const createBtn = makeBtn("Create Character", STYLES.btnGold, function() {
    const name = nameInput.value.trim();
    if (!name) { descText.textContent = "Please enter a name!"; descText.style.color = "#e74c3c"; return; }
    GM.playerName = name;
    GM.className = CLASSES[selectedIdx].name;
    GM.classIndex = selectedIdx;
    GM.maxHp = CLASSES[selectedIdx].hp;
    GM.hp = GM.maxHp;
    GM.maxMp = CLASSES[selectedIdx].mp;
    GM.mp = GM.maxMp;
    GM.atk = CLASSES[selectedIdx].atk;
    GM.def = CLASSES[selectedIdx].def;
    GM.oriCoin = 100;
    GM.level = 1;
    GM.exp = 0;
    GM.inventory = [];
    showTown();
  }, "\u2728");
  createBtn.style.maxWidth = "350px";
  s.appendChild(createBtn);
  app.appendChild(s);
}
// TOWN HUB
function showTown() {
  clearScene();
  GM.currentScene = "town";
  const s = document.createElement("div");
  s.style.cssText = STYLES.scene + "background:linear-gradient(180deg,#1a1200 0%,#2a1a08 40%,#1a1200 100%);padding:15px;";

  const header = document.createElement("div");
  header.style.cssText = "width:100%;display:flex;justify-content:space-between;align-items:center;padding:10px 5px;margin-bottom:10px;";
  header.innerHTML = '<div style="color:#ffd200;font-weight:900;font-size:1.3em;">\ud83c\udff0 '+GM.playerName+'</div><div style="color:#f5af19;font-weight:700;">Lv.'+GM.level+'</div>';
  s.appendChild(header);

  const coinBar = document.createElement("div");
  coinBar.style.cssText = "width:100%;display:flex;gap:8px;margin-bottom:8px;";
  const coinEl = document.createElement("div");
  coinEl.style.cssText = STYLES.card + "flex:1;text-align:center;padding:10px;font-size:0.95em;";
  coinEl.innerHTML = '\ud83e\ude99 <span style="color:#ffd200;font-weight:700;">'+GM.oriCoin+'</span> Ori Coin';
  const hpEl = document.createElement("div");
  hpEl.style.cssText = STYLES.card + "flex:1;text-align:center;padding:10px;font-size:0.95em;";
  hpEl.innerHTML = '\u2764\ufe0f <span style="color:#e74c3c;font-weight:700;">'+GM.hp+'/'+GM.maxHp+'</span>';
  const mpEl = document.createElement("div");
  mpEl.style.cssText = STYLES.card + "flex:1;text-align:center;padding:10px;font-size:0.95em;";
  mpEl.innerHTML = '\ud83d\udca7 <span style="color:#3498db;font-weight:700;">'+GM.mp+'/'+GM.maxMp+'</span>';
  coinBar.appendChild(coinEl);
  coinBar.appendChild(hpEl);
  coinBar.appendChild(mpEl);
  s.appendChild(coinBar);

  const expBar = document.createElement("div");
  expBar.style.cssText = "width:100%;height:8px;background:rgba(255,255,255,0.1);border-radius:4px;margin-bottom:15px;overflow:hidden;";
  const expFill = document.createElement("div");
  var expPct = (GM.exp/GM.expToNext*100);
  expFill.style.cssText = "height:100%;width:"+expPct+"%;background:linear-gradient(90deg,#f5af19,#ffd200);border-radius:4px;transition:width 0.5s;";
  expBar.appendChild(expFill);
  s.appendChild(expBar);

  const btns = [
    { text: "Adventure", style: STYLES.btnPrimary, icon: "\u2694\ufe0f", action: function(){ showLevelSelect(); } },
    { text: "Shop", style: STYLES.btnGold, icon: "\ud83d\uded2", action: function(){ showShop(); } },
    { text: "Inventory", style: STYLES.btnSecondary, icon: "\ud83c\udf92", action: function(){ showInventory(); } },
    { text: "Quests", style: STYLES.btnSecondary, icon: "\ud83d\udcdc", action: function(){ showQuests(); } },
    { text: "Profile", style: STYLES.btnSecondary, icon: "\ud83d\udc64", action: function(){ showProfile(); } },
    { text: "World Chat", style: STYLES.btnSecondary, icon: "\ud83d\udcac", action: function(){ showChat(); } },
    { text: "Recharge", style: STYLES.btnSuccess, icon: "\ud83d\udcb3", action: function(){ GM.oriCoin += 500; coinEl.innerHTML = '\ud83e\ude99 <span style="color:#ffd200;font-weight:700;">'+GM.oriCoin+'</span> Ori Coin'; spawnFloatingText(window.innerWidth/2, window.innerHeight/2, "+500 Ori Coin!", "#ffd200", 28); } },
  ];

  const grid = document.createElement("div");
  grid.style.cssText = "display:flex;flex-direction:column;gap:10px;width:100%;max-width:400px;";
  btns.forEach(function(b) {
    const btn = makeBtn(b.text, b.style, b.action, b.icon);
    btn.style.width = "100%";
    grid.appendChild(btn);
  });
  s.appendChild(grid);
  app.appendChild(s);
}

// LEVEL SELECT
function showLevelSelect() {
  clearScene();
  GM.currentScene = "level_select";
  const s = document.createElement("div");
  s.style.cssText = STYLES.scene + "background:linear-gradient(180deg,#0a1a0a 0%,#152015 50%,#0a1a0a 100%);padding:20px;";

  const h = document.createElement("h2");
  h.style.cssText = STYLES.title + "font-size:1.6em;color:#4CAF50;margin:15px 0;";
  h.textContent = "\ud83c\udf0d World Map";
  s.appendChild(h);

  const list = document.createElement("div");
  list.style.cssText = "display:flex;flex-direction:column;gap:10px;width:100%;max-width:400px;";

  LEVELS.forEach(function(lv) {
    const locked = GM.level < lv.req;
    const card = document.createElement("div");
    card.style.cssText = STYLES.card + (locked ? "opacity:0.5;" : "cursor:pointer;");
    var lockText = locked ? '\ud83d\udd12 Lv.' + lv.req : "\u25b6";
    var nameColor = locked ? "#666" : "#4CAF50";
    var lockColor = locked ? "#c0392b" : "#27ae60";
    card.innerHTML = '<div style="display:flex;justify-content:space-between;align-items:center;"><div><div style="font-weight:700;font-size:1.1em;color:'+nameColor+';">'+lv.name+'</div><div style="font-size:0.8em;color:#888;margin-top:3px;">'+lv.desc+'</div></div><div style="font-size:0.8em;color:'+lockColor+';">'+lockText+'</div></div>';
    if (!locked) {
      card.addEventListener("click", function(){ GM.selectedLevel = lv; startBattle(); });
    }
    list.appendChild(card);
  });
  s.appendChild(list);

  const backBtn = makeBtn("Back to Town", STYLES.btnDanger, function(){ showTown(); }, "\u2190");
  backBtn.style.maxWidth = "400px";
  backBtn.style.marginTop = "15px";
  s.appendChild(backBtn);
  app.appendChild(s);
}
// BATTLE SYSTEM
let battleState = {};

function startBattle() {
  clearScene();
  GM.currentScene = "battle";
  const lv = GM.selectedLevel || LEVELS[0];

  battleState = {
    playerHp: GM.hp, playerMaxHp: GM.maxHp,
    playerMp: GM.mp, playerMaxMp: GM.maxMp,
    enemyHp: lv.enemyHp, enemyMaxHp: lv.enemyHp,
    enemyName: lv.enemy,
    active: true, animating: false, log: [],
    defending: false,
  };

  const s = document.createElement("div");
  s.id = "battle-scene";
  s.style.cssText = STYLES.scene + "background:linear-gradient(180deg,"+lv.bg+" 0%,#0a0a0a 60%);padding:10px;";

  const style = document.createElement("style");
  style.textContent = "@keyframes enemyIdle{0%,100%{transform:translateY(0) rotate(0deg)}50%{transform:translateY(-5px) rotate(1deg)}}@keyframes enemyHit{0%{filter:brightness(1);transform:translateX(0)}25%{filter:brightness(3) saturate(0);transform:translateX(-10px)}50%{filter:brightness(2);transform:translateX(8px)}100%{filter:brightness(1);transform:translateX(0)}}@keyframes playerGlow{0%,100%{box-shadow:0 0 10px rgba(46,204,113,0.3)}50%{box-shadow:0 0 25px rgba(46,204,113,0.6)}}@keyframes victoryPulse{0%{transform:scale(0.5) rotate(-10deg);opacity:0}50%{transform:scale(1.1) rotate(3deg)}100%{transform:scale(1) rotate(0deg);opacity:1}}@keyframes logFade{from{opacity:0;transform:translateX(-20px)}to{opacity:1;transform:translateX(0)}}@keyframes skillGlow{0%{box-shadow:inset 0 0 30px rgba(155,89,182,0)}50%{box-shadow:inset 0 0 60px rgba(155,89,182,0.4)}100%{box-shadow:inset 0 0 30px rgba(155,89,182,0)}}@keyframes enemyEnter{0%{opacity:0;transform:scale(0.3) translateY(-50px)}100%{opacity:1;transform:scale(1) translateY(0)}}";
  s.appendChild(style);

  // Enemy area
  const enemyArea = document.createElement("div");
  enemyArea.style.cssText = "width:100%;text-align:center;padding:20px 0;position:relative;min-height:220px;";

  const enemyEmoji = document.createElement("div");
  enemyEmoji.id = "enemy-sprite";
  enemyEmoji.style.cssText = "font-size:6em;animation:enemyEnter 0.6s cubic-bezier(0.175,0.885,0.32,1.275) forwards,enemyIdle 2s ease-in-out 0.7s infinite;filter:drop-shadow(0 0 15px rgba(255,50,50,0.4));cursor:default;transition:all 0.15s;";
  var enemyIcons = { 1: "\ud83d\udc3a", 2: "\ud83e\udd77", 3: "\ud83d\udc7b", 4: "\ud83d\udc19" };
  enemyEmoji.textContent = enemyIcons[lv.id] || "\ud83d\udc3a";
  enemyArea.appendChild(enemyEmoji);

  const enemyName = document.createElement("div");
  enemyName.style.cssText = "color:#e74c3c;font-weight:900;font-size:1.2em;margin-top:5px;text-shadow:0 0 10px rgba(231,76,60,0.5);";
  enemyName.textContent = lv.enemy;
  enemyArea.appendChild(enemyName);

  const enemyHpBar = document.createElement("div");
  enemyHpBar.style.cssText = "width:80%;max-width:300px;height:14px;background:rgba(255,255,255,0.1);border-radius:7px;margin:8px auto;overflow:hidden;border:1px solid rgba(255,255,255,0.2);";
  const enemyHpFill = document.createElement("div");
  enemyHpFill.id = "enemy-hp-fill";
  enemyHpFill.style.cssText = "height:100%;width:100%;background:linear-gradient(90deg,#e74c3c,#ff6b6b);border-radius:7px;transition:width 0.4s ease;";
  enemyHpBar.appendChild(enemyHpFill);
  enemyArea.appendChild(enemyHpBar);

  const enemyHpText = document.createElement("div");
  enemyHpText.id = "enemy-hp-text";
  enemyHpText.style.cssText = "color:#ff6b6b;font-size:0.85em;";
  enemyHpText.textContent = battleState.enemyHp + "/" + battleState.enemyMaxHp;
  enemyArea.appendChild(enemyHpText);
  s.appendChild(enemyArea);

  // VS divider
  const vs = document.createElement("div");
  vs.style.cssText = "text-align:center;font-size:1.5em;font-weight:900;color:#ffd200;text-shadow:0 0 15px rgba(255,210,0,0.5);margin:5px 0;";
  vs.textContent = "\u2694\ufe0f VS \u2694\ufe0f";
  s.appendChild(vs);

  // Player area
  const playerArea = document.createElement("div");
  playerArea.id = "player-area";
  playerArea.style.cssText = "width:100%;text-align:center;padding:10px 0;";

  const playerEmoji = document.createElement("div");
  playerEmoji.style.cssText = "font-size:4em;animation:playerGlow 2s ease-in-out infinite;";
  playerEmoji.textContent = CLASSES[GM.classIndex].icon;
  playerArea.appendChild(playerEmoji);

  const playerNameEl = document.createElement("div");
  playerNameEl.style.cssText = "color:" + CLASSES[GM.classIndex].color + ";font-weight:900;font-size:1.1em;";
  playerNameEl.textContent = GM.playerName + " (" + GM.className + ")";
  playerArea.appendChild(playerNameEl);

  const pHpBar = document.createElement("div");
  pHpBar.style.cssText = "width:80%;max-width:300px;height:12px;background:rgba(255,255,255,0.1);border-radius:6px;margin:6px auto;overflow:hidden;border:1px solid rgba(255,255,255,0.2);";
  const pHpFill = document.createElement("div");
  pHpFill.id = "player-hp-fill";
  pHpFill.style.cssText = "height:100%;width:100%;background:linear-gradient(90deg,#2ecc71,#27ae60);border-radius:6px;transition:width 0.4s ease;";
  pHpBar.appendChild(pHpFill);
  playerArea.appendChild(pHpBar);

  const pStatsText = document.createElement("div");
  pStatsText.id = "player-stats-text";
  pStatsText.style.cssText = "color:#aaa;font-size:0.8em;";
  pStatsText.textContent = "HP: " + battleState.playerHp + "/" + battleState.playerMaxHp + " | MP: " + battleState.playerMp + "/" + battleState.playerMaxMp;
  playerArea.appendChild(pStatsText);
  s.appendChild(playerArea);

  // Battle log
  const logDiv = document.createElement("div");
  logDiv.id = "battle-log";
  logDiv.style.cssText = "width:100%;max-width:400px;min-height:80px;max-height:120px;overflow-y:auto;background:rgba(0,0,0,0.5);border:1px solid rgba(255,255,255,0.1);border-radius:10px;padding:10px;margin:10px 0;font-size:0.85em;color:#ccc;";
  s.appendChild(logDiv);

  // Action buttons
  const actionPanel = document.createElement("div");
  actionPanel.id = "action-panel";
  actionPanel.style.cssText = "display:grid;grid-template-columns:1fr 1fr;gap:8px;width:100%;max-width:400px;";

  const attackBtn = makeBtn("Attack", STYLES.btnPrimary, function(){ doAttack(); }, "\u2694\ufe0f");
  attackBtn.id = "attack-btn";
  const skillBtn = makeBtn("Skill", STYLES.btnSecondary, function(){ doSkill(); }, "\u26a1");
  skillBtn.id = "skill-btn";
  const defendBtn = makeBtn("Defend", "background:linear-gradient(135deg,#3498db,#2980b9);color:#fff;box-shadow:0 4px 15px rgba(52,152,219,0.4);"+STYLES.btn, function(){ doDefend(); }, "\ud83d\udee1\ufe0f");
  defendBtn.id = "defend-btn";
  const itemBtn = makeBtn("Item", STYLES.btnSuccess, function(){ doItem(); }, "\ud83e\uddea");
  itemBtn.id = "item-btn";

  actionPanel.appendChild(attackBtn);
  actionPanel.appendChild(skillBtn);
  actionPanel.appendChild(defendBtn);
  actionPanel.appendChild(itemBtn);
  s.appendChild(actionPanel);

  const backBtn = makeBtn("Return to Town", STYLES.btnDanger, function(){ showTown(); }, "\u2190");
  backBtn.id = "battle-back-btn";
  backBtn.style.display = "none";
  backBtn.style.maxWidth = "400px";
  backBtn.style.marginTop = "10px";
  s.appendChild(backBtn);

  app.appendChild(s);

  addBattleLog("Battle Start! " + lv.enemy + " appears!");
  addBattleLog("Choose your action...");
}

function addBattleLog(msg) {
  const logDiv = document.getElementById("battle-log");
  if (!logDiv) return;
  battleState.log.push(msg);
  if (battleState.log.length > 20) battleState.log.shift();
  var html = "";
  for (var i = 0; i < battleState.log.length; i++) {
    var extra = (i === battleState.log.length-1) ? "color:#fff;font-weight:700;" : "";
    html += '<div style="animation:logFade 0.3s ease;'+extra+'">'+battleState.log[i]+'</div>';
  }
  logDiv.innerHTML = html;
  logDiv.scrollTop = logDiv.scrollHeight;
}

function updateBattleUI() {
  var eFill = document.getElementById("enemy-hp-fill");
  var eText = document.getElementById("enemy-hp-text");
  var pFill = document.getElementById("player-hp-fill");
  var pText = document.getElementById("player-stats-text");
  if (eFill) eFill.style.width = Math.max(0, battleState.enemyHp / battleState.enemyMaxHp * 100) + "%";
  if (eText) eText.textContent = Math.max(0,battleState.enemyHp) + "/" + battleState.enemyMaxHp;
  if (pFill) pFill.style.width = Math.max(0, battleState.playerHp / battleState.playerMaxHp * 100) + "%";
  if (pText) pText.textContent = "HP: " + Math.max(0,battleState.playerHp) + "/" + battleState.playerMaxHp + " | MP: " + battleState.playerMp + "/" + battleState.playerMaxMp;
}

function setActionsEnabled(on) {
  var ids = ["attack-btn","skill-btn","defend-btn","item-btn"];
  ids.forEach(function(id) {
    var btn = document.getElementById(id);
    if (btn) { btn.style.pointerEvents = on ? "auto" : "none"; btn.style.opacity = on ? "1" : "0.5"; }
  });
}

function shakeEnemy() {
  var e = document.getElementById("enemy-sprite");
  if (!e) return;
  e.style.animation = "enemyHit 0.4s ease";
  setTimeout(function(){ e.style.animation = "enemyIdle 2s ease-in-out infinite"; }, 500);
}

function spawnHitParticles() {
  var e = document.getElementById("enemy-sprite");
  if (!e) return;
  var rect = e.getBoundingClientRect();
  var cx = rect.left + rect.width/2;
  var cy = rect.top + rect.height/2;
  spawnParticles(cx, cy, 15, "#ff6b35", 4, 30);
  spawnParticles(cx, cy, 8, "#ffd200", 3, 25);
}

function spawnSkillParticles() {
  var e = document.getElementById("enemy-sprite");
  if (!e) return;
  var rect = e.getBoundingClientRect();
  var cx = rect.left + rect.width/2;
  var cy = rect.top + rect.height/2;
  spawnParticles(cx, cy, 25, "#9b59b6", 5, 40);
  spawnParticles(cx, cy, 20, "#3498db", 4, 35);
  spawnParticles(cx, cy, 10, "#e74c3c", 3, 30);
}

function spawnHealParticles() {
  var p = document.getElementById("player-area");
  if (!p) return;
  var rect = p.getBoundingClientRect();
  var cx = rect.left + rect.width/2;
  var cy = rect.top + rect.height/2;
  spawnParticles(cx, cy, 20, "#2ecc71", 3, 40);
  spawnParticles(cx, cy, 10, "#27ae60", 2, 35);
}
function doAttack() {
  if (!battleState.active || battleState.animating) return;
  battleState.animating = true;
  setActionsEnabled(false);
  battleState.defending = false;

  var damage = Math.floor(Math.random() * 10) + GM.atk - 5;
  var crit = Math.random() < 0.15;
  var finalDmg = crit ? Math.floor(damage * 1.8) : Math.max(1, damage);

  screenShake(crit ? 12 : 6, crit ? 300 : 200);
  shakeEnemy();
  spawnHitParticles();

  var e = document.getElementById("enemy-sprite");
  var rect = e.getBoundingClientRect();
  spawnFloatingText(rect.left + rect.width/2 - 30, rect.top, (crit ? "CRIT! " : "-") + finalDmg, crit ? "#ffd200" : "#ff4444", crit ? 42 : 32);
  screenFlash("rgba(255,100,50,0.2)", 200);

  setTimeout(function() {
    battleState.enemyHp -= finalDmg;
    addBattleLog("You attack for " + finalDmg + " damage!" + (crit ? " CRITICAL!" : ""));
    updateBattleUI();
    if (battleState.enemyHp <= 0) { battleVictory(); }
    else { setTimeout(function(){ enemyTurn(); }, 500); }
  }, 400);
}

function doSkill() {
  if (!battleState.active || battleState.animating) return;
  if (battleState.playerMp < 10) { addBattleLog("Not enough MP!"); return; }
  battleState.animating = true;
  setActionsEnabled(false);
  battleState.playerMp -= 10;

  var damage = Math.floor(Math.random() * 15) + GM.atk;
  var crit = Math.random() < 0.2;
  var finalDmg = crit ? Math.floor(damage * 2) : Math.max(1, damage);

  screenFlash("rgba(155,89,182,0.3)", 300);
  screenShake(crit ? 15 : 8, 300);
  shakeEnemy();
  spawnSkillParticles();

  var e = document.getElementById("enemy-sprite");
  var rect = e.getBoundingClientRect();
  spawnFloatingText(rect.left + rect.width/2 - 30, rect.top, (crit ? "SKILL CRIT! " : "-") + finalDmg, "#c39bd3", crit ? 46 : 36);

  setTimeout(function() {
    battleState.enemyHp -= finalDmg;
    addBattleLog("Skill attack for " + finalDmg + " damage!" + (crit ? " DEVASTATING!" : ""));
    updateBattleUI();
    if (battleState.enemyHp <= 0) { battleVictory(); }
    else { setTimeout(function(){ enemyTurn(); }, 500); }
  }, 500);
}

function doDefend() {
  if (!battleState.active || battleState.animating) return;
  battleState.animating = true;
  setActionsEnabled(false);
  battleState.defending = true;

  screenFlash("rgba(52,152,219,0.3)", 300);
  addBattleLog("You raise your shield! DEF up this turn.");

  setTimeout(function(){ enemyTurn(); }, 400);
}

function doItem() {
  if (!battleState.active || battleState.animating) return;
  battleState.animating = true;
  setActionsEnabled(false);
  battleState.defending = false;

  var heal = 30;
  battleState.playerHp = Math.min(battleState.playerMaxHp, battleState.playerHp + heal);
  spawnHealParticles();

  var p = document.getElementById("player-area");
  var rect = p.getBoundingClientRect();
  spawnFloatingText(rect.left + rect.width/2, rect.top, "+" + heal + " HP", "#2ecc71", 30);
  addBattleLog("Potion used! +" + heal + " HP");
  updateBattleUI();

  setTimeout(function(){ enemyTurn(); }, 500);
}

function enemyTurn() {
  var baseDmg = GM.selectedLevel ? GM.selectedLevel.enemyAtk : 8;
  var damage = Math.floor(Math.random() * 8) + baseDmg;
  if (battleState.defending) {
    damage = Math.max(1, Math.floor(damage * 0.3));
    addBattleLog("Blocked! Only " + damage + " damage!");
  } else {
    addBattleLog(battleState.enemyName + " attacks for " + damage + "!");
  }

  screenShake(battleState.defending ? 3 : 8, 200);
  screenFlash("rgba(255,50,50," + (battleState.defending ? "0.1" : "0.25") + ")", 200);

  var p = document.getElementById("player-area");
  var rect = p.getBoundingClientRect();
  spawnFloatingText(rect.left + rect.width/2 - 20, rect.top, "-" + damage, "#ff4444", 28);

  battleState.playerHp -= damage;
  battleState.defending = false;
  updateBattleUI();

  if (battleState.playerHp <= 0) {
    setTimeout(function(){ battleDefeat(); }, 300);
  } else {
    setTimeout(function() {
      battleState.animating = false;
      setActionsEnabled(true);
    }, 400);
  }
}

function battleVictory() {
  battleState.active = false;
  var expGain = 20 + (GM.selectedLevel ? GM.selectedLevel.id * 5 : 0);
  var coinGain = 10 + (GM.selectedLevel ? GM.selectedLevel.id * 5 : 0);
  GM.exp += expGain;
  GM.oriCoin += coinGain;
  while (GM.exp >= GM.expToNext) {
    GM.exp -= GM.expToNext;
    GM.level++;
    GM.maxHp += 10;
    GM.maxMp += 5;
    GM.atk += 2;
    GM.def += 1;
    GM.hp = GM.maxHp;
    GM.mp = GM.maxMp;
    GM.expToNext = Math.floor(GM.expToNext * 1.5);
    addBattleLog("LEVEL UP! Now Lv." + GM.level + "!");
  }
  GM.hp = Math.max(GM.hp, battleState.playerHp);
  GM.mp = Math.max(GM.mp, battleState.playerMp);

  screenFlash("rgba(255,215,0,0.4)", 500);
  spawnParticles(window.innerWidth/2, window.innerHeight/2 - 100, 40, "#ffd200", 6, 50);
  spawnParticles(window.innerWidth/2, window.innerHeight/2 - 100, 30, "#f5af19", 5, 45);

  addBattleLog("VICTORY! +" + expGain + " EXP, +" + coinGain + " Ori Coin");

  var e = document.getElementById("enemy-sprite");
  if (e) { e.style.transition = "all 0.8s"; e.style.transform = "scale(0) rotate(180deg)"; e.style.opacity = "0"; }

  setTimeout(function() {
    setActionsEnabled(false);
    var ap = document.getElementById("action-panel");
    if (ap) ap.style.display = "none";

    var vicPanel = document.createElement("div");
    vicPanel.style.cssText = "position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);text-align:center;animation:victoryPulse 0.8s ease;z-index:100;";
    vicPanel.innerHTML = '<div style="font-size:4em;">\ud83c\udfc6</div><div style="font-size:2.5em;font-weight:900;background:linear-gradient(135deg,#ffd200,#f5af19);-webkit-background-clip:text;-webkit-text-fill-color:transparent;">VICTORY!</div><div style="color:#ffd200;font-size:1.1em;margin-top:8px;">+' + expGain + ' EXP | +' + coinGain + ' Ori Coin</div>';
    document.getElementById("battle-scene").appendChild(vicPanel);

    var bb = document.getElementById("battle-back-btn");
    if (bb) { bb.style.display = "flex"; bb.style.margin = "10px auto"; }
  }, 800);
}

function battleDefeat() {
  battleState.active = false;
  screenFlash("rgba(139,0,0,0.5)", 600);
  addBattleLog("DEFEAT...");

  setTimeout(function() {
    setActionsEnabled(false);
    var ap = document.getElementById("action-panel");
    if (ap) ap.style.display = "none";

    var defPanel = document.createElement("div");
    defPanel.style.cssText = "position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);text-align:center;animation:victoryPulse 0.8s ease;z-index:100;";
    defPanel.innerHTML = '<div style="font-size:3em;">\ud83d\udc80</div><div style="font-size:2.2em;font-weight:900;color:#e74c3c;">DEFEAT</div><div style="color:#999;margin-top:8px;">The Orishas demand you try again...</div>';
    document.getElementById("battle-scene").appendChild(defPanel);

    var bb = document.getElementById("battle-back-btn");
    if (bb) { bb.style.display = "flex"; bb.style.margin = "10px auto"; }
  }, 600);
}
// SHOP
function showShop() {
  clearScene();
  GM.currentScene = "shop";
  const s = document.createElement("div");
  s.style.cssText = STYLES.scene + "background:linear-gradient(180deg,#1a0f05 0%,#2a1a0a 50%,#1a0f05 100%);padding:20px;";

  const h = document.createElement("h2");
  h.style.cssText = STYLES.title + "font-size:1.6em;color:#ffd200;margin:15px 0 5px;";
  h.textContent = "\ud83d\uded2 Shop";
  s.appendChild(h);

  const coinEl = document.createElement("div");
  coinEl.style.cssText = "color:#f5af19;font-weight:700;margin-bottom:15px;";
  coinEl.textContent = "\ud83e\ude99 Ori Coin: " + GM.oriCoin;
  s.appendChild(coinEl);

  const list = document.createElement("div");
  list.style.cssText = "display:flex;flex-direction:column;gap:8px;width:100%;max-width:400px;";

  SHOP_ITEMS.forEach(function(item, i) {
    const card = document.createElement("div");
    card.style.cssText = STYLES.card + "display:flex;align-items:center;gap:10px;padding:12px;";
    card.innerHTML = '<div style="font-size:1.8em;">'+item.icon+'</div><div style="flex:1;"><div style="font-weight:700;color:#ffd200;">'+item.name+'</div><div style="font-size:0.8em;color:#aaa;">'+item.desc+'</div></div><div style="text-align:right;"><div style="color:#f5af19;font-weight:700;">'+item.price+' OC</div></div>';
    const buyBtn = document.createElement("button");
    buyBtn.textContent = "Buy";
    buyBtn.style.cssText = "padding:6px 14px;border:none;border-radius:8px;background:linear-gradient(135deg,#ffd200,#f5af19);color:#1a0a00;font-weight:700;cursor:pointer;font-size:0.85em;margin-top:4px;";
    buyBtn.addEventListener("click", function() {
      if (GM.oriCoin >= item.price) {
        GM.oriCoin -= item.price;
        GM.inventory.push(item);
        coinEl.textContent = "\ud83e\ude99 Ori Coin: " + GM.oriCoin;
        spawnFloatingText(window.innerWidth/2, 200, item.name + " purchased!", "#2ecc71", 22);
      } else {
        spawnFloatingText(window.innerWidth/2, 200, "Not enough coins!", "#e74c3c", 22);
      }
    });
    const btnWrap = document.createElement("div");
    btnWrap.style.cssText = "display:flex;flex-direction:column;align-items:center;";
    btnWrap.appendChild(buyBtn);
    card.appendChild(btnWrap);
    list.appendChild(card);
  });
  s.appendChild(list);

  const backBtn = makeBtn("Back to Town", STYLES.btnDanger, function(){ showTown(); }, "\u2190");
  backBtn.style.maxWidth = "400px";
  backBtn.style.marginTop = "15px";
  s.appendChild(backBtn);
  app.appendChild(s);
}

// INVENTORY
function showInventory() {
  clearScene();
  GM.currentScene = "inventory";
  const s = document.createElement("div");
  s.style.cssText = STYLES.scene + "background:linear-gradient(180deg,#0d0815 0%,#1a1025 50%,#0d0815 100%);padding:20px;";

  const h = document.createElement("h2");
  h.style.cssText = STYLES.title + "font-size:1.6em;color:#c39bd3;margin:15px 0;";
  h.textContent = "\ud83c\udf92 Inventory";
  s.appendChild(h);

  if (GM.inventory.length === 0) {
    const empty = document.createElement("div");
    empty.style.cssText = "color:#666;text-align:center;padding:40px;font-size:1.1em;";
    empty.textContent = "Your inventory is empty. Visit the shop!";
    s.appendChild(empty);
  } else {
    const list = document.createElement("div");
    list.style.cssText = "display:flex;flex-direction:column;gap:8px;width:100%;max-width:400px;";
    const counts = {};
    GM.inventory.forEach(function(item) { counts[item.name] = (counts[item.name] || 0) + 1; });
    Object.keys(counts).forEach(function(name) {
      var item = null;
      for (var j = 0; j < GM.inventory.length; j++) { if (GM.inventory[j].name === name) { item = GM.inventory[j]; break; } }
      const card = document.createElement("div");
      card.style.cssText = STYLES.card + "display:flex;align-items:center;gap:10px;";
      card.innerHTML = '<div style="font-size:1.5em;">'+item.icon+'</div><div style="flex:1;"><div style="font-weight:700;color:#c39bd3;">'+name+'</div><div style="font-size:0.8em;color:#aaa;">'+item.desc+'</div></div><div style="color:#ffd200;font-weight:700;">x'+counts[name]+'</div>';
      list.appendChild(card);
    });
    s.appendChild(list);
  }

  const backBtn = makeBtn("Back to Town", STYLES.btnDanger, function(){ showTown(); }, "\u2190");
  backBtn.style.maxWidth = "400px";
  backBtn.style.marginTop = "15px";
  s.appendChild(backBtn);
  app.appendChild(s);
}

// QUESTS
function showQuests() {
  clearScene();
  GM.currentScene = "quests";
  const s = document.createElement("div");
  s.style.cssText = STYLES.scene + "background:linear-gradient(180deg,#0a0d00 0%,#151a08 50%,#0a0d00 100%);padding:20px;";

  const h = document.createElement("h2");
  h.style.cssText = STYLES.title + "font-size:1.6em;color:#f39c12;margin:15px 0;";
  h.textContent = "\ud83d\udcdc Quests";
  s.appendChild(h);

  const list = document.createElement("div");
  list.style.cssText = "display:flex;flex-direction:column;gap:8px;width:100%;max-width:400px;";

  QUESTS.forEach(function(q) {
    const card = document.createElement("div");
    card.style.cssText = STYLES.card;
    card.innerHTML = '<div style="font-weight:700;color:#f39c12;">'+q.name+'</div><div style="font-size:0.85em;color:#aaa;margin:4px 0;">'+q.desc+'</div><div style="font-size:0.8em;color:#2ecc71;">Reward: '+q.reward+' Ori Coin</div>';
    list.appendChild(card);
  });
  s.appendChild(list);

  const backBtn = makeBtn("Back to Town", STYLES.btnDanger, function(){ showTown(); }, "\u2190");
  backBtn.style.maxWidth = "400px";
  backBtn.style.marginTop = "15px";
  s.appendChild(backBtn);
  app.appendChild(s);
}

// PROFILE
function showProfile() {
  clearScene();
  GM.currentScene = "profile";
  const s = document.createElement("div");
  s.style.cssText = STYLES.scene + "background:linear-gradient(180deg,#0a0a15 0%,#151525 50%,#0a0a15 100%);padding:20px;";

  const h = document.createElement("h2");
  h.style.cssText = STYLES.title + "font-size:1.6em;color:#3498db;margin:15px 0;";
  h.textContent = "\ud83d\udc64 Profile";
  s.appendChild(h);

  const card = document.createElement("div");
  card.style.cssText = STYLES.card + "width:100%;max-width:400px;text-align:center;padding:20px;";
  var cls = CLASSES[GM.classIndex];
  card.innerHTML = '<div style="font-size:4em;margin-bottom:10px;">'+cls.icon+'</div><div style="font-size:1.4em;font-weight:900;color:'+cls.color+';">'+GM.playerName+'</div><div style="color:#ffd200;margin:5px 0;">'+GM.className+' | Lv.'+GM.level+'</div><div style="margin-top:15px;display:grid;grid-template-columns:1fr 1fr;gap:8px;text-align:left;"><div style="color:#e74c3c;">\u2764\ufe0f HP: '+GM.hp+'/'+GM.maxHp+'</div><div style="color:#3498db;">\ud83d\udca7 MP: '+GM.mp+'/'+GM.maxMp+'</div><div style="color:#e67e22;">\u2694\ufe0f ATK: '+GM.atk+'</div><div style="color:#95a5a6;">\ud83d\udee1\ufe0f DEF: '+GM.def+'</div><div style="color:#f39c12;">\ud83e\ude99 Ori Coin: '+GM.oriCoin+'</div><div style="color:#2ecc71;">\u2b50 EXP: '+GM.exp+'/'+GM.expToNext+'</div></div>';
  s.appendChild(card);

  const backBtn = makeBtn("Back to Town", STYLES.btnDanger, function(){ showTown(); }, "\u2190");
  backBtn.style.maxWidth = "400px";
  backBtn.style.marginTop = "15px";
  s.appendChild(backBtn);
  app.appendChild(s);
}

// CHAT
function showChat() {
  clearScene();
  GM.currentScene = "chat";
  const s = document.createElement("div");
  s.style.cssText = STYLES.scene + "background:linear-gradient(180deg,#0a0a0a 0%,#151515 50%,#0a0a0a 100%);padding:20px;";

  const h = document.createElement("h2");
  h.style.cssText = STYLES.title + "font-size:1.6em;color:#1abc9c;margin:15px 0;";
  h.textContent = "\ud83d\udcac World Chat";
  s.appendChild(h);

  const chatBox = document.createElement("div");
  chatBox.style.cssText = "width:100%;max-width:400px;flex:1;min-height:200px;max-height:400px;overflow-y:auto;background:rgba(0,0,0,0.4);border:1px solid rgba(255,255,255,0.1);border-radius:12px;padding:12px;margin-bottom:10px;";
  CHAT_MESSAGES.forEach(function(msg) {
    const div = document.createElement("div");
    div.style.cssText = "padding:4px 0;color:#aaa;font-size:0.9em;border-bottom:1px solid rgba(255,255,255,0.05);";
    div.textContent = msg;
    chatBox.appendChild(div);
  });
  s.appendChild(chatBox);

  const inputRow = document.createElement("div");
  inputRow.style.cssText = "display:flex;gap:8px;width:100%;max-width:400px;";
  const input = document.createElement("input");
  input.type = "text";
  input.placeholder = "Type a message...";
  input.style.cssText = STYLES.input + "flex:1;";
  const sendBtn = makeBtn("Send", STYLES.btnSuccess, function() {
    if (input.value.trim()) {
      const div = document.createElement("div");
      div.style.cssText = "padding:4px 0;color:#ffd200;font-size:0.9em;border-bottom:1px solid rgba(255,255,255,0.05);";
      div.textContent = GM.playerName + ": " + input.value;
      chatBox.appendChild(div);
      input.value = "";
      chatBox.scrollTop = chatBox.scrollHeight;
    }
  }, "\u2709\ufe0f");
  sendBtn.style.minWidth = "auto";
  sendBtn.style.padding = "12px 18px";
  inputRow.appendChild(input);
  inputRow.appendChild(sendBtn);
  s.appendChild(inputRow);

  const backBtn = makeBtn("Back to Town", STYLES.btnDanger, function(){ showTown(); }, "\u2190");
  backBtn.style.maxWidth = "400px";
  backBtn.style.marginTop = "15px";
  s.appendChild(backBtn);
  app.appendChild(s);
}

// INIT
showMainMenu();