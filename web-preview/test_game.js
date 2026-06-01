const { chromium } = require('playwright');
(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage({viewport:{width:400,height:800}});
  
  // Navigate to game
  await page.goto('http://127.0.0.1:8080/');
  await page.waitForTimeout(1500);
  console.log('1. Main Menu loaded');
  
  // Click START GAME
  await page.click('text=START GAME');
  await page.waitForTimeout(500);
  console.log('2. Character Select loaded');
  
  // Type name and select class
  await page.fill('input[type="text"]', 'TestHero');
  await page.waitForTimeout(300);
  
  // Click second class (Shango Mage)
  const classButtons = await page.locator('#app div[style*="cursor:pointer"]').all();
  if (classButtons.length > 1) await classButtons[1].click();
  await page.waitForTimeout(300);
  
  // Click Create Character
  await page.click('text=Create Character');
  await page.waitForTimeout(500);
  console.log('3. Town loaded');
  
  // Click Recharge
  await page.click('text=Recharge');
  await page.waitForTimeout(500);
  console.log('4. Recharge clicked (should add 500 coins)');
  
  // Click Adventure
  await page.click('text=Adventure');
  await page.waitForTimeout(500);
  console.log('5. Level Select loaded');
  
  // Click first level
  const levelBtns = await page.locator('text=Savanna Outskirts').all();
  if (levelBtns.length > 0) await levelBtns[0].click();
  await page.waitForTimeout(500);
  
  // Enter Battle
  const enterBtns = await page.locator('text=Enter Level').all();
  if (enterBtns.length > 0) { 
    await enterBtns[0].click();
  } else {
    // The level select click may directly enter battle
    console.log('Level selected, checking for battle...');
  }
  await page.waitForTimeout(1500);
  console.log('6. Battle scene loaded');
  
  // Take battle screenshot
  await page.screenshot({path:'C:/Users/hftan/Documents/Codex/2026-06-01/superpowers-plugin-superpowers-openai-curated/orishas-path/web-preview/screenshot_battle.png'});
  
  // Click Attack
  await page.click('text=Attack');
  await page.waitForTimeout(2000);
  console.log('7. Attack clicked');
  await page.screenshot({path:'C:/Users/hftan/Documents/Codex/2026-06-01/superpowers-plugin-superpowers-openai-curated/orishas-path/web-preview/screenshot_attack.png'});
  
  // Click Skill
  await page.click('text=Skill');
  await page.waitForTimeout(2000);
  console.log('8. Skill clicked');
  
  // Click Defend
  await page.click('text=Defend');
  await page.waitForTimeout(2000);
  console.log('9. Defend clicked');
  
  // Keep attacking until victory or defeat
  for (let i = 0; i < 20; i++) {
    const backBtn = await page.locator('text=Return to Town').all();
    if (backBtn.length > 0 && await backBtn[0].isVisible()) {
      console.log('10. Battle ended! Victory/Defeat screen visible');
      await page.screenshot({path:'C:/Users/hftan/Documents/Codex/2026-06-01/superpowers-plugin-superpowers-openai-curated/orishas-path/web-preview/screenshot_victory.png'});
      break;
    }
    try { await page.click('text=Attack', {timeout:1000}); } catch(e) { 
      try { await page.click('text=Skill', {timeout:1000}); } catch(e2) {} 
    }
    await page.waitForTimeout(2000);
  }
  
  // Return to town
  try { await page.click('text=Return to Town', {timeout:3000}); } catch(e) {}
  await page.waitForTimeout(500);
  console.log('11. Back in Town');
  
  // Test Shop
  await page.click('text=Shop');
  await page.waitForTimeout(500);
  console.log('12. Shop loaded');
  await page.screenshot({path:'C:/Users/hftan/Documents/Codex/2026-06-01/superpowers-plugin-superpowers-openai-curated/orishas-path/web-preview/screenshot_shop.png'});
  await page.click('text=Back to Town');
  await page.waitForTimeout(500);
  
  // Test Profile
  await page.click('text=Profile');
  await page.waitForTimeout(500);
  console.log('13. Profile loaded');
  await page.screenshot({path:'C:/Users/hftan/Documents/Codex/2026-06-01/superpowers-plugin-superpowers-openai-curated/orishas-path/web-preview/screenshot_profile.png'});
  await page.click('text=Back to Town');
  await page.waitForTimeout(500);
  
  // Test Chat
  await page.click('text=World Chat');
  await page.waitForTimeout(500);
  console.log('14. Chat loaded');
  await page.click('text=Back to Town');
  await page.waitForTimeout(500);
  
  // Test Quests
  await page.click('text=Quests');
  await page.waitForTimeout(500);
  console.log('15. Quests loaded');
  await page.click('text=Back to Town');
  await page.waitForTimeout(500);
  
  // Test Inventory
  await page.click('text=Inventory');
  await page.waitForTimeout(500);
  console.log('16. Inventory loaded');
  await page.screenshot({path:'C:/Users/hftan/Documents/Codex/2026-06-01/superpowers-plugin-superpowers-openai-curated/orishas-path/web-preview/screenshot_inventory.png'});
  
  console.log('\n=== ALL SCENES TESTED SUCCESSFULLY ===');
  await browser.close();
})();