typedef enum {WEEKLY, MONTHLY, BIWEEKLY} schedule;
typedef struct employee Employee;

struct hourly_classification
{
  float hourly_rate;
};
typedef struct hourly_classification HourlyClassification;
struct salaried_classification
{
  int salary;
};
typedef struct salaried_classification SalariedClassification;
struct commissioned_classification
{
  float commission_rate;
};
typedef struct commissioned_classification CommissionedClassification;

struct employee
{
  int id;
  char name[50];
  char address[200];
  void *classification;
  schedule schedule;
};

void payroll_init();
void add_hourly_employee(int id, char *name, char *address, float hourly_rate);
void add_salaried_employee(int id, char *name, char *address, float salary);
void add_commissioned_employee(int id, char *name, char *address,
    float commission_rate);
Employee *get_employee(int id);
void remove_employee(int id);
void change_employee_name(int id, char *name);
void change_employee_address(int id, char *name);
