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
    explicit DIOlib(const DIOlib &ref) : QObject(ref.parent()) {}
    virtual ~DIOlib() {}
    static void registerToQML();

    Q_INVOKABLE void writeConfig(const QList<QObject *> &);
signals:

};

#endif // DIOLIB_H
