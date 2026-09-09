/// <summary>
/// Shows the employment history lines of a candidate on the job application.
/// </summary>
page 70146 "Candidate Empl. History Part"
{
    Caption = 'Employment History';
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "Candidate Employment History";
    AutoSplitKey = true;
    DelayedInsert = true;
    MultipleNewLines = true;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Employer Name"; Rec."Employer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the employer that the candidate worked for.';
                }
                field("Company Name"; Rec."Company Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the company that the candidate worked for.';
                }
                field("Position"; Rec."Position")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the position that the candidate held with this employer.';
                }
                field("Department"; Rec."Department")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the department that the candidate worked in.';
                }
                field("From Date"; Rec."From Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date on which the candidate started with this employer.';
                }
                field("Till Date"; Rec."Till Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date on which the candidate left this employer. Leave it empty if the candidate still works there.';
                }
                field("Years of Experience"; Rec."Years of Experience")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the number of years the candidate worked for this employer, calculated from the From Date and the Till Date.';
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
                ToolTip = 'Remove the selected employment history line.';

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
        DeleteLineQst: Label 'Do you want to delete this employment history line?';
}
