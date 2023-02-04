#include "dgate.h"
#include <QDebug>

DGate::DGate(QObject *par) :
    QObject(par), x(0), y(0), inputs(2), type(GateType::None), inv(false)
{
    if(type == GateType::Not)
        inputs = 1;
}

DGate::DGate(QObject *par, GateType _tp, int _x, int _y, int _inputs, bool _inv) :
    QObject(par), x(_x), y(_y), inputs(_inputs), type(_tp), inv(_inv)
{
    if(type == GateType::Not)
        inputs = 1;
}

void DGate::setX(int nx)
{
    if( nx != x )
    {
        x = nx;
        emit XChanged(x);
    }
}

void DGate::setY(int ny)
{
    if( ny != y )
    {
        y = ny;
        emit YChanged(y);
    }
}

void DGate::setNot(bool nn)
{
    if( nn != inv )
    {
        inv = nn;
        emit invChanged(inv);
    }
}

void DGate::setInputs(int ni)
{
    if( type == GateType::Not )
    {
        ni = 1;
    }
    if( type != GateType::Not && ni < 2 )
        ni = 2;

    if( ni != inputs )
    {
        inputs = ni;
        emit inputsChanged(ni);
    }
}

void DGate::setType(GateType nt)
{
    if( nt != type )
    {
        type = nt;
        emit typeChanged(nt);
        if(type == GateType::Not)
            setInputs(1);
    }
}
