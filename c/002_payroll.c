#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "002_payroll.h"

Employee employees[100];

void set_common_employee_fields(
    Employee *employee, int id, char *name, char *address)
{
  employee->id = id;
  strcpy(employee->name, name);
  strcpy(employee->address, address);
}

void add_hourly_employee(int id, char *name, char *address, float hourly_rate)
{
  Employee *employee = get_employee(id);
  set_common_employee_fields(employee, id, name, address);
  HourlyClassification *classification = malloc(sizeof(HourlyClassification));
  classification->hourly_rate = hourly_rate;
  employee->classification = classification;
  employee->schedule = WEEKLY;
}

void add_salaried_employee(int id, char *name, char *address, float salary)
{
  Employee *employee = get_employee(id);
  set_common_employee_fields(employee, id, name, address);
  SalariedClassification *classification = malloc(sizeof(SalariedClassification));
  classification->salary = salary;
  employee->classification = classification;
  employee->schedule = MONTHLY;
}

void add_commissioned_employee(
    int id, char *name, char *address, float commission_rate)
{
  Employee *employee = get_employee(id);
  set_common_employee_fields(employee, id, name, address);
  CommissionedClassification *classification =
    malloc(sizeof(CommissionedClassification));
  classification->commission_rate = commission_rate;
  employee->classification = classification;
  employee->schedule = BIWEEKLY;
}

Employee *get_employee(int id)
{
  return &employees[id - 1];
}
void remove_employee(int id)
{
  employees[id - 1].id = 0;
  free(employees[id - 1].classification);
  employees[id - 1].classification = NULL;
}

void change_employee_name(int id, char *name)
{
  strcpy(get_employee(id)->name, name);
}

void change_employee_address(int id, char *address)
{
  strcpy(get_employee(id)->address, address);
}
