#ifndef DATAUAV_H
#define DATAUAV_H

#include <QObject>
#include <QUdpSocket>

class dataUAV : public QObject
{
    Q_OBJECT
    Q_PROPERTY(double latitude READ latitude NOTIFY latitudeChanged)
    Q_PROPERTY(double longitude READ longitude)
    Q_PROPERTY(double alture READ alture)
    Q_PROPERTY(double airspeed READ airspeed)
    Q_PROPERTY(double heading READ heading)
    Q_PROPERTY(double x_accel READ x_accel)
    Q_PROPERTY(double y_accel READ y_accel)
    Q_PROPERTY(double z_accel READ z_accel)
    Q_PROPERTY(double r_rate READ r_rate)
    Q_PROPERTY(double y_rate READ y_rate)
    Q_PROPERTY(double p_rate READ p_rate)



public:
    explicit dataUAV(QObject *parent = nullptr);
    double latitude();
    double longitude();
    double alture();
    double airspeed();
    double heading();
    double x_accel();
    double y_accel();
    double z_accel();
    double r_rate();
    double p_rate();
    double y_rate();


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
    double _Alture;
    double _AirSpeed;
    double _Heading;
    double _X_Accel;
    double _Y_Accel;
    double _Z_Accel;
    double _Roll_rate;
    double _Pitch_rate;
    double _Yaw_rate;
};

#endif // DATAUAV_H
