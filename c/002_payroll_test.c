#include <stdio.h>
#include <assert.h>
#include <string.h>
#include "002_payroll.h"

static void assert_string(char *actual, char *expect)
{
  assert(strcmp(actual, expect) == 0);
}
static void assert_basic_employee_fields(Employee *employee)
{
  assert(employee->id == 1);
  assert_string(employee->name, "bob");
  assert_string(employee->address, "Auckland");
}

static void test_add_hourly_employee()
{
  add_hourly_employee(1, "bob", "Auckland", 10.5);
  Employee *emp = get_employee(1);
  assert_basic_employee_fields(emp);
  assert(((HourlyClassification *) emp->classification)->hourly_rate == 10.5);
  assert(emp->schedule == WEEKLY);
}

static void test_add_salaried_employee()
{
  add_salaried_employee(1, "bob", "Auckland", 45000);
  Employee *emp = get_employee(1);
  assert_basic_employee_fields(emp);
  assert(((SalariedClassification *) emp->classification)->salary == 45000);
  assert(emp->schedule == MONTHLY);
}

static void test_add_commissioned_employee()
{
  add_commissioned_employee(1, "bob", "Auckland", 10.5);
  Employee *emp = get_employee(1);
  assert_basic_employee_fields(emp);
  assert(((CommissionedClassification *) emp->classification)->
      commission_rate == 10.5);
  assert(emp->schedule == BIWEEKLY);
}

static void test_get_remove_employee()
{
  add_hourly_employee(1, "bob", "Auckland", 10.5);
  assert(get_employee(1)->id == 1);
  remove_employee(1);
  assert(get_employee(1)->id == 0);
  assert(get_employee(1)->classification == NULL && "free classification");
}

static void test_change_employee_name()
{
  add_hourly_employee(1, "bob", "Auckland", 10.5);
  change_employee_name(1, "new name");
  assert_string(get_employee(1)->name, "new name");
}

static void test_change_employee_address()
{
  add_hourly_employee(1, "bob", "Auckland", 10.5);
  change_employee_address(1, "new address");
  assert_string(get_employee(1)->address, "new address");
}

int main(void)
{
  test_add_hourly_employee();
  test_add_salaried_employee();
  test_add_commissioned_employee();
  test_get_remove_employee();
  test_change_employee_name();
  test_change_employee_address();
}
