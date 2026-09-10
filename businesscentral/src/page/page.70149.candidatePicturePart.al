/// <summary>
/// Shows the candidate's photo in a FactBox on the Candidate Card, and lets the photo be
/// imported, exported and removed from Business Central. A Media field renders as an image
/// but cannot be edited in place, so the photo is managed through actions.
/// </summary>
page 70149 "Candidate Picture Part"
{
    // The photo is mandatory, and the FactBox is the only place it can be added, so
    // the caption says so where the Import action is.
    Caption = 'Candidate Photo (Required)';
    PageType = CardPart;
    ApplicationArea = All;
    SourceTable = "Candidate";
    InsertAllowed = false;
    DeleteAllowed = false;
    LinksAllowed = false;

    layout
    {
        area(Content)
        {
            // Bound to the stored Media field, not the "Picture" FlowField, because a
            // FlowField only mirrors the value and would leave the FactBox empty.
            field(Picture; Rec."Picture Blob")
            {
                ApplicationArea = All;
                ShowCaption = false;
                ToolTip = 'Specifies the photo of the candidate.';
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ImportPicture)
            {
                ApplicationArea = All;
                Caption = 'Import';
                Image = Import;
                ToolTip = 'Upload a photo of the candidate from a file.';

                trigger OnAction()
                begin
                    Rec.ImportPicture();
                    CurrPage.Update(false);
                end;
            }
            action(ExportPicture)
            {
                ApplicationArea = All;
                Caption = 'Export';
                Image = Export;
                Enabled = HasPicture;
                ToolTip = 'Save the photo of the candidate to a file.';

                trigger OnAction()
                begin
                    Rec.ExportPicture();
                end;
            }
            action(DeletePicture)
            {
                ApplicationArea = All;
                Caption = 'Delete';
                Image = Delete;
                Enabled = HasPicture;
                ToolTip = 'Remove the photo of the candidate.';

                trigger OnAction()
                begin
                    Rec.DeletePicture();
                    CurrPage.Update(false);
                end;
            }
        }
    }

    var
        HasPicture: Boolean;

    trigger OnAfterGetCurrRecord()
    begin
        HasPicture := Rec."Picture Blob".HasValue();
    end;
}
