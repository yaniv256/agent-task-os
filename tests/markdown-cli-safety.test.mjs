import assert from "node:assert/strict";
import fs from "node:fs";

const skill = fs.readFileSync(
  new URL("../SKILL.md", import.meta.url),
  "utf8",
);

assert.match(skill, /Markdown is data, not shell syntax/i);
assert.match(skill, /--body-file/);
assert.match(skill, /quoted heredoc delimiter/);
assert.match(skill, /Never embed.*double-quoted.*--body/i);
assert.match(skill, /read the\s+remote body back/i);

console.log("Markdown CLI transport contract is present.");
