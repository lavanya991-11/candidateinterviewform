/// <summary>
/// Uploads and lists the files that a candidate attached to one section of the job application.
/// </summary>
page 70148 "Candidate Attachments Part"
{
    Caption = 'Attachments';
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "Candidate Attachment";
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Files)
            {
                field("File Name"; Rec."File Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the name of the uploaded file.';

                    trigger OnDrillDown()
                    begin
                        Rec.DownloadFile();
                    end;
                }
                field("Description"; Rec."Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies an optional description of the uploaded file.';
                }
                field("File Size (Bytes)"; Rec."File Size (Bytes)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the size of the uploaded file.';
                }
                field("Attached On"; Rec."Attached On")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the file was uploaded.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(AttachFile)
            {
                ApplicationArea = All;
                Caption = 'Browse Files';
                Image = Attach;
                ToolTip = 'Upload a PDF, JPG or PNG file of up to 10 MB.';

                trigger OnAction()
                var
                    CandidateAttachment: Record "Candidate Attachment";
                begin
                    if CandidateAttachment.UploadFile(GetCandidateEntryNo(), GetAttachmentType()) then
                        CurrPage.Update(false);
                end;
            }
            action(DownloadFile)
            {
                ApplicationArea = All;
                Caption = 'Download';
                Image = Download;
                Scope = Repeater;
                ToolTip = 'Download the selected file.';

                trigger OnAction()
                begin
                    Rec.DownloadFile();
                end;
            }
            action(DeleteFile)
            {
                ApplicationArea = All;
                Caption = 'Remove';
                Image = Delete;
                Scope = Repeater;
                ToolTip = 'Remove the selected file.';

                trigger OnAction()
                begin
                    if Rec."Line No." = 0 then
                        exit;
                    if Confirm(DeleteFileQst, false, Rec."File Name") then begin
                        Rec.Delete(true);
                        CurrPage.Update(false);
                    end;
                end;
            }
        }
    }

    var
        DeleteFileQst: Label 'Do you want to remove the file %1?', Comment = '%1 = File Name';

    local procedure GetCandidateEntryNo(): Integer
    begin
        if Rec.GetFilter("Candidate Entry No.") <> '' then
            exit(Rec.GetRangeMin("Candidate Entry No."));
        exit(Rec."Candidate Entry No.");
    end;

    local procedure GetAttachmentType(): Enum "Candidate Attachment Type"
    begin
        if Rec.GetFilter("Attachment Type") <> '' then
            exit(Rec.GetRangeMin("Attachment Type"));
        exit(Rec."Attachment Type");
    end;
}
