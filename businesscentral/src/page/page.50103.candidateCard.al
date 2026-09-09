/// <summary>
/// Captures a job application, following the sections of the printed application form.
/// </summary>
page 70141 "Candidate Card"
{
    Caption = 'Job Application';
    PageType = Card;
    ApplicationArea = All;
    SourceTable = "Candidate";

    layout
    {
        area(Content)
        {
            group(PersonalInformation)
            {
                Caption = 'Personal Information';

                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique number assigned to the candidate.';
                }
                field("Salutation"; Rec."Salutation")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the salutation of the candidate, such as Mr. or Ms.';
                }
                field("First Name"; Rec."First Name")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the first name of the candidate.';
                }
                field("Middle Name"; Rec."Middle Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the middle name of the candidate.';
                }
                field("Last Name"; Rec."Last Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the last name of the candidate.';
                }
                field("Candidate Name"; Rec."Candidate Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the full name of the candidate, composed from the name parts.';
                }
                field("Date of Birth"; Rec."Date of Birth")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the date of birth of the candidate.';
                }
                field("Gender"; Rec."Gender")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the gender of the candidate.';
                }
                field("Marital Status"; Rec."Marital Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the marital status of the candidate.';
                }
            }
            group(ContactInformation)
            {
                Caption = 'Contact Information';

                field("Email"; Rec."Email")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the email address used to contact the candidate.';
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the 10 digit mobile number, including the country code. For example, (012) 3456789012.';
                }
            }
            group(CurrentAddress)
            {
                Caption = 'Current Address';

                field("Address"; Rec."Address")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the door number or flat number of the current address.';
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the apartment name or street name of the current address.';
                }
                field("City"; Rec."City")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the city of the current address.';
                }
                field("State"; Rec."State")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the state of the current address.';
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the pin code of the current address.';
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the country or region of the current address.';
                }
            }
            group(PermanentAddress)
            {
                Caption = 'Permanent Address';

                field("Same as Current Address"; Rec."Same as Current Address")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies that the permanent address is the same as the current address.';

                    trigger OnValidate()
                    begin
                        UpdateControlState();
                        CurrPage.Update(true);
                    end;
                }
                group(PermanentAddressDetails)
                {
                    ShowCaption = false;
                    Editable = PermanentAddressEditable;

                    field("Permanent Address"; Rec."Permanent Address")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the door number or flat number of the permanent address.';
                    }
                    field("Permanent Address 2"; Rec."Permanent Address 2")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the apartment name or street name of the permanent address.';
                    }
                    field("Permanent City"; Rec."Permanent City")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the city of the permanent address.';
                    }
                    field("Permanent State"; Rec."Permanent State")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the state of the permanent address.';
                    }
                    field("Permanent Post Code"; Rec."Permanent Post Code")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the pin code of the permanent address.';
                    }
                    field("Permanent Country/Region Code"; Rec."Permanent Country/Region Code")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the country or region of the permanent address.';
                    }
                }
            }
            group(EducationalQualification)
            {
                Caption = 'Educational Qualification';

                field("Qualification"; Rec."Qualification")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the highest qualification of the candidate.';

                    trigger OnValidate()
                    begin
                        UpdateControlState();
                        CurrPage.Update(true);
                    end;
                }
                field("Other Qualification"; Rec."Other Qualification")
                {
                    ApplicationArea = All;
                    Enabled = OtherQualificationEnabled;
                    ToolTip = 'Specifies the qualification of the candidate when it is not in the list.';
                }
                field("Education"; Rec."Education")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    ToolTip = 'Specifies the educational background of the candidate.';
                }
            }
            part(EducationCertificates; "Candidate Attachments Part")
            {
                ApplicationArea = All;
                Caption = 'Graduation Certificates & Mark Sheets';
                SubPageLink = "Candidate Entry No." = field("Entry No."),
                              "Attachment Type" = const(Education);
                UpdatePropagation = Both;
            }
            group(RegistrationsAndCertifications)
            {
                Caption = 'Registrations & Certifications';

                field("Reference Check Consent"; Rec."Reference Check Consent")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies that the candidate consents to reference checks being carried out.';
                }
            }
            part(RegistrationCertificates; "Candidate Attachments Part")
            {
                ApplicationArea = All;
                Caption = 'Registration Certificates';
                SubPageLink = "Candidate Entry No." = field("Entry No."),
                              "Attachment Type" = const(Registration);
                UpdatePropagation = Both;
            }
            group(EmploymentDetails)
            {
                Caption = 'Employment Details';

                field("Experience"; Rec."Experience")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    ToolTip = 'Specifies a summary of the work experience of the candidate.';
                }
                field("Skills"; Rec."Skills")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    ToolTip = 'Specifies the skills that the candidate has.';
                }
            }
            part(EmploymentHistory; "Candidate Empl. History Part")
            {
                ApplicationArea = All;
                Caption = 'Employment History';
                SubPageLink = "Candidate Entry No." = field("Entry No.");
                UpdatePropagation = Both;
            }
            part(ExperienceCertificates; "Candidate Attachments Part")
            {
                ApplicationArea = All;
                Caption = 'Employment Experience Certificates';
                SubPageLink = "Candidate Entry No." = field("Entry No."),
                              "Attachment Type" = const(Experience);
                UpdatePropagation = Both;
            }
            part(References; "Candidate References Part")
            {
                ApplicationArea = All;
                Caption = 'References';
                SubPageLink = "Candidate Entry No." = field("Entry No.");
                UpdatePropagation = Both;
            }
            group(EnglishLanguageCertifications)
            {
                Caption = 'English Language Certifications';

                field("English Certification"; Rec."English Certification")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the English language certification that the candidate attempted, IELTS or OET.';

                    trigger OnValidate()
                    begin
                        UpdateControlState();
                        CurrPage.Update(true);
                    end;
                }
                field("Most Recent Test Date"; Rec."Most Recent Test Date")
                {
                    ApplicationArea = All;
                    Enabled = TestDateEnabled;
                    ToolTip = 'Specifies the date of the most recent English language test.';
                }
            }
            group(Recruitment)
            {
                Caption = 'Recruitment';

                field("Position Applied For"; Rec."Position Applied For")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the position that the candidate applied for.';
                }
                field("Interview Date"; Rec."Interview Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date on which the candidate is interviewed.';
                }
                field("Application Date"; Rec."Application Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date on which the candidate applied.';
                }
                field("Application Status"; Rec."Application Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the application is still a draft or has been submitted.';
                }
                field("Submitted On"; Rec."Submitted On")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the application was submitted.';
                }
            }
            group(ApplicationOverview)
            {
                Caption = 'Application Overview';

                field("No. of Employment Lines"; Rec."No. of Employment Lines")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how many employment history lines the candidate entered.';
                }
                field("No. of References"; Rec."No. of References")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how many references the candidate provided.';
                }
                field("No. of Attachments"; Rec."No. of Attachments")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how many files the candidate uploaded.';
                }
            }
        }
        area(FactBoxes)
        {
            part(CandidatePicture; "Candidate Picture Part")
            {
                ApplicationArea = All;
                SubPageLink = "Entry No." = field("Entry No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(SubmitApplication)
            {
                ApplicationArea = All;
                Caption = 'Review && Submit Application';
                Image = Approve;
                ToolTip = 'Check the required details and submit the application.';

                trigger OnAction()
                begin
                    CurrPage.SaveRecord();
                    Rec.SubmitApplication();
                    CurrPage.Update(false);
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref(SubmitApplication_Promoted; SubmitApplication) { }
            }
        }
    }

    var
        PermanentAddressEditable: Boolean;
        OtherQualificationEnabled: Boolean;
        TestDateEnabled: Boolean;

    trigger OnOpenPage()
    begin
        UpdateControlState();
    end;

    trigger OnAfterGetRecord()
    begin
        UpdateControlState();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        UpdateControlState();
    end;

    local procedure UpdateControlState()
    begin
        PermanentAddressEditable := not Rec."Same as Current Address";
        OtherQualificationEnabled := Rec."Qualification" = Rec."Qualification"::Other;
        TestDateEnabled := Rec."English Certification" <> Rec."English Certification"::None;
    end;
}
