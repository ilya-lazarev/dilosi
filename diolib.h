#ifndef DIOLIB_H
#define DIOLIB_H

#include <QObject>
#include <QList>

class DIOlib : public QObject
{
    Q_OBJECT
public:
    enum class GateType: int
    {
        Gate = 0,
        Not, And, Or, Xor
    };
    Q_ENUM(GateType)
    explicit DIOlib(QObject *parent = nullptr);
    explicit DIOlib(DIOlib &ref) : QObject(ref.parent()) {}
    virtual ~DIOlib() {}
    static void registerToQML();
    void writeConfig(QList<QObject *> *);
signals:

};

//Q_DECLARE_METATYPE(DIOlib::GateType)
#endif // DIOLIB_H
