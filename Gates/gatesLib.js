.pragma library
.import gates.org 1.0 as Gates

var andC, orC, xorC, notC;
var gID = 0;

var gatesMap = {
    GateType.Not: "GNot.qml",
    GateType.And: "GAnd.qml",
    GateType.Or: "GOr.qml",
    GateType.Xor: "GXor.qml"
};

function preload() {
    for( var i in gatesMap) {
        gatesMap[i] = Qt.createComponent(gatesMap[i]);
    }
}

function createGate(type, par, args) {
    if(type in gatesMap) {
        var obj = comp.createObject(par, args);
        obj.objectName = 'gate_' + type + '_' + gID++;
        if (obj !== null) {
            // Error Handling
            return obj;
        } else {
            console.log("Error creating component: ", comp.errorString());
        }
    }
    return null;
}
