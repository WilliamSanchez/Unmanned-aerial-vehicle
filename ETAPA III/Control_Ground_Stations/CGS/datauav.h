#ifndef DATAUAV_H
#define DATAUAV_H

#include <QObject>
#include <QUdpSocket>

class dataUAV : public QObject
{
    Q_OBJECT
    Q_PROPERTY(double latitude READ latitude NOTIFY latitudeChanged)
    Q_PROPERTY(double longitude READ longitude NOTIFY longitudeChanged)

public:
    explicit dataUAV(QObject *parent = nullptr);
    double latitude();
    double longitude();

signals:
    void latitudeChanged();
    void longitudeChanged();

public slots:
    void readData();
    void sendData();

private:
    QUdpSocket *_socket;

    double _Latitude;
    double _Longitude;
    qfloat16 _Alture;
    qfloat16 _AirSpeed;
    qfloat16 _Heading;
    qfloat16 _X_Accel;
    qfloat16 _Y_Accel;
    qfloat16 _Z_Accel;
    qfloat16 _Roll_rate;
    qfloat16 _Pitch_rate;
    qfloat16 _Yaw_rate;
};

#endif // DATAUAV_H
