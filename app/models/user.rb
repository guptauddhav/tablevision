require 'digest/sha1'

class User < ActiveRecord::Base
  
  validates_length_of :username, :within => 5..40
  
  validates_length_of :password, :within => 5..40
  
  validates_presence_of :username, :email, :password, :password_confirmation, 
                        :firstname, :lastname
  
  validates_uniqueness_of :username, :email
  
  validates_confirmation_of :password
  
  validates_format_of :email, 
                      :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, 
                      :message => "Invalid email"  
  
  attr_protected :id, :salt
  
  attr_accessor :password, :password_confirmation
  
  before_create :prepare_activation
  
  after_create :send_activate
  
  def self.authenticate(username, pass)
    u = find(:first, :conditions=>["username = ?", username])
    return nil if u.nil?
    return u if User.encrypt(pass, u.salt) == u.hashed_password
  end
  
  def password=(pass)
    @password = pass
    self.salt = User.random_string(10) if !self.salt?
    self.hashed_password = User.encrypt(@password, self.salt)
  end
  
  def send_password_reset_mail
    Notifications.deliver_password_reset(self)
  end
  
  def send_activate
    Notifications.deliver_activate(self)
  end
  
  def activate!
    self.active = true
    self.created_at = Time.now.utc
    self.activation_id = nil
    save(false)
  end
  
  def make_reset_token
    self.reset_token = self.class.make_token
  end
  
  def clear_reset_token
    self.reset_token = nil
  end
  
  protected
  
  def prepare_activation
    self.activation_id = self.class.make_token
    self.created_at ||= Time.now
  end
  
  private 
  
  def self.random_string(len)
    #generat a random password consisting of strings and digits
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end
  
  def self.encrypt(pass, salt)
    Digest::SHA1.hexdigest(pass+salt)
  end
  
  def self.secure_digest(*args)
    Digest::SHA1.hexdigest(args.flatten.join('--'))
  end
  
  def self.make_token
    secure_digest(Time.now, (1..10).map{ rand.to_s })
  end
  
end
