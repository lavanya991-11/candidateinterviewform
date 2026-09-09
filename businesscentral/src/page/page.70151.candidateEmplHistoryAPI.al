/// <summary>
/// Exposes the employment history lines of a candidate as an API sub-page of the candidates entity.
/// </summary>
page 70151 "Candidate Empl. Hist. API"
{
    Caption = 'employmentHistory', Locked = true;
    PageType = API;
    APIPublisher = 'Novasoft';
    APIGroup = 'Novasoft';
    APIVersion = 'v2.0';
    EntityName = 'employmentHistory';
    EntitySetName = 'employmentHistory';
    SourceTable = "Candidate Employment History";
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
                field(employerName; Rec."Employer Name") { }
                field(companyName; Rec."Company Name") { }
                field(position; Rec."Position") { }
                field(department; Rec."Department") { }
                field(fromDate; Rec."From Date") { }
                field(tillDate; Rec."Till Date") { }
                // Derived from the employment period on the table - posting it is ignored.
                field(yearsOfExperience; Rec."Years of Experience") { Editable = false; }
                field(lastModifiedDateTime; Rec.SystemModifiedAt) { Editable = false; }
            }
        }
    }
}
