require 'test_helper'

class NotificationsTest < ActionMailer::TestCase
  test "forgot_password" do
    @expected.subject = 'Notifications#forgot_password'
    @expected.body    = read_fixture('forgot_password')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Notifications.create_forgot_password(@expected.date).encoded
  end

  test "activate" do
    @expected.subject = 'Notifications#activate'
    @expected.body    = read_fixture('activate')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Notifications.create_activate(@expected.date).encoded
  end

end
