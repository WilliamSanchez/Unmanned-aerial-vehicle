#include "datauav.h"
#include <QDebug>
#include <QThread>

dataUAV::dataUAV(QObject *parent)
    : QObject{parent}
{

     /*Create a QUDP socket*/
      _socket = new QUdpSocket(this);
      _socket->bind(QHostAddress::LocalHost,4500);
      connect(_socket,SIGNAL(readyRead()),this,SLOT(readData()));
}


double dataUAV::latitude()
{
    return _Latitude;
}

double dataUAV::longitude()
{
   return _Longitude;
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
    _socket->writeDatagram(data,QHostAddress::LocalHost,4500);
    qDebug()<<"Send data";

}

void dataUAV::readData(){

    QByteArray buffer;
    buffer.resize(_socket->pendingDatagramSize());

    QHostAddress sender;
    quint16 senderPort;

    _socket->readDatagram(buffer.data(),buffer.size(),&sender,&senderPort);

    QList list = buffer.split('\n');

    _Latitude =      list.at(0).toDouble();
    _Longitude =     list.at(1).toDouble();
    //_Alture =        list.at(2);
    //_AirSpeed =      list.at(3);
    //_Heading =       list.at(4);
    //_X_Accel =       list.at(5);
    //_Y_Accel =       list.at(6);
    //_Z_Accel =       list.at(7);
    //_Roll_rate =     list.at(8);
    //_Pitch_rate =    list.at(9);
    //_Yaw_rate =      list.at(10);

    qDebug()<<"Mensage from "<< sender.toString();
    qDebug()<<"Message port "<<senderPort;
    qDebug()<<"Latitude: "<< list.at(0);
    qDebug()<<"Longitude: "<< list.at(1);
    qDebug()<<"Alture: "<< list.at(2);
    qDebug()<<"AirSpeed: "<< list.at(3);
    qDebug()<<"Heading: "<< list.at(4);
    qDebug()<<"X_Accel: "<< list.at(5);
    qDebug()<<"Y_Accel: "<< list.at(6);
    qDebug()<<"Z_Accel: "<< list.at(7);
    qDebug()<<"Roll_rate: "<< list.at(8);
    qDebug()<<"Pitch_rate: "<< list.at(9);
    qDebug()<<"Yaw_rate: "<< list.at(10);

    emit latitudeChanged();
    emit longitudeChanged();
}

