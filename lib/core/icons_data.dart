/// Inline SVG icons ported verbatim from icons.js - the game never uses an
/// icon font or emoji-as-icon. Monochrome icons use "currentColor" for their
/// stroke/fill, substituted per-instance by AppIcon; coin/diamond bake in
/// their own colors and are rendered as-is.
const Map<String, String> kIconSvgs = {
  'play':
      '<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path d="M6 4 L20 12 L6 20 Z" fill="currentColor" stroke="currentColor" stroke-width="2" stroke-linejoin="round"/></svg>',

  'shopBag':
      '<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M7 9 L5 21 H19 L17 9 Z"/><path d="M9 9 V6.5 a3 3 0 0 1 6 0 V9"/></svg>',

  'profile':
      '<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" fill="currentColor"><circle cx="12" cy="8" r="4"/><path d="M4 21 c0 -4.5 3.5 -7 8 -7 s8 2.5 8 7 Z"/></svg>',

  'coin':
      '<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><circle cx="12" cy="12" r="9" fill="#ffd60a" stroke="#ffb700" stroke-width="2"/><circle cx="12" cy="12" r="5.5" fill="none" stroke="#ffb700" stroke-width="1.5"/></svg>',

  'diamond':
      '<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><defs><linearGradient id="diamondGrad" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#7ad7ff"/><stop offset="1" stop-color="#2b7fff"/></linearGradient></defs><path d="M6 3 H18 L22 9 L12 22 L2 9 Z" fill="url(#diamondGrad)" stroke="#1a5fd0" stroke-width="1" stroke-linejoin="round"/><path d="M2 9 H22 M8.5 9 L12 22 M15.5 9 L12 22 M6 3 L8.5 9 M18 3 L15.5 9" fill="none" stroke="#ffffff" stroke-opacity="0.5" stroke-width="0.8"/></svg>',

  'home':
      '<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 11 L12 4 L20 11"/><path d="M6 10 V20 H18 V10"/></svg>',

  'hint':
      '<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 18 H15"/><path d="M12 3 a6 6 0 0 1 3.5 10.9 c-0.8 0.6 -1.2 1.4 -1.2 2.1 H9.7 c0 -0.7 -0.4 -1.5 -1.2 -2.1 A6 6 0 0 1 12 3 Z"/></svg>',

  'shuffle':
      '<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 6 H7 L17 18 H21"/><path d="M17 6 H21 V10"/><path d="M3 18 H7 L10.5 13.8"/><path d="M17 18 H21 V14"/></svg>',

  'freeze':
      '<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M12 2 V22 M4.5 6 L19.5 18 M19.5 6 L4.5 18"/></svg>',

  'freezeOpponents':
      '<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M12 2 V22 M4.5 6 L19.5 18 M19.5 6 L4.5 18"/><circle cx="12" cy="12" r="10" stroke-dasharray="2 3"/></svg>',

  'tornado':
      '<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M3 5 H21"/><path d="M5 10 H19"/><path d="M8 15 H16"/><path d="M10 20 H14"/></svg>',

  'close':
      '<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round"><path d="M6 6 L18 18 M18 6 L6 18"/></svg>',

  'pause':
      '<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M8 5 V19 M16 5 V19"/></svg>',
};
