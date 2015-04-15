require 'set'
require 'ostruct'

class Employee < OpenStruct
  attr_reader :account
  def initialize(*args)
    super(*args)
    @account = 0.0
  end
  def pay
    @account += classification.calculate_pay
  end
end
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
  def add_timecard(employee_id:, date:, hours:)
    timecard = Timecard.new date: date, hours: hours
    Database[employee_id].classification.timecards.push timecard
  end
  def add_sales_receipt(employee_id:, date:, amount:)
    receipt = SalesReceipt.new date: date, amount: amount
    Database[employee_id].classification.sales_receipts.push receipt
  end
  def add_service_charge(employee_id:, date:, amount:)
    charge = ServiceCharge.new date: date, amount: amount
    Database[employee_id].affiliation.service_charges.push charge
  end
  def payday date
    Database.each {|_, v| v.pay if v.schedule.is_payday?(date)}
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
  def calculate_pay
    total_hours = @timecards.map(&:hours).inject(:+)
    @timecards.clear
    total_hours * hourly_rate
  end
end
Timecard = OpenStruct
class Salaried
  attr_reader :salary
  def initialize(salary)
    @salary = salary
  end
  def calculate_pay
  end
end
class Commissioned
  attr_reader :salary, :commission_rate, :sales_receipts
  def initialize(salary, commission_rate)
    @salary = salary
    @commission_rate = commission_rate
    @sales_receipts = []
  end
  def calculate_pay
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

class IntDate
  def initialize(date_int)
    @date_int = date_int
  end
  def time
    @date_int.to_s =~ /^(\d\d\d\d)(\d\d)(\d\d)$/
    Time.utc($1, $2, $3)
  end
end

class Weekly
  def is_payday? date
    IntDate.new(date).time.friday?
  end
end
class Monthly
  def is_payday? date
    (IntDate.new(date).time + 24 * 60 * 60).day == 1
  end
end
class Biweekly
  def is_payday? date
    IntDate.new(date).time.friday? &&
    (IntDate.new(date).time.to_i / (24 * 60 * 60)).odd?
  end
end
