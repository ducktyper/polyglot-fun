require 'minitest/autorun'
require_relative '002_payroll'

def subject
  @subject ||= Payroll.new
end
def base_hash
  {id: '1', name: "bob", address: "Auckland"}
end
def add_hourly_employee
  subject.add_hourly_employee base_hash.merge(hourly_rate: 10.5)
end
def employee
  Database['1']
end

class TestPayroll < Minitest::Test
  def test_add_hourly_employee
    add_hourly_employee
    check_common_value
    assert_equal 10.5, employee.classification.hourly_rate
    assert_equal Weekly, employee.schedule.class
  end
  def test_add_salaried_employee
    subject.add_salaried_employee base_hash.merge(salary: 10.5)
    check_common_value
    assert_equal 10.5, employee.classification.salary
    assert_equal Monthly, employee.schedule.class
  end
  def test_add_commissioned_employee
    subject.add_commissioned_employee(id: '1', name: "bob", address: "Auckland",
      salary: 45000, commission_rate: 10)
    check_common_value
    assert_equal 45000, employee.classification.salary
    assert_equal 10, employee.classification.commission_rate
    assert_equal Biweekly, employee.schedule.class
  end
  def test_remove_employee
    add_hourly_employee
    subject.delete_employee employee_id: employee.id
    assert_equal nil, employee
  end
  def test_change_employee_name
    add_hourly_employee
    subject.change_employee_name employee_id: employee.id, name: "tom"
    assert_equal "tom", employee.name
  end
  def test_change_employee_address
    add_hourly_employee
    subject.change_employee_address(
      employee_id: employee.id, address: "Wellington")
    assert_equal "Wellington", employee.address
  end
  def test_change_to_hourly_employee
    add_hourly_employee
    subject.change_to_hourly_employee(
      employee_id: employee.id, hourly_rate: 10.5)
    assert_equal 10.5, employee.classification.hourly_rate
    assert_equal Weekly, employee.schedule.class
  end
  def test_change_to_salaried_employee
    add_hourly_employee
    subject.change_to_salaried_employee(
      employee_id: employee.id, salary: 100000)
    assert_equal 100000, employee.classification.salary
    assert_equal Monthly, employee.schedule.class
  end
  def test_change_to_commissioned_employee
    add_hourly_employee
    subject.change_to_commissioned_employee(
      employee_id: employee.id, salary: 45000, commission_rate: 10)
    assert_equal 45000, employee.classification.salary
    assert_equal 10, employee.classification.commission_rate
    assert_equal Biweekly, employee.schedule.class
  end
  def test_change_to_union_member
    add_hourly_employee
    subject.change_to_union_member(employee_id: employee.id, member_id: 2)
    assert_equal 2, employee.affiliation.member_id
  end
  def test_change_to_no_affiliation
    add_hourly_employee
    subject.change_to_union_member(employee_id: employee.id, member_id: 2)
    subject.change_to_no_affiliation(employee_id: employee.id)
    assert_equal NoAffiliation, employee.affiliation.class
  end
  def test_add_timecard
    add_hourly_employee
    timecard = Timecard.new(date: 20150101, hours: 2.5)
    subject.add_timecard employee_id: employee.id, timecard: timecard
    assert_equal timecard, employee.classification.timecards.last
  end
  def test_add_sales_receipt
    subject.add_commissioned_employee(base_hash.merge(
      salary: 45000, commission_rate: 10))
    receipt = SalesReceipt.new(date: 20150101, amount: 100)
    subject.add_sales_receipt employee_id: employee.id, sales_receipt: receipt
    assert_equal receipt, employee.classification.sales_receipts.last
  end
  def test_add_service_charage
    subject.add_hourly_employee(base_hash.merge(
      hourly_rate: 10.5, affiliation: UnionAffiliation.new(2)))
    charge = ServiceCharge.new(date: 20150101, amount: 100)
    subject.add_service_charge(employee_id: employee.id, service_charge: charge)
    assert_equal charge, employee.affiliation.service_charges.last
  end

  private
  def check_common_value
    assert_equal base_hash[:id], employee.id
    assert_equal base_hash[:name], employee.name
    assert_equal base_hash[:address], employee.address
    assert_equal NoAffiliation, employee.affiliation.class
  end
end
