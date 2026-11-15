import { readFileSync, readdirSync, statSync } from "node:fs";
import { join, relative } from "node:path";
const root=process.cwd();
const catalogue=readFileSync(join(root,"lib/i18n/messages.ts"),"utf8");
const keys=new Set([...catalogue.matchAll(/^\s*"([^"]+)"\s*:/gm)].map(match=>match[1]));
const files=[];
function walk(dir){for(const name of readdirSync(dir)){const path=join(dir,name);if(statSync(path).isDirectory())walk(path);else if(/\.(tsx|ts)$/.test(name))files.push(path);}}
for(const dir of ["components","app"])walk(join(root,dir));
const missing=[];
for(const file of files){const content=readFileSync(file,"utf8");for(const match of content.matchAll(/\bt\(\s*"([^"]+)"\s*\)/g)){if(!keys.has(match[1]))missing.push(relative(root,file)+": "+match[1]);}}
if(missing.length){console.error("Missing Arabic translation keys:\n"+missing.join("\n"));process.exit(1);}
console.log("Arabic catalogue covers every literal t() key.");
