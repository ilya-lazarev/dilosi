#ifndef DGATE_H
#define DGATE_H

#include <QObject>
#include <QMap>

class DGate: public QObject
{
    Q_OBJECT

public:
    enum class GateType: int
    {
        None = 0, Gate,
        Not, And, Or, Xor
    };

    Q_ENUM(GateType)

    Q_PROPERTY(int x READ getX WRITE setX NOTIFY XChanged)
    Q_PROPERTY(int y READ getY WRITE setY NOTIFY YChanged)
    Q_PROPERTY(GateType type READ getType WRITE setType NOTIFY typeChanged)
    Q_PROPERTY(bool inv READ getNot WRITE setNot NOTIFY invChanged)
    Q_PROPERTY(int inputs READ getInputs WRITE setInputs NOTIFY inputsChanged)

public:
    DGate(QObject *par = nullptr);
    DGate(const DGate &d) : QObject(d.parent()),  x(d.x), y(d.y), inputs(d.inputs), type(d.type), inv(d.inv) {}
    DGate(QObject *par, GateType _tp, int _x, int _y, int inputs, bool _inv);
    virtual ~DGate() {}

    int getX() { return x; }
    int getY() { return y; }
    bool getNot() { return inv; }
    GateType getType() { return type; }
    int getInputs() { return inputs; }

public slots:
    void setX(int nx);
    void setY(int ny);
    void setNot(bool nn);
    void setInputs(int ni);
    void setType(GateType nt);

signals:
    void XChanged(int);
    void YChanged(int);
    void invChanged(bool);
    void inputsChanged(int);
    void typeChanged(GateType);

private:
    int x, y, inputs;
    GateType type;
    bool inv;
};

Q_DECLARE_METATYPE(DGate);

#endif // DGATE_H
