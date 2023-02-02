#include "diolib.h"
#include <qqml.h>
#include <QDebug>

DIOlib::DIOlib(QObject *parent) : QObject(parent)
{

}

void DIOlib::registerToQML()
{
    qmlRegisterUncreatableType<DIOlib>("gates.org", 1, 0, "GateLib", "DIOlib internals");
}

void DIOlib::writeConfig(const QList<QObject *> &gates)
{
    qDebug()<<"Write";
    foreach (QObject *gate, gates) {
        if( gate ) {
            qDebug()<<gate->objectName()<<':' <<
                gate->property("type").value<int>();
        }
    }
}
