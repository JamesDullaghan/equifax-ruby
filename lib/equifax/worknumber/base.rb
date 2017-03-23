module Equifax
  module Worknumber
    class Base
      def initialize(opts)
        # Get a new client to fetch account # and password
        @client = Equifax::Client.new('')
        @account_number = @client.account_number
        @password = @client.password
        @opts = opts
      end

      private

      attr_reader :client,
                  :opts,
                  :account_number,
                  :password

      # Required Fields
      def self.required_fields
        [
          :vendor_id,
          :first_name,
          :last_name,
          :ssn,
          :lender_case_id,
          :lender_name,
        ]
      end

      # Either is required not both
      def self.either_field_required
        [ [:employer_code, :employer_name] ]
      end

      # Optional Fields
      def self.optional_fields
        [
          :middle_name,
          :employer_address,
          :employer_city,
          :employer_state,
          :employer_postal_code,
          :employer_phone,
          :street_address,
          :city,
          :state,
          :postal_code,
          :borrower_id,
        ]
      end

      self.class_eval do
        self.required_fields.each do |attr|
          define_method(attr) do
            fetch_attribute(attr)
          end
        end

        self.either_field_required.each do |pair|
          pair.each do |attr|
            define_method(attr) do
              # Check for either or
              unless opts[pair[0]] || opts[pair[1]]
                raise ArgumentError, "Provide either #{pair[0]} or #{pair[1]}"
              end

              fetch_attribute(attr, '')
            end
          end
        end

        self.optional_fields.each do |attr|
          define_method(attr) do
            fetch_attribute(attr, '')
          end
        end
      end

      def fetch_attribute(attr, default = nil)
        fallback = if default
          default
        else
          -> { raise ArgumentError, "Provide #{attr}" }
        end

        opts.fetch(attr) { fallback.respond_to?(:call) ? fallback.call : fallback }
      end

      def url
        @url ||= URI(opts.fetch(:url, 'https://emscert.equifax.com/talx/InteractionServlet'))
      end

      def doc
        Ox.parse(xml)
      end

      def request_params
        @request_params ||= Ox.dump(doc, indent: 2)
      end

      def xml
        raise NotImplementedError, 'Define xml in the subclass'
      end
    end
  end
end
