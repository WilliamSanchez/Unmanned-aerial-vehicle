#include "datauav.h"
#include <QDebug>

dataUAV::dataUAV(QObject *parent)
    : QObject{parent}
{

     /*Create a QUDP socket*/
      _socket = new QUdpSocket(this);
 //   _socket->bind(QHostAddress::LocalHost,5500);
      _socket->bind(QHostAddress::LocalHost,4500);

      connect(_socket,SIGNAL(readyRead()),this,SLOT(readData()));

}

void dataUAV::sendData(){

    QByteArray data;
    data.append("Hello from GCS");
    _socket->writeDatagram(data,QHostAddress::LocalHost,5501);

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
