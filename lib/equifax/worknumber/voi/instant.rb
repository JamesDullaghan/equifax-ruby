module Equifax
  module Worknumber
    module VOI
      class Instant < ::Equifax::Worknumber::Base
        def self.call(opts)
          voi = Equifax::Worknumber::VOI::Instant.new(opts)

          Equifax::Client.request(
            voi.send(:url),
            { request_method: :post },
            voi.send(:request_params),
          )
        end

        def self.required_fields
          super + [
            :order_number,
            :organization_name,
          ]
        end

        def xml
          <<-eos
            <?xml version="1.0" encoding="utf-8"?>
            <REQUEST_GROUP MISMOVersionID="2.3.1">
              <SUBMITTING_PARTY _Name="#{vendor_id}">
                <PREFERRED_RESPONSE _Format="PDF"></PREFERRED_RESPONSE> </SUBMITTING_PARTY>
              <REQUEST LoginAccountPassword="#{password}"
                LoginAccountIdentifier="#{account_number}" InternalAccountIdentifier="#{account_number}"
                RequestingPartyBranchIdentifier="#{organization_name}">
                <KEY _Name="EMSEmployerCode" _Value="#{employer_code}" />
                <REQUEST_DATA>
                  <VOI_REQUEST LenderCaseIdentifier="#{lender_case_id}"
                    RequestingPartyRequestedByName="#{lender_name}">
                    <VOI_REQUEST_DATA VOIReportType="Other"
                      VOIReportTypeOtherDescription="VOI" VOIRequestType="Individual"
                      VOIRequestID="VOITestWithEmployerCodeWithPDF" VOIReportRequestActionType="Submit"
                      BorrowerID="Borrower" />
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
