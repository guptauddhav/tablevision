class Notifications < ActionMailer::Base
  

  def password_reset(user)
    subject    'Reset your password : Instructions'
    recipients user.email
    from       'admin@tablevision.com'
    sent_on    Time.now
    content_type "text/html"
    body       :firstname => user.firstname, 
               :lastname => user.lastname,
               :url =>  "http://localhost:3000/user/reset_password/#{user.reset_token}"
  end

  def activate(user)
    subject    'Activate your account - tablevision'
    recipients user.email
    from       'admin@tablevision.com'
    sent_on    Time.now
    content_type "text/html"
    body       :firstname => user.firstname, 
               :lastname => user.lastname,
               :url =>  "http://localhost:3000/user/activate/#{user.activation_id}"
  end

end
