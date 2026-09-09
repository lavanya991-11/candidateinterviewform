/// <summary>
/// Holds one previous employment of a candidate.
/// </summary>
table 70121 "Candidate Employment History"
{
    Caption = 'Candidate Employment History';
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
        field(3; "Employer Name"; Text[100])
        {
            Caption = 'Employer Name';
        }
        field(8; "Company Name"; Text[100])
        {
            Caption = 'Company Name';
        }
        field(4; "Position"; Text[100])
        {
            Caption = 'Position';
        }
        field(5; "Department"; Text[100])
        {
            Caption = 'Department';
        }
        field(6; "From Date"; Date)
        {
            Caption = 'From Date';

            trigger OnValidate()
            begin
                CheckDates();
            end;
        }
        field(7; "Till Date"; Date)
        {
            Caption = 'Till Date';

            trigger OnValidate()
            begin
                CheckDates();
            end;
        }
        field(9; "Years of Experience"; Decimal)
        {
            Caption = 'Years of Experience';
            DecimalPlaces = 0 : 2;
            MinValue = 0;
            Editable = false;
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
        fieldgroup(DropDown; "Employer Name", "Company Name", "Position", "From Date", "Till Date", "Years of Experience") { }
    }

    var
        TillBeforeFromErr: Label 'Till Date %1 cannot be earlier than From Date %2.', Comment = '%1 = Till Date, %2 = From Date';

    trigger OnInsert()
    var
        EmploymentHistory: Record "Candidate Employment History";
    begin
        if "Line No." = 0 then begin
            EmploymentHistory.SetRange("Candidate Entry No.", "Candidate Entry No.");
            if EmploymentHistory.FindLast() then
                "Line No." := EmploymentHistory."Line No." + 10000
            else
                "Line No." := 10000;
        end;
    end;

    local procedure CheckDates()
    begin
        if ("From Date" <> 0D) and ("Till Date" <> 0D) and ("Till Date" < "From Date") then
            Error(TillBeforeFromErr, "Till Date", "From Date");
        UpdateYearsOfExperience();
    end;

    /// <summary>
    /// Derives the years of experience from the employment period. An empty Till Date means the
    /// candidate still works there, so the period runs up to today.
    /// </summary>
    local procedure UpdateYearsOfExperience()
    var
        EndDate: Date;
        DaysPerYear: Decimal;
    begin
        DaysPerYear := 365.25;

        if "From Date" = 0D then begin
            "Years of Experience" := 0;
            exit;
        end;

        EndDate := "Till Date";
        if EndDate = 0D then
            EndDate := Today();

        if EndDate < "From Date" then
            "Years of Experience" := 0
        else
            "Years of Experience" := Round((EndDate - "From Date") / DaysPerYear, 0.01);
    end;
}
