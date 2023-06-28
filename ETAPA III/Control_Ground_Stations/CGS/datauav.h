#ifndef DATAUAV_H
#define DATAUAV_H

#include <QObject>
#include <QUdpSocket>

class dataUAV : public QObject
{
    Q_OBJECT
public:
    explicit dataUAV(QObject *parent = nullptr);
    void sendData();

signals:

public slots:
    void readData();

private:
    QUdpSocket *_socket;

};

#endif // DATAUAV_H
