/*
 * tomato.cpp
 *
 *  Created on: Apr 15, 2015
 *      Author: liu
 */
#include "tomato.h"
#include <cmath>
#include <iostream>
using namespace std;

Tomato::Tomato(QObject* parent) :
        QObject(parent)
{
    taskName = "Hello";
    std::cout << "Tomato was created" << std::endl;
    timeLeft = 25 * 60 - 5;
}

Tomato::~Tomato() {
    std::cout << "Tomato was deleted" << std::endl;
}

void Tomato::oneSecondEvent(){
    timeLeft = timeLeft - 1;
    //emit timeLeftChanged();
}
void Tomato::setTaskName(QString tn){
    taskName = tn;
    emit taskNameChanged();
}

void Tomato::setTomatoInterval(int tSeconds){
    tomatoIntrv = tSeconds;
}
void Tomato::setShortBreakInterval(int tSecond){
    shortBreakIntrv = tSecond;

}
void Tomato::setLongBreakInterval(int tSecond){
    longBreakIntrv = tSecond;
}

QString Tomato::getTaskName() const
{
    return taskName;
}

QString Tomato::getLeftTime() const
{
    QString res = QString::number(int(timeLeft/60)) + " : " + QString::number(int(timeLeft%60));
    return res;
}
