class User < ActiveRecord::Base
  
  acts_as_authentic do |c|
    c.login_field = :phone
    c.validate_email_field = false
    c.validate_login_field = false
    c.validates_length_of_password_field_options(:minimum => 6, :if => :require_password?)    
    c.maintain_sessions = false
  end
  
  attr_protected :admin
  attr_accessor :web_registration
    
  validates_presence_of :phone, :full_name, :island_id
  validates_uniqueness_of :phone
  validates_uniqueness_of :email, :allow_nil => true
  validates_length_of :phone, :is => 7  
  # validates_length_of :password, :within => 6..32
  validates_format_of :email, :with => Authlogic::Regex.email, :if => :is_web_registration?
  
  has_many :listings, :dependent => :destroy
  has_many :contacts, :dependent => :destroy
  has_many :associates, :through => :contacts
  
  has_many :inverse_contacts, :class_name => "Contact", :foreign_key => "associate_id"
  has_many :inverse_associates, :through => :inverse_contacts, :source => :user
    
  has_many :recommendations_received, :class_name => "Recommendation", :foreign_key => "user_id"
  has_many :recommendations_given, :class_name => "Recommendation", :foreign_key => "author_id"
  
  belongs_to :island
  
  default_scope :order => 'created_at DESC', :include => {:island => :atoll}
  named_scope :active_users, :conditions => {:active => true}
  named_scope :inactive_users, :conditions => {:active => false}
    
  def location
    "#{island.atoll.abbreviation}. #{island.name}"
  end
  
  def is_web_registration?
    self.web_registration
  end
  
  # Default authlogic authentication and authorization methods
  
  #def self.find_by_login_or_email(login)
  #  find_by_smart_case_login_field(login)
  #end
  
  # Instance methods overridden with business logic
  
  def before_destroy
    if self.listings.empty? 
      true
    else
      errors.add_to_base("A user who has listings cannot be removed.") 
      false
    end
  end
  
  def before_save    
    if self.address
      self.address = self.address.titleize
    end
    
    if self.street
      self.street = self.street.titleize
    end    
    
    if self.full_name
      self.full_name = self.full_name.titleize
    end      
  end
  
  def before_validation
    self.phone = self.phone.gsub(/^(960|\+960)/, "")
  end
  
  # Activation methods
  
  def activate!
    if self.active
      errors.add_to_base("Account is already active.")
      false
    else
      self.active = true
      save!
    end
  end
  
  def deactivate!
    if self.active
      self.active = false
      save!
    else
      errors.add_to_base("Account is already deactivated.")
      false
    end
  end
  
  # Email notifications
  
  def deliver_activation_instructions!
    reset_perishable_token!
    Notifier.deliver_activation_instructions(self)
  end

  def deliver_activation_confirmation!
    reset_perishable_token!
    Notifier.deliver_activation_confirmation(self)
  end  
  
  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.deliver_password_reset_instructions(self)
  end
  
  # Reset password
  
  def reset_password!
    reset_perishable_token!
    password = perishable_token
    password_confirmation = perishable_token
    save!
  end
  
  # Class methods
  
end
