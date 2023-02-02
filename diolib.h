#ifndef DIOLIB_H
#define DIOLIB_H

#include <QObject>
#include <QList>
#include <QString>
#include <QJSValue>
#include <QQmlApplicationEngine>

#include "dgate.h"

class DIOlib : public QObject
{
    Q_OBJECT
    typedef QMap<DGate::GateType, QString> GateTypeMap;

public:
    static const QString dataFileName;


    explicit DIOlib(QObject *parent = nullptr);
    explicit DIOlib(const DIOlib &ref) : QObject(ref.parent()) {}
    virtual ~DIOlib() {}

    static void registerToQML();
    static const QString & GateTypeToString(DGate::GateType);
    static DGate::GateType stringToGateType(const QString &);

    Q_INVOKABLE void writeFile(const QList<DGate *> &);
    Q_INVOKABLE QJSValue loadFile();
    void setEngine(QQmlApplicationEngine &);
signals:

private:
    static GateTypeMap GateType2string;
    QQmlApplicationEngine *engine;
};

#endif // DIOLIB_H
