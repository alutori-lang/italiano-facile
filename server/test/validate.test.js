'use strict';
const test = require('node:test');
const assert = require('node:assert');
const { validateAnswer, parseModelJson } = require('../src/validate');
const { GOOD } = require('./helpers');

const clone = () => JSON.parse(JSON.stringify(GOOD));

test('a good answer passes', () => {
  const r = validateAnswer(clone());
  assert.ok(r.ok, JSON.stringify(r.errors));
  assert.strictEqual(r.value.it, 'il pomodoro');
  assert.strictEqual(r.value.tr.length, 10);
  assert.strictEqual(r.value.rom.zh, 'fanqie|xihongshi');
});

test('wrong number of meanings fails', () => {
  const a = clone(); a.tr.pop();
  assert.ok(!validateAnswer(a).ok);
});

test('empty meaning fails', () => {
  const a = clone(); a.tr[7] = '  ';
  assert.ok(!validateAnswer(a).ok);
});

test('script checks per slot', () => {
  const bad = [
    [1, 'tamatar'],          // Urdu in Latin
    [2, 'ਟਮਾਟਰ'],            // Shahmukhi slot with Gurmukhi
    [1, 'ٹماٹر tomato'],     // mixed Arabic + Latin
    [3, 'ٹماٹر'],            // Gurmukhi slot with Arabic
    [4, 'tomato'],           // Bengali slot in Latin
    [5, 'টমেটো'],            // Sinhala slot with Bengali
    [6, 'tomato'],           // Chinese slot in Latin
    [0, 'ٹماٹر'],            // English slot in Arabic
  ];
  for (const [slot, value] of bad) {
    const a = clone(); a.tr[slot] = value;
    assert.ok(!validateAnswer(a).ok, `slot ${slot} = ${value} must fail`);
  }
});

test('pos, gender, offensive flag and types are checked', () => {
  let a = clone(); a.pos = 'noun-ish'; assert.ok(!validateAnswer(a).ok);
  a = clone(); a.g = 'x'; assert.ok(!validateAnswer(a).ok);
  a = clone(); delete a.offensive; assert.ok(!validateAnswer(a).ok);
  a = clone(); a.it = 42; assert.ok(!validateAnswer(a).ok);
  a = clone(); a.it = 'x'.repeat(500); assert.ok(!validateAnswer(a).ok);
  a = clone(); a.gloss = ''; assert.ok(!validateAnswer(a).ok);
  assert.ok(!validateAnswer(null).ok);
  assert.ok(!validateAnswer([1, 2]).ok);
});

test('bad romanizations are dropped, not fatal', () => {
  const a = clone(); a.rom = { ur: 'ٹماٹر', zh: 'fan qie', xx: 'y' };
  const r = validateAnswer(a);
  assert.ok(r.ok);
  assert.deepStrictEqual(r.value.rom, { zh: 'fan qie' });
});

test('gender is null for non-nouns', () => {
  const a = clone(); a.pos = 'verb'; a.it = 'mangiare';
  assert.strictEqual(validateAnswer(a).value.g, null);
});

test('unknown answer', () => {
  const r = validateAnswer({ unknown: true, offensive: false });
  assert.ok(r.ok && r.unknown);
});

test('parseModelJson handles fences and chatter', () => {
  assert.deepStrictEqual(parseModelJson('```json\n{"a":1}\n```'), { a: 1 });
  assert.deepStrictEqual(parseModelJson('Sure! {"a":{"b":2}} hope it helps'), { a: { b: 2 } });
  assert.strictEqual(parseModelJson('no json here'), null);
  assert.strictEqual(parseModelJson('{broken'), null);
});
