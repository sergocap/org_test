class Organization < ApplicationRecord
  belongs_to :category
  has_many :statistics, :dependent => :destroy
  has_many :values, :dependent => :destroy
  has_many :schedules, :dependent => :destroy
  has_many :children, class_name: 'Organization', foreign_key: 'parent_id'
  has_many :organization_managers,  :dependent => :destroy
  has_many :organization_service_packs,  :dependent => :destroy
  has_many :service_packs, :through => :organization_service_packs
  has_many :gallery_images, :dependent => :destroy
  has_one :address, :dependent => :destroy
  accepts_nested_attributes_for :values
  accepts_nested_attributes_for :schedules, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :gallery_images, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :address,   :reject_if => :all_blank, :allow_destroy => true
  validates_presence_of :title
  validates_presence_of :category, :message => 'Укажите категорию'
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: 'Неверный email'
  validates_presence_of :schedules, :message => 'У заведения должно быть хотя бы одно расписание'
  validate :check_necessarily
  has_attached_file :logotype, styles: { medium: "300x300>", thumb: "100x100>"  }, default_url: "/images/missing.jpg"
  validates_attachment_content_type :logotype, content_type: /\Aimage\/.*\z/

  after_save     :create_redis_record
  before_destroy :destroy_redis_record

  include SettingsStateMachine
  include Bootsy::Container

  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]

  delegate :latitude, :longitude, :to => :address, :allow_nil => true
  after_initialize :set_initial_status

  def can_service?(service)
    permit_services.include? service
  end

  def permitted_logotype_url
    can_service?(:logotype) ? logotype.url : '/images/missing.jpg'
  end

  def permit_services
    service_packs.map {|pack| pack.has_services }.flatten.uniq
  end

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

  def city
    MainCities.instance.find_by :id, city_id
  end

  def managers
    organization_managers.map(&:manager)
  end

  def owner?(some_user)
    user == some_user
  end

  def manager?(user)
    managers.include? user
  end

  def is_child?
    !parent_id.nil?
  end

  def check_necessarily
    sort_values.each do |value|
      errors.add(value.property.title, 'Не может быть пустым') if value.get == 'не указано' &&
        category_properties.find {|cp| cp.property_id == value.property_id }.necessarily
    end
  end

  def pretty_values
    '{' + values.map {|value| '"'+ value.id.to_s + '":' + value.pretty_view }.join(',') + '}'
  end

  # валидные значения
  def sort_values
    category_properties.map {|cp| values.find { |value| value.property_id == cp.property_id } }
  end

  def fast_dynamic_fields
    begin
      @fast_dynamic_fields = $redis.get("organization_dynamic_fields:#{id}")
      raise 'no dynamic fields in redis' if @fast_dynamic_fields.blank?
    rescue
      fast_dynamic_fields_record
      retry
    end
    JSON.parse @fast_dynamic_fields
  end

  def create_redis_record
    fast_dynamic_fields_record

    if user.present?
      datas_for_user = {
        id => {
          title:          title,
          url:            "#{Settings['app.host']}/#{city.slug}/organizations/#{slug}",
          main_photo_url: "#{Settings['app.host']}#{logotype.url(:thumb)}",
          state: I18n.t("state.#{state}")
        }.to_json
      }

      RedisUserConnector.set("#{user.id}:organizations", datas_for_user.to_a.flatten) if user
    end

    if address.present? && self.published?
      datas_for_autocomplete_place = {
        'title'          =>    title,
        'url'            =>    "#{Settings['app.host']}/#{city.slug}/organizations/#{slug}",
        'main_photo_url' =>    "#{Settings['app.host']}#{logotype.url(:thumb)}",
        'longitude'      =>    address.longitude,
        'latitude'       =>    address.latitude
      }

      $redis.hmset("organization:#{id}", *datas_for_autocomplete_place.to_a.flatten)
    end
  end

  private
  def fast_dynamic_fields_record
    dynamic_fields = sort_values.inject({}) {|h,v| h[v.property.title] = v.get; h}
    $redis.set("organization_dynamic_fields:#{id}", dynamic_fields.to_json)
  end

  def destroy_redis_record
    RedisUserConnector.clean("#{user.id}:organizations", id) if user
    $redis.del("organization:#{id}")
    $redis.del("organization_dynamic_fields:#{id}")
  end

  def category_properties
    return CategoryProperty.none unless category.present?
    CategoryProperty.where(category_id: category.id,
                           property_id: values.pluck(:property_id),
                           show_on_public: true).sort_by(&:row_order)
  end
end
