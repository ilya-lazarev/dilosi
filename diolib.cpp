#include "diolib.h"
#include <qqml.h>
#include <QDebug>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QFile>
#include <QJSEngine>

const QString DIOlib::dataFileName("dilosi.json");

DIOlib::GateTypeMap DIOlib::GateType2string = {
    {DGate::GateType::Gate, "Gate"},
    {DGate::GateType::Not, "Not"},
    {DGate::GateType::And, "And"},
    {DGate::GateType::Or, "Or"},
    {DGate::GateType::Xor, "Xor"}
};

DIOlib::DIOlib(QObject *parent) : QObject(parent)
{

}

void DIOlib::registerToQML()
{
//    qmlRegisterUncreatableType<DIOlib>("gates.org", 1, 0, "GateType", "DIOlib internals");
    qmlRegisterType<DGate>("gates.org", 1, 0, "GateType");
}

const QString & DIOlib::GateTypeToString(DGate::GateType gt)
{
    static QString unknown("?");

    if( GateType2string.contains(gt))
        return GateType2string[gt];
    return unknown;
}

DGate::GateType DIOlib::stringToGateType(const QString &st)
{
    for( GateTypeMap::const_iterator i = GateType2string.cbegin(); i != GateType2string.cend(); ++i)
    {
        if(*i == st )
            return i.key();
    }
    return DGate::GateType::None;
}

QJSValue DIOlib::loadFile()
{
    QFile of(dataFileName);
//    QList<DGate *>  gates;

    QJSEngine *eng = dynamic_cast<QJSEngine *>(engine);
    QJSValue gates = eng->newArray();

    if(of.open(QFile::ReadOnly))
    {
        QJsonDocument doc(QJsonDocument::fromJson(of.readAll()));

        QJsonObject jo;
        int x, y;
        bool inv;
        DGate::GateType type;
        int ii = 0, inputs;

        const QJsonArray ja = doc.array();

        for( QJsonArray::const_iterator i = ja.cbegin(); i != ja.cend(); ++i)
        {
            jo = i->toObject();
            type = stringToGateType(jo["type"].toString());

            x = jo["x"].toInt();
            y = jo["y"].toInt();
            inputs = jo["inputs"].toInt();
            inv = jo["not"].toBool();

            DGate * ng = new DGate(this, type, x, y, inputs, inv);
            gates.setProperty( ii++, eng->newQObject(ng));
        }
    }
    else
        qDebug() << "Error opening...:" << of.errorString();

    return gates;
}

void DIOlib::setEngine(QQmlApplicationEngine &e)
{
    engine = &e;
}

void DIOlib::writeFile(const QList<DGate *> &gates)
{
    QFile of(dataFileName);
    QJsonObject jo;
    QJsonArray ja;

    foreach (DGate *gate, gates) {
        if( gate ) {
            DGate::GateType type = gate->getType();
            jo["type"] = GateTypeToString(type);
            jo["not"] = gate->getNot();
            jo["x"] = gate->getX();
            jo["y"] = gate->getY();
            jo["inputs"] = gate->getInputs();

            ja.append(jo);
        }
    }

    QJsonDocument doc(ja);

    if(of.open(QFile::WriteOnly))
    {
        of.write(doc.toJson());
    }
}
