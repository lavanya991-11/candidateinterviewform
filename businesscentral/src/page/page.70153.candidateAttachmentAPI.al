/// <summary>
/// Exposes the files that a candidate attached to the job application as an API entity.
/// The file itself is a Blob, which OData publishes as a stream property, so the content
/// is uploaded with a binary PATCH instead of a client callback that Business Central
/// Data Services cannot issue.
/// </summary>
page 70153 "Candidate Attachment API"
{
    Caption = 'candidateAttachments', Locked = true;
    PageType = API;
    APIPublisher = 'Novasoft';
    APIGroup = 'Novasoft';
    APIVersion = 'v2.0';
    EntityName = 'candidateAttachment';
    EntitySetName = 'candidateAttachments';
    SourceTable = "Candidate Attachment";
    DelayedInsert = true;
    ODataKeyFields = SystemId;
    Extensible = false;
    ChangeTrackingAllowed = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(id; Rec.SystemId) { Editable = false; }
                // A top-level entity rather than a sub-page of candidates, so that the
                // stream property sits one segment below the key and the candidate is
                // named in the payload instead of the URL.
                field(candidateEntryNo; Rec."Candidate Entry No.") { }
                field(lineNo; Rec."Line No.") { Editable = false; }
                field(attachmentType; Rec."Attachment Type") { }
                // Validated by the table, which derives the extension and rejects a file
                // type outside PDF, JPG and PNG.
                field(fileName; Rec."File Name") { }
                field(fileExtension; Rec."File Extension") { Editable = false; }
                field(description; Rec."Description") { }
                // Measured by the table when the content is written.
                field(fileSizeBytes; Rec."File Size (Bytes)") { Editable = false; }
                field(attachedOn; Rec."Attached On") { Editable = false; }
                field(attachmentContent; Rec."Attachment") { }
                field(lastModifiedDateTime; Rec.SystemModifiedAt) { Editable = false; }
            }
        }
    }
}
