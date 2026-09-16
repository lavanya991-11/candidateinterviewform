/// <summary>
/// Captures only what HR needs to invite a candidate to the online application form. The
/// candidate enters the rest of the application on the form, and it is reviewed on the
/// Job Application card once submitted.
/// </summary>
page 70158 "Candidate Invitation Card"
{
    Caption = 'Registration Invitation';
    PageType = Card;
    ApplicationArea = All;
    SourceTable = "Candidate";
    // A submitted application has nothing left to invite, so it is not opened here.
    SourceTableView = where("Application Status" = filter(Draft | Invited));
    DataCaptionFields = "Candidate Name";

    layout
    {
        area(Content)
        {
            group(Candidate)
            {
                Caption = 'Candidate';

                field("Salutation"; Rec."Salutation")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
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
                field("Email"; Rec."Email")
                {
                    ApplicationArea = All;
                    Caption = 'Candidate Email Address';
                    ShowMandatory = true;
                    ToolTip = 'Specifies the email address that the registration link is sent to.';
                }
                field("Position Applied For"; Rec."Position Applied For")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the position that the candidate is invited to apply for. The registration email mentions it.';
                }
            }
            group(Registration)
            {
                Caption = 'Registration';

                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Caption = 'ID Number';
                    ToolTip = 'Specifies the reference number of the candidate. The registration email quotes this number.';
                }
                field("HR Email"; Rec."HR Email")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the email address of the HR contact, who receives a copy of the registration email.';
                }
                field("Application Status"; Rec."Application Status")
                {
                    ApplicationArea = All;
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
                ToolTip = 'Email the candidate a link to the online application form, with a copy to the HR email address.';

                trigger OnAction()
                begin
                    CurrPage.SaveRecord();
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

    /// <summary>
    /// Refuses to create the invitation until a title is chosen, as the Job Application
    /// card does, so no record reaches the table without one.
    /// </summary>
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.CheckSalutation();
        exit(true);
    end;
}
