class Schedule < ActiveRecord::Base

  has_many :discussions
  has_many :lessons
  has_many :schedule_events
  has_many :portfolio
  has_many :assignment

end
