module PublishingLogic
  module ModelLogic

    def self.included(base)
      module_to_include = if base.column_names.include?('published_until')
                            WithPublishedUntilField
                          else
                            WithoutPublishedUntilField
                          end
      base.class_eval do
        # If objects have identical published_at values, order by created_at. If these are
        # identical as well, then order by id. This is done to ensure there is a unique
        # ordering of objects, ordering by newest and oldest should result in arrays that are
        # the inverse of the other.
        scope :by_publication_date_oldest_first, lambda {
          order("#{base.table_name}.published_at ASC, #{base.table_name}.created_at ASC, #{base.table_name}.id ASC")
        }

        scope :by_publication_date_newest_first, lambda {
          order("#{base.table_name}.published_at DESC, #{base.table_name}.created_at DESC, #{base.table_name}.id DESC")
        }

        include module_to_include
      end
    end

    module WithoutPublishedUntilField
      def self.included(base)
        base.class_eval do
          scope :published, lambda {
            where("#{base.table_name}.publishing_enabled = ? AND \
                  (#{base.table_name}.published_at IS NULL or #{base.table_name}.published_at < ?)",
                  true, Time.now.utc) } do
            def newest
              find(:first, :order => "#{table_name}.published_at DESC")
            end

            def oldest
              find(:last, :order => "#{table_name}.published_at DESC")
            end
          end

          def published?
            return false if published_at && Time.now < published_at
            publishing_enabled?
          end
        end
      end
    end

    module WithPublishedUntilField
      def self.included(base)
        base.class_eval do
          scope :published, lambda { where("#{base.table_name}.publishing_enabled = ? AND \
                                            (#{base.table_name}.published_until IS NULL or #{base.table_name}.published_until > ?) AND \
                                            (#{base.table_name}.published_at IS NULL or #{base.table_name}.published_at < ?)",
                                            true, Time.now.utc, Time.now.utc) } do
            def newest
              find(:first, :order => "#{table_name}.published_at DESC")
            end

            def oldest
              find(:last, :order => "#{table_name}.published_at DESC")
            end
          end

          def published?
            return false if published_at && Time.now < published_at
            return false if published_until && Time.now > published_until
            publishing_enabled?
          end
        end
      end
    end
  end
end
