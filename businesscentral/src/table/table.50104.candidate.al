/// <summary>
/// Holds the job application of a candidate, including personal details, addresses, qualifications and recruitment status.
/// </summary>
table 70120 "Candidate"
{
    Caption = 'Candidate';
    DataClassification = CustomerContent;
    LookupPageId = "Candidate List";
    DrillDownPageId = "Candidate List";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            Editable = false;
        }
        field(2; "Candidate Name"; Text[100])
        {
            Caption = 'Candidate Name';
            NotBlank = true;
        }
        field(3; "Email"; Text[80])
        {
            Caption = 'Email Address';
            ExtendedDatatype = EMail;

            trigger OnValidate()
            var
                MailMgt: Codeunit "Mail Management";
            begin
                if "Email" <> '' then
                    MailMgt.CheckValidEmailAddress("Email");
            end;
        }
        field(4; "Phone No."; Text[30])
        {
            Caption = 'Primary Mobile Number';
            ExtendedDatatype = PhoneNo;
        }
        field(5; "Education"; Text[250])
        {
            Caption = 'Education';
        }
        field(6; "Experience"; Text[250])
        {
            Caption = 'Experience';
        }
        field(7; "Skills"; Text[250])
        {
            Caption = 'Skills';
        }
        field(8; "Position Applied For"; Text[100])
        {
            Caption = 'Position Applied For';
        }
        field(9; "Interview Date"; Date)
        {
            Caption = 'Interview Date';
        }
        field(10; "Application Date"; Date)
        {
            Caption = 'Application Date';
            Editable = false;
        }

        // Personal information
        field(20; "Salutation"; Enum "Candidate Salutation")
        {
            Caption = 'Salutation';
        }
        field(21; "First Name"; Text[50])
        {
            Caption = 'First Name';

            trigger OnValidate()
            begin
                UpdateCandidateName();
            end;
        }
        field(22; "Middle Name"; Text[50])
        {
            Caption = 'Middle Name';

            trigger OnValidate()
            begin
                UpdateCandidateName();
            end;
        }
        field(23; "Last Name"; Text[50])
        {
            Caption = 'Last Name';

            trigger OnValidate()
            begin
                UpdateCandidateName();
            end;
        }
        field(24; "Date of Birth"; Date)
        {
            Caption = 'Date of Birth';

            trigger OnValidate()
            begin
                if "Date of Birth" > Today() then
                    Error(DateOfBirthInFutureErr);
            end;
        }
        field(25; "Gender"; Enum "Candidate Gender")
        {
            Caption = 'Gender';
        }
        field(26; "Marital Status"; Enum "Candidate Marital Status")
        {
            Caption = 'Marital Status';
        }
        field(27; "Picture Blob"; Media)
        {
            Caption = 'Picture';
            // this is the actual stored media — use THIS on your editable FactBox part
        }

        // Current address
        field(30; "Address"; Text[100])
        {
            Caption = 'Door No. / Flat No. / Address 1';

            trigger OnValidate()
            begin
                CopyCurrentAddressToPermanent();
            end;
        }
        field(31; "Address 2"; Text[100])
        {
            Caption = 'Apartment Name / Street Name / Address 2';

            trigger OnValidate()
            begin
                CopyCurrentAddressToPermanent();
            end;
        }
        field(32; "City"; Text[50])
        {
            Caption = 'City';

            trigger OnValidate()
            begin
                CopyCurrentAddressToPermanent();
            end;
        }
        field(33; "State"; Text[50])
        {
            Caption = 'State';

            trigger OnValidate()
            begin
                CopyCurrentAddressToPermanent();
            end;
        }
        field(34; "Post Code"; Code[20])
        {
            Caption = 'Pin Code';

            trigger OnValidate()
            begin
                CopyCurrentAddressToPermanent();
            end;
        }
        field(35; "Country/Region Code"; Code[10])
        {
            Caption = 'Country';
            TableRelation = "Country/Region";

            trigger OnValidate()
            begin
                CopyCurrentAddressToPermanent();
            end;
        }

        // Permanent address
        field(40; "Same as Current Address"; Boolean)
        {
            Caption = 'Same as Current Address';
            InitValue = true;

            trigger OnValidate()
            begin
                CopyCurrentAddressToPermanent();
            end;
        }
        field(41; "Permanent Address"; Text[100])
        {
            Caption = 'Door No. / Flat No. / Address 1';

            trigger OnValidate()
            begin
                CheckPermanentAddressEditable();
            end;
        }
        field(42; "Permanent Address 2"; Text[100])
        {
            Caption = 'Apartment Name / Street Name / Address 2';

            trigger OnValidate()
            begin
                CheckPermanentAddressEditable();
            end;
        }
        field(43; "Permanent City"; Text[50])
        {
            Caption = 'City';

            trigger OnValidate()
            begin
                CheckPermanentAddressEditable();
            end;
        }
        field(44; "Permanent State"; Text[50])
        {
            Caption = 'State';

            trigger OnValidate()
            begin
                CheckPermanentAddressEditable();
            end;
        }
        field(45; "Permanent Post Code"; Code[20])
        {
            Caption = 'Pin Code';

            trigger OnValidate()
            begin
                CheckPermanentAddressEditable();
            end;
        }
        field(46; "Permanent Country/Region Code"; Code[10])
        {
            Caption = 'Country';
            TableRelation = "Country/Region";

            trigger OnValidate()
            begin
                CheckPermanentAddressEditable();
            end;
        }

        // Educational qualification
        field(50; "Qualification"; Enum "Candidate Qualification")
        {
            Caption = 'Qualification Details';

            trigger OnValidate()
            begin
                if "Qualification" <> "Qualification"::Other then
                    "Other Qualification" := '';
            end;
        }
        field(51; "Other Qualification"; Text[100])
        {
            Caption = 'Other Qualification';

            trigger OnValidate()
            begin
                if ("Other Qualification" <> '') and ("Qualification" <> "Qualification"::Other) then
                    Error(OtherQualificationErr);
            end;
        }

        // English language certifications
        field(60; "English Certification"; Enum "Candidate English Cert.")
        {
            Caption = 'Certifications Attempted';

            trigger OnValidate()
            begin
                if "English Certification" = "English Certification"::None then
                    "Most Recent Test Date" := 0D;
            end;
        }
        field(61; "Most Recent Test Date"; Date)
        {
            Caption = 'Most Recent Test Date';

            trigger OnValidate()
            begin
                if ("Most Recent Test Date" <> 0D) and ("English Certification" = "English Certification"::None) then
                    Error(TestDateWithoutCertErr);
                if "Most Recent Test Date" > Today() then
                    Error(TestDateInFutureErr);
            end;
        }

        // Consent and submission
        field(70; "Reference Check Consent"; Boolean)
        {
            Caption = 'Consent to Reference Checks';
        }
        field(71; "Application Status"; Enum "Candidate Application Status")
        {
            Caption = 'Application Status';
            Editable = false;
        }
        field(72; "Submitted On"; DateTime)
        {
            Caption = 'Submitted On';
            Editable = false;
        }

        // Statistics
        field(80; "No. of Employment Lines"; Integer)
        {
            Caption = 'Employment History Lines';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = count("Candidate Employment History" where("Candidate Entry No." = field("Entry No.")));
        }
        field(81; "No. of References"; Integer)
        {
            Caption = 'References';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = count("Candidate Reference" where("Candidate Entry No." = field("Entry No.")));
        }
        field(82; "No. of Attachments"; Integer)
        {
            Caption = 'Attachments';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = count("Candidate Attachment" where("Candidate Entry No." = field("Entry No.")));
        }
        field(83; "Picture"; Media)
        {
            Caption = 'Picture';
            FieldClass = FlowField;
            CalcFormula = lookup("Candidate"."Picture Blob" where("Entry No." = field("Entry No.")));
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Email; "Email") { }
        key(InterviewDate; "Interview Date") { }
        key(Name; "Last Name", "First Name") { }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Entry No.", "Candidate Name", "Position Applied For") { }
        fieldgroup(Brick; "Candidate Name", "Position Applied For", "Email", "Phone No.") { }
    }

    var
        DateOfBirthInFutureErr: Label 'The date of birth cannot be later than today.';
        TestDateInFutureErr: Label 'The most recent test date cannot be later than today.';
        TestDateWithoutCertErr: Label 'You cannot enter a test date when no English language certification was attempted.';
        OtherQualificationErr: Label 'You can only specify another qualification when Qualification Details is set to Other.';
        PermanentAddressLockedErr: Label 'The permanent address is copied from the current address. Clear Same as Current Address to enter a different address.';
        SubmitConfirmQst: Label 'Do you want to submit this application? A submitted application can no longer be changed.';
        MissingFieldErr: Label '%1 must be filled in before the application can be submitted.', Comment = '%1 = Field caption';
        MissingPictureErr: Label 'A candidate photo must be attached before the application can be submitted.';
        AlreadySubmittedErr: Label 'This application was already submitted on %1.', Comment = '%1 = Submission date and time';
        PictureDescriptionTxt: Label 'Photo of %1', Comment = '%1 = Candidate name';
        DefaultPictureMimeTypeTok: Label 'image/jpeg', Locked = true;
        DataUriPrefixTok: Label 'data:', Locked = true;
        InvalidPictureBase64Err: Label 'The candidate photo could not be read. Provide the photo as a Base64 encoded image.';
        SelectPictureTxt: Label 'Select a photo of the candidate';
        PictureFileFilterTxt: Label 'Image files (*.jpg;*.jpeg;*.png;*.bmp;*.gif)|*.jpg;*.jpeg;*.png;*.bmp;*.gif', Comment = 'Only the file type names are translated.';
        DeletePictureQst: Label 'Do you want to delete the photo of %1?', Comment = '%1 = Candidate name';
        NoPictureErr: Label 'There is no photo to export for this candidate.';
        PictureFileNameTxt: Label 'Photo of %1%2', Comment = '%1 = Candidate name, %2 = File extension including the dot';

    trigger OnInsert()
    begin
        if "Application Date" = 0D then
            "Application Date" := Today();
        UpdateCandidateName();
    end;

    trigger OnModify()
    begin
        UpdateCandidateName();
    end;

    trigger OnDelete()
    var
        EmploymentHistory: Record "Candidate Employment History";
        CandidateReference: Record "Candidate Reference";
        CandidateAttachment: Record "Candidate Attachment";
    begin
        EmploymentHistory.SetRange("Candidate Entry No.", "Entry No.");
        EmploymentHistory.DeleteAll(true);

        CandidateReference.SetRange("Candidate Entry No.", "Entry No.");
        CandidateReference.DeleteAll(true);

        CandidateAttachment.SetRange("Candidate Entry No.", "Entry No.");
        CandidateAttachment.DeleteAll(true);
    end;

    /// <summary>
    /// Builds the candidate name from the separate name parts that are entered on the application form.
    /// </summary>
    procedure UpdateCandidateName()
    var
        NewName: Text;
    begin
        NewName := "First Name";
        if "Middle Name" <> '' then
            NewName := NewName + ' ' + "Middle Name";
        if "Last Name" <> '' then
            NewName := NewName + ' ' + "Last Name";
        NewName := DelChr(NewName, '<>', ' ');

        if NewName <> '' then
            "Candidate Name" := CopyStr(NewName, 1, MaxStrLen("Candidate Name"));
    end;

    /// <summary>
    /// Returns the name of the candidate, prefixed with the salutation.
    /// </summary>
    /// <returns>The salutation and the candidate name.</returns>
    procedure GetFullName(): Text
    begin
        if "Salutation" = "Salutation"::" " then
            exit("Candidate Name");
        exit(Format("Salutation") + ' ' + "Candidate Name");
    end;

    /// <summary>
    /// Stores the candidate photo from a Base64 encoded image, so a client that cannot send
    /// the binary picture sub-resource can still supply the photo inline. A plain Base64
    /// string and a data URI ("data:image/png;base64,...") are both accepted; an empty text
    /// clears the photo.
    /// </summary>
    /// <param name="PictureBase64">The Base64 encoded image, optionally as a data URI.</param>
    procedure SetPictureFromBase64(PictureBase64: Text)
    var
        TempBlob: Codeunit "Temp Blob";
        PictureInStream: InStream;
        PictureOutStream: OutStream;
        MimeType: Text[100];
    begin
        Clear("Picture Blob");

        PictureBase64 := StripDataUri(RemoveWhitespace(PictureBase64), MimeType);
        if PictureBase64 = '' then begin
            Modify(true);
            exit;
        end;

        TempBlob.CreateOutStream(PictureOutStream);
        if not TryDecodeBase64(PictureBase64, PictureOutStream) then
            Error(InvalidPictureBase64Err);

        TempBlob.CreateInStream(PictureInStream);

        if MimeType = '' then
            MimeType := DefaultPictureMimeTypeTok;

        "Picture Blob".ImportStream(PictureInStream, StrSubstNo(PictureDescriptionTxt, "Candidate Name"), MimeType);
        Modify(true);
    end;

    /// <summary>
    /// Returns the stored candidate photo as a Base64 encoded string, for clients that read
    /// the photo inline instead of through the binary picture sub-resource.
    /// </summary>
    /// <returns>The Base64 encoded image, or an empty text when no photo is stored.</returns>
    procedure GetPictureAsBase64(): Text
    var
        TenantMedia: Record "Tenant Media";
        Base64Convert: Codeunit "Base64 Convert";
        PictureInStream: InStream;
    begin
        if not "Picture Blob".HasValue() then
            exit('');

        TenantMedia.SetAutoCalcFields(Content);
        if not TenantMedia.Get("Picture Blob".MediaId) then
            exit('');

        if not TenantMedia.Content.HasValue() then
            exit('');

        TenantMedia.Content.CreateInStream(PictureInStream);
        exit(Base64Convert.ToBase64(PictureInStream));
    end;

    /// <summary>
    /// Returns the MIME type the stored candidate photo was imported with.
    /// </summary>
    /// <returns>The MIME type, or an empty text when no photo is stored.</returns>
    procedure GetPictureMimeType(): Text
    var
        TenantMedia: Record "Tenant Media";
    begin
        if not "Picture Blob".HasValue() then
            exit('');

        if not TenantMedia.Get("Picture Blob".MediaId) then
            exit('');

        exit(TenantMedia."Mime Type");
    end;

    /// <summary>
    /// Uploads a photo from the client and stores it on the candidate, so the photo can be
    /// set from the Candidate Card as well as through the API.
    /// </summary>
    procedure ImportPicture()
    var
        PictureInStream: InStream;
        ClientFileName: Text;
    begin
        if not UploadIntoStream(SelectPictureTxt, '', PictureFileFilterTxt, ClientFileName, PictureInStream) then
            exit;

        Clear("Picture Blob");
        // The MIME type is derived from the file name the client sent, because the stored
        // type is what the API data URI and the confirmation email are built from.
        "Picture Blob".ImportStream(PictureInStream, StrSubstNo(PictureDescriptionTxt, "Candidate Name"), GetMimeTypeFromFileName(ClientFileName));
        Modify(true);
    end;

    /// <summary>
    /// Downloads the stored photo to the client.
    /// </summary>
    procedure ExportPicture()
    var
        TenantMedia: Record "Tenant Media";
        PictureInStream: InStream;
        ToFile: Text;
    begin
        if not "Picture Blob".HasValue() then
            Error(NoPictureErr);

        TenantMedia.SetAutoCalcFields(Content);
        if not TenantMedia.Get("Picture Blob".MediaId) then
            Error(NoPictureErr);

        if not TenantMedia.Content.HasValue() then
            Error(NoPictureErr);

        TenantMedia.Content.CreateInStream(PictureInStream);
        ToFile := StrSubstNo(PictureFileNameTxt, "Candidate Name", GetFileExtensionFromMimeType(TenantMedia."Mime Type"));
        DownloadFromStream(PictureInStream, '', '', '', ToFile);
    end;

    /// <summary>
    /// Removes the stored photo after the user confirms.
    /// </summary>
    procedure DeletePicture()
    begin
        if not "Picture Blob".HasValue() then
            exit;

        if not Confirm(DeletePictureQst, false, "Candidate Name") then
            exit;

        Clear("Picture Blob");
        Modify(true);
    end;

    /// <summary>
    /// Maps an uploaded file name to the MIME type the photo is stored under.
    /// </summary>
    /// <param name="FileName">The file name reported by the client.</param>
    /// <returns>The MIME type, falling back to the default when the extension is unknown.</returns>
    local procedure GetMimeTypeFromFileName(FileName: Text): Text[100]
    var
        LowerFileName: Text;
    begin
        LowerFileName := LowerCase(FileName);

        if LowerFileName.EndsWith('.png') then
            exit('image/png');
        if LowerFileName.EndsWith('.gif') then
            exit('image/gif');
        if LowerFileName.EndsWith('.bmp') then
            exit('image/bmp');

        exit(DefaultPictureMimeTypeTok);
    end;

    /// <summary>
    /// Maps a stored MIME type back to the file extension the photo is exported with.
    /// </summary>
    /// <param name="MimeType">The MIME type the photo was imported with.</param>
    /// <returns>The file extension, including the leading dot.</returns>
    local procedure GetFileExtensionFromMimeType(MimeType: Text): Text
    begin
        case LowerCase(MimeType) of
            'image/png':
                exit('.png');
            'image/gif':
                exit('.gif');
            'image/bmp':
                exit('.bmp');
        end;

        exit('.jpg');
    end;

    /// <summary>
    /// Splits a data URI into its MIME type and its Base64 payload. A value that is not a
    /// data URI is returned unchanged, with a blank MIME type.
    /// </summary>
    local procedure StripDataUri(PictureBase64: Text; var MimeType: Text[100]): Text
    var
        Header: Text;
        SeparatorPos: Integer;
        HeaderLength: Integer;
    begin
        MimeType := '';

        if not PictureBase64.StartsWith(DataUriPrefixTok) then
            exit(PictureBase64);

        SeparatorPos := StrPos(PictureBase64, ',');
        if SeparatorPos = 0 then
            exit(PictureBase64);

        // Everything between "data:" and the comma, for example "image/png;base64".
        HeaderLength := SeparatorPos - 1 - StrLen(DataUriPrefixTok);
        if HeaderLength > 0 then begin
            Header := CopyStr(PictureBase64, StrLen(DataUriPrefixTok) + 1, HeaderLength);
            if StrPos(Header, ';') > 0 then
                Header := CopyStr(Header, 1, StrPos(Header, ';') - 1);
            MimeType := CopyStr(Header, 1, MaxStrLen(MimeType));
        end;

        exit(CopyStr(PictureBase64, SeparatorPos + 1));
    end;

    /// <summary>
    /// Removes the spaces and line breaks a Base64 payload may be wrapped in.
    /// </summary>
    local procedure RemoveWhitespace(Value: Text): Text
    var
        Tab: Char;
        LineFeed: Char;
        CarriageReturn: Char;
    begin
        Tab := 9;
        LineFeed := 10;
        CarriageReturn := 13;
        exit(DelChr(Value, '=', ' ' + Format(Tab) + Format(LineFeed) + Format(CarriageReturn)));
    end;

    [TryFunction]
    local procedure TryDecodeBase64(PictureBase64: Text; PictureOutStream: OutStream)
    var
        Base64Convert: Codeunit "Base64 Convert";
    begin
        Base64Convert.FromBase64(PictureBase64, PictureOutStream);
    end;

    /// <summary>
    /// Asks the user to confirm and then submits the application, from a session that
    /// has a client to answer the question. This is recruitment submitting the record
    /// inside Business Central, not the candidate, so no acknowledgement is sent - the
    /// candidate is only written to when they themselves submit the application form.
    /// </summary>
    procedure SubmitApplication()
    begin
        CheckSubmittable();

        if not Confirm(SubmitConfirmQst, false) then
            exit;

        Submit();
    end;

    /// <summary>
    /// Submits the application on the candidate's own behalf and acknowledges it by
    /// email. Only the application form reaches this, through the submit action on the
    /// API page, so an acknowledgement means the candidate really did submit it.
    /// </summary>
    procedure SubmitFromApplicationForm()
    begin
        Submit();

        SendApplicationConfirmationEmail();
    end;

    /// <summary>
    /// Validates the mandatory parts of the application form and marks the application
    /// as submitted, without asking anything. Business Central Data Services cannot
    /// issue a client callback, so no code an API request can reach may confirm.
    /// Sends nothing: the acknowledgement belongs to the form path alone.
    /// </summary>
    procedure Submit()
    begin
        CheckSubmittable();

        "Application Status" := "Application Status"::Submitted;
        "Submitted On" := CurrentDateTime();
        Modify(true);
    end;

    /// <summary>
    /// Emails the candidate a confirmation that their application was received.
    /// </summary>
    local procedure SendApplicationConfirmationEmail()
    var
        CandidateAckEmail: Codeunit "Candidate Ack. Email";
    begin
        CandidateAckEmail.Send(Rec);
    end;

    local procedure CheckSubmittable()
    begin
        if "Application Status" = "Application Status"::Submitted then
            Error(AlreadySubmittedErr, "Submitted On");

        CheckMandatoryFields();
    end;

    /// <summary>
    /// Checks the fields that the application form marks as required.
    /// </summary>
    procedure CheckMandatoryFields()
    begin
        if "Salutation" = "Salutation"::" " then
            Error(MissingFieldErr, FieldCaption("Salutation"));
        if "First Name" = '' then
            Error(MissingFieldErr, FieldCaption("First Name"));
        if "Date of Birth" = 0D then
            Error(MissingFieldErr, FieldCaption("Date of Birth"));
        if "Email" = '' then
            Error(MissingFieldErr, FieldCaption("Email"));
        if "Phone No." = '' then
            Error(MissingFieldErr, FieldCaption("Phone No."));
        if "Address" = '' then
            Error(MissingFieldErr, FieldCaption("Address"));
        if "City" = '' then
            Error(MissingFieldErr, FieldCaption("City"));
        if "Post Code" = '' then
            Error(MissingFieldErr, FieldCaption("Post Code"));
        if "Qualification" = "Qualification"::" " then
            Error(MissingFieldErr, FieldCaption("Qualification"));
        // The photo is written to the Candidate Picture before the application is
        // submitted, so by this point it is either stored or it was never supplied.
        if not "Picture Blob".HasValue() then
            Error(MissingPictureErr);
    end;

    local procedure CopyCurrentAddressToPermanent()
    begin
        if not "Same as Current Address" then
            exit;

        "Permanent Address" := "Address";
        "Permanent Address 2" := "Address 2";
        "Permanent City" := "City";
        "Permanent State" := "State";
        "Permanent Post Code" := "Post Code";
        "Permanent Country/Region Code" := "Country/Region Code";
    end;

    local procedure CheckPermanentAddressEditable()
    begin
        if "Same as Current Address" then
            Error(PermanentAddressLockedErr);
    end;
}
