#include "datauav.h"
#include <QDebug>
#include <QThread>

dataUAV::dataUAV(QObject *parent)
    : QObject{parent}
    ,_somevar("123")
{

     /*Create a QUDP socket*/
      _socket = new QUdpSocket(this);
      _socket->bind(QHostAddress::LocalHost,5500);
      connect(_socket,SIGNAL(readyRead()),this,SLOT(readData()));
}

void dataUAV::anotherFunction()
{
    qDebug()<<"otra function";
}

QString dataUAV::getSomeVar()
{
   return _somevar;
}

QString dataUAV::someVar()
{
    return _somevar;
}

/*

Send a siganl to autopilot from GUI to connect the
GCS with the autopilot.
this.sendData()

1-> Turn on GUI
2-> Turn on Autopilot

*/

void dataUAV::sendData(){
    QByteArray data;
    data.append("Hello from GCS");
    _socket->writeDatagram(data,QHostAddress::LocalHost,5500);
    qDebug()<<"Send data";

}

void dataUAV::setSomeVar(QString newVar)
{
    if (_somevar != newVar)
    {
        _somevar = newVar;
        emit someVarChanged();
    }
}

void dataUAV::readData(){

    QByteArray buffer;
    buffer.resize(_socket->pendingDatagramSize());

    QHostAddress sender;
    quint16 senderPort;

    _socket->readDatagram(buffer.data(),buffer.size(),&sender,&senderPort);
    qDebug()<< "Mensage from "<< sender.toString();
    qDebug()<<"Message port "<<senderPort;
    qDebug()<<"Mensage: "<< buffer;


}

