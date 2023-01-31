#ifndef DIOLIB_H
#define DIOLIB_H

#include <QObject>
#include <QList>

class DIOlib : public QObject
{
    Q_OBJECT
public:
    explicit DIOlib(QObject *parent = nullptr);
    void writeConfig(QList<QObject *> *);
signals:

};

#endif // DIOLIB_H
