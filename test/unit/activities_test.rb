require 'test_helper'

class ActivitiesTest < ActiveSupport::TestCase
  def test_bill_activities
    #created
    activities = Activities.get_all_by_bill(bills(:food))
    assert_equal 1, activities.length
    assert_equal %w{created}, get_verbs(activities)


    #accepted
    activities = Activities.get_all_by_bill(bills(:book))
    assert_equal 2, activities.length
    assert_equal %w{created accepted}, get_verbs(activities)


    #closed
    activities = Activities.get_all_by_bill(bills(:server))
    assert_equal 3, activities.length
    assert_equal %w{created accepted closed}, get_verbs(activities)
  end

  def test_transfer_activities
    #created
    activities = Activities.get_all_by_transfer(transfers(:one))
    assert_equal 1, activities.length
    assert_equal %w{created}, get_verbs(activities)

    #verified
    activities = Activities.get_all_by_transfer(transfers(:three))
    assert_equal 2, activities.length
    assert_equal %w{created verified}, get_verbs(activities)
  end

  def test_user_activitites
    #quentin
    activities = Activities.get_all_by_user(users(:quentin))
    assert_equal 4, activities.length
    assert_equal %w{created created accepted accepted}, get_verbs(activities)
    assert_equal %w{Transfer Transfer Bill Bill}, get_classes(activities)

    #aaron
    activities = Activities.get_all_by_user(users(:aaron))
    assert_equal 6, activities.length
    assert_equal %w{created verified created created created closed}, get_verbs(activities)
    assert_equal %w{Transfer Transfer Bill Bill Bill Bill}, get_classes(activities)

    #sam
    activities = Activities.get_all_by_user(users(:sam))
    assert_equal 3, activities.length
    assert_equal %w{created created accepted}, get_verbs(activities)
    assert_equal %w{Bill Bill Bill}, get_classes(activities)
  end


  private
  def get_verbs(activities)
    verbs = Array.new
    activities.each {|a| verbs << a.verb}
    verbs
  end

  def get_classes(activities)
    classes = Array.new
    activities.each {|a| classes << a.object.class.name}
    classes
  end
end
