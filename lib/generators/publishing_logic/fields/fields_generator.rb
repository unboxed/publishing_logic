module PublishingLogic
  module Generators
    class FieldsGenerator < Rails::Generators::NamedBase

      include Rails::Generators::Migration

      source_root File.expand_path('../templates', __FILE__)

      class_option :published_until_field,  type: :boolean, default: true,    desc: "Specify if the generator should create a published_until field"
      class_option :admin_form,             type: :boolean, default: true,    desc: "Specify if the generator should create an admin form"
      class_option :admin_namespace,        type: :string,  default: 'admin', desc: "Specify the namespace for the admin publishing_fields view partial"
      class_option :shared_template,        type: :boolean, default: false,   desc: "(For multiple Publishable models) Specify if the admin publishing_fields view partial should go into the shared directory"


      def create_migration_file
        raise_if_class_does_not_exists
        migration_template  'db/migrate/add_publishing_logic_fields.rb.erb',
                            "db/migrate/#{migration_file_name}.rb"
      end

      def create_view_file
        raise_if_class_does_not_exists
        if options[:admin_form]
          template  'app/views/publishing_logic_fields.html.erb',
                    "app/views/#{admin_namespace}#{template_dir}/_publishing_logic_fields.html.erb"

          puts completed_message
        end
      end

      protected
      def raise_if_class_does_not_exists
        class_name.classify.constantize
      end

      def migration_file_name
        "add_publishing_logic_fields_to_#{file_path.gsub(/\//, '_').pluralize}"
      end

      def migration_name
        "AddPublishingLogicFieldsTo#{class_name.pluralize.gsub(/::/, '')}"
      end

      def admin_namespace
        options[:admin_namespace].blank? ? '/' : "#{options[:admin_namespace]}/"
      end

      def template_dir
        options[:shared_template] ? 'shared' : table_name
      end

      def self.next_migration_number(path)
        unless @prev_migration_nr
          @prev_migration_nr = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
        else
          @prev_migration_nr += 1
        end
        @prev_migration_nr.to_s
      end

      def completed_message
        "\n      ===============================================================\n\n" +
        "      You will need to add the following line to your #{class_name} form view:\n\n" +
        "          <%= render: '#{template_dir + '/' if options[:shared_templte]}publishing_logic_fields' form: form %>\n\n" +
        "      and the following to your #{class_name} model:\n\n" +
        "          include PublishingLogic::ModelLogic\n\n" +
        "      and run your migrations:\n\n" +
        "          bundle exec rake db:migrate\n\n\n"
      end
    end
  end
end
