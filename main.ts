// Post file for the make.fun bounty "The agent builds a game from one prompt".
// The entry's post lives on X; this program hands its address to the house
// by copying POST.json from this repository into the output directory.
// The house then reads the post itself and writes its counts beside it.

import { copyFileSync, mkdirSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const here = dirname(fileURLToPath(import.meta.url));
const outDir = process.env.MAKEFUN_OUTPUT_DIR || join(here, 'out');

mkdirSync(outDir, { recursive: true });
copyFileSync(join(here, 'POST.json'), join(outDir, 'POST.json'));
console.log('POST.json copied to ' + outDir);
