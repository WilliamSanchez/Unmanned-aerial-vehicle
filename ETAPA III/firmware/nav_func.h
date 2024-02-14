#ifndef _NAV_FUNC_H_
#define _NAV_FUNC_H_

#include <matrices.h>

//#define PI 3.14159265358979	

#define zeros		0
#define ones 		1
#define identity	2
#define undefined	3

Matrix euler2DCM(double *euler, Matrix DCM);
Matrix quat2DCM(double *quat, Matrix DCM);
Matrix DCM_Angular(double *gyro, Matrix qDCM);
double DCM2quat(Matrix DCM, double *quat);
double euler2quat(double *euler, double *quat);
double quat2euler(double *quat, double *euler);

double rungeKutta(Matrix DCM, double *gyro, double *quat, double delta, double *newquat);


#endif
