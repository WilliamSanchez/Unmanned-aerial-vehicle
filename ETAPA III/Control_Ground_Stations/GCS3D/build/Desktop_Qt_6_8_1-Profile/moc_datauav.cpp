/****************************************************************************
** Meta object code from reading C++ file 'datauav.h'
**
** Created by: The Qt Meta Object Compiler version 68 (Qt 6.8.1)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../datauav.h"
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'datauav.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 68
#error "This file was generated using the moc from 6.8.1. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

#ifndef Q_CONSTINIT
#define Q_CONSTINIT
#endif

QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
QT_WARNING_DISABLE_GCC("-Wuseless-cast")
namespace {
struct qt_meta_tag_ZN7dataUAVE_t {};
} // unnamed namespace


#ifdef QT_MOC_HAS_STRINGDATA
static constexpr auto qt_meta_stringdata_ZN7dataUAVE = QtMocHelpers::stringData(
    "dataUAV",
    "latitudeChanged",
    "",
    "longitudeChanged",
    "readData",
    "sendData",
    "connectIP",
    "addressIP",
    "latitude",
    "longitude",
    "alture",
    "airspeed",
    "heading",
    "x_accel",
    "y_accel",
    "z_accel",
    "r_rate",
    "y_rate",
    "p_rate"
);
#else  // !QT_MOC_HAS_STRINGDATA
#error "qtmochelpers.h not found or too old."
#endif // !QT_MOC_HAS_STRINGDATA

Q_CONSTINIT static const uint qt_meta_data_ZN7dataUAVE[] = {

 // content:
      12,       // revision
       0,       // classname
       0,    0, // classinfo
       5,   14, // methods
      11,   51, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       2,       // signalCount

 // signals: name, argc, parameters, tag, flags, initial metatype offsets
       1,    0,   44,    2, 0x06,   12 /* Public */,
       3,    0,   45,    2, 0x06,   13 /* Public */,

 // slots: name, argc, parameters, tag, flags, initial metatype offsets
       4,    0,   46,    2, 0x0a,   14 /* Public */,
       5,    0,   47,    2, 0x0a,   15 /* Public */,
       6,    1,   48,    2, 0x0a,   16 /* Public */,

 // signals: parameters
    QMetaType::Void,
    QMetaType::Void,

 // slots: parameters
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void, QMetaType::QString,    7,

 // properties: name, type, flags, notifyId, revision
       8, QMetaType::Double, 0x00015001, uint(0), 0,
       9, QMetaType::Double, 0x00015001, uint(-1), 0,
      10, QMetaType::Double, 0x00015001, uint(-1), 0,
      11, QMetaType::Double, 0x00015001, uint(-1), 0,
      12, QMetaType::Double, 0x00015001, uint(-1), 0,
      13, QMetaType::Double, 0x00015001, uint(-1), 0,
      14, QMetaType::Double, 0x00015001, uint(-1), 0,
      15, QMetaType::Double, 0x00015001, uint(-1), 0,
      16, QMetaType::Double, 0x00015001, uint(-1), 0,
      17, QMetaType::Double, 0x00015001, uint(-1), 0,
      18, QMetaType::Double, 0x00015001, uint(-1), 0,

       0        // eod
};

Q_CONSTINIT const QMetaObject dataUAV::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_meta_stringdata_ZN7dataUAVE.offsetsAndSizes,
    qt_meta_data_ZN7dataUAVE,
    qt_static_metacall,
    nullptr,
    qt_incomplete_metaTypeArray<qt_meta_tag_ZN7dataUAVE_t,
        // property 'latitude'
        QtPrivate::TypeAndForceComplete<double, std::true_type>,
        // property 'longitude'
        QtPrivate::TypeAndForceComplete<double, std::true_type>,
        // property 'alture'
        QtPrivate::TypeAndForceComplete<double, std::true_type>,
        // property 'airspeed'
        QtPrivate::TypeAndForceComplete<double, std::true_type>,
        // property 'heading'
        QtPrivate::TypeAndForceComplete<double, std::true_type>,
        // property 'x_accel'
        QtPrivate::TypeAndForceComplete<double, std::true_type>,
        // property 'y_accel'
        QtPrivate::TypeAndForceComplete<double, std::true_type>,
        // property 'z_accel'
        QtPrivate::TypeAndForceComplete<double, std::true_type>,
        // property 'r_rate'
        QtPrivate::TypeAndForceComplete<double, std::true_type>,
        // property 'y_rate'
        QtPrivate::TypeAndForceComplete<double, std::true_type>,
        // property 'p_rate'
        QtPrivate::TypeAndForceComplete<double, std::true_type>,
        // Q_OBJECT / Q_GADGET
        QtPrivate::TypeAndForceComplete<dataUAV, std::true_type>,
        // method 'latitudeChanged'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'longitudeChanged'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'readData'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'sendData'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'connectIP'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<QString, std::false_type>
    >,
    nullptr
} };

void dataUAV::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<dataUAV *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->latitudeChanged(); break;
        case 1: _t->longitudeChanged(); break;
        case 2: _t->readData(); break;
        case 3: _t->sendData(); break;
        case 4: _t->connectIP((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        default: ;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        {
            using _q_method_type = void (dataUAV::*)();
            if (_q_method_type _q_method = &dataUAV::latitudeChanged; *reinterpret_cast<_q_method_type *>(_a[1]) == _q_method) {
                *result = 0;
                return;
            }
        }
        {
            using _q_method_type = void (dataUAV::*)();
            if (_q_method_type _q_method = &dataUAV::longitudeChanged; *reinterpret_cast<_q_method_type *>(_a[1]) == _q_method) {
                *result = 1;
                return;
            }
        }
    }
    if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< double*>(_v) = _t->latitude(); break;
        case 1: *reinterpret_cast< double*>(_v) = _t->longitude(); break;
        case 2: *reinterpret_cast< double*>(_v) = _t->alture(); break;
        case 3: *reinterpret_cast< double*>(_v) = _t->airspeed(); break;
        case 4: *reinterpret_cast< double*>(_v) = _t->heading(); break;
        case 5: *reinterpret_cast< double*>(_v) = _t->x_accel(); break;
        case 6: *reinterpret_cast< double*>(_v) = _t->y_accel(); break;
        case 7: *reinterpret_cast< double*>(_v) = _t->z_accel(); break;
        case 8: *reinterpret_cast< double*>(_v) = _t->r_rate(); break;
        case 9: *reinterpret_cast< double*>(_v) = _t->y_rate(); break;
        case 10: *reinterpret_cast< double*>(_v) = _t->p_rate(); break;
        default: break;
        }
    }
}

const QMetaObject *dataUAV::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *dataUAV::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_ZN7dataUAVE.stringdata0))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int dataUAV::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 5)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 5;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 5)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 5;
    }
    if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::BindableProperty
            || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 11;
    }
    return _id;
}

// SIGNAL 0
void dataUAV::latitudeChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void dataUAV::longitudeChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}
QT_WARNING_POP
