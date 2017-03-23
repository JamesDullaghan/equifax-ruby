module Equifax
  module Worknumber
    module VOE
      module Researched
        class Submit < ::Equifax::Worknumber::Base

          def self.call(opts)
            voe = Equifax::Worknumber::VOE::Researched::Submit.new(opts)

            Equifax::Client.request(
              voe.send(:url),
              { request_method: :post },
              voe.send(:request_params),
            )
          end

          def self.required_fields
            super::REQUIRED_FIELDS + [
              :authform_name,
              :authform_content,
              :organization_name,
            ]
          end

          def self.optional_fields
            super::OPTIONAL_FIELDS + [:employer_duns_number, :employer_division]
          end

          private

          def xml
            <<-eos
              <?xml version="1.0" encoding="utf-8"?>
              <!-- edited with XMLSpy v2010 rel. 3 (http://www.altova.com) by EQUIFAX, INC. (EQUIFAX, INC.) -->
              <REQUEST_GROUP MISMOVersionID="2.3.1" >
                <REQUESTING_PARTY _Name="#{vendor_id}"/>
                <SUBMITTING_PARTY _Name="#{employer_name}">
                  <PREFERRED_RESPONSE _Format="PDF"></PREFERRED_RESPONSE>
                </SUBMITTING_PARTY>
                <REQUEST InternalAccountIdentifier="#{account_number}" LoginAccountIdentifier="#{account_number}" LoginAccountPassword="#{password}" RequestingPartyBranchIdentifier="#{organization_name}">
                  <KEY _Name="EMSEmployerCode" _Value="#{employer_code}"/>
                  <KEY _Name="EMSEmployerDunsNumber" _Value="#{employer_duns_number}"/>
                  <KEY _Name="EMSEmployerDivision" _Value="#{employer_division}"/>
                  <KEY _Name="EmployerVerificationDocumentsRequired" _Value="Y"/>
                  <KEY _Name="CallRecordingRequired" _Value="N"/>
                  <REQUEST_DATA>
                    <VOI_REQUEST LenderCaseIdentifier="#{lender_case_id}" RequestingPartyRequestedByName="#{lender_name}">
                      <VOI_REQUEST_DATA VOIReportType="Other" VOIReportTypeOtherDescription="rvvoe" VOIRequestType="Individual" VOIReportRequestActionType="Submit" BorrowerID="Borrower"/>
                      <LOAN_APPLICATION>
                        <BORROWER BorrowerID="Borrower" _FirstName="#{first_name}" _MiddleName="#{middle_name}" _LastName="#{last_name}" _PrintPositionType="Borrower" _SSN="#{ssn}">
                          <_RESIDENCE _StreetAddress="#{street_address}" _City="#{city}" _State="#{state}" _PostalCode="#{postal_code}" BorrowerResidencyType="Current"/>
                          <EMPLOYER _Name="#{employer_name}" _StreetAddress="#{employer_address}" _City="#{employer_city}" _State="#{employer_state}" _PostalCode="#{employer_postal_code}" _TelephoneNumber="#{employer_phone}"/>
                        </BORROWER>
                      </LOAN_APPLICATION>
                      <EXTENSION>
                        <EXTENSION_SECTION>
                          <EXTENSION_SECTION_DATA>
                            <EMBEDDED_FILE MIMEType="application tiff" _Name="#{authform_name}" _EncodingType="Base64" _Type="tiff">
                              <DOCUMENT>#{authform_content}
                              </DOCUMENT>
                            </EMBEDDED_FILE>
                          </EXTENSION_SECTION_DATA>
                        </EXTENSION_SECTION>
                      </EXTENSION>
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
