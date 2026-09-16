/// <summary>
/// Lists the candidates that HR is inviting to the online application form: those whose
/// link has not been sent yet and those who have not submitted the form yet. A candidate
/// leaves this list on submission and appears on the Candidate Applications list instead.
/// </summary>
page 70157 "Candidate Invitation List"
{
    Caption = 'Registration Invitations';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Candidate";
    SourceTableView = sorting("Entry No.") order(descending)
                      where("Application Status" = filter(Draft | Invited));
    CardPageId = "Candidate Invitation Card";
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
                    ToolTip = 'Specifies the reference number of the candidate. The registration email quotes this number.';
                }
                field("Candidate Name"; Rec."Candidate Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the full name of the candidate.';
                }
                field("Email"; Rec."Email")
                {
                    ApplicationArea = All;
                    Caption = 'Candidate Email Address';
                    ToolTip = 'Specifies the email address that the registration link is sent to.';
                }
                field("Position Applied For"; Rec."Position Applied For")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the position that the candidate is invited to apply for.';
                }
                field("HR Email"; Rec."HR Email")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the email address of the HR contact, who receives a copy of the registration email.';
                }
                field("Application Status"; Rec."Application Status")
                {
                    ApplicationArea = All;
                    StyleExpr = StatusStyleTxt;
                    ToolTip = 'Specifies whether the registration link is still to be sent or the candidate has not submitted the form yet.';
                }
                field("Registration Sent On"; Rec."Registration Sent On")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the registration link was last sent to the candidate.';
                }
                field("Registration Sent By"; Rec."Registration Sent By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the user who last sent the registration link.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(SendForRegistration)
            {
                ApplicationArea = All;
                Caption = 'Send for Registration';
                Image = SendTo;
                ToolTip = 'Email the selected candidate a link to the online application form, with a copy to the HR email address.';

                trigger OnAction()
                begin
                    Rec.SendForRegistration();
                    CurrPage.Update(false);
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref(SendForRegistration_Promoted; SendForRegistration) { }
            }
        }
    }

    views
    {
        view(NotSent)
        {
            Caption = 'Not Sent';
            Filters = where("Application Status" = const(Draft), "Registration Sent On" = filter(''));
        }
        view(WaitingForCandidate)
        {
            Caption = 'Waiting for Candidate';
            Filters = where("Application Status" = const(Invited));
        }
    }

    var
        StatusStyleTxt: Text;

    trigger OnAfterGetRecord()
    begin
        // A link that has gone out is waiting on the candidate; one that has not is
        // waiting on HR, which is the case that needs attention.
        if Rec."Application Status" = Rec."Application Status"::Invited then
            StatusStyleTxt := 'Ambiguous'
        else
            StatusStyleTxt := 'Attention';
    end;
}
