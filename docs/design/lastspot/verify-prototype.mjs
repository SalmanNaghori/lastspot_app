// Uses Node 22+ and an installed Chrome. No npm packages or remote services.
import {spawn} from 'node:child_process';
import {mkdtemp,readFile,writeFile,mkdir,rm} from 'node:fs/promises';
import {tmpdir} from 'node:os';
import {join,dirname} from 'node:path';
import {fileURLToPath,pathToFileURL} from 'node:url';
import vm from 'node:vm';
import assert from 'node:assert/strict';

const directory=dirname(fileURLToPath(import.meta.url));
const chromePath=process.env.LASTSPOT_CHROME_PATH||'/Applications/Google Chrome.app/Contents/MacOS/Google Chrome';
const exportAll=process.argv.includes('--export');
const profile=await mkdtemp(join(tmpdir(),'lastspot-design-chrome-'));
const port=19000+(process.pid%10000);
const chrome=spawn(chromePath,['--headless=new','--disable-gpu','--disable-background-networking','--no-first-run','--no-default-browser-check',`--remote-debugging-port=${port}`,`--user-data-dir=${profile}`,'about:blank'],{stdio:'ignore'});
let socket,counter=0;
const pending=new Map(),exceptions=[],checks=[];
const pause=ms=>new Promise(r=>setTimeout(r,ms));
async function command(method,params={}){const id=++counter;let timer;const result=new Promise((resolve,reject)=>{timer=setTimeout(()=>{pending.delete(id);reject(Error('CDP timeout: '+method));},15000);pending.set(id,{resolve,reject});});socket.send(JSON.stringify({id,method,params}));try{return await result;}finally{clearTimeout(timer);}}
async function evaluate(expression){const r=await command('Runtime.evaluate',{expression,returnByValue:true,awaitPromise:true,userGesture:true});if(r.exceptionDetails)throw Error(r.exceptionDetails.exception?.description||r.exceptionDetails.text);return r.result.value;}
async function settle(){await evaluate('new Promise(r => requestAnimationFrame(() => requestAnimationFrame(r)))');}
async function goto(id,state='default',activity=null){await evaluate(`LastSpotPrototype.go(${JSON.stringify(id)},${JSON.stringify({state,activity})})`);await settle();}
async function click(selector){await evaluate(`(()=>{const el=document.querySelector(${JSON.stringify(selector)});if(!el)throw Error('Missing control: '+${JSON.stringify(selector)});el.click()})()`);await settle();}
async function fill(selector,value){await evaluate(`(()=>{const el=document.querySelector(${JSON.stringify(selector)});if(!el)throw Error('Missing field');el.value=${JSON.stringify(value)};el.dispatchEvent(new Event('input',{bubbles:true}));})()`);}
async function check(name,expression){assert.equal(await evaluate(expression),true,name);checks.push(name);}
async function shot(name){const r=await command('Page.captureScreenshot',{format:'png',captureBeyondViewport:false});await writeFile(join(directory,'screens',name),Buffer.from(r.data,'base64'));}
try{
 let targets;
 for(let n=0;n<60;n++){try{targets=await (await fetch(`http://127.0.0.1:${port}/json`)).json();break;}catch{await pause(100);}}
 assert(targets?.length,'Chrome debugging endpoint did not start');
 const pageTarget=targets.find(t=>t.type==='page'&&t.url==='about:blank');
 assert(pageTarget,'No blank page target available');
 socket=new WebSocket(pageTarget.webSocketDebuggerUrl);await new Promise((resolve,reject)=>{socket.addEventListener('open',resolve,{once:true});socket.addEventListener('error',reject,{once:true});});
 socket.addEventListener('close',()=>{for(const entry of pending.values())entry.reject(Error('Browser connection closed'));pending.clear();});
 socket.addEventListener('message',event=>{const message=JSON.parse(event.data);if(message.id){const entry=pending.get(message.id);pending.delete(message.id);if(message.error)entry?.reject(Error(JSON.stringify(message.error)));else entry?.resolve(message.result);}if(message.method==='Runtime.exceptionThrown')exceptions.push(message.params.exceptionDetails.exception?.description||message.params.exceptionDetails.text);});
 await command('Page.enable');await command('Runtime.enable');
 await command('Emulation.setDeviceMetricsOverride',{width:390,height:844,deviceScaleFactor:2,mobile:false});
 await command('Page.navigate',{url:pathToFileURL(join(directory,'index.html')).href+'?export=1#home'});
 for(let n=0;n<60;n++){if(await evaluate('Boolean(window.LastSpotPrototype)'))break;await pause(100);}
 await settle();await mkdir(join(directory,'screens'),{recursive:true});
 const screens=await evaluate('LastSpotPrototype.screens');
 assert.equal(screens.length,47,'Screen inventory count');
 for(const s of screens){
   if(screens.indexOf(s)%10===0)console.log(`Checking screens ${screens.indexOf(s)+1}–${Math.min(screens.indexOf(s)+10,screens.length)}…`);
   await goto(s.id);await check(`Screen renders: ${s.id}`,`document.querySelector('#app').textContent.trim().length>20 && document.querySelector('#phone').scrollWidth<=391`);
   const contentOverflow=await evaluate(`[...document.querySelectorAll('#app .content')].some(x=>x.scrollWidth>x.clientWidth+2)`);
   assert.equal(contentOverflow,false,`Horizontal overflow on ${s.id}`);
   if(exportAll)await shot(`${String(screens.indexOf(s)+1).padStart(2,'0')}-${s.id}.png`);
   for(const state of s.states){await goto(s.id,state);await check(`State renders: ${s.id}/${state}`,`document.querySelector('#app').textContent.trim().length>20 && [...document.querySelectorAll('#app .content')].every(x=>x.scrollWidth<=x.clientWidth+2)`);if(exportAll)await shot(`${String(screens.indexOf(s)+1).padStart(2,'0')}-${s.id}--${state}.png`);}
 }
 await goto('welcome');await click('#app [data-nav="signup"]');
 await fill('#auth-form [name="name"]','Aanya Patel');await fill('#auth-form [name="email"]','aanya@example.test');await fill('#auth-form [name="password"]','sample-only-password');await fill('#auth-form [name="confirm"]','different');await evaluate('document.querySelector("[name=terms]").checked=true;document.querySelector("#auth-form").requestSubmit()');await settle();
 await check('Signup password mismatch remains on form','LastSpotPrototype.current.id==="signup" && document.querySelector("#form-error").textContent.includes("match")');
 await fill('#auth-form [name="confirm"]','sample-only-password');await evaluate('document.querySelector("#auth-form").requestSubmit()');await settle();
 await check('Signup leads to profile setup','LastSpotPrototype.current.id==="profile-setup"');
 await click('#app [data-act="choose-city"]');await fill('#city-search','zzz');await check('City search empty state','document.querySelector("#city-results").textContent.includes("No city found")');await fill('#city-search','Vad');await click('#city-results [data-value="Vadodara"]');await click('#app [data-act="confirm-city"]');await check('City confirmation returns to setup','LastSpotPrototype.current.id==="profile-setup" && LastSpotPrototype.demo.city==="Vadodara"');
 await evaluate('document.querySelector("#profile-form").requestSubmit()');await settle();await click('#app [data-act="save-interests"]');await check('Profile onboarding reaches Home','LastSpotPrototype.current.id==="home"');
 await click('#reset-demo');await goto('explore');await fill('#activity-search','badminton');await check('Explore search filters results','document.querySelectorAll("#explore-results .activity-card").length===1');
 await fill('#activity-search','');await goto('filters');await click('#app [data-key="price"][data-value="Free"]');await click('#app [data-act="apply-filters"]');await check('Filter applies to actual sample results','LastSpotPrototype.demo.filters.price==="Free" && document.querySelectorAll("#explore-results .activity-card").length===1');
 await goto('activity');await click('#app [data-act="join"]');await check('Join becomes pending and does not expose group chat','LastSpotPrototype.current.id==="activity-pending" && document.querySelector(".action-footer button").disabled && !document.querySelector("#app [data-nav=group-chat]")');
 await click('#app [data-nav="direct-chat"]');await check('Pending applicant can enter supported direct chat','LastSpotPrototype.current.id==="direct-chat"');
 await goto('create-basics');await fill('#create-form [name="title"]','Sunrise cricket crew');await evaluate('document.querySelector("#create-form").requestSubmit()');await settle();await fill('#create-form [name="capacity"]','1');await evaluate('document.querySelector("#create-form").requestSubmit()');await settle();await check('Invalid capacity blocks creation step','LastSpotPrototype.current.id==="create-details"');await fill('#create-form [name="capacity"]','10');await evaluate('document.querySelector("#create-form").requestSubmit()');await settle();await check('Creation review contains draft values','LastSpotPrototype.current.id==="create-review" && document.querySelector("#app").textContent.includes("Sunrise cricket crew")');await click('#app [data-act="publish"]');await pause(650);await settle();await check('Publishing shows success','LastSpotPrototype.current.id==="create-success"');await click('#app [data-created]');await check('Created activity opens entered title','document.querySelector("#app").textContent.includes("Sunrise cricket crew")');
 await goto('request-detail');await click('#app [data-act="accept"]');await check('Acceptance updates request list','LastSpotPrototype.current.id==="requests" && LastSpotPrototype.demo.accepted && document.querySelector("#app").textContent.includes("accepted")');
 await goto('group-chat');await fill('#message-input','*Hello* _team_ ~old~ `B2` ગુજરાતી हिंदी 😊 <script>bad()</script>');await evaluate('document.querySelector("#composer").requestSubmit()');await settle();await check('Chat formatting, Unicode and HTML escaping','document.querySelector(".message-row:last-child strong").textContent==="Hello" && document.querySelector(".message-row:last-child").textContent.includes("ગુજરાતી") && !document.querySelector("#message-list script")');
 await evaluate('LastSpotPrototype.scenario("current")');await check('Current-chat message appends without banner','document.querySelector(".message-row:last-child").textContent.includes("See you soon") && !document.querySelector(".notification-banner")');
 await evaluate('LastSpotPrototype.scenario("other")');await check('Other-chat message shows banner','document.querySelectorAll(".notification-banner").length===1');await click('.banner-body');await check('Banner opens target conversation','LastSpotPrototype.current.id==="direct-chat" && LastSpotPrototype.current.activity==="cricket" && !document.querySelector(".notification-banner")');
 await evaluate('LastSpotPrototype.scenario("rapid")');await check('Rapid notifications keep one banner','document.querySelectorAll(".notification-banner").length===1');await click('#feedback [data-act="dismiss-feedback"]');await check('Manual dismissal clears banner','!document.querySelector(".notification-banner")');
 await evaluate('LastSpotPrototype.scenario("other")');await goto('activities');await check('Navigation clears banner','!document.querySelector(".notification-banner")');
 await goto('group-chat');await evaluate('LastSpotPrototype.scenario("keyboard")');await settle();await check('Composer remains above keyboard','document.querySelector(".composer").getBoundingClientRect().bottom<=document.querySelector(".keyboard-preview").getBoundingClientRect().top+1');if(exportAll)await shot('group-chat--keyboard.png');await evaluate('LastSpotPrototype.scenario("keyboard")');
 await evaluate('LastSpotPrototype.scenario("other");LastSpotPrototype.scenario("expired")');await settle();await check('Session expiry clears feedback','LastSpotPrototype.current.id==="session-expired" && !document.querySelector(".notification-banner")');
 await goto('profile');await evaluate('LastSpotPrototype.scenario("other")');await goto('logout');await click('#app [data-act="logout"]');await check('Logout clears feedback and returns to sign-in','LastSpotPrototype.current.id==="login" && !document.querySelector(".notification-banner")');
 await click('#reset-demo');
 for(const id of ['home','explore','group-chat','profile']){await goto(id);await evaluate('document.querySelector("#theme-picker").value="dark";document.querySelector("#theme-picker").dispatchEvent(new Event("change",{bubbles:true}))');await settle();if(exportAll)await shot(`${id}--dark.png`);}
 await evaluate('document.querySelector("#theme-picker").value="light";document.querySelector("#theme-picker").dispatchEvent(new Event("change",{bubbles:true}))');
 await goto('home');await shot('home-preview.png');
 assert.equal(exceptions.length,0,'Browser JavaScript errors: '+exceptions.join('\n'));
 const report={checkedAt:new Date().toISOString(),screens:screens.length,screenVariants:screens.reduce((n,s)=>n+1+s.states.length,0),checks:checks.length,passed:true,browserExceptions:exceptions,exports:exportAll,scope:'Local prototype interactions and rendered layouts. No Flutter, FCM, Supabase, native OS or authentication integration is tested.'};
 await writeFile(join(directory,'verification.json'),JSON.stringify(report,null,2)+'\n');
 await writeFile(join(directory,'SCREEN-INVENTORY.md'),'# LastSpot screen inventory\n\n47 individual screens and contextual views. Open each linked screen in the local prototype; state variants are available from the inspector. All sample data is illustrative.\n\n| # | Screen | Group | Alternate states | Flutter destination |\n|---|---|---|---|---|\n'+screens.map((s,i)=>`| ${i+1} | [${s.name}](index.html#${s.id}) | ${s.group} | ${s.states.join(', ')||'—'} | \`${s.route}\` |`).join('\n')+'\n');
 console.log(JSON.stringify(report,null,2));
}finally{
 try{if(socket?.readyState===1)await command('Browser.close');}catch{}
 socket?.close();chrome.kill();await pause(200);await rm(profile,{recursive:true,force:true}).catch(()=>{});
}
