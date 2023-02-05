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
            return obj;
        } else {
            // Error Handling
            console.log("Error creating component: " + comp.errorString());
        }
    }
    return null;
}

// p1 <= p <= p2
function between(p, p1, p2) {
    return p1 <= p && p <= p2;
}

// all point of inner rect is inside outer rect
function rectContains(outer, inner) {
    var right = outer.x + outer.width,
        bottom = outer.y + outer.height

    return between(inner.x, outer.x, right) && between(inner.y, outer.y, bottom) &&
            between(inner.x + inner.width, outer.x, right) &&
            between(inner.y + inner.height, outer.y, bottom)
}

// any point of inner rect is inside outer rect
function rectIntersects(outer, inner) {
    var right = outer.x + outer.width,
        bottom = outer.y + outer.height

    if( between(inner.x, outer.x, right) && between(inner.y, outer.y, bottom) ) return true;
    if( between(inner.x + inner.width, outer.x, right) && between(inner.y, outer.y, bottom) ) return true;
    if( between(inner.x, outer.x, right) && between(inner.y + inner.height, outer.y, bottom) ) return true;
    return between(inner.x + inner.width, outer.x, right) && between(inner.y + inner.height, outer.y, bottom);
}
