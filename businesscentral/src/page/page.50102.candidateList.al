/// <summary>
/// Lists the submitted and draft job applications.
/// </summary>
page 70136 "Candidate List"
{
    Caption = 'Candidates';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Candidate";
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
                    // Left on the page rather than removed, so it can be brought back
                    // from Personalize without a code change.
                    Visible = false;
                    ToolTip = 'Specifies the unique number assigned to the candidate.';
                }
                field("Candidate Name"; Rec."Candidate Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the full name of the candidate.';
                }
                field("First Name"; Rec."First Name")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the first name of the candidate.';
                }
                field("Last Name"; Rec."Last Name")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the last name of the candidate.';
                }
                field("Date of Birth"; Rec."Date of Birth")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date of birth of the candidate.';
                }
                field("Gender"; Rec."Gender")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the gender of the candidate.';
                }
                field("Email"; Rec."Email")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the email address used to contact the candidate.';
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the phone number used to contact the candidate.';
                }
                field("City"; Rec."City")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the city of the current address of the candidate.';
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the country or region of the current address of the candidate.';
                }
                field("Qualification"; Rec."Qualification")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the highest qualification of the candidate.';
                }
                field("English Certification"; Rec."English Certification")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the English language certification that the candidate attempted.';
                }
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
                    StyleExpr = StatusStyleTxt;
                    ToolTip = 'Specifies whether the application is still a draft or has been submitted.';
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
    }

    // actions
    // {
    //     area(Processing)
    //     {
    //         action(SubmitApplication)
    //         {
    //             ApplicationArea = All;
    //             Caption = 'Review && Submit Application';
    //             Image = Approve;
    //             ToolTip = 'Check the required details and submit the selected application.';

    //             trigger OnAction()
    //             begin
    //                 Rec.SubmitApplication();
    //                 CurrPage.Update(false);
    //             end;
    //         }
    //     }
    //     area(Promoted)
    //     {
    //         group(Category_Process)
    //         {
    //             Caption = 'Process';

    //             actionref(SubmitApplication_Promoted; SubmitApplication) { }
    //         }
    //     }
    // }

    var
        StatusStyleTxt: Text;

    trigger OnAfterGetRecord()
    begin
        if Rec."Application Status" = Rec."Application Status"::Submitted then
            StatusStyleTxt := 'Favorable'
        else
            StatusStyleTxt := 'Ambiguous';
    end;
}
