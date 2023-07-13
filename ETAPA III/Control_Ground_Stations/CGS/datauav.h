#ifndef DATAUAV_H
#define DATAUAV_H

#include <QObject>
#include <QUdpSocket>

class dataUAV : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString someVar READ someVar WRITE setSomeVar NOTIFY someVarChanged)

public:
    explicit dataUAV(QObject *parent = nullptr);
    Q_INVOKABLE void anotherFunction();
    Q_INVOKABLE QString getSomeVar();
    QString someVar();

signals:
    void someVarChanged();

public slots:
    void readData();
    void sendData();
    void setSomeVar(QString newVar);

private:
    QUdpSocket *_socket;
    QString _somevar;


};

#endif // DATAUAV_H
