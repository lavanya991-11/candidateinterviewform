/// <summary>
/// Holds the settings of the candidate registration process.
/// </summary>
table 70124 "Candidate Setup"
{
    Caption = 'Candidate Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Candidate Nos."; Code[20])
        {
            Caption = 'Candidate Nos.';
            TableRelation = "No. Series";
        }
        field(10; "Registration Form URL"; Text[250])
        {
            Caption = 'Registration Form URL';
            ExtendedDatatype = URL;

            trigger OnValidate()
            begin
                "Registration Form URL" := DelChr("Registration Form URL", '<>', ' ');
                if "Registration Form URL" = '' then
                    exit;

                if not (LowerCase("Registration Form URL").StartsWith('https://') or
                        LowerCase("Registration Form URL").StartsWith('http://'))
                then
                    Error(InvalidUrlErr);
            end;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    var
        InvalidUrlErr: Label 'The registration form URL must start with https:// or http://.';
        MissingUrlErr: Label 'Enter the Registration Form URL on the Candidate Setup page before sending a registration link.';

    procedure EnsureRecord()
    begin
        Reset();
        if not Get() then begin
            Init();
            Insert();
        end;
    end;

    /// <summary>
    /// Returns the address of the web application form that registration links point to.
    /// </summary>
    /// <returns>The form URL, without a trailing slash.</returns>
    procedure GetRegistrationFormUrl(): Text
    begin
        if not Get() then
            Init();

        if "Registration Form URL" = '' then
            Error(MissingUrlErr);

        exit("Registration Form URL".TrimEnd('/'));
    end;
}
