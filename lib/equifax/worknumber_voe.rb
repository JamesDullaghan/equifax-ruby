require 'pry'

module Equifax
  class WorknumberVOE
    def initialize(opts)
      # Get a new client to fetch account # and password
      @client = Equifax::Client.new('')
      @account_number = @client.account_number
      @password = @client.password
      @opts = opts
    end

    def self.post(opts)
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

    [
      :first_name,
      :last_name,
      :ssn,
      :street_address,
      :city,
      :state,
      :postal_code,
      :residency_type,
    ].each do |attr|
      define_method(attr) do
        fetch_attribute(attr)
      end
    end

    def middle_name
      fetch_attribute(:middle_name, '')
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
      @url ||= URI('https://emscert.equifax.com/talx/InteractionServlet')
    end

    def request_params
      xml = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<REQUEST_GROUP MISMOVersionID=\"2.3.1\">\n\t<SUBMITTING_PARTY _Name=\"VENDORID\">\n\t\t<PREFERRED_RESPONSE _Format=\"PDF\"></PREFERRED_RESPONSE> </SUBMITTING_PARTY>\n\t<REQUEST InternalAccountIdentifier=\"999MF02317\"\n\t\tLoginAccountIdentifier=\"#{account_number}\" LoginAccountPassword=\"#{password}\">\n\t\t<KEY _Name=\"EMSEmployerCode\" _Value=\"91001\" /> \n\t\t<REQUEST_DATA>\n\t\t\t<VOI_REQUEST LenderCaseIdentifier=\"LOANNUMBER4\"\n\t\t\t\tRequestingPartyRequestedByName=\"EMS, UFT TOOL\">\n\t\t\t\t<VOI_REQUEST_DATA VOIReportType=\"Other\"\n\t\t\t\t\tVOIReportTypeOtherDescription=\"VOE\" VOIRequestType=\"Individual\"\n\t\t\t\t\tVOIReportRequestActionType=\"Submit\" BorrowerID=\"Borrower\" />\n\t\t\t\t<LOAN_APPLICATION>\n\t\t\t\t\t<BORROWER BorrowerID=\"Borrower\" _FirstName=\"#{first_name}\"\n\t\t\t\t\t\t_MiddleName=\"#{middle_name}\" _LastName=\"#{last_name}\" _PrintPositionType=\"Borrower\"\n\t\t\t\t\t\t_SSN=\"#{ssn}\">\n\t\t\t\t\t\t<_RESIDENCE _StreetAddress=\"#{street_address}\" _City=\"#{city}\"\n                                    _State=\"#{state}\" _PostalCode=\"#{postal_code}\" BorrowerResidencyType=\"#{residency_type}\" />\n\t\t\t\t\t</BORROWER>\n\t\t\t\t</LOAN_APPLICATION>\n\t\t\t</VOI_REQUEST>\n\t\t</REQUEST_DATA>\n\t</REQUEST>\n</REQUEST_GROUP>"
      @request_params ||= Nokogiri::XML(xml).to_xml
    end
  end
end
