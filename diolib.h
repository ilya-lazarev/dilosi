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
        And, Or, Xor
    };
    Q_ENUM(GateType)
    explicit DIOlib(QObject *parent = nullptr);
    static void registerToQML();
    void writeConfig(QList<QObject *> *);
signals:

};

#endif // DIOLIB_H
