/// <summary>
/// Sets up how candidates are numbered and where registration links point to.
/// </summary>
page 70155 "Candidate Setup"
{
    Caption = 'Candidate Setup';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Candidate Setup";
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(Numbering)
            {
                Caption = 'Numbering';

                field("Candidate Nos."; Rec."Candidate Nos.")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the number series that gives a new candidate its Entry No. The series must use digits only, for example 1000 to 999999, because the Entry No. is a number.';
                }
            }
            group(Registration)
            {
                Caption = 'Registration';

                field("Registration Form URL"; Rec."Registration Form URL")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the address of the online application form, for example https://candidate-form.onrender.com. The registration link that is emailed to a candidate opens this form.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.EnsureRecord();
    end;
}
