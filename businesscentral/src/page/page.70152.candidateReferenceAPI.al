/// <summary>
/// Exposes the references of a candidate as an API sub-page of the candidates entity.
/// </summary>
page 70152 "Candidate Reference API"
{
    Caption = 'candidateReferences', Locked = true;
    PageType = API;
    APIPublisher = 'Novasoft';
    APIGroup = 'Novasoft';
    APIVersion = 'v2.0';
    EntityName = 'candidateReference';
    EntitySetName = 'candidateReferences';
    SourceTable = "Candidate Reference";
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
                // Set by the SubPageLink and read-only on the table - posting it is rejected.
                field(candidateEntryNo; Rec."Candidate Entry No.") { Editable = false; }
                field(lineNo; Rec."Line No.") { Editable = false; }
                field(referenceName; Rec."Reference Name") { }
                field(email; Rec."Email") { }
                field(phoneNo; Rec."Phone No.") { }
                field(notes; Rec."Notes") { }
                field(lastModifiedDateTime; Rec.SystemModifiedAt) { Editable = false; }
            }
        }
    }
}
