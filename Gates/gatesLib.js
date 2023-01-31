var andC, orC, xorC;
var gID = 0;

function preload() {
    andC = Qt.createComponent("GAnd.qml");
    orC = Qt.createComponent("GOr.qml");
    xorC = Qt.createComponent("GXor.qml");
}

function createObj(comp, par, args) {
    var obj = comp.createObject(par, args);
    obj.objectName = 'gate_' + obj.type + gID++;
    if (obj === null) {
        // Error Handling
        console.log("Error creating component: ", comp.errorString());
    }
    return obj;
}


function createGandObject(par, args) {
    return createObj(andC, par, args);
}

function createGorObject(par, args) {
    return createObj(orC, par, args);
}

function createGxorObject(par, args) {
    return createObj(xorC, par, args);
}
