#include "diolib.h"
#include <QDebug>

DIOlib::DIOlib(QObject *parent) : QObject(parent)
{

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
