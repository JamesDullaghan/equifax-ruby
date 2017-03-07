module Equifax
  module Worknumber
    module VOE
      class Instant
        def initialize(opts)
          # Get a new client to fetch account # and password
          @client = Equifax::Client.new('')
          @account_number = @client.account_number
          @password = @client.password
          @opts = opts
        end

        def self.call(opts)
          voe = Equifax::WorknumberVOE.new(opts)

          Equifax::Client.request(
            voe.send(:url),
            { request_method: :post },
            voe.send(:request_params),
          )
        end

        private

        attr_reader :client,
                    :opts,
                    :account_number,
                    :password

        # Required Fields
        [
          :first_name,
          :last_name,
          :ssn,
          :street_address,
          :city,
          :state,
          :postal_code,
          :residency_type,
          :report_type,
          :report_description,
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

        # Not Required
        [
          :middle_name,
          :employer_address,
          :employer_city,
          :employer_state,
          :employer_postal_code
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

        def request_params
          xml = <<-eos
            <?xml version="1.0" encoding="utf-8"?>
            <REQUEST_GROUP MISMOVersionID="2.3.1">
              <SUBMITTING_PARTY _Name="VENDORID">
                <PREFERRED_RESPONSE _Format="PDF"></PREFERRED_RESPONSE> </SUBMITTING_PARTY>
              <REQUEST InternalAccountIdentifier="#{account_number}"
                LoginAccountIdentifier="#{account_number}" LoginAccountPassword="#{password}">
                <KEY _Name="EMSEmployerCode" _Value="#{employer_code}" />
                <REQUEST_DATA>
                  <VOI_REQUEST LenderCaseIdentifier="#{lender_case_id}"
                    RequestingPartyRequestedByName="EMS, UFT TOOL">
                    <VOI_REQUEST_DATA VOIReportType="Other"
                      VOIReportTypeOtherDescription="VOE" VOIRequestType="Individual"
                      VOIReportRequestActionType="Submit" BorrowerID="Borrower" />
                    <LOAN_APPLICATION>
                      <BORROWER BorrowerID="Borrower" _FirstName="#{first_name}"
                        _MiddleName="#{middle_name}" _LastName="#{last_name}" _PrintPositionType="Borrower"
                        _SSN="#{ssn}">
                        <_RESIDENCE _StreetAddress="#{street_address}" _City="#{city}"
                                                _State="#{state}" _PostalCode="#{postal_code}" BorrowerResidencyType="#{residency_type}" />
                        <EMPLOYER _Name="#{employer_name}" _StreetAddress="#{employer_address}"
                          _City="#{employer_city}" _State="#{employer_state}" _PostalCode="#{employer_postal_code}" />
                      </BORROWER>
                    </LOAN_APPLICATION>
                  </VOI_REQUEST>
                </REQUEST_DATA>
              </REQUEST>
            </REQUEST_GROUP>
          eos

          @request_params ||= Nokogiri::XML(xml).to_xml
        end
      end
    end
  end
end
