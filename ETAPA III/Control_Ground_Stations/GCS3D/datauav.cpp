#include "datauav.h"
#include <QDebug>
#include <QThread>

dataUAV::dataUAV(QObject *parent)
    : QObject{parent}
{

     /*Create a QUDP socket*/
      _socket = new QUdpSocket(this);
  //    _socket->bind(QHostAddress::LocalHost,4500);
      //_socket->bind(QHostAddress::Any,4500);
      //_socket->bind(QHostAddress("192.168.7.2"),4500);
    //  connect(_socket,SIGNAL(readyRead()),this,SLOT(readData()));
}


double dataUAV::latitude()
{
    return _Latitude;
}

double dataUAV::longitude()
{
    return _Longitude;
}

double dataUAV::alture()
{
    return (int16_t)_Alture;
}

double dataUAV::airspeed()
{
    return _AirSpeed;
}

double dataUAV::heading()
{
    return _Heading;
}

double dataUAV::x_accel()
{
    return _X_Accel;
}

double dataUAV::y_accel()
{
    return _Y_Accel;
}

double dataUAV::z_accel()
{
    return _Z_Accel;
}

double dataUAV::p_rate()
{
    return _Pitch_rate;
}

double dataUAV::r_rate()
{
    return _Roll_rate;
}

double dataUAV::y_rate()
{
    return _Yaw_rate;
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
    //_socket->writeDatagram(data,QHostAddress("192.168.7.2"),4500);
    _socket->writeDatagram(data,QHostAddress::LocalHost,4500);
    //_socket->writeDatagram(data,QHostAddress("192.168.15.55"),4500);
    qDebug()<<"Send data";

}

void dataUAV::connectIP(QString addressIP)
{
    const char *dataIP = NULL;

    dataIP = addressIP.toStdString().c_str();

    if(strcmp(dataIP,"localhost") or strcmp(dataIP,"")) {
         _socket->bind(QHostAddress::LocalHost,4500);
    }else{
        _socket->bind(QHostAddress(addressIP),4500);
    }
    _socket->bind(QHostAddress::LocalHost,4500);
    //_socket->bind(QHostAddress::Any,4500);
    //_socket->bind(QHostAddress("192.168.7.2"),4500);
    connect(_socket,SIGNAL(readyRead()),this,SLOT(readData()));
  qDebug()<< addressIP;
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
    _Alture =        list.at(2).toDouble();
    _AirSpeed =      list.at(3).toDouble();
    _Heading =       list.at(4).toDouble();
    _X_Accel =       list.at(5).toDouble();
    _Y_Accel =       list.at(6).toDouble();
    _Z_Accel =       list.at(7).toDouble();
    _Roll_rate =     list.at(8).toDouble();
    _Pitch_rate =    list.at(9).toDouble();
    _Yaw_rate =      list.at(10).toDouble();

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

