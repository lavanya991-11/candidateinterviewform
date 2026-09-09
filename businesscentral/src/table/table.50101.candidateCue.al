table 70131 "Candidate Cue"
{
    Caption = 'Candidate Cue';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(3; "Application Date Filter"; Date)
        {
            Caption = 'Application Date Filter';
            FieldClass = FlowFilter;
        }
        field(10; "Total Candidates"; Integer)
        {
            Caption = 'Total Candidates';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = count("Candidate");
        }
        field(11; "Interviews Today"; Integer)
        {
            Caption = 'Interviews Today';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = count("Candidate" where("Interview Date" = field("Date Filter")));
        }
        field(12; "Interviews Scheduled"; Integer)
        {
            Caption = 'Interviews Scheduled';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = count("Candidate" where("Interview Date" = filter(<> 0D)));
        }
        field(13; "Interviews Not Scheduled"; Integer)
        {
            Caption = 'Interviews Not Scheduled';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = count("Candidate" where("Interview Date" = const(0D)));
        }
        field(14; "New Applications"; Integer)
        {
            Caption = 'New Applications';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = count("Candidate" where("Application Date" = field("Application Date Filter")));
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    procedure EnsureRecord()
    begin
        Reset();
        if not Get() then begin
            Init();
            Insert();
        end;
    end;
}
