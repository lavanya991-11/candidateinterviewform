/// <summary>
/// Holds one work or personal reference of a candidate.
/// </summary>
table 70122 "Candidate Reference"
{
    Caption = 'Candidate Reference';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Candidate Entry No."; Integer)
        {
            Caption = 'Candidate Entry No.';
            TableRelation = "Candidate"."Entry No.";
            Editable = false;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            Editable = false;
        }
        field(3; "Reference Name"; Text[100])
        {
            Caption = 'Reference Name';
        }
        field(4; "Email"; Text[80])
        {
            Caption = 'Email';
            ExtendedDatatype = EMail;

            trigger OnValidate()
            var
                MailMgt: Codeunit "Mail Management";
            begin
                if "Email" <> '' then
                    MailMgt.CheckValidEmailAddress("Email");
            end;
        }
        field(5; "Phone No."; Text[30])
        {
            Caption = 'Phone Number';
            ExtendedDatatype = PhoneNo;
        }
        field(6; "Notes"; Text[250])
        {
            Caption = 'Notes';
        }
    }

    keys
    {
        key(PK; "Candidate Entry No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Reference Name", "Email", "Phone No.") { }
    }

    trigger OnInsert()
    var
        CandidateReference: Record "Candidate Reference";
    begin
        if "Line No." = 0 then begin
            CandidateReference.SetRange("Candidate Entry No.", "Candidate Entry No.");
            if CandidateReference.FindLast() then
                "Line No." := CandidateReference."Line No." + 10000
            else
                "Line No." := 10000;
        end;
    end;
}
