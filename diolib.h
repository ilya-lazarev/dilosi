#ifndef DIOLIB_H
#define DIOLIB_H

#include <QObject>
#include <QList>
#include <QString>


class DIOlib : public QObject
{
    Q_OBJECT

public:
    static const QString dataFileName;

    enum class GateType: int
    {
        None = 0, Gate,
        Not, And, Or, Xor
    };

    Q_ENUM(GateType)

    typedef QMap<GateType, QString> GateTypeMap;

    explicit DIOlib(QObject *parent = nullptr);
    explicit DIOlib(const DIOlib &ref) : QObject(ref.parent()) {}
    virtual ~DIOlib() {}

    static void registerToQML();
    static const QString & GateTypeToString(GateType);
    static GateType stringToGateType(const QString &);

    Q_INVOKABLE void writeFile(const QList<QObject *> &);
    Q_INVOKABLE QList<QObject *> loadFile();
signals:

private:
    static GateTypeMap GateType2string;
};

#endif // DIOLIB_H
