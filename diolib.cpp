#include "diolib.h"
#include <qqml.h>
#include <QDebug>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QFile>

const QString DIOlib::dataFileName("dilosi.json");

DIOlib::GateTypeMap DIOlib::GateType2string = {
    {DIOlib::GateType::Gate, "Gate"},
    {DIOlib::GateType::Not, "Not"},
    {DIOlib::GateType::And, "And"},
    {DIOlib::GateType::Or, "Or"},
    {DIOlib::GateType::Xor, "Xor"}
};

DIOlib::DIOlib(QObject *parent) : QObject(parent)
{

}

void DIOlib::registerToQML()
{
    qmlRegisterUncreatableType<DIOlib>("gates.org", 1, 0, "GateLib", "DIOlib internals");
}

const QString & DIOlib::GateTypeToString(GateType gt)
{
    static QString unknown("?");

    if( GateType2string.contains(gt))
        return GateType2string[gt];
    return unknown;
}

DIOlib::GateType DIOlib::stringToGateType(const QString &st)
{
    for( GateTypeMap::const_iterator i = GateType2string.cbegin(); i != GateType2string.cend(); ++i)
    {
        if(*i == st )
            return i.key();
    }
    return GateType::None;
}

QList<QObject *> DIOlib::loadFile()
{
    QFile of(dataFileName);
    QList<QObject *>  gates;

    return gates;
}

void DIOlib::writeFile(const QList<QObject *> &gates)
{
    qDebug()<<"Write";
    QFile of(dataFileName);
    QJsonObject jo;
    QJsonArray ja;

    foreach (QObject *gate, gates) {
        if( gate ) {
            GateType type = gate->property("type").value<GateType>();
            jo["type"] = GateTypeToString(type);
            jo["not"] = gate->property("not").value<bool>();
            jo["x"] = gate->property("x").value<int>();
            jo["y"] = gate->property("y").value<int>();

            ja.append(jo);
            qDebug()<<gate->objectName()<<':' <<
                gate->property("type").value<int>();
        }
    }
    QJsonDocument doc(ja);
    if(of.open(QFile::WriteOnly))
    {
        of.write(doc.toJson());
    }
}
