# NOTE: class include this concern must be declare the default
# serializer constant named: DEFAULT_SERIALIZER
module Serializeable
  extend ActiveSupport::Concern

  included do
    scope :latest_id,         -> { maximum(:id) }
    scope :latest_created_at, -> { maximum(:created_at).to_i }
    scope :latest_updated_at, -> { maximum(:updated_at).to_i }
    scope :today,             -> { where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day) }
    scope :ndays_ago,         -> (days){ where(created_at: (days-1).days.ago..Time.zone.now.end_of_day) }

    scope :by_keyword, -> (keyword) {
      if keyword.present?
        keyword = keyword.to_search_string
        where("searchable_text ILIKE ?", "%#{keyword}%") if keyword.to_s.strip.present?
      end
    }

    def iso_created_at
      self.created_at.try(:iso8601)
    end

    def iso_updated_at
      self.created_at.try(:iso8601)
    end

    def iso_date(date_field)
      self.try(date_field).try(:iso8601)
    end

    def cached_key_part
      "#{self.class.name.underscore}_#{self.id}_#{self.updated_at.to_i}"
    end
  end

  #use to serialize json of object with current user options
  #if logic require more than one options please
  #use default serializer init style for best customizable
  def serialize(serializer = nil, options = {})
    serializer ||= self.class::DEFAULT_SERIALIZER
    serializer.new(self, options: options).attributes
  end

  module ClassMethods
    def serialize_items(items, options = {}, serializer = nil)
      serializer ||= self::DEFAULT_SERIALIZER
      items.map{ |item| item.serialize(serializer, options) }
    end
  end

  # cache keys
  def fragment_key(key, current_user = nil)
    CacheManager::View.item_key(key, self, current_user)
  end

  def delete_cached_key(k: nil, u: nil, single: false)
    if single
      key_1 = "#{k}-#{self.id}"
      Rails.cache.delete(key_1)

      key_2 = "#{k}-#{self.id}-#{u.try(:id)}"
      Rails.cache.delete(key_2)
    else
      keys_pattern = "*#{k}-#{self.id}*"
      keys = Rails.cache.data.keys(keys_pattern)
      if keys.is_a?(Array) && keys.any?
        keys.each do |key|
          p "Deleting: #{key}"
          Rails.cache.delete(key)
        end
      end
    end
  end

end
