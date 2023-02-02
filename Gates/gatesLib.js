.pragma library
.import gates.org 1.0 as Gates

var gID = 0;

var gatesMap=[];

function preload() {
    gatesMap[Gates.GateLib.Gate] = "Gate.qml"
    gatesMap[Gates.GateLib.Not] = "GNot.qml"
    gatesMap[Gates.GateLib.And] = "GAnd.qml"
    gatesMap[Gates.GateLib.Or] = "GOr.qml"
    gatesMap[Gates.GateLib.Xor] = "GXor.qml"
    for( var i in gatesMap) {
        gatesMap[i] = Qt.createComponent(gatesMap[i]);
    }
}

function createGate(type, par, args) {
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
