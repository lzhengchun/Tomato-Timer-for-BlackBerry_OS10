/*
 * tomato.h
 *
 *  Created on: Apr 15, 2015
 *      Author: liu
 */

#ifndef TOMATO_H_
#define TOMATO_H_
#include <QObject>


class Tomato: public QObject {
    Q_OBJECT

    Q_PROPERTY(QString getTaskName READ getTaskName NOTIFY taskNameChanged)
    Q_PROPERTY(QString getLeftTime READ getLeftTime NOTIFY leftTimeChanged)


public:
    Tomato(QObject* parent = 0);
    virtual ~Tomato();
    void oneSecondEvent();
    void setTaskName(QString tn);
    void setTomatoInterval(int tSeconds);
    void setShortBreakInterval(int tSecond);
    void setLongBreakInterval(int tSecond);
    QString getTaskName() const;
    QString getLeftTime() const;

//signals:
//    void timeLeftChanged();
Q_SIGNALS:
    void taskNameChanged();
    void leftTimeChanged();

private:
    int stages;
    int tomatoIntrv;
    int longBreakIntrv;
    int shortBreakIntrv;
    int timeLeft;
    QString taskName;
};




#endif /* TOMATO_H_ */
