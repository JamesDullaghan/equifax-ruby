module Equifax
  module Worknumber
    module VOI
      module Researched
        class Status < ::Equifax::Worknumber::Base
          def self.call(opts)
            voe = Equifax::Worknumber::VOE::Researched::Status.new(opts)

            Equifax::Client.request(
              voe.send(:url),
              { request_method: :post },
              voe.send(:request_params),
            )
          end

          def self.required_fields
            super + [:order_number]
          end

          def xml
            <<-eos
              <?xml version="1.0" encoding="utf-8"?>
              <REQUEST_GROUP MISMOVersionID="2.3.1">
                <SUBMITTING_PARTY _Name="#{vendor_id}"/>
                <REQUEST InternalAccountIdentifier="#{account_number}" LoginAccountIdentifier="#{account_number}" LoginAccountPassword="#{password}" RequestingPartyBranchIdentifier="#{organization_name}">
                  <!--    <KEY _Name="getTestOFXResponse" _Value="" /> -->
                  <KEY _Name="EMSEmployerCode" _Value="#{employer_code}"/>
                  <KEY _Name="EMSOrderNumber" _Value="#{order_number}"/>
                  <REQUEST_DATA>
                    <VOI_REQUEST LenderCaseIdentifier="#{lender_case_id}" RequestingPartyRequestedByName="#{lender_name}">
                      <VOI_REQUEST_DATA VOIReportType="Other" VOIReportTypeOtherDescription="rvvoi" VOIRequestType="Individual" VOIRequestID="RVVOESQ1" VOIReportRequestActionType="StatusQuery" BorrowerID="Borrower"/>
                      <LOAN_APPLICATION>
                        <BORROWER BorrowerID="Borrower" _FirstName="#{first_name}" _MiddleName="#{middle_name}" _LastName="#{last_name}" _PrintPositionType="Borrower" _SSN="#{ssn}">
                          <_RESIDENCE _StreetAddress="#{address}" _City="#{city}" _State="#{state}" _PostalCode="#{postal_code}" BorrowerResidencyType="Current"/>
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
end
