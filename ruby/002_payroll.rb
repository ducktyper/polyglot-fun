require 'set'
require 'ostruct'

Employee = OpenStruct
Database = {}

class Payroll
  def add_hourly_employee(hourly_rate:, **args)
    set_hourly_employee create_employee(args), hourly_rate
  end
  def add_salaried_employee(salary:, **args)
    set_salaried_employee create_employee(args), salary
  end
  def add_commissioned_employee(salary:, commission_rate:, **args)
    set_commissioned_employee create_employee(args), salary, commission_rate
  end
  def delete_employee(employee_id:)
    Database.delete employee_id
  end
  def change_employee_name(employee_id:, name:)
    Database[employee_id].name = name
  end
  def change_employee_address(employee_id:, address:)
    Database[employee_id].address = address
  end
  def change_to_hourly_employee(employee_id:, hourly_rate:)
    set_hourly_employee Database[employee_id], hourly_rate
  end
  def change_to_salaried_employee(employee_id:, salary:)
    set_salaried_employee Database[employee_id], salary
  end
  def change_to_commissioned_employee(employee_id:, salary:, commission_rate:)
    set_commissioned_employee Database[employee_id], salary, commission_rate
  end
  def change_to_union_member(employee_id:, member_id:)
    Database[employee_id].affiliation = UnionAffiliation.new(member_id)
  end
  def change_to_no_affiliation(employee_id:)
    Database[employee_id].affiliation = NoAffiliation.new
  end
  def add_timecard(employee_id:, timecard:)
    Database[employee_id].classification.timecards.push timecard
  end
  def add_sales_receipt(employee_id:, sales_receipt:)
    Database[employee_id].classification.sales_receipts.push sales_receipt
  end
  def add_service_charge(employee_id:, service_charge:)
    Database[employee_id].affiliation.service_charges.push service_charge
  end

  private
  def create_employee(args)
    args[:affiliation]    = NoAffiliation.new unless args[:affiliation]
    args[:payment_method] = MailMethod.new unless args[:payment_method]
    Database[args[:id]] = Employee.new(args)
  end
  def set_hourly_employee(employee, hourly_rate)
    employee.classification = Hourly.new hourly_rate
    employee.schedule = Weekly.new
  end
  def set_salaried_employee(employee, salary)
    employee.classification = Salaried.new salary
    employee.schedule = Monthly.new
  end
  def set_commissioned_employee(employee, salary, commission_rate)
    employee.classification = Commissioned.new salary, commission_rate
    employee.schedule = Biweekly.new
  end
end

class Hourly
  attr_reader :hourly_rate, :timecards
  def initialize(hourly_rate)
    @hourly_rate = hourly_rate
    @timecards = []
  end
end
Timecard = OpenStruct
class Salaried
  attr_reader :salary
  def initialize(salary)
    @salary = salary
  end
end
class Commissioned
  attr_reader :salary, :commission_rate, :sales_receipts
  def initialize(salary, commission_rate)
    @salary = salary
    @commission_rate = commission_rate
    @sales_receipts = []
  end
end
SalesReceipt = OpenStruct

class NoAffiliation
  def service_charges
    []
  end
end
class UnionAffiliation
  attr_reader :member_id, :service_charges
  def initialize(member_id)
    @member_id = member_id
    @service_charges = []
  end
end
ServiceCharge = OpenStruct

DirectMethod = Struct.new(:bank, :account)
class HoldMethod
end
MailMethod = Struct.new(:address)

class Weekly
end
class Monthly
end
class Biweekly
end
