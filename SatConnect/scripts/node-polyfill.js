// Polyfill for util.styleText (added in Node 20.12, missing in older versions)
// Required for React Native CLI to work on Node < 20.12
const util = require('util');
if (!util.styleText) {
  util.styleText = (style, text) => text;
}
