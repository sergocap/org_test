# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170630050657) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "addresses", force: :cascade do |t|
    t.integer  "city_id"
    t.string   "street"
    t.string   "house"
    t.string   "region"
    t.string   "office"
    t.string   "longitude"
    t.string   "latitude"
    t.integer  "organization_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["organization_id"], name: "index_addresses_on_organization_id", using: :btree
  end

  create_table "bootsy_image_galleries", force: :cascade do |t|
    t.string   "bootsy_resource_type"
    t.integer  "bootsy_resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bootsy_images", force: :cascade do |t|
    t.string   "image_file"
    t.integer  "image_gallery_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "breaks", force: :cascade do |t|
    t.time     "from"
    t.time     "to"
    t.integer  "schedule_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["schedule_id"], name: "index_breaks_on_schedule_id", using: :btree
  end

  create_table "categories", force: :cascade do |t|
    t.string   "title"
    t.string   "ancestry"
    t.integer  "ancestry_depth", default: 0
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["ancestry"], name: "index_categories_on_ancestry", using: :btree
  end

  create_table "category_properties", force: :cascade do |t|
    t.integer  "category_id"
    t.integer  "property_id"
    t.integer  "row_order"
    t.boolean  "necessarily",    default: false
    t.boolean  "show_on_public", default: true
    t.string   "show_as",        default: "check_boxes"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.index ["category_id"], name: "index_category_properties_on_category_id", using: :btree
    t.index ["property_id"], name: "index_category_properties_on_property_id", using: :btree
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree
  end

  create_table "gallery_images", force: :cascade do |t|
    t.string   "element_file_name"
    t.string   "element_content_type"
    t.integer  "element_file_size"
    t.datetime "element_updated_at"
    t.string   "description"
    t.integer  "organization_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["organization_id"], name: "index_gallery_images_on_organization_id", using: :btree
  end

  create_table "hierarch_list_items", force: :cascade do |t|
    t.string   "title"
    t.string   "parent_id"
    t.integer  "property_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["property_id"], name: "index_hierarch_list_items_on_property_id", using: :btree
  end

  create_table "list_item_values", force: :cascade do |t|
    t.integer  "heirarch_list_item_id"
    t.integer  "list_item_id"
    t.integer  "value_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["heirarch_list_item_id"], name: "index_list_item_values_on_heirarch_list_item_id", using: :btree
    t.index ["list_item_id"], name: "index_list_item_values_on_list_item_id", using: :btree
    t.index ["value_id"], name: "index_list_item_values_on_value_id", using: :btree
  end

  create_table "list_items", force: :cascade do |t|
    t.string   "title"
    t.integer  "property_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["property_id"], name: "index_list_items_on_property_id", using: :btree
  end

  create_table "organization_managers", force: :cascade do |t|
    t.integer  "organization_id"
    t.uuid     "user_id"
    t.string   "state"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["organization_id"], name: "index_organization_managers_on_organization_id", using: :btree
    t.index ["user_id"], name: "index_organization_managers_on_user_id", using: :btree
  end

  create_table "organization_service_packs", force: :cascade do |t|
    t.integer  "organization_id"
    t.integer  "service_pack_id"
    t.integer  "duration"
    t.float    "price"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["organization_id"], name: "index_organization_service_packs_on_organization_id", using: :btree
    t.index ["service_pack_id"], name: "index_organization_service_packs_on_service_pack_id", using: :btree
  end

  create_table "organizations", force: :cascade do |t|
    t.string   "title"
    t.uuid     "user_id"
    t.integer  "parent_id"
    t.integer  "category_id"
    t.integer  "city_id"
    t.string   "state"
    t.string   "email"
    t.string   "phone"
    t.string   "logotype_file_name"
    t.string   "logotype_content_type"
    t.integer  "logotype_file_size"
    t.datetime "logotype_updated_at"
    t.text     "description"
    t.string   "slug"
    t.index ["category_id"], name: "index_organizations_on_category_id", using: :btree
    t.index ["slug"], name: "index_organizations_on_slug", unique: true, using: :btree
    t.index ["user_id"], name: "index_organizations_on_user_id", using: :btree
  end

  create_table "payments", force: :cascade do |t|
    t.string   "paymentable_type"
    t.integer  "paymentable_id"
    t.integer  "organization_id"
    t.string   "state"
    t.float    "amount"
    t.integer  "duration"
    t.string   "details"
    t.uuid     "user_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["organization_id"], name: "index_payments_on_organization_id", using: :btree
    t.index ["paymentable_type", "paymentable_id"], name: "index_payments_on_paymentable_type_and_paymentable_id", using: :btree
  end

  create_table "permissions", force: :cascade do |t|
    t.string   "user_id"
    t.string   "role"
    t.string   "context_type"
    t.integer  "context_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id", "role", "context_id", "context_type"], name: "by_user_and_role_and_context", using: :btree
  end

  create_table "properties", force: :cascade do |t|
    t.string   "kind"
    t.string   "title"
    t.integer  "category_id"
    t.string   "show_on_filter_as"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "schedules", force: :cascade do |t|
    t.boolean  "monday",          default: false
    t.boolean  "tuesday",         default: false
    t.boolean  "wednesday",       default: false
    t.boolean  "thursday",        default: false
    t.boolean  "friday",          default: false
    t.boolean  "saturday",        default: false
    t.boolean  "sunday",          default: false
    t.boolean  "free",            default: false
    t.string   "comment"
    t.time     "from"
    t.time     "to"
    t.integer  "organization_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["organization_id"], name: "index_schedules_on_organization_id", using: :btree
  end

  create_table "service_packs", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.string   "tag"
    t.float    "price_for_month"
    t.float    "price_for_six_months"
    t.float    "price_for_year"
    t.boolean  "logotype"
    t.boolean  "gallery"
    t.boolean  "description_field"
    t.boolean  "small_comment"
    t.boolean  "price_list"
    t.boolean  "brand"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "statistics", force: :cascade do |t|
    t.integer  "organization_id"
    t.string   "kind"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["organization_id"], name: "index_statistics_on_organization_id", using: :btree
  end

  create_table "values", force: :cascade do |t|
    t.integer  "organization_id"
    t.integer  "property_id"
    t.integer  "list_item_id"
    t.integer  "hierarch_list_item_id"
    t.string   "string_value"
    t.integer  "integer_value"
    t.float    "float_value"
    t.boolean  "boolean_value",              default: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.integer  "root_hierarch_list_item_id"
    t.index ["hierarch_list_item_id"], name: "index_values_on_hierarch_list_item_id", using: :btree
    t.index ["list_item_id"], name: "index_values_on_list_item_id", using: :btree
    t.index ["organization_id"], name: "index_values_on_organization_id", using: :btree
    t.index ["property_id"], name: "index_values_on_property_id", using: :btree
  end

end
