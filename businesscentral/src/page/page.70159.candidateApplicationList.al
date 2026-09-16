/// <summary>
/// Lists the submitted job applications, for HR to review and plan interviews. Candidates
/// who are still being invited are on the Registration Invitations list instead.
/// </summary>
page 70159 "Candidate Application List"
{
    Caption = 'Candidate Applications';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Candidate";
    SourceTableView = sorting("Entry No.") order(descending)
                      where("Application Status" = const(Submitted));
    CardPageId = "Candidate Card";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Caption = 'ID Number';
                    ToolTip = 'Specifies the reference number of the candidate.';
                }
                field("Candidate Name"; Rec."Candidate Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the full name of the candidate.';
                }
                field("Position Applied For"; Rec."Position Applied For")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the position that the candidate applied for.';
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the phone number used to contact the candidate.';
                }
                field("Email"; Rec."Email")
                {
                    ApplicationArea = All;
                    Caption = 'Candidate Email Address';
                    Visible = false;
                    ToolTip = 'Specifies the email address used to contact the candidate.';
                }
                field("City"; Rec."City")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the city of the current address of the candidate.';
                }
                field("Qualification"; Rec."Qualification")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the highest qualification of the candidate.';
                }
                field("English Certification"; Rec."English Certification")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the English language certification that the candidate attempted.';
                }
                field("Submitted On"; Rec."Submitted On")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the application was submitted.';
                }
                field("Interview Date"; Rec."Interview Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date on which the candidate is interviewed.';
                }
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

    views
    {
        view(InterviewNotScheduled)
        {
            Caption = 'Interview Not Scheduled';
            Filters = where("Interview Date" = filter(''));
        }
        view(InterviewScheduled)
        {
            Caption = 'Interview Scheduled';
            Filters = where("Interview Date" = filter('<>'''''));
        }
    }
}
