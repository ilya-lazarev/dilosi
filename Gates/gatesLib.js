.pragma library
.import gates.org 1.0 as Gates

var andC, orC, xorC, notC;
var gID = 0;

var gatesMap=[];

function preload() {
    gatesMap[Gates.GateType.Not] = "GNot.qml"
    gatesMap[Gates.GateType.And] = "GAnd.qml"
    gatesMap[Gates.GateType.Or] = "GOr.qml"
    gatesMap[Gates.GateType.Xor] = "GXor.qml"

    for( var i in gatesMap) {
        gatesMap[i] = Qt.createComponent(gatesMap[i]);
    }
}

function createGate(type, par, args) {
    console.log("New gate " + type)
    if(type in gatesMap) {
        var comp = gatesMap[type];
        var obj = comp.createObject(par, args);
        if (obj !== null) {
            obj.objectName = 'gate_' + type + '_' + gID++;
            // Error Handling
            return obj;
        } else {
            console.log("Error creating component: " + comp.errorString());
        }
    }
    return null;
}
