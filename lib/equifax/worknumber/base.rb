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
      [
        :vendor_id,
        :first_name,
        :last_name,
        :ssn,
        :lender_case_id
      ].each do |attr|
        define_method(attr) do
          fetch_attribute(attr)
        end
      end

      # Either is required, not both
      [
        :employer_code,
        :employer_name
      ].each do |attr|
        define_method(attr) do
          unless opts[:employer_code] || opts[:employer_name]
            raise ArgumentError, 'Provide either <EMPLOYER Name /> or <EMSEmployerCode _Value />'
          end

          fetch_attribute(attr, '')
        end
      end

      # Optional Fields
      [
        :middle_name,
        :employer_address,
        :employer_city,
        :employer_state,
        :employer_postal_code
        :street_address,
        :city,
        :state,
        :postal_code,
      ].each do |attr|
        define_method(attr) do
          fetch_attribute(attr, '')
        end
      end

      def fetch_attribute(attr, default = nil)
        camelized_attr = attr.to_s.split('_').collect(&:capitalize).join

        fallback = if default
          default
        else
          -> { raise ArgumentError, "Provide _#{camelized_attr}" }
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
