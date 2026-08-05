const fs = require('fs');
const path = require('path');
const { marked } = require('marked');

// privacy-policy.md tetap satu-satunya sumber kebenaran (dipakai juga oleh
// raw.githubusercontent.com untuk fetch offline-first di siuji-android) --
// skrip ini cuma merender salinan HTML-nya, bukan mengganti file sumbernya.
const mdPath = path.join(__dirname, '..', 'privacy-policy.md');
const templatePath = path.join(__dirname, 'template.html');
const outDir = path.join(__dirname, 'dist');

const md = fs.readFileSync(mdPath, 'utf8');
const template = fs.readFileSync(templatePath, 'utf8');
const contentHtml = marked.parse(md);
const html = template.replace('{{CONTENT}}', contentHtml);

fs.mkdirSync(outDir, { recursive: true });
fs.writeFileSync(path.join(outDir, 'index.html'), html);
console.log('Built dist/index.html dari privacy-policy.md');
