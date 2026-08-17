// One-time build script: reproduces the exact dictionary-merge logic from the
// original web app's game.js (normalizeDictionary -> mergeExtraWords, in that
// order) against copies of its three word-source files, and emits a flat
// { "word": points } map as assets/dictionary/words.json.
//
// Usage: node scripts/build_dictionary.mjs <path-to-game.js> <path-to-words.js> <path-to-words-bulk.js>

import { readFileSync, writeFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import path from 'node:path';

const [, , gameJsPath, wordsJsPath, wordsBulkJsPath] = process.argv;
if (!gameJsPath || !wordsJsPath || !wordsBulkJsPath) {
    console.error('Usage: node build_dictionary.mjs <game.js> <words.js> <words-bulk.js>');
    process.exit(1);
}

const FINAL_LETTER_MAP = { 'ך': 'כ', 'ם': 'מ', 'ן': 'נ', 'ף': 'פ', 'ץ': 'צ' };
function normalizeFinals(str) {
    return str.replace(/[ךםןףץ]/g, c => FINAL_LETTER_MAP[c]);
}
function pointsForWord(word) {
    if (word.length >= 5) return 500;
    if (word.length === 4) return 250;
    return 100;
}

// Extract the HEBREW_DICTIONARY object literal out of game.js without
// executing the rest of the (browser-only) file.
function extractDictionary(gameJsSource) {
    const marker = 'const HEBREW_DICTIONARY = ';
    const start = gameJsSource.indexOf(marker);
    if (start === -1) throw new Error('HEBREW_DICTIONARY not found in game.js');
    const braceStart = gameJsSource.indexOf('{', start);
    let depth = 0;
    let end = -1;
    for (let i = braceStart; i < gameJsSource.length; i++) {
        const ch = gameJsSource[i];
        if (ch === '{') depth++;
        else if (ch === '}') {
            depth--;
            if (depth === 0) { end = i; break; }
        }
    }
    if (end === -1) throw new Error('Could not find end of HEBREW_DICTIONARY literal');
    const literal = gameJsSource.slice(braceStart, end + 1);
    // eslint-disable-next-line no-eval
    return eval(`(${literal})`);
}

function extractArray(source, constName) {
    const marker = `const ${constName} = `;
    const start = source.indexOf(marker);
    if (start === -1) throw new Error(`${constName} not found`);
    const bracketStart = source.indexOf('[', start);
    let depth = 0;
    let end = -1;
    for (let i = bracketStart; i < source.length; i++) {
        const ch = source[i];
        if (ch === '[') depth++;
        else if (ch === ']') {
            depth--;
            if (depth === 0) { end = i; break; }
        }
    }
    if (end === -1) throw new Error(`Could not find end of ${constName} literal`);
    const literal = source.slice(bracketStart, end + 1);
    // eslint-disable-next-line no-eval
    return eval(literal);
}

const gameJsSource = readFileSync(gameJsPath, 'utf8');
const wordsJsSource = readFileSync(wordsJsPath, 'utf8');
const wordsBulkJsSource = readFileSync(wordsBulkJsPath, 'utf8');

const dictionary = extractDictionary(gameJsSource);
const extraWords = extractArray(wordsJsSource, 'EXTRA_WORDS');
const extraWordsBulk = extractArray(wordsBulkJsSource, 'EXTRA_WORDS_BULK');

// Step 1: normalizeDictionary() - normalize every key, keep the max score on collision.
for (const key of Object.keys(dictionary)) {
    const norm = normalizeFinals(key);
    if (norm === key) continue;
    dictionary[norm] = Math.max(dictionary[norm] ?? 0, dictionary[key]);
    delete dictionary[key];
}

// Step 2: mergeExtraWords() - add words.js then words-bulk.js, skipping any
// word already present (curated scores win) and any word shorter than 2 chars.
for (const pack of [extraWords, extraWordsBulk]) {
    for (const w of pack) {
        const word = normalizeFinals(w);
        if (word.length >= 2 && dictionary[word] === undefined) {
            dictionary[word] = pointsForWord(word);
        }
    }
}

const sortedEntries = Object.entries(dictionary).sort(([a], [b]) => a.localeCompare(b, 'he'));
const sorted = Object.fromEntries(sortedEntries);

const outDir = path.join(path.dirname(fileURLToPath(import.meta.url)), '..', 'assets', 'dictionary');
const outPath = path.join(outDir, 'words.json');
writeFileSync(outPath, JSON.stringify(sorted), 'utf8');

console.log(`Wrote ${sortedEntries.length} words to ${outPath}`);
