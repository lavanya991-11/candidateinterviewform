/// <summary>
/// Shows the work and personal references of a candidate on the job application.
/// </summary>
page 70147 "Candidate References Part"
{
    Caption = 'References';
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "Candidate Reference";
    AutoSplitKey = true;
    DelayedInsert = true;
    MultipleNewLines = true;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Reference Name"; Rec."Reference Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the full name of the work or personal reference.';
                }
                field("Email"; Rec."Email")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the email address of the reference.';
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the phone number of the reference.';
                }
                field("Notes"; Rec."Notes")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies optional notes about the reference, such as how the candidate knows them.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(DeleteLine)
            {
                ApplicationArea = All;
                Caption = 'Delete Line';
                Image = Delete;
                ToolTip = 'Remove the selected reference.';

                trigger OnAction()
                begin
                    if Rec."Line No." = 0 then
                        exit;
                    if Confirm(DeleteLineQst, false) then begin
                        Rec.Delete(true);
                        CurrPage.Update(false);
                    end;
                end;
            }
        }
    }

    var
        DeleteLineQst: Label 'Do you want to delete this reference?';
}
