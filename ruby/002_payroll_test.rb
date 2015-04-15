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
    subject.add_timecard employee_id: employee.id, date: 20150101, hours: 2.5
    assert_equal 20150101, employee.classification.timecards.last.date
    assert_equal 2.5, employee.classification.timecards.last.hours
  end
  def test_add_sales_receipt
    subject.add_commissioned_employee(base_hash.merge(
      salary: 45000, commission_rate: 10))
    subject.add_sales_receipt(
      employee_id: employee.id, date: 20150101, amount: 100)
    assert_equal 20150101, employee.classification.sales_receipts.last.date
    assert_equal 100, employee.classification.sales_receipts.last.amount
  end
  def test_add_service_charage
    subject.add_hourly_employee(base_hash.merge(
      hourly_rate: 10.5, affiliation: UnionAffiliation.new(2)))
    subject.add_service_charge(
      employee_id: employee.id, date: 20150101, amount: 100)
    assert_equal 20150101, employee.affiliation.service_charges.last.date
    assert_equal 100, employee.affiliation.service_charges.last.amount
  end
  def test_weekly_is_payday?
    friday = 20150102
    assert_equal true, Weekly.new.is_payday?(friday)
    assert_equal false, Weekly.new.is_payday?(friday + 1)
  end
  def test_monthly_is_payday?
    last_day_of_month = 20150131
    assert_equal true, Monthly.new.is_payday?(last_day_of_month)
    assert_equal false, Monthly.new.is_payday?(20150201)
  end
  def test_biweekly_is_payday?
    odd_friday = 20150102
    even_friday = 20150108
    assert_equal true, Biweekly.new.is_payday?(odd_friday)
    assert_equal false, Biweekly.new.is_payday?(20150103)
    assert_equal false, Biweekly.new.is_payday?(even_friday)
  end
  def test_payday_for_hourly_employee_at_payday
    add_hourly_employee
    subject.add_timecard(employee_id: employee.id, date: 20150101, hours: 2.5)
    subject.payday(20150102)
    assert_equal 10.5 * 2.5, Database[employee.id].account
  end
  def test_payday_for_hourly_employee_at_payday_clear_timecards
    add_hourly_employee
    subject.add_timecard(employee_id: employee.id, date: 20150101, hours: 2.5)
    subject.payday(20150102)
    assert_equal 0, Database[employee.id].classification.timecards.size
  end
  def test_payday_for_hourly_employee_at_none_payday
    add_hourly_employee
    subject.add_timecard(employee_id: employee.id, date: 20150101, hours: 2.5)
    subject.payday(20150103)
    assert_equal 0, Database[employee.id].account
  end

  private
  def check_common_value
    assert_equal base_hash[:id], employee.id
    assert_equal base_hash[:name], employee.name
    assert_equal base_hash[:address], employee.address
    assert_equal NoAffiliation, employee.affiliation.class
  end
end
