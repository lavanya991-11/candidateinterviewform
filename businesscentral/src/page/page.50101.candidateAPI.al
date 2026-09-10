
page 70142 "Candidate API"
{
    Caption = 'candidates', Locked = true;
    PageType = API;
    APIPublisher = 'Novasoft';
    APIGroup = 'Novasoft';
    APIVersion = 'v2.0';
    EntityName = 'candidate';
    EntitySetName = 'candidates';
    SourceTable = "Candidate";
    DelayedInsert = true;
    ODataKeyFields = SystemId;
    Extensible = false;
    ChangeTrackingAllowed = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(id; Rec.SystemId) { Editable = false; }
                field(entryNo; Rec."Entry No.") { Editable = false; }
                // Exposed as a binary sub-resource: GET/PATCH candidates({id})/picture/content
                field(picture; Rec."Picture Blob") { Caption = 'picture', Locked = true; }

                // Personal information
                field(salutation; Rec."Salutation") { }
                field(firstName; Rec."First Name") { }
                field(middleName; Rec."Middle Name") { }
                field(lastName; Rec."Last Name") { }
                // Rebuilt by the table from the name parts, so it is never accepted as input.
                field(candidateName; Rec."Candidate Name") { Editable = false; }
                field(dateOfBirth; Rec."Date of Birth") { }
                field(gender; Rec."Gender") { }
                field(maritalStatus; Rec."Marital Status") { }

                // Contact information
                field(email; Rec."Email") { }
                field(phoneNo; Rec."Phone No.") { }

                // Current address
                field(address; Rec."Address") { }
                field(address2; Rec."Address 2") { }
                field(city; Rec."City") { }
                field(state; Rec."State") { }
                field(postCode; Rec."Post Code") { }
                field(countryRegionCode; Rec."Country/Region Code") { }

                // Permanent address
                field(sameAsCurrentAddress; Rec."Same as Current Address") { }
                field(permanentAddress; Rec."Permanent Address") { }
                field(permanentAddress2; Rec."Permanent Address 2") { }
                field(permanentCity; Rec."Permanent City") { }
                field(permanentState; Rec."Permanent State") { }
                field(permanentPostCode; Rec."Permanent Post Code") { }
                field(permanentCountryRegionCode; Rec."Permanent Country/Region Code") { }

                // Educational qualification
                field(qualification; Rec."Qualification") { }
                field(otherQualification; Rec."Other Qualification") { }
                field(education; Rec."Education") { }

                // Employment details
                field(experience; Rec."Experience") { }
                field(skills; Rec."Skills") { }

                // English language certifications
                field(englishCertification; Rec."English Certification") { }
                field(mostRecentTestDate; Rec."Most Recent Test Date") { }

                // Recruitment
                field(referenceCheckConsent; Rec."Reference Check Consent") { }
                field(positionAppliedFor; Rec."Position Applied For") { }
                field(interviewDate; Rec."Interview Date") { }
                field(applicationDate; Rec."Application Date") { Editable = false; }
                field(applicationStatus; Rec."Application Status") { Editable = false; }
                field(submittedOn; Rec."Submitted On") { Editable = false; }
                field(lastModifiedDateTime; Rec.SystemModifiedAt) { Editable = false; }

                part(employmentHistory; "Candidate Empl. Hist. API")
                {
                    Caption = 'employmentHistory', Locked = true;
                    EntityName = 'employmentHistory';
                    EntitySetName = 'employmentHistory';
                    SubPageLink = "Candidate Entry No." = field("Entry No.");
                }
                part(candidateReferences; "Candidate Reference API")
                {
                    Caption = 'candidateReferences', Locked = true;
                    EntityName = 'candidateReference';
                    EntitySetName = 'candidateReferences';
                    SubPageLink = "Candidate Entry No." = field("Entry No.");
                }
            }
        }
    }

    var
        CandidateNotFoundErr: Label 'The application could not be found.';
        PictureDataUriTxt: Label 'data:%1;base64,%2', Locked = true;

    /// <summary>
    /// Refuses an application that arrives without a title, so the row never enters the
    /// table without one. The photo cannot be checked here: it is a Media field, which
    /// OData publishes as a separate resource, so it can only be written to a row that
    /// already exists - setPictureBase64 does that, and the submit refuses a row that
    /// still has no photo by then.
    /// </summary>
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.CheckSalutation();
        exit(true);
    end;

    /// <summary>
    /// Submits the application. An API page exposes a bound action through a
    /// ServiceEnabled procedure - an action in the actions area is a UI construct that
    /// never reaches the OData metadata - so this is callable as
    /// POST .../candidates({id})/Microsoft.NAV.submit.
    /// </summary>
    [ServiceEnabled]
    procedure submit(var ActionContext: WebServiceActionContext)
    var
        Candidate: Record "Candidate";
    begin
        if not Candidate.GetBySystemId(Rec.SystemId) then
            Error(CandidateNotFoundErr);

        // SubmitFromApplicationForm() rather than SubmitApplication(): the table owns the
        // already-submitted guard, the mandatory field check and the status update, but
        // the confirmation dialog belongs to the UI path only - a client callback fails
        // outright here. This is also the one path that acknowledges the candidate by
        // email, because it is the only one the candidate themselves can reach.
        Candidate.SubmitFromApplicationForm();

        ActionContext.SetObjectType(ObjectType::Page);
        ActionContext.SetObjectId(Page::"Candidate API");
        ActionContext.AddEntityKey(Rec.FieldNo(SystemId), Candidate.SystemId);
        ActionContext.SetResultCode(WebServiceActionResultCode::Updated);
    end;

    /// <summary>
    /// Stores the candidate photo from a Base64 encoded image, for clients that cannot
    /// PATCH the binary picture sub-resource. Callable as
    /// POST .../candidates({id})/Microsoft.NAV.setPictureBase64 with a body of
    /// { "pictureBase64": "..." }. A plain Base64 string and a data URI are both accepted;
    /// an empty string clears the photo.
    /// </summary>
    /// <param name="pictureBase64">The Base64 encoded image, optionally as a data URI.</param>
    [ServiceEnabled]
    procedure setPictureBase64(pictureBase64: Text; var ActionContext: WebServiceActionContext)
    var
        Candidate: Record "Candidate";
    begin
        if not Candidate.GetBySystemId(Rec.SystemId) then
            Error(CandidateNotFoundErr);

        Candidate.SetPictureFromBase64(pictureBase64);

        ActionContext.SetObjectType(ObjectType::Page);
        ActionContext.SetObjectId(Page::"Candidate API");
        ActionContext.AddEntityKey(Rec.FieldNo(SystemId), Candidate.SystemId);
        ActionContext.SetResultCode(WebServiceActionResultCode::Updated);
    end;

    /// <summary>
    /// Returns the stored candidate photo as a data URI, so a client can read the photo
    /// inline instead of through the binary picture sub-resource. Callable as
    /// POST .../candidates({id})/Microsoft.NAV.getPictureBase64.
    /// </summary>
    /// <returns>The photo as a data URI, or an empty text when no photo is stored.</returns>
    [ServiceEnabled]
    procedure getPictureBase64(): Text
    var
        Candidate: Record "Candidate";
        PictureBase64: Text;
    begin
        if not Candidate.GetBySystemId(Rec.SystemId) then
            Error(CandidateNotFoundErr);

        PictureBase64 := Candidate.GetPictureAsBase64();
        if PictureBase64 = '' then
            exit('');

        exit(StrSubstNo(PictureDataUriTxt, Candidate.GetPictureMimeType(), PictureBase64));
    end;
}
