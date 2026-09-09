/// <summary>
/// Stores a file that a candidate uploaded with the job application.
/// </summary>
table 70123 "Candidate Attachment"
{
    Caption = 'Candidate Attachment';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Candidate Entry No."; Integer)
        {
            Caption = 'Candidate Entry No.';
            TableRelation = "Candidate"."Entry No.";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            Editable = false;
        }
        field(3; "Attachment Type"; Enum "Candidate Attachment Type")
        {
            Caption = 'Attachment Type';
        }
        field(4; "File Name"; Text[250])
        {
            Caption = 'File Name';

            trigger OnValidate()
            begin
                "File Extension" := CopyStr(GetExtension("File Name"), 1, MaxStrLen("File Extension"));
                CheckFileExtension("File Name");
            end;
        }
        field(5; "File Extension"; Text[30])
        {
            Caption = 'File Extension';
            Editable = false;
        }
        field(6; "File Size (Bytes)"; Integer)
        {
            Caption = 'File Size (Bytes)';
            Editable = false;
            BlankZero = true;
        }
        field(7; "Attached On"; DateTime)
        {
            Caption = 'Attached On';
            Editable = false;
        }
        field(8; "Description"; Text[100])
        {
            Caption = 'Description';
        }
        field(20; "Attachment"; Blob)
        {
            Caption = 'Attachment';
        }
    }

    keys
    {
        key(PK; "Candidate Entry No.", "Line No.")
        {
            Clustered = true;
        }
        key(Type; "Candidate Entry No.", "Attachment Type") { }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "File Name", "Attachment Type") { }
    }

    var
        UploadTitleTxt: Label 'Attach a File';
        FileFilterTxt: Label 'PDF, JPG and PNG Files (*.pdf;*.jpg;*.jpeg;*.png)|*.pdf;*.jpg;*.jpeg;*.png', Comment = 'Locked apart from the description.';
        UnsupportedFileTypeErr: Label 'Only PDF, JPG and PNG files can be attached. The file %1 is not supported.', Comment = '%1 = File Name';
        FileTooLargeErr: Label 'The file %1 is larger than the %2 MB limit.', Comment = '%1 = File Name, %2 = size limit in MB';
        NoAttachmentErr: Label 'There is no file attached to this line.';

    trigger OnInsert()
    var
        CandidateAttachment: Record "Candidate Attachment";
    begin
        if "Line No." = 0 then begin
            CandidateAttachment.SetRange("Candidate Entry No.", "Candidate Entry No.");
            if CandidateAttachment.FindLast() then
                "Line No." := CandidateAttachment."Line No." + 10000
            else
                "Line No." := 10000;
        end;
        if "Attached On" = 0DT then
            "Attached On" := CurrentDateTime();
    end;

    trigger OnModify()
    begin
        UpdateFileSize();
    end;

    /// <summary>
    /// Uploads a file from the client and stores it on a new attachment line for the candidate.
    /// </summary>
    /// <param name="CandidateEntryNo">The candidate that the file belongs to.</param>
    /// <param name="AttachmentType">The section of the application form that the file was uploaded for.</param>
    /// <returns>True when a file was uploaded and stored.</returns>
    procedure UploadFile(CandidateEntryNo: Integer; AttachmentType: Enum "Candidate Attachment Type"): Boolean
    var
        FileInStream: InStream;
        AttachmentOutStream: OutStream;
        FileName: Text;
    begin
        if not UploadIntoStream(UploadTitleTxt, '', FileFilterTxt, FileName, FileInStream) then
            exit(false);

        Init();
        Validate("Candidate Entry No.", CandidateEntryNo);
        Validate("Attachment Type", AttachmentType);
        // Validating the name derives the extension and rejects an unsupported file type.
        Validate("File Name", CopyStr(FileName, 1, MaxStrLen("File Name")));
        Insert(true);

        "Attachment".CreateOutStream(AttachmentOutStream);
        CopyStream(AttachmentOutStream, FileInStream);
        // OnModify records the size and rejects a file over the limit.
        Modify(true);
        exit(true);
    end;

    /// <summary>
    /// Downloads the stored file to the client.
    /// </summary>
    procedure DownloadFile()
    var
        AttachmentInStream: InStream;
        ToFileName: Text;
    begin
        CalcFields("Attachment");
        if not "Attachment".HasValue() then
            Error(NoAttachmentErr);

        "Attachment".CreateInStream(AttachmentInStream);
        ToFileName := "File Name";
        DownloadFromStream(AttachmentInStream, '', '', '', ToFileName);
    end;

    local procedure CheckFileExtension(FileName: Text)
    var
        Extension: Text;
    begin
        Extension := LowerCase(GetExtension(FileName));
        if not (Extension in ['pdf', 'jpg', 'jpeg', 'png']) then
            Error(UnsupportedFileTypeErr, FileName);
    end;

    /// <summary>
    /// Stores the size of the attached file and rejects one that is over the limit.
    /// </summary>
    local procedure UpdateFileSize()
    begin
        // HasValue is already true for a blob that was written in this transaction, so
        // the size is taken without a CalcFields that would read the stored value back
        // over the new content. An uploaded file is therefore always measured here.
        if not "Attachment".HasValue() then
            exit;

        // The error rolls the whole request back, which removes the line that the
        // oversized file was written to.
        if "Attachment".Length() > (MaxFileSizeMb() * 1024 * 1024) then
            Error(FileTooLargeErr, "File Name", MaxFileSizeMb());

        "File Size (Bytes)" := "Attachment".Length();
    end;

    local procedure MaxFileSizeMb(): Integer
    begin
        exit(10);
    end;

    local procedure GetExtension(FileName: Text): Text
    var
        DotPosition: Integer;
        Position: Integer;
    begin
        for Position := StrLen(FileName) downto 1 do
            if FileName[Position] = '.' then begin
                DotPosition := Position;
                break;
            end;
        if DotPosition = 0 then
            exit('');
        exit(CopyStr(FileName, DotPosition + 1));
    end;
}
