const fs = require('fs');
const obfuscator = require('javascript-obfuscator');

const settings = {
    "compact": true,
    "controlFlowFlattening": true,
    "controlFlowFlatteningThreshold": 1,
    "deadCodeInjection": true,
    "deadCodeInjectionThreshold": 1,
    "debugProtection": true,
    "debugProtectionInterval": 4000,
    "disableConsoleOutput": true,
    "domainLock": [],
    "domainLockRedirectUrl": "about:blank",
    "forceTransformStrings": [],
    "identifierNamesGenerator": "mangled",
    "identifiersDictionary": [],
    "identifiersPrefix": "",
    "ignoreImports": false,
    "log": false,
    "numbersToExpressions": true,
    "optionsPreset": "high-obfuscation",
    "renameGlobals": true,
    "renameProperties": true,
    "renamePropertiesMode": "unsafe",
    "reservedNames": [],
    "reservedStrings": [],
    "seed": 0,
    "selfDefending": true,
    "simplify": false,
    "sourceMap": false,
    "splitStrings": true,
    "splitStringsChunkLength": 3,
    "stringArray": true,
    "stringArrayCallsTransform": true,
    "stringArrayCallsTransformThreshold": 1,
    "stringArrayEncoding": ["rc4"],
    "stringArrayIndexesType": ["hexadecimal-number"],
    "stringArrayIndexShift": true,
    "stringArrayRotate": true,
    "stringArrayShuffle": true,
    "stringArrayWrappersCount": 5,
    "stringArrayWrappersChainedCalls": true,
    "stringArrayWrappersParametersMaxCount": 5,
    "stringArrayWrappersType": "function",
    "stringArrayThreshold": 1,
    "target": "node",
    "transformObjectKeys": true,
    "unicodeEscapeSequence": true
}


const main = () => {
    let inputText = fs.readFileSync('./input.js').toString();
    let obfuscationResult = obfuscator.obfuscate(inputText);
    fs.writeFileSync("./output.js", obfuscationResult.getObfuscatedCode());
}

main();