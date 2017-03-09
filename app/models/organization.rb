class Organization < ApplicationRecord
  belongs_to :category
  belongs_to :city
  has_many :statistics, :dependent => :destroy
  has_many :values, :dependent => :destroy
  has_many :schedules, :dependent => :destroy
  has_many :children, class_name: 'Organization', foreign_key: 'parent_id'
  has_one :address, :dependent => :destroy
  accepts_nested_attributes_for :values
  accepts_nested_attributes_for :schedules, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :address,   :reject_if => :all_blank, :allow_destroy => true
  validates_presence_of :title
  validates_presence_of :schedules, :message => 'У заведения должно быть хотя бы одно расписание'
  validate :check_necessarily
  include SettingsStateMachine

  delegate :latitude, :longitude, :to => :address, :allow_nil => true
  after_initialize :set_initial_status

  def add_statistic(kind = 'show')
    statistics.create(:kind => kind)
  end

  def set_initial_status
    self.state ||= :draft
  end

  def self.states_list
    [:draft, :published, :moderation]
  end

  searchable do
    text    :title
    text    :string_values do
      values.map(&:string_value).compact
    end
    string  :state
  end

  def parent
    Organization.where(:id => parent_id).first
  end

  def user
    User.find_by id: user_id
  end

  def owner?(some_user)
    user == some_user
  end

  def is_child?
    !parent_id.nil?
  end

  def check_necessarily
    values.each do |value|
      errors.add(value.property.title, 'Не может быть пустым') if !value.get.present? && category_property(value.property).necessarily
    end
  end

  def pretty_values
    '{' + values.map {|value| '"'+ value.id.to_s + '":' + value.pretty_view }.join(',') + '}'
  end

  private
  def category_property(property)
    CategoryProperty.where(:category_id => category.id, :property_id => property.id).first
  end
end
