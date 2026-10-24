#!/usr/bin/env bash
# PreToolUse hook: an active plan's Amendment Log is append-only (AW-20, AW-21).
# Editing the plan body is allowed (amendments edit the phases, then append an entry).
# Blocked: changing or deleting an existing "### A<n>" entry, or removing the "## Amendment Log" section.
# Needs node to parse the payload; without it the hook allows the edit and says so (the written rule still binds).
input="$(cat)"
case "$input" in *docs/plans/active/*|*docs\\\\plans\\\\active\\\\*) ;; *) exit 0 ;; esac
command -v node >/dev/null 2>&1 || { echo "amendment-guard: node not found, Amendment Log not checked." >&2; exit 0; }

printf '%s' "$input" | node -e '
const fs = require("fs");
const p = JSON.parse(fs.readFileSync(0, "utf8")), t = p.tool_input || {};
const file = (t.file_path || "").replace(/\\/g, "/");
const m = file.match(/(?:^|\/)(docs\/plans\/active\/[^/]+\.md)$/);
if (!m) process.exit(0);
// An absolute path in another shell dialect (e.g. /tmp under Git Bash) may not resolve; the cwd-relative one does.
const target = fs.existsSync(t.file_path) ? t.file_path : m[1];
if (!fs.existsSync(target)) process.exit(0);    // a new plan file has no log to protect
const nl = s => (s || "").replace(/\r\n/g, "\n");
const cur = nl(fs.readFileSync(target, "utf8"));

// The log runs from "## Amendment Log" to the next "## " heading or end of file.
const logOf = s => { const i = s.search(/^## Amendment Log[ \t]*$/m); if (i < 0) return null;
  const rest = s.slice(i), j = rest.slice(3).search(/^## /m); return j < 0 ? rest : rest.slice(0, j + 3); };
const entries = log => (log.match(/^### A\d+[\s\S]*?(?=^### A\d+|(?![\s\S]))/mg) || []).map(e => e.replace(/\s+$/, ""));

const curLog = logOf(cur);
if (curLog === null) process.exit(0);           // no log yet: nothing to protect

let next;
if (p.tool_name === "Write") next = nl(t.content);
else {
  const edits = p.tool_name === "MultiEdit" ? (t.edits || []) : [t];
  next = cur;
  for (const e of edits) {
    const o = nl(e.old_string), n = nl(e.new_string);
    if (!o || !next.includes(o)) process.exit(0); // the tool itself will reject a missing old_string
    next = e.replace_all ? next.split(o).join(n) : next.replace(o, () => n);
  }
}
const nextLog = logOf(next);
const fail = msg => { process.stderr.write("Blocked: " + msg + " The Amendment Log in an active plan is append-only (AW-20, AW-21): add a new ### A<n> entry instead of changing an old one. If an entry is wrong, append a correction.\n"); process.exit(2); };
if (nextLog === null) fail("this edit removes the \"## Amendment Log\" section.");
for (const e of entries(curLog)) if (!nextLog.includes(e)) fail("this edit changes or deletes entry \"" + e.split("\n")[0] + "\".");
process.exit(0);
'
