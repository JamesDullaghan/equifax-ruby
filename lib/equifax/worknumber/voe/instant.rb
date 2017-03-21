module Equifax
  module Worknumber
    module VOE
      class Instant < ::Equifax::Worknumber::Base
        def self.call(opts)
          voe = Equifax::Worknumber::VOE::Instant.new(opts)

          Equifax::Client.request(
            voe.send(:url),
            { request_method: :post },
            voe.send(:request_params),
          )
        end

        private

        def xml
          <<-eos
            <?xml version="1.0" encoding="utf-8"?>
            <REQUEST_GROUP MISMOVersionID="2.3.1">
              <SUBMITTING_PARTY _Name="#{vendor_id}">
                <PREFERRED_RESPONSE _Format="PDF"></PREFERRED_RESPONSE> </SUBMITTING_PARTY>
              <REQUEST InternalAccountIdentifier="#{account_number}"
                LoginAccountIdentifier="#{account_number}" LoginAccountPassword="#{password}">
                <KEY _Name="EMSEmployerCode" _Value="#{employer_code}" />
                <REQUEST_DATA>
                  <VOI_REQUEST LenderCaseIdentifier="#{lender_case_id}"
                    RequestingPartyRequestedByName="#{lender_name}">
                    <VOI_REQUEST_DATA VOIReportType="Other"
                      VOIReportTypeOtherDescription="VOE" VOIRequestType="Individual"
                      VOIReportRequestActionType="Submit" BorrowerID="Borrower" />
                    <LOAN_APPLICATION>
                      <BORROWER BorrowerID="Borrower" _FirstName="#{first_name}"
                        _MiddleName="#{middle_name}" _LastName="#{last_name}" _PrintPositionType="Borrower"
                        _SSN="#{ssn}">
                        <_RESIDENCE _StreetAddress="#{street_address}" _City="#{city}"
                                                _State="#{state}" _PostalCode="#{postal_code}" BorrowerResidencyType="Current" />
                        <EMPLOYER _Name="#{employer_name}" _StreetAddress="#{employer_address}"
                          _City="#{employer_city}" _State="#{employer_state}" _PostalCode="#{employer_postal_code}" />
                      </BORROWER>
                    </LOAN_APPLICATION>
                  </VOI_REQUEST>
                </REQUEST_DATA>
              </REQUEST>
            </REQUEST_GROUP>
          eos
        end
      end
    end
  end
end
