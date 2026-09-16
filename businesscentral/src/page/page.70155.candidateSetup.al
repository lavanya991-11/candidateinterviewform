/// <summary>
/// Sets up where candidate registration links point to.
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
