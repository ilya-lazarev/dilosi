#include "diolib.h"
#include <qqml.h>
#include <QDebug>

DIOlib::DIOlib(QObject *parent) : QObject(parent)
{

}

void DIOlib::registerToQML()
{
    qmlRegisterUncreatableType<DIOlib>("gates", 1, 0, "GateType", "DIOlib internals");
}

void DIOlib::writeConfig(QList<QObject *> *gates)
{
    qDebug()<<"Write";
    foreach (auto gate, *gates) {
        if( gate ) {
            qDebug()<<gate->objectName();
        }
    }
}
