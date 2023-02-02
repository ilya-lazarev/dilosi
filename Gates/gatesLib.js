.pragma library
.import gates.org 1.0 as Gates

var gID = 0;

var gatesMap=[], symMap=[];

function preload() {
    symMap[Gates.GateType.Gate] = "⨀"
    symMap[Gates.GateType.Not] = "1"
    symMap[Gates.GateType.And] = "&"
    symMap[Gates.GateType.Or] = "1"
    symMap[Gates.GateType.Xor] = "=1"

    gatesMap[Gates.GateType.Gate] = "Gate.qml"
    gatesMap[Gates.GateType.Not] = "GNot.qml"
    gatesMap[Gates.GateType.And] = "GAnd.qml"
    gatesMap[Gates.GateType.Or] = "GOr.qml"
    gatesMap[Gates.GateType.Xor] = "GXor.qml"
    for( var i in gatesMap) {
        gatesMap[i] = Qt.createComponent(gatesMap[i]);
    }
}

function getSymbol(type) {
    return symMap[type]
}

function createGate(par, args) {
    if(args.type in gatesMap) {
        var comp = gatesMap[args.type];

        var obj = comp.createObject(par, args);

        if (obj !== null) {
            obj.objectName = 'gate_' + args.type + '_' + gID++;
            // Error Handling
            return obj;
        } else {
            console.log("Error creating component: " + comp.errorString());
        }
    }
    return null;
}
